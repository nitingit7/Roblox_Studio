local commands = {}
Prefix = "/"
local admin = {
	"LuffyXGojo7";
	"alanwalker_941";
}

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
