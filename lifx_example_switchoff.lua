
require "lifx_bulb"

-- create a bulb: ip address, port, hardware address
local bulb = LifxBulb:Create('192.168.1.73',
                             56700,
                             {0xD0, 0x73, 0xD5, 0x01, 0x0A, 0x3F})

-- switch off the bulb
bulb:SwitchOff()

