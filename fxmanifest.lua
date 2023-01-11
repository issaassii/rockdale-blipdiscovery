fx_version 'cerulean'
game 'gta5'

author 'Owl#7402'
description 'Blip/Region Discovery System for QB-Core & ESX'
version '1.2.0'

client_scripts {
	'config.lua',
    'client/main.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'config.lua',
    'server/main.lua',
    'server/version.lua',
}