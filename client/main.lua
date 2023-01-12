if Config.Framework == "qb-core" then
	IsQB = true
	QBCore = exports['qb-core']:GetCoreObject()
	RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
		TriggerServerEvent("rockdale-blipdiscovery:InitializePlayer")
	end)
	RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
		IsLoggingOut = true
		for _, identifier in pairs(BlipsTable) do
			RemoveBlip(identifier)
		end
		BlipsTable = {}
		TriggerServerEvent("rockdale-blipdiscovery:SaveBlips", json.encode(DiscoveredBlips))
		PlayerIsLoaded = false
	end)
else
	IsQB = false
	ESX = exports['es_extended']:getSharedObject()
	RegisterNetEvent('esx:playerLoaded', function()
		TriggerServerEvent("rockdale-blipdiscovery:InitializePlayer")
	end)
	RegisterNetEvent('esx:onPlayerLogout', function()
		IsLoggingOut = true
		for _, identifier in pairs(BlipsTable) do
			RemoveBlip(identifier)
		end
		BlipsTable = {}
		TriggerServerEvent("rockdale-blipdiscovery:SaveBlips", json.encode(DiscoveredBlips))
		PlayerIsLoaded = false
	end)
end

RegisterNetEvent('rockdale-blipdiscovery:PlayerDropped', function()
	IsLoggingOut = true
end)

local function IsBlipDiscovered(val)
    for _, v in ipairs(DiscoveredBlips) do
        if v == val then return true end
    end
	return false
end

IsLoggingOut = true
PlayerIsLoaded = false
local isInsideZone = false
local inProgress = false
DiscoveredBlips = {}
BlipsTable = {}

RegisterNetEvent('rockdale-blipdiscovery:UpdatePlayerBlipsTable', function(table)
	DiscoveredBlips = table
	TriggerEvent("rockdale-blipdiscovery:GenerateBlips")
	PlayerIsLoaded = true
	IsLoggingOut = false
end)

RegisterNetEvent("rockdale-blipdiscovery:GenerateBlips", function()
	if Config.ShowBlips then
		Citizen.CreateThread(function()
			if Config.DynamicBlips then
				for _, blip in pairs(Config.Blips) do
					local this = AddBlipForCoord(blip.coords.x, blip.coords.y, blip.coords.z)
					SetBlipAsShortRange(this, true)
					SetBlipDisplay(this, 4)
					SetBlipScale(this, Config.BlipScale)
					if not IsBlipDiscovered(tostring(blip.coords.x+blip.coords.y+blip.coords.z).."_"..blip.discoveredLabel) then
						SetBlipSprite(this, blip.initialSprite)
						SetBlipColour(this, blip.initialColor)
						BeginTextCommandSetBlipName("STRING")
						AddTextComponentString(blip.initialLabel)
						EndTextCommandSetBlipName(this)
						BlipsTable[tostring(blip.coords.x+blip.coords.y+blip.coords.z).."_"..blip.initialLabel] = this
					else
						SetBlipSprite(this, blip.discoveredSprite)
						SetBlipColour(this, blip.discoveredColor)
						BeginTextCommandSetBlipName("STRING")
						AddTextComponentString(blip.discoveredLabel)
						EndTextCommandSetBlipName(this)
						BlipsTable[tostring(blip.coords.x+blip.coords.y+blip.coords.z).."_"..blip.discoveredLabel] = this
					end
				end
			else
				for _, blip in pairs(Config.Blips) do
					local this = AddBlipForCoord(blip.coords.x, blip.coords.y, blip.coords.z)
					SetBlipAsShortRange(this, true)
					SetBlipSprite(this, blip.initialSprite)
					SetBlipColour(this, blip.initialColor)
					BeginTextCommandSetBlipName("STRING")
					AddTextComponentString(blip.initialLabel)
					EndTextCommandSetBlipName(this)
					SetBlipDisplay(this, 4)
					SetBlipScale(this, Config.BlipScale)
					BlipsTable[tostring(blip.coords.x+blip.coords.y+blip.coords.z).."_"..blip.initialLabel] = this
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
						if not IsBlipDiscovered(tostring(blip.coords.x+blip.coords.y+blip.coords.z).."_"..blip.discoveredLabel) and not inProgress then
							isInsideZone = true
							inProgress = true
							RemoveBlip(BlipsTable[tostring(blip.coords.x+blip.coords.y+blip.coords.z).."_"..blip.initialLabel])
							BlipsTable[tostring(blip.coords.x+blip.coords.y+blip.coords.z).."_"..blip.initialLabel] = nil
							table.insert(DiscoveredBlips, tostring(blip.coords.x+blip.coords.y+blip.coords.z).."_"..blip.discoveredLabel)
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
							-- BlipsTable[blip.discoveredLabel] = this
							BlipsTable[tostring(blip.coords.x+blip.coords.y+blip.coords.z).."_"..blip.discoveredLabel] = this
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
		if PlayerIsLoaded and not IsLoggingOut then
			TriggerServerEvent("rockdale-blipdiscovery:SaveBlips", json.encode(DiscoveredBlips))
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