-- Do not touch
QBCore = exports['qb-core']:GetCoreObject()
Config = {}

-- Show blips at all?
Config.ShowBlips = true

-- Update blips on discovery or just show initial blips?
Config.DynamicBlips = true

-- The minimum distance between the player and the blip so that it is discovered
Config.DiscoverDistance = 15

-- Blip size
Config.BlipScale = 0.8

-- List of blips
Config.Blips = {
	{
		initialLabel = "Undiscovered Blip", 			 -- blip name BEFORE discovery
		discoveredLabel = "Discovered Blip", 	 -- blip name AFTER discovery
		initialColor = 0, 						 -- blip color BEFORE discovery
		discoveredColor = 0, 					 -- blip color AFTER discovery
		initialSprite = 456, 					 -- blip sprite BEFORE disocovery
		discoveredSprite = 310,					 -- blip sprite AFTER discovery
		coords = vector3(2239.62, 5071.91, 46.9) -- blip location (tip: /vector3)
	},
}