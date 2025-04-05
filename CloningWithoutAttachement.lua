local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer
local ATTACHMENT_NAME = "FootAttachment"
local OFFSET = Vector3.new(0, -4.154, 0)

-- Debug function
local function debugPrint(message)
    print("[Particle Debug]: "..message)
    -- Uncomment next line to show on screen too
    -- game.StarterGui:SetCore("SendNotification", {Title="Particle Debug", Text=message, Duration=5})
end

local function setupCharacter(character)
    -- Wait for humanoid root part
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    debugPrint("Found HumanoidRootPart")
    
    -- Clean up old attachment if exists
    local oldAttachment = humanoidRootPart:FindFirstChild(ATTACHMENT_NAME)
    if oldAttachment then
        oldAttachment:Destroy()
        debugPrint("Cleaned up old attachment")
    end
    
    -- Create new attachment
    local footAttachment = Instance.new("Attachment")
    footAttachment.Name = ATTACHMENT_NAME
    footAttachment.Parent = humanoidRootPart
    footAttachment.Position = OFFSET
    debugPrint("Created new attachment at Y = "..OFFSET.Y)
    
    -- Find and move particle emitters from workspace
    local emitterCount = 0
    for _, child in pairs(workspace:GetChildren()) do
        if child:IsA("ParticleEmitter") then
            debugPrint("Found emitter: "..child.Name)
            
            -- Clone emitter to keep original in workspace
            local clonedEmitter = child:Clone()
            clonedEmitter.Parent = footAttachment
            clonedEmitter.Enabled = true
            
            emitterCount = emitterCount + 1
            debugPrint("Moved emitter to attachment")
        end
    end
    
    if emitterCount == 0 then
        debugPrint("WARNING: No emitters found in workspace!")
    else
        debugPrint("Successfully moved "..emitterCount.." emitters")
    end
    
    return footAttachment
end

-- Initial setup
if player.Character then
    setupCharacter(player.Character)
end

-- Handle respawns
player.CharacterAdded:Connect(function(character)
    debugPrint("New character detected")
    setupCharacter(character)
end)

-- Continuous verification
RunService.Heartbeat:Connect(function()
    if player.Character then
        local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            local attachment = humanoidRootPart:FindFirstChild(ATTACHMENT_NAME)
            if not attachment then
                debugPrint("WARNING: Attachment missing - recreating")
                setupCharacter(player.Character)
            end
        end
    end
end)

debugPrint("System initialized for player: "..player.Name)
