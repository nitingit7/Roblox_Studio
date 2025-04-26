local humanoid = script.Parent:WaitForChild("Humanoid")
local animator = humanoid:LoadAnimation(script.Parent.Animation)
animator:Play()
-- Fix Z rotation if needed
humanoid.RootPart.CFrame = humanoid.RootPart.CFrame * CFrame.Angles(0, math.pi, 0)  -- 180 degree Z flip compensate
wait(0.1)  -- Thoda wait karo taki animation stabilize ho
humanoid.RootPart.CFrame = humanoid.RootPart.CFrame * CFrame.Angles(0, 0, 0)  -- Z rotation 0 pe lock
