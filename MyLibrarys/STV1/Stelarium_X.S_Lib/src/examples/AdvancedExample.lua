local Library = loadstring(game:HttpGet("URL"))()

local advancedWindow = Library:MakeWindow({
	Name = "Painel de Controle",
	Size = UDim2.new(0, 300, 0, 200)
})

if advancedWindow then
	local label = Instance.new("TextLabel")
	label.Text = "Janela customizada!"
	label.Size = UDim2.new(1, 0, 1, -30)
	label.Position = UDim2.new(0, 0, 0, 30)
	label.TextColor3 = Color3.new(1, 1, 1)
	label.BackgroundTransparency = 1
	label.Parent = advancedWindow
	
	print("Janela avançada criada com sucesso!")
end
