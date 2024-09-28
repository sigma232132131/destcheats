-- Define a new section for the example addon
local Example = ObeseAddons:Section({Name = "SIGMA CHINA UTILITIES banglesh", Side = "left"})

-- Flags to control the state of each functionality
local flags = {
    destroy_cheaters = false,
    chat_spy = false,
}

-- Destroy Cheaters Functionality
local FINOBE_KEYBIND = "M"

getgenv().Finobe1 = false -- Set the initial value to false to prevent activation
local NewCFrame = CFrame.new
local LocalFinobe = game.Players.LocalPlayer
local InputService = game:GetService("UserInputService")
local Runfinobe = game:GetService("RunService")

local Finobe2; 
Runfinobe.Heartbeat:Connect(function()
    if flags.destroy_cheaters and LocalFinobe.Character then  -- Ensure it's only running when the toggle is on
        local FinobeChar = LocalFinobe.Character.HumanoidRootPart
        local Offset = FinobeChar.CFrame * NewCFrame(9e9, 0/0, math.huge)
        
        if getgenv().Finobe1 then 
            Finobe2 = FinobeChar.CFrame
            FinobeChar.CFrame = Offset
            Runfinobe.RenderStepped:Wait()
            FinobeChar.CFrame = Finobe2
        end 
    end 
end)

InputService.InputBegan:Connect(function(sigma)
    if sigma.KeyCode == Enum.KeyCode[FINOBE_KEYBIND] then 
        getgenv().Finobe1 = not getgenv().Finobe1
        
        if not getgenv().Finobe1 then 
            LocalFinobe.Character.HumanoidRootPart.CFrame = Finobe2
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "china obese+",
                Text = "dc disabled"
            })
        else 
            Finobe2 = nil 
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "china obese+",
                Text = "dc enabled"
            })
        end 
    end 
end)

local finobeHookSigmaChatWtfCreateRemindedMeAboutThisShittyAssExploitBtw_MiseryOwnerIsACuck
finobeHookSigmaChatWtfCreateRemindedMeAboutThisShittyAssExploitBtw_MiseryOwnerIsACuck = hookmetamethod(game, "__index", newcclosure(function(self, key)
    if not checkcaller() then
        if key == "CFrame" and getgenv().Finobe1 and LocalFinobe.Character and LocalFinobe.Character:FindFirstChild("HumanoidRootPart") and LocalFinobe.Character:FindFirstChild("Humanoid") and LocalFinobe.Character.Humanoid.Health > 0 then
            if self == LocalFinobe.Character.HumanoidRootPart and Finobe2 ~= nil then
                return Finobe2
            end
        end
    end
    return finobeHookSigmaChatWtfCreateRemindedMeAboutThisShittyAssExploitBtw_MiseryOwnerIsACuck(self, key)
end))

-- Chat Spy Functionality
local Config = {
    enabled = false, -- Set to false initially
    spyOnMyself = true,
    public = false,
    publicItalics = true
}

local PrivateProperties = {
    Color = Color3.fromRGB(0, 255, 255),
    Font = Enum.Font.SourceSansBold,
    TextSize = 18,
}

local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local saymsg = game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest")
local getmsg = game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("OnMessageDoneFiltering")
local instance = (_G.chatSpyInstance or 0) + 1
_G.chatSpyInstance = instance

local function onChatted(p, msg)
    if _G.chatSpyInstance == instance then
        if p == player and msg:lower():sub(1, 4) == "/spy" then
            Config.enabled = not Config.enabled
            wait(0.3)
            PrivateProperties.Text = "{SPY " .. (Config.enabled and "EN" or "DIS") .. "ABLED}"
            StarterGui:SetCore("ChatMakeSystemMessage", PrivateProperties)
        elseif Config.enabled and (Config.spyOnMyself or p ~= player) then
            msg = msg:gsub("[\n\r]", ''):gsub("\t", ' '):gsub("[ ]+", ' ')
            local hidden = true
            local conn = getmsg.OnClientEvent:Connect(function(packet, channel)
                if packet.SpeakerUserId == p.UserId and packet.Message == msg:sub(#msg - #packet.Message + 1) and (channel == "All" or (channel == "Team" and Config.public == false and Players[packet.FromSpeaker].Team == player.Team)) then
                    hidden = false
                end
            end)
            wait(1)
            conn:Disconnect()
            if hidden and Config.enabled then
                if Config.public then
                    saymsg:FireServer((Config.publicItalics and "/me " or '') .. "{SPY} [" .. p.Name .. "]: " .. msg, "All")
                else
                    PrivateProperties.Text = "{SPY} [" .. p.Name .. "]: " .. msg
                    StarterGui:SetCore("ChatMakeSystemMessage", PrivateProperties)
                end
            end
        end
    end
end

for _, p in ipairs(Players:GetPlayers()) do
    p.Chatted:Connect(function(msg) onChatted(p, msg) end)
end

Players.PlayerAdded:Connect(function(p)
    p.Chatted:Connect(function(msg) onChatted(p, msg) end)
end)

PrivateProperties.Text = "{SPY " .. (Config.enabled and "EN" or "DIS") .. "ABLED}"
StarterGui:SetCore("ChatMakeSystemMessage", PrivateProperties)

-- Toggle for "Destroy Cheaters"
Example:Toggle({
    Name = "Destroy Cheaters M",
    Def = false,
    Callback = function(state)
        flags.destroy_cheaters = state
        getgenv().Finobe1 = state  -- Control activation of "Destroy Cheaters"
        
        -- Start teleportation only if the toggle is enabled
        if state then
            Finobe2 = nil
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Destroy Cheaters",
                Text = "Enabled"
            })
        else
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Destroy Cheaters",
                Text = "Disabled"
            })
        end
    end
})

-- Toggle for "Chat Spy"
Example:Toggle({
    Name = "Chat Spy",
    Def = false,
    Callback = function(state)
        flags.chat_spy = state
        Config.enabled = state  -- Enable or disable chat spy based on toggle
        PrivateProperties.Text = "{SPY " .. (Config.enabled and "EN" or "DIS") .. "ABLED}"
        StarterGui:SetCore("ChatMakeSystemMessage", PrivateProperties)
    end
})
