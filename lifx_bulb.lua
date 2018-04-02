local socket = require 'socket'
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
   local packet = LifxPacket:Create(0x14, self.Target, {
                     0x75, 0x00,
                     0x00, 0x00,
                     0x00, 0x00,
                     0x00, 0x00,
                     0x00, 0x00})
   self:SendPacket(packet)
end

function LifxBulb:SwitchOn()
   local packet = LifxPacket:Create(0x14, self.Target, {
                     0x75, 0x00,
                     0x00, 0x00,
                     0xff, 0xff,
                     0x00, 0x00,
                     0x00, 0x00})
   self:SendPacket(packet)
end

function LifxBulb:SetColorHSV(hue, saturation, value, fade_time)
   assert(hue >= 0 and hue <= 1, "Hue is out of range");                                      
   assert(saturation >= 0 and saturation <= 1, "Saturation is out of range");                                
   assert(value >= 0 and value <= 1, "Value is out of range");      

   if(fade_time == nil) then
      fade_time = 0
   else
      assert(fade_time >= 0, "fade time must be zero or a postive integer")
   end
   
   print(string.format("setting color to {hue = %f, saturation = %f, value = %f} over %d milliseconds",
                       hue, saturation, value, fade_time))
   
   -- scale the values to be between 0 and 65535
   local hsv_h = math.floor(hue * 0xFFFF)
   local hsv_s = math.floor(saturation * 0xFFFF)
   local hsv_v = math.floor(value * 0xFFFF)
   
   local fade_time_bytes = {}
   for i = 1,4 do
         fade_time_bytes[i] = fade_time % 0x100
         fade_time = math.floor(fade_time / 0x100)
   end
   
   local packet = LifxPacket:Create(0x14, self.Target, {
                     0x66, 0x00,
                     0x00, 0x00,
                     0x00, -- reserved 
                     hsv_h % 0x100, math.floor(hsv_h / 0x100), --hue
                     hsv_s % 0x100, math.floor(hsv_s / 0x100), --saturation
                     hsv_v % 0x100, math.floor(hsv_v / 0x100), --brightness
                     0xff, 0x00, --kelvin
                     fade_time_bytes[1], fade_time_bytes[2], --duration
                     fade_time_bytes[3], fade_time_bytes[4]})
   self:SendPacket(packet)  
end       
       
function LifxBulb:SetColorRGB(red, green, blue, fade_time)
   assert(red >= 0 and red <= 1, "Red is out of range"); 
   assert(green >= 0 and green <= 1, "Green is out of range");
   assert(blue >= 0 and blue <= 1, "Blue is out of range");
   
   if(fade_time == nil) then
      fade_time = 0
   else
      assert(fade_time >= 0, "fade time must be zero or a postive integer")
   end
   
   print(string.format("setting color to {red = %f, green = %f, blue = %f} over %d milliseconds",
                       red, green, blue, fade_time))

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

   self:SetColorHSV(hsv_h / 360, hsv_s, hsv_v, fade_time)
end
