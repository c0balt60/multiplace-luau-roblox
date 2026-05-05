local fs = require("@lune/fs")
local serde = require("@lune/serde")

local log = require("./log")

--[=[
    Recursively normalize filespaths and children of filepath
]=]
local function normalizeNode(node: any)
	if node.filePaths then
		for i, v in node.filePaths do
			node.filePaths[i] = v:gsub("/", "\\")
		end
	end
	if node.children then
		for _, v in node.children do
			normalizeNode(v)
		end
	end
end

--[=[
    Darklua processes paths with \ while rojo generates with /
     Function replaces / with \

    @param sourcemap - Path to sourcemap
]=]
local function normalize(sourcemapPath: string?)
	local sourcemap = serde.decode("json", fs.readFile(sourcemapPath or "sourcemap.json"))

	if not sourcemap then
		log.error(`Sourcemap not located for path: {sourcemap or "./sourcemap"}`)
		return
	end

	-- Normalize
	normalizeNode(sourcemap)

	-- Write
	fs.writeFile(sourcemapPath or "sourcemap.json", serde.encode("json", sourcemap, true))
end

--[=[
	Generate darklua config inside of specific place
	 This is needed because darklua solves the path from where it runs.
]=]
local function genLocalDarklua(place: string)
	-- Create .darklua dir
	if fs.isDir(`{place}/.darklua`) then
		-- fs.writeDir(`{place}/.darklua`)
		log.info("Darklua config already exists in " .. place)
		return
	end

	-- Copy over the .darklua
	fs.copy(".darklua", `{place}/.darklua`)
end

--[=[
	Generates a root project (default.project.json) for the current place
	 This is for luau-lsp
]=]
local function genRootProject(place: string, name: string?)
	local path = `{place}/{name or "default"}.project.json`
	-- local path = `{place}/out.project.json`
	local project = serde.decode("json", fs.readFile(path))

	local tree = { ["$className"] = "DataModel" }

	local function recur(node)
		for n, child in node do
			if type(child) == "table" then
				recur(child)
				continue
			end

			if node["$path"] then
				node["$path"] = `{place}/{node["$path"]}`
				-- print(node["$path"], ": modified")
			end
		end
	end

	for n, node in project.tree do
		if n == "$className" then
			continue
		end
		-- if node["$path"] then
		-- 	node["$path"] = `{place}/{node["$path"]}`
		-- 	print(node["$path"], ": modifying")
		-- end
		recur(node)
		tree[n] = node
	end

	fs.writeFile(
		"default.project.json",
		serde.encode("json", {
			name = "game",
			tree = tree,
		}, true)
	)
end

--[=[
	Copies files from one dir into another
]=]
local function copy(src: string, dest: string)
	for _, v in fs.readDir(src) do
		local srcPath = `{src}/{v}`
		local destPath = `{dest}/{v}`

		print(srcPath, "->", destPath)

		if fs.isDir(srcPath) then
			fs.writeDir(destPath)
			copy(srcPath, destPath)
		else
			if fs.isFile(destPath) then
				--error(`File exists in both? :: {srcPath} , {destPath}`)
				log.warn(`File exists in both dirs: {srcPath} & {destPath}`)
			end
			fs.writeFile(destPath, fs.readFile(srcPath))
		end
	end
end

--[=[
	Builds the place by combining it with common
]=]
local function buildPlace(place: string)
	-- Generate .build
	local build = `build`
	if fs.isDir(build) then
		fs.removeDir(build)
	end
	fs.writeDir(build)

	-- Copy common
	copy("places/common/src", build)

	-- Copy place src
	copy(`{place}/src`, build)
end

--[=[
	Modifies the luaurc to point to project (for blink networking)
]=]
local function refactorLuaurc(place: string, new: { [string]: string })
	local read = serde.decode("json", fs.readFile(`{place}/.luaurc`))

	for i, v in new do
		read.aliases[i] = v
	end

	fs.writeFile(`{place}/.luaurc`, serde.encode("json", read, true))
end

return {
	normalize = normalize,
	normalizeNode = normalizeNode,
	genLocalDarklua = genLocalDarklua,
	genRootProject = genRootProject,

	buildPlace = buildPlace,

	refactorLuaurc = refactorLuaurc,
}
