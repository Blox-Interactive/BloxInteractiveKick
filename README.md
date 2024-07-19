# Blox Interactive Kick Module

## Overview

The Blox Interactive Kick Module is designed to manage player kick requests from an external server. This module allows you to configure the `gameName` and polling interval to suit your needs. It includes a script for fetching and integrating the module into your Roblox game.

## Features

- **External Kick Management:** Integrates with a serverless function to handle player kick requests.
- **Configurable Settings:** Allows customization of the `gameName` and polling interval.
- **Automatic Module Integration:** Fetches and loads the module from GitHub directly into Roblox Studio.

## Installation

### 1. **Insert the Module Fetching Script**

To use the Blox Interactive Kick Module, insert the following script into your game. This script will download the module from GitHub and configure it for your game.

**Script to Load Blox Interactive Kick Module:**

```lua
-- Script to Download and Load Blox Interactive Kick Module from GitHub

local HttpService = game:GetService("HttpService")

-- Define the GitHub URL for the raw module file
local moduleUrl = 'https://raw.githubusercontent.com/username/repository/branch/KickModule.lua' -- Replace with your GitHub URL

-- Function to fetch and load the module from GitHub
local function loadModule(url)
    local success, response = pcall(function()
        return HttpService:GetAsync(url)
    end)
    
    if success then
        local moduleScript = Instance.new("ModuleScript")
        moduleScript.Name = "KickModule"
        moduleScript.Source = response
        moduleScript.Parent = game.ServerScriptService -- Or choose another location as needed
        
        return require(moduleScript)
    else
        warn("Failed to load module: " .. response)
        return nil
    end
end

-- Load the module
local kickModule = loadModule(moduleUrl)

-- Check if the module was loaded successfully
if kickModule then
    -- Configure the module
    kickModule.gameName = 'NewGameName' -- Replace with your actual game name
    kickModule.pollInterval = 600 -- Set to your desired polling interval in seconds (600 seconds = 10 minutes)
else
    warn("KickModule could not be loaded.")
end
