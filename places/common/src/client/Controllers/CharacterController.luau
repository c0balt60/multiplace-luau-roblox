-- Services
local Player = game:GetService("Players").LocalPlayer :: Player

-- Packages
local Signal = require("@packages/Signal")

-- Types
local types = require("@types/types")

-- Controller
local controller = {}

function controller.init(self: Controller)
	-- utils
	self.CharacterAdded = Signal.new() :: Signal.Signal<types.Character>
	self.CharacterRemoving = Signal.new()
	self.HumanoidDied = Signal.new()

	self.character = nil :: types.Character?
	self.playerModule = nil :: types.PlayerModule?
end

function controller.start(self: Controller)
	if Player.Character then self:_characterAdded(Player.Character :: types.Character) end

	--Wait for playerscripts
	self.playerModule = Player.PlayerScripts:WaitForChild("PlayerModule") :: types.PlayerModule

	-- Bind to character
	Player.CharacterAdded:Connect(function(char)
		self:_characterAdded(char :: types.Character)
	end)
	Player.CharacterRemoving:Connect(function(char)
		self:_characterRemoving(char :: types.Character)
	end)
end

--[=[
	Client event for when a character (re)spawns

	@param character Model
]=]
function controller._characterAdded(self: Controller, character: types.Character)
	-- Hook onto humanoid
	local humanoid = character:WaitForChild("Humanoid") :: Humanoid
	if humanoid then humanoid.Died:Connect(function()
		self.HumanoidDied:Fire()
	end) end
	print("SPAWNED CHARACTER")
	self.character = character
	-- Send out signal
	self.CharacterAdded:Fire(character)
end

--[=[
    Client event for when a character is removing

	@param character Model
]=]
function controller._characterRemoving(self: Controller, character: types.Character)
	-- Logic

	self.CharacterRemoving:Fire(character)
end

--[=[
    Freezes the current players character (disables controls)

    @param state - Whether to freeze or unfreeze
]=]
function controller.freezeCharacter(self: Controller, state: boolean)
    if not self.playerModule then return end
    self.playerModule:GetControls()[if state then "Disable" else "Enable"](self.playerModule)
end

type Controller = typeof(controller)
return controller
