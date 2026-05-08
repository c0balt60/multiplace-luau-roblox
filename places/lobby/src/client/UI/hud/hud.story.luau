local React = require("@packages/React")
local ReactRoblox = require("@packages/react_roblox")
local UiLabs = require("@packages/UILabs")

local component = require("./")
local e = React.createElement

local controls = {
	Xp = UiLabs.Slider(0, 0, 100, 5),
	Frame = UiLabs.Choose({ "main", "weapons", "classes" }),
	Center = UiLabs.Choose({ "items", "settings", "teleport", "quests", "shop" }),
}

local story = {
	react = React,
	reactRoblox = ReactRoblox,
	controls = controls,
	story = function(props: UiLabs.ReactProps)
		return e(component, {
			-- Experience = props.controls.Xp,
			Frame = props.controls.Frame,
		})
	end,
}

return story
