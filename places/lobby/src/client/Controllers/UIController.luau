--!nonstrict
-- Services
local Player = game:GetService("Players").LocalPlayer :: Player
local SocialService = game:GetService("SocialService")

-- Packages
local React = require("@packages/React")
local ReactRoblox = require("@packages/react_roblox")
local Sift = require("@packages/Sift")
local TopbarPlus = require("@packages/Topbarplus")

-- Networking
local net = require("@client-net")

-- Import
local CharacterController = require(script.Parent.Parent.Common.Controllers.CharacterController)

-- Atoms
local ScreenState = require("../Atoms/ScreenState")

-- Interfaces
local Hud = require("../UI/hud")
local Overhead = require("../UI/overhead")
local Party = require("../UI/party")

-- Constants
local e = React.createElement

--[=[
    Create a screengui with children
]=]
local function createScreenGui(props: { native: any?, children: React.ReactNode })
	return e("ScreenGui", Sift.Dictionary.merge({}, props.native), props.children)
end

--[=[
	Create a billboardgui with children
]=]
local function createBillboard(props: { any? })
	local bbg = Instance.new("BillboardGui")
	for i, v in props do
		bbg[i] = v
	end
	return bbg
end

-- Controller
local controller = {}

function controller.start(self: Controller)
	local playerGui = Player:WaitForChild("PlayerGui")
	self.playerGui = playerGui
	self.char = CharacterController.character

	CharacterController.CharacterAdded:Connect(function(char)
		self.char = char
		self:buildOverhead()
	end)

	-- Hook queue event
	net.Queue.OpenInterface.On(function()
		ScreenState.setScreen(nil)
		ScreenState.setCenter("party")
	end)
	net.Queue.CloseInterface.On(function()
		ScreenState.setScreen("main")
		ScreenState.setCenter(nil)
	end)

	-- Create root
	local root = ReactRoblox.createRoot(Instance.new("Folder"))
	self.root = root

	self:build()
	self:buildTopbar()
	if self.char then self:buildOverhead() end

	-- Debug
	print("[ui controller] Interface mounted")
end

function controller.buildTopbar(self: Controller)
	-- Invite players
	local invite = TopbarPlus.new() :: any

	invite:setImage("rbxassetid://16967821446")
	invite:setCaption("Invite Friends")
	invite:oneClick(true)
	invite.selected:Connect(function()
		SocialService:PromptGameInvite(Player)
	end)
end

function controller.build(self: Controller)
	-- Render normal
	self.root:render(ReactRoblox.createPortal(
		e(React.Fragment, {}, {
			Interface = e(createScreenGui, { native = { ResetOnSpawn = false } }, {
				Hud = e(Hud, {}),
				Party = e(Party, {}),
			}),
		}),
		self.playerGui
	))
end

function controller.buildOverhead(self: Controller)
	print("Build head ui: ", self.char.Head)

	local bbg = createBillboard({
		Adornee = self.char.Head,
		MaxDistance = 100,
		LightInfluence = 0,
		Size = UDim2.fromScale(8, 2.5),
		StudsOffset = Vector3.new(0, 2, 0),
		Parent = self.playerGui,
	})
	print(bbg)

	local root = ReactRoblox.createRoot(bbg)

	-- Overhead gui
	root:render(ReactRoblox.createPortal(
		e(React.Fragment, {}, {
			Overhead = e(Overhead, {}),
		}),
		bbg
	))
end

type Controller = typeof(controller)
return controller
