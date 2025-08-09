local Lib = {}
Lib.__index = Lib

local Themes = {
    Dark = {
        BG = Color3.fromRGB(24, 25, 29),
        Primary = Color3.fromRGB(44, 46, 51),
        Secondary = Color3.fromRGB(62, 64, 70),
        Accent = Color3.fromRGB(88, 101, 242),
        Font = Color3.fromRGB(242, 242, 242),
        Font2 = Color3.fromRGB(180, 180, 180),
        FontName = Enum.Font.GothamSemibold,
        Radius = UDim.new(0, 8)
    }
}
Themes.dark = Themes.Dark

function Lib:MakeWindow(Info)
    local th = Themes[Info.Theme] or Themes.Dark

    if game:GetService("CoreGui"):FindFirstChild("MoonLibV2_GUI") then
        game:GetService("CoreGui"):FindFirstChild("MoonLibV2_GUI"):Destroy()
    end

    local sGui = Instance.new("ScreenGui")
    sGui.Name = "MoonLibV2_GUI"
    sGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sGui.Parent = game:GetService("CoreGui")

    if Info.LoadScreen then
        local lFrm = Instance.new("Frame")
        lFrm.Name = "LoadScreen"
        lFrm.Parent = sGui
        lFrm.BackgroundColor3 = th.BG
        lFrm.Size = UDim2.new(1, 0, 1, 0)
        lFrm.ZIndex = 10
        
        local lTxt = Instance.new("TextLabel")
        lTxt.Name = "LoadInfo"
        lTxt.Parent = lFrm
        lTxt.AnchorPoint = Vector2.new(0.5, 0.5)
        lTxt.Position = UDim2.new(0.5, 0, 0.5, 0)
        lTxt.Size = UDim2.new(0, 400, 0, 50)
        lTxt.BackgroundTransparency = 1
        lTxt.Font = th.FontName
        lTxt.TextColor3 = th.Font
        lTxt.TextSize = 22
        lTxt.Text = Info.LoadScreenInfo or "Carregando..."
        
        wait(2)
        for i = 1, 10 do
            lFrm.BackgroundTransparency = i / 10
            lTxt.TextTransparency = i / 10
            wait(0.05)
        end
        lFrm:Destroy()
    end

    local mFrm = Instance.new("Frame")
    mFrm.Name = "Window"
    mFrm.Parent = sGui
    mFrm.AnchorPoint = Vector2.new(0.5, 0.5)
    mFrm.Position = UDim2.new(0.5, 0, 0.5, 0)
    mFrm.Size = UDim2.new(0, 500, 0, 300)
    mFrm.BackgroundColor3 = th.Primary
    mFrm.BorderSizePixel = 0
    mFrm.Active = true
    mFrm.Draggable = true
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = th.Radius
    corner.Parent = mFrm
    
    local tBar = Instance.new("Frame")
    tBar.Name = "TitleBar"
    tBar.Parent = mFrm
    tBar.Size = UDim2.new(1, 0, 0, 40)
    tBar.BackgroundTransparency = 1
    
    local tLbl = Instance.new("TextLabel")
    tLbl.Name = "Title"
    tLbl.Parent = tBar
    tLbl.Size = UDim2.new(1, -15, 1, 0)
    tLbl.Position = UDim2.new(0, 15, 0, 0)
    tLbl.BackgroundTransparency = 1
    tLbl.Font = th.FontName
    tLbl.TextColor3 = th.Font
    tLbl.TextSize = 20
    tLbl.Text = Info.Name or "Window"
    tLbl.TextXAlignment = Enum.TextXAlignment.Left
    
    local sLbl = Instance.new("TextLabel")
    sLbl.Name = "SubTitle"
    sLbl.Parent = mFrm
    sLbl.Size = UDim2.new(1, -30, 0, 20)
    sLbl.Position = UDim2.new(0, 15, 0, 40)
    sLbl.BackgroundTransparency = 1
    sLbl.Font = Enum.Font.Gotham
    sLbl.TextColor3 = th.Font2
    sLbl.TextSize = 14
    sLbl.Text = Info.SubTitle or ""
    sLbl.TextXAlignment = Enum.TextXAlignment.Left
    
    local winObj = {}
    winObj.Frame = mFrm
    winObj.Theme = th
    
    function winObj:AddTab(tabInfo)
        -- Futura lógica para abas
    end

    return winObj
end

return Lib
