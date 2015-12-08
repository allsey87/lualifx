
require "lifx_bulb"

-- create a wrapper for the unix sleep function
local function sleep(n_sec)
   os.execute("sleep " .. tonumber(n_sec))
end

-- create a bulb: ip address, port, hardware address
local bulb = LifxBulb:Create('192.168.1.73',
                             56700,
                             {0xD0, 0x73, 0xD5, 0x01, 0x0A, 0x3F})

local duration = 1800 -- 30 minutes
local steps = 180
local values = {
   start = {hue = 0.17, sat = 1.00, val = 0.04},
   finish = {hue = 0.15, sat = 1.00, val = 0.15}
}

-- switch bulb on
bulb:SwitchOn()

-- set levels to zero, in case the bulb switches on in an illuminated state
bulb:SetColorHSV(0,0,0)

-- pause a second before starting the squence
sleep(1)

-- linearly increase the brightness to the final value
for step = 0,steps do
   bulb:SetColorHSV(values["start"]["hue"] + (values["finish"]["hue"] - values["start"]["hue"]) * (step / steps),
                    values["start"]["sat"] + (values["finish"]["sat"] - values["start"]["sat"]) * (step / steps),
                    values["start"]["val"] + (values["finish"]["val"] - values["start"]["val"]) * (step / steps),
                    (duration * 1000) / steps)
   -- pause before sending next command
   local pause = math.floor(duration / steps)
   if pause >= 1 then
      sleep(pause)
   else
      sleep(1)
   end
end
