--!strict
local CONFIG = {
	BASE_XP = 100, -- XP to go from level 1 → 2
	GROWTH = 50, -- additional XP required per subsequent level
}
-- Cumulative thresholds with defaults:  L1=0  L2=100  L3=250  L4=450  L5=700  L6=1000

--[=[
	Total XP required to *reach* level n.
	Level 1 starts at 0 XP.
]=]
local function xpForLevel(level: number): number
	if level <= 1 then return 0 end
	local k = level - 1
	return CONFIG.BASE_XP * k + CONFIG.GROWTH * k * (k - 1) / 2
end

--[=[
	Current level from a raw XP total.
	Inverts xpForLevel analytically via the quadratic formula — no iteration.
]=]
local function levelFromXp(xp: number): number
	if xp <= 0 then return 1 end
	local a = CONFIG.GROWTH / 2
	local b = CONFIG.BASE_XP - CONFIG.GROWTH / 2
	local k = math.floor((-b + math.sqrt(b * b + 4 * a * xp)) / (2 * a))
	return k + 1
end

-- XP earned within the current level (resets each level-up).
local function xpInLevel(xp: number): number
	return xp - xpForLevel(levelFromXp(xp))
end

-- Total XP span of the current level (the bar maximum).
local function xpRequiredThisLevel(xp: number): number
	local level = levelFromXp(xp)
	return xpForLevel(level + 1) - xpForLevel(level)
end

-- Progress through the current level as 0..1.
local function xpProgress(xp: number): number
	return xpInLevel(xp) / xpRequiredThisLevel(xp)
end

-- XP still needed to reach the next level.
local function xpToNextLevel(xp: number): number
	return xpForLevel(levelFromXp(xp) + 1) - xp
end

-- Returns true if newXp crossed at least one level boundary.
local function didLevelUp(oldXp: number, newXp: number): boolean
	return levelFromXp(newXp) > levelFromXp(oldXp)
end

return {
	CONFIG = CONFIG,
	xpForLevel = xpForLevel,
	levelFromXp = levelFromXp,
	xpInLevel = xpInLevel,
	xpRequiredThisLevel = xpRequiredThisLevel,
	xpProgress = xpProgress,
	xpToNextLevel = xpToNextLevel,
	didLevelUp = didLevelUp,
}
