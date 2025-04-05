local Players = game:GetService("Players")

-- Names of folders/models in Workspace containing particle emitters
local TARGET_ATTACHMENTS = {"Ring", "Wind"}

-- Utility: Get foot parts based on rig type
local function getFeet(character)
	local leftFoot = character:FindFirstChild("LeftFoot") or character:FindFirstChild("Left Leg")
	local rightFoot = character:FindFirstChild("RightFoot") or character:FindFirstChild("Right Leg")
	return leftFoot, rightFoot
end

-- Attach particles to a given foot
local function attachParticlesToPart(part)
	if not part then return end

	-- Avoid duplicate attachments
	if part:FindFirstChild("FootParticles") then return end

	local attachment = Instance.new("Attachment")
	attachment.Name = "FootParticles"
	attachment.Parent = part -- Attach directly to the foot

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

-- Setup per-character
local function setupCharacter(character)
	local humanoid = character:WaitForChild("Humanoid")

	-- Auto-cleanup particles on death
	humanoid.Died:Connect(function()
		for _, a in ipairs(character:GetDescendants()) do
			if a:IsA("Attachment") and a.Name == "FootParticles" then
				a:Destroy()
			end
		end
	end)

	local leftFoot, rightFoot = getFeet(character)
	attachParticlesToPart(leftFoot)
	attachParticlesToPart(rightFoot)
end

-- Setup per-player
local function onPlayerAdded(player)
	player.CharacterAdded:Connect(setupCharacter)

	-- Handle already loaded character
	if player.Character then
		setupCharacter(player.Character)
	end
end

-- Connect all players
Players.PlayerAdded:Connect(onPlayerAdded)

for _, player in ipairs(Players:GetPlayers()) do
	onPlayerAdded(player)
end
