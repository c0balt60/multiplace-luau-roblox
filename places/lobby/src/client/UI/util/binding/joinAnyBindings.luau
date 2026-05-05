local React = require("@packages/React")

local toBinding = require("./toBinding")

local createBinding, joinBindings = React.createBinding, React.joinBindings

-- Joins a map or array of bindings (or values) into a single binding.
local function joinAnyBindings(bindings)
	local bindingsToMap = {}

	for key, value in pairs(bindings) do
		bindingsToMap[key] = toBinding(value)
	end

	return joinBindings(bindingsToMap)
end

return joinAnyBindings
