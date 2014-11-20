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
   data = ''
   for k,v in pairs(packet:ToDatagram()) do
      data = data .. string.char(v)
   end
   bulb_socket:send(data)
   bulb_socket:close()
end

function LifxBulb:SwitchOff()
   packet = LifxPacket:Create(self.Target,
                              {0x15, 0x00},
                              {0x00, 0x00})
   self:SendPacket(packet)
end

function LifxBulb:SwitchOn()
   packet = LifxPacket:Create(self.Target,
                              {0x15, 0x00},
                              {0x00, 0x01})
   self:SendPacket(packet)
end

function LifxBulb:SetColor(color)
   assert(color["red"] >= 0 and color["red"] <= 1, "Red is out of range"); 
   assert(color["green"] >= 0 and color["green"] <= 1, "Green is out of range");
   assert(color["blue"] >= 0 and color["blue"] <= 1, "Blue is out of range");
   rgb_max = math.max(color["red"], color["green"], color["blue"])
   rgb_min = math.min(color["red"], color["green"], color["blue"])
   rgb_delta = rgb_max - rgb_min   
   hsv_h = 0
   hsv_s = 0
   hsv_v = rgb_max
   if(rgb_max > 0 and rgb_delta > 0) then
      -- compute the saturation
      hsv_s = rgb_delta / rgb_max
      -- compute the hue
      if(color["red"] == rgb_max) then
         hsv_h = (color["green"] - color["blue"]) / rgb_delta
      elseif(color["green"] == rgb_max) then
         hsv_h = 2.0 + (color["blue"] - color["red"]) / rgb_delta
      else
         hsv_h = 4.0 + (color["red"] - color["green"]) / rgb_delta
      end

      hsv_h = hsv_h * 60
      if(hsv_h < 0) then
         hsv_h = hsv_h + 360;
      end
   else
      hsv_s = 0
      hsv_h = 0
   end
   
   packet = LifxPacket:Create(self.Target,
                              {0x66, 0x00},
                              {0x00, 
                               0x00, math.floor((hsv_h / 360) * 255), --hue
                               0x00, math.floor(hsv_s * 255), --sat
                               0x00, math.floor(hsv_v * 255), --brightness
                               0x00, 0x00, --kelvin
                               0x00, 0x00, 0x00, 0x00}) -- fade time
   self:SendPacket(packet)
end
