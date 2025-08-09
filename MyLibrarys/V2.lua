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
        lFrm.Name = "LoadScreen"; lFrm.Parent = sGui; lFrm.BackgroundColor3 = th.BG; lFrm.Size = UDim2.new(1, 0, 1, 0); lFrm.ZIndex = 10
        local lTxt = Instance.new("TextLabel")
        lTxt.Name = "LoadInfo"; lTxt.Parent = lFrm; lTxt.AnchorPoint = Vector2.new(0.5, 0.5); lTxt.Position = UDim2.new(0.5, 0, 0.5, 0); lTxt.Size = UDim2.new(0, 400, 0, 50); lTxt.BackgroundTransparency = 1; lTxt.Font = th.FontName; lTxt.TextColor3 = th.Font; lTxt.TextSize = 22; lTxt.Text = Info.LoadScreenInfo or "Carregando..."
        wait(2)
        for i = 1, 10 do lFrm.BackgroundTransparency = i / 10; lTxt.TextTransparency = i / 10; wait(0.05) end
        lFrm:Destroy()
    end

    local mFrm = Instance.new("Frame")
    mFrm.Name = "Window"; mFrm.Parent = sGui; mFrm.AnchorPoint = Vector2.new(0.5, 0.5); mFrm.Position = UDim2.new(0.5, 0, 0.5, 0); mFrm.Size = UDim2.new(0, 500, 0, 300); mFrm.BackgroundColor3 = th.Primary; mFrm.BorderSizePixel = 0; mFrm.Active = true; mFrm.Draggable = true
    local corner = Instance.new("UICorner"); corner.CornerRadius = th.Radius; corner.Parent = mFrm
    local tBar = Instance.new("Frame"); tBar.Name = "TitleBar"; tBar.Parent = mFrm; tBar.Size = UDim2.new(1, 0, 0, 30); tBar.Position = UDim2.new(0, 0, 0, 5); tBar.BackgroundTransparency = 1
    local tLbl = Instance.new("TextLabel"); tLbl.Name = "Title"; tLbl.Parent = tBar; tLbl.Size = UDim2.new(1, -15, 1, 0); tLbl.Position = UDim2.new(0, 15, 0, 0); tLbl.BackgroundTransparency = 1; tLbl.Font = th.FontName; tLbl.TextColor3 = th.Font; tLbl.TextSize = 20; tLbl.Text = Info.Name or "Window"; tLbl.TextXAlignment = Enum.TextXAlignment.Left
    local sLbl = Instance.new("TextLabel"); sLbl.Name = "SubTitle"; sLbl.Parent = mFrm; sLbl.Size = UDim2.new(1, -30, 0, 15); sLbl.Position = UDim2.new(0, 15, 0, 30); sLbl.BackgroundTransparency = 1; sLbl.Font = Enum.Font.Gotham; sLbl.TextColor3 = th.Font2; sLbl.TextSize = 14; sLbl.Text = Info.SubTitle or ""; sLbl.TextXAlignment = Enum.TextXAlignment.Left
    local line = Instance.new("Frame"); line.Name = "Separator"; line.Parent = mFrm; line.BackgroundColor3 = th.BG; line.BorderSizePixel = 0; line.Size = UDim2.new(1, -30, 0, 2); line.Position = UDim2.new(0.5, 0, 0, 55); line.AnchorPoint = Vector2.new(0.5, 0)
    
    local winObj = {}
    winObj.Frame = mFrm
    winObj.Theme = th
    winObj.Tabs = {}
    winObj.TabHolder = Instance.new("Frame"); winObj.TabHolder.Name = "TabHolder"; winObj.TabHolder.Parent = mFrm; winObj.TabHolder.Size = UDim2.new(1, 0, 0, 30); winObj.TabHolder.Position = UDim2.new(0, 0, 0, 65); winObj.TabHolder.BackgroundTransparency = 1
    local tabLayout = Instance.new("UIListLayout"); tabLayout.Parent = winObj.TabHolder; tabLayout.FillDirection = Enum.FillDirection.Horizontal; tabLayout.Padding = UDim.new(0, 5)

    function winObj:MakeTab(Info)
        local tabBtn = Instance.new("TextButton")
        tabBtn.Name = Info.Name; tabBtn.Parent = winObj.TabHolder; tabBtn.Size = UDim2.new(0, 100, 1, 0); tabBtn.BackgroundColor3 = th.Secondary; tabBtn.Text = Info.Name; tabBtn.Font = th.FontName; tabBtn.TextColor3 = th.Font; tabBtn.TextSize = 14
        local tabCorner = Instance.new("UICorner"); tabCorner.CornerRadius = th.Radius; tabCorner.Parent = tabBtn

        local content = Instance.new("Frame")
        content.Name = "Content"; content.Parent = mFrm; content.Size = UDim2.new(1, 0, 1, -105); content.Position = UDim2.new(0, 0, 0, 100); content.BackgroundTransparency = 1; content.Visible = false
        
        local subTabHolder = Instance.new("Frame"); subTabHolder.Name = "SubTabHolder"; subTabHolder.Parent = content; subTabHolder.Size = UDim2.new(1, 0, 0, 25); subTabHolder.BackgroundTransparency = 1
        local subTabLayout = Instance.new("UIListLayout"); subTabLayout.Parent = subTabHolder; subTabLayout.FillDirection = Enum.FillDirection.Horizontal; subTabLayout.Padding = UDim.new(0, 5)

        local tabObj = {}
        tabObj.Button = tabBtn
        tabObj.Content = content
        tabObj.SubTabs = {}
        tabObj.SubTabHolder = subTabHolder
        tabObj.HasSubTabs = false

        function tabObj:MakeSubTab(sInfo)
            tabObj.HasSubTabs = true
            local sBtn = Instance.new("TextButton")
            sBtn.Name = sInfo.Name; sBtn.Parent = subTabHolder; sBtn.Size = UDim2.new(0, 100, 1, 0); sBtn.BackgroundColor3 = th.Secondary; sBtn.Text = sInfo.Name; sBtn.Font = th.FontName; sBtn.TextColor3 = th.Font; sBtn.TextSize = 12
            local sCorner = Instance.new("UICorner"); sCorner.CornerRadius = th.Radius; sCorner.Parent = sBtn

            local sContent = Instance.new("Frame")
            sContent.Name = "SubContent"; sContent.Parent = content; sContent.Size = UDim2.new(1, 0, 1, -30); sContent.Position = UDim2.new(0, 0, 0, 30); sContent.BackgroundTransparency = 1; sContent.Visible = false
            
            local sObj = {Button = sBtn, Content = sContent}
            table.insert(tabObj.SubTabs, sObj)

            sBtn.MouseButton1Click:Connect(function()
                for _, otherSubTab in ipairs(tabObj.SubTabs) do
                    otherSubTab.Content.Visible = false
                    otherSubTab.Button.BackgroundColor3 = th.Secondary
                end
                sContent.Visible = true
                sBtn.BackgroundColor3 = th.Accent
            end)
            return sObj
        end
        
        table.insert(winObj.Tabs, tabObj)

        tabBtn.MouseButton1Click:Connect(function()
            for _, otherTab in ipairs(winObj.Tabs) do
                otherTab.Content.Visible = false
                otherTab.Button.BackgroundColor3 = th.Secondary
            end
            content.Visible = true
            tabBtn.BackgroundColor3 = th.Accent

            if tabObj.HasSubTabs and #tabObj.SubTabs > 0 then
                for i, sTab in ipairs(tabObj.SubTabs) do
                    sTab.Content.Visible = (i == 1)
                    sTab.Button.BackgroundColor3 = (i == 1) and th.Accent or th.Secondary
                end
            end
        end)
        
        if #winObj.Tabs == 1 then
            tabBtn:MouseButton1Click()
        end
        
        return tabObj
    end

    return winObj
end

return Lib
