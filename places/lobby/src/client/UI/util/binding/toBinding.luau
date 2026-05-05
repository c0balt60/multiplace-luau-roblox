local React = require("@packages/React")

local isBinding = require("./isBinding")

local createBinding = React.createBinding

-- Converts a value to a binding. If it's already a binding, return it.
local function toBinding(value)
	if isBinding(value) then
		return value
	else
		local binding, _ = createBinding(value)
		return binding
	end
end

return toBinding
