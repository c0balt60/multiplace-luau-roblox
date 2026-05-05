-- Packages
local Bootstrapper = require("@packages/Bootstrapper")
local CharmSync = require("@packages/CharmSync")
local Sift = require("@packages/Sift")

-- Networking
local net = require("@server-net")

-- Load time
local start = tick()

-- Charm sync
local syncer = CharmSync.server({
	atoms = Sift.Dictionary.merge(require("@shared/Store/atoms"), require("@common/Store/atoms")) :: any,
	preserveHistory = true,
})
syncer:connect(function(player, payload)
	net.Common.Charm.Replicate.Fire(player, payload)
end)
net.Common.Charm.Init.On(function(player)
	syncer:hydrate(player)
end)

-- Load common services
require(script.Parent.Common.loadSequence)()

-- Auto load services
local services = Bootstrapper.loadChildren(script.Parent.Services, Bootstrapper.byName("Service$")) :: any

-- Init
Bootstrapper.run(services, "init")

-- Start
Bootstrapper.runConcurrent(services, "start")

-- Bindings
Bootstrapper.bindToHeartbeat(services, "onUpdate")

-- Finish loading
print("[server] Bootstrapped in ", string.format("%.3f", (tick() - start) * 1000), "ms")
