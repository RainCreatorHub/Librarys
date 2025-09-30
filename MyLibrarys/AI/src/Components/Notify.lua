local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Notify = {}

function Notify.new(config)
	local title = config.Title or "Notify"
	local desc = config.Desc or ""
	local iconId = config.Icon
	local options = config.Options

	local gui = Instance.new("ScreenGui")
	gui.Name = "DoorLibNotify"
	gui.ResetOnSpawn = false
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.Parent = pcall(function() return getfenv().getcustomasset end) and game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")

	local frame = Instance.new("Frame")
	frame.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
	frame.BorderSizePixel = 0
	frame.Parent = gui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = frame

	-- Determinar tamanho com base na presença de opções
	local hasOptions = options and (options.Op1 or options.Op2)
	local height = hasOptions and 120 or 70
	frame.Size = UDim2.new(0, 300, 0, height)
	frame.Position = UDim2.new(1, -320, 0, 20)

	-- Ícone principal (opcional)
	if iconId then
		local mainIcon = Instance.new("ImageLabel")
		mainIcon.Image = "rbxassetid://" .. tostring(iconId)
		mainIcon.Size = UDim2.new(0, 24, 0, 24)
		mainIcon.Position = UDim2.new(0, 12, 0, 12)
		mainIcon.BackgroundTransparency = 1
		mainIcon.Parent = frame
	end

	-- Título
	local titleLbl = Instance.new("TextLabel")
	titleLbl.Text = title
	titleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleLbl.TextSize = 14
	titleLbl.Font = Enum.Font.GothamBold
	titleLbl.BackgroundTransparency = 1
	titleLbl.Size = UDim2.new(1, -24, 0, 18)
	titleLbl.Position = UDim2.new(0, iconId and 40 or 12, 0, 12)
	titleLbl.Parent = frame

	-- Descrição
	local descLbl = Instance.new("TextLabel")
	descLbl.Text = desc
	descLbl.TextColor3 = Color3.fromRGB(180, 180, 180)
	descLbl.TextSize = 12
	descLbl.Font = Enum.Font.Gotham
	descLbl.BackgroundTransparency = 1
	descLbl.Size = UDim2.new(1, -24, 0, 16)
	descLbl.Position = UDim2.new(0, iconId and 40 or 12, 0, 34)
	descLbl.RichText = true
	descLbl.TextWrapped = true
	descLbl.Parent = frame

	-- Opções (botões)
	if hasOptions then
		local buttonContainer = Instance.new("Frame")
		buttonContainer.Size = UDim2.new(1, -16, 0, 30)
		buttonContainer.Position = UDim2.new(0, 8, 1, -38)
		buttonContainer.BackgroundTransparency = 1
		buttonContainer.Parent = frame

		local btns = {}
		local count = 0
		if options.Op1 then count = count + 1 end
		if options.Op2 then count = count + 1 end

		local btnWidth = count == 1 and UDim2.new(1, 0, 1, 0) or UDim2.new(0.5, -2, 1, 0)

		if options.Op1 then
			local btn1 = Instance.new("TextButton")
			btn1.Text = options.Op1.Title or "Opção 1"
			btn1.TextColor3 = Color3.fromRGB(255, 255, 255)
			btn1.TextSize = 13
			btn1.Font = Enum.Font.Gotham
			btn1.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			btn1.BorderSizePixel = 0
			btn1.Size = btnWidth
			btn1.Position = UDim2.new(0, 0, 0, 0)
			btn1.AutoButtonColor = false
			btn1.Parent = buttonContainer

			local c1 = Instance.new("UICorner")
			c1.CornerRadius = UDim.new(0, 4)
			c1.Parent = btn1

			if options.Op1.Icon then
				local icn = Instance.new("ImageLabel")
				icn.Image = "rbxassetid://" .. tostring(options.Op1.Icon)
				icn.Size = UDim2.new(0, 14, 0, 14)
				icn.Position = UDim2.new(0, 6, 0.5, -7)
				icn.BackgroundTransparency = 1
				icn.Parent = btn1
			end

			btn1.MouseButton1Click:Connect(function()
				if options.Op1.Callback then options.Op1.Callback() end
				gui:Destroy()
			end)

			table.insert(btns, btn1)
		end

		if options.Op2 then
			local btn2 = Instance.new("TextButton")
			btn2.Text = options.Op2.Title or "Opção 2"
			btn2.TextColor3 = Color3.fromRGB(255, 255, 255)
			btn2.TextSize = 13
			btn2.Font = Enum.Font.Gotham
			btn2.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			btn2.BorderSizePixel = 0
			btn2.Size = btnWidth
			btn2.Position = count == 2 and UDim2.new(0.5, 2, 0, 0) or UDim2.new(0, 0, 0, 0)
			btn2.AutoButtonColor = false
			btn2.Parent = buttonContainer

			local c2 = Instance.new("UICorner")
			c2.CornerRadius = UDim.new(0, 4)
			c2.Parent = btn2

			if options.Op2.Icon then
				local icn = Instance.new("ImageLabel")
				icn.Image = "rbxassetid://" .. tostring(options.Op2.Icon)
				icn.Size = UDim2.new(0, 14, 0, 14)
				icn.Position = UDim2.new(0, 6, 0.5, -7)
				icn.BackgroundTransparency = 1
				icn.Parent = btn2
			end

			btn2.MouseButton1Click:Connect(function()
				if options.Op2.Callback then options.Op2.Callback() end
				gui:Destroy()
			end)

			table.insert(btns, btn2)
		end

		-- Hover effect
		for _, btn in ipairs(btns) do
			btn.MouseEnter:Connect(function()
				btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			end)
			btn.MouseLeave:Connect(function()
				btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			end)
		end

		-- Sem auto-destruição se houver opções
		return { Destroy = function() if gui.Parent then gui:Destroy() end end }
	end

	-- Notificação simples (sem opções): auto-destrói
	local TS = game:GetService("TweenService")
	TS:Create(frame, TweenInfo.new(0.3), { BackgroundTransparency = 0 }):Play()
	TS:Create(titleLbl, TweenInfo.new(0.3), { TextTransparency = 0 }):Play()
	TS:Create(descLbl, TweenInfo.new(0.3), { TextTransparency = 0 }):Play()

	delay(4, function()
		if not frame.Parent then return end
		TS:Create(frame, TweenInfo.new(0.3), { BackgroundTransparency = 1 }):Play()
		TS:Create(titleLbl, TweenInfo.new(0.3), { TextTransparency = 1 }):Play()
		TS:Create(descLbl, TweenInfo.new(0.3), { TextTransparency = 1 }):Play()
		delay(0.3, function()
			if frame.Parent then gui:Destroy() end
		end)
	end)

	return { Destroy = function() if gui.Parent then gui:Destroy() end end }
end

return Notify
