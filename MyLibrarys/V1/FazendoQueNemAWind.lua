-- // Serviços e Módulos
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

-- // Módulo Principal e Objetos
local Zyrex = {}
local WindowObject = {}
WindowObject.__index = WindowObject

-- // Configurações de Aparência (Cores, Fontes, Ícones)
local DEFAULTS = {
    Colors = {
        Background = Color3.fromRGB(28, 28, 28),      -- #1C1C1C
        ContentBG = Color3.fromRGB(28, 28, 28),      -- Fundo da área de conteúdo
        TabInactive = Color3.fromRGB(45, 45, 45),    -- #2D2D2D
        TabActive = Color3.fromRGB(60, 60, 60),      -- #3C3C3C
        TextPrimary = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(180, 180, 180),
        TextPlaceholder = Color3.fromRGB(120, 120, 120)
    },
    Fonts = {
        Title = Enum.Font.GothamSemibold,
        Subtitle = Enum.Font.Gotham,
        Tab = Enum.Font.Gotham,
        Body = Enum.Font.Gotham
    },
    Icons = {
        -- Mapeamento de nomes para IDs de assets (Feather Icons)
        ["window"] = "rbxassetid://6269654939",
        ["tab"] = "rbxassetid://2849278925",
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
    self.MainFrame.Size = options.Size or UDim2.fromOffset(580, 380)
    self.MainFrame.Position = UDim2.new(0.5, -self.MainFrame.AbsoluteSize.X / 2, 0.5, -self.MainFrame.AbsoluteSize.Y / 2)
    self.MainFrame.BackgroundColor3 = DEFAULTS.Colors.Background
    self.MainFrame.BorderSizePixel = 0
    Instance.new("UICorner", self.MainFrame).CornerRadius = UDim.new(0, 8)

    -- 3. Barra de Título
    local titleBar = Instance.new("Frame", self.MainFrame)
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 55)
    titleBar.BackgroundTransparency = 1

    local windowIcon = Instance.new("ImageLabel", titleBar)
    windowIcon.Image = DEFAULTS.Icons[options.Icon] or DEFAULTS.Icons["window"]
    windowIcon.Size = UDim2.new(0, 20, 0, 20)
    windowIcon.Position = UDim2.new(0, 18, 0.5, -18)
    windowIcon.BackgroundTransparency = 1
    windowIcon.ImageColor3 = DEFAULTS.Colors.TextSecondary

    local titleLabel = Instance.new("TextLabel", titleBar)
    titleLabel.Text = options.Title or "Zyrex UI"
    titleLabel.Font = DEFAULTS.Fonts.Title
    titleLabel.TextColor3 = DEFAULTS.Colors.TextPrimary
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Position = UDim2.new(0, 50, 0, 8)
    titleLabel.Size = UDim2.new(0, 300, 0, 20)
    titleLabel.BackgroundTransparency = 1

    local subtitleLabel = Instance.new("TextLabel", titleBar)
    subtitleLabel.Text = options.Author or "by Zyrex"
    subtitleLabel.Font = DEFAULTS.Fonts.Subtitle
    subtitleLabel.TextColor3 = DEFAULTS.Colors.TextSecondary
    subtitleLabel.TextSize = 13
    subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    subtitleLabel.Position = UDim2.new(0, 50, 0, 28)
    subtitleLabel.Size = UDim2.new(0, 300, 0, 15)
    subtitleLabel.BackgroundTransparency = 1
    
    -- Botões de Ação da Janela
    local actionButtons = Instance.new("Frame", titleBar)
    actionButtons.Size = UDim2.new(0, 100, 0, 20)
    actionButtons.Position = UDim2.new(1, -110, 0, 10)
    actionButtons.BackgroundTransparency = 1
    local actionsLayout = Instance.new("UIListLayout", actionButtons)
    actionsLayout.FillDirection = Enum.FillDirection.Horizontal
    actionsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    actionsLayout.Padding = UDim.new(0, 8)

    local closeBtn = Instance.new("ImageButton", actionButtons)
    closeBtn.Image = DEFAULTS.Icons.close
    closeBtn.Size = UDim2.new(0, 16, 0, 16)
    closeBtn.BackgroundTransparency = 1
    closeBtn.ImageColor3 = DEFAULTS.Colors.TextSecondary
    closeBtn.MouseButton1Click:Connect(function() self.ScreenGui:Destroy() end)

    local maxBtn = Instance.new("ImageButton", actionButtons)
    maxBtn.Image = DEFAULTS.Icons.maximize
    maxBtn.Size = UDim2.new(0, 16, 0, 16)
    maxBtn.BackgroundTransparency = 1
    maxBtn.ImageColor3 = DEFAULTS.Colors.TextSecondary

    local minBtn = Instance.new("ImageButton", actionButtons)
    minBtn.Image = DEFAULTS.Icons.minimize
    minBtn.Size = UDim2.new(0, 16, 0, 16)
    minBtn.BackgroundTransparency = 1
    minBtn.ImageColor3 = DEFAULTS.Colors.TextSecondary

    -- 4. Container Principal
    local mainContainer = Instance.new("Frame", self.MainFrame)
    mainContainer.Size = UDim2.new(1, 0, 1, -55)
    mainContainer.Position = UDim2.new(0, 0, 0, 55)
    mainContainer.BackgroundTransparency = 1
    Instance.new("UIPadding", mainContainer).PaddingLeft = UDim.new(0, 15)
    Instance.new("UIPadding", mainContainer).PaddingRight = UDim.new(0, 15)
    Instance.new("UIPadding", mainContainer).PaddingBottom = UDim.new(0, 15)

    -- 5. Painel de Abas (Esquerda)
    local sideBarWidth = options.SideBarWidth or 180
    self.TabsContainer = Instance.new("Frame", mainContainer)
    self.TabsContainer.Size = UDim2.new(0, sideBarWidth, 1, 0)
    self.TabsContainer.BackgroundTransparency = 1
    local tabsLayout = Instance.new("UIListLayout", self.TabsContainer)
    tabsLayout.Padding = UDim.new(0, 10)
    tabsLayout.SortOrder = Enum.SortOrder.LayoutOrder

    -- 6. Painel de Conteúdo (Direita)
    self.ContentFrame = Instance.new("Frame", mainContainer)
    self.ContentFrame.Size = UDim2.new(1, -sideBarWidth - 15, 1, 0)
    self.ContentFrame.Position = UDim2.new(0, sideBarWidth + 15, 0, 0)
    self.ContentFrame.BackgroundTransparency = 1
    self.ContentFrame.ClipsDescendants = true

    -- 7. Lógica de Arrastar
    self:_makeDraggable(titleBar)

    return self
end

-- // Funções do Objeto da Janela

function WindowObject:_makeDraggable(frame)
    local dragInput, framePosition
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            self._dragging = true; dragInput = input; framePosition = self.MainFrame.Position
        end
    end)
    frame.InputEnded:Connect(function(input) if input == dragInput then self._dragging = false end end)
    UserInputService.InputChanged:Connect(function(input)
        if self._dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragInput.Position
            self.MainFrame.Position = UDim2.new(framePosition.X.Scale, framePosition.X.Offset + delta.X, framePosition.Y.Scale, framePosition.Y.Offset + delta.Y)
        end
    end)
end

function WindowObject:_updateEmptyMessage(tab)
    local hasElements = false
    for _, child in ipairs(tab.Content:GetChildren()) do
        if child:IsA("TextButton") or child:IsA("Frame") and child.Name ~= "EmptyMessage" then
            hasElements = true
            break
        end
    end
    tab.EmptyMessage.Visible = not hasElements
end

function WindowObject:SwitchTab(title)
    if not self.Tabs[title] or self.ActiveTab == title then return end

    if self.ActiveTab and self.Tabs[self.ActiveTab] then
        local oldTab = self.Tabs[self.ActiveTab]
        oldTab.Content.Visible = false
        TweenService:Create(oldTab.Button, TweenInfo.new(0.2), { BackgroundColor3 = DEFAULTS.Colors.TabInactive }):Play()
    end

    local newTab = self.Tabs[title]
    newTab.Content.Visible = true
    newTab.Button.BackgroundColor3 = DEFAULTS.Colors.TabActive
    self.ActiveTab = title
end

function WindowObject:AddTab(title, icon)
    local tabData = {}

    local tabButton = Instance.new("TextButton", self.TabsContainer)
    tabButton.Name = title
    tabButton.Size = UDim2.new(1, 0, 0, 42)
    tabButton.BackgroundColor3 = DEFAULTS.Colors.TabInactive
    tabButton.Text = ""
    Instance.new("UICorner", tabButton).CornerRadius = UDim.new(0, 6)

    local tabIcon = Instance.new("ImageLabel", tabButton)
    tabIcon.Image = DEFAULTS.Icons[icon] or DEFAULTS.Icons["tab"]
    tabIcon.Size = UDim2.new(0, 20, 0, 20)
    tabIcon.Position = UDim2.new(0, 15, 0.5, -10)
    tabIcon.BackgroundTransparency = 1
    tabIcon.ImageColor3 = DEFAULTS.Colors.TextSecondary

    local tabLabel = Instance.new("TextLabel", tabButton)
    tabLabel.Text = title
    tabLabel.Font = DEFAULTS.Fonts.Tab
    tabLabel.TextColor3 = DEFAULTS.Colors.TextPrimary
    tabLabel.TextSize = 15
    tabLabel.TextXAlignment = Enum.TextXAlignment.Left
    tabLabel.Position = UDim2.new(0, 45, 0, 0)
    tabLabel.Size = UDim2.new(1, -55, 1, 0)
    tabLabel.BackgroundTransparency = 1

    local content = Instance.new("ScrollingFrame", self.ContentFrame)
    content.Name = title .. "Content"
    content.Size = UDim2.fromScale(1, 1)
    content.BackgroundColor3 = DEFAULTS.Colors.Background
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 0
    content.Visible = false
    Instance.new("UICorner", content).CornerRadius = UDim.new(0, 6)
    local contentLayout = Instance.new("UIListLayout", content)
    contentLayout.Padding = UDim.new(0, 10)
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    Instance.new("UIPadding", content).Padding = UDim.new(0, 15)

    local emptyMessage = Instance.new("Frame", content)
    emptyMessage.Name = "EmptyMessage"
    emptyMessage.Size = UDim2.fromScale(1, 1)
    emptyMessage.BackgroundTransparency = 1
    local emptyIcon = Instance.new("ImageLabel", emptyMessage)
    emptyIcon.Image = DEFAULTS.Icons["empty-face"]
    emptyIcon.Size = UDim2.fromOffset(48, 48)
    emptyIcon.Position = UDim2.new(0.5, -24, 0.5, -40)
    emptyIcon.BackgroundTransparency = 1
    emptyIcon.ImageColor3 = Color3.fromRGB(60, 60, 60)
    local emptyText = Instance.new("TextLabel", emptyMessage)
    emptyText.Text = "This tab is empty"
    emptyText.Font = DEFAULTS.Fonts.Body
    emptyText.TextColor3 = DEFAULTS.Colors.TextPlaceholder
    emptyText.TextSize = 14
    emptyText.Position = UDim2.new(0.5, -100, 0.5, 15)
    emptyText.Size = UDim2.fromOffset(200, 20)
    emptyText.BackgroundTransparency = 1

    tabData.Button = tabButton
    tabData.Content = content
    tabData.EmptyMessage = emptyMessage
    self.Tabs[title] = tabData

    tabButton.MouseButton1Click:Connect(function() self:SwitchTab(title) end)

    if not self.ActiveTab then self:SwitchTab(title) end
    self:_updateEmptyMessage(tabData)

    return tabData
end

-- // Funções para adicionar elementos
function WindowObject:AddButton(tab, text, callback)
    if not tab or not tab.Content then return end
    
    local button = Instance.new("TextButton", tab.Content)
    button.Name = text
    button.Size = UDim2.new(1, 0, 0, 38)
    button.BackgroundColor3 = DEFAULTS.Colors.TabInactive
    button.Text = text
    button.TextColor3 = DEFAULTS.Colors.TextPrimary
    button.Font = DEFAULTS.Fonts.Body
    button.TextSize = 14
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)

    button.MouseButton1Click:Connect(function() pcall(callback) end)
    self:_updateEmptyMessage(tab)
end

return Zyrex
