local Section = {}

function Section.new(parent, config)
	config = config or {}
	local name = config.Name or "Section"
	local icon = config.Icon
	local locked = config.Locked == true

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 0, 32)
	frame.BackgroundTransparency = 1
	frame.Parent = parent

	local content = Instance.new("Frame")
	content.Size = UDim2.new(1, 0, 1, 0)
	content.BackgroundTransparency = 1
	content.Position = UDim2.new(0, 0, 1, 4)
	content.Parent = frame

	local layout = Instance.new("UIListLayout")
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 4)
	layout.Parent = content

	local titleFrame = Instance.new("Frame")
	titleFrame.Size = UDim2.new(1, 0, 0, 24)
	titleFrame.BackgroundTransparency = 1
	titleFrame.Parent = frame

	local titleText = Instance.new("TextLabel")
	titleText.Text = name
	titleText.TextColor3 = locked and Color3.fromRGB(100, 100, 100) or Color3.fromRGB(120, 100, 255)
	titleText.TextSize = 13
	titleText.Font = Enum.Font.GothamBold
	titleText.BackgroundTransparency = 1
	titleText.Size = UDim2.new(1, -24, 1, 0)
	titleText.Position = UDim2.new(0, 4, 0, 0)
	titleText.Parent = titleFrame

	if icon then
		local iconLabel = Instance.new("ImageLabel")
		iconLabel.Image = type(icon) == "string" and icon or ("rbxassetid://" .. tostring(icon))
		iconLabel.Size = UDim2.new(0, 16, 0, 16)
		iconLabel.Position = UDim2.new(1, -20, 0.5, -8)
		iconLabel.BackgroundTransparency = 1
		iconLabel.Parent = titleFrame
	end

	if locked then
		local lock = Instance.new("TextLabel")
		lock.Text = "🔒"
		lock.TextSize = 14
		lock.Font = Enum.Font.SourceSans
		lock.TextColor3 = Color3.fromRGB(180, 180, 180)
		lock.BackgroundTransparency = 1
		lock.Size = UDim2.new(0, 20, 1, 0)
		lock.Position = UDim2.new(1, -20, 0, 0)
		lock.Parent = titleFrame
	end

	function frame:AddLabel(cfg)
		return require(script.Parent.Label).new(content, cfg)
	end

	function frame:AddParagraph(cfg)
		return require(script.Parent.Paragraph).new(content, cfg)
	end

	return frame
end

return Section
