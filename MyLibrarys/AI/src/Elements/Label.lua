local Label = {}

function Label.new(parent, config)
	config = config or {}
	local name = config.Name or "Label"
	local desc = config.Desc or ""

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 0, 24)
	frame.BackgroundTransparency = 1
	frame.Parent = parent

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Text = name
	nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	nameLabel.TextSize = 13
	nameLabel.Font = Enum.Font.Gotham
	nameLabel.BackgroundTransparency = 1
	nameLabel.Size = UDim2.new(1, -80, 1, 0)
	nameLabel.Position = UDim2.new(0, 0, 0, 0)
	nameLabel.Parent = frame

	if desc ~= "" then
		local descLabel = Instance.new("TextLabel")
		descLabel.Text = desc
		descLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
		descLabel.TextSize = 12
		descLabel.Font = Enum.Font.Gotham
		descLabel.BackgroundTransparency = 1
		descLabel.Size = UDim2.new(0, 70, 1, 0)
		descLabel.Position = UDim2.new(1, -70, 0, 0)
		descLabel.Parent = frame
	end

	return frame
end

return Label
