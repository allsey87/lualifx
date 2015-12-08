
LifxPacket = {}
LifxPacket.__index = LifxPacket

-- Method: Create 
-- Constructor
function LifxPacket:Create(protocol, target, payload)
   local self = {}
   self.Protocol = protocol
   self.Target = target
   self.Version = "LIFXV2"
   self.Payload = payload
   setmetatable(self, LifxPacket)
   return self
end

-- Method: ToDatagram
-- Serializes the packet for transmission
function LifxPacket:ToDatagram()
   -- zero initialize the array
   local datagram = {}
   for i = 1, 32 do
      datagram[i] = 0
   end
   -- set the protocol
   datagram[4] = self.Protocol
   -- set the target
   for i = 1,6 do
      datagram[8 + i] = self.Target[i]
   end
   -- set the packet type parameter
   for i = 1,6 do
      datagram[16 + i] = string.byte(self.Version,i)
   end
   -- append the payload to the end of the datagram
   for k, v in pairs(self.Payload) do
      if type(k) == 'number' then
         datagram[32 + k] = v
      end
   end
   -- size the size parameter
   datagram[1] = #datagram
   -- return the datagram
   return datagram
end
