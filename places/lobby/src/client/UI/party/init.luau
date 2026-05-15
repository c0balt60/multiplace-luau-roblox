--!nonstrict
local React = require("@packages/React")
local ReactSpring = require("@packages/react_spring")

local Button = require(script.Button)
local useCenter = require("./hooks/useCenter")

local e = React.createElement
local useState = React.useState
local useBinding = React.useBinding
local useEffect = React.useEffect
local useMemo = React.useMemo
local useSpring = ReactSpring.useSpring

type PartyProps = {}

local function Party(props: PartyProps)
	-- Context
	local center = useCenter()

	-- Style
	local style = useSpring({
		position = center == "party" and 0 or 1,

		config = { tension = 600, friction = 50 },
	}, { center })

	-- Buttons
	local buttons = useMemo(function()
		local children: { any } = {}

		for i = 1, 5 do
			table.insert(
				children,
				e(Button, {
					LayoutOrder = i,
					onClick = function()
						print("button: ", i)
					end,
				})
			)
		end

		return children
	end)

	return e("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = 0.5,
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(0.5, 0.5),
	}, {
		UICorner = e("UICorner", { CornerRadius = UDim.new(0.025, 0) }),
		Exit = e("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.new(0, 0, 0),
			BackgroundTransparency = 0.35,
			Position = UDim2.fromScale(1, 0),
			Size = UDim2.fromScale(0.07, 1),
		}, {
			UICorner = e("UICorner", { CornerRadius = UDim.new(0.1, 0) }),
			UIAspectRatioConstraint = e("UIAspectRatioConstraint"),
			Icon = e("ImageLabel", {
				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundTransparency = 1,
				Position = UDim2.fromScale(0.5, 0),
				Size = UDim2.fromScale(0.7, 1),
				ZIndex = 10,
				Image = "rbxassetid://10152135063",
				ScaleType = Enum.ScaleType.Fit,
			}),
		}),
		Party = e("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromScale(0.8, 0.25),
		}, {
			UIListLayout = e("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0.05, 0),
			}),

			table.unpack(buttons),
		}),
	})
end

return Party
