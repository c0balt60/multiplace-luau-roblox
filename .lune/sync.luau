local parseArgs = require("./util/parseArgs")
local sync = require("./util/sync")

local result = parseArgs.resolve(parseArgs.createParser("prepare", "Prepare a place for sync"))
sync(result.args)
