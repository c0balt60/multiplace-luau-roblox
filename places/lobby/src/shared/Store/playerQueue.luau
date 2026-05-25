local Charm = require("@packages/Charm")
local Sift = require("@packages/Sift")

-- Types
export type Players = { [number]: { Player }, Max: number }
export type QueueAtom = Charm.Atom<Players>

-- Player queue
local queue = {
	players = Charm.atom({}) :: QueueAtom,
}

--[=[
    Create a queue with initial player

    @param id - The queue slot
    @param max - Max amount of selected players
    @param player - Initial player
]=]
local function createQueue(id: number, max: number, player: Player)
	queue.players(function(state): any
		return Sift.Dictionary.merge(state, { [id] = { player, Max = max } })
	end)
end

--[=[
    Updates an existing queue

    @param id - The queue slot
    @pram update - The updater function
]=]
local function updateQueue(id: number, update: (state: { Player }) -> Players)
	queue.players(function(state): any
		return Sift.Dictionary.merge(state, { [id] = state[id] and update(state[id]) })
	end)
end

--[=[
    Deletes the queue reservation

    @param id - The queue slot
]=]
local function deleteQueue(id: number)
	queue.players(function(state): any
		return Sift.Dictionary.merge(state, { [id] = nil })
	end)
end

return {
	queue = queue,
	createQueue = createQueue,
	updateQueue = updateQueue,
	deleteQueue = deleteQueue,
}
