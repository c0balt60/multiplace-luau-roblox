local Charm = require("@packages/Charm")
local Sift = require("@packages/Sift")

local Template = require("../Config/Template")

-- Types
export type PlayerData = Template.Template
export type Players = { [string]: PlayerData }
export type PlayersAtom = Charm.Atom<Players>

-- Datastore wrapper
local datastore = {
	default = Sift.Dictionary.copyDeep(Template.Template),
	players = Charm.atom({}) :: PlayersAtom,
}

--[=[
    Returns the players data for id

    @param id - Players id
    @return PlayerData
]=]
local function getPlayerData(id: number)
	return datastore.players()[tostring(id)]
end

--[=[
    Writes data directly to atom

    @param id - Players id to write data for
    @param data - The data to write
]=]
local function setPlayerData(id: number, data: PlayerData)
	local id = tostring(id)
	if not id or not data then return end
	datastore.players(function(state): any
		return Sift.Dictionary.merge(state, { [id] = data })
	end)
end

--[=[
    Writes nil to the data for specific player

    @param id - Players data to delete
]=]
local function deletePlayerData(id: number)
	local id = tostring(id)
	if not id then return end
	datastore.players(function(state): any
		return Sift.Dictionary.merge(state, { [id] = nil })
	end)
end

--[=[
    Updates the existing data for a player
]=]
local function updatePlayerData(id: number, update: (data: PlayerData) -> PlayerData)
	local id = tostring(id)
	if not id then return end
	datastore.players(function(state): any
		return Sift.Dictionary.merge(state, { [id] = state[id] and update(state[id]) })
	end)
end

return {
	datastore = datastore,
	getPlayerData = getPlayerData,
	setPlayerData = setPlayerData,
	deletePlayerData = deletePlayerData,
	updatePlayerData = updatePlayerData,
}
