-- Services
local Players = game:GetService("Players")

-- Packages
local Promise = require("@packages/Promise")

-- Networking
local net = require("@server-net")

-- Queue
local Queue = require("@shared/Store/playerQueue")

-- Workspace
local queueParts: Folder = workspace:WaitForChild("QueueParts") :: Folder

--Service
local service = {}

function service.init(self: Service)
	-- Setup
	self.touching = {} :: { BasePart? }
	self.playerTouch = {} :: { [Player]: number }
end
function service.start(self: Service)
	-- Process touch parts
	for _, v: BasePart in queueParts:GetChildren() do
		v.Touched:Connect(function(hit: BasePart)
			local plr = Players:GetPlayerFromCharacter(hit.Parent :: Model)
			if not plr then return end
			if table.find(self.touching, v) then return end

			table.insert(self.touching, v)

			v.Color = Color3.fromRGB(172, 255, 151)

			-- Network
			net.Queue.OpenInterface.Fire(plr)
			net.Common.Character.Freeze.Fire(plr, true)

			self.playerTouch[plr] = tonumber(v.Name)
		end)
		v.TouchEnded:Connect(function(hit: BasePart)
			local plr = Players:GetPlayerFromCharacter(hit.Parent :: Model)
			if not plr then return end
			if not table.find(self.touching, v) then return end

			-- Do a radius check instead of automatically untouching
			if (hit.Position - v.Position).Magnitude < (v.Size.X * 0.5) then return end

			table.remove(self.touching, table.find(self.touching, v))
			v.Color = Color3.fromRGB(163, 162, 165)

			-- Network
			net.Queue.CloseInterface.Fire(plr)
		end)
	end

	-- Hook updating queue
	net.Queue.Create.On(function(player, amount)
		if not self.playerTouch[player] then error("[PartyService] no player found to create party for") end
		Queue.createQueue(self.playerTouch[player], amount, player)
	end)
end

type Service = typeof(service)
return service
