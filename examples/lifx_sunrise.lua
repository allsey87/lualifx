require 'lifx_bulb'

bulb = LifxBulb:Create('192.168.1.73',
                    56700,
                    {0xD0, 0x73, 0xD5, 0x01, 0x0A, 0x3F})
bulb:SwitchOn()
bulb:SetColor{red = 0, green = 0, blue = 0}


