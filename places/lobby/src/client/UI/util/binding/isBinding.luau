-- Utility type checker
local function isBinding(value)
	return typeof(value) == "table" and value.getValue ~= nil and value.map ~= nil
end

return isBinding
