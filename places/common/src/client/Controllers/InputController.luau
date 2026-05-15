local UserInputService = game:GetService("UserInputService")

-- Types
local types = require("@types/types")

-- Import
local CharacterController = require("./CharacterController")

--Service
local controller = {}

function controller.init(self: Controller)
	self.char = nil :: types.Character?
end
function controller.start(self: Controller)
	-- Bind character
	self.char = CharacterController.character
	CharacterController.CharacterAdded:Connect(function(char)
		self.char = char
	end)
	CharacterController.HumanoidDied:Connect(function()
		self.char = nil
	end)

	UserInputService.InputBegan:Connect(function(input, gp)
		if gp then return end

		if input.KeyCode == Enum.KeyCode.LeftShift then self:_sprint(true) end
	end)
	UserInputService.InputEnded:Connect(function(input, gp)
		if gp then return end

		if input.KeyCode == Enum.KeyCode.LeftShift then self:_sprint(false) end
	end)
end

function controller._sprint(self: Controller, running: boolean)
	print(self.char)
	if not self.char then return end
	self.char.Humanoid.WalkSpeed = running and 27 or 16
end

type Controller = typeof(controller)
return controller
