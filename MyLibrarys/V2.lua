local MoonLibV2 = {}
MoonLibV2.__index = MoonLibV2

-- Tabela de temas.
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
function MoonLibV2:MakeWindow(Info)

    -- Define o tema a ser usado. Padrão é "Dark" se não for especificado ou for inválido.
    local theme = Themes[Info.Theme] or Themes.Dark

    -- Garante que a GUI antiga seja removida se o script for executado novamente
    if game:GetService("CoreGui"):FindFirstChild("MoonLibV2_GUI") then
        game:GetService("CoreGui"):FindFirstChild("MoonLibV2_GUI"):Destroy()
    end

    -- Cria a base da GUI (ScreenGui)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MoonLibV2_GUI"
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = game:GetService("CoreGui")

    -- Tela de Carregamento (Load Screen)
    if Info.LoadScreen then
        local loadFrame = Instance.new("Frame")
        loadFrame.Name = "LoadScreen"
        loadFrame.Parent = screenGui
        loadFrame.BackgroundColor3 = theme.Background
        loadFrame.Size = UDim2.new(1, 0, 1, 0)
        loadFrame.ZIndex = 10

        local loadText = Instance.new("TextLabel")
        loadText.Name = "LoadInfo"
        loadText.Parent = loadFrame
        loadText.AnchorPoint = Vector2.new(0.5, 0.5)
        loadText.Position = UDim2.new(0.5, 0, 0.5, 0)
        loadText.Size = UDim2.new(0, 400, 0, 50)
        loadText.BackgroundTransparency = 1
        loadText.Font = theme.Font
        loadText.TextColor3 = theme.FontColor
        loadText.TextSize = 22
        loadText.Text = Info.LoadScreenInfo or "Carregando..."

        wait(2)
        for i = 1, 10 do
            loadFrame.BackgroundTransparency = i / 10
            loadText.TextTransparency = i / 10
            wait(0.05)
        end
        loadFrame:Destroy()
    end

    -- Janela Principal (Frame)
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "JanelaPrincipal"
    mainFrame.Parent = screenGui
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainFrame.Size = UDim2.new(0, 500, 0, 300)
    mainFrame.BackgroundColor3 = theme.Primary
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = theme.CornerRadius
    uiCorner.Parent = mainFrame

    -- Barra de Título
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Parent = mainFrame
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundTransparency = 1

    -- Título da Janela
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Parent = titleBar
    titleLabel.Size = UDim2.new(1, -15, 1, 0)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = theme.Font
    titleLabel.TextColor3 = theme.FontColor
    titleLabel.TextSize = 20
    titleLabel.Text = Info.Name or "Janela"
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- Subtítulo da Janela
    local subTitleLabel = Instance.new("TextLabel")
    subTitleLabel.Name = "SubTitle"
    subTitleLabel.Parent = mainFrame
    subTitleLabel.Size = UDim2.new(1, -30, 0, 20)
    subTitleLabel.Position = UDim2.new(0, 15, 0, 40)
    subTitleLabel.BackgroundTransparency = 1
    subTitleLabel.Font = Enum.Font.Gotham
    subTitleLabel.TextColor3 = theme.FontColorSecondary
    subTitleLabel.TextSize = 14
    subTitleLabel.Text = Info.SubTitle or ""
    subTitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    print("MoonLibV2: Janela '" .. (Info.Name or "Indefinida") .. "' criada com sucesso.")
    return mainFrame
end
