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

### Running the sunrise example from CRON

When placed in a CRONTAB file, this line will instruct CRON to execute the sunrise example at 5:30 (GMT), the package path variable is modified using the -e parameter so that the require statements work without hard-coding the paths inside the library. 
```bash
30 5 * * * lua -i -e "package.path = '/path/to/lualifx/?.lua;' .. package.path" /path/to/lualifx/lifx_example_sunrise.lua > /dev/null 2>&1
```