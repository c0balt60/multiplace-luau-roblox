--!nonstrict
local React = require("@packages/React")
local ReactSpring = require("@packages/react_spring")

local net = require("@client-net")

local Button = require(script.Button)
local Trigger = require("./components/Trigger")
local useCenter = require("./hooks/useCenter")

local net = require("@client-net")

local e = React.createElement
local useState = React.useState
local useBinding = React.useBinding
local useEffect = React.useEffect
local useMemo = React.useMemo
local useSpring = ReactSpring.useSpring

type PartyProps = {
	Frame: "party" | string,
}

local function Party(props: PartyProps)
	-- Context
	local center = props.Frame or useCenter()

	-- State
	local size, setSize = useState(nil)

	-- Style
	local styles = useSpring({
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
					Selected = size,
					onClick = function()
						setSize(i)
						print("button: ", i)
						setParty(i)
					end,
				})
			)
		end

		return children
	end, { size })

	return e("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = 0.5,
		Position = styles.position:map(function(value: number)
			return UDim2.fromScale(0.5, 0.5 + 1 * value)
		end),
		Size = UDim2.fromScale(0.5, 0.5),
	}, {
		UICorner = e("UICorner", { CornerRadius = UDim.new(0.025, 0) }),
		-- Exit = e("Frame", {
		-- 	AnchorPoint = Vector2.new(0.5, 0.5),
		-- 	BackgroundColor3 = Color3.new(0, 0, 0),
		-- 	BackgroundTransparency = 0.35,
		-- 	Position = UDim2.fromScale(1, 0),
		-- 	Size = UDim2.fromScale(0.07, 1),
		-- }, {
		-- 	UICorner = e("UICorner", { CornerRadius = UDim.new(0.1, 0) }),
		-- 	UIAspectRatioConstraint = e("UIAspectRatioConstraint"),
		-- 	Icon = e("ImageLabel", {
		-- 		AnchorPoint = Vector2.new(0.5, 0),
		-- 		BackgroundTransparency = 1,
		-- 		Position = UDim2.fromScale(0.5, 0),
		-- 		Size = UDim2.fromScale(0.7, 1),
		-- 		ZIndex = 10,
		-- 		Image = "rbxassetid://10152135063",
		-- 		ScaleType = Enum.ScaleType.Fit,
		-- 	}),
		-- }),
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
		Create = e("TextButton", {
			AnchorPoint = Vector2.new(0.5, 1),
			BackgroundColor3 = Color3.new(0, 0, 0),
			BackgroundTransparency = 0.5,
			Position = UDim2.fromScale(0.5, 0.95),
			Size = UDim2.fromScale(0.225, 0.125),

			FontFace = Font.fromName("FredokaOne"),
			Text = "Create",
			TextColor3 = Color3.new(1, 1, 1),
			TextScaled = true,

			[React.Event.Activated] = function()
				net.Queue.Create.Fire(size)
			end,
		}, {
			UICorner = e("UICorner", { CornerRadius = UDim.new(0.1, 0) }),
			UIPadding = e("UIPadding", {
				PaddingBottom = UDim.new(0.15, 0),
				PaddingTop = UDim.new(0.15, 0),
			}),
		}),
	})
end

return Party
