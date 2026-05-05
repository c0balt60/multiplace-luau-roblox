--!nonstrict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require("@packages/React")
local ReactSpring = require("@packages/react_spring")
local Sift = require("@packages/Sift")

local Context = require("../Context/HudContext")
local useData = require("../../hooks/useData")

local e = React.createElement
local useState = React.useState
local useEffect = React.useEffect
local useSpring = ReactSpring.useSpring

local function Gradient(props)
	return e("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, props.colorA or Color3.fromRGB(150, 214, 233)),
			ColorSequenceKeypoint.new(1, props.colorB or Color3.fromRGB(25, 133, 255)),
		}),
		Rotation = 45,
	})
end

type StatProps = {
	native: { [string]: any }?,

	ColorA: Color3,
	ColorB: Color3,
	Image: string,
	Icon: string,

	Data: string,

	onClick: () -> (),
}

local function Stat(props: StatProps)
	-- States
	local hovered, setHovered = useState(false)
	local pressed, setPressed = useState(false)

	-- Style
	local styles = useSpring({
		scale = if pressed and hovered then 0.975 elseif hovered then 1.1 else 1,

		config = { tension = 800, friction = 20 },
	})

	return e(
		"Frame",
		Sift.Dictionary.merge({
			BackgroundTransparency = 1,
			Position = UDim2.fromScale(0, 0.175),
			Size = UDim2.fromScale(0.75, 0.075),
		}, props.native),
		{
			Purchase = e("Frame", {
				AnchorPoint = Vector2.new(1, 0.5),
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 0,
				Position = UDim2.fromScale(0.975, 0.5),
				Size = UDim2.fromScale(0.15, 1),
				ZIndex = 3,
			}, {
				UIAspectRatio = e("UIAspectRatioConstraint"),
				UIScale = e("UIScale", { Scale = styles.scale }),
				UICorner = e("UICorner", { CornerRadius = UDim.new(0.12, 0) }),
				UIGradient = e(Gradient, { colorA = props.ColorA, colorB = props.ColorB }),

				Trigger = e("ImageButton", {
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1),
					Image = "",
					ZIndex = 100,

					[React.Event.MouseEnter] = function()
						setHovered(true)
					end,
					[React.Event.MouseLeave] = function()
						setHovered(false)
					end,
					[React.Event.MouseButton1Down] = function()
						setPressed(true)
					end,
					[React.Event.MouseButton1Up] = function()
						setPressed(false)
						if props.onClick then props.onClick() end
					end,
				}),

				Outer = e("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1),
					ZIndex = -1,
				}, {
					UICorner = e("UICorner", { CornerRadius = UDim.new(0.08, 0) }),
					UIGradient = e(Gradient, { colorA = props.ColorA, colorB = props.ColorB }),
					UIStroke = e("UIStroke", {
						Color = Color3.fromRGB(0, 0, 0),
						StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize,
						Thickness = 0.045,
					}),
				}),
				Icon = e("ImageLabel", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
					BorderSizePixel = 1,
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromScale(0.6, 0.6),
					Image = "rbxassetid://10971295769",
					ScaleType = Enum.ScaleType.Fit,
				}),
			}),

			Inner = e("Frame", {
				BackgroundColor3 = Color3.fromRGB(16, 16, 16),
				Size = UDim2.fromScale(1, 1),
				ZIndex = 0,
			}, {
				UICorner = e("UICorner", { CornerRadius = UDim.new(0.08, 0) }),
				UIGradient = e(Gradient, { colorA = props.ColorA, colorB = props.ColorB }),
				UIStroke = e("UIStroke", {
					Color = Color3.fromRGB(152, 152, 152),
					StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize,
					Thickness = 0.025,
				}, e(Gradient, { colorA = props.ColorA, colorB = props.ColorB })),
			}),
			Outer = e("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				ZIndex = -1,
			}, {
				UICorner = e("UICorner", { CornerRadius = UDim.new(0.08, 0) }),
				UIGradient = e(Gradient, { colorA = props.ColorA, colorB = props.ColorB }),
				UIStroke = e("UIStroke", {
					Color = Color3.fromRGB(0, 0, 0),
					StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize,
					Thickness = 0.045,
				}),
			}),
			Image = e("ImageLabel", {
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundTransparency = 1,
				BorderSizePixel = 1,
				Position = UDim2.fromScale(0.025, 0.5),
				Size = UDim2.fromScale(0.2, 0.75),
				ZIndex = 5,
				Image = props.Image,
				ScaleType = Enum.ScaleType.Fit,
			}),
			InnerGlow = e("ImageLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				BorderSizePixel = 1,
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(1, 1),
				ZIndex = 3,
				Image = "rbxassetid://98674946710205",
			}, e(Gradient, { colorA = props.ColorA, colorB = props.ColorB })),
			OuterGlow = e("ImageLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				BorderSizePixel = 1,
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(1.5, 1.75),
				ZIndex = -1,
				Image = "rbxassetid://133757130817066",
			}, e(Gradient, { colorA = props.ColorA, colorB = props.ColorB })),
			Data = e(
				"TextLabel",
				{
					AnchorPoint = Vector2.new(0, 0.5),
					BackgroundTransparency = 1,
					BorderSizePixel = 1,
					Position = UDim2.fromScale(0.25, 0.5),
					Size = UDim2.fromScale(0.55, 0.6),
					ZIndex = 2,

					FontFace = Font.new("FredokaOne", Enum.FontWeight.Bold),
					Text = props.Data,
					TextColor3 = Color3.new(1, 1, 1),
					TextScaled = true,
					TextXAlignment = Enum.TextXAlignment.Left,
				},
				e("UIStroke", {
					Color = Color3.fromRGB(0, 0, 0),
					StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize,
					Thickness = 0.025,
				})
			),
		}
	)
end

return Stat
