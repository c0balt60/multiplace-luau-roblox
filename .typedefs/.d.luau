declare _G: {[any]: any} & {
	__BUILD__: "dev" | "prod",
	__VERBOSE__: number,
	__DEV_TOOLS__: boolean,
	__DEBUG__: boolean,
}