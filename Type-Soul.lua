local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local PlayerBackpack = Player:WaitForChild("Backpack")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local CharacterRemotes = Character:WaitForChild("CharacterHandler"):WaitForChild("Remotes")

local Settings = {
	["Client Cheats"] = {
		["WalkSpeed"] = 15
	}
}
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
	Name = "Multiware: Type Soul",
	LoadingTitle = "Loading: Type Soul...",
	LoadingSubtitle = "by ???",
	ConfigurationSaving = {
		Enabled = true,
		FolderName = "multiwareConfig",
		FileName = "mwTYPESOULConfig"
	},
})

local ClientTab = Window:CreateTab("Client Cheats", 4483362458) -- Title, Image
local Section = ClientTab:CreateSection("Movement")


local WalkspeedConnection = nil
local WalkspeedToggle = ClientTab:CreateToggle({
	Name = "Walkspeed",
	CurrentValue = false,
	Flag = "Walkspeedtoggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Toggle)
        if Toggle == true then
			WalkspeedConnection = game:GetService("RunService").RenderStepped:Connect(function()
				Character.Humanoid.WalkSpeed = Settings["Client Cheats"].WalkSpeed
			end)
        elseif Toggle == false then
			if WalkspeedConnection then
				WalkspeedConnection:Disconnect()
			end
		end
	end,
})

local WalkSpeedSlider = ClientTab:CreateSlider({
	Name = "Walkspeed Slider",
	Range = {0, 125},
	Increment = 1,
	Suffix = "Speed",
	CurrentValue = 0,
	Flag = "WSSlider", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Value)
		Settings["Client Cheats"].WalkSpeed = Value
	end,
})

local AutoSprintConnection = nil
local UISConnection = nil
local AutoSprintToggle = ClientTab:CreateToggle({
	Name = "Auto-Sprint",
	CurrentValue = false,
	Flag = "AutosprintToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Toggle)
        if Toggle == true then
            AutoSprintConnection = game:GetService("RunService").RenderStepped:Connect(function()
                UISConnection = game:GetService("UserInputService").InputBegan:Connect(function(K,_GPE)
                    if _GPE then return end
                    if K.KeyCode == Enum.KeyCode.W then
                        if Toggle == false then return end
                        for i = 1, 2 do
                            if i == 1 then
                                CharacterRemotes.Sprint:FireServer("Released")
                            elseif i == 2 then
                                CharacterRemotes.Sprint:FireServer("Pressed")
                            end
                        end
                     end
                end)
            end)            
        elseif Toggle == false then
            if AutoSprintConnection then
                AutoSprintConnection:Disconnect()
            end
			if UISConnection then
				UISConnection:Disconnect()
			end
        end
	end,
})
