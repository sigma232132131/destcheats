-- Define a new section for the example addon
local Example = ObeseAddons:Section({Name = "Game Utilities", Side = "left"})

-- Variable to track the toggle state
local flags = { destroy_cheaters = false }

-- Function to teleport the character away
local function destroyCheaters()
    while flags.destroy_cheaters do  -- Run while the toggle is enabled
        -- Check if the local player's character and HRP exist
        local plrs = game:GetService("Players")
        local lplr = plrs.LocalPlayer
        local character = lplr.Character
        if not character then return end

        local hrp = character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        -- Save the current position and teleport the character away
        local old = hrp.CFrame
        hrp.CFrame = CFrame.new(9e9, 0, math.huge)

        -- Wait a frame to ensure the teleport registers
        game:GetService("RunService").RenderStepped:Wait()

        -- Return the character to the original position
        hrp.CFrame = old

        -- Small delay to prevent infinite loop from crashing the game
        task.wait(0.5)  -- Adjust the wait time as needed
    end
end

-- Create a toggle in the UI for the "Destroy Cheaters" feature
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
