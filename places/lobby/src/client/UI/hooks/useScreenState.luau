local ReactCharm = require("@packages/ReactCharm")
local screenState = require("../../Atoms/ScreenState")

local function useScreenState()
	return ReactCharm.useAtom(function()
		return screenState
	end) :: typeof(screenState)
end

return useScreenState
