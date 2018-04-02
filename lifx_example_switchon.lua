
require "lifx_bulb"

-- create a bulb: ip address, port, hardware address
local bulb = LifxBulb:Create('10.0.0.2',
                             56700,
                             {0xD0, 0x73, 0xD5, 0x22, 0x7A, 0x0C})

-- switch on the bulb
bulb:SwitchOn()

