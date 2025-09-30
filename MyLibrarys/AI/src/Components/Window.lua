local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local TitleBar = require(script.Parent.TitleBar)
local KeySystem = require(script.Parent.KeySystem)
local Notify = require(script.Parent.Notify)

local Window = {}
Window.__index = Window

function Window.new(config, lib)
	local self = setmetatable({}, Window)
	self.Lib = lib

	local title = config.Title or "DoorLib"
	local subtitle = config.SubTitle or ""
	local useKey = config.Key == true
	local keySystemConfig = config.KeySystem or {}

	local gui = Instance.new("ScreenGui")
	gui.Name = "DoorLib"
	gui.ResetOnSpawn = false
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.IgnoreGuiInset = true
	gui.Parent = pcall(function() return getfenv().getcustomasset end) and game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")

	local main = Instance.new("Frame")
	main.Size = UDim2.new(0, 420, 0, 320)
	main.Position = UDim2.new(0.5, -210, 0.5, -160)
	main.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
	main.BorderSizePixel = 0
	main.ClipsDescendants = true
	main.Parent = gui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = main

	local titleBar = TitleBar.new(main, title, subtitle, function()
		gui:Destroy()
	end)

	local divider = Instance.new("Frame")
	divider.Size = UDim2.new(1, 0, 0, 1)
	divider.Position = UDim2.new(0, 0, 0, 36)
	divider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	divider.BorderSizePixel = 0
	divider.Parent = main

	local content = Instance.new("ScrollingFrame")
	content.Size = UDim2.new(1, -16, 1, -52)
	content.Position = UDim2.new(0, 8, 0, 44)
	content.BackgroundTransparency = 1
	content.CanvasSize = UDim2.new(0, 0, 0, 0)
	content.ScrollBarThickness = 6
	content.BorderSizePixel = 0
	content.Parent = main

	local layout = Instance.new("UIListLayout")
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 6)
	layout.Parent = content

	layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		content.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
	end)

	if useKey then
		local valid, reason = KeySystem.Verify(keySystemConfig)
		if not valid then
			gui:Destroy()
			if keySystemConfig.Notify and keySystemConfig.Notify.InvalidKey then
				local inv = keySystemConfig.Notify.InvalidKey
				Notify.new(inv.Title, inv.Desc, inv.Time or 3)
				if inv.Callback then inv.Callback() end
			end
			return { Destroy = function() end }
		else
			if keySystemConfig.Notify and keySystemConfig.Notify.ValidKey then
				local val = keySystemConfig.Notify.ValidKey
				Notify.new(val.Title, val.Desc, val.Time or 3)
				if val.Callback then val.Callback() end
			end
		end
	end

	local tabs = {}

	function self:Tab(cfg)
		cfg = cfg or {}
		local tab = require(script.Parent.Tab).new(content, cfg)
		table.insert(tabs, tab)
		return tab
	end

	function self:Destroy()
		gui:Destroy()
	end

	local dragging = false
	local dragStart
	local startPos

	titleBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = main.Position
		end
	end)

	titleBar.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
			local delta = input.Position - dragStart
			main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)

	return self
end

return Window
