local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
local ConnectionHandler = loadstring(game:HttpGet('https://github.com/averyoriginalusername/main/raw/main/ConnectionManager.lua'))()

local localPlayer = game.Players.LocalPlayer
local PlayerGui = localPlayer:FindFirstChild("PlayerGui")
local Connections = ConnectionHandler.new()
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
getgenv().ExternalSettings = {
    WalkSpeed = 0,
    JumpPower = 0,
}
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "" }),
    Automation = Window:AddTab({ Title = "Automation", Icon = ""}),
    Teleports = Window:AddTab({ Title = "Teleports", Icon = ""}),
    Keybinds = Window:AddTab({ Title = "Keybinds", Icon = ""--[["layers"]] }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

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

local function setCFrameToPart(Part)
    if not localPlayer.Character then return end
    localPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = part.CFrame
end

local function GetCodes()
    return loadstring(game:HttpGet("https://pastebin.com/raw/Urv51Bdt"))()
end


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
    Description = "",
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

Tabs.Main:AddButton({
	Title = "Reset",
	Description = "(used to become lost soul, unbug yourself, etc)",
	Callback = function()
		if localPlayer.Character and localPlayer.Character:FindFirstChild("Head")  then
            localPlayer.Character:FindFirstChild("Head"):Destroy()
        end
	end
})

Tabs.Keybinds:AddParagraph({
    Title = "Keybinds",
    Content = "soon not yet\nwait!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
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
            return setCFrameToPart(workspace.WandenGate:FindFirstChild("WandenGate"))
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
            return setCFrameToPart(workspace.WandenGate:FindFirstChild("SoulGate"))
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

local AdjuchasNotifierToggle = Tabs.Automation:AddToggle("AdjuchasNotifier", {
    Title = "Adjuchas Notifier",
    Default = false
}):OnChanged(function()
    if Options.AutoQueue.Value == true then
        for _,adjucha in pairs(workspace.Entities:GetChildren()) do
            if adjucha.Name:match("Adju") then
                AlertNotification({
                    Title = "lightage",
                    Content = "An adjuchas has spawned in your server: "..adjucha.Name,
                    Duration = 1e9
                })
            end
        end

        Connections:Conn("OnChildAddedAdjuchas", workspace.Entities.ChildAdded:Connect(function(Child)
            if Child.Name:match("Adju") then
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
-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- InterfaceManager (Allows you to have a interface managment system)

-- Hand the library over to our managers
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- You can add indexes of elements the save manager should ignore
SaveManager:SetIgnoreIndexes({})

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
InterfaceManager:SetFolder("lightagev2")
SaveManager:SetFolder("lightagev2/type-soul")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()
Window:SelectTab(1)
