local http_request = game:HttpGet('https://pastebin.com/raw/ymTEAzmy1')
local scriptKeys = game:GetService('HttpService'):JSONDecode(http_request).validScriptKeys
local ClientHWID = nil
local HasKey = nil

local CheckExecutor = function(Table)
	for name,_ in pairs(Table) do
		if identifyexecutor():match(tostring(name)) then
			return true
		else
			return false
		end
	end
end

ClientHWID = CheckExecutor({Valyse = true}) and gethwid() or game:GetService('RbxAnalyticsService'):GetClientId()
setclipboard(ClientHWID)

for k,v in pairs(scriptKeys) do
	if table.find(v, ClientHWID) and script_Key == k then
		HasKey = true
		break
	end
	if table.find(k, script_Key) then
		warn("Valid Key")
		request({
			Url = 'https://pastebin.com/raw/ymTEAzmy1',
			Method = 'POST',
			Headers = {
				['Content-Type'] = 'application/json'
			},
			Body = game:GetService('HttpService'):JSONEncode(scriptKeys[script_Key].WhitelistedTo == tostring(ClientHWID))
		})
		HasKey = true
		break
	end
end


if HasKey then
	print("loaded")
else
	warn("fake key or tried to do something")
end
