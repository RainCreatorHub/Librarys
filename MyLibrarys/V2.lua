local MoonLibV2 = {}
MoonLibV2.__index = MoonLibV2

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Themes = {
    Dark = {
        Background = Color3.fromRGB(24, 25, 29),
        Primary = Color3.fromRGB(44, 46, 51),
        Secondary = Color3.fromRGB(62, 64, 70),
        Accent = Color3.fromRGB(88, 101, 242),
        FontColor = Color3.fromRGB(242, 242, 242),
        FontColorSecondary = Color3.fromRGB(180, 180, 180),
        Font = Enum.Font.GothamSemibold,
        CornerRadius = UDim.new(0, 8)
    }
}
Themes.dark = Themes.Dark

function MoonLibV2:MakeWindow(WindowInfo)
    local Theme = Themes[WindowInfo.Theme] or Themes.Dark

    if game:GetService("CoreGui"):FindFirstChild("MoonLibV2_GUI") then
        game:GetService("CoreGui"):FindFirstChild("MoonLibV2_GUI"):Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "MoonLibV2_GUI"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = game:GetService("CoreGui")

    local MainWindow = Instance.new("Frame")
    local WindowObject = {}

    if WindowInfo.LoadScreen then
        local LoadFrame = Instance.new("Frame")
        LoadFrame.Name = "LoadScreen"; LoadFrame.Parent = ScreenGui; LoadFrame.BackgroundColor3 = Theme.Primary; LoadFrame.AnchorPoint = Vector2.new(0.5, 0.5); LoadFrame.Position = UDim2.new(0.5, 0, 0.5, 0); LoadFrame.Size = UDim2.new(0, 300, 0, 100); LoadFrame.ZIndex = 10
        local LoadCorner = Instance.new("UICorner"); LoadCorner.CornerRadius = Theme.CornerRadius; LoadCorner.Parent = LoadFrame
        local LoadTitle = Instance.new("TextLabel"); LoadTitle.Name = "LoadTitle"; LoadTitle.Parent = LoadFrame; LoadTitle.Size = UDim2.new(1, -20, 0, 30); LoadTitle.Position = UDim2.new(0.5, 0, 0, 10); LoadTitle.AnchorPoint = Vector2.new(0.5, 0); LoadTitle.BackgroundTransparency = 1; LoadTitle.Font = Theme.Font; LoadTitle.TextColor3 = Theme.FontColor; LoadTitle.TextSize = 18; LoadTitle.Text = WindowInfo.Name or "Carregando Interface"
        local LoadInfoLabel = Instance.new("TextLabel"); LoadInfoLabel.Name = "LoadInfo"; LoadInfoLabel.Parent = LoadFrame; LoadInfoLabel.Size = UDim2.new(1, -20, 0, 20); LoadInfoLabel.Position = UDim2.new(0.5, 0, 0, 40); LoadInfoLabel.AnchorPoint = Vector2.new(0.5, 0); LoadInfoLabel.BackgroundTransparency = 1; LoadInfoLabel.Font = Enum.Font.Gotham; LoadInfoLabel.TextColor3 = Theme.FontColorSecondary; LoadInfoLabel.TextSize = 14; LoadInfoLabel.Text = WindowInfo.LoadScreenInfo or "Por favor, aguarde..."
        local ProgressBarBG = Instance.new("Frame"); ProgressBarBG.Name = "ProgressBarBG"; ProgressBarBG.Parent = LoadFrame; ProgressBarBG.BackgroundColor3 = Theme.Background; ProgressBarBG.BorderSizePixel = 0; ProgressBarBG.Size = UDim2.new(1, -20, 0, 10); ProgressBarBG.Position = UDim2.new(0.5, 0, 1, -20); ProgressBarBG.AnchorPoint = Vector2.new(0.5, 1)
        local BarCorner = Instance.new("UICorner"); BarCorner.CornerRadius = Theme.CornerRadius; BarCorner.Parent = ProgressBarBG
        local ProgressBar = Instance.new("Frame"); ProgressBar.Name = "ProgressBar"; ProgressBar.Parent = ProgressBarBG; ProgressBar.BackgroundColor3 = Theme.Accent; ProgressBar.BorderSizePixel = 0; ProgressBar.Size = UDim2.new(0, 0, 1, 0)
        local ProgressCorner = Instance.new("UICorner"); ProgressCorner.CornerRadius = Theme.CornerRadius; ProgressCorner.Parent = ProgressBar
        local ProgressTween = TweenService:Create(ProgressBar, TweenInfo.new(1.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)}); ProgressTween:Play()
    end
    
    task.spawn(function()
        MainWindow.Name = "Window"; MainWindow.Parent = ScreenGui; MainWindow.AnchorPoint = Vector2.new(0.5, 0.5); MainWindow.Position = UDim2.new(0.5, 0, 0.5, 0); MainWindow.Size = UDim2.new(0, 540, 0, 380); MainWindow.BackgroundColor3 = Theme.Primary; MainWindow.BorderSizePixel = 0; MainWindow.Active = true; MainWindow.Draggable = true; MainWindow.Visible = false
        local Corner = Instance.new("UICorner"); Corner.CornerRadius = Theme.CornerRadius; Corner.Parent = MainWindow
        local TitleBar = Instance.new("Frame"); TitleBar.Name = "TitleBar"; TitleBar.Parent = MainWindow; TitleBar.Size = UDim2.new(1, 0, 0, 40); TitleBar.Position = UDim2.new(0, 0, 0, 0); TitleBar.BackgroundTransparency = 1
        local TitleLabel = Instance.new("TextLabel"); TitleLabel.Name = "Title"; TitleLabel.Parent = TitleBar; TitleLabel.Size = UDim2.new(1, -80, 1, 0); TitleLabel.Position = UDim2.new(0, 15, 0, 0); TitleLabel.BackgroundTransparency = 1; TitleLabel.Font = Theme.Font; TitleLabel.TextColor3 = Theme.FontColor; TitleLabel.TextSize = 20; TitleLabel.Text = WindowInfo.Name or "Window"; TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        local SubTitleLabel = Instance.new("TextLabel"); SubTitleLabel.Name = "SubTitle"; SubTitleLabel.Parent = MainWindow; SubTitleLabel.Size = UDim2.new(1, -30, 0, 15); SubTitleLabel.Position = UDim2.new(0, 15, 0, 30); SubTitleLabel.BackgroundTransparency = 1; SubTitleLabel.Font = Enum.Font.Gotham; SubTitleLabel.TextColor3 = Theme.FontColorSecondary; SubTitleLabel.TextSize = 14; SubTitleLabel.Text = WindowInfo.SubTitle or ""; SubTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        local SeparatorLine = Instance.new("Frame"); SeparatorLine.Name = "Separator"; SeparatorLine.Parent = MainWindow; SeparatorLine.BackgroundColor3 = Theme.Background; SeparatorLine.BorderSizePixel = 0; SeparatorLine.Size = UDim2.new(1, -30, 0, 2); SeparatorLine.Position = UDim2.new(0.5, 0, 0, 55); SeparatorLine.AnchorPoint = Vector2.new(0.5, 0)
        WindowObject.Frame = MainWindow; WindowObject.Theme = Theme; WindowObject.Tabs = {}
        WindowObject.TabHolder = Instance.new("Frame"); WindowObject.TabHolder.Name = "TabHolder"; WindowObject.TabHolder.Parent = MainWindow; WindowObject.TabHolder.Size = UDim2.new(1, -10, 0, 30); WindowObject.TabHolder.Position = UDim2.new(0, 5, 0, 65); WindowObject.TabHolder.BackgroundTransparency = 1
        local TabLayout = Instance.new("UIListLayout"); TabLayout.Parent = WindowObject.TabHolder; TabLayout.FillDirection = Enum.FillDirection.Horizontal; TabLayout.Padding = UDim.new(0, 5)
        local IsMinimized = false; local OriginalSizeY = MainWindow.Size.Y.Offset
        local CloseButton = Instance.new("TextButton"); CloseButton.Name = "CloseButton"; CloseButton.Parent = TitleBar; CloseButton.Size = UDim2.new(0, 20, 0, 20); CloseButton.Position = UDim2.new(1, -25, 0.5, 0); CloseButton.AnchorPoint = Vector2.new(0.5, 0.5); CloseButton.BackgroundColor3 = Theme.Primary; CloseButton.Text = "X"; CloseButton.Font = Theme.Font; CloseButton.TextColor3 = Theme.FontColor; CloseButton.TextSize = 14
        CloseButton.MouseButton1Click:Connect(function() local tween = TweenService:Create(MainWindow, TweenInfo.new(0.3), {Size = UDim2.fromOffset(0,0), Position = UDim2.fromOffset(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)}); tween:Play(); tween.Completed:Wait(); ScreenGui:Destroy() end)
        local MinimizeButton = Instance.new("TextButton"); MinimizeButton.Name = "MinimizeButton"; MinimizeButton.Parent = TitleBar; MinimizeButton.Size = UDim2.new(0, 20, 0, 20); MinimizeButton.Position = UDim2.new(1, -50, 0.5, 0); MinimizeButton.AnchorPoint = Vector2.new(0.5, 0.5); MinimizeButton.BackgroundColor3 = Theme.Primary; MinimizeButton.Text = "-"; MinimizeButton.Font = Theme.Font; MinimizeButton.TextColor3 = Theme.FontColor; MinimizeButton.TextSize = 20
        MinimizeButton.MouseButton1Click:Connect(function()
            IsMinimized = not IsMinimized
            local targetSize; if IsMinimized then OriginalSizeY = MainWindow.Size.Y.Offset; targetSize = UDim2.new(MainWindow.Size.X.Scale, MainWindow.Size.X.Offset, 0, TitleBar.AbsoluteSize.Y) else targetSize = UDim2.new(MainWindow.Size.X.Scale, MainWindow.Size.X.Offset, 0, OriginalSizeY) end
            TweenService:Create(MainWindow, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = targetSize}):Play(); MinimizeButton.Text = IsMinimized and "+" or "-"; SubTitleLabel.Visible = not IsMinimized; SeparatorLine.Visible = not IsMinimized; WindowObject.TabHolder.Visible = not IsMinimized
            for _, tab in ipairs(WindowObject.Tabs) do local isVisible = not IsMinimized and tab.Button.BackgroundColor3 == Theme.Accent; local targetTransparency = isVisible and 0 or 1; TweenService:Create(tab.Content, TweenInfo.new(0.2), {GroupTransparency = targetTransparency}):Play() end
        end)
        local ResizeHandle = Instance.new("TextButton"); ResizeHandle.Name = "ResizeHandle"; ResizeHandle.Parent = MainWindow; ResizeHandle.Size = UDim2.new(0, 20, 0, 20); ResizeHandle.Position = UDim2.new(1, 0, 1, 0); ResizeHandle.AnchorPoint = Vector2.new(1, 1); ResizeHandle.BackgroundTransparency = 1; ResizeHandle.Text = ""; ResizeHandle.AutoButtonColor = false
        ResizeHandle.MouseButton1Down:Connect(function()
            MainWindow.Draggable = false; local initialMousePos = UserInputService:GetMouseLocation(); local initialSize = MainWindow.AbsoluteSize; local MouseMoveConnection; local MouseUpConnection
            MouseMoveConnection = UserInputService.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then local delta = UserInputService:GetMouseLocation() - initialMousePos; local newSize = initialSize + delta; local minSize = Vector2.new(250, 150); MainWindow.Size = UDim2.new(0, math.max(minSize.X, newSize.X), 0, math.max(minSize.Y, newSize.Y)); if IsMinimized then OriginalSizeY = MainWindow.Size.Y.Offset end end end)
            MouseUpConnection = UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then MainWindow.Draggable = true; if MouseMoveConnection then MouseMoveConnection:Disconnect() end; if MouseUpConnection then MouseUpConnection:Disconnect() end end end)
        end)
    end)

    task.wait(1.5)
    if ScreenGui:FindFirstChild("LoadScreen") then
        local LoadFrame = ScreenGui.LoadScreen; local tweenInfo = TweenInfo.new(0.5)
        TweenService:Create(LoadFrame, tweenInfo, {BackgroundTransparency = 1}):Play()
        for _, child in ipairs(LoadFrame:GetChildren()) do if child:IsA("GuiObject") and child.Name ~= "UICorner" then if child:IsA("TextLabel") then TweenService:Create(child, tweenInfo, {TextTransparency = 1}):Play() else TweenService:Create(child, tweenInfo, {BackgroundTransparency = 1}):Play(); for _, subChild in ipairs(child:GetChildren()) do if subChild:IsA("GuiObject") and subChild.Name ~= "UICorner" then TweenService:Create(subChild, tweenInfo, {BackgroundTransparency = 1}):Play() end end end end end
        task.wait(0.5); LoadFrame:Destroy()
    end
    
    MainWindow.Visible = true; MainWindow.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(MainWindow, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 540, 0, 380)}):Play()

    function WindowObject:MakeTab(TabInfo)
        local TabButton = Instance.new("TextButton"); TabButton.Name = TabInfo.Name; TabButton.Parent = WindowObject.TabHolder; TabButton.Size = UDim2.new(0, 100, 1, 0); TabButton.BackgroundColor3 = Theme.Secondary; TabButton.Text = TabInfo.Name; TabButton.Font = Theme.Font; TabButton.TextColor3 = Theme.FontColor; TabButton.TextSize = 14
        local TabCorner = Instance.new("UICorner"); TabCorner.CornerRadius = Theme.CornerRadius; TabCorner.Parent = TabButton
        
        local TabContent = Instance.new("CanvasGroup")
        TabContent.Name = "Content"; TabContent.Parent = MainWindow; TabContent.Size = UDim2.new(1, -10, 1, -105); TabContent.Position = UDim2.new(0, 5, 0, 100); TabContent.BackgroundTransparency = 1; TabContent.GroupTransparency = 1
        
        local SubTabHolder = Instance.new("Frame"); SubTabHolder.Name = "SubTabHolder"; SubTabHolder.Parent = TabContent; SubTabHolder.Size = UDim2.new(1, 0, 0, 25); SubTabHolder.BackgroundTransparency = 1
        local SubTabLayout = Instance.new("UIListLayout"); SubTabLayout.Parent = SubTabHolder; SubTabLayout.FillDirection = Enum.FillDirection.Horizontal; SubTabLayout.Padding = UDim.new(0, 5)

        local TabObject = {}; TabObject.Button = TabButton; TabObject.Content = TabContent; TabObject.SubTabs = {}; TabObject.SubTabHolder = SubTabHolder; TabObject.HasSubTabs = false

        function TabObject:MakeSubTab(SubTabInfo)
            TabObject.HasSubTabs = true
            local SubTabButton = Instance.new("TextButton"); SubTabButton.Name = SubTabInfo.Name; SubTabButton.Parent = SubTabHolder; SubTabButton.Size = UDim2.new(0, 100, 1, 0); SubTabButton.BackgroundColor3 = Theme.Secondary; SubTabButton.Text = SubTabInfo.Name; SubTabButton.Font = Theme.Font; SubTabButton.TextColor3 = Theme.FontColor; SubTabButton.TextSize = 12
            local SubTabCorner = Instance.new("UICorner"); SubTabCorner.CornerRadius = Theme.CornerRadius; SubTabCorner.Parent = SubTabButton
            
            local SubTabContent = Instance.new("CanvasGroup")
            SubTabContent.Name = "SubContent"; SubTabContent.Parent = TabContent; SubTabContent.Size = UDim2.new(1, 0, 1, -30); SubTabContent.Position = UDim2.new(0, 0, 0, 30); SubTabContent.BackgroundTransparency = 1; SubTabContent.GroupTransparency = 1
            
            local SubTabObject = {Button = SubTabButton, Content = SubTabContent}
            table.insert(TabObject.SubTabs, SubTabObject)
            SubTabButton.MouseButton1Click:Connect(function()
                for _, OtherSubTab in ipairs(TabObject.SubTabs) do TweenService:Create(OtherSubTab.Content, TweenInfo.new(0.2), {GroupTransparency = 1}):Play(); OtherSubTab.Button.BackgroundColor3 = Theme.Secondary end
                TweenService:Create(SubTabContent, TweenInfo.new(0.2), {GroupTransparency = 0}):Play(); SubTabButton.BackgroundColor3 = Theme.Accent
            end)
            return SubTabObject
        end
        
        table.insert(WindowObject.Tabs, TabObject)
        local function OnTabClick()
            if IsMinimized then return end
            for _, OtherTab in ipairs(WindowObject.Tabs) do TweenService:Create(OtherTab.Content, TweenInfo.new(0.2), {GroupTransparency = 1}):Play(); OtherTab.Button.BackgroundColor3 = Theme.Secondary end
            TweenService:Create(TabContent, TweenInfo.new(0.2), {GroupTransparency = 0}):Play(); TabButton.BackgroundColor3 = Theme.Accent
            if TabObject.HasSubTabs and #TabObject.SubTabs > 0 then
                for i, sTab in ipairs(TabObject.SubTabs) do local targetTransparency = (i == 1) and 0 or 1; TweenService:Create(sTab.Content, TweenInfo.new(0.2), {GroupTransparency = targetTransparency}):Play(); sTab.Button.BackgroundColor3 = (i == 1) and Theme.Accent or Theme.Secondary end
            else
                for _, sTab in ipairs(TabObject.SubTabs) do TweenService:Create(sTab.Content, TweenInfo.new(0.2), {GroupTransparency = 1}):Play() end
            end
        end
        TabButton.MouseButton1Click:Connect(OnTabClick)
        if #WindowObject.Tabs == 1 then task.spawn(OnTabClick) end
        return TabObject
    end

    return WindowObject
end

return MoonLibV2
