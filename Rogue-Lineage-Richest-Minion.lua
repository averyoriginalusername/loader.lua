local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local PlayerBackpack = Player:WaitForChild("Backpack")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local CharacterRemotes = Character:WaitForChild("CharacterHandler"):WaitForChild("Remotes")
local GetRemote = game.ReplicatedStorage.Requests:WaitForChild("Get")
local Stations = workspace.Stations

local Settings = {
    ["Client Cheats"] = {
         ["JumpPower"] = 0;
         ["HealthDistance"] = 0;
    };
    ["Auto Farms"] = {
        ["PlayerDetectionThreshold"] = 35;
        ["UseWebhook"] = false;
        ["LogOnScroll"] = {
            IsEnabled = false;
            Scroll = "None";
        };
    }
}

local AmountToCraft = 0
local CurrentlySelected = "None"
local PotionRecipes = {
    ["Health Potion"] = {
        ["Scroom"] = 2;
        ["Lava Flower"] = 1;
    }
}

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
	Name = "Multiware: Richest Minion",
	LoadingTitle = "Loading: Rogue Lineage: Richest Minion...",
	LoadingSubtitle = "by ???",
	ConfigurationSaving = {
		Enabled = true,
		FolderName = "multiwareConfig",
		FileName = "mwRLRMConfig"
	},
})

local ClientTab = Window:CreateTab("Client Modification", 4483362458) -- Title, Image
local ClientSection = ClientTab:CreateSection("Client Cheats")

-- from poorest minion code


local InfJumpConnection = nil
local InfJumpToggle = ClientTab:CreateToggle({
	Name = "Infinite Jump",
	CurrentValue = false,
	Flag = "InfJumpToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Toggle)
        local UserInputService = game:GetService("UserInputService")

        if Toggle == true then
            InfJumpConnection = game:GetService("RunService").RenderStepped:Connect(function()
                local NewBV 
                while UserInputService:IsKeyDown("Space") do wait()
                    if not HumanoidRootPart:FindFirstChild("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa") then
                        NewBV = Instance.new("BodyVelocity")
                        NewBV.Name = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
                        NewBV.MaxForce = Vector3.new(0, math.huge, 0)
                        NewBV.Velocity = Vector3.new(0, Settings["Client Cheats"].JumpPower, 0)
                        NewBV.Parent = HumanoidRootPart
                    end
                end
                if NewBV then
                     NewBV:Destroy()
                end
            end)
        elseif Toggle == false then
            if InfJumpConnection then
                 InfJumpConnection:Disconnect()
             end
        end 
	end,
})
local InfJumpSlider = ClientTab:CreateSlider({
	Name = "Infinite Jump Power",
	Range = {0, 150},
	Increment = 1,
	Suffix = "Jump Power",
	CurrentValue = Settings["Client Cheats"].JumpPower,
	Flag = "JumpPowerSlider", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(SliderValue)
		Settings["Client Cheats"].JumpPower = SliderValue
	end,
})


local BlankSection1 = ClientTab:CreateSection("")

local NoFireConnection = nil
local NoFireToggle = ClientTab:CreateToggle({
    Name = "No Fire",
    CurrentValue = false,
    Flag = "NoFireToggle",
    Callback = function(Toggle)
        if Toggle == true then
            NoFireConnection = Character.ChildAdded:Connect(function(c)
                if c.Name == "Burning" and c:IsA("Accessory") then
                    CharacterRemotes.Dodge:FireServer(0, "normal")
                end
            end)
        elseif Toggle == false then
            if NoFireConnection then
                NoFireConnection:Disconnect()
            end
        end
    end,
})
local BreakJoints = ClientTab:CreateButton({
	Name = "Break Joints (Reset)",
	Callback = function()
        if Player:FindFirstChild("Danger") then return end
		Character:BreakJoints()
	end,
})
local NoInjuriesToggle = ClientTab:CreateButton({
    Name = "No Blindness",
    Callback = function(Toggle)
        if Toggle == true then
            local GetCall = Get:InvokeServer({"Injuries"})
            if GetCall.Injuries:find("dizzy") then
                if Lighting.Blur.Visible == true then
                    Lighting.Blur.Visible = false
                end
            end
        end
    end,
})

local GameVisuals = Window:CreateTab("Game Visuals", 4483362458) -- Title, Image
local ClientSection = GameVisuals:CreateSection("Visuals Cheats")

local healthOnCharacterAdded = nil
local EyesOfElemira = GameVisuals:CreateToggle({
	Name = "Eyes Of Elemira",
	CurrentValue = false,
	Flag = "EOEToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Toggle)
        local ToggleHealthView = function(val)
            for i,v in pairs(workspace.Live:GetDescendants()) do
                if v:IsA("Model") == true then
                    local TargetHumanoid = v:FindFirstChild("Humanoid")
                    if TargetHumanoid then
                    	TargetHumanoid.HealthDisplayDistance = Settings["Client Cheats"].HealthDistance
                        TargetHumanoid.HealthDisplayType = val and Enum.HumanoidHealthDisplayType.AlwaysOn or Enum.HumanoidHealthDisplayType.AlwaysOff
                    end
                end
            end
        end
        
        ToggleHealthView(Toggle)
        healthOnCharacterAdded = workspace.Live.ChildAdded:Connect(function()
            ToggleHealthView(Toggle)
        end)

        if Toggle == false then
            if healthOnCharacterAdded then
                healthOnCharacterAdded:Disconnect()
            end
        end
	end,
})

local ViewHealthDistance = GameVisuals:CreateSlider({
	Name = "View Health Threshold",
	Range = {0, 150},
	Increment = 1,
	Suffix = "Studs",
	CurrentValue = Settings["Client Cheats"].HealthDistance,
	Flag = "ViewHealthDistanceSlider", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(SliderValue)
        Settings["Client Cheats"].HealthDistance = SliderValue
	end,
})

local SecurityTab = Window:CreateTab("Security", 4483362458) -- Title, Image
local NotifierSection = SecurityTab:CreateSection("Notifiers")

local IlluonPlayerAdded = nil
local IllusionistNotifier = SecurityTab:CreateToggle({
	Name = "Illusionist Notifier",
	CurrentValue = false,
	Flag = "IllusionistNotifier", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Toggle)
        local NotifyIllu = function(TargetPlayer)
            local TargetBackpack = TargetPlayer:WaitForChild("Backpack")
            local TargetCharacter = TargetPlayer.Character or TargetPlayer.CharacterAdded:Wait()

            if TargetBackpack:FindFirstChild("Observe") or TargetCharacter:FindFirstChild("Observe") then
                Rayfield:Notify({
                    Title = TargetPlayer.Name.." has Observe!",
                    Content = TargetPlayer.Name.." is an illusionist.",
                    Duration = 1e9,
                    Image = 4483362458,
                    Actions = { -- Notification Buttons
                        Ignore = {
                          Name = "Alright"
                        },
                    },
                 })
            end
        end
        
        if Toggle == true then
            for i,rplayer in next, game.Players:GetChildren() do
                print(rplayer)
                NotifyIllu(rplayer)
            end
            IlluonPlayerAdded = game.Players.PlayerAdded:Connect(function(Player)
                NotifyIllu(Player)
            end)
        elseif Toggle == false then
            if IlluonPlayerAdded then 
                IlluonPlayerAdded:Disconnect()
                print"disconnected"
            end
        end
    end,
})

local SpecNotifierConnection = nil
local SpecNotifierToggle = SecurityTab:CreateToggle({
	Name = "Spec User Notifier",
	CurrentValue = false,
	Flag = "SpecNotifier", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Toggle)
        local NotifySpec = function(TargetPlayer)
            local TargetBackpack = TargetPlayer:WaitForChild("Backpack")
            local TargetCharacter = TargetPlayer.Character or TargetPlayer.CharacterAdded:Wait()

            local specTable = {}

            for i,v in pairs(TargetBackpack:GetChildren()) do
                  if v:IsA("Tool") == true then
                     if v:FindFirstChild("SpecialSkill") then
                         table.insert(specTable, v.Name)
                    end
               end
            end
            
            if #specTable > 0 then
                Rayfield:Notify({
                    Title = TargetPlayer.Name.." has specs!",
                    Content =  TargetPlayer.Name.."has: "..table.concat(specTable, ", "),
                    Duration = 1e9,
                    Image = 4483362458,
                    Actions = { -- Notification Buttons
                        Ignore = {
                            Name = "Alright"
                        },
                    },
                })
                specTable = {}
            end
        end
        
        if Toggle == true then
            for i,rplayer in next, game.Players:GetChildren() do
                NotifySpec(rplayer)
            end
            SpecNotifierConnection = game.Players.PlayerAdded:Connect(function(Player)
                NotifySpec(Player)
            end)
        elseif Toggle == false then
            if SpecNotifierConnection then 
                SpecNotifierConnection:Disconnect()
            end
        end
    end,
})


local AutomationTab = Window:CreateTab("Automation", 4483362458) -- Title, Image
local NotifierSection = AutomationTab:CreateSection("Gacha Autofarm")

local HttpService = game:GetService("HttpService")
function GetWebhookOwner()
	if not Settings["Auto Farms"].UseWebhook then return end
    if not getgenv().GachaAutofarmWebhook then return end
	return HttpService:JSONDecode(HttpService:GetAsync(GachaAutofarmWebhook))["user"]["username"] or "here"
end
function SendMessageAsync(Message)
	if not Settings["Auto Farms"].UseWebhook then return end
    if not getgenv().GachaAutofarmWebhook then return end
	HttpService:PostAsync(GachaAutofarmWebhook or "", HttpService:JSONEncode({["content"] = Message}))
end

local GachaFarmConnection = nil
local GachaFarmToggle
local PlayerNearby = false
GachaFarmToggle = AutomationTab:CreateToggle({
	Name = "Autofarm Gacha",
	CurrentValue = false,
	Callback = function(Toggle)
        local CanGacha = function()
            local wawawawawa = game:GetService("ReplicatedStorage").Requests.Get:InvokeServer({"DaysSurvived", "LastGacha", "Silver"})
            local DaysSurvived =  wawawawawa.DaysSurvived
            local LastGacha = wawawawawa.LastGacha
            local Silver = wawawawawa.Silver

            if DaysSurvived ~= LastGacha and Silver >= 250 then
                print"can gacha"
                return true
            end
            return false
        end

        if Toggle == true then
            GachaFarmConnection = game:GetService("RunService").RenderStepped:Connect(function()
                Character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
                game.Players.LocalPlayer.Backpack.ChildAdded:Connect(function(scroll)
                    if scroll.Name:match("Scroll") then
                        SendMessageAsync("rolled: "..scroll.Name)
                    end
                    if scroll.Name:match(tostring(Settings["Auto Farms"].LogOnScroll.Scroll)) then
                        game.Players.LocalPlayer:Kick("Obtained: "..tostring(Settings["Auto Farm"].LogOnScroll.Scroll))
                        GachaFarmToggle:Set(false)
                        GachaFarmConnection:Disconnect()
                    end
                end)
                if (Character.PrimaryPart.Position - workspace.NPCs.Xenyari.HumanoidRootPart.Position).magnitude > 10 and not PlayerNearby == true then
                    Rayfield:Notify({Title="Error",Content="You are not near Xenyari!",Duration=5,Image=4483362458,Actions={Ignore={Name="Alright"},},})
                    GachaFarmToggle:Set(false)
                    GachaFarmConnection:Disconnect()
                end

                if not PlayerNearby then
                    for i,v in workspace.Live:GetChildren() do
                        if v:IsA("Model") == true then
                            local PotentialPlayer = v
                            if (PotentialPlayer.PrimaryPart.Position - Character.PrimaryPart.Position).magnitude <= 40 then
                                PlayerNearby = true
                                repeat
                                    game:GetService("ReplicatedStorage").toMenu:FireServer()
                                    wait(1)
                                    game:GetService("Players").LocalPlayer.PlayerGui.StartMenu.Finish:FireServer()
                                    wait(30)
                                until (PotentialPlayer.PrimaryPart.Position - workspace.NPCs.Xenyari.HumanoidRootPart.Position).magnitude > 40
                                PlayerNearby = false
                            end
                        end
                    end
                end
                
                while (Character.PrimaryPart.Position - workspace.NPCs.Xenyari.HumanoidRootPart.Position).magnitude >= 10 do wait()
                    if (Character.PrimaryPart.Position - workspace.NPCs.Xenyari.HumanoidRootPart.Position).magnitude > 10 and not PlayerNearby == true then
                        Rayfield:Notify({Title="Error",Content="You are not near Xenyari!",Duration=5,Image=4483362458,Actions={Ignore={Name="Alright"},},})
                        break
                    end
                    if CanGacha() == true  then
                        fireclickdetector(workspace.NPCs.Xenyari.ClickDetector)
                        wait(.5)
                        local args = {[1] = {["choice"] = "Sure, I'll pay."}}
                        game:GetService("ReplicatedStorage").Requests.Dialogue:FireServer(unpack(args))
                        wait(.5)
                        args = {[1]={["exit"] = true}}
                        game:GetService("ReplicatedStorage").Requests.Dialogue:FireServer(unpack(args))
                    end

                    repeat
                        wait()
                    until CanGacha() == true
                end
            end)
        elseif Toggle == false then
            if GachaFarmConnection then
                GachaFarmConnection:Disconnect()
            end
        end
    end,
})

local NotifierSection = AutomationTab:CreateSection("Gacha Autofarm (Settings)")


local PlayerDetectionThresholdSlider = AutomationTab:CreateSlider({
	Name = "Player Detection Threshold (not working rn will fix later)",
	Range = {0, 150},
	Increment = 1,
	Suffix = "Studs",
	CurrentValue = Settings["Auto Farms"].PlayerDetectionThreshold,
	Flag = "PlayerDetectionThresholdAF", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(SliderValue)
        Settings["Auto Farms"].PlayerDetectionThreshold = SliderValue
	end,
})

local UseWebhookToggle = AutomationTab:CreateToggle({
	Name = "Use Webhook",
	CurrentValue = false,
	Flag = "UseWebhookTOGGLE", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Toggle)
       Settings["Auto Farms"].UseWebhook = Toggle
	end,
})

local LogOnScrollToggle = AutomationTab:CreateToggle({
	Name = "Log on scroll",
	CurrentValue = Settings["Auto Farms"].LogOnScroll.IsEnabled,
	Flag = "LogOnScrollToggleeeeeasy", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Toggle)
       Settings["Auto Farms"].LogOnScroll.IsEnabled = Toggle
	end,
})

local LogOnScrollDropdown = AutomationTab:CreateDropdown({
	Name = "Select Scroll",
	Options = {"None","Scroll of Snarvindur","Scroll of Hoppa","Scroll of Percutiens","Scroll of Fimbulvetr","Scroll of Manus Dei","Scroll of Nocere","Scroll of Telorum","Scroll of Tenebris"},
	CurrentOption = Settings["Auto Farms"].LogOnScroll.Scroll,
	Flag = "LogOnScrollDropdownez", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Option)
        Settings["Auto Farms"].LogOnScroll.Scroll = Option
	end,
})
