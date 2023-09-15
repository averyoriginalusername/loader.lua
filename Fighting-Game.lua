getgenv().SecureMode = true

local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local PlayerBackpack = Player:WaitForChild("Backpack")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
	Name = "Multiware: Fighting Game",
	LoadingTitle = "Loading: Fighting Game...",
	LoadingSubtitle = "by ???",
	ConfigurationSaving = {
		Enabled = true,
		FolderName = "multiwareConfig",
		FileName = "mwFGConfig"
	},
})

local ClientTab = Window:CreateTab("Client Cheats", 4483362458) -- Title, Image


local GameVisualsTab = Window:CreateTab("Game Visuals", 4483362458) -- Title, Image
local OldBrightness = game.Lighting.Brightness

local FBToggle = GameVisualsTab:CreateToggle({
	Name = "Enable Fullbright",
	CurrentValue = false,
	Flag = "FBToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Toggle)
        if Toggle == true then
            game.Lighting.Brightness = 40
        else
            game.Lighting.Brightness = OldBrightness
        end
	end,
})
local DisableShadowsToggle = GameVisualsTab:CreateToggle({
	Name = "Disable Shadows",
	CurrentValue = false,
	Flag = "ShadowsToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Toggle)
        local TurnOffShadows = function(Bool)
            if Bool == true then
                for i,v in workspace:GetDescendants() do
                    if v:IsA("BasePart") then
                        v.CastShadows = Bool and false or true
                        game.Lighting.GlobalShadows = Bool and false or true
                    end
                end
            end
        end
	
        TurnOffShadows(Toggle)
    end,
})
