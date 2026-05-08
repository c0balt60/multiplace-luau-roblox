--!strict
-- Author: c0balt60
--[[
	DataService.luau
		Loads, replicates, manages player data

	TODO:
		Refactor the overall formatting of Migrations and Check (move to its own module)
		✅ Refactor PlayerAdded & PlayerRemoving functions
		Refactor infinite loop to give play time (don't save the play count in state so often)

]]

-- Services
local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")

-- Packages
local Charm = require("@packages/Charm")
local DocumentService = require("@packages/DocumentService")
local Janitor = require("@packages/Janitor")
local Sift = require("@packages/Sift")

-- Data
local Atoms = require("@common/Store/datastore")
local LevelUtils = require("@common/Util/LevelUtils")
local Migrations = require("@common/Config/Migrations")
local Template = require("@common/Config/Template")

-- Networking
local net = require("@server-net")

-- Types
type Schema = Template.Template

--[=[
    Builds leaderstats for player

    @param player
    @param data

    @return Folder
]=]
local function buildLeaderstats(player: Player, data: Schema): Folder
	local ls = Instance.new("Folder", player)
	ls.Name = "leaderstats"

	local coins = Instance.new("IntValue", ls)
	coins.Name = "Cash"
	coins.Value = if data then data.Cash else 0

	return ls
end

-- Service
local service = {}

function service.init(self: Service)
	-- Create store
	local store = DocumentService.DocumentStore.new({
		dataStore = DataStoreService:GetDataStore("test1"),
		check = Template.check,
		default = Template.Template,
		migrations = Migrations,
		lockSessions = true,
	} :: any) :: DocumentService.DocumentStore<Schema>

	-- Write to service
	self._store = store
	self._documents = {} :: { [number]: DocumentService.Document<Schema> }
	self._connections = {} :: { [number]: Janitor.Janitor }
	self._janitor = Janitor.new()

	-- Networking hooks
	net.Common.UpdateData.On(function(player, data)
		print("Data received: ", player, data)
	end)
end

function service.start(self: Service)
	-- Build document for joining player
	Players.PlayerAdded:Connect(function(player)
		self._connections[player.UserId] = Janitor.new()
		self:_buildDocument(player)
	end)

	-- Deconstruct documents
	Players.PlayerRemoving:Connect(function(player)
		self._connections[player.UserId]:destroy()
		self._connections[player.UserId] = nil
		local document = self:getDocument(player)

		if not document or not document:IsOpen() then return end
		document:Close()
		self._documents[player.UserId] = nil
		Atoms.deletePlayerData(player.UserId)
	end)

	-- Listen for data updates
	Charm.subscribe(Atoms.datastore.players :: () -> Atoms.Players, function(d, prev)
		-- Iterate every player and write data
		for id, data in d do
			local id = tonumber(id) :: number
			local document = self:getDocument(id)
			if not document then continue end

			print("Subscribed: ", data)

			-- Level-up detection
			local prevData = prev and prev[tostring(id)]
			if prevData and LevelUtils.didLevelUp(prevData.Experience, data.Experience) then
				local newLevel = LevelUtils.levelFromXp(data.Experience)
				local plr = Players:GetPlayerByUserId(id)
				if plr then
					self:_onLevelUp(plr, newLevel)
				end
			end

			-- Hydrate document
			document:SetCache(data)

			-- Hydrate ls
			local plr = Players:GetPlayerByUserId(id)
			if not plr then continue end
			self:_hydrateLeaderstats(plr, data)
		end
	end)
end

--[=[
	Builds a new document for the player, caches it internally

	@param player

	@yields
]=]
function service._buildDocument(self: Service, player: Player)
	if self._documents[player.UserId] then return end

	local document = self._store:GetDocument(tostring(player.UserId))
	local result = document:Open()

	-- Check if document opens
	if not result.success and result.reason == "SessionLockedError" then
		document:Steal()
		result = document:Open()
	end

	-- Process document not opening
	if not result.success then
		if result.reason == "BackwardsCompatibilityError" then
			player:Kick(
				"You joined an old server which does not support your saved data."
					.. "Please try joining another server. If this persists, contact a developer."
			)
		end
		if result.reason == "RobloxAPIError" then
			player:Kick("Failed to load data due to a Roblox service issue. Try again later.")
		end
		player:Kick(
			`Failed to load data: {result.reason}. Please screenshot this message and report it to a developer.`
		)
		return
	end

	-- print("Opened player document: ", player, document:GetCache())

	-- Leaderstats
	buildLeaderstats(player, document:GetCache())

	-- Update atom
	Atoms.setPlayerData(player.UserId, document:GetCache())
	self._documents[player.UserId] = document
end

--[=[
	Hydrates the players leaderstats with the given data

	@param data -- The data Schema with which to hydrate the leaderstats
]=]
function service._hydrateLeaderstats(self: Service, player: Player, data: Schema)
	local ls = player:FindFirstChild("leaderstats")
	if not ls or not data then return end

	local coins = ls:FindFirstChild("Coins") :: IntValue
	coins.Value = data.Coins
end

--[=[
	Get document for Player

	@param id -- Player or their corresponding userId

	@return DocumentService.Document<Schema>?
]=]
function service.getDocument(self: Service, id: Player | number): DocumentService.Document<Schema>?
	return self._documents[type(id) == "number" and id or id.UserId]
end

--[=[
	Increments a shallow key by a value or 1
	Should only be used for number values

	@param id -- Players corresponding userId
	@param key
	@param value -- Optional value to increment by
]=]
function service.Increment(self: Service, id: number, key: Template.keys, value: number?)
	Atoms.updatePlayerData(id, function(data)
		if not data[key] then return data end
		return Sift.Dictionary.update(data :: any, key, function(v: number)
			return v + (value or 1)
		end)
	end)
end

--[=[
	Converts the data from key1 to key2, setting key1 to 0

	@param id -- Players corresponding userId
	@param key1
	@param key2
]=]
function service.Convert(self: Service, id: number, key1: Template.keys, key2: Template.keys)
	Atoms.updatePlayerData(id, function(data)
		if not data[key1] or not data[key2] then return data end
		local d1 = data[key1]
		return Sift.Dictionary.merge(data, {
			[key1] = 0,
			[key2] = data[key2] + d1,
		}) :: any
	end)
end

--[=[
	Called whenever a player crosses a level threshold.
	Wire up rewards, network events, or VFX here.

	@param player
	@param newLevel -- the level they just reached
]=]
function service._onLevelUp(self: Service, player: Player, newLevel: number)
	print(`{player.Name} reached level {newLevel}!`)
	-- net.Common.LevelUp.Fire(player, newLevel)
end

type Service = typeof(service)
return service
