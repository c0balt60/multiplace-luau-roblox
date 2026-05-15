local React = require("@packages/React")
local ReactRoblox = require("@packages/react_roblox")
local UiLabs = require("@packages/UILabs")

local useScreen = require("../hooks/useScreen")

local component = require("./")
local e = React.createElement

local controls = {
	Xp = UiLabs.Slider(500, 0, 1000, 5),
	Frame = UiLabs.Choose({ "main", "weapons", "classes" }),
	Center = UiLabs.Choose({ "items", "settings", "teleport", "quests", "shop" }),
}

local story = {
	react = React,
	reactRoblox = ReactRoblox,
	controls = controls,
	story = function(props: { controls: { Xp: number, Frame: "classes" | "main" | "weapons", Center: string } })
		-- local screen = useScreen()

		-- Map screen
		-- print(props.controls, screen)
		-- screen(props.controls.Frame)

		return e(component, {
			Experience = props.controls.Xp,
			Frame = props.controls.Frame,
		})
	end,
}

return story
