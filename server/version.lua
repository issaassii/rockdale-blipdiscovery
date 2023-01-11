if Config.CheckForUpdates then
    Citizen.CreateThread(function()
		ResourceName = "^3Rockdale Blip Discovery^7"
		function VersionCheck(err, responseText, headers)
			CurrentVersion = LoadResourceFile(GetCurrentResourceName(), "VERSION")
			if responseText == nil then
				print(ResourceName..":^1 failed to check for update\n"..ResourceName..": ^1Error "..err.."^7")
				return
			end
			if CurrentVersion ~= responseText and tonumber(CurrentVersion) < tonumber(responseText) then
				print("\n^1----------------------------------------------------------------------------------^7")
				print(ResourceName.."\n^1Version is outdated^7\nLatest version is: ^2"..responseText.."^7Installed version: ^1"..CurrentVersion.."^7\nUpdate from 	")
				print("^1----------------------------------------------------------------------------------^7")
			elseif tonumber(CurrentVersion) > tonumber(responseText) then
				print("\n^3----------------------------------------------------------------------------------^7")
				print(ResourceName.."\nLatest version: ^2"..responseText.."^7Installed version: ^3"..CurrentVersion.."^7 (developer copy)")
				print("^3----------------------------------------------------------------------------------^7")
			else
				print("\n^2----------------------------------------------------------------------------------^7")
				print(ResourceName.."\nVersion is up to date. (^2"..CurrentVersion.."^7)")
				print("^2----------------------------------------------------------------------------------^7")
			end
		end
        PerformHttpRequest("https://raw.githubusercontent.com/jackwemble/rockdale-blipdiscovery/master/VERSION", VersionCheck, "GET")
    end)
end
