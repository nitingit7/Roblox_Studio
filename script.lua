local Players = game:GetService("Players")

-- Names of the folders in Workspace containing particle emitters
local TARGET_ATTACHMENTS = {"Ring", "Wind"}

-- Returns the left and right foot parts based on rig type
local function getFeet(character)
    local leftFoot = character:FindFirstChild("LeftFoot") or character:FindFirstChild("Left Leg")
    local rightFoot = character:FindFirstChild("RightFoot") or character:FindFirstChild("Right Leg")
    return leftFoot, rightFoot
end

-- Attaches particle emitters to a given body part (foot)
local function attachParticlesToPart(part)
    if not part then return end

    local attachment = Instance.new("Attachment")
    attachment.Name = "FootParticles"
    attachment.Parent = part

    for _, sourceName in ipairs(TARGET_ATTACHMENTS) do
        local source = workspace:FindFirstChild(sourceName, true)
        if source then
            for _, emitter in ipairs(source:GetChildren()) do
                if emitter:IsA("ParticleEmitter") then
                    local clone = emitter:Clone()
                    clone.Enabled = true
                    clone.Parent = attachment
                end
            end
        else
            warn("Missing particle source in Workspace:", sourceName)
        end
    end
end

local function setupCharacter(character)
    -- Wait for necessary parts
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.Died:Connect(function() -- Optional: clean up particles on death
        for _, a in ipairs(character:GetDescendants()) do
            if a:IsA("Attachment") and a.Name == "FootParticles" then
                a:Destroy()
            end
        end
    end)

    -- Attach to both feet
    local leftFoot, rightFoot = getFeet(character)
    attachParticlesToPart(leftFoot)
    attachParticlesToPart(rightFoot)
end

-- Connect to player
local function onPlayerAdded(player)
    player.CharacterAdded:Connect(setupCharacter)

    -- If player already has a character loaded
    if player.Character then
        setupCharacter(player.Character)
    end
end

-- Connect existing and future players
Players.PlayerAdded:Connect(onPlayerAdded)

for _, player in ipairs(Players:GetPlayers()) do
    onPlayerAdded(player)
end
