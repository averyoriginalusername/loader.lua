--project rain ui lib
local Player = game.Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")

local Library = loadstring(game:HttpGet("https://github.com/averyoriginalusername/lib/raw/main/Library.lua"))()
local ThemeManager = loadstring(game:HttpGet('https://github.com/averyoriginalusername/lib/raw/main/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet('https://github.com/averyoriginalusername/lib/raw/main/SaveManager.lua'))()
local ConnectionHandler = loadstring(game:HttpGet('https://github.com/averyoriginalusername/main/raw/main/ConnectionManager.lua'))()

local Connections = ConnectionHandler.new()
local ExternalSettings = {
    JumpPower = 0,
    Speed = 0,
    ESPSettings = {
        MobESPs = {
            HollowMobsEnabled = false,
            ShowHealth = false,
        },
        GateESP = false,
        TextFont = 1,
        TextSize = 15,
        ESPColor = Color3.new(1, 1, 1)
    }
}
local Window = Library:CreateWindow({
    Title = 'lightage.cc',
    Center = true, 
    AutoShow = true,
})

local Tabs = {
    Main = Window:AddTab('Main'),
    ESP = Window:AddTab('ESP'),
    Settings = Window:AddTab('Settings'),
}

local GroupBoxes = {
    Left = {
        PlayerBox = Tabs.Main:AddLeftGroupbox('Player'),
        FarmingBox = Tabs.Main:AddLeftGroupbox('Farming'),
        ESPBox = Tabs.ESP:AddLeftGroupbox("ESPs"),
    },
    Right = {
        OthersBox = Tabs.Main:AddRightGroupbox('Others'),
        ESPSettingsBox = Tabs.ESP:AddRightGroupbox("ESP Settings")
    }
}
local PlaceIds = {
    Hueco = 14069122388,
    Wanden = 14071822972,
    LasNoches = 14069122388,
    Karakura = 14069678431,
    SoulSociety = 14070029709
}
local MonsterTypes = {
    "Menos"; "Frisker"; "Fishbone"
}
local GateESPs,HollowESPs,ShinigamiESPs,ArrancarESPs,PlayerESPs,NPCESPs = {}, {}, {}, {}, {}, {} 
local function newDrawing()
    local DrawObj = Drawing.new("Text")
    DrawObj.Center = true
    DrawObj.Font = 1
    DrawObj.Visible = true
    DrawObj.Outline = true
	DrawObj.Color = Color3.new(1,1,1)
    return DrawObj
end

local function teleportToPlace(plr, part)
    plr.Character.HumanoidRootPart.Position = part.Position
end

workspace.Entities.ChildAdded:Connect(function(child)
    for MonsterType,_ in next, MonsterTypes do
        if child.ClassName == "Model" and child.Name:match(MonsterType) then
            HollowESPs[child] = newDrawing()
            print("newdrawing: ", child.Name)
        end 
    end
end)

workspace.Entities.ChildRemoved:Connect(function(child)
    for MonsterType,_ in next, MonsterTypes do
        if child.ClassName == "Model" and child.Name:match(MonsterType) then
            HollowESPs[child]:Remove(); HollowESPs[child] = nil
        end 
    end
end)

for _,v in next, workspace.Entities:GetChildren() do
     for MonsterType,_ in next, MonsterTypes do
        if v.ClassName == "Model" and v.Name:match(MonsterType) then
            if game.Players:FindFirstChild(v.Name) then continue end
            HollowESPs[v] = newDrawing()
        end 
    end
end

--[[
Connections:Conn("ESP_PlayerAdded", game.Players.PlayerAdded:Connect(function(plr)
    if not PlayerESPs[plr] then PlayerESPs[plr] = newDrawing() end
end)); Connections:Conn("ESP_PlayerRemoving", game.Players.PlayerRemoving:Connect(function(plr)
    if PlayerESPs[plr] then PlayerESPs[plr]:Remove(); PlayerESPs[plr] = nil end
end))--]]

--[[
Connections:Conn("ESP_EntityAdded", workspace.Entities.ChildAdded:Connect(function(child)
    for MonsterType,_ in next, MonsterTypes do
        if child.ClassName == "Model" and child.Name:match(MonsterType) then
            HollowESPs[child] = newDrawing()
            print("newdrawing: ", child.Name)
        end 
    end
end)); Connections:Conn("ESP_EntityRemoved", workspace.Entities.ChildRemoved:Connect(function(child)
    for MonsterType,_ in next, MonsterTypes do
        if child.ClassName == "Model" and child.Name:match(MonsterType) then
            HollowESPs[child]:Remove(); HollowESPs[child] = nil
        end 
    end
end))
--]]

--table.foreach(PlayerESPs, warn)
table.foreach(HollowESPs, warn)

GroupBoxes.Left.PlayerBox:AddToggle('NoClipToggle', {
    Text = 'Enable Noclip',
    Default = false, -- Default value (true / false)
    Tooltip = 'Enables noclip', -- Information shown when you hover over the toggle

    Callback = function(Toggle)
        if Toggle then
            Connections:Conn("NoclipConnection", game:GetService("RunService").RenderStepped:Connect(function()
                if not Player.Character then
                    return
                end
                
                for i,v in Player.Character:GetChildren() do
                    if v:IsA("BasePart") == true then
                        v.CanCollide = false
                    end
                end
            end))
        else
            if Connections:Disconnect("NoclipConnection") then
                Player.Character.Torso.CanCollide = true
            end
        end
    end
})

local OldWalkspeed = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid").WalkSpeed
GroupBoxes.Left.PlayerBox:AddToggle('WalkspeedToggle', {
    Text = 'Enable Walkspeed',
    Default = false,
    Tooltip = 'enables walkspeed',

    Callback = function(Toggle)
        print(Toggle)
        if Toggle == true then
            Connections:Conn("WalkSpeedConnection", game:GetService("RunService").RenderStepped:Connect(function()
                Player.Character:FindFirstChild("Humanoid").WalkSpeed = ExternalSettings.Speed
            end))
        else
            if Connections:Disconnect("WalkSpeedConnection") then
                Player.Character:FindFirstChild("Humanoid").WalkSpeed = OldWalkspeed
            end
        end
    end
})

GroupBoxes.Left.PlayerBox:AddSlider('WalkspeedSlider', {
    Text = 'Walkspeed',
    Default = 1,
    Min = 1,
    Max = 150,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        ExternalSettings.Speed = Value
    end
})

GroupBoxes.Left.PlayerBox:AddToggle('InfiniteJumpToggle', {
    Text = 'Enable Infinite Jump',
    Default = false,
    Tooltip = 'enables inf jump',

    Callback = function(Toggle)
        if Toggle == true then
            local HumanoidRootPart =  game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local UserInputService = game:GetService("UserInputService")     
            Connections:Conn("InfJumpConnection", game:GetService("RunService").RenderStepped:Connect(function()
                local NewBV 
                while UserInputService:IsKeyDown("Space") do wait()
                    if not HumanoidRootPart:FindFirstChild(".") then
                        NewBV = Instance.new("BodyVelocity")
                        NewBV.Name = "."
                        NewBV.MaxForce = Vector3.new(0, math.huge, 0)
                        NewBV.Velocity = Vector3.new(0, ExternalSettings.JumpPower, 0)
                        NewBV.Parent = HumanoidRootPart
                    end
                end
                if NewBV then
                     NewBV:Destroy()
                end
            end))
        elseif Toggle == false then
            Connections:Disconnect("InfJumpConnection")
        end
    end
})

GroupBoxes.Left.PlayerBox:AddSlider('InfiniteJumpSlider', {
    Text = 'Jump Power',
    Default = 1,
    Min = 1,
    Max = 150,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        ExternalSettings.JumpPower = Value;
    end
})

GroupBoxes.Left.ESPBox:AddToggle('ToggleHollowMobESP', {
    Text = 'Show Hollow-Classed Mobs',
    Default = false,
    Tooltip = 'enables esp for mobs (EXPERIMENTAL, MAY NOT BE AS ACCURATE)',

    Callback = function(Toggle)
        ExternalSettings.ESPSettings.MobESPs.HollowMobsEnabled = Toggle
    end
})

GroupBoxes.Left.FarmingBox:AddToggle('AutoCreateParty', {
    Text = 'Adjuchas Notifier',
    Default = false,
    Tooltip = 'notifies if adjucha',

    Callback = function(Toggle)
        local function NotifyAdjuchas(Path)
            for _,potentialAdjucha in Path:GetChildren() do
                if potentialAdjucha.ClassName == "Model" then
                    if potentialAdjucha.Name:match("Adjuc") and potentialAdjucha.Name:match("_") then
                        Library:Notify("Adjuchas Spawned: "..potentialAdjucha.Name, 600)
                    end
                end
            end
        end

        NotifyAdjuchas(workspace.Entities)
        workspace.Entities.ChildAdded:Connect(function(_)
            NotifyAdjuchas(workspace.Entities)
        end)
    end
})

GroupBoxes.Left.FarmingBox:AddToggle('AutoCreateParty', {
    Text = 'Auto-Create Party',
    Default = false,
    Tooltip = 'create party auto',

    Callback = function(Toggle)
        if Toggle == true then
            Connections:Conn('AutoCreate_Party', game:GetService("RunService").RenderStepped:Connect(function()
                local PlayerGui = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
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
    end
})

GroupBoxes.Right.ESPSettingsBox:AddToggle('ToggleMobHealth', {
    Text = 'Show Mob Health',
    Default = false,
    Tooltip = 'enables esp health for mobs',

    Callback = function(Toggle)
        ExternalSettings.ESPSettings.MobESPs.ShowHealth = Toggle
    end
})

GroupBoxes.Right.ESPSettingsBox:AddSlider('TextSizeSlider', {
    Text = 'Text Size',
    Default = 1,
    Min = 1,
    Max = 25,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        ExternalSettings.ESPSettings.TextSize = Value;
    end
})
local KillSelfButton = GroupBoxes.Left.PlayerBox:AddButton({
    Text = 'Kill Player',
    DoubleClick = false,
    Tooltip = 'kill yourself (can use to become a lost soul)',
    Func = function()
        return game.Players.LocalPlayer.Character:BreakJoints()
    end,
})

local TweenToKisuke = (game.PlaceId == PlaceIds.Karakura) and GroupBoxes.Right.OthersBox:AddButton({
    Text = 'To Kisuke',
    DoubleClick = false,
    Tooltip = 'tween to kisuke (CAN AA GUN)',
    Func = function()
        local isTweening = false
        local ToKisuke = TweenService:Create(game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart"), TweenInfo.new(10, Enum.EasingStyle.Linear), {CFrame = workspace.NPCs:FindFirstChild("Kisuke").Kisuke:FindFirstChild("HumanoidRootPart").CFrame})

        if not isTweening then
            isTweening = not isTweening
            ToKisuke:Play(); ToKisuke.Completed:Connect(function()
                isTweening = false
            end)
        end
        return
    end,
}) or nil

--GroupBoxes.Left.OthersBox:AddDivider()

local TPToWanden = not (game.PlaceId == PlaceIds.Wanden) or not (game.PlaceId == PlaceIds.Hueco) and GroupBoxes.Right.OthersBox:AddButton({
    Text = 'TP To Wanden',
    DoubleClick = false,
    Tooltip = 'tp to wanden',
    Func = function()
        local Part = nil
        if (game.PlaceId == PlaceIds.Karakura) then
            warn("Karakura")
            Part = workspace.WandenreichGate:FindFirstChild("WandenGate")
        end

        return teleportToPlace(game.Players.LocalPlayer, Part)
    end,
}) or nil

local TPToLasNoches = (game.PlaceId == PlaceIds.Hueco) and GroupBoxes.Right.OthersBox:AddButton({
    Text = 'TP To Las Noches',
    DoubleClick = false,
    Tooltip = 'tp to las noches',
    Func = function()
        teleportToPlace(game.Players.LocalPlayer,workspace:FindFirstChild("LasNoches").MenosPit)
        return 
    end,
}) or nil

local TPToSoulSociety = not (game.PlaceId == PlaceIds.SoulSociety) or not (game.PlaceId == PlaceIds.Hueco) and GroupBoxes.Right.OthersBox:AddButton({
    Text = 'TP To Soul Society',
    DoubleClick = false,
    Tooltip = 'tp to ss',
    Func = function()
        local Part = nil
        if (game.PlaceId == PlaceIds.Karakura) then
            Part = workspace.SoulGate:FindFirstChild("SoulGate")
        end

        return teleportToPlace(game.Players.LocalPlayer, Part)
    end,
}) or nil

-- lib stuff
--Library:SetWatermarkVisibility(true)
--Library:SetWatermark('YOU ARE RUNNING: v1')

Library:OnUnload(function()
    print('Unloaded!')
    Library.Unloaded = true
end)

local MenuGroup = Tabs.Settings:AddLeftGroupbox('Menu')
MenuGroup:AddButton('Unload', function() Library:Unload() end) 
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'Insert', NoUI = true, Text = 'Menu keybind' }) 
Library.ToggleKeybind = Options.MenuKeybind -- Allows you to have a custom keybind for the menu

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings() 
SaveManager:SetIgnoreIndexes({'MenuKeybind'}) 
SaveManager:SetFolder('lightage')
SaveManager:SetFolder('lightage/rogue-lineage-richest-minion')

SaveManager:BuildConfigSection(Tabs.Settings) 
ThemeManager:ApplyToTab(Tabs.Settings)

Tabs.Settings:AddRightGroupbox('Debug'):AddButton('Clear All Connections', function() Connections:ClearAllCurrent() end) 

local function UpdateDrawings()
    local a,b = pcall(function()
        if ExternalSettings.ESPSettings.MobESPs.HollowMobsEnabled then
            for Mob,drawingObj in next,HollowESPs do
                local partToRender = Mob.PrimaryPart
                if partToRender then
                        --local Distance = (workspace.CurrentCamera.CFrame.Position - partToRender.Position).Magnitude
                        --if Distance > ExternalSettings.MobESPRange then continue end 
                    local screenPosition,canSee = workspace.CurrentCamera:WorldToViewportPoint(partToRender.Position)
                    if canSee then
                        local Health = partToRender.Parent:FindFirstChild("Humanoid") and math.ceil(partToRender.Parent:FindFirstChild("Humanoid").Health)
                        local MaxHealth = partToRender.Parent:FindFirstChild("Humanoid") and math.ceil(partToRender.Parent:FindFirstChild("Humanoid").MaxHealth)
                        drawingObj.Text = ExternalSettings.ESPSettings.MobESPs.ShowHealth and partToRender.Parent.Name:split("_")[1]:lower().." ["..Health.."/"..MaxHealth.."]" or partToRender.Parent.Name:split("_")[1]:lower()
                        drawingObj.Font = ExternalSettings.ESPSettings.TextFont
                        drawingObj.Size = ExternalSettings.ESPSettings.TextSize
                        drawingObj.Position = Vector2.new(screenPosition.X,screenPosition.Y)
                        drawingObj.Visible = true
                    else
                        drawingObj.Visible = false
                     end
                else
                    drawingObj.Visible = false
                end
            end
        else
            for Mob,drawingObj in next,HollowESPs do
                drawingObj.Visible = false
            end
        end
    end)

    if not a then warn(tostring(b)) end
end
game:GetService("RunService"):BindToRenderStep("UpdateESPDrawings", 201, UpdateDrawings)
