do	
	local GameList = {
		[13747403394] =  loadstring(game:HttpGet("https://raw.githubusercontent.com/averyoriginalusername/main/main/Rogue-Lineage-Richest-Minion.lua"));
		[7162704734] = loadstring(game:HttpGet("https://raw.githubusercontent.com/averyoriginalusername/main/main/Fighting-Game.lua"));
		-- TYPE SOUL
		[14069678431] = loadstring(game:HttpGet("https://raw.githubusercontent.com/averyoriginalusername/main/main/Type-Soul.lua"));
		[1] = loadstring(game:HttpGet("https://raw.githubusercontent.com/averyoriginalusername/main/main/Type-Soul.lua"));
		[2] = loadstring(game:HttpGet("https://raw.githubusercontent.com/averyoriginalusername/main/main/Type-Soul.lua"));
		[3] = loadstring(game:HttpGet("https://raw.githubusercontent.com/averyoriginalusername/main/main/Type-Soul.lua"));
	}
	local MultiplePlaceGames = {
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
	for i: number, scriptLink in next, GameList do
		if i == game.PlaceId then
			return scriptLink()
		end
	end
end
