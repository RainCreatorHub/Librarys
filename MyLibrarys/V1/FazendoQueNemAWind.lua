

-- // Serviços
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

-- // Módulo Principal e Objeto da Janela
local Zyrex = {}
local WindowObject = { _elements = {} }
WindowObject.__index = WindowObject

-- // Configurações de Aparência (Cores, Fontes, Ícones)
local DEFAULTS = {
    Colors = {
        Background = Color3.fromRGB(25, 25, 25),      -- #191919
        ContentBG = Color3.fromRGB(35, 35, 35),      -- Fundo da área de conteúdo
        ElementBG = Color3.fromRGB(43, 43, 43),      -- Fundo de botões/abas
        ElementHover = Color3.fromRGB(60, 60, 60),   -- Cor de hover
        TextPrimary = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(169, 169, 169)
    },
    Fonts = {
        Title = Enum.Font.GothamSemibold,
        Subtitle = Enum.Font.Gotham,
        Body = Enum.Font.Gotham
    },
    Icons = {
        ["default-icon"] = "rbxassetid://2151722383", -- Ícone de usuário placeholder
        ["empty-face"] = "rbxassetid://5984510721"
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

    -- Ícone Circular da Janela
    local iconContainer = Instance.new("Frame", titleBar)
    iconContainer.Size = UDim2.fromOffset(28, 28)
    iconContainer.Position = UDim2.new(0, 15, 0.5, -14)
    iconContainer.BackgroundTransparency = 1
    local iconImage = Instance.new("ImageLabel", iconContainer)
    iconImage.Size = UDim2.fromScale(1, 1)
    iconImage.Image = options.Icon or DEFAULTS.Icons["default-icon"]
    iconImage.BackgroundTransparency = 1
    local iconCorner = Instance.new("UICorner", iconContainer)
    iconCorner.CornerRadius = UDim.new(1, 0)

    local titleLabel = Instance.new("TextLabel", titleBar)
    titleLabel.Text = options.Title or "Zyrex UI"
    titleLabel.Font = DEFAULTS.Fonts.Title
    titleLabel.TextColor3 = DEFAULTS.Colors.TextPrimary
    titleLabel.TextSize = 15
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Position = UDim2.new(0, 55, 0, 6)
    titleLabel.Size = UDim2.new(0, 300, 0, 20)
    titleLabel.BackgroundTransparency = 1

    local subtitleLabel = Instance.new("TextLabel", titleBar)
    subtitleLabel.Text = options.Author or "by Zyrex"
    subtitleLabel.Font = DEFAULTS.Fonts.Subtitle
    subtitleLabel.TextColor3 = DEFAULTS.Colors.TextSecondary
    subtitleLabel.TextSize = 12
    subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    subtitleLabel.Position = UDim2.new(0, 55, 0, 25)
    subtitleLabel.Size = UDim2.new(0, 300, 0, 15)
    subtitleLabel.BackgroundTransparency = 1

    -- 4. Container Principal (para Abas e Conteúdo)
    local mainContainer = Instance.new("Frame", self.MainFrame)
    mainContainer.Size = UDim2.new(1, -20, 1, -60)
    mainContainer.Position = UDim2.new(0.5, -mainContainer.AbsoluteSize.X / 2, 0.5, 25)
    mainContainer.BackgroundTransparency = 1

    -- 5. Painel de Abas (Esquerda)
    local sideBarWidth = 140
    self.TabsContainer = Instance.new("Frame", mainContainer)
    self.TabsContainer.Size = UDim2.new(0, sideBarWidth, 1, 0)
    self.TabsContainer.BackgroundTransparency = 1
    local tabsLayout = Instance.new("UIListLayout", self.TabsContainer)
    tabsLayout.Padding = UDim.new(0, 10)
    tabsLayout.SortOrder = Enum.SortOrder.LayoutOrder

    -- 6. Painel de Conteúdo (Direita)
    self.ContentFrame = Instance.new("Frame", mainContainer)
    self.ContentFrame.Size = UDim2.new(1, -sideBarWidth - 10, 1, 0)
    self.ContentFrame.Position = UDim2.new(0, sideBarWidth + 10, 0, 0)
    self.ContentFrame.BackgroundColor3 = DEFAULTS.Colors.ContentBG
    self.ContentFrame.BorderSizePixel = 0
    Instance.new("UICorner", self.ContentFrame).CornerRadius = UDim.new(0, 6)

    -- 7. Lógica de Arrastar
    self:_makeDraggable(titleBar)

    return self
end

-- // Funções do Objeto da Janela

function WindowObject:_makeDraggable(frame)
    -- (Código de arrastar permanece o mesmo da versão anterior)
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

function WindowObject:SwitchTab(title)
    if not self.Tabs[title] or self.ActiveTab == title then return end

    if self.ActiveTab and self.Tabs[self.ActiveTab] then
        local oldTab = self.Tabs[self.ActiveTab]
        oldTab.Content.Visible = false
        TweenService:Create(oldTab.Button, TweenInfo.new(0.2), { BackgroundColor3 = DEFAULTS.Colors.ElementBG }):Play()
    end

    local newTab = self.Tabs[title]
    newTab.Content.Visible = true
    newTab.Button.BackgroundColor3 = DEFAULTS.Colors.ElementHover
    self.ActiveTab = title
end

function WindowObject:AddTab(title)
    local tabData = {}

    local tabButton = Instance.new("TextButton", self.TabsContainer)
    tabButton.Name = title
    tabButton.Size = UDim2.new(1, 0, 0, 40)
    tabButton.BackgroundColor3 = DEFAULTS.Colors.ElementBG
    tabButton.Text = title
    tabButton.Font = DEFAULTS.Fonts.Body
    tabButton.TextSize = 14
    tabButton.TextColor3 = DEFAULTS.Colors.TextPrimary
    Instance.new("UICorner", tabButton).CornerRadius = UDim.new(0, 6)

    local content = Instance.new("ScrollingFrame", self.ContentFrame)
    content.Name = title .. "Content"
    content.Size = UDim2.fromScale(1, 1)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 4
    content.Visible = false
    local contentLayout = Instance.new("UIListLayout", content)
    contentLayout.Padding = UDim.new(0, 10)
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    Instance.new("UIPadding", content).PaddingTop = UDim.new(0, 10)
    Instance.new("UIPadding", content).PaddingLeft = UDim.new(0, 10)
    Instance.new("UIPadding", content).PaddingRight = UDim.new(0, 10)

    tabData.Button = tabButton
    tabData.Content = content
    self.Tabs[title] = tabData

    tabButton.MouseButton1Click:Connect(function() self:SwitchTab(title) end)

    if not self.ActiveTab then self:SwitchTab(title) end

    return tabData
end

-- // Funções para adicionar elementos (Layout Corrigido)

function WindowObject:AddButton(tab, text, callback)
    if not tab or not tab.Content then return end

    local container = Instance.new("Frame", tab.Content)
    container.Size = UDim2.new(1, 0, 0, 35)
    container.BackgroundTransparency = 1

    local button = Instance.new("TextButton", container)
    button.Name = text
    button.Size = UDim2.new(0.5, 0, 1, 0)
    button.Position = UDim2.new(0.5, 0, 0, 0)
    button.BackgroundColor3 = DEFAULTS.Colors.ElementBG
    button.Text = text
    button.TextColor3 = DEFAULTS.Colors.TextPrimary
    button.Font = DEFAULTS.Fonts.Body
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)

    button.MouseButton1Click:Connect(function() pcall(callback) end)
end

function WindowObject:AddToggle(tab, text, callback)
    if not tab or not tab.Content then return end
    local state = false

    local container = Instance.new("Frame", tab.Content)
    container.Size = UDim2.new(1, 0, 0, 40)
    container.BackgroundTransparency = 1

    local label = Instance.new("TextLabel", container)
    label.Text = text
    label.Font = DEFAULTS.Fonts.Body
    label.TextColor3 = DEFAULTS.Colors.TextPrimary
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Position = UDim2.new(0, 0, 0.5, -10)
    label.Size = UDim2.new(0.7, 0, 0, 20)
    label.BackgroundTransparency = 1

    local switch = Instance.new("TextButton", container)
    switch.Size = UDim2.new(0, 50, 0, 24)
    switch.Position = UDim2.new(1, -50, 0.5, -12)
    switch.BackgroundColor3 = DEFAULTS.Colors.ElementBG
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
        local newColor = state and Color3.fromRGB(100, 180, 100) or DEFAULTS.Colors.ElementBG
        TweenService:Create(knob, TweenInfo.new(0.2), {Position = newPos}):Play()
        TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = newColor}):Play()
        pcall(callback, state)
    end)
end

return Zyrex
