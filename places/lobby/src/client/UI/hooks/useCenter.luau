local ReactCharm = require("@packages/ReactCharm")
local screenState = require("../../Atoms/ScreenState")

local function useCenter(): screenState.Centers
	return ReactCharm.useAtom(screenState.state.center :: any)
end

return useCenter
