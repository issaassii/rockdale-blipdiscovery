if Config.Framework == "qb-core" then
	IsQB = true
	QBCore = exports['qb-core']:GetCoreObject()
	RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
		TriggerServerEvent("rockdale-blipdiscovery:InitializePlayer")
	end)
	RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
		for _, identifier in pairs(BlipsTable) do
			RemoveBlip(identifier)
		end
		BlipsTable = {}
		TriggerServerEvent("rockdale-blipdiscovery:SaveBlips", json.encode(DiscoveredBlips))
	end)
else
	IsQB = false
	ESX = exports['es_extended']:getSharedObject()
	RegisterNetEvent('esx:playerLoaded', function()
		TriggerServerEvent("rockdale-blipdiscovery:InitializePlayer")
	end)
	RegisterNetEvent('esx:onPlayerLogout', function()
		for _, identifier in pairs(BlipsTable) do
			RemoveBlip(identifier)
		end
		BlipsTable = {}
		TriggerServerEvent("rockdale-blipdiscovery:SaveBlips", json.encode(DiscoveredBlips))
	end)
end

local function IsBlipDiscovered(val)
    for _, v in ipairs(DiscoveredBlips) do
        if v == val then return true end
    end
	return false
end

PlayerIsLoaded = false
local isInsideZone = false
local inProgress = false
DiscoveredBlips = {}
BlipsTable = {}

RegisterNetEvent('rockdale-blipdiscovery:UpdatePlayerBlipsTable', function(table)
	DiscoveredBlips = table
	TriggerEvent("rockdale-blipdiscovery:GenerateBlips")
	PlayerIsLoaded = true
end)

RegisterNetEvent("rockdale-blipdiscovery:GenerateBlips", function()
	if Config.ShowBlips then
		Citizen.CreateThread(function()
			for _, blip in pairs(Config.Blips) do
				local this = AddBlipForCoord(blip.coords.x, blip.coords.y, blip.coords.z)
				if Config.DynamicBlips then
					SetBlipAsShortRange(this, true)
					SetBlipDisplay(this, 4)
					SetBlipScale(this, Config.BlipScale)
					if not IsBlipDiscovered(blip.discoveredLabel) then
						SetBlipSprite(this, blip.initialSprite)
						SetBlipColour(this, blip.initialColor)
						BeginTextCommandSetBlipName("STRING")
						AddTextComponentString(blip.initialLabel)
						EndTextCommandSetBlipName(this)
						BlipsTable[blip.initialLabel] = this
					else
						SetBlipSprite(this, blip.discoveredSprite)
						SetBlipColour(this, blip.discoveredColor)
						BeginTextCommandSetBlipName("STRING")
						AddTextComponentString(blip.discoveredLabel)
						EndTextCommandSetBlipName(this)
						BlipsTable[blip.discoveredLabel] = this
					end
				else
					SetBlipAsShortRange(this, true)
					SetBlipSprite(this, blip.initialSprite)
					SetBlipColour(this, blip.initialColor)
					BeginTextCommandSetBlipName("STRING")
					AddTextComponentString(blip.initialLabel)
					EndTextCommandSetBlipName(this)
					SetBlipDisplay(this, 4)
					SetBlipScale(this, Config.BlipScale)
					BlipsTable[blip.initialLabel] = this
				end
			end
		end)
	end
end)

if Config.DynamicBlips then
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(1)
			if PlayerIsLoaded then
				for _, blip in pairs(Config.Blips) do
					local playerCoords = GetEntityCoords(PlayerPedId(), false)
					local blipCoords = blip.coords
					local dist = #(playerCoords - blipCoords)
					if dist <= Config.DiscoverDistance then
						if not IsBlipDiscovered(blip.discoveredLabel) and not inProgress then
							isInsideZone = true
							inProgress = true
							RemoveBlip(BlipsTable[blip.initialLabel])
							BlipsTable[blip.initialLabel] = nil
							table.insert(DiscoveredBlips, blip.discoveredLabel)
							if IsQB then
								QBCore.Functions.Notify('Discovered New Location: '..blip.discoveredLabel, 'primary', 7500)
							else
								TriggerEvent("ESX:Notify", "info", 7500, 'Discovered New Location: '..blip.discoveredLabel)
							end
							local this = AddBlipForCoord(blip.coords.x, blip.coords.y, blip.coords.z)
							SetBlipAsShortRange(this, true)
							SetBlipSprite(this, blip.discoveredSprite)
							SetBlipColour(this, blip.discoveredColor)
							BeginTextCommandSetBlipName("STRING")
							AddTextComponentString(blip.discoveredLabel)
							EndTextCommandSetBlipName(this)
							SetBlipDisplay(this, 4)
							SetBlipScale(this, Config.BlipScale)
							BlipsTable[blip.discoveredLabel] = this
							inProgress = false
						end
					else
						isInsideZone = false
					end
				end
			else
				Citizen.Wait(Config.AutosaveTime*1000)
			end
		end
	end)
end

Citizen.CreateThread(function()
	while true do
		Wait(Config.AutosaveTime*1000)
		if PlayerIsLoaded then
			TriggerServerEvent("rockdale-blipdiscovery:SaveBlips", json.encode(DiscoveredBlips))
			-- print("Saved Discovered Blips")
		end
	end
end)

RegisterCommand("resetPersonalBlips", function(source, args , rawCommand)
	if not isInsideZone then
		for _, identifier in pairs(BlipsTable) do
			RemoveBlip(identifier)
		end
		BlipsTable = {}
		DiscoveredBlips = {}
		TriggerEvent("rockdale-blipdiscovery:UpdatePlayerBlipsTable", {})
		if IsQB then
			QBCore.Functions.Notify("Reset blips successfully", 'success', 7500)
		else
			TriggerEvent("ESX:Notify", "success", 7500, "Reset blips successfully")
		end
	else
		if IsQB then
			QBCore.Functions.Notify("You may not do this when near a blip", 'error', 7500)
		else 
			TriggerEvent("ESX:Notify", "error", 7500, "You may not do this when near a blip")
		end
	end
end, false)

TriggerEvent('chat:addSuggestion', '/resetPersonalBlips', "Reset discovered blips to their initial style")