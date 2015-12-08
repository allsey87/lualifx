
require "lifx_bulb"

-- set the values from the command line
local params = {...}

assert(table.getn(params) >= 4, 
       "the set color example requires the colorspace (HSV or RGB), three values, and fade time (optional)")

-- convert arguments
local colorspace = params[1]
local components = { tonumber(params[2]), tonumber(params[3]), tonumber(params[4]) }
local fade_time = tonumber(params[5])

-- create a bulb: ip address, port, hardware address
bulb = LifxBulb:Create('192.168.1.73',
                       56700,
                       {0xD0, 0x73, 0xD5, 0x01, 0x0A, 0x3F})

-- switch on the bulb
bulb:SwitchOn()

-- set the color specified value
if colorspace == "RGB" then
   bulb:SetColorRGB(components[1], components[2], components[3], fade_time)
elseif colorspace == "HSV" then
   bulb:SetColorHSV(components[1], components[2], components[3], fade_time)
else 
   error(string.format("The colorspace %s is unknown", colorspace))
end

   


