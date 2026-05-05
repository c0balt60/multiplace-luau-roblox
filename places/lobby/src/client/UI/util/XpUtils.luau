function getNextLevel(xp: number, level: number)
	return math.floor(xp + (1.5 + level / 100))
end

return {
	baseXp = 100,
	getNextLevel = getNextLevel,
}
