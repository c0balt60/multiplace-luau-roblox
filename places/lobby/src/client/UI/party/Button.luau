--!nonstrict
local React = require("@packages/React")
local ReactSpring = require("@packages/react_spring")

local useCenter = require("../hooks/useCenter")

local e = React.createElement
local useState = React.useState
local useBinding = React.useBinding
local useEffect = React.useEffect
local useSpring = ReactSpring.useSpring

type ButtonProps = {
	LayoutOrder: number?,
	onClick: () -> (),
}

local function Button(props: ButtonProps)
	return e("Frame", {
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = 0.5,
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(0, 1),
		LayoutOrder = props.LayoutOrder or 1,
	}, {
		UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
			AspectType = Enum.AspectType.ScaleWithParentSize,
			DominantAxis = Enum.DominantAxis.Height,
		}),
		UICorner = e("UICorner", { CornerRadius = UDim.new(0.1, 0) }),
		Label = e("TextLabel", {
			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundTransparency = 1,
			Position = UDim2.fromScale(0, 0.5),
			Size = UDim2.fromScale(1, 0.6),
			FontFace = Font.fromName("FredokaOne", Enum.FontWeight.Bold),
			Text = tostring(props.LayoutOrder) or "1",
			TextColor3 = Color3.new(1, 1, 1),
			TextScaled = true,
		}),
	})
end

return Button
