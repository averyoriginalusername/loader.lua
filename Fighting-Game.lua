getgenv().SecureMode = true
local TrinketModels = {
    ["Goblet"] = {AssetId = 13116132, Color = Color3.fromRGB(231, 141, 22), Rarity = "Common"};
    ["Scroll"] = {AssetId = 60791940, Color = Color3.fromRGB(51, 95, 255), Rarity = "Rare"};
}
Settings = {
    ["Client Cheats"] = {
        Fullbright = false;
        NoShadows = false;
    };
	["ESP Settings"] = {
		["Trinket ESP"] = {
			Enabled = true,
			["Trinket Types"] = {
				Common = false;
				Rare = false;
				Legendary = false;
			}
		}
	}
}
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

local ClientTab = Window:CreateTab("Client Cheats", 4483362458)


local GameVisualsTab = Window:CreateTab("Game Visuals", 4483362458) 
function newTrinketEsp(Trinket, Value)
    local TrinketDrawing = Drawing.new("Text")
    TrinketDrawing.Visible = false
    TrinketDrawing.Center = true
    TrinketDrawing.Font = 1
    TrinketDrawing.Size = 18

    local RenderStepped = nil
    RenderStepped = game:GetService("RunService").RenderStepped:Connect(function()
        if Value == false then TrinketDrawing.Visible = false;TrinketDrawing:Remove();RenderStepped:Disconnect() end
        if Trinket and Trinket ~= nil then
            local TrinketMesh = Trinket and Trinket:FindFirstChildOfClass("SpecialMesh")
            local TrinketPosition,IsOnScreen = workspace.CurrentCamera:WorldToViewportPoint(Trinket.Position)
            if IsOnScreen then
                if TrinketMesh then
                    for name,values in TrinketModels do
                        if TrinketMesh.MeshId:match(values.AssetId) then
                            TrinketDrawing.Text = name
                            TrinketDrawing.Color = values.Color
                            if Settings["ESP Settings"]["Trinket ESP"].Enabled then
                                if Settings["ESP Settings"]["Trinket ESP"]["Trinket Types"][values.Rarity] == true then
                                    TrinketDrawing.Visible = true
                                else
                                    TrinketDrawing.Visible = false
                                end
                            end
                        end
                    end
                    TrinketDrawing.Position = Vector2.new(TrinketPosition.X, TrinketPosition.Y)
                end
            else
                TrinketDrawing.Visible = false
            end
        else
            TrinketDrawing.Visible = false
            TrinketDrawing:Remove()
            RenderStepped:Disconnect()    
        end

        if Trinket then
            Trinket.Destroying:Connect(function()
                TrinketDrawing:Remove()
            end)
        end
    end)
end

local ESPSection = ClientTab:CreateSection("ESP")
local ESPToggle = GameVisualsTab:CreateToggle({
	Name = "Enable Trinket ESP",
	CurrentValue = Settings["ESP Settings"]["Trinket ESP"].Enabled,
	Flag = "TrinketESPToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Toggle)
        for i,v in workspace.Thrown:GetChildren() do
            if v:IsA("Part") == true then
                if v.Name == "Part" then
                    newTrinketEsp(v, Toggle)
                end
            end
        end
        Settings["ESP Settings"]["Trinket ESP"] = Toggle
	end,
})
local ShowCommonToggle = GameVisualsTab:CreateToggle({
	Name = "Enable Trinket ESP",
	CurrentValue = Settings["ESP Settings"]["Trinket ESP"]["Trinket Types"].Common,
	Flag = "TrinketESPToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Toggle)
        Settings["ESP Settings"]["Trinket ESP"]["Trinket Types"].Common = Toggle
	end,
})
local ShowRareToggle = GameVisualsTab:CreateToggle({
	Name = "Enable Trinket ESP",
	CurrentValue = Settings["ESP Settings"]["Trinket ESP"]["Trinket Types"].Rare,
	Flag = "TrinketESPToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Toggle)
        Settings["ESP Settings"]["Trinket ESP"]["Trinket Types"].Rare = Toggle
	end,
})
local ShowLegendaryToggle = GameVisualsTab:CreateToggle({
	Name = "Enable Trinket ESP",
	CurrentValue = Settings["ESP Settings"]["Trinket ESP"]["Trinket Types"].Legendary,
	Flag = "TrinketESPToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Toggle)
        Settings["ESP Settings"]["Trinket ESP"]["Trinket Types"].Legendary = Toggle
	end,
})
local GameViewSection = ClientTab:CreateSection("World View")

local OldBrightness = game.Lighting.Brightness
local OldAmbient = game.Lighting.Ambient
local FBToggle = GameVisualsTab:CreateToggle({
	Name = "Enable Fullbright",
	CurrentValue = Settings["Client Cheats"].Fullbright,
	Flag = "FBToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Toggle)
        if Toggle == true then
            game.Lighting.Brightness = 40
			game.Lighting.Ambient = Color3.fromRGB(255,255,255)
        else
            game.Lighting.Brightness = OldBrightness
			game.Lighting.Ambient = OldAmbient
        end

        Settings["Client Cheats"].Fullbright = Toggle
	end,
})
local DisableShadowsToggle = GameVisualsTab:CreateToggle({
	Name = "No Shadows",
	CurrentValue = Settings["Client Cheats"].NoShadows,
	Flag = "ShadowsToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Toggle)
        local TurnOffShadows = function(Bool)
            if Bool == true then
                for i,v in workspace:GetDescendants() do
                    if v:IsA("BasePart") then
                        v.CastShadow = Bool and false or true
                        game.Lighting.GlobalShadows = Bool and false or true
                        Settings["Client Cheats"].NoShadows = Bool
                    end
                end
            end
        end
	
        TurnOffShadows(Toggle)
    end,
})
