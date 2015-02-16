
require "lifx_bulb"

-- create a wrapper for the unix sleep function
local function sleep(n_sec)
   os.execute("sleep " .. tonumber(n_sec))
end

-- create a bulb: ip address, port, hardware address
local bulb = LifxBulb:Create('192.168.1.73',
                             56700,
                             {0xD0, 0x73, 0xD5, 0x01, 0x0A, 0x3F})

local duration = 1800; -- 30 minutes
local steps = 360;
local values = {red = 0.085, green = 0.060, blue = 0.000}

-- switch on the bulb
bulb:SwitchOn()
-- set levels to zero, in case the bulb switches on in an illuminated state
bulb:SetColorRGB(0,0,0)
-- pause a second before starting the squence
sleep(1)
-- linearly increase the brightness to the final value
for step = 0,steps do
   bulb:SetColorRGB(values["red"] * (step / steps),
                    values["green"] * (step / steps),
                    values["blue"] * (step / steps),
                    1)
   sleep(math.floor(duration / steps))
end

