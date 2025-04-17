local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local sprintAnim = Instance.new("Animation")
sprintAnim.AnimationId = "rbxassetid://101723211973609"

local sprinting = false
local runSpeed = 34
local walkSpeed = 16

local animator
local sprintTrack


-- Mobile Run Button
local runButton = Instance.new("TextButton")
runButton.Size = UDim2.new(0, 100, 0, 50)
runButton.Position = UDim2.new(1, -110, 1, -60)
runButton.AnchorPoint = Vector2.new(0.5, 0.5)
runButton.Text = "Run"
runButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
runButton.Visible = UserInputService.TouchEnabled

-- Ensure ScreenGui exists
local playerGui = player:WaitForChild("PlayerGui")
local screenGui = playerGui:FindFirstChild("SprintGui")

if not screenGui then
	screenGui = Instance.new("ScreenGui")
	screenGui.Name = "SprintGui"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = playerGui
end

-- Add the button to the GUI
runButton.Parent = screenGui


runButton.MouseButton1Down:Connect(function()
	sprinting = true
end)

runButton.MouseButton1Up:Connect(function()
	sprinting = false
end)

-- Sprint key on PC
function handleSprint(actionName, inputState, inputObject)
	if inputState == Enum.UserInputState.Begin then
		sprinting = true
	elseif inputState == Enum.UserInputState.End then
		sprinting = false
	end
end

ContextActionService:BindAction("Sprint", handleSprint, false, Enum.KeyCode.LeftShift)

-- Apply speed change while moving

RunService.RenderStepped:Connect(function()
	if humanoid and character:FindFirstChild("HumanoidRootPart") then
		local movingForward = UserInputService:IsKeyDown(Enum.KeyCode.W) or UserInputService.TouchEnabled
		local shouldSprint = sprinting and movingForward
		humanoid.WalkSpeed = shouldSprint and runSpeed or walkSpeed

		if shouldSprint then
			if not animator then
				animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)
			end
			if not sprintTrack then
				sprintTrack = animator:LoadAnimation(sprintAnim)
				sprintTrack.Priority = Enum.AnimationPriority.Action
			end
			if not sprintTrack.IsPlaying then
				sprintTrack:Play()
				sprintTrack:AdjustSpeed(2.5)
			end
		else
			if sprintTrack and sprintTrack.IsPlaying then
				sprintTrack:Stop()
			end
		end
	end
end)


--RunService.RenderStepped:Connect(function()
--	if humanoid and character:FindFirstChild("HumanoidRootPart") then
--		local movingForward = UserInputService:IsKeyDown(Enum.KeyCode.W) or UserInputService.TouchEnabled
--		humanoid.WalkSpeed = (sprinting and movingForward) and runSpeed or walkSpeed
--	end
--end)
