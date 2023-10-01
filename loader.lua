local _HttpGet = "return warn('no script supported for ur game')"
local HttpLink do
	local GameList = {
		[13747403394] =  game:HttpGet('https://raw.githubusercontent.com/averyoriginalusername/main/main/Rogue-Lineage-Richest-Minion.lua');
		[7162704734] = game:HttpGet('https://raw.githubusercontent.com/averyoriginalusername/main/main/Fighting-Game.lua');
		[13772394625] = game:HttpGet('https://raw.githubusercontent.com/averyoriginalusername/main/main/Blade-Ball.lua');
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
			if (scriptLink:match('Fighting-Game.lua')) then
				if CheckExecutor({Valyse = true}) then
					loadstring(game:HttpGet('https://raw.githubusercontent.com/Tamim468/Valyseonly/main/synsupport.lua'))();
				else
					warn('Fighting Game is not supported for other executors except from Valyse at the moment.')
					return
				end
			end
			_HttpGet = scriptLink
            break
		end
	end
end
xpcall(function()
    loadstring(_HttpGet)();
end,function(err)
    warn("error, %s"):format(err)
end)
