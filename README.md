# Roblox Kick Module

## Overview
This module manages kick requests from an external server. You can configure the `gameName` and polling interval.

## Installation

1. **Download the Module:**
   - The module is hosted on GitHub. Use the following script to fetch and use it in Roblox Studio.

   ```lua
   local HttpService = game:GetService("HttpService")

   local moduleUrl = 'https://raw.githubusercontent.com/username/repository/branch/KickModule.lua' -- Replace with your URL

   local function loadModule(url)
       local success, response = pcall(function()
           return HttpService:GetAsync(url)
       end)
       
       if success then
           local moduleScript = Instance.new("ModuleScript")
           moduleScript.Name = "KickModule"
           moduleScript.Source = response
           moduleScript.Parent = game.ServerScriptService -- or wherever you want to store it
           
           return require(moduleScript)
       else
           warn("Failed to load module: " .. response)
           return nil
       end
   end

   local kickModule = loadModule(moduleUrl)

   if kickModule then
       kickModule.gameName = 'NewGameName'
       kickModule.pollInterval = 600 -- Set to 10 minutes (600 seconds)
   else
       warn("KickModule could not be loaded.")
   end
