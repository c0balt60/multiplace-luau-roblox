local Charm = require("@packages/Charm")

-- Types
export type Screens = "main" | "weapons" | "classes"
export type Centers = "items" | "settings" | "teleport" | "quests" | "shop" | nil

-- Screen state
local state = {
	screen = Charm.atom("main") :: Charm.Atom<Screens>,
	center = Charm.atom(nil) :: Charm.Atom<Centers>,
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
