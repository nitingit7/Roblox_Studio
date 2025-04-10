local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local BanStore = DataStoreService:GetDataStore("BannedPlayers")

--[[local function FindPlayer(playerName)
	for _, player in pairs(game.Players:GetPlayers()) do
		if string.lower(player.Name) == playerName then
			return player
		end
	end

	return nil
end]]

local function isBanned(player)
	
	local success, result = pcall(function()
		return BanStore:GetAsync(player.UserId)
	end)
	return success and result == true
end

local function banPlayer(userId)
	if userId == 5206990893 then
		return nil
	end

	pcall(function()
		BanStore:SetAsync(userId, true)
	end)
end

-- Kick banned players on join
Players.PlayerAdded:Connect(function(player)
	if isBanned(player) then
		player:Kick("You are permanently banned from this game.")
	end
end)

-- Example admin ban command
Players.PlayerAdded:Connect(function(player)
	player.Chatted:Connect(function(message)
		if player.Name == "LuffyXGojo7" then -- Change to your admin name(s)
			local split = message:split(" ")
			if split[1] == "/ban" then
				local targetName = split[2]
				local targetPlayer = Players:FindFirstChild(targetName)
				if targetPlayer then
					banPlayer(targetPlayer.UserId)
					targetPlayer:Kick("You have been permanently banned by Admin.")
				else
					print("The player is not found "..targetName)
				end
			end
		end
	end)
end)
