local ReactCharm = require("@packages/ReactCharm")
local screenState = require("../../Atoms/ScreenState")

local function useScreen(): screenState.Screens
	return ReactCharm.useAtom(screenState.state.screen :: any)
end

return useScreen
