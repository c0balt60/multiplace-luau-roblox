local suffixes = {
	"",
	"K",
	"M",
	"B",
	"T",
	"Qa",
	"Qi",
	"Sx",
	"Sp",
	"Oc",
	"No",
	"Dc",
	"Ud",
	"Dd",
	"Td",
	"Qad",
	"Qid",
	"Sxd",
	"Spd",
	"Ocd",
	"Nod",
	"Vg",
	"Uvg",
	"Dvg",
	"Tvg",
	"Qavg",
	"Qivg",
	"Sxvg",
	"Spvg",
	"Ocvg",
	"Novg",
	"Tg",
	"Utg",
	"Dtg",
	"Ttg",
	"Qatg",
	"Qitg",
	"Sxtg",
	"Sptg",
	"Octg",
	"Notg",
	"Qag",
	"DuAG",
	"TeAG",
	"QdAG",
	"QnAG",
	"SxAG",
	"SpAG",
	"OcAG",
	"NvAG",
	"CT",
}

local function convert(value: number): string
	-- assert(value, "Value required for Suffix operation. ")

	for i = 1, #suffixes do
		if tonumber(value) < 10 ^ (i * 3) then
			return math.floor(value / ((10 ^ ((i - 1) * 3)) / 100)) / 100 .. suffixes[i]
		end
	end

	return tostring(value)
end

return convert
