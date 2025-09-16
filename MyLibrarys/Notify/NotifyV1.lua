-- Opa
-- V1
local function NotifyFunc(Title, Desc, Time, Type)
    local duration = Time or 5
    local titleText = Title or "Notificação"
    local descText = Desc or ""
    local typeKey = Type or "Info"
    local typeMap = {
        Error = { Color = Color3.fromRGB(239, 68, 68), Icon = "X" },
        Warn = { Color = Color3.fromRGB(251, 191, 36), Icon = "!" },
        Success = { Color = Color3.fromRGB(34, 197, 94), Icon = "✓" },
        Info = { Color = Color3.fromRGB(32, 129, 226), Icon = "i" },
        Debug = { Color = Color3.fromRGB(115, 115, 115), Icon = "D" },
        System = { Color = Color3.fromRGB(168, 85, 247), Icon = "S" },
        Custom = { Color = Color3.fromRGB(244, 114, 182), Icon = "*" }
    }
    local typeData = typeMap[typeKey] or typeMap.Info
    local accentColor = typeData.Color
    local iconChar = typeData.Icon
    local textColor = Color3.fromRGB(255, 255, 255)
    local glassColor = Color3.fromRGB(30, 30, 30)

    local coreGui = game:GetService("CoreGui")
    local screenGui = coreGui:FindFirstChild("FluentNotify")
    if not screenGui then
        screenGui = Instance.new("ScreenGui")
        screenGui.Name = "FluentNotify"
        screenGui.ResetOnSpawn = false
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        screenGui.Parent = coreGui
    end

    local existing = {}
    for _, child in ipairs(screenGui:GetChildren()) do
        if child:IsA("Frame") and child.Name:match("^Notify%d+$") then
            local num = tonumber(child.Name:sub(7))
            if num then
                table.insert(existing, {frame = child, num = num})
            end
        end
    end

    table.sort(existing, function(a, b) return a.num < b.num end)

    local nextNum = #existing + 1
    local notifyName = "Notify" .. nextNum

    local offsetY = 30 + (#existing * 76)

    -- Criar frame
    local frame = Instance.new("Frame")
    frame.Name = notifyName
    frame.BackgroundTransparency = 1
    frame.Size = UDim2.new(0, 280, 0, 68)
    frame.Position = UDim2.new(0, -300, 0, offsetY)
    frame.AnchorPoint = Vector2.new(0, 0)
    frame.ZIndex = 20
    frame.Parent = screenGui

    local function repositionAll()
        local currentList = {}
        for _, child in ipairs(screenGui:GetChildren()) do
            if child:IsA("Frame") and child.Name:match("^Notify%d+$") then
                local num = tonumber(child.Name:sub(7))
                if num then
                    table.insert(currentList, {frame = child, num = num})
                end
            end
        end

        table.sort(currentList, function(a, b) return a.num < b.num end)

        for i, data in ipairs(currentList) do
            if data.frame.Parent then
                local targetY = 30 + (i - 1) * 76
                local currentY = data.frame.Position.Y.Offset
                if math.abs(targetY - currentY) > 1 then
                    local tween = game:GetService("TweenService"):Create(data.frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, 24, 0, targetY)})
                    tween:Play()
                end
            end
        end
    end

    frame.AncestryChanged:Connect(function(_, parent)
        if not parent then
            repositionAll()
        end
    end)

    local acrylic = Instance.new("Frame")
    acrylic.BackgroundColor3 = glassColor
    acrylic.BackgroundTransparency = 0.22
    acrylic.Size = UDim2.new(1, 0, 1, 0)
    acrylic.ZIndex = 10
    acrylic.Parent = frame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 14)
    corner.Parent = acrylic

    local innerGlow = Instance.new("Frame")
    innerGlow.BackgroundColor3 = accentColor
    innerGlow.BackgroundTransparency = 0.88
    innerGlow.Size = UDim2.new(1, -4, 1, -4)
    innerGlow.Position = UDim2.new(0, 2, 0, 2)
    innerGlow.ZIndex = 15
    innerGlow.Parent = acrylic

    local innerGlowCorner = Instance.new("UICorner")
    innerGlowCorner.CornerRadius = UDim.new(0, 12)
    innerGlowCorner.Parent = innerGlow
  
    local iconContainer = Instance.new("Frame")
    iconContainer.BackgroundTransparency = 1
    iconContainer.Size = UDim2.new(0, 44, 0, 44)
    iconContainer.Position = UDim2.new(0, 12, 0, 12)
    iconContainer.ZIndex = 20
    iconContainer.Parent = frame

    local iconBg = Instance.new("Frame")
    iconBg.BackgroundColor3 = accentColor
    iconBg.BackgroundTransparency = 0.2
    iconBg.Size = UDim2.new(1, 0, 1, 0)
    iconBg.ZIndex = 19
    iconBg.Parent = iconContainer

    local iconBgCorner = Instance.new("UICorner")
    iconBgCorner.CornerRadius = UDim.new(0, 22)
    iconBgCorner.Parent = iconBg

    local iconInnerShadow = Instance.new("Frame")
    iconInnerShadow.BackgroundColor3 = Color3.new(0, 0, 0)
    iconInnerShadow.BackgroundTransparency = 0.8
    iconInnerShadow.Size = UDim2.new(1, -4, 1, -4)
    iconInnerShadow.Position = UDim2.new(0, 2, 0, 2)
    iconInnerShadow.ZIndex = 20
    iconInnerShadow.Parent = iconBg

    local iconInnerShadowCorner = Instance.new("UICorner")
    iconInnerShadowCorner.CornerRadius = UDim.new(0, 20)
    iconInnerShadowCorner.Parent = iconInnerShadow

    local iconLabel = Instance.new("TextLabel")
    iconLabel.BackgroundTransparency = 1
    iconLabel.Size = UDim2.new(0, 36, 0, 36)
    iconLabel.Position = UDim2.new(0.5, -18, 0.5, -18)
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.TextColor3 = textColor
    iconLabel.TextSize = 26
    iconLabel.TextXAlignment = Enum.TextXAlignment.Center
    iconLabel.TextYAlignment = Enum.TextYAlignment.Center
    iconLabel.ZIndex = 21
    iconLabel.TextTransparency = 1
    iconLabel.Text = iconChar
    iconLabel.Parent = iconContainer

    spawn(function()
        task.wait(0.1)
        local bgTween = game:GetService("TweenService"):Create(iconBg, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.1})
        bgTween:Play()
        local iconTween = game:GetService("TweenService"):Create(iconLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0, Position = UDim2.new(0.5, -20, 0.5, -20), Size = UDim2.new(0, 40, 0, 40)})
        iconTween:Play()
    end)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.BackgroundTransparency = 1
    titleLabel.Size = UDim2.new(0, 180, 0, 20)
    titleLabel.Position = UDim2.new(0, 68, 0, 16)
    titleLabel.Font = Enum.Font.GothamSemibold
    titleLabel.Text = titleText
    titleLabel.TextColor3 = textColor
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
    titleLabel.ZIndex = 20
    titleLabel.Parent = frame

    local descLabel = Instance.new("TextLabel")
    descLabel.BackgroundTransparency = 1
    descLabel.Size = UDim2.new(0, 180, 0, 32)
    descLabel.Position = UDim2.new(0, 68, 0, 36)
    descLabel.Font = Enum.Font.Gotham
    descLabel.Text = descText
    descLabel.TextColor3 = textColor
    descLabel.TextTransparency = 0.75
    descLabel.TextSize = 12
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.TextYAlignment = Enum.TextYAlignment.Top
    descLabel.TextWrapped = true
    descLabel.TextTruncate = Enum.TextTruncate.AtEnd
    descLabel.ZIndex = 20
    descLabel.Parent = frame

    local progressBar = Instance.new("Frame")
    progressBar.BackgroundColor3 = accentColor
    progressBar.BackgroundTransparency = 0.7
    progressBar.BorderSizePixel = 0
    progressBar.Size = UDim2.new(1, -32, 0, 2)
    progressBar.Position = UDim2.new(0, 16, 1, -8)
    progressBar.ZIndex = 20
    progressBar.Parent = frame

    local progressFill = Instance.new("Frame")
    progressFill.BackgroundColor3 = accentColor
    progressFill.BackgroundTransparency = 0.1
    progressFill.Size = UDim2.new(1, 0, 1, 0)
    progressFill.BorderSizePixel = 0
    progressFill.Parent = progressBar

    local progressCorner = Instance.new("UICorner")
    progressCorner.CornerRadius = UDim.new(0, 1)
    progressCorner.Parent = progressFill

    spawn(function()
        local startTime = tick()
        while tick() - startTime < duration and frame and frame.Parent do
            local progress = (tick() - startTime) / duration
            progressFill.Size = UDim2.new(1 - progress, 0, 1, 0)
            task.wait(0.03)
        end
        if frame and frame.Parent then
            local fadeOut = game:GetService("TweenService"):Create(frame, TweenInfo.new(0.25, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {BackgroundTransparency = 1, Size = UDim2.new(0, 260, 0, 60)})
            fadeOut:Play()
            local slideOut = game:GetService("TweenService"):Create(frame, TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {Position = UDim2.new(0, game.Workspace.CurrentCamera.ViewportSize.X + 100, 0, frame.Position.Y.Offset)})
            slideOut:Play()
            fadeOut.Completed:Wait()
            slideOut.Completed:Wait()
            if frame then frame:Destroy() end
        end
    end)

    frame.BackgroundTransparency = 1
    frame.Size = UDim2.new(0, 260, 0, 60)
    local tweenIn = game:GetService("TweenService"):Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {Position = UDim2.new(0, 24, 0, offsetY), Size = UDim2.new(0, 280, 0, 68), BackgroundTransparency = 0})
    tweenIn:Play()
end

local Notify = {}
function Notify:MakeNotify(config)
    if not config or type(config) ~= "table" then return end
    NotifyFunc(config.Title, config.Desc, config.Time, config.Type)
end

return Notify
