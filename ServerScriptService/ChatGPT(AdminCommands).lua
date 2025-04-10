local Players = game:GetService("Players")

local PREFIX = "/"
local ADMINS = {
	"LuffyXGojo7",
	"alanwalker_941",
}

-- Check if player is admin
local function isAdmin(player)
	return table.find(ADMINS, player.Name) ~= nil
end

-- Find a player by name (case-insensitive)
local function findPlayer(name)
	local lowerName = name:lower()
	for _, player in ipairs(Players:GetPlayers()) do
		if player.Name:lower() == lowerName then
			return player
		end
	end
	return nil
end

-- Command definitions
local commands = {}

commands.tp = function(args)
	local fromName, toName = args[1], args[2]
	if not fromName or not toName then return end

	local fromPlayer = findPlayer(fromName)
	local toPlayer = findPlayer(toName)

	if fromPlayer and toPlayer and fromPlayer.Character and toPlayer.Character then
		local fromHRP = fromPlayer.Character:FindFirstChild("HumanoidRootPart")
		local toHRP = toPlayer.Character:FindFirstChild("HumanoidRootPart")
		if fromHRP and toHRP then
			fromHRP.CFrame = toHRP.CFrame
			print("✅ Teleport command executed.")
		end
	end
end

commands.speed = function(args)
	local targetName, speedStr = args[1], args[2]
	local speed = tonumber(speedStr)
	if not targetName or not speed then return end

	local targetPlayer = findPlayer(targetName)
	if targetPlayer and targetPlayer.Character then
		local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.WalkSpeed = speed
			print("✅ Speed command executed.")
		end
	end
end

-- Connect chat command listener
Players.PlayerAdded:Connect(function(player)
	player.Chatted:Connect(function(message)
		if not isAdmin(player) then return end

		message = message:lower()
		local split = message:split(" ")
		local slashCommand = split[1]

		if not slashCommand:match("^" .. PREFIX) then return end

		local commandName = slashCommand:sub(#PREFIX + 1)
		local command = commands[commandName]

		if command then
			local args = {}
			for i = 2, #split do
				table.insert(args, split[i])
			end
			command(args)
		end
	end)
end)
