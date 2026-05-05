-- Packages
local Bootstrapper = require("@packages/Bootstrapper")
local Sift = require("@packages/Sift")

return function()
	local sequence = {
		script.Parent.Controllers.CharacterController,
	} :: any

	-- Run sequence
	Bootstrapper.run(sequence, "init")
	Bootstrapper.runAsync(sequence, "start")

	-- Boot other controllers
	local controllers = Bootstrapper.loadSequence(
		Sift.Array.differenceSymmetric(sequence, script.Parent.Controllers:GetChildren()),
		Bootstrapper.byName("Controller$")
	) :: any

	-- Run
	Bootstrapper.run(controllers, "init")
	Bootstrapper.runConcurrent(controllers, "start")

	-- Binding
	Bootstrapper.bindToRenderStep(controllers, "onRender")
end
