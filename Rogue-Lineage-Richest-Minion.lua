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
    Webhook = readfile("lightage/webhooks/rlrmgachawebhook.txt") or "NONE",
    AutofarmWebhookSettings = {
        UseWebhook = false,
        PingHere = false,
    },
    SelectedScrolls = true,
    DisableInWater = false,
    JumpPower = 0,
    Speed = 0,
    NoFallDamage = false
}
local KeybindBooleans = {
    Walkspeed = false
    Noclip = false
    InfiniteJump = false
}
if not isfile("workspace/lightage/rogue-lineage-richest-minion/bots") then
    makefolder("lightage/rogue-lineage-richest-minion/bots")
end

local Window = Library:CreateWindow({
    Title = 'lightage.cc',
    Center = true, 
    AutoShow = true,
})

local Tabs = {
    Main = Window:AddTab('Main'),
    Autofarm = Window:AddTab('Autofarm'),
    Keybinds = Window:AddTab('Keybinds'),
    Settings = Window:AddTab('Settings'),
}

local GroupBoxes = {
    Left = {
        CharacterTab = Tabs.Main:AddLeftGroupbox('Character'),
        Autofarm = Tabs.Autofarm:AddLeftGroupbox('Gacha Autofarm'),
        CharacterKeybinds = Tabs.Keybinds:AddLeftGroupbox('Character'),
    },
    Right = {
        Bots = Tabs.Autofarm:AddRightGroupbox('Bots'),
    }
}

local old
old = hookfunction(Instance.new("RemoteEvent").FireServer, newcclosure(function(self, ...)
    if not checkcaller() then
        if self.Name == "ApplyFallDamage" and ExternalSettings.NoFallDamage then
            return
        end
    end
    return old(self, ...)
end))

local OldWalkspeed = Player.Character:FindFirstChild("Humanoid").WalkSpeed
GroupBoxes.Left.CharacterTab:AddToggle('WalkspeedToggle', {
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

GroupBoxes.Left.CharacterTab:AddSlider('WalkspeedSlider', {Text = 'Walkspeed',  Default = 1,Min = 1, Max = 200,Rounding = 1,Compact = false,Callback = function(Value)ExternalSettings.Speed = Value;end})

GroupBoxes.Left.CharacterTab:AddToggle('InfiniteJumpToggle', {
    Text = 'Enable Infinite Jump',
    Default = false,
    Tooltip = 'enables inf jump',

    Callback = function(_)
        KeybindBooleans.InfiniteJump = not KeybindBooleans.InfiniteJump

        if KeybindsBooleans.InfiniteJump == true then
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
        elseif KeybindsBooleans.InfiniteJump == false then
            Connections:Disconnect("InfJumpConnection")
        end
    end
})

GroupBoxes.Left.CharacterTab:AddSlider('InfiniteJumpSlider', {Text = 'Jump Power',  Default = 1,Min = 1, Max = 150,Rounding = 1,Compact = false,Callback = function(Value)ExternalSettings.JumpPower = Value;end})

GroupBoxes.Left.CharacterTab:AddToggle('NoFallDamageToggle', {
    Text = 'Enable No Fall Damage',
    Default = false, -- Default value (true / false)
    Tooltip = 'Enables no fall damage', -- Information shown when you hover over the toggle

    Callback = function(Toggle)
        ExternalSettings.NoFallDamage = Toggle
    end
})

GroupBoxes.Left.CharacterTab:AddToggle('NoClipToggle', {
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

GroupBoxes.Left.CharacterTab:AddToggle('DisableInWater', {
    Text = 'Disable In Water',
    Default = false, -- Default value (true / false)
    Tooltip = 'disable when in water', -- Information shown when you hover over the toggle

    Callback = function(Toggle)
        ExternalSettings.DisableInWater = toggle
    end
})

GroupBoxes.Left.CharacterKeybinds:AddLabel('Walkspeed'):AddKeyPicker('WalkspeedKeybind', {
    -- SyncToggleState only works with toggles.
    -- It allows you to make a keybind which has its state synced with its parent toggle

    -- Example: Keybind which you use to toggle flyhack, etc.
    -- Changing the toggle disables the keybind state and toggling the keybind switches the toggle state

    Default = 'F1', -- String as the name of the keybind (MB1, MB2 for mouse buttons)
    SyncToggleState = false,


    -- You can define custom Modes but I have never had a use for it.
    Mode = 'Toggle', -- Modes: Always, Toggle, Hold

    Text = 'Noclip Keybind', -- Text to display in the keybind menu
    NoUI = false, -- Set to true if you want to hide from the Keybind menu,

    -- Occurs when the keybind is clicked, Value is `true`/`false`
    Callback = function(Value)
        Toggles.WalkspeedToggle:SetValue(Value)
    end,

    -- Occurs when the keybind itself is changed, `New` is a KeyCode Enum OR a UserInputType Enum
    ChangedCallback = function(New)
        print('[cb] Keybind changed!', New)
    end
})

GroupBoxes.Left.CharacterKeybinds:AddLabel('Noclip'):AddKeyPicker('NoClipToggle', {
    -- SyncToggleState only works with toggles.
    -- It allows you to make a keybind which has its state synced with its parent toggle

    -- Example: Keybind which you use to toggle flyhack, etc.
    -- Changing the toggle disables the keybind state and toggling the keybind switches the toggle state

    Default = 'F2', -- String as the name of the keybind (MB1, MB2 for mouse buttons)
    SyncToggleState = false,


    -- You can define custom Modes but I have never had a use for it.
    Mode = 'Toggle', -- Modes: Always, Toggle, Hold

    Text = 'Noclip Keybind', -- Text to display in the keybind menu
    NoUI = false, -- Set to true if you want to hide from the Keybind menu,

    -- Occurs when the keybind is clicked, Value is `true`/`false`
    Callback = function(Value)
        Toggles.NoClipToggle:SetValue(Value)
    end,

    -- Occurs when the keybind itself is changed, `New` is a KeyCode Enum OR a UserInputType Enum
    ChangedCallback = function(New)
        print('[cb] Keybind changed!', New)
    end
})

GroupBoxes.Left.CharacterKeybinds:AddLabel('Infinite Jump'):AddKeyPicker('InfiniteJumpKeybind', {
    -- SyncToggleState only works with toggles.
    -- It allows you to make a keybind which has its state synced with its parent toggle

    -- Example: Keybind which you use to toggle flyhack, etc.
    -- Changing the toggle disables the keybind state and toggling the keybind switches the toggle state

    Default = 'F3', -- String as the name of the keybind (MB1, MB2 for mouse buttons)
    SyncToggleState = false,


    -- You can define custom Modes but I have never had a use for it.
    Mode = 'Toggle', -- Modes: Always, Toggle, Hold

    Text = 'Noclip Keybind', -- Text to display in the keybind menu
    NoUI = false, -- Set to true if you want to hide from the Keybind menu,

    -- Occurs when the keybind is clicked, Value is `true`/`false`
    Callback = function(Value)
        Toggles.InfiniteJumpToggle:SetValue(Value)
    end,

    -- Occurs when the keybind itself is changed, `New` is a KeyCode Enum OR a UserInputType Enum
    ChangedCallback = function(New)
        print('[cb] Keybind changed!', New)
    end
})

local function SendDiscordRequest(Message)
    if ExternalSettings.AutofarmWebhookSettings.UseWebhook == false then return end
    local Response = syn and syn.request or request
    Response({
        Url = ExternalSettings.Webhook,
        Method = "POST",
        Headers = {
            ['Content-Type'] = 'application/json'
        },
        Body = HttpService:JSONEncode({
            ["content"] = Message
        })
    })
end

GroupBoxes.Left.Autofarm:AddToggle('GachaAutofarm', {
    Text = 'Enable Autofarm Gacha',
    Default = false, -- Default value (true / false)
    Tooltip = 'Enables the gacha autofarm', -- Information shown when you hover over the toggle

    Callback = function(Toggle)
        local Action = false

        local function GachaStatus()
            local Get = game:GetService("ReplicatedStorage").Requests.Get:InvokeServer({"DaysSurvived", "LastGacha", "Silver"})

            local DaysSurvived = Get.DaysSurvived
            local LastGacha = Get.LastGacha
            local Silver = Get.Silver

            if DaysSurvived ~= LastGacha and Silver >= 250 then
                return true
            elseif DaysSurvived ~= LastGacha and Silver < 250 then
                return "nosilver"
            end
            return false
        end

        if Toggle == true then 
            Connections:Conn("GachaAutofarmConnection", game:GetService("RunService").RenderStepped:Connect(function()
                if Action then 
                    return 
                end
                if GachaStatus() == "nosilver" then
                     return Library:Notify("Not enough silver", 1e9), GachaAutoFarmConnection:Disconnect(), Toggles.GachaAutofarm:SetValue(false)
                end

                if GachaStatus() == true then
                    Action = true;
                    do
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.NPCs.Xenyari.HumanoidRootPart.CFrame
                        wait(.2)
                        fireclickdetector(workspace.NPCs.Xenyari.ClickDetector)
                        wait(.25)
                        local args = {[1] = {["choice"] = "Sure, I'll pay."}}
                        game:GetService("ReplicatedStorage").Requests.Dialogue:FireServer(unpack(args))
                        wait(.25)
                        args = {[1]={["exit"] = true}}
                        game:GetService("ReplicatedStorage").Requests.Dialogue:FireServer(unpack(args))
                        wait(2)
                    end;
                    Action = false;
                end
            end))
        else
            Connections:Disconnect("GachaAutoFarmConnection")
        end
    end
})

GroupBoxes.Left.Autofarm:AddToggle("UseWebhook", {
    Text = 'Use Webhook',
    Default = false, -- Default value (true / false)
    Tooltip = 'Use the webhook when you get a new scroll', -- Information shown when you hover over the toggle

    Callback = function(Toggle)
        ExternalSettings.AutofarmWebhookSettings.UseWebhook = Toggle
        if Toggle == true then
            Connections:Conn("ScrollAddedConnection", Player:FindFirstChild("Backpack").ChildAdded:Connect(function(Child)
                if Child.Name:match("Scroll of") then
                    if ExternalSettings.AutofarmWebhookSettings.PingHere == true then
                        SendDiscordRequest("@here rolled: "..Child.Name)
                        return
                    else
                        SendDiscordRequest("rolled: "..Child.Name)
                        return
                    end
                end
            end))
        else
            Connections:Disconnect("ScrollAddedConnection")
        end
    end
})

GroupBoxes.Left.Autofarm:AddToggle("PingHereOnScroll", {
    Text = 'Ping Here On Scroll',
    Default = false, -- Default value (true / false)
    Tooltip = 'Ping @here on scroll', -- Information shown when you hover over the toggle

    Callback = function(Toggle)
        ExternalSettings.AutofarmWebhookSettings.PingHere = Toggle
    end
})


GroupBoxes.Left.Autofarm:AddInput('WebhookInput', {
    Default = '',
    Numeric = false, -- true / false, only allows numbers
    Finished = false, -- true / false, only calls callback when you press enter

    Text = 'Webhook',
    Tooltip = 'Enter Webhook; leave/make blank if none.', -- Information shown when you hover over the textbox

    Placeholder = '', -- placeholder text when the box is empty
    -- MaxLength is also an option which is the max length of the text

    Callback = function(Value)
        print(Value)
        ExternalSettings.Webhook = tostring(Value)
    end
})

local SaveWebhookButton = GroupBoxes.Left.Autofarm:AddButton({
    Text = 'Save Webhook',
    DoubleClick = false,
    Tooltip = 'Save the webhook',
    Func = function()
        if not isfile("workspace/lightage/webhooks") then
            makefolder("lightage/webhooks")
        end
        
        if ExternalSettings.Webhook:match("discord.com/api/webhooks") then
            writefile("lightage/webhooks/rlrmgachawebhook.txt", ExternalSettings.Webhook)
            return Library:Notify("Webhook saved! The next time you open the script, it will not load to the textbox.\n Check workspace/lightage/webhooks (look for the game name) and see if it has saved.\n (or alternatively press check webhook button)", 1e9)
        else
            return Library:Notify("Not a valid webhook URL")
        end
    end,
})

local CheckForWebhook = GroupBoxes.Left.Autofarm:AddButton({
    Text = 'Check For Webhook',
    DoubleClick = false,
    Tooltip = 'Check if you have your webhook saved',
    Func = function()
        if isfile("workspace/lightage/webhooks/rlrmgachawebhook") then
            return Library:Notify("Webhook data exists", 5)
        else
            return Library:Notify("No webhook data", 5)
        end
    end,
})

local SendTestPost = GroupBoxes.Left.Autofarm:AddButton({
    Text = 'Send Test Message',
    DoubleClick = false,
    Tooltip = 'Send a test message',
    Func = function()
        SendDiscordRequest("This is a test message")
    end,
})

local SelectedPath = nil
local PathTable = {}

local HasStarted = false
local StopCreating = false
local PlayingPath = false

local Speed = 5
local Wait = 5

local BotFiles = {"--"} do
    local botfileslist = listfiles("lightage/rogue-lineage-richest-minion/bots")

    for i = 1, #botfileslist do
        local file = botfileslist[i]
        if file:split(".")[2]:match("json") then
            BotFiles[i] = file:split("/")[3]
        end
    end
end

setmetatable(BotFiles, {__newindex = function(t,k,v) rawset(t,k.v) end,})

local NewPathName = ""
GroupBoxes.Right.Bots:AddInput('PathName', {
    Default = '',
    Numeric = false, -- true / false, only allows numbers
    Finished = false, -- true / false, only calls callback when you press enter

    Text = 'Path Name',
    Tooltip = 'create a pathn mae', -- Information shown when you hover over the textbox

    Placeholder = 'e.g path1', -- placeholder text when the box is empty
    -- MaxLength is also an option which is the max length of the text

    Callback = function(Value)
        NewPathName = Value
    end
})

GroupBoxes.Right.Bots:AddDropdown('SavedPaths', {
    Values = BotFiles or {},
    Default = 1, -- number index of the value / string
    Multi = false, -- true / false, allows multiple choices to be selected

    Text = 'Saved Paths',
    Tooltip = 'Bot Paths', -- Information shown when you hover over the dropdown

    Callback = function(Value)
        SelectedPath = Value
    end
})

local CreateNewPath = GroupBoxes.Right.Bots:AddButton({
    Text = 'Create Path',
    DoubleClick = false,
    Tooltip = 'Create a new bot path',
    Func = function()
        if NewPathName ~= "" then
            writefile("lightage/rogue-lineage-richest-minion/bots/"..NewPathName..".json", HttpService:JSONEncode(PathTable))
            Library:Notify("Created: "..NewPathName..".json", 5)
        else
            Library:Notify("Name cannot be blank", 5)
        end
    end,
})

local LoadPath = GroupBoxes.Right.Bots:AddButton({
    Text = 'Load Path',
    DoubleClick = false,
    Tooltip = 'Load selected path',
    Func = function()
        if SelectedPath ~= nil then
            PlayingPath = true
            local PathContents = readfile("lightage/rogue-lineage-richest-minion/"..SelectedPath)
            local Decoded = HttpService:JSONDecode(PathContents)
            
            local CurrentTween
            for i = 1, #Decoded do
                print(Decoded[i].Position)
                CurrentTween = TweenService:Create(Player.Character.HumanoidRootPart, TweenInfo.new(Decoded[i].CharSpeed, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Position = Decoded[i].Position})
                CurrentTween:Play()
                CurrentTween.Completed:Connect(function() 
                    task.wait(Decoded[i].Wait)
                end)
            end
            Library:Notify("Path Completed", 5)
        end
    end,
})


local BeginCreatingPath = GroupBoxes.Right.Bots:AddButton({
    Text = 'Begin Creating Path',
    DoubleClick = false,
    Tooltip = 'begin creationg a path',
    Func = function()
        if HasStarted then return end
        HasStarted = true
        return Library:Notify("Behun", 3)
    end,
})

local FinishCreatingPath = GroupBoxes.Right.Bots:AddButton({
    Text = 'Finish Creating Path',
    DoubleClick = false,
    Tooltip = 'begin creationg a path',
    Func = function()
        if HasStarted == false then
            return Library:Notify("You aren't recording", 3)
        end
        HasStarted = false
        return Library:Notify("Finished recording path", 3)
    end,
})

local DiscardRecordingPath = GroupBoxes.Right.Bots:AddButton({
    Text = 'Discard Path',
    DoubleClick = false,
    Tooltip = 'Discard the current recording',
    Func = function()
        return PathRecordingConnection:Disconnect(), HasStarted == false, StopCreating == true, Pause == false
    end,
})

GroupBoxes.Right.Bots:AddSlider('WaitSlider', {Text = 'Wait',  Default = 1,Min = 1, Max = 15,Rounding = 1,Compact = false,Callback = function(Value)Wait = Value;end})
GroupBoxes.Right.Bots:AddSlider('SpeedSlider', {Text = 'Speed',Default = 1,Min = 1,Max = 5, Rounding = 1,Compact = false,Callback = function(Value)Speed = Value;end})

local AddPoint = GroupBoxes.Right.Bots:AddButton({
    Text = 'Add Point',
    DoubleClick = false,
    Tooltip = 'Add a point',
    Func = function()
       if HasStarted == true then
            return Library:Notify("Added a point", 3), table.insert(PathTable, {WaitTime = Wait, CharSpeed = Speed, Position = Player.Character:FindFirstChild("HumanoidRootPart").Position})
       else
            return Library:Notify("You aren't recording", 3)
       end
    end,
})
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
