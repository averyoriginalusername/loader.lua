--project rain ui lib
local Player = game.Players.LocalPlayer

local Library = loadstring(game:HttpGet("https://github.com/averyoriginalusername/lib/raw/main/Library.lua"))()
local ThemeManager = loadstring(game:HttpGet('https://github.com/averyoriginalusername/lib/raw/main/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet('https://github.com/averyoriginalusername/lib/raw/main/SaveManager.lua'))()

local ExternalSettings = {}

local Window = Library:CreateWindow({
    Title = 'lightage.cc',
    Center = true, 
    AutoShow = true,
})

local Tabs = {
    Main = Window:AddTab('Main'),
    Settings = Window:AddTab('Settings'),
}

local GroupBoxes = {
    Left = {
        Autofarm = Tabs.Main:AddLeftGroupbox('Auto-Parry')
    },
}

local AutoParryConnection
GroupBoxes.Left.Autofarm:AddToggle('AutoParryConnection', {
    Text = 'Enable Auto-Parry (BETA)',
    Default = false, -- Default value (true / false)
    Tooltip = 'Enables auto-parry', -- Information shown when you hover over the toggle

    Callback = function(Toggle)
        if Toggle == true then 
            AutoParryConnection = game:GetService("RunService").RenderStepped:Connect(function()
                if not workspace.Balls:GetChildren() then
                    return
                end
                if Player.Character.Parent == workspace.Dead then
                    return
                end

                for _,ball in workspace.Balls:GetChildren() do
                    if (Player.Character:FindFirstChild("HumanoidRootPart").Position - ball.Position).magnitude <= 25 then
                        if Player.Character:FindFirstChildOfClass("Highlight") then
                            keypress(0x46)
                        end
                    end
                end
            end)
        else
            AutoParryConnection:Disconnect()
        end
    end
})

-- lib stuff
Library:SetWatermarkVisibility(true)
Library:SetWatermark('YOU ARE RUNNING: v1')

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
SaveManager:SetFolder('lightage/blade-ball')

SaveManager:BuildConfigSection(Tabs.Settings) 
ThemeManager:ApplyToTab(Tabs.Settings)
