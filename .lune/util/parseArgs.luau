local argparse = require("@pkg/argparse")
local process = require("@lune/process")

export type Args = {
	place: string?,
}

export type ParseResult = {
	args: Args,
}

local function createParser(name: string, description: string)
	local parser = argparse()
	parser:name(name)
	parser:description(description)
	parser:option("--place"):default("lobby")
	return parser
end

local function resolve(parser: any): ParseResult
	local args: Args = parser:parse(process.args)

	return { args = args }
end

return { createParser = createParser, resolve = resolve }
