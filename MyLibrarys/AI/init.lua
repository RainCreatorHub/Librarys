-- DoorLib/init.lua
local DoorLib = {}

DoorLib.Components = {
	Window = require(script.src.Components.Window),
	Notify = require(script.src.Components.Notify),
	KeySystem = require(script.src.Components.KeySystem)
}

function DoorLib:MakeWind(config)
	config = config or {}
	return DoorLib.Components.Window.new(config, self)
end

function DoorLib:Notify(title, desc, time)
	return DoorLib.Components.Notify.new(title, desc, time)
end

return DoorLib
