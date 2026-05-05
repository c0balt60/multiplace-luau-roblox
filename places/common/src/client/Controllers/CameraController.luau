local RunService = game:GetService("RunService")
-- Packages
local Lerp = require("@common/Util/Lerp").lerp

-- Types
local types = require("@types/types")

-- Vars
local camera = workspace.CurrentCamera

-- Import
local CharacterController = require("./CharacterController")

-- Controller
local controller = {}

function controller.init(self: Controller)
	self._char = nil :: types.Character?
end

function controller.start(self: Controller)
	-- Bind to character
	CharacterController.CharacterAdded:Connect(function(char)
		self._char = char
		self:bindCharacterToCamera(char)
	end)
	CharacterController.CharacterRemoving:Connect(function()
		RunService:UnbindFromRenderStep("CharacterTilt")
	end)
	CharacterController.HumanoidDied:Connect(function()
		RunService:UnbindFromRenderStep("CharacterTilt")
	end)
end

--[=[
    Binds character tilt to camera rotation
]=]
function controller.bindCharacterToCamera(self: Controller, char: types.Character)
	RunService:BindToRenderStep("CharacterTilt", Enum.RenderPriority.Camera.Value - 1, function(dt)
		local rootPart = char.HumanoidRootPart
		if not rootPart then return end

		-- local waist = char.UpperTorso.Waist
		local waist = char.LowerTorso.WaistRigAttachment
		-- local neck = char.Head.Neck
		local neck = char.UpperTorso.NeckRigAttachment
		local neckDefault = char.UpperTorso.NeckAttachment

		-- Vectors
		local cameraLook = camera.CFrame.LookVector
		local rootLook = rootPart.CFrame.LookVector

		-- Pitch
		local pitch = math.asin(cameraLook.Y)

		-- Yaw
		local cameraFlat = Vector3.new(cameraLook.X, 0, cameraLook.Z).Unit
		local rootFlat = Vector3.new(rootLook.X, 0, rootLook.Z).Unit
		local yaw = math.atan2(rootFlat:Cross(cameraFlat).Y, rootFlat:Dot(cameraFlat))

		-- Split
		local torsoTilt = pitch * 0.5
		local headTilt = pitch * 0.5
		local torsoYaw = yaw * 0.3
		local headYaw = yaw * 0.7

		-- Clamp
		torsoYaw = math.clamp(torsoYaw, -math.rad(45), math.rad(45))
		headYaw = math.clamp(headYaw, -math.rad(80), math.rad(80))

		-- Stop if too far
		if yaw <= -math.rad(110) or yaw >= math.rad(110) then
			torsoTilt = 0
			torsoYaw = 0
			headTilt = 0
			headYaw = 0
		end

		-- Smooth
		-- waist.Transform = CFrame.Angles(torsoTilt, torsoYaw, 0)
		-- neck.Transform = CFrame.Angles(headTilt, headYaw, 0)
		waist.CFrame = waist.CFrame:Lerp(CFrame.Angles(torsoTilt, torsoYaw, 0), 0.08 + dt)
		neck.CFrame = neck.CFrame:Lerp(neckDefault.CFrame * CFrame.Angles(headTilt, headYaw, 0), 0.08 + dt)
	end)
end

type Controller = typeof(controller)
return controller
