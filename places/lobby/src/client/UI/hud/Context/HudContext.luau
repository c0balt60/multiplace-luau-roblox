local React = require("@packages/React")
local Sift = require("@packages/Sift")

local e = React.createElement
local useState = React.useState
local useCallback = React.useCallback

export type ContextType = {}

local defaultContext: ContextType = {}

local context = React.createContext(defaultContext)

local function ContextProvider(props: {
	children: React.ReactNode,
})
	-- States

	-- Context
	local contextVal: ContextType = {}

	return e(context.Provider, {
		value = contextVal,
	}, props.children)
end

local function useContext(): ContextType
	return React.useContext(context)
end

return {
	Context = context,
	Provider = ContextProvider,
	useContext = useContext,
}
