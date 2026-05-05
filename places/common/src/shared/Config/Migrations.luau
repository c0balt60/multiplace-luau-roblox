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

-- Type import
local template = require("./Template")

export type Migration<T> = {
	backwardsCompatible: boolean,
	migrate: (old: T) -> T,
}

-- Migrations
local m: { Migration<template.Template> } = {

	-- Example migration:
	-- V x -> y
	-- {
	--     backwardsCompatible = true,
	--     migrate = function(old)
	--     end
	-- }
}

return m
