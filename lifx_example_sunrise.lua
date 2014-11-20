
require "lifx_bulb"

-- create a wrapper for the sleep function
function sleep(n_sec)
   os.execute("sleep " .. tonumber(n_sec))
end

-- create a bulb: ip address, port, hardware address
bulb = LifxBulb:Create('192.168.1.73',
                    56700,
                    {0xD0, 0x73, 0xD5, 0x01, 0x0A, 0x3F})

-- switch on the bulb
bulb:SwitchOn()
-- set the color instantly to 0,0,0
bulb:SetColor{red = 0, green = 0, blue = 1}

-- 
for r = 0.0, 0.7, 0.1 do
   bulb:SetColor{red = r, green = 0, blue = 0}
   sleep(1);
end



