
require "lifx_bulb"

-- create a wrapper for the unix sleep function
local function sleep(n_sec)
   os.execute("sleep " .. tonumber(n_sec))
end

-- create a bulb: ip address, port, hardware address
local bulb = LifxBulb:Create('10.0.0.2',
                             56700,
                             {0xD0, 0x73, 0xD5, 0x22, 0x7A, 0x0C})

local transitions = {
   [1] = {
      duration = 0, -- instantly
      hsv = {hue = 0.16, sat = 1.00, val = 0.04},
   },
   [2] = {
      duration = 900, -- over 15 minutes
      hsv = {hue = 0.14, sat = 1.00, val = 0.15},
   },
   [3] = {
      duration = 1800, -- over 30 minutes
      hsv = {hue = 0.12, sat = 1.00, val = 1.00},
   },
}

-- switch bulb on
bulb:SwitchOn()

-- linearly increase the brightness to the final value for each transition
for index,transition in ipairs(transitions) do
   bulb:SetColorHSV(transition["hsv"]["hue"],
      transition["hsv"]["sat"],
      transition["hsv"]["val"],
      transition["duration"] * 1000)
   -- pause before sending next command
   local pause = math.floor(transition["duration"])
   if pause >= 1 then
      sleep(pause)
   else
      sleep(1)
   end   
end

