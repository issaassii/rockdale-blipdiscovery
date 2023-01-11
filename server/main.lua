if Config.Framework == "qb-core" then
	IsQB = true
	QBCore = exports['qb-core']:GetCoreObject()
else
	IsQB = false
	ESX = exports['es_extended']:getSharedObject()
end

local function GetPlayerCitizenID(src)
	local src = source
	if IsQB then
		local Player = QBCore.Functions.GetPlayer(src)
		return Player.PlayerData.citizenid
	else
		local Player = ESX.GetPlayerFromId(src)
		return Player.getIdentifier()
	end
end

RegisterNetEvent('rockdale-blipdiscovery:InitializePlayer', function()
	local src = source
	local CitizenID = GetPlayerCitizenID(src)
	MySQL.insert('INSERT IGNORE INTO `player_blips` (`characterid`, `discovered_blips`) VALUES (?, ?)', {CitizenID, "[]"}, function()
		print(CitizenID.." was initialized successfully")
		local DiscoveredBlipsTable = MySQL.query.await('SELECT `discovered_blips` FROM `player_blips` WHERE characterid = ?', {CitizenID})
		TriggerClientEvent("rockdale-blipdiscovery:UpdatePlayerBlipsTable", src, json.decode(DiscoveredBlipsTable[1]["discovered_blips"]))
	end)
end)

RegisterNetEvent('rockdale-blipdiscovery:SaveBlips', function(DiscoveredBlips)
	local src = source
	local CitizenID = GetPlayerCitizenID(src)
	MySQL.update('UPDATE `player_blips` SET `discovered_blips` = ? WHERE `characterid` = ?', {DiscoveredBlips, CitizenID}, function()
		-- print("Saved discovered blips for "..CitizenID) -- Uncomment if you want to log blip saves
	end)
end)

RegisterNetEvent('rockdale-blipdiscovery:ResetPersonalBlips', function()
	TriggerClientEvent("rockdale-blipdiscovery:UpdatePlayerBlipsTable", src, json.decode("[]"))
end)
