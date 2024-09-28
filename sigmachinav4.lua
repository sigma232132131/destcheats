-- Define a new section for the example addon
local Example = ObeseAddons:Section({Name = "SIGMA CHINA Obese+", Side = "left"})

-- Variables to track the state of each toggle
local flags = {
    destroy_cheaters = false,
    chat_spy = false
}

-- "Destroy Cheaters" function with timing adjustments
local function destroyCheaters()
    while flags.destroy_cheaters do
        -- Check if the local player's character and HRP exist
        local plrs = game:GetService("Players")
        local lplr = plrs.LocalPlayer
        local character = lplr.Character
        if not character then return end

        local hrp = character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        -- Save the current position
        local oldCFrame = hrp.CFrame

        -- Move the HRP millions of studs underground
        hrp.CFrame = CFrame.new(0, -1000000, 0)  -- Move to a very deep underground position
        wait(1)  -- Stay underground for 1 second

        -- Return the character to the original position
        hrp.CFrame = oldCFrame
        wait(0.4)  -- Stay at the original position for 0.4 seconds
    end
end

-- "Chat Spy" configuration and function
local Config = {
    enabled = false,
    spyOnMyself = true,
    public = false,
    publicItalics = true
}

local PrivateProperties = {
    Color = Color3.fromRGB(0, 255, 255),
    Font = Enum.Font.SourceSansBold,
    TextSize = 18
}

local function initializeChatSpy()
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
            elseif Config.enabled and (Config.spyOnMyself == true or p ~= player) then
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
    local chatFrame = player.PlayerGui.Chat.Frame
    chatFrame.ChatChannelParentFrame.Visible = true
    chatFrame.ChatBarParentFrame.Position = chatFrame.ChatChannelParentFrame.Position + UDim2.new(UDim.new(), chatFrame.ChatChannelParentFrame.Size.Y)
end

-- Toggle for "Destroy Cheaters"
Example:Toggle({
    Name = "Destroy Cheaters",
    Def = false,
    Callback = function(state)
        flags.destroy_cheaters = state
        if state then
            -- Start the destroyCheaters function in a new thread
            task.spawn(destroyCheaters)
        end
    end
})

-- Toggle for "Chat Spy"
Example:Toggle({
    Name = "Chat Spy",
    Def = false,
    Callback = function(state)
        flags.chat_spy = state
        Config.enabled = state  -- Enable or disable the chat spy
        if state then
            -- Initialize Chat Spy functionality if enabled
            initializeChatSpy()
        else
            -- If disabling, inform the player
            local PrivateProperties = {
                Text = "{SPY DISABLED}",
                Color = Color3.fromRGB(0, 255, 255),
                Font = Enum.Font.SourceSansBold,
                TextSize = 18
            }
            game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", PrivateProperties)
        end
    end
})
