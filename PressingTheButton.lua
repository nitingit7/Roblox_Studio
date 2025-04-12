local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local emitterPart = character:WaitForChild("HumanoidRootPart"):WaitForChild("YourAttachmentName", true) -- Replace as needed

local emitter = emitterPart:FindFirstChildOfClass("ParticleEmitter")
if not emitter then
	warn("No ParticleEmitter found in attachment")
	return
end

local isEmitterOn = false

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	
	if input.KeyCode == Enum.KeyCode.E then
		isEmitterOn = not isEmitterOn
		emitter.Enabled = isEmitterOn
	end
end)
