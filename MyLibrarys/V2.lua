local MoonLibV2 = {}
MoonLibV2.__index = MoonLibV2

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

    if WindowInfo.LoadScreen then
        local LoadFrame = Instance.new("Frame")
        LoadFrame.Name = "LoadScreen"; LoadFrame.Parent = ScreenGui; LoadFrame.BackgroundColor3 = Theme.Background; LoadFrame.Size = UDim2.new(1, 0, 1, 0); LoadFrame.ZIndex = 10
        local LoadLabel = Instance.new("TextLabel")
        LoadLabel.Name = "LoadInfo"; LoadLabel.Parent = LoadFrame; LoadLabel.AnchorPoint = Vector2.new(0.5, 0.5); LoadLabel.Position = UDim2.new(0.5, 0, 0.5, 0); LoadLabel.Size = UDim2.new(0, 400, 0, 50); LoadLabel.BackgroundTransparency = 1; LoadLabel.Font = Theme.Font; LoadLabel.TextColor3 = Theme.FontColor; LoadLabel.TextSize = 22; LoadLabel.Text = WindowInfo.LoadScreenInfo or "Carregando..."
        task.wait(2)
        for i = 1, 10 do LoadFrame.BackgroundTransparency = i / 10; LoadLabel.TextTransparency = i / 10; task.wait(0.05) end
        LoadFrame:Destroy()
    end

    local MainWindow = Instance.new("Frame")
    MainWindow.Name = "Window"; MainWindow.Parent = ScreenGui; MainWindow.AnchorPoint = Vector2.new(0.5, 0.5); MainWindow.Position = UDim2.new(0.5, 0, 0.5, 0); MainWindow.Size = UDim2.new(0, 540, 0, 380); MainWindow.BackgroundColor3 = Theme.Primary; MainWindow.BorderSizePixel = 0; MainWindow.Active = true; MainWindow.Draggable = true
    
    local Corner = Instance.new("UICorner"); Corner.CornerRadius = Theme.CornerRadius; Corner.Parent = MainWindow
    
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"; TitleBar.Parent = MainWindow; TitleBar.Size = UDim2.new(1, 0, 0, 40); TitleBar.Position = UDim2.new(0, 0, 0, 0); TitleBar.BackgroundTransparency = 1
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"; TitleLabel.Parent = TitleBar; TitleLabel.Size = UDim2.new(1, -80, 1, 0); TitleLabel.Position = UDim2.new(0, 15, 0, 0); TitleLabel.BackgroundTransparency = 1; TitleLabel.Font = Theme.Font; TitleLabel.TextColor3 = Theme.FontColor; TitleLabel.TextSize = 20; TitleLabel.Text = WindowInfo.Name or "Window"; TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local SubTitleLabel = Instance.new("TextLabel")
    SubTitleLabel.Name = "SubTitle"; SubTitleLabel.Parent = MainWindow; SubTitleLabel.Size = UDim2.new(1, -30, 0, 15); SubTitleLabel.Position = UDim2.new(0, 15, 0, 30); SubTitleLabel.BackgroundTransparency = 1; SubTitleLabel.Font = Enum.Font.Gotham; SubTitleLabel.TextColor3 = Theme.FontColorSecondary; SubTitleLabel.TextSize = 14; SubTitleLabel.Text = WindowInfo.SubTitle or ""; SubTitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local SeparatorLine = Instance.new("Frame")
    SeparatorLine.Name = "Separator"; SeparatorLine.Parent = MainWindow; SeparatorLine.BackgroundColor3 = Theme.Background; SeparatorLine.BorderSizePixel = 0; SeparatorLine.Size = UDim2.new(1, -30, 0, 2); SeparatorLine.Position = UDim2.new(0.5, 0, 0, 55); SeparatorLine.AnchorPoint = Vector2.new(0.5, 0)
    
    local WindowObject = {}
    WindowObject.Frame = MainWindow; WindowObject.Theme = Theme; WindowObject.Tabs = {}
    
    WindowObject.TabHolder = Instance.new("Frame")
    WindowObject.TabHolder.Name = "TabHolder"; WindowObject.TabHolder.Parent = MainWindow; WindowObject.TabHolder.Size = UDim2.new(1, -10, 0, 30); WindowObject.TabHolder.Position = UDim2.new(0, 5, 0, 65); WindowObject.TabHolder.BackgroundTransparency = 1
    
    local TabLayout = Instance.new("UIListLayout"); TabLayout.Parent = WindowObject.TabHolder; TabLayout.FillDirection = Enum.FillDirection.Horizontal; TabLayout.Padding = UDim.new(0, 5)

    local IsMinimized = false
    local OriginalSizeY = MainWindow.Size.Y.Offset
    
    local CloseButton = Instance.new("TextButton"); CloseButton.Name = "CloseButton"; CloseButton.Parent = TitleBar; CloseButton.Size = UDim2.new(0, 20, 0, 20); CloseButton.Position = UDim2.new(1, -25, 0.5, 0); CloseButton.AnchorPoint = Vector2.new(0.5, 0.5); CloseButton.BackgroundColor3 = Theme.Primary; CloseButton.Text = "X"; CloseButton.Font = Theme.Font; CloseButton.TextColor3 = Theme.FontColor; CloseButton.TextSize = 14
    CloseButton.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

    local MinimizeButton = Instance.new("TextButton"); MinimizeButton.Name = "MinimizeButton"; MinimizeButton.Parent = TitleBar; MinimizeButton.Size = UDim2.new(0, 20, 0, 20); MinimizeButton.Position = UDim2.new(1, -50, 0.5, 0); MinimizeButton.AnchorPoint = Vector2.new(0.5, 0.5); MinimizeButton.BackgroundColor3 = Theme.Primary; MinimizeButton.Text = "-"; MinimizeButton.Font = Theme.Font; MinimizeButton.TextColor3 = Theme.FontColor; MinimizeButton.TextSize = 20
    MinimizeButton.MouseButton1Click:Connect(function()
        IsMinimized = not IsMinimized
        if IsMinimized then
            OriginalSizeY = MainWindow.Size.Y.Offset
            MainWindow.Size = UDim2.new(MainWindow.Size.X.Scale, MainWindow.Size.X.Offset, 0, TitleBar.AbsoluteSize.Y)
            MinimizeButton.Text = "+"
        else
            MainWindow.Size = UDim2.new(MainWindow.Size.X.Scale, MainWindow.Size.X.Offset, 0, OriginalSizeY)
            MinimizeButton.Text = "-"
        end
        SubTitleLabel.Visible = not IsMinimized
        SeparatorLine.Visible = not IsMinimized
        WindowObject.TabHolder.Visible = not IsMinimized
        for _, tab in ipairs(WindowObject.Tabs) do tab.Content.Visible = not IsMinimized and tab.Button.BackgroundColor3 == Theme.Accent end
    end)

    local ResizeHandle = Instance.new("TextButton"); ResizeHandle.Name = "ResizeHandle"; ResizeHandle.Parent = MainWindow; ResizeHandle.Size = UDim2.new(0, 20, 0, 20); ResizeHandle.Position = UDim2.new(1, 0, 1, 0); ResizeHandle.AnchorPoint = Vector2.new(1, 1); ResizeHandle.BackgroundTransparency = 1; ResizeHandle.Text = ""; ResizeHandle.AutoButtonColor = false
    local UserInputService = game:GetService("UserInputService")
    local IsResizing = false
    ResizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            IsResizing = true
            MainWindow.Draggable = false
            local initialMousePos = UserInputService:GetMouseLocation()
            local initialSize = MainWindow.AbsoluteSize
            local moveConnection
            moveConnection = UserInputService.InputChanged:Connect(function(moveInput)
                if not IsResizing then moveConnection:Disconnect() return end
                if moveInput.UserInputType == Enum.UserInputType.MouseMovement or moveInput.UserInputType == Enum.UserInputType.Touch then
                    local currentMousePos = UserInputService:GetMouseLocation()
                    local delta = currentMousePos - initialMousePos
                    local newSize = initialSize + delta
                    local minSize = Vector2.new(250, 150)
                    MainWindow.Size = UDim2.new(0, math.max(minSize.X, newSize.X), 0, math.max(minSize.Y, newSize.Y))
                    if IsMinimized then OriginalSizeY = MainWindow.Size.Y.Offset end
                end
            end)
            local upConnection
            upConnection = UserInputService.InputEnded:Connect(function(upInput)
                if upInput.UserInputType == Enum.UserInputType.MouseButton1 or upInput.UserInputType == Enum.UserInputType.Touch then
                    IsResizing = false
                    MainWindow.Draggable = true
                    moveConnection:Disconnect()
                    upConnection:Disconnect()
                end
            end)
        end
    end)

    function WindowObject:MakeTab(TabInfo)
        local TabButton = Instance.new("TextButton"); TabButton.Name = TabInfo.Name; TabButton.Parent = WindowObject.TabHolder; TabButton.Size = UDim2.new(0, 100, 1, 0); TabButton.BackgroundColor3 = Theme.Secondary; TabButton.Text = TabInfo.Name; TabButton.Font = Theme.Font; TabButton.TextColor3 = Theme.FontColor; TabButton.TextSize = 14
        local TabCorner = Instance.new("UICorner"); TabCorner.CornerRadius = Theme.CornerRadius; TabCorner.Parent = TabButton
        local TabContent = Instance.new("Frame"); TabContent.Name = "Content"; TabContent.Parent = MainWindow; TabContent.Size = UDim2.new(1, -10, 1, -105); TabContent.Position = UDim2.new(0, 5, 0, 100); TabContent.BackgroundTransparency = 1; TabContent.Visible = false
        local SubTabHolder = Instance.new("Frame"); SubTabHolder.Name = "SubTabHolder"; SubTabHolder.Parent = TabContent; SubTabHolder.Size = UDim2.new(1, 0, 0, 25); SubTabHolder.BackgroundTransparency = 1
        local SubTabLayout = Instance.new("UIListLayout"); SubTabLayout.Parent = SubTabHolder; SubTabLayout.FillDirection = Enum.FillDirection.Horizontal; SubTabLayout.Padding = UDim.new(0, 5)
        local TabObject = {}; TabObject.Button = TabButton; TabObject.Content = TabContent; TabObject.SubTabs = {}; TabObject.SubTabHolder = SubTabHolder; TabObject.HasSubTabs = false
        function TabObject:MakeSubTab(SubTabInfo)
            TabObject.HasSubTabs = true
            local SubTabButton = Instance.new("TextButton"); SubTabButton.Name = SubTabInfo.Name; SubTabButton.Parent = SubTabHolder; SubTabButton.Size = UDim2.new(0, 100, 1, 0); SubTabButton.BackgroundColor3 = Theme.Secondary; SubTabButton.Text = SubTabInfo.Name; SubTabButton.Font = Theme.Font; SubTabButton.TextColor3 = Theme.FontColor; SubTabButton.TextSize = 12
            local SubTabCorner = Instance.new("UICorner"); SubTabCorner.CornerRadius = Theme.CornerRadius; SubTabCorner.Parent = SubTabButton
            local SubTabContent = Instance.new("Frame"); SubTabContent.Name = "SubContent"; SubTabContent.Parent = TabContent; SubTabContent.Size = UDim2.new(1, 0, 1, -30); SubTabContent.Position = UDim2.new(0, 0, 0, 30); SubTabContent.BackgroundTransparency = 1; SubTabContent.Visible = false
            local SubTabObject = {Button = SubTabButton, Content = SubTabContent}
            table.insert(TabObject.SubTabs, SubTabObject)
            SubTabButton.MouseButton1Click:Connect(function()
                for _, OtherSubTab in ipairs(TabObject.SubTabs) do OtherSubTab.Content.Visible = false; OtherSubTab.Button.BackgroundColor3 = Theme.Secondary end
                SubTabContent.Visible = true; SubTabButton.BackgroundColor3 = Theme.Accent
            end)
            return SubTabObject
        end
        table.insert(WindowObject.Tabs, TabObject)
        local function OnTabClick()
            if IsMinimized then return end
            for _, OtherTab in ipairs(WindowObject.Tabs) do OtherTab.Content.Visible = false; OtherTab.Button.BackgroundColor3 = Theme.Secondary end
            TabContent.Visible = true; TabButton.BackgroundColor3 = Theme.Accent
            if TabObject.HasSubTabs and #TabObject.SubTabs > 0 then
                for i, sTab in ipairs(TabObject.SubTabs) do sTab.Content.Visible = (i == 1); sTab.Button.BackgroundColor3 = (i == 1) and Theme.Accent or Theme.Secondary end
            end
        end
        TabButton.MouseButton1Click:Connect(OnTabClick)
        if #WindowObject.Tabs == 1 then task.spawn(OnTabClick) end
        return TabObject
    end

    return WindowObject
end

return MoonLibV2
