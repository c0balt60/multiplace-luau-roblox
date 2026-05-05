local parseArgs = require("./util/parseArgs")
local prepare = require("./util/prepare")

local result = parseArgs.resolve(parseArgs.createParser("prepare", "Prepare a place for sync"))
prepare(result.args)
