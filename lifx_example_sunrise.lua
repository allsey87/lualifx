
require "lifx_bulb"

-- A class to hold the parameters of the sunrise and compute the
-- colors at each timestep
Sunrise = {}
Sunrise.__index = Sunrise

function Sunrise:Create(steps, coefficient, scaling_factor, final_values)
   local self = {}
   self.steps = steps
   self.coefficient = coefficient
   self.scaling_factor = scaling_factor
   self.final_values = final_values
   setmetatable(self, Sunrise)
   return self
end

function Sunrise:GetValues(timestep)
   local red = self.final_values["red"] * 
      math.pow(self.coefficient, self.scaling_factor * (self.steps - timestep))
   local green = self.final_values["green"] * 
      math.pow(self.coefficient, self.scaling_factor * (self.steps - timestep))
   local blue = self.final_values["blue"] * 
      math.pow(self.coefficient, self.scaling_factor * (self.steps - timestep))
   return red, green, blue
end

-- create a wrapper for the unix sleep function
local function Sleep(n_sec)
   os.execute("sleep " .. tonumber(n_sec))
end

-- create a bulb: ip address, port, hardware address
local bulb = LifxBulb:Create('192.168.1.73',
                             56700,
                             {0xD0, 0x73, 0xD5, 0x01, 0x0A, 0x3F})

-- create the sunrise object
local sunrise = Sunrise:Create(3600, 0.95, 0.025,
                               {red = 0.08, green = 0.05, blue = 0.00})

-- switch on the bulb
bulb:SwitchOn()
-- set levels to zero, in case the bulb switches on in an illuminated state
bulb:SetColorRGB(0, 0, 0)

-- iterate over the different colors
for n = 1800, 3600, 200 do
   local red, green, blue = sunrise:GetValues(n)
   bulb:SetColorRGB(red, green, blue, 1)
   Sleep(1)
end



