local Players = game:GetService("Players")

local TARGET_ATTACHMENTS = {"Ring", "Wind"}

-- Utility to find left foot (works for R15 and R6)
local function getLeftFoot(character)
    return character:FindFirstChild("LeftFoot") or character:FindFirstChild("Left Leg")
end

-- Attach particle emitters to HumanoidRootPart but position over foot
local function attachParticlesRelativeToFoot(character)
    local root = character:WaitForChild("HumanoidRootPart")
    local foot = getLeftFoot(character)
    if not foot then
        warn("Foot not found for character:", character.Name)
        return
    end

    -- Get world offset between root and foot
    local offset = foot.Position - root.Position

    -- Create attachment
    local attachment = Instance.new("Attachment")
    attachment.Name = "FootParticles"
    attachment.Position = offset -- offset from root to foot
    attachment.Parent = root

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

-- Setup character
local function setupCharacter(character)
    local humanoid = character:WaitForChild("Humanoid")

    humanoid.Died:Connect(function()
        for _, a in ipairs(character:GetDescendants()) do
            if a:IsA("Attachment") and a.Name == "FootParticles" then
                a:Destroy()
            end
        end
    end)

    attachParticlesRelativeToFoot(character)
end

-- Player logic
local function onPlayerAdded(player)
    player.CharacterAdded:Connect(setupCharacter)

    if player.Character then
        setupCharacter(player.Character)
    end
end

-- Init
Players.PlayerAdded:Connect(onPlayerAdded)

for _, player in ipairs(Players:GetPlayers()) do
    onPlayerAdded(player)
end
