# LuaLIFX
A Lua library for controlling LIFX bulbs based on LuaSocket

## Motivation
This is a Lua library for controlling LIFX bulbs targeted at wireless routers capable of running [OpenWRT](https://openwrt.org/). A wireless router is an ideal location to run a LIFX server as it is typically always on, always connected to the bulbs, low power, and accessible from the internet.

The motivation for creating yet another library for controlling the bulbs, this time using Lua, is that many of the wireless routers that OpenWRT supports, have very little flash memory and run quite slowly. A default installation of OpenWRT includes the Lua interpreter (used by Luci). The LuaLIFX library makes use of the existing installation of Lua, and only requires one addtional package (luasocket - 125kb) to provide support for controlling and automating LIFX bulbs on a wireless router.

## Progress
### Implemented
1. Switch on
2. Switch off
3. Change color (RGB)

### To do
1. Create a bridge implementation / virtual bulb
