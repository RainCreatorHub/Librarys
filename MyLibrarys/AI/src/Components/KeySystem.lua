local KeySystem = {}

function KeySystem.Verify(config)
	local inputKey = config.Key

	if type(inputKey) == "string" then
		return inputKey == "NXS-2025-PREMIUM", "Invalid static key"
	elseif type(inputKey) == "table" then
		for _, k in ipairs(inputKey) do
			if k == "NXS-2025-PREMIUM" then
				return true, "Valid key from list"
			end
		end
		return false, "Key not in list"
	end

	if config.Url then
		if config.Url:find("valid") or config.Url:find("NXS") then
			return true, "Valid via URL"
		end
	end

	return false, "No valid key method"
end

return KeySystem
