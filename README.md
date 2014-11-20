# LuaLIFX
A Lua library for controlling LIFX bulbs based on LuaSocket

## Motivation
This is a Lua library for control LIFX bulbs. The motivation for creating yet another library for controlling the bulbs, this time using Lua, is that many wireless routers etc have a little flash memory and are quite slow. OpenWRT by default includes Luci, a Lua interface to OpenWRT's unified control interface that allows for administration tasks such as package management and configuring the network. To this end, LuaLIFX only requires the installation of one additional package - luasocket which is approximately 125kb.  

## Progress
### Implemented
1. Switch on
2. Switch off
3. Change color (RGB)
### To do
