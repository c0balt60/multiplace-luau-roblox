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

export type ControlModule = {
    GetMoveVector: (self: ControlModule) -> Vector3,
    GetActiveController: (self: ControlModule) -> (),
    Enable: (self: ControlModule, enable: boolean?) -> (),
    Disable: (self: ControlModule) -> (),
} & {[string]: any}

export type PlayerModule = ModuleScript & {
    new: (self: PlayerModule) -> PlayerModule,
    GetCameras: (self: PlayerModule) -> (),
    GetControls: (self: PlayerModule) -> ControlModule,
    GetClickToMoveController: (self: PlayerModule) -> (),
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
