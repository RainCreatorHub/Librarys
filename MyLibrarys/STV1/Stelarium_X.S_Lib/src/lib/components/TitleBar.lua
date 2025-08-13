local TitleBar = {}

function TitleBar.new(titleText, windowFrame)
	local titleBarFrame = Instance.new("Frame")
	titleBarFrame.Name = "TitleBar"
	titleBarFrame.Size = UDim2.new(1, 0, 0, 30)
	titleBarFrame.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
	titleBarFrame.Parent = windowFrame

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "TitleLabel"
	titleLabel.Size = UDim2.new(1, -45, 1, 0)
	titleLabel.Position = UDim2.fromOffset(15, 0)
	titleLabel.Text = titleText
	titleLabel.Font = Enum.Font.SourceSansBold
	titleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.BackgroundTransparency = 1
	titleLabel.Parent = titleBarFrame

	local closeButton = Instance.new("TextButton")
	closeButton.Name = "CloseButton"
	closeButton.Size = UDim2.new(0, 30, 0, 30)
	closeButton.Position = UDim2.new(1, -30, 0, 0)
	closeButton.Text = "X"
	closeButton.Font = Enum.Font.SourceSansBold
	closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	closeButton.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
	closeButton.BackgroundTransparency = 0.2
	closeButton.Parent = titleBarFrame
	closeButton.MouseButton1Click:Connect(function() windowFrame.Parent:Destroy() end)

	local UserInputService = game:GetService("UserInputService")
	local dragging, dragStart, startPosition
	titleBarFrame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging, dragStart, startPosition = true, input.Position, windowFrame.Position
			return Enum.ContextActionResult.Sink
		end
	end)
	titleBarFrame.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			windowFrame.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
		end
	end)
end

return TitleBar
