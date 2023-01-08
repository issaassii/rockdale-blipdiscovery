if Config.Framework == "qb-core" then
	isQB = true
	QBCore = exports['qb-core']:GetCoreObject()
	RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
		TriggerServerEvent("rockdale-blipdiscover:addToDB")
		TriggerEvent("rockdale-blipdiscover:createBlips")
	end)
	RegisterNetEvent('QBCore:Client:OnPlayerUnload', function() 
		TriggerEvent("rockdale-blipdiscover:ClearAllBlips")
	end)
else
	isQB = false
	ESX = exports['es_extended']:getSharedObject()
	RegisterNetEvent('esx:playerLoaded', function() 
		TriggerServerEvent("rockdale-blipdiscover:addToDB")
		TriggerEvent("rockdale-blipdiscover:createBlips")
	end)
	RegisterNetEvent('esx:onPlayerLogout', function()
		TriggerEvent("rockdale-blipdiscover:ClearAllBlips")
	end)
end

local isDiscovered = false
local inProgress = false
local isInsideZone = false
blips_table = {}

RegisterNetEvent("rockdale-blipdiscover:createBlips", function()
	if Config.ShowBlips then
		Citizen.CreateThread(function()
			for _, blip in pairs(Config.Blips) do
				local this = AddBlipForCoord(blip.coords.x, blip.coords.y, blip.coords.z)
				isBlipDiscovered(blip.discoveredLabel)
				Wait(1000)
				if Config.DynamicBlips then
					SetBlipAsShortRange(this, true)
					if not isDiscovered then
						SetBlipSprite(this, blip.initialSprite)
						SetBlipColour(this, blip.initialColor)
						BeginTextCommandSetBlipName("STRING")
						AddTextComponentString(blip.initialLabel)
						EndTextCommandSetBlipName(this)
					else
						SetBlipSprite(this, blip.discoveredSprite)
						SetBlipColour(this, blip.discoveredColor)
						BeginTextCommandSetBlipName("STRING")
						AddTextComponentString(blip.discoveredLabel)
						EndTextCommandSetBlipName(this)
					end
					SetBlipDisplay(this, 4)
					SetBlipScale(this, Config.BlipScale)
					blips_table[blip.coords.x+blip.coords.y+blip.coords.z] = this
				else
					SetBlipAsShortRange(this, true)
					SetBlipSprite(this, blip.initialSprite)
					SetBlipColour(this, blip.initialColor)
					BeginTextCommandSetBlipName("STRING")
					AddTextComponentString(blip.initialLabel)
					EndTextCommandSetBlipName(this)
					SetBlipDisplay(this, 4)
					SetBlipScale(this, Config.BlipScale)
					blips_table[blip.coords.x+blip.coords.y+blip.coords.z] = this
				end
			end
		end)
	end
end)

if Config.DynamicBlips then
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(1)
			for _, blip in pairs(Config.Blips) do
				local playerCoords = GetEntityCoords(PlayerPedId(), false)
				local blipCoords = blip.coords
				local dist = #(playerCoords - blipCoords)
				if dist <= Config.DiscoverDistance then
					isInsideZone = true
					isBlipDiscovered(blip.discoveredLabel)
					Wait(1000) -- To account for slow db
					if not isDiscovered and not inProgress then
						inProgress = true
						TriggerServerEvent("rockdale-blipdiscover:blipDiscovered", "`"..blip.discoveredLabel.."`")
						if isQB then
							QBCore.Functions.Notify('Discovered New Location: '..blip.discoveredLabel, 'primary', 7500)
						else
							TriggerEvent("ESX:Notify", "info", 7500, 'Discovered New Location: '..blip.discoveredLabel)
						end
						Wait(200)
						RemoveBlip(blips_table[blip.coords.x+blip.coords.y+blip.coords.z])
						local this = AddBlipForCoord(blip.coords.x, blip.coords.y, blip.coords.z)
						SetBlipAsShortRange(this, true)
						SetBlipSprite(this, blip.discoveredSprite)
						SetBlipColour(this, blip.discoveredColor)
						BeginTextCommandSetBlipName("STRING")
						AddTextComponentString(blip.discoveredLabel)
						EndTextCommandSetBlipName(this)
						SetBlipDisplay(this, 4)
						SetBlipScale(this, Config.BlipScale)
						blips_table[blip.coords.x+blip.coords.y+blip.coords.z] = this
						inProgress = false
					end
				else
					isInsideZone = false
				end
			end
		end
	end)
end

function isBlipDiscovered(blip)
	TriggerServerEvent("rockdale-blipdiscover:isBlipDiscovered", "%`"..blip.."`%")
end

RegisterNetEvent("rockdale-blipdiscover:isBlipDiscoveredBool", function(data)
	isDiscovered = data
end)

RegisterCommand("resetPersonalBlips", function(source, args , rawCommand)
	if not isInsideZone then
		TriggerServerEvent("rockdale-blipdiscover:ResetPersonalBlips")
	else
		if isQB then
			QBCore.Functions.Notify("You may not do this when near a blip", 'error', 7500)
		else 
			TriggerEvent("ESX:Notify", "error", 7500, "You may not do this when near a blip")
		end
	end
end, false)

TriggerEvent('chat:addSuggestion', '/resetPersonalBlips', "Reset discovered blips to their initial style")

RegisterNetEvent("rockdale-blipdiscover:ClearAllBlips", function() 
	for _, v in pairs(blips_table) do
		RemoveBlip(v)
	end
	blips_table = {}
end)