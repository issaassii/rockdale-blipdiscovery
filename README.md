# Blip Discovery
Originally a script made for my [server](https://discord.com/invite/GpttmrUPgk) that allows players to discover areas within the map through blip changes for QB-Core & ESX.

## Features
- A blip will change and remain changed when a player comes within a predefined range of that blip. Blip changes include sprite, color, and text. Check screenshots for more.
- Players can reset their personal discovered blips
- Widely and easily customizable

## Screenshots
Before discovering a blip<br/>
![image](https://i.ibb.co/pQ6tV3r/1.png)

After discovering a blip (getting close to it)<br/>
![image](https://i.ibb.co/cTwSGw2/2.png)

Resetting personal blips<br />
![image](https://i.ibb.co/3kMpKzm/3.png)

Trying to reset blips while near a blip (causes issues otherwise)<br/>
![image](https://i.ibb.co/zQkgXt7/4.png)

## Requirements
- [qb-core](https://github.com/qbcore-framework/qb-core) or [esx-legacy](https://github.com/esx-framework/esx-legacy)
- [oxmysql](https://github.com/overextended/oxmysql)

## Installation
- Import ```rockdale-blipdiscovery.sql``` into your database
- Drag & drop into resources
- Ensure resource in server.cfg
- Edit config.lua

## Changelog
- **1.0**: Initial release
- **1.1**: Added ESX compatibility & performance adjustments