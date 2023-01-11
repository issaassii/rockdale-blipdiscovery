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
- [GitHub](https://github.com/jackwemble/rockdale-blipdiscovery)

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

## Notes
Please keep in mind every blip has to have a **unique** discovered label in the config or it will be discovered if another blip with the same name is.