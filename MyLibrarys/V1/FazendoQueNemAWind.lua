-- // Serviços e Módulos
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

-- // Módulo Principal e Objeto da Janela
local Zyrex = {}
local WindowObject = { _elements = {} }
WindowObject.__index = WindowObject

-- // Configurações de Aparência (Cores, Fontes, Ícones)
local DEFAULTS = {
    Colors = {
        Background = Color3.fromRGB(25, 25, 25),      -- #191919
        TabInactive = Color3.fromRGB(43, 43, 43),    -- #2B2B2B
        TabActive = Color3.fromRGB(60, 60, 60),      -- #3C3C3C
        TextPrimary = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(169, 169, 169) -- #A9A9A9
    },
    Fonts = {
        Title = Enum.Font.GothamSemibold,
        Subtitle = Enum.Font.Gotham,
        Tab = Enum.Font.GothamSemibold,
        Body = Enum.Font.Gotham
    },
    Icons = {
        ["door-open"] = "rbxassetid://6269654939",
        ["default-tab"] = "rbxassetid://2849278925",
        ["empty-face"] = "rbxassetid://5984510721",
        ["minimize"] = "rbxassetid://6031829090",
        ["maximize"] = "rbxassetid://6031825883",
        ["close"] = "rbxassetid://6031824231"
    }
}

-- // Função Principal: CreateWindow
function Zyrex:CreateWindow(options)
    local self = setmetatable({}, WindowObject)
    self.Tabs = {}
    self.ActiveTab = nil
    self.Options = options
    self._dragging = false

    -- 1. GUI Principal
    self.ScreenGui = Instance.new("ScreenGui", Players.LocalPlayer:WaitForChild("PlayerGui"))
    self.ScreenGui.Name = options.Folder or "ZyrexHub"
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.ResetOnSpawn = false

    -- 2. Janela Principal
    self.MainFrame = Instance.new("Frame", self.ScreenGui)
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = options.Size or UDim2.fromOffset(560, 340)
    self.MainFrame.Position = UDim2.new(0.5, -self.MainFrame.AbsoluteSize.X / 2, 0.5, -self.MainFrame.AbsoluteSize.Y / 2)
    self.MainFrame.BackgroundColor3 = DEFAULTS.Colors.Background
    self.MainFrame.BorderSizePixel = 0
    Instance.new("UICorner", self.MainFrame).CornerRadius = UDim.new(0, 8)

    -- 3. Barra de Título
    local titleBar = Instance.new("Frame", self.MainFrame)
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 50)
    titleBar.BackgroundTransparency = 1

    local windowIcon = Instance.new("ImageLabel", titleBar)
    windowIcon.Image = DEFAULTS.Icons[options.Icon] or DEFAULTS.Icons["door-open"]
    windowIcon.Size = UDim2.new(0, 20, 0, 20)
    windowIcon.Position = UDim2.new(0, 15, 0.5, -18)
    windowIcon.BackgroundTransparency = 1
    windowIcon.ImageColor3 = DEFAULTS.Colors.TextSecondary

    local titleLabel = Instance.new("TextLabel", titleBar)
    titleLabel.Text = options.Title or "Zyrex UI"
    titleLabel.Font = DEFAULTS.Fonts.Title
    titleLabel.TextColor3 = DEFAULTS.Colors.TextPrimary
    titleLabel.TextSize = 15
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Position = UDim2.new(0, 45, 0, 6)
    titleLabel.Size = UDim2.new(0, 300, 0, 20)
    titleLabel.BackgroundTransparency = 1

    local subtitleLabel = Instance.new("TextLabel", titleBar)
    subtitleLabel.Text = options.Author or "by Zyrex"
    subtitleLabel.Font = DEFAULTS.Fonts.Subtitle
    subtitleLabel.TextColor3 = DEFAULTS.Colors.TextSecondary
    subtitleLabel.TextSize = 12
    subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    subtitleLabel.Position = UDim2.new(0, 45, 0, 25)
    subtitleLabel.Size = UDim2.new(0, 300, 0, 15)
    subtitleLabel.BackgroundTransparency = 1

    -- 4. Painel de Abas (Esquerda)
    local sideBarWidth = options.SideBarWidth or 170
    self.TabsContainer = Instance.new("Frame", self.MainFrame)
    self.TabsContainer.Size = UDim2.new(0, sideBarWidth, 1, -50)
    self.TabsContainer.Position = UDim2.new(0, 0, 0, 50)
    self.TabsContainer.BackgroundTransparency = 1
    local tabsLayout = Instance.new("UIListLayout", self.TabsContainer)
    tabsLayout.Padding = UDim.new(0, 8)
    tabsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    Instance.new("UIPadding", self.TabsContainer).PaddingTop = UDim.new(0, 10)

    -- 5. Painel de Conteúdo (Direita)
    self.ContentFrame = Instance.new("Frame", self.MainFrame)
    self.ContentFrame.Size = UDim2.new(1, -sideBarWidth, 1, -50)
    self.ContentFrame.Position = UDim2.new(0, sideBarWidth, 0, 50)
    self.ContentFrame.BackgroundTransparency = 1
    self.ContentFrame.ClipsDescendants = true

    -- 6. Mensagem de "Aba Vazia"
    self.EmptyMessage = Instance.new("Frame", self.ContentFrame)
    self.EmptyMessage.Size = UDim2.new(1, 0, 1, 0)
    self.EmptyMessage.BackgroundTransparency = 1
    local emptyIcon = Instance.new("ImageLabel", self.EmptyMessage)
    emptyIcon.Image = DEFAULTS.Icons["empty-face"]
    emptyIcon.Size = UDim2.new(0, 48, 0, 48)
    emptyIcon.Position = UDim2.new(0.5, -24, 0.5, -40)
    emptyIcon.BackgroundTransparency = 1
    emptyIcon.ImageColor3 = Color3.fromRGB(60, 60, 60)
    local emptyText = Instance.new("TextLabel", self.EmptyMessage)
    emptyText.Text = "This tab is empty"
    emptyText.Font = DEFAULTS.Fonts.Body
    emptyText.TextColor3 = Color3.fromRGB(80, 80, 80)
    emptyText.TextSize = 14
    emptyText.Position = UDim2.new(0.5, -100, 0.5, 15)
    emptyText.Size = UDim2.new(0, 200, 0, 20)
    emptyText.BackgroundTransparency = 1

    -- 7. Lógica de Arrastar
    self:_makeDraggable(titleBar)

    return self
end

-- // Funções do Objeto da Janela

function WindowObject:_makeDraggable(frame)
    local dragInput
    local framePosition

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            self._dragging = true
            dragInput = input
            framePosition = self.MainFrame.Position
        end
    end)

    frame.InputEnded:Connect(function(input)
        if input == dragInput then
            self._dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if self._dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragInput.Position
            self.MainFrame.Position = UDim2.new(
                framePosition.X.Scale, framePosition.X.Offset + delta.X,
                framePosition.Y.Scale, framePosition.Y.Offset + delta.Y
            )
        end
    end)
end

function WindowObject:SwitchTab(title)
    if not self.Tabs[title] or self.ActiveTab == title then return end

    if self.ActiveTab and self.Tabs[self.ActiveTab] then
        local oldTab = self.Tabs[self.ActiveTab]
        oldTab.Content.Visible = false
        TweenService:Create(oldTab.Button, TweenInfo.new(0.2), {BackgroundColor3 = DEFAULTS.Colors.TabInactive}):Play()
    end

    local newTab = self.Tabs[title]
    newTab.Content.Visible = true
    newTab.Button.BackgroundColor3 = DEFAULTS.Colors.TabActive
    self.ActiveTab = title

    self.EmptyMessage.Visible = #newTab.Content:GetChildren() <= 1
end

function WindowObject:AddTab(title, icon)
    local tabData = {}

    local tabButton = Instance.new("TextButton")
    tabButton.Name = title
    tabButton.Size = UDim2.new(1, -20, 0, 40)
    tabButton.BackgroundColor3 = DEFAULTS.Colors.TabInactive
    tabButton.Text = ""
    tabButton.Parent = self.TabsContainer
    Instance.new("UICorner", tabButton).CornerRadius = UDim.new(0, 6)

    local tabIcon = Instance.new("ImageLabel", tabButton)
    tabIcon.Image = DEFAULTS.Icons[icon] or DEFAULTS.Icons["default-tab"]
    tabIcon.Size = UDim2.new(0, 20, 0, 20)
    tabIcon.Position = UDim2.new(0, 12, 0.5, -10)
    tabIcon.BackgroundTransparency = 1
    tabIcon.ImageColor3 = DEFAULTS.Colors.TextSecondary

    local tabLabel = Instance.new("TextLabel", tabButton)
    tabLabel.Text = title
    tabLabel.Font = DEFAULTS.Fonts.Tab
    tabLabel.TextColor3 = DEFAULTS.Colors.TextPrimary
    tabLabel.TextSize = 14
    tabLabel.TextXAlignment = Enum.TextXAlignment.Left
    tabLabel.Position = UDim2.new(0, 42, 0, 0)
    tabLabel.Size = UDim2.new(1, -50, 1, 0)
    tabLabel.BackgroundTransparency = 1

    local content = Instance.new("ScrollingFrame", self.ContentFrame)
    content.Name = title .. "Content"
    content.Size = UDim2.new(1, 0, 1, 0)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 4
    content.Visible = false
    local contentLayout = Instance.new("UIListLayout", content)
    contentLayout.Padding = UDim.new(0, 10)
    contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    Instance.new("UIPadding", content).PaddingTop = UDim.new(0, 15)
    Instance.new("UIPadding", content).PaddingLeft = UDim.new(0, 15)
    Instance.new("UIPadding", content).PaddingRight = UDim.new(0, 15)

    tabData.Button = tabButton
    tabData.Content = content
    self.Tabs[title] = tabData

    tabButton.MouseButton1Click:Connect(function() self:SwitchTab(title) end)

    tabButton.MouseEnter:Connect(function()
        if self.ActiveTab ~= title then
            TweenService:Create(tabButton, TweenInfo.new(0.2), {BackgroundColor3 = DEFAULTS.Colors.TabActive}):Play()
        end
    end)
    tabButton.MouseLeave:Connect(function()
        if self.ActiveTab ~= title then
            TweenService:Create(tabButton, TweenInfo.new(0.2), {BackgroundColor3 = DEFAULTS.Colors.TabInactive}):Play()
        end
    end)

    if not self.ActiveTab then self:SwitchTab(title) end

    return tabData
end

-- // Funções para adicionar elementos
function WindowObject:AddButton(tab, text, callback)
    if not tab or not tab.Content then return end
    self.EmptyMessage.Visible = false

    local button = Instance.new("TextButton")
    button.Name = text
    button.Size = UDim2.new(1, 0, 0, 35)
    button.BackgroundColor3 = DEFAULTS.Colors.TabInactive
    button.Text = text
    button.TextColor3 = DEFAULTS.Colors.TextPrimary
    button.Font = DEFAULTS.Fonts.Body
    button.Parent = tab.Content
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)

    button.MouseButton1Click:Connect(function()
        pcall(callback)
    end)
end

function WindowObject:AddToggle(tab, text, callback)
    if not tab or not tab.Content then return end
    self.EmptyMessage.Visible = false
    local state = false

    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, 0, 0, 40)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = tab.Content

    local label = Instance.new("TextLabel", toggleFrame)
    label.Text = text
    label.Font = DEFAULTS.Fonts.Body
    label.TextColor3 = DEFAULTS.Colors.TextPrimary
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1

    local switch = Instance.new("TextButton", toggleFrame)
    switch.Size = UDim2.new(0, 50, 0, 24)
    switch.Position = UDim2.new(1, -50, 0.5, -12)
    switch.BackgroundColor3 = DEFAULTS.Colors.TabInactive
    switch.Text = ""
    Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame", switch)
    knob.Size = UDim2.new(0, 18, 0, 18)
    knob.Position = UDim2.new(0, 4, 0.5, -9)
    knob.BackgroundColor3 = DEFAULTS.Colors.TextSecondary
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    switch.MouseButton1Click:Connect(function()
        state = not state
        local newPos = state and UDim2.new(1, -22, 0.5, -9) or UDim2.new(0, 4, 0.5, -9)
        local newColor = state and Color3.fromRGB(130, 255, 130) or DEFAULTS.Colors.TabInactive
        TweenService:Create(knob, TweenInfo.new(0.2), {Position = newPos}):Play()
        TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = newColor}):Play()
        pcall(callback, state)
    end)
end

return Zyrex
