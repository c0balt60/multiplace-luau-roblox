-- Packages
local Janitor = require("@packages/Janitor")
local Promise = require("@packages/Promise")
local Sift = require("@packages/Sift")

-- Types
local Types = require("@types/types")

-- Util
local Animation = {
	Animations = {},
}

export type LoadedTracks<T> = { [Types.keyOf<T>]: AnimationTrack }

--[=[
	Loads the dictionary of animation ids to the animator.
	Internally stores the animations as a flat map of:

	name/animation name/AnimationTrack

	@param animator
	@param name -- The container name for the animations
	@param ids -- The ids for the container
]=]
function Animation.loadAnimations<T>(
	self: Util,
	animator: Animator,
	name: string,
	ids: T
): Promise.TypedPromise<LoadedTracks<T>>
	return Promise.new(function(resolve, reject)
		if not animator or not ids then reject("Invalid arguments") end

		print(animator, name, ids)

		-- Check local animation cache
		local flat = {}
		local ret = {}

		-- Load animations
		for i, v in ids :: any do
			local a = Instance.new("Animation")
			a.AnimationId = "rbxassetid://" .. v

			local track = animator:LoadAnimation(a)
			flat[`{name}/{i}`] = track
			ret[i] = track
		end

		resolve(ret)
		ret = nil
		self.Animations = Sift.Dictionary.merge(self.Animations, flat) :: any
	end)
end

type Util = typeof(Animation)
return Animation
