local keyframeSequence = game.Workspace:WaitForChild("KeyframeSequence") -- Isme apne KeyframeSequence ka naam daal
local keyframes = keyframeSequence:GetKeyframes()

for _, keyframe in pairs(keyframes) do
	local poses = keyframe:GetDescendants()
	for _, pose in pairs(poses) do
		if pose:IsA("Pose") and pose.Name == "LowerTorso" then
			local cframe = pose.CFrame
			pose.CFrame = CFrame.new(Vector3.new(cframe.Position.X, 0, cframe.Position.Z)) * CFrame.Angles(cframe:ToEulerAnglesXYZ())
		end
	end
end
