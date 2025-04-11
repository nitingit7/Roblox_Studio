local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local BanStore = DataStoreService:GetDataStore("BannedPlayers")

local commands = {}
Prefix = "/"
local admin = {
	"LuffyXGojo7";
	"alanwalker_941";
}

--local bannedPlayers = {}

local function isBanned(player)

	local success, result = pcall(function()
		return BanStore:GetAsync(player.UserId)
	end)
	return success and result == true
end

local function isAdmin(player) -- player is an object
	for _, v in pairs(admin) do
		if v == player.Name then
			return true
		end
	end
	
	return false
end

local function FindPlayer(playerName)
	for _, player in pairs(game.Players:GetPlayers()) do
		if string.lower(player.Name) == playerName then
			return player
		end
	end
	
	return nil
end

commands.tp = function(arguments)
	print("command is fired")
	
	local PLayerIsTeleporting = arguments[1]
	local PlayerToTeleport = arguments[2]
	
	if PLayerIsTeleporting and PlayerToTeleport then
		local PlToTl = FindPlayer(PLayerIsTeleporting)
		local PlToTlTo = FindPlayer(PlayerToTeleport)
		
		if PlToTlTo and PlToTl then
			PlToTl.Character.HumanoidRootPart.CFrame = PlToTlTo.Character.HumanoidRootPart.CFrame
			print("Command Sucessfully Executed")
		end
		
	end
end

--ChatGPT
commands.kick = function(args)
	local targetName = args[1]
	local reason = table.concat(args, " ", 2) -- get reason if any

	local targetPlayer = FindPlayer(targetName)
	if targetPlayer then
		targetPlayer:Kick(reason ~= "" and reason or "You were kicked by an admin.")
		print("✅ Kick command executed.")	
	else
		print("No Such Player Found")
	end
end


commands.ban = function(args)
	local targetName = args[1]
	
	local function banPlayer(userId)
		if userId ~= 5206990893 then
			pcall(function()
				BanStore:SetAsync(userId, true)
			end)
		end
	end

	local targetPlayer = FindPlayer(targetName)
	if targetPlayer then
		local playerUserId = targetPlayer.UserId
		if playerUserId ~= 5206990893 then
			banPlayer(playerUserId)
			targetPlayer:Kick("You have been permanently banned by Admin.")
			print("✅ Ban command executed.")
		else
			print("The targer player is an Admin")
		end
	else
		print("The player "..targetName.." was not found in the game")
	end
end

commands.unban = function(args)
	local TargetUserId = args[1]
	
	if TargetUserId then
		
		local function isPlayerBanned(userId)
			local success, isBanned = pcall(function()
				return BanStore:GetAsync(userId)
			end)

			return success and isBanned == true
		end
		
		if isPlayerBanned(TargetUserId) then
			
			pcall(function()
				BanStore:SetAsync(TargetUserId, false)
			end)
			
			print("✅ Unban command executed.")
		else
			print("🔴 Unban command not Executed.")
		end
	end

end



commands.speed = function(arguments)
	local playertoSpeed = arguments[1]
	local SpeedArgument = arguments[2]
	
	if playertoSpeed then
		local plt = FindPlayer(playertoSpeed)
		if plt then
			plt.Character.Humanoid.WalkSpeed = SpeedArgument
			print("Speed Command is succesfully Executed")
		end
	end
end

game.Players.PlayerAdded:Connect(function(player)
	if isBanned(player) then
		player:Kick("You are permanently banned from this game.")
	end
	player.Chatted:Connect(function(message, recipient)
		if isAdmin(player) then
			message = string.lower(message)
			local splitmessage = message:split(" ") --{"/tp","LuffyXGojo7,Blob"}
			local slashcommand = splitmessage[1]
			local cmd = slashcommand:split(Prefix)
			local cmdName = cmd[2]
			if commands[cmdName] then
				local argument = {}
				for i = 2, #splitmessage,1 do
					table.insert(argument,splitmessage[i])
				end
				commands[cmdName](argument)
			end
		end
		
	end)
end)
