local WindowModule = require(script.components.Window)

local Stelarium_X_S_Lib = {}

function Stelarium_X_S_Lib:MakeWindow(Info)
	return WindowModule:MakeWindow(Info)
end

return Stelarium_X_S_Lib
