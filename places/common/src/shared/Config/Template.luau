--!nocheck
-- Template
-- Author: c0balt60
--[=[
	Template for players profiles
	@using DocumentService
	@using Blink

		MIGRATION PROCEDURES:
			When create a new value in TEMPLATE:
				1. Update version labels
				2. Add migration to update data (backwards compatible = true)
				3. Update Interface typings
				4. Update Networking typings

			When removing a value from TEMPLATE:
				1. Update version labels
				2. Add migration that removes value (not backwards compatible)
				3. Update all typings

]=]

local t = require("@packages/t")
local types = require("@types/types")

-- Version: 1+
local TEMPLATE = {
	Experience = 0,

	Cash = 0,
	Gems = 0,
	Wins = 0,

	Equipped = {
		Class = "Survivor",
	},
	Inventory = {},
	Settings = {},
}

-- Version: 1
local Interface = t.interface({
	Experience = t.integer,
	Cash = t.integer,
	Gems = t.integer,
	Wins = t.integer,

	Equipped = t.interface({
		Class = t.string,
	}),
	Inventory = t.map(t.string, t.optional(t.any)),
	Settings = t.map(t.string, t.optional(t.any)),
})

export type keys = types.keyOf<typeof(TEMPLATE)>
export type Template = typeof(TEMPLATE) & { [string]: any }

--[=[
	Checks the given t interface
]=]
local function check(val: Template)
	assert(type(val) == "table", "[DataService] Loaded data must be a table type.")
	return Interface(val)
end

return {
	Template = TEMPLATE,
	Interface = Interface,
	check = check,
}
