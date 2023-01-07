local isDiscovered = false
local inProgress = false
local isInsideZone = false
blips_table = {}

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function() -- On load, if not in db then insert
	TriggerServerEvent("rockdale-blipdiscover:addToDB")
	TriggerEvent("rockdale-blipdiscover:createBlips")
end)

RegisterNetEvent("rockdale-blipdiscover:createBlips", function()
	if Config.ShowBlips then
		for _, blip in pairs(Config.Blips) do
			local this = AddBlipForCoord(blip.coords.x, blip.coords.y, blip.coords.z)
			isBlipDiscovered(blip.discoveredLabel)
			Wait(100)
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
	end
end)

if Config.DynamicBlips then
	Citizen.CreateThread(function()	-- Blip interactions
		while true do
			Citizen.Wait(1)
			for _, blip in pairs(Config.Blips) do
				local playerCoords = GetEntityCoords(PlayerPedId(), false)
				local blipCoords = blip.coords
				local dist = #(playerCoords - blipCoords)
				if dist <= Config.DiscoverDistance then
					isInsideZone = true
					isBlipDiscovered(blip.discoveredLabel)
					Wait(100)
					if not isDiscovered and not inProgress then
						inProgress = true
						TriggerServerEvent("rockdale-blipdiscover:blipDiscovered", "`"..blip.discoveredLabel.."`")
						QBCore.Functions.Notify('Discovered New Location: '..blip.discoveredLabel, 'primary', 7500)
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

-- blip information
function isBlipDiscovered(blip) -- Ask server if its been discovered
	TriggerServerEvent("rockdale-blipdiscover:isBlipDiscovered", "%`"..blip.."`%")
end

RegisterNetEvent("rockdale-blipdiscover:isBlipDiscoveredBool", function(data) -- Answer from server
	isDiscovered = data
end)

-- reset blips
RegisterCommand("resetPersonalBlips", function(source, args , rawCommand)
	if not isInsideZone then
		TriggerServerEvent("rockdale-blipdiscover:ResetPersonalBlips")
	else
		QBCore.Functions.Notify("You may not do this when near a blip", 'error', 7500)
	end
end, false)

-- On load, if not in db then insert
RegisterNetEvent('QBCore:Client:OnPlayerUnload', function() 
	TriggerEvent("rockdale-blipdiscover:ClearAllBlips")
end)

RegisterNetEvent("rockdale-blipdiscover:ClearAllBlips", function() 
	for _, v in pairs(blips_table) do
		RemoveBlip(v)
	end
	blips_table = {}
end)
