local Players = game:GetService("Players")
local ReactCharm = require("@packages/ReactCharm")
local datastore = require("@common/Store/datastore")

local function useData(): datastore.PlayerData
	return ReactCharm.useAtom(function()
		local data = datastore.getPlayerData(Players.LocalPlayer.UserId)
		return data or datastore.datastore.default
	end)
end

return useData
