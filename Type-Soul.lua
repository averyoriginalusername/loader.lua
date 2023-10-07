local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
local ConnectionHandler = loadstring(game:HttpGet('https://github.com/averyoriginalusername/main/raw/main/ConnectionManager.lua'))()

local localPlayer = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera
local PlayerGui = localPlayer:FindFirstChild("PlayerGui")
local Connections = ConnectionHandler.new()
local ESP_Players = {}
local Window = Fluent:CreateWindow({
    Title = "lightage",
    SubTitle = "VERSION 2 (PRIVATE SCRIPT)",
    TabWidth = 160,
    Size = UDim2.fromOffset(620, 360),
    Acrylic = false, 
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.LeftControl
})
--Fluent provides Lucide Icons https://lucide.dev/icons/ for the tabs, icons are optional
local Options = Fluent.Options
local ExternalAssets = game:GetObjects("rbxassetid://14985186166")[1]
getgenv().ExternalSettings = {
    ESPSettings = {
        Player = {
            Color = Color3.new(1, 1, 1),
            TextSize = 15,
            Font = 1,
            Enabled = false,
            ShowFaction = false,
            ShowHealth = false,
        },
        Mobs = {},
    },
    WalkSpeed = 0,
    JumpPower = 0,
    AutoEat = false,
}

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "" }),
    ESP = Window:AddTab({ Title = "ESP", Icon = "" }),
    Automation = Window:AddTab({ Title = "Automation", Icon = ""}),
    Teleports = Window:AddTab({ Title = "Teleports", Icon = ""}),
    Keybinds = Window:AddTab({ Title = "Keybinds", Icon = ""--[["layers"]] }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local find = string.find
local ceil = math.ceil
local function AlertNotification(Data)
    Fluent:Notify(Data)
    task.spawn(function()
        local AlertSound = "rbxassetid://5153734608"
        local SoundInstance = Instance.new("Sound")
        SoundInstance.Parent = workspace
        SoundInstance.Volume = 10
        SoundInstance:Play();SoundInstance.Ended:Connect(function()
            SoundInstance:Destroy()
        end)
    end)
end

local function newDrawing()
    local DrawingObj = Drawing.new("Text")
    DrawingObj.Font = 1
    DrawingObj.Size = 15
    DrawingObj.Visible = false
    DrawingObj.Center = true
    DrawingObj.Color = Color3.new(1, 1, 1)
    return DrawingObj
end

local function setCFrameToPart(Part)
    if not localPlayer.Character then return end
    localPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = part.CFrame
end

local function getDistance(pointA, pointB)
    return (pointA.Position - pointB.Position).magnitude
end

local function GetFaction(Character)
    for _,child in Character:GetChildren() do
        if child.ClassName == "Shirt" then
            if child.Name:match("ArrancarShirt") then
                return "ARRANCAR"
            elseif child.Name:match("ShinigamiShirt") then
                return "SHINIGAMI"
            elseif child.Name:match("QuincyShirt") then
                return "QUINCY"
            end
        elseif child.ClassName == "LocalScript" then
            if child.Name:match("AnimateFishbone") or child.Name:match("AnimateMenos") or child.Name:match("AnimateAdjuchas") then
                return "HOLLOW"
            end
        end
    end
    return "UNKNOWN"
end

local function GetCodes()
    return loadstring(game:HttpGet("https://pastebin.com/raw/Urv51Bdt"))()
end

for _,v in game.Players:GetPlayers() do
    if v == game.Players.LocalPlayer then continue end
    ESP_Players[v] = newDrawing()
end

game.Players.PlayerAdded:Connect(function(Player)
    ESP_Players[Player] = newDrawing()
end)
game.Players.PlayerRemoving:Connect(function(Player)
    ESP_Players[Player]:Remove();ESP_Players[Player] = nil
end)

local NoclipToggle = Tabs.Main:AddToggle("NoclipToggle", {
    Title = "Enable Noclip",
    Default = false
}):OnChanged(function()
    if Options.NoclipToggle.Value == true then
        Connections:Conn("NoclipConnection", game:GetService("RunService").RenderStepped:Connect(function()
            if not localPlayer.Character then
                return
            end
    
            for i,v in localPlayer.Character:GetChildren() do
                if v:IsA("BasePart") == true then
                    v.CanCollide = false
                end
            end
        end))
    else
        if Connections:Disconnect("NoclipConnection") then
            localPlayer.Character.Torso.CanCollide = true
        end
    end
end)

local OldWalkspeed = localPlayer.Character:FindFirstChild("Humanoid").WalkSpeed
local WalkspeedToggle = Tabs.Main:AddToggle("WalkspeedToggle", {
    Title = "Enable WalkSpeed",
    Default = false
}):OnChanged(function()
    if Options.WalkspeedToggle.Value == true then
        Connections:Conn("WalkspeedConnection", game:GetService("RunService").RenderStepped:Connect(function()
            localPlayer.Character:FindFirstChild("Humanoid").WalkSpeed = getgenv().ExternalSettings.WalkSpeed
        end))
    else
        if Connections:Disconnect("WalkspeedConnection") then
            localPlayer.Character:FindFirstChild("Humanoid").WalkSpeed = OldWalkspeed
        end
    end
end)
local WalkspeedSlider = Tabs.Main:AddSlider("WalkspeedSlider", {
    Title = "WalkSpeed",
    Default = 1,
    Min = 1,
    Max = 150,
    Rounding = 1,
    Callback = function(Value)
        getgenv().ExternalSettings.WalkSpeed = Value
    end
})

local OldWalkspeed = localPlayer.Character:FindFirstChild("Humanoid").WalkSpeed
local InfiniteJumpToggle = Tabs.Main:AddToggle("InfiniteJumpToggle", {
    Title = "Enable Infinite Jump",
    Default = false
}):OnChanged(function()
    if Options.InfiniteJumpToggle.Value == true then
        local HumanoidRootPart =  game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local UserInputService = game:GetService("UserInputService")     
        Connections:Conn("InfJumpConnection", game:GetService("RunService").RenderStepped:Connect(function()
            local NewBV 
            while UserInputService:IsKeyDown("Space") do wait()
                if not HumanoidRootPart:FindFirstChild(".") then
                    NewBV = Instance.new("BodyVelocity")
                    NewBV.Name = "."
                    NewBV.MaxForce = Vector3.new(0, math.huge, 0)
                    NewBV.Velocity = Vector3.new(0, getgenv().ExternalSettings.JumpPower, 0)
                    NewBV.Parent = HumanoidRootPart
                end
            end
            if NewBV then
                NewBV:Destroy()
            end
        end))
    else
        Connections:Disconnect("InfJumpConnection")
    end
end)
local InfiniteJumpSlider = Tabs.Main:AddSlider("InfiniteJumpSlider", {
    Title = "Infinite Jump",
    Description = "",
    Default = 1,
    Min = 1,
    Max = 100,
    Rounding = 1,
    Callback = function(Value)
        getgenv().ExternalSettings.JumpPower = Value
    end
})

local HoldM1Toggle = Tabs.Main:AddToggle("HoldM1Toggle", {
    Title = "Enable Hold M1",
    Default = false
}):OnChanged(function()
    if Options.HoldM1Toggle.Value == true then
        local M1Down = false
        Connections:Conn("OnMouseDown", game:GetService("UserInputService").InputBegan:Connect(function(Input, _GPE)
            if _GPE then return end

            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                M1Down = true
                warn("down")
                return
            end
        end));Connections:Conn("OnMouseUp", game:GetService("UserInputService").InputEnded:Connect(function(Input, _GPE)
            if _GPE then return end

            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                M1Down = false
                warn("up")
                return
            end
        end))

        while task.wait(0.25) do
            if not localPlayer.Character:FindFirstChild("CharacterHandler") then
                return
            end
            if M1Down == true then
                game.ReplicatedStorage.Remotes.ServerCombatHandler:FireServer("LightAttack")
            end
        end
    else
        Connections:Disconnect("OnMouseUp");Connections:Disconnect("OnMouseDown")
    end
end)
--[[
local ChatLoggerInstance = false
local HoldM1Toggle = Tabs.Main:AddToggle("EnableChatLogger", {
    Title = "Enable Chat Logger",
    Default = false
}):OnChanged(function()
    if Options.EnableChatLogger.Value == true then
        local ChatLogger = ExternalAssets.ChatLogger:Clone()
        ChatLogger.DragFrame.Draggable = true
        ChatLogger.Name = game:GetService("HttpService"):GenerateGUID(false)
    else
       if ChatLogger then
         ChatLogger:Destroy();
         task.wait();
         ChatLogger = false 
        end 
    end
end)--]]

Tabs.Main:AddButton({
	Title = "Reset",
	Description = "(used to become lost soul, unbug yourself, etc)",
	Callback = function()
		if localPlayer.Character and localPlayer.Character:FindFirstChild("Head")  then
            localPlayer.Character:FindFirstChild("Head"):Destroy()
        end
	end
})

Tabs.ESP:AddParagraph({
    Title = "Player ESP",
    Description = "Player ESP"
})

local EnablePlayerESP = Tabs.ESP:AddToggle("EnablePlayerESP", {
    Title = "Enabled",
    Default = false
}):OnChanged(function()
    getgenv().ExternalSettings.ESPSettings.Player.Enabled = Options.EnablePlayerESP.Value
end)

local PlayerESPColor = Tabs.ESP:AddColorpicker("PlayerESPColor", {
    Title = "Player ESP Color",
    Default = Color3.fromRGB(1, 1, 1)
}):OnChanged(function()
    getgenv().ExternalSettings.ESPSettings.Player.Color = Options.PlayerESPColor.Value
end)

local InfiniteJumpSlider = Tabs.ESP:AddSlider("ESPTextSize", {
    Title = "Text Size",
    Default = 10,
    Min = 10,
    Max = 30,
    Rounding = 0,
    Callback = function(Value)
        getgenv().ExternalSettings.ESPSettings.Player.TextSize = Value
    end
})

local ESPFontDropdown = Tabs.ESP:AddDropdown("ESPFontDropdown", {
    Title = "Text Font",
    Values = {1, 2, 3},
    Multi = false,
    Default = 1,
}):OnChanged(function()
    getgenv().ExternalSettings.ESPSettings.Player.Font = Options.ESPFontDropdown.Value
end)

local ShowPlayerHealth = Tabs.ESP:AddToggle("ShowPlayerHealthESP", {
    Title = "Show Health",
    Default = false
}):OnChanged(function()
    getgenv().ExternalSettings.ESPSettings.Player.ShowHealth = Options.ShowPlayerHealthESP.Value
end)

local ShowPlayerFactions = Tabs.ESP:AddToggle("ShowPlayerFactionsESP", {
    Title = "Show Factions",
    Default = false
}):OnChanged(function()
    getgenv().ExternalSettings.ESPSettings.Player.ShowFaction = Options.ShowPlayerFactionsESP.Value
end)

local WalkspeedToggleBind = Tabs.Keybinds:AddKeybind("WalkspeedToggleKeybind", {
    Title = "WalkSpeed Keybind",
    Mode = "Toggle", -- Always, Toggle, Hold
    Default = "F1", -- String as the name of the keybind (MB1, MB2 for mouse buttons)

    -- Occurs when the keybind is clicked, Value is `true`/`false`
    Callback = function(Value)
        Options.WalkspeedToggle:SetValue(not Options.WalkspeedToggle.Value)
    end,
})

local InfiniteJumpKeybind = Tabs.Keybinds:AddKeybind("InfiniteJumpKeybind", {
    Title = "Infinite Jump Keybind",
    Mode = "Toggle", -- Always, Toggle, Hold
    Default = "F2", -- String as the name of the keybind (MB1, MB2 for mouse buttons)

    -- Occurs when the keybind is clicked, Value is `true`/`false`
    Callback = function(Value)
        Options.InfiniteJumpToggle:SetValue(not Options.InfiniteJumpToggle.Value)
    end,
})

local NoclipKeybind = Tabs.Keybinds:AddKeybind("NoclipKeybind", {
    Title = "Noclip Keybind",
    Mode = "Toggle", -- Always, Toggle, Hold
    Default = "F3", -- String as the name of the keybind (MB1, MB2 for mouse buttons)

    -- Occurs when the keybind is clicked, Value is `true`/`false`
    Callback = function(Value)
        Options.NoclipToggle:SetValue(not Options.NoclipToggle.Value)
    end,
})


Tabs.Teleports:AddButton({
	Title = "Tween To Kisuke",
	Description = "(Become a soul reaper as a lost soul)",
	Callback = function()
		local inTween = false
        local Tween = game:GetService("TweenService"):Create(localPlayer.Character.HumanoidRootPart, TweenInfo.new(10, Enum.EasingStyle.Linear), {CFrame = workspace.NPCs.Kisuke.Kisuke:FindFirstChild("HumanoidRootPart").CFrame})

        if inTween == false then
            inTween = true
            Tween:Play(); Tween.Completed:Connect(function()
                task.wait(1)
                inTween = false
            end)
        end
	end
})

Tabs.Teleports:AddButton({
	Title = "Teleport To Wanden",
	Callback = function()
        if not (game.PlaceId == 14069678431) then
            return Fluent:Notify({
                Title = "lightage",
                Content = "You must be in Karakura.",
                Duration = 15
            })
        end
		if workspace:FindFirstChild("WandenGate") and workspace.WandenGate:GetChildren()  then
            return setCFrameToPart(workspace.WandenreichGate:FindFirstChild("WandenGate"))
        end
	end
})

Tabs.Teleports:AddButton({
	Title = "Teleport To Soul Society",
	Callback = function()
        if not (game.PlaceId == 14069678431) then
            return Fluent:Notify({
                Title = "lightage",
                Content = "You must be in Karakura.",
                Duration = 15
            })
        end
		if workspace:FindFirstChild("SoulGate") and workspace.WandenGate:GetChildren()  then
            return setCFrameToPart(workspace.SoulGate:FindFirstChild("SoulGate"))
        end
	end
})

Tabs.Automation:AddParagraph({
    Title = "WARNING:",
    Content = "YOU ARE AT RISK OF GETTING BANNED IN MULTIPLE WAYS, TO AVOID THIS, PLEASE PLAY IN LOWER SERVERS (3-5 PEOPLE), AND TRY NOT TO TELEPORT/TWEEN TO PLACES WITHIN A SHORT TIME SPAN. YOU MAY GET AA-GUNNED."
})
local AutoCreateParty = Tabs.Automation:AddToggle("AutoCreateParty", {
    Title = "Auto-Create Party",
    Default = false
}):OnChanged(function()
    if Options.AutoCreateParty.Value == true then
        Connections:Conn('AutoCreate_Party', game:GetService("RunService").RenderStepped:Connect(function()
            local MissionsUI = PlayerGui:FindFirstChild("MissionsUI")

            if not PlayerGui then
                return
            end
            if not MissionsUI then
                return
            end

            if MissionsUI.CreatePartyFrame.CreateParty.Visible == true then
                game.Players.LocalPlayer.Character:FindFirstChild("CharacterHandler").Remotes.PartyCreate:FireServer()
            end
        end))
    else
        Connections:Disconnect("AutoCreate_Party")
    end
end)

local InAction = false
local AutoCreateParty = Tabs.Automation:AddToggle("AutoQueue", {
    Title = "Auto-Queue For Mission",
    Description = "(TELEPORTS YOU TO A MISSION BOARD, MAY BE RISKY IF TELEPORTED WITHIN A SHORT TIME SPAN)",
    Default = false
}):OnChanged(function()
    if Options.AutoQueue.Value == true then
        Connections:Conn('AutoQueue', game:GetService("RunService").RenderStepped:Connect(function()
            local QueueUI = PlayerGui:FindFirstChild("QueueUI")
            local MissionsUI = PlayerGui:FindFirstChild("MissionsUI")
            local TextThingy = MissionsUI:FindFirstChild("Queueing")
            if MissionsUI.CreatePartyFrame.CreateParty.Visible == true  then
                return Fluent:Notify({
                    Title = "lightage",
                    Content = "You are not in a party.",
                    Duration = 5
                }), Options.AutoQueue:SetValue(false), Connections:Disconnect('AutoQueue')
            end
            if not QueueUI then
                return
            end
            if InAction then
                return
            end
            if not localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                return
            end
            if QueueUI.Enabled == true then
                return
            end
            if QueueUI.Enabled == false then
                repeat
                    InAction = true
                    localPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = workspace.NPCs.MissionNPC:FindFirstChild("MissionBoard"):FindFirstChild("Board"):FindFirstChild("Union").CFrame
                    task.wait(0.0001)
                    for _,missionboard in workspace.NPCs.MissionNPC:GetChildren() do
						if missionboard:FindFirstChild("Board") then
							local SelectedBoard = missionboard:FindFirstChild("Board"):FindFirstChild("Union")
							if (localPlayer.Character.HumanoidRootPart.Position - SelectedBoard.Position).magnitude <= 32 then
								fireclickdetector(SelectedBoard:FindFirstChildWhichIsA("ClickDetector"))
								onChildAdded = localPlayer.ChildAdded:Connect(function(Child)
									if Child:IsA("RemoteEvent") == true and Child.Name == "MissionBoard" then
										task.wait(1/2)
										Child:FireServer("Yes")
										onChildAdded:Disconnect()
									end
								end)
							else
								break
							end
						end
					end

                    task.wait(5)
                    InAction = false
                until QueueUI.Enabled == true or Queueing.Visible == true
            end
        end))
    else
        Connections:Disconnect('AutoQueue')
    end
end)

local IsTweening = false;
Tabs.Automation:AddButton({
	Title = "Tween To Mission Board",
	Description = "(TWEENS TO A MISSION BOARD AND QUEUES, SAFER OPTION)",
	Callback = function()
		local MissionsUI = PlayerGui:FindFirstChild("MissionsUI")
		if IsTweening then return end
		if MissionsUI.CreatePartyFrame.CreateParty.Visible == true then
			return Window:Dialog({
				Title = "Error;",
				Content = "You are not in a party - turn on Auto-Create, or make a party",
				Buttons = {{Title = "ok", Callback = function()
					print("Confirmed the dialog.")
				end},
				}
			})  
		else
			IsTweening = true
            local TweenObj;
			local Tween;

            for _,v in pairs(workspace.NPCs.MissionNPC:GetChildren()) do
                if v:IsA("Model") == true then
                    table.foreach(v:GetChildren(), warn)
                    local BoardUnion = v:FindFirstChild("Board") and v.Board:FindFirstChild("Union")
                    if (localPlayer.Character:FindFirstChild("HumanoidRootPart").Position - BoardUnion.Position).magnitude < math.huge then
                        Tween = game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(15, Enum.EasingStyle.Linear), {CFrame = BoardUnion.CFrame})
                        Tween:Play()
                    end
                end
            end
            Tween:Play();Tween.Completed:Connect(function()
				local onChildAdded = nil
				task.delay(1, function()
					for _,missionboard in pairs(workspace.NPCs.MissionNPC:GetChildren()) do
						if missionboard:FindFirstChild("Board") then
							local SelectedBoard = missionboard:FindFirstChild("Board"):FindFirstChild("Union")
							if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - SelectedBoard.Position).magnitude <= 32 then
								fireclickdetector(SelectedBoard:FindFirstChildWhichIsA("ClickDetector"))
								onChildAdded = game.Players.LocalPlayer.ChildAdded:Connect(function(Child)
									if Child:IsA("RemoteEvent") == true and Child.Name == "MissionBoard" then
										task.wait(1/2)
										Child:FireServer("Yes")
										IsTweening = false
										onChildAdded:Disconnect()
									end
								end)
							else
								IsTweening = false
                                onChildAdded:Disconnect()
								break
							end
						end
					end
				end)
			end)
			game.Players.LocalPlayer.PlayerGui.DialogueUI.dialogueFrame.Visible = false
		end
	end
})

local CodeOutput = {Successful = {};Invalid = {}}
Tabs.Automation:AddButton({
	Title = "Redeem Valid Codes",
    Description = "(will provide an output on successful/invalid codess)",
	Callback = function()
        if not localPlayer.Character then return end
        CodeOutput.Successful = {};CodeOutput.Invalid = {}
        local CodesList = GetCodes()
        for code,_ in next,CodesList do
            local _CodeResponse = localPlayer.Character:FindFirstChild("CharacterHandler").Remotes:FindFirstChild("Codes"):InvokeServer(tostring(code))
            if _CodeResponse then
                table.insert(CodeOutput.Successful, true)
            else
                table.insert(CodeOutput.Invalid, true)
            end
            task.wait(0.01)
        end
        Fluent:Notify({
            Title = "lightage",
            Content = "Codes Redeemed: \nSuccessful: "..#CodeOutput.Successful.."\nInvalid: "..#CodeOutput.Invalid,
            Duration = 15
        })
	end
})

local AutoEatFood = Tabs.Automation:AddToggle("AutoEatFoodToggle", {
    Title = "Auto-Eat",
    Default = false
}):OnChanged(function()
    getgenv().ExternalSettings.AutoEat = Options.AutoEatFoodToggle.Value
    
    while task.wait(0.1) do
        if not getgenv().ExternalSettings.AutoEat then return end

        for _,hollaw in workspace.Entities:GetChildren() do
            if hollaw == nil then return end
            if hollaw:IsA("Model") == true then
                for _,_type in pairs({"Fishbone", "Menos", "Frisker", "Jackal"}) do
                    if hollaw:GetAttribute("EntityID") and hollow:GetAttribute("EntityType") then
                        if find(hollaw:GetAttribute("EntityID"), _type) and find(hollaw:GetAttribute("EntityID"), _type) then
                            local Distance = getDistance(localPlayer.Character:FindFirstChild("HumanoidRootPart"), hollaw.PrimaryPart)
                            if Distance <= 10 then
                                localPlayer.Character:FindFirstChild("CharacterHandler").Remotes.Execute:FireServer()
                            end
                        end
                    end
                end
            end
        end
    end
end)

local AdjuchasNotifierToggle = Tabs.Automation:AddToggle("AdjuchasNotifier", {
    Title = "Adjuchas Notifier",
    Default = false
}):OnChanged(function()
    if Options.AutoQueue.Value == true then
        for _,adjucha in pairs(workspace.Entities:GetChildren()) do
            if adjucha:IsA("Model") == true and adjucha.Name:match("Jackal") then
                AlertNotification({
                    Title = "lightage",
                    Content = "An adjuchas has spawned in your server: "..adjucha.Name,
                    Duration = 1e9
                })
            end
        end

        Connections:Conn("OnChildAddedAdjuchas", workspace.Entities.ChildAdded:Connect(function(Child)
            if Child.Name:match("Jackal") then
                AlertNotification({
                    Title = "lightage",
                    Content = "An adjuchas has spawned in your server: "..Child.Name,
                    Duration = 1e9
                })
            end
        end))
    else
        Connections:Disconnect('OnChildAddedAdjuchas')
    end
end)

local function ESPBind()
    if getgenv().ExternalSettings.ESPSettings.Player.Enabled == true then
        for player,espObj in pairs(ESP_Players) do
            local eCharacter = player.Character or player.CharacterAdded:Wait()
            local PrimaryPart = eCharacter and eCharacter.PrimaryPart
            local eHumanoid = eCharacter and eCharacter:FindFirstChild("Humanoid")

            if PrimaryPart and PrimaryPart ~= nil and PrimaryPart.Parent ~= nil then
                local playerPos,canSee = Camera:WorldToViewportPoint(PrimaryPart.Position)
                if canSee then
                    local formattedText = PrimaryPart.Parent.Name
                    if getgenv().ExternalSettings.ESPSettings.Player.ShowHealth == true then
                        formattedText = formattedText..("\n[%d/%d]"):format(ceil(eHumanoid.Health), ceil(eHumanoid.MaxHealth))
                    end
                    if getgenv().ExternalSettings.ESPSettings.Player.ShowFaction == true then
                        formattedText = formattedText..("\n[%s]"):format(GetFaction(PrimaryPart.Parent))
                    end
                    espObj.Outline = true
                    espObj.Position = Vector2.new(playerPos.X, playerPos.Y)
                    espObj.Font = getgenv().ExternalSettings.ESPSettings.Player.Font
                    espObj.Size = getgenv().ExternalSettings.ESPSettings.Player.TextSize
                    espObj.Color = getgenv().ExternalSettings.ESPSettings.Player.Color
                    espObj.Visible = true
                    espObj.Text = formattedText
                else
                    espObj.Visible = false
                end
            else
                espObj.Visible = false
            end
        end
    else
        for player,espObj in pairs(ESP_Players) do
            espObj.Visible = false
        end
    end 
end

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()

SaveManager:SetIgnoreIndexes({})

InterfaceManager:SetFolder("lightagev2")
SaveManager:SetFolder("lightagev2/type-soul")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

SaveManager:LoadAutoloadConfig()
Window:SelectTab(1)

game:GetService("RunService"):BindToRenderStep("ESP_BindToRenderStep", 20, ESPBind)


local function RecordMessage(Player)
    Player.Chatted:Connect(function(Message)
        warn(("[%s]: %s"):format(Player.Name, Message))
    end)
end

do
    for _,plr in game.Players:GetChildren() do
        RecordMessage(plr)
    end; game.Players.PlayerAdded:Connect(function(plr)
        RecordMessage(plr)
    end)
end
