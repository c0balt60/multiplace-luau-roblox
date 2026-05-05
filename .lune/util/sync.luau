local fs = require("@lune/fs")
local process = require("@lune/process")
local task = require("@lune/task")

local log = require("./log")
local prepare = require("./prepare")

local function sync(args: any)
	local place = "places/" .. args.place

	-- Prepare project
	prepare(args)

	log.info("Starting watch mode... :: " .. place)

	-- Start stylua lsp
	task.spawn(function()
		process.exec("stylua", {"--lsp"}, { stdio = "forward" })
	end)

	-- Watch blink
	task.spawn(function()
		process.exec("blink", {
			`net.blink`,
			"--watch",
		}, { stdio = "forward", cwd = place })
	end)

	-- Watch sourcemap
	task.spawn(function()
		process.exec("rojo", {
			"sourcemap",
			`default.project.json`,
			"-o",
			"sourcemap.json",
			"--watch",
		}, { stdio = "forward" })
	end)

	-- Process darklua (place then common)
	task.spawn(function()
		process.exec("darklua", {
			"process",
			"--watch",
			`{place}/src`,
			"out",
			"--config",
			".darklua/dev.darklua.json",
		}, { stdio = "forward" })
	end)
	task.spawn(function()
		process.exec("darklua", {
			"process",
			"--watch",
			`places/common/src`,
			"out/Common",
			"--config",
			".darklua/dev.darklua.json",
		}, { stdio = "forward" })
	end)

	-- Serve rojo
	process.exec("rojo", {
		"serve",
		"out.project.json",
	}, { stdio = "forward" })
end

return sync
