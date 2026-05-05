-- Packages
local Bootstrapper = require("@packages/Bootstrapper")

return function()
	local sequence = Bootstrapper.loadSequence({
		script.Parent.Services.DataService,
	}) :: { Bootstrapper.LoadedModules }

	-- Run sequence
	Bootstrapper.run(sequence, "init")
	Bootstrapper.runAsync(sequence, "start")

	-- Boot other services
	-- local services = Bootstrapper.loadChildren(script.Parent.Services, Bootstrapper.byName("Service$")) :: any

	-- Run
	-- Bootstrapper.run(services, "init")
	-- Bootstrapper.runConcurrent(services, "start")

	-- Binding
	Bootstrapper.bindToHeartbeat(sequence, "onHeartbeat")
end
