--!nonstrict
local React = require("@packages/React")
local Sift = require("@packages/Sift")

local e = React.createElement

type ButtonProps = {
	native: { any },

	mouseEnter: () -> (),
	mouseLeave: () -> (),
	onClick: () -> (),
}

local function Button(props: ButtonProps)
	return e(
		"ImageButton",
		Sift.Dictionary.merge({
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			Image = "",

			[React.Event.Activated] = function()
				if not props.onClick then return end
				props.onClick()
			end,
			[React.Event.MouseEnter] = props.mouseEnter,
			[React.Event.MouseLeave] = props.mouseLeave,
		}, props.native)
	)
end

return Button
