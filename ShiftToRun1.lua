local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

local sprintAnim = Instance.new("Animation")
sprintAnim.AnimationId = "rbxassetid://82639714942648"

local sprinting = false
local runSpeed = 44
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

-- Apply speed change and animation direction
RunService.RenderStepped:Connect(function()
    if humanoid and character:FindFirstChild("HumanoidRootPart") then
        -- Determine if the player is moving forward
        local movingForward = UserInputService:IsKeyDown(Enum.KeyCode.W) or UserInputService.TouchEnabled
        local shouldSprint = sprinting and movingForward
        humanoid.WalkSpeed = shouldSprint and runSpeed or walkSpeed

        -- Get the character's movement direction
        local moveDirection = humanoid.MoveDirection
        if shouldSprint and moveDirection.Magnitude > 0 then
            -- Normalize the move direction to exclude the Y component (vertical)
            local flatMoveDirection = Vector3.new(moveDirection.X, 0, moveDirection.Z).Unit

            -- Orient the HumanoidRootPart to face the movement direction
            local lookAtCFrame = CFrame.new(Vector3.new(0, 0, 0), flatMoveDirection)
            hrp.CFrame = CFrame.new(hrp.Position) * lookAtCFrame

            -- Load and play the sprint animation
            if not animator then
                animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)
            end
            if not sprintTrack then
                sprintTrack = animator:LoadAnimation(sprintAnim)
                sprintTrack.Priority = Enum.AnimationPriority.Action
            end
            if not sprintTrack.IsPlaying then
                sprintTrack:Play()
                sprintTrack:AdjustSpeed(1.5) -- Keep the speed adjustment
            end
        else
            -- Stop the animation if not sprinting or not moving forward
            if sprintTrack and sprintTrack.IsPlaying then
                sprintTrack:Stop()
            end
        end
    end
end)
