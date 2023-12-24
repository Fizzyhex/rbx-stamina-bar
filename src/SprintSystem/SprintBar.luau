--!strict

local TweenService = game:GetService("TweenService")

local smoothTween = TweenInfo.new(0.3, Enum.EasingStyle.Quad)

local DECREASE_LERP_SPEED = 0.1

local COLORS = {
    sprint = Color3.fromRGB(0, 195, 255),
    decreasing = Color3.fromRGB(0, 0, 0),
    exhausted = Color3.fromRGB(255, 207, 104),
}

local function SprintBar()
    local state: string?

    local gui = Instance.new("ScreenGui")
    gui.Name = "SprintBar"

        local frame = Instance.new("Frame")
        frame.Name = "Container"
        frame.Position = UDim2.new(0.5, 0)
        frame.AnchorPoint = Vector2.new(0.5, 0)
        frame.Size = UDim2.fromOffset(300, 4)
        frame.Parent = gui

            local bar = Instance.new("Frame")
            bar.Name = "Bar"
            bar.Size = UDim2.fromScale(1, 1)
            bar.ZIndex = 2
            bar.Parent = frame

            local decreaseBar = Instance.new("Frame")
            decreaseBar.Name = "Decrease Bar"
            decreaseBar.BackgroundColor3 = COLORS.decreasing
            decreaseBar.Size = UDim2.fromScale(1, 1)
            decreaseBar.BorderSizePixel = 0
            decreaseBar.Parent = frame

    local controller = {}
    controller.instance = gui

    local function tweenToColor(newColor: Color3)
        TweenService:Create(bar, smoothTween, {BackgroundColor3 = newColor}):Play()
    end

    function controller:setPercentage(value)
        bar.Size = UDim2.fromScale(value, 1)
    end

    function controller:update(newState: string, deltaTime: number)
        decreaseBar.Size = decreaseBar.Size:Lerp(bar.Size, deltaTime * 60 * DECREASE_LERP_SPEED)
        bar.Visible = bar.AbsoluteSize.X >= 1
        
        if state == newState then
            return
        end

        if newState == "idle" or newState == "sprint" then
            tweenToColor(COLORS.sprint)
        elseif newState == "exhausted" then
            tweenToColor(COLORS.exhausted)
        end
        
        state = newState
    end

    return controller
end

return SprintBar