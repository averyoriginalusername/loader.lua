--project rain ui lib
local Player = game.Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")

local Library = loadstring(game:HttpGet("https://github.com/averyoriginalusername/lib/raw/main/Library.lua"))()
local ThemeManager = loadstring(game:HttpGet('https://github.com/averyoriginalusername/lib/raw/main/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet('https://github.com/averyoriginalusername/lib/raw/main/SaveManager.lua'))()

local ExternalSettings = {
    Webhook = readfile("lightage/webhooks/rlrmgachawebhook.txt") or "NONE",
    AutofarmWebhookSettings = {
        UseWebhook = false,
        PingHere = false,
    },
    SelectedScrolls = true
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
    Settings = Window:AddTab('Settings'),
}

local GroupBoxes = {
    Left = {
        Autofarm = Tabs.Autofarm:AddLeftGroupbox('Gacha Autofarm')
    },
    Right = {
        Bots = Tabs.Autofarm:AddRightGroupbox('Bots')
    }
}

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

local GachaAutoFarmConnection
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
            GachaAutoFarmConnection = game:GetService("RunService").RenderStepped:Connect(function()
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
            end)
        else
            GachaAutoFarmConnection:Disconnect()
        end
    end
})

local ScrollAddedConnection
GroupBoxes.Left.Autofarm:AddToggle("UseWebhook", {
    Text = 'Use Webhook',
    Default = false, -- Default value (true / false)
    Tooltip = 'Use the webhook when you get a new scroll', -- Information shown when you hover over the toggle

    Callback = function(Toggle)
        ExternalSettings.AutofarmWebhookSettings.UseWebhook = Toggle
        if Toggle == true then
            ScrollAddedConnection = Player:FindFirstChild("Backpack").ChildAdded:Connect(function(Child)
                if Child.Name:match("Scroll of") then
                    if ExternalSettings.AutofarmWebhookSettings.PingHere == true then
                        SendDiscordRequest("@here rolled: "..Child.Name)
                        return
                    else
                        SendDiscordRequest("rolled: "..Child.Name)
                        return
                    end
                end
            end)
        else
            ScrollAddedConnection:Disconnect()
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
SaveManager:SetFolder('lightage/rogue-lineage-richest-minion')

SaveManager:BuildConfigSection(Tabs.Settings) 
ThemeManager:ApplyToTab(Tabs.Settings)
