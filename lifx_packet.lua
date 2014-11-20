
LifxPacket = {}
LifxPacket.__index = LifxPacket

-- Method: Create 
-- Constructor
function LifxPacket:Create(target, class, payload)
   local self = {}
   self.Version = 0x34
   self.Class = class
   self.Payload = payload
   self.Target = target
   setmetatable(self, LifxPacket)
   return self
end

-- Method: ToDatagram
-- Serializes the packet for transmission
function LifxPacket:ToDatagram()
   -- zero initialize the array
   local datagram = {}
   for i = 1, 36 do
      datagram[i] = 0
   end
   -- set the version parameter
   datagram[4] = self.Version
   -- set the site id parameter
   for i = 1,6 do
      datagram[16 + i] = self.Target[i]
   end
   -- set the packet type parameter
   for i = 1,2 do
      datagram[32 + i] = self.Class[i]
   end
   -- append the payload to the end of the datagram
   for k, v in pairs(self.Payload) do
      if type(k) == 'number' then
         datagram[36 + k] = v
      end
   end
   -- size the size parameter
   datagram[1] = #datagram
   -- return the datagram
   return datagram
end
