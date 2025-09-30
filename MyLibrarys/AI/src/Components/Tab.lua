local Section = require(script.Parent.Parent.Elements.Section)
local Label = require(script.Parent.Parent.Elements.Label)
local Paragraph = require(script.Parent.Parent.Elements.Paragraph)

local Tab = {}
Tab.__index = Tab

function Tab.new(parentContainer, config)
	local self = setmetatable({}, Tab)
	config = config or {}

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 1, 0)
	frame.BackgroundTransparency = 1
	frame.Visible = false
	frame.Parent = parentContainer

	local mainContent = Instance.new("Frame")
	mainContent.Size = UDim2.new(1, 0, 1, 0)
	mainContent.BackgroundTransparency = 1
	mainContent.Parent = frame

	local layout = Instance.new("UIListLayout")
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 4)
	layout.Parent = mainContent

	self.Container = frame
	self.MainContent = mainContent
	self.Sections = {}

	function self:Section(cfg)
		cfg = cfg or {}
		local sec = Section.new(self.MainContent, cfg)
		table.insert(self.Sections, sec)
		self.Container.Visible = true
		return sec
	end

	function self:Label(cfg)
		cfg = cfg or {}
		local target = #self.Sections > 0 and self.Sections[#self.Sections] or self.MainContent
		local el = Label.new(target, cfg)
		self.Container.Visible = true
		return el
	end

	function self:Paragraph(cfg)
		cfg = cfg or {}
		local target = #self.Sections > 0 and self.Sections[#self.Sections] or self.MainContent
		local el = Paragraph.new(target, cfg)
		self.Container.Visible = true
		return el
	end

	return self
end

return Tab
