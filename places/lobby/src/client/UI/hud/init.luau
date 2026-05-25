--!nonstrict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require("@packages/React")
local ReactSpring = require("@packages/react_spring")

local CenterButton = require(script.Components.CenterButton)
local Context = require("@self/Context/HudContext")
local ConvertNumber = require("./util/ConvertNumber")
local LeftButton = require(script.Components.LeftButton)
local LeftStat = require(script.Components.LeftStat)
local joinAnyBindings = require("./util/binding/joinAnyBindings")
local screenAtom = require("../Atoms/ScreenState")
local useCenter = require("./hooks/useCenter")
local useData = require("./hooks/useData")
local useScreen = require("./hooks/useScreen")

local e = React.createElement
local useState = React.useState
local useBinding = React.useBinding
local useEffect = React.useEffect
local useSpring = ReactSpring.useSpring

type HudProps = {
	Experience: number?,
	Frame: "main" | "weapons" | "classes",
}

local function HudView(props: HudProps)
	-- Contexts
	local data = useData()
	local context = Context.useContext()
	local screen = props.Frame or useScreen()

	-- States
	local xpHidden, setXpHidden = useState(true)
	local experience, setExperience = useState(props.Experience or data.Experience)

	-- Styles
	local styles = useSpring({
		position = screen == "main" and 0 or 1,

		size_x = UDim2.fromScale((experience or 0) / 1000, 1),
		hide_xp = xpHidden and 1.01 or 1,

		config = { tension = 600, friction = 50 },
	}, { screen, xpHidden, experience })

	local expStyle, expApi = useSpring(function()
		return {
			size_x = UDim2.fromScale((experience or 0) / 1000, 1),

			config = { tension = 600, friction = 50 },
		}
	end, { experience })

	-- Effects
	useEffect(function() -- Update by experience
		if not props.Experience then return end
		expApi.start({
			size_x = UDim2.fromScale(props.Experience / 1000, 1),
		})

		setExperience(props.Experience)
	end, { props.Experience, data.Experience })

	-- useEffect(function()
	-- 	print("rerendring")
	-- end, { props })

	useEffect(function() -- Hide xp bar after timer ends
		local cancel = false
		-- setXpHidden(false)

		if xpHidden then setXpHidden(false) end

		task.delay(2, function()
			if cancel then return end
			setXpHidden(true)
		end)

		return function()
			cancel = true
		end
	end, { props.Experience, data.Experience })

	useEffect(function() -- When data changes
		setExperience(data.experience)
	end, { data })

	return e(React.Fragment, {}, {
		Level = e("Frame", {
			AnchorPoint = Vector2.new(0, 1),
			BackgroundColor3 = Color3.fromRGB(57, 57, 57),
			BorderSizePixel = 0,
			-- Position = UDim2.fromScale(-0.025, 1),
			-- Position = styles.hide_xp:map(function(value: number)
			-- 	return UDim2.fromScale(-0.01, value * 1)
			-- end),
			Position = joinAnyBindings({
				hide_xp = styles.hide_xp,
				pos = styles.position,
			}):map(function(bindings)
				return UDim2.fromScale(-0.01, 1 * bindings.hide_xp + bindings.pos * 0.5)
			end),
			Size = UDim2.fromScale(1.01, 0.01),
		}, {
			Bar = e("Frame", {
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 209, 43),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0, 0.5),
				Size = expStyle.size_x,
			}, {
				UICorner = e("UICorner", { CornerRadius = UDim.new(0.5, 0) }),
			}),

			Header = e("TextLabel", {
				AnchorPoint = Vector2.new(1, 1),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Position = UDim2.fromScale(1, -0.5),
				Size = UDim2.fromScale(0.15, 3),

				FontFace = Font.new(
					"rbxasset://fonts/families/Montserrat.json",
					Enum.FontWeight.Bold,
					Enum.FontStyle.Normal
				),
				-- Text = experience:map(function(xp)
				-- 	return `{xp or 0} / 1000 Xp`
				-- end),
				Text = `{experience or 0} / 1000`,
				TextColor3 = Color3.new(1, 1, 1),
				TextScaled = true,
			}),
		}),

		Left = e("Frame", {
			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundTransparency = 1,
			-- Position = UDim2.fromScale(0.01, 0.5),
			Position = styles.position:map(function(value: number)
				return UDim2.fromScale(0.01 + -0.5 * value, 0.5)
			end),
			Size = UDim2.fromScale(0.2, 0.9),
		}, {
			UIListLayout = e("UIListLayout", {
				Padding = UDim.new(0.02, 0),
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
			}),

			Coins = e(LeftStat, {
				ColorA = Color3.fromRGB(255, 213, 0),
				ColorB = Color3.fromRGB(255, 114, 0),
				Image = "rbxassetid://13249588501",
				Data = ConvertNumber(data.Cash),
				native = {
					LayoutOrder = 1,
				},
			}),

			Gems = e(LeftStat, {
				ColorA = Color3.fromRGB(223, 80, 233),
				ColorB = Color3.fromRGB(160, 60, 255),
				Image = "rbxassetid://6995306743",
				Data = ConvertNumber(data.Gems),
				native = {
					Position = UDim2.fromScale(0, 0.325),
					LayoutOrder = 2,
				},
			}),

			Buttons = e("Frame", {
				AnchorPoint = Vector2.new(0, 1),
				BackgroundTransparency = 1,
				Position = UDim2.fromScale(0, 1),
				Size = UDim2.fromScale(0.7, 0.31),
				LayoutOrder = 3,
			}, {
				UIGridLayout = e("UIGridLayout", {
					CellPadding = UDim2.fromScale(0.045, 0.075),
					CellSize = UDim2.fromScale(0.3, 0.3),
					SortOrder = Enum.SortOrder.LayoutOrder,
				}),

				Settings = e(LeftButton, {
					Name = "Settings",
					Image = "rbxassetid://112793475659442",
					ColorA = Color3.new(1, 1, 1),
					ColorB = Color3.new(1, 1, 1),
					OnClick = function()
						context.setCenterFrame("settings")
					end,
				}),
				Quests = e(LeftButton, {
					Name = "Quests",
					Image = "rbxassetid://112472857612218",
					ColorA = Color3.fromRGB(185, 30, 198),
					ColorB = Color3.fromRGB(93, 88, 234),
					OnClick = function()
						context.setCenterFrame("quests")
					end,
				}),
				Items = e(LeftButton, {
					Name = "Items",
					Image = "rbxassetid://97831922756086",
					ColorA = Color3.fromRGB(100, 201, 255),
					ColorB = Color3.fromRGB(59, 172, 233),
					OnClick = function()
						context.setCenterFrame("items")
					end,
				}),
				Shop = e(LeftButton, {
					Name = "Shop",
					Image = "rbxassetid://132392146641768",
					ColorA = Color3.fromRGB(94, 255, 105),
					ColorB = Color3.fromRGB(111, 245, 120),
					OnClick = function()
						context.setCenterFrame("shop")
					end,
				}),
				Teleport = e(LeftButton, {
					Name = "Teleport",
					Image = "rbxassetid://140588195461379",
					ColorA = Color3.fromRGB(226, 28, 176),
					ColorB = Color3.fromRGB(197, 97, 255),
					OnClick = function()
						context.setCenterFrame("teleport")
					end,
				}),
			}),
		}),

		Boosts = e("Frame", {
			AnchorPoint = Vector2.new(0, 1),
			BackgroundTransparency = 1,
			-- Position = UDim2.fromScale(0.01, 0.5),
			Position = styles.position:map(function(value: number)
				return UDim2.fromScale(0.01 + -0.5 * value, 1)
			end),
			Size = UDim2.fromScale(0.2, 0.2),
			Visible = false,
		}, {
			UIListLayout = e("UIListLayout", {
				Padding = UDim.new(0.02, 0),
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
			}),

			ScrapBoost = e(
				"TextLabel",
				{
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
					BorderSizePixel = 1,
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromScale(0.55, 0.6),
					ZIndex = 2,

					FontFace = Font.new("FredokaOne", Enum.FontWeight.Bold),
					Text = "Scrap Boost: ",
					TextColor3 = Color3.new(1, 1, 1),
					TextScaled = true,
				},
				e("UIStroke", {
					Color = Color3.fromRGB(0, 0, 0),
					StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize,
					Thickness = 0.025,
				})
			),
		}),

		Center = e("Frame", {
			BackgroundTransparency = 1,
			Position = UDim2.fromScale(0, 0),
			Size = UDim2.fromScale(1, 1),
		}, {
			Bottom = e("Frame", {
				AnchorPoint = Vector2.new(0.5, 1),
				BackgroundTransparency = 1,
				Position = styles.position:map(function(value: number)
					return UDim2.fromScale(0.5, 1 + 0.5 * value)
				end),
				Size = UDim2.fromScale(0.5, 0.125),
			}, {
				UIListLayout = e("UIListLayout", {
					Padding = UDim.new(0.025, 0),
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder,
				}),

				Weapons = e(CenterButton, {
					ColorA = Color3.fromRGB(146, 26, 26),
					ColorB = Color3.fromRGB(94, 38, 14),
					Text = "Weapons",
					onClick = function()
						screenAtom.setScreen("weapons")
					end,
				}),
				Play = e(CenterButton, {
					ColorA = Color3.fromRGB(27, 92, 29),
					ColorB = Color3.fromRGB(15, 66, 41),
					Text = "Play",
					native = {
						Size = UDim2.fromScale(0.31, 0.625),
					},
					onClick = function()
						screenAtom.setScreen(nil)
					end,
				}),
				Classes = e(CenterButton, {
					ColorA = Color3.fromRGB(68, 44, 80),
					ColorB = Color3.fromRGB(27, 21, 50),
					Text = "Classes",
					onClick = function()
						screenAtom.setScreen("classes")
					end,
				}),
			}),
		}),
	})
end

local function HudApp(props: HudProps)
	return e(Context.Provider, {}, {
		Hud = e(HudView, props),
	})
end

return HudApp
