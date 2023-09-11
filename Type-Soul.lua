local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local PlayerBackpack = Player:WaitForChild("Backpack")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local CharacterRemotes = Character:WaitForChild("CharacterHandler"):WaitForChild("Remotes")

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

local WalkspeedToggle = ClientTab:CreateToggle({
	Name = "Walkspeed",
	CurrentValue = false,
	Flag = "Walkspeedtoggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Toggle)
        if Toggle == true then

        end
	end,
})

local Slider = ClientTab:CreateSlider({
	Name = "Slider Example",
	Range = {0, 100},
	Increment = 10,
	Suffix = "Bananas",
	CurrentValue = 10,
	Flag = "Slider1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Value)
		-- The function that takes place when the slider changes
    		-- The variable (Value) is a number which correlates to the value the slider is currently at
	end,
})
local Button = ClientTab:CreateButton({
	Name = "Button Example",
	Callback = function()
		-- The function that takes place when the button is pressed
	end,
})

local Toggle = ClientTab:CreateToggle({
	Name = "Toggle Example",
	CurrentValue = false,
	Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Value)
		-- The function that takes place when the toggle is pressed
    		-- The variable (Value) is a boolean on whether the toggle is true or false
	end,
})

local Slider = ClientTab:CreateSlider({
	Name = "Slider Example",
	Range = {0, 100},
	Increment = 10,
	Suffix = "Bananas",
	CurrentValue = 10,
	Flag = "Slider1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Value)
		-- The function that takes place when the slider changes
    		-- The variable (Value) is a number which correlates to the value the slider is currently at
	end,
})

local Label = ClientTab:CreateLabel("Label Example")

local Paragraph = ClientTab:CreateParagraph({Title = "Paragraph Example", Content = "Paragraph Example"})

local Input = ClientTab:CreateInput({
	Name = "Input Example",
	PlaceholderText = "Input Placeholder",
	RemoveTextAfterFocusLost = false,
	Callback = function(Text)
		-- The function that takes place when the input is changed
    		-- The variable (Text) is a string for the value in the text box
	end,
})

local Keybind = ClientTab:CreateKeybind({
	Name = "Keybind Example",
	CurrentKeybind = "Q",
	HoldToInteract = false,
	Flag = "Keybind1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Keybind)
		-- The function that takes place when the keybind is pressed
    		-- The variable (Keybind) is a boolean for whether the keybind is being held or not (HoldToInteract needs to be true)
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
