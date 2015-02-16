require 'socket'
require 'lifx_packet'

LifxBulb = {}
LifxBulb.__index = LifxBulb

function LifxBulb:Create(address, port, target)
   local self = {}
   self.Address = address
   self.Port = port
   self.Target = target
   setmetatable(self, LifxBulb)
   return self
end

function LifxBulb:SendPacket(packet)
   local bulb_socket = socket.udp()
   bulb_socket:setpeername(self.Address, self.Port)
   local data = ''
   for k,v in pairs(packet:ToDatagram()) do
      data = data .. string.char(v)
   end
   bulb_socket:send(data)
   bulb_socket:close()
end

function LifxBulb:SwitchOff()
   local packet = LifxPacket:Create(self.Target,
                                    {0x15, 0x00},
                                    {0x00, 0x00})
   self:SendPacket(packet)
end

function LifxBulb:SwitchOn()
   local packet = LifxPacket:Create(self.Target,
                                    {0x15, 0x00},
                                    {0x00, 0x01})
   self:SendPacket(packet)
end

function LifxBulb:SetColorRGB(red, green, blue, fade_time)
   assert(red >= 0 and red <= 1, "Red is out of range"); 
   assert(green >= 0 and green <= 1, "Green is out of range");
   assert(blue >= 0 and blue <= 1, "Blue is out of range");
   
   if(fade_time == nil) then
      fade_time = 0
   else
      assert(fade_time >= 0 and fade_time <= 120, "fade time must be in the range [0 .. 120]")
   end

   local rgb_max = math.max(red, green, blue)
   local rgb_min = math.min(red, green, blue)
   local rgb_delta = rgb_max - rgb_min   
   local hsv_h = 0
   local hsv_s = 0
   local hsv_v = rgb_max
   if(rgb_max > 0 and rgb_delta > 0) then
      -- compute the saturation
      hsv_s = rgb_delta / rgb_max
      -- compute the hue
      if(red == rgb_max) then
         hsv_h = (green - blue) / rgb_delta
      elseif(green == rgb_max) then
         hsv_h = 2.0 + (blue - red) / rgb_delta
      else
         hsv_h = 4.0 + (red - green) / rgb_delta
      end

      hsv_h = hsv_h * 60
      if(hsv_h < 0) then
         hsv_h = hsv_h + 360;
      end
   else
      hsv_s = 0
      hsv_h = 0
   end

   -- scale the values to be between 0 and 65535
   hsv_h = math.floor((hsv_h / 360) * 0xFFFF)
   hsv_s = math.floor(hsv_s * 0xFFFF)
   hsv_v = math.floor(hsv_v * 0xFFFF)
   
   print(string.format("setting color to {red = %f, green = %f, blue = %f} over %d seconds",
                       red, green, blue, fade_time))

   local packet = LifxPacket:Create(self.Target,
                                    {0x66, 0x00},
                                    {0x00, 
                                     hsv_h % 0x100, math.floor(hsv_h / 0x100), --hue
                                     hsv_s % 0x100, math.floor(hsv_s / 0x100), --sat
                                     hsv_v % 0x100, math.floor(hsv_v / 0x100), --brightness
                                     0x00, 0x00, --kelvin
                                     0x00, 0x00, 2 * fade_time, 0x00}) -- fade time
   self:SendPacket(packet)
end
