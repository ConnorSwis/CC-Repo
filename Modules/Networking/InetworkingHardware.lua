---@class InetworkingHardware
local InetworkingHardware = {}

---send a message
---@param msg ILLmessage msg being send
function InetworkingHardware.transmit(msg)
    return {
        arguments = {"table"},
        returns = {}
    }
end

---receive a message, blocking
---@return ILLmessage | nil message message that was received
function InetworkingHardware.receive()
    return {
        arguments = {},
        returns = {"table or nil"}
    }
end

return InetworkingHardware
