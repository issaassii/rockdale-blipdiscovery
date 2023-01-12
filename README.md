# Blip Discovery (Rewritten)
Originally a script made for my [server](https://discord.com/invite/GpttmrUPgk) that allows players to discover areas within the map through blip changes for QB-Core & ESX.

## Features
- A blip will change and remain changed when a player comes within a predefined range of that blip. Blip changes include sprite, color, and text. Check screenshots for more.
- Players can reset their personal discovered blips
- Widely and easily customizable
## Screenshots

<details>
    <summary>Click to view</summary>
    Before discovering a blip<br>
	<img src="https://i.ibb.co/pQ6tV3r/1.png"/><br>
    After discovering a blip (getting close to it)<br>
	<img src="https://i.ibb.co/cTwSGw2/2.png"><br>
    Resetting personal blips<br>
	<img src="https://i.ibb.co/3kMpKzm/3.png"><br>
    Trying to reset blips while near a blip (causes issues otherwise)<br>
	<img src="https://i.ibb.co/zQkgXt7/4.png"><br>
</details>

## Requirements
- [qb-core](https://github.com/qbcore-framework/qb-core) or [esx-legacy](https://github.com/esx-framework/esx-legacy)
- [oxmysql](https://github.com/overextended/oxmysql)

## Download
- Download from [releases](https://github.com/JackWemble/rockdale-blipdiscovery/releases/tag/v1.3.0) or you may have bugs

## Installation
- Import ```rockdale-blipdiscovery.sql``` into your database
- Drag & drop into resources
- Ensure resource in server.cfg
- Edit config.lua

## Changelog
- **1.0**: Initial release
- **1.1**: Added ESX compatibility & performance adjustments
- **1.2**: Completely rewritten:
	- Fixed blip loading times (instant now)
	- Fixed blip being discovered when it shouldn't be
	- Fixed issue where both discovered and undiscovered blips would load at the same time
	- Added version checker
	- Updated license
	- Performance improvements
- **1.3**:
	- The unique identifier is now the vector of the blip, therefore, you can have blips with duplicate initial and discovered labels

## Notes

**Updating from 1.1 and under to 1.2+:** Use a fresh install of the script, open your old config.lua, and copy paste "Config.Blips" table over to the new config.

**Updating from 1.2 to 1.3**: Run the query ```sql DROP DATABASE player_blips``` and then reimport the database file

Every blip has to have unique coords in the config or it will cause issues with the initial blips.
