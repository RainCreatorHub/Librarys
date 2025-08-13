local TitleBarComponent = require(script.Parent.TitleBar)

local Window = {}

function Window:MakeWindow(Info)
	Info = Info or {}

	if not Info.Name then
		warn("MakeWindow - O campo 'Name' é obrigatório.")
		return nil
	end

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "Stelarium_X.S_Lib_Container"
	screenGui.ResetOnSpawn = false
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

	local windowFrame = Instance.new("Frame")
	windowFrame.Name = "WindowFrame"
	windowFrame.Size = Info.Size or UDim2.new(0, 450, 0, 350)
	windowFrame.Position = Info.Position or UDim2.new(0.5, -225, 0.5, -175)
	windowFrame.BackgroundColor3 = Info.BackgroundColor or Color3.fromRGB(38, 38, 38)
	windowFrame.BorderColor3 = Info.BorderColor or Color3.fromRGB(10, 10, 10)
	windowFrame.ClipsDescendants = true
	windowFrame.Parent = screenGui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = windowFrame

	TitleBarComponent.new(Info.Name, windowFrame)

	screenGui.Parent = game:GetService("CoreGui")
	return windowFrame
end

return Window
