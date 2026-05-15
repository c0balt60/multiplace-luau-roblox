local React = require("@packages/React")
local ReactRoblox = require("@packages/react_roblox")
local UiLabs = require("@packages/UILabs")

local component = require("./")
local e = React.createElement

local controls = {}

local story = {
	react = React,
	reactRoblox = ReactRoblox,
	controls = controls,
	story = function(props: UiLabs.ReactProps)
		return e(component)
	end,
}

return story
