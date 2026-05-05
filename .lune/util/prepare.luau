local fs = require("@lune/fs")
local process = require("@lune/process")
local serde = require("@lune/serde")

local build = require("./build")
local log = require("./log")

local function prepare(args: any)
	local place = `places/{args.place}`

	-- Cleanup old out
	if fs.isDir("out") then
		log.info("removing old out")
		fs.removeDir("out")
	end

	-- Cleanup sourcemap
	if fs.isFile("sourcemap.json") then
		log.info("removing sourcemap")
		fs.removeFile("sourcemap.json")
	end

	-- Check place dir
	if not fs.isDir(place) then
		log.error("Incorrect dir path for prepare")
		return
	end

	-- Info
	log.info(`Preparing {place}...`)

	-- Run cli's
	process.exec("rokit", { "install" }, { stdio = "forward" })
	process.exec("pesde", { "install" }, { stdio = "forward" })
	process.exec("blink", { `{place}/net.blink` }, { stdio = "forward" })
	-- process.exec("blink", { `places/common/net.blink` }, { stdio = "forward" })

	-- Refactor luaurc in common
	log.info("Refactoring luaurc in common")
	build.refactorLuaurc("places/common", {
		["server-net"] = `../../{place}/src/server/net`,
		["client-net"] = `../../{place}/src/client/net`,
	})

	-- Generate sourcemap
	log.info("Generating rojo sourcemap")
	build.genRootProject(place)

	process.exec("rojo", {
		"sourcemap",
		`default.project.json`,
		"-o",
		"sourcemap.json",
	}, { stdio = "forward" })

	-- Darklua modify
	log.info("Generating out")
	process.exec("darklua", {
		"process",
		`{place}/src`,
		`out`,
		"--config",
		`.darklua/dev.darklua.json`,
	}, { stdio = "forward" })
	process.exec("darklua", {
		"process",
		`places/common/src`,
		`out/Common`,
		"--config",
		`.darklua/dev.darklua.json`,
	}, { stdio = "forward" })
end

return prepare
