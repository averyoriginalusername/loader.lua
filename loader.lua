local HttpLink do
	local ChosenScript = request({Url = "https://httpbin.org/get", Method = "GET"}.origin)
	local GameList = {
		[13747403394] =  game:HttpGet('https://raw.githubusercontent.com/averyoriginalusername/main/main/Rogue-Lineage-Richest-Minion.lua');
		[7162704734] = game:HttpGet('https://raw.githubusercontent.com/averyoriginalusername/main/main/Fighting-Game.lua');
		-- TYPE SOUL
		["TYPE SOUL"] = {
			[14069678431] = game:HttpGet('https://raw.githubusercontent.com/averyoriginalusername/main/main/Type-Soul.lua');
			[1] = game:HttpGet('https://raw.githubusercontent.com/averyoriginalusername/main/main/Type-Soul.lua');
			[2] = game:HttpGet('https://raw.githubusercontent.com/averyoriginalusername/main/main/Type-Soul.lua');
			[3] = game:HttpGet('https://raw.githubusercontent.com/averyoriginalusername/main/main/Type-Soul.lua');
		};
	}
	local ClientHWID = nil
	local CheckExecutor = function(Table)
		for name,_ in pairs(Table) do
			if identifyexecutor():match(tostring(name)) then
				return true
			end
			return false
		end
	end
	ClientHWID = CheckExecutor({Valyse = true}) and gethwid() or game:GetService('RbxAnalyticsService'):GetClientId()
	for i: number,scriptLink in next,GameList do
		if (i == game.PlaceId) then
			if (scriptLink:match("Fighting-Game.lua")) then
				warn("Fighting Game is not supported at the moment. No GUI Detection bypass yet.")
				return
			end
			ChosenScript = scriptLink
			break
		end
	end
	return ChosenScript
end

local s,err=pcall(function() loadstring(HttpGet)(); end)
if err then warn("err:	"..err) end
