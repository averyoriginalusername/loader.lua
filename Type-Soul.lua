local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local PlayerBackpack = Player:WaitForChild("Backpack")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local CharacterRemotes = Character:WaitForChild("CharacterHandler"):WaitForChild("Remotes")

local Settings = {
	["Client Cheats"] = {
		["WalkSpeed"] = 15;
		["JumpPower"] = 0;
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
local MovementSection = ClientTab:CreateSection("Movement")

local NoclipConnection = nil
local NoclipToggle = ClientTab:CreateToggle({
	Name = "Noclip",
	CurrentValue = false,
	Flag = "NoclipToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Toggle)
        if Toggle == true then
			NoclipConnection = game:GetService("RunService").Stepped:Connect(function()
				for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
					if v:IsA("BasePart") == true then
						v.CanCollide = false
					end
				end
			end)
        elseif Toggle == false then
			if NoclipConnection then
				NoclipConnection:Disconnect()
				Character.Torso.CanCollide = true
			end
		end
	end,
})
local OriginalWalkspeed = Character.Humanoid.WalkSpeed
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
				Character.Humanoid.WalkSpeed = OriginalWalkspeed
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

local OtherSection = ClientTab:CreateSection("Others")
local BreakJoints = ClientTab:CreateButton({
	Name = "Break Joints (Can be used to become lost soul)",
	Callback = function()
		Character:BreakJoints()
	end,
})
