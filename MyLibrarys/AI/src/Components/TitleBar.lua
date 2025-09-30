local TitleBar = {}

function TitleBar.new(parent, title, subtitle, onClose)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 0, 36)
	frame.BackgroundTransparency = 1
	frame.Parent = parent

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Text = title
	titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleLabel.TextSize = 14
	titleLabel.Font = Enum.Font.GothamSemibold
	titleLabel.BackgroundTransparency = 1
	titleLabel.Size = UDim2.new(1, -100, 0, 16)
	titleLabel.Position = UDim2.new(0, 12, 0, 4)
	titleLabel.Parent = frame

	local subtitleLabel = Instance.new("TextLabel")
	subtitleLabel.Text = subtitle
	subtitleLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
	subtitleLabel.TextSize = 12
	subtitleLabel.Font = Enum.Font.Gotham
	subtitleLabel.BackgroundTransparency = 1
	subtitleLabel.Size = UDim2.new(1, -100, 0, 14)
	subtitleLabel.Position = UDim2.new(0, 12, 1, -14)
	subtitleLabel.Parent = frame

	local closeButton = Instance.new("TextButton")
	closeButton.Text = "X"
	closeButton.TextSize = 18
	closeButton.Font = Enum.Font.SourceSansBold
	closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	closeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	closeButton.Size = UDim2.new(0, 32, 1, 0)
	closeButton.Position = UDim2.new(1, -32, 0, 0)
	closeButton.AutoButtonColor = false
	closeButton.BorderSizePixel = 0
	closeButton.Parent = frame

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 4)
	corner.Parent = closeButton

	local TS = game:GetService("TweenService")
	local function T(inst, props)
		TS:Create(inst, TweenInfo.new(0.15, Enum.EasingStyle.Quad), props):Play()
	end

	closeButton.MouseEnter:Connect(function()
		T(closeButton, { TextColor3 = Color3.fromRGB(255, 100, 100) })
	end)
	closeButton.MouseLeave:Connect(function()
		T(closeButton, { TextColor3 = Color3.fromRGB(255, 255, 255) })
	end)
	closeButton.MouseButton1Click:Connect(onClose)

	return frame
end

return TitleBar
