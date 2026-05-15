local Charm = require("@packages/Charm")

-- Types
export type Screens = "main" | "weapons" | "classes" | nil
export type Centers = "items" | "settings" | "teleport" | "quests" | "shop" | "party" | nil
export type Screen = Charm.Atom<Screens>
export type Center = Charm.Atom<Centers>

-- Screen state
local state = {
	screen = Charm.atom("main") :: Screen,
	center = Charm.atom(nil) :: Center,
}

--[=[
    Switches the state of the screen
]=]
local function setScreen(new: Screens)
	state.screen(new)
end

--[=[
    Switches the state of the center screen
]=]
local function setCenter(new: Centers)
	state.center(new)
end

return {
	state = state,
	setScreen = setScreen,
	setCenter = setCenter,
}
