-- Define a new section for the example addon
local Example = ObeseAddons:Section({Name = "SIGMA CHINA UTILITIES v4", Side = "left"})

-- Flags to control the state of each functionality
local flags = {
    destroy_cheaters = false,
    void_spam = false
}

-- Destroy Cheaters Functionality
local FINOBE_KEYBIND = "X"

getgenv().Finobe1 = true 
local NewCFrame = CFrame.new
local LocalFinobe = game.Players.LocalPlayer
local InputService = game:GetService("UserInputService")
local Runfinobe = game:GetService("RunService")

local Finobe2; 
Runfinobe.heartbeat:Connect(function()
    if LocalFinobe.Character then 
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
                Title = "Destroy Exploiters",
                Text = "Disabled"
            })
        else 
            Finobe2 = nil 
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Destroy Exploiters",
                Text = "Enabled"
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

-- Void Spam Functionality
local function voidSpam()
    while flags.void_spam do
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(0, -1000000, 0)  -- Teleport to underground
            wait(1)  -- Stay underground for 1 second
            player.Character.HumanoidRootPart.CFrame = CFrame.new(0, 0, 0)  -- Return to original position
            wait(0.4)  -- Stay at original position for 0.4 seconds
        end
    end
end

-- Toggle for "Destroy Cheaters"
Example:Toggle({
    Name = "Destroy Cheaters",
    Def = false,
    Callback = function(state)
        flags.destroy_cheaters = state
        if state then
            -- Start the destroyCheaters functionality
            task.spawn(function() 
                while flags.destroy_cheaters do 
                    -- This loop controls the teleportation logic
                    if LocalFinobe.Character then 
                        local FinobeChar = LocalFinobe.Character.HumanoidRootPart
                        local Offset = FinobeChar.CFrame * NewCFrame(9e9, 0/0, math.huge)
                        Finobe2 = FinobeChar.CFrame
                        FinobeChar.CFrame = Offset
                        wait(1)  -- Stay underground
                        FinobeChar.CFrame = Finobe2
                        wait(0.4)  -- Wait before the next cycle
                    end
                end
            end)
        end
    end
})

-- Toggle for "Void Spam"
Example:Toggle({
    Name = "Void Spam",
    Def = false,
    Callback = function(state)
        flags.void_spam = state
        if state then
            -- Start the void spam function
            task.spawn(voidSpam)
        end
    end
})
