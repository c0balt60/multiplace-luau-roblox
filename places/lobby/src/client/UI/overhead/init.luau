local React = require("@packages/React")

local useData = require("./hooks/useData")

local e = React.createElement
local useState = React.useState

type OverheadProps = {}

local function Overhead(props: OverheadProps)
	local state = useState(false)

	-- Context
	-- local data = useData()
	local data = {
		Wins = 200,
		Equipped = {
			Class = "survivor",
		},
	}

	return e("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
	}, {
		UIListLayout = e(
			"UIListLayout",
			{ SortOrder = Enum.SortOrder.LayoutOrder, HorizontalAlignment = Enum.HorizontalAlignment.Center }
		),

		Wins = e("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(0.7, 0.45),
		}, {
			UIListLayout = e("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				HorizontalFlex = Enum.UIFlexAlignment.SpaceEvenly,
				VerticalAlignment = Enum.VerticalAlignment.Center,
			}),
			Icon = e("ImageLabel", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(0.35, 1),
				Image = "rbxassetid://82857133407630",
				ScaleType = Enum.ScaleType.Fit,
			}),
			Header = e("TextLabel", {
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(0.3, 0.75),
				FontFace = Font.fromName("FredokaOne"),
				Text = data.Wins,
				TextColor3 = Color3.fromRGB(223, 200, 41),
				TextScaled = true,
				TextXAlignment = Enum.TextXAlignment.Left,
			}, {
				UIStroke = e("UIStroke", {
					Color = Color3.fromRGB(62, 57, 7),
					StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize,
					Thickness = 0.075,
				}),
			}),
		}),

		Header = e("TextLabel", {
			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(0.6, 0.4),
			FontFace = Font.fromName("FredokaOne"),
			Text = `< {data.Equipped.Class} >`,
			TextColor3 = Color3.fromRGB(161, 165, 182),
			TextScaled = true,
		}, {
			UIStroke = e("UIStroke", {
				Color = Color3.fromRGB(62, 57, 7),
				StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize,
				Thickness = 0.075,
			}),
		}),
	})
end

return Overhead
