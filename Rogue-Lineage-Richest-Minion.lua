local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local PlayerBackpack = Player:WaitForChild("Backpack")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local CharacterRemotes = Character:FindFirstChild("CharacterHandler"):FindFirstChild("Remotes")

local ClientCheatSettings = {
    ["JumpPower"] = 0;
    ["HealthDistance"] = 0;
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
                        NewBV.Velocity = Vector3.new(0, ClientCheatSettings.JumpPower, 0)
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
                 print("Disconnected")
             end
        end 
	end,
})
local InfJumpSlider = ClientTab:CreateSlider({
	Name = "Infinite Jump Power",
	Range = {0, 150},
	Increment = 1,
	Suffix = "Jump Power",
	CurrentValue = ClientCheatSettings.JumpPower,
	Flag = "JumpPowerSlider", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(SliderValue)
		ClientCheatSettings.JumpPower = SliderValue
	end,
})


local BlankSection1 = ClientTab:CreateSection("")
local BreakJoints = ClientTab:CreateButton({
	Name = "Break Joints (Reset)",
	Callback = function()
        if Player:FindFirstChild("Danger") then return end
		Character:BreakJoints()
	end,
})
local NoInjuriesToggle = ClientTab:CreateToggle({
    Name = "No Injuries"
    CurrentValue = false,
    Flag = "NoInjuriesToggle"
    Callback = function(Toggle)
        if Toggle == true then

        end
    end
})
local NoFireConnection = nil
local NoFireToggle = ClientTab:CreateToggle({
    Name = "No Fire"
    CurrentValue = false,
    Flag = "NoFireToggle"
    Callback = function(Toggle)
        if Toggle == true then
            NoFireConnection = Character.ChildAdded:Connect(function(child)
                if Child.Name == "Fire" then
                    CharacterRemotes.Dodge:Fire(0, "normal")
                end
            end)
        end
    end
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
                    	TargetHumanoid.HealthDisplayDistance = ClientCheatSettings.HealthDistance
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
	CurrentValue = ClientCheatSettings.JumpPower,
	Flag = "ViewHealthDistanceSlider", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(SliderValue)
        ClientCheatSettings.HealthDistance = SliderValue
	end,
})

local SecurityTab = Window:CreateTab("Security", 4483362458) -- Title, Image
local NotifierSection = SecurityTab:CreateSection("Notifiers")


local onPlayerAdded = nil
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
            onPlayerAdded = game.Players.PlayerAdded:Connect(function(Player)
                NotifyIllu(Player)
            end)
        elseif Toggle == false then
            if onPlayerAdded then 
                onPlayerAdded:Disconnect()
                print"disconnected"
            end
        end
    end,
})

local AutomationTab = Window:CreateTab("Automation", 4483362458) -- Title, Image
local NotifierSection = AutomationTab:CreateSection("Craft Potions")

local Stations = workspace.Stations
local AmountToCraft = 0
local CurrentlySelected = "None"
local PotionRecipes = {
    ["Health Potion"] = {
        ["Scroom"] = 2;
        ["Lava Flower"] = 1;
    }
}

local PotionsDropdown = AutomationTab:CreateDropdown({
	Name = "Select Potion",
	Options = {"Health Potion","Tespian Elixir"},
	CurrentOption = "Health Potion",
	Flag = "PotionDropdown", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Option)
	  	  CurrentlySelected = Option
	end,
})
local PotionAmount = AutomationTab:CreateInput({
	Name = "Potion Amount (NUMBERS ONLY)",
	PlaceholderText = "1",
	RemoveTextAfterFocusLost = false,
	Callback = function(Text)
		AmountToCraft = tonumber(Text)
	end,
})
local StartedCrafting = false
local BeginCrafting = AutomationTab:CreateButton({
	Name = "Begin Crafting",
	Callback = function()
        StartedCrafting = true

        local getIngredientAmounts = function(Ingredient)
            local ingredientCount = 0

            for i,v in 
        end

        while StartedCrafting == true do wait()
            if StartedCrafting == false then
                 break
            end
            if CurrentlySelected ~= "None" then
                for i,cauldron in pairs(Stations:GetChildren()) do
                    local Station = cauldron.Name == "AlchemyStation" and cauldron:IsA("Model") == true
                    if (Character.HumanoidRootPart.Position - cauldron.Bucket.Position) > 10 then
                        Rayfield:Notify({
                            Title = "Error",
                            Content = "You must be within 10 studs of a crafting station.",
                            Duration = 1e9,
                            Image = 4483362458,
                            Actions = { -- Notification Buttons
                                Ignore = {
                                  Name = "Alright"
                                },
                            },
                         })
                         StartedCrafting = false
                        break
                    end
                end
            end
        end
	end,
})
--[[
local Label = Tab:CreateLabel("Label Example")

local Paragraph = Tab:CreateParagraph({Title = "Paragraph Example", Content = "Paragraph Example"})

local Input = Tab:CreateInput({
	Name = "Input Example",
	PlaceholderText = "Input Placeholder",
	RemoveTextAfterFocusLost = false,
	Callback = function(Text)
		-- The function that takes place when the input is changed
    		-- The variable (Text) is a string for the value in the text box
	end,
})

local Dropdown = Tab:CreateDropdown({
	Name = "Dropdown Example",
	Options = {"Option 1","Option 2"},
	CurrentOption = "Option 1",
	Flag = "Dropdown1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Option)
	  	  -- The function that takes place when the selected option is changed
    	  -- The variable (Option) is a string for the value that the dropdown was changed to
	end,
})

local Button = Tab:CreateButton({
	Name = "Destroy UI",
	Callback = function()
		Rayfield:Destroy()
	end,
})
--]]
-- Extras

-- getgenv().SecureMode = true -- Only Set To True If Games Are Detecting/Crashing The UI

-- Rayfield:Destroy() -- Destroys UI

-- Rayfield:LoadConfiguration() -- Enables Configuration Saving

-- Section:Set("Section Example") -- Use To Update Section Text

-- Button:Set("Button Example") -- Use To Update Button Text

-- Toggle:Set(false) -- Use To Update Toggle

-- Slider:Set(10) -- Use To Update Slider Value

-- Label:Set("Label Example") -- Use To Update Label Text

-- Paragraph:Set({Title = "Paragraph Example", Content = "Paragraph Example"}) -- Use To Update Paragraph Text

-- Keybind:Set("RightCtrl") -- Keybind (string) -- Use To Update Keybind

-- Dropdown:Set("Option 2") -- The new option value -- Use To Update/Set New Dropdowns
