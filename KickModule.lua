-- ModuleScript

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local module = {}
module.gameName = 'YourGameNameHere' -- Default value, can be overridden
module.pollInterval = 2 -- Default to 2 seconds, can be overridden

-- Define the URL of the Vercel serverless function
local pollUrl = 'https://appbloxinteractive.glitch.me/poll-kick-data' -- Replace with your actual Vercel URL

-- Function to kick a player
local function kickPlayer(username, reason)
	local player = Players:FindFirstChild(username)
	if player then
		player:Kick(reason)

		-- Notify the serverless function to remove the entry
		local removeUrl = 'https://appbloxinteractive.glitch.me/remove-kick-data' -- Replace with your actual Vercel URL
		local removeData = HttpService:JSONEncode({
			username = username,
			gameName = module.gameName
		})

		pcall(function()
			HttpService:PostAsync(removeUrl, removeData, Enum.HttpContentType.ApplicationJson)
		end)
	end
end

-- Function to check for kick requests
local function checkForKickRequests()
	local success, response = pcall(function()
		return HttpService:GetAsync(pollUrl .. '?gameName=' .. HttpService:UrlEncode(module.gameName))
	end)

	if success then
		local data = HttpService:JSONDecode(response)

		for _, entry in ipairs(data) do
			local username = entry.username
			local reason = "You have been kicked for the following reason: "..entry.reason.. ". (Copyright BloxInteractive Moderation)"

			-- Kick the player if they are in the game
			kickPlayer(username, reason)
		end
	else
		warn("Failed to fetch kick requests: " .. response)
	end
end

-- Poll function
local function startPolling()
	while true do
		checkForKickRequests()
		wait(module.pollInterval) -- Use configurable polling interval
	end
end

-- Start polling in a separate thread
coroutine.wrap(startPolling)()

return module
