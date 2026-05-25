--!nonstrict
local React = require("@packages/React")

local e = React.createElement

type TriggerProps = {
    onMouseEnter: () -> (),
    onMouseLeave: () -> (),
    onMouseDown: () -> (),
    onMouseUp: () -> (),
    onActivated: () -> (),
}

local function Trigger(props: TriggerProps)
    return e("ImageButton", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1,1),
        Image = "",

        [React.Event.MouseEnter] = props.onMouseEnter,
        [React.Event.MouseLeave] = props.onMouseLeave,
        [React.Event.MouseButton1Down] = props.onMouseDown,
        [React.Event.MouseButton1Up] = props.onMouseUp,
        [React.Event.Activated] = props.onActivated
    })
end

return Trigger
