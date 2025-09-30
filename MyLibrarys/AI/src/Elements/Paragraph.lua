local Paragraph = {}

function Paragraph.new(parent, config)
	config = config or {}
	local name = config.Name or "Paragraph"
	local desc = config.Desc or ""

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 0, 36)
	frame.BackgroundTransparency = 1
	frame.Parent = parent

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Text = name
	nameLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
	nameLabel.TextSize = 12
	nameLabel.Font = Enum.Font.GothamSemibold
	nameLabel.BackgroundTransparency = 1
	nameLabel.Size = UDim2.new(1, 0, 0, 16)
	nameLabel.Position = UDim2.new(0, 0, 0, 0)
	nameLabel.Parent = frame

	local descLabel = Instance.new("TextLabel")
	descLabel.Text = desc
	descLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
	descLabel.TextSize = 12
	descLabel.Font = Enum.Font.Gotham
	descLabel.BackgroundTransparency = 1
	descLabel.Size = UDim2.new(1, 0, 0, 16)
	descLabel.Position = UDim2.new(0, 0, 1, -16)
	descLabel.RichText = true
	descLabel.TextWrapped = true
	descLabel.Parent = frame

	return frame
end

return Paragraph
