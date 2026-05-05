-- Packages
local Bootstrapper = require("@packages/Bootstrapper")
local CharmSync = require("@packages/CharmSync")
local Sift = require("@packages/Sift")

-- Networking
local net = require("@client-net")

-- Load time
local start = tick()

-- Charm sync
local syncer = CharmSync.client({
	atoms = Sift.Dictionary.merge(require("@shared/Store/atoms"), require("@common/Store/atoms")) :: any,
	ignoreUnhydrated = false,
})
net.Common.Charm.Replicate.On(function(payload: CharmSync.SyncPayload)
	syncer:sync(payload)
end)
net.Common.Charm.Init.Fire()

-- Load common controllers
require(script.Parent.Common.loadSequence)()

-- Auto load services
local controller = Bootstrapper.loadChildren(script.Parent.Controllers, Bootstrapper.byName("Controller$")) :: any
-- local common_controller =
-- Bootstrapper.loadChildren(script.Parent.Common.Controllers, Bootstrapper.byName("Controller$")) :: any
-- Init
Bootstrapper.run(controller, "init")
-- Bootstrapper.run(common_controller, "init")

-- Start
Bootstrapper.runConcurrent(controller, "start")
-- Bootstrapper.runConcurrent(common_controller, "start")

-- Bindings
Bootstrapper.bindToHeartbeat(controller, "onUpdate")
-- Bootstrapper.bindToRenderStep(common_controller, "onRender")

-- Finish loading
print("[client] Bootstrapped in ", string.format("%.3f", (tick() - start) * 1000), "ms")
