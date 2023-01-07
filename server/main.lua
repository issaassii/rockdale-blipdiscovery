
function GetPlayerCitizenID(src)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	return Player.PlayerData.citizenid
end 

RegisterNetEvent('rockdale-blipdiscover:addToDB', function()
	local src = source
	local CitizenID = GetPlayerCitizenID(src)
	MySQL.insert('INSERT IGNORE INTO `player_blips` (`characterid`, `discovered_blips`) VALUES (?, ?)', {CitizenID, " "}, function()
		print("Success")
	end)
end)

RegisterNetEvent('rockdale-blipdiscover:blipDiscovered', function(blip)
	local src = source
	local CitizenID = GetPlayerCitizenID(src)
	MySQL.update('UPDATE `player_blips` SET `discovered_blips` = CONCAT(`discovered_blips`, ?) WHERE `discovered_blips` NOT LIKE ? AND `characterid` = ?', {blip.." ", "%`"..blip.."`%", CitizenID}, function()
		print("Discovered blip")
	end)
end)

RegisterNetEvent('rockdale-blipdiscover:isBlipDiscovered', function(blip)
	local src = source
	local CitizenID = GetPlayerCitizenID(src)
	local isDiscovered = MySQL.query.await('SELECT * FROM `player_blips` WHERE characterid = ? AND discovered_blips LIKE ?', {CitizenID, blip})
	if not next(isDiscovered) then
		TriggerClientEvent("rockdale-blipdiscover:isBlipDiscoveredBool", src, false)
	else
		TriggerClientEvent("rockdale-blipdiscover:isBlipDiscoveredBool", src, true)
	end
end)

RegisterNetEvent('rockdale-blipdiscover:ResetPersonalBlips', function()
	local CitizenID = GetPlayerCitizenID(source)
	MySQL.update('UPDATE `player_blips` SET `discovered_blips` = ? WHERE `characterid` = ?', {" ", CitizenID}, function()
		print("Reset discovered blips for "..CitizenID)
	end)
	TriggerClientEvent("rockdale-blipdiscover:ClearAllBlips", source)
	TriggerClientEvent("rockdale-blipdiscover:createBlips", source)
	TriggerClientEvent("QBCore:Notify", source, "Reset discovered blips", "success", 7500)
end)