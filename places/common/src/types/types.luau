--!strict
export type Character = Model & {
	Head: BasePart,
	HumanoidRootPart: BasePart,
	Humanoid: Humanoid,
	LowerTorso: BasePart & {
		WaistRigAttachment: Attachment,
	},
	UpperTorso: BasePart & {
		NeckAttachment: Attachment,
		NeckRigAttachment: Attachment,
	},
}

type function keyof(t: type)
	local r = nil
	for i in t:properties() do
		r = if r then types.unionof(r, i) else i
	end
	return if r then r else types.singleton(nil)
end
export type keyOf<T> = keyof<T>

return {}
