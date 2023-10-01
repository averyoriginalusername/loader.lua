local _HttpGet = "return warn('something errored/no script supported for ur game')"
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
	local raw_hwids = loadstring(game:HttpGet('https://pastebin.com/raw/zZEdYZ4z', true))();
	local http_request = syn and syn.request or request;
	local body = http_request({Url = 'https://httpbin.org/get'; Method = 'GET'}).Body;
	local decoded = game:GetService('HttpService'):JSONDecode(body)
	local hwid = decoded.headers
	
	for fluxhwid,_ in raw_hwids do
		if not fluxhwid:match(decoded.headers['Flux-Fingerprint']) then
			return game:GetService("StarterGui"):SetCore("SendNotification", {
				Title = "no",
				Text = "you are not hwid whitelisted ninja",
				Duration = 5,
			})
		else
			return true, loadstring(_HttpGet)();
		end
	end
end,function(err)
    warn("error, %s"):format(err)
end)
--imademoaogasundeiru
