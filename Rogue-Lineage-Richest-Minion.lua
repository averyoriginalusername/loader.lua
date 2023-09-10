if game.PlaceId ~= 13747403394 then return end

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

local ClientCheatSettings = {
    ["JumpPower"] = 0;
    ["HealthDistance"] = 0;
}
local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

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
