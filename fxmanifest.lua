fx_version 'cerulean'
game 'gta5'

author 'Owl#7402'
description 'Blip/Region Discovery System for QB-Core'
version '1.0'

client_scripts {
	'config.lua',
    'client/*.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'config.lua',
    'server/*.lua',
}