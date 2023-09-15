local _HttpGet = nil
local HttpLink do
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
local s,err=pcall(function()loadstring(_HttpGet)();end)
if err then warn("err:	"..err);end
