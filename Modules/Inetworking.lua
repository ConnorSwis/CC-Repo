---@class Inetworking
---@field broadcastChannel number
local Networking = {}

---@class InetworkingQOS
Networking.QOS = { -- quality of service for messages
    ATMOST_ONCE = 0, -- message will be sent once but may not arrive (udp only 1 message is sent)
    ATLEAST_ONCE = 1, -- message will be resent if lost but may arrive multiple times (sends 2 messages for each message)
    EXACTLY_ONCE = 2 -- message will be resent and a synAck will be created so message will arive exactly once (tcp 3 messages atleast for each message)
}

---@class InetworkingMessageTypes
---used internally to transmit messages, not needed outside of Networking class
Networking.MsgTypes = {
    message = 0,
    ack = 1,
    synAck = 2
}

---@class ILLmessage
---@field llType InetworkingMessageTypes
---@field llId number
---@field to number
---@field from number
---@field QOS InetworkingQOS
---@field payload Imessage

---transmit a message to other computer
---@param to number channel the receiver is listening on (its id or the broadcast channel)
---@param QOS InetworkingQOS quality of service for the message class.QOS value
---@param payload Imessage data being transmitted
---@param responseTo number | nil optional field that can be set to indicate this message is a response to a received message, allows the receiver to filter incoming messages
---@return number msgId of the message being sent
function Networking.transmit(to, QOS, payload, responseTo)
    return {
        arguments = {"number", "number (should be implemented as class.QOS)", "table, string, number, boolean",
                     "number or nil"},
        returns = {"number"}
    }
end

---receive a specific msgtype as defined in Modules/Networking/Messages.lua
---@param timeout number | nil timeout before function returns, nil is no timeout
---@param channel number | nil channel to listen on, nil listens on all channels
---@param msgTypes MessageTypes[] table of message types as defined in the Messages.lua file
---@return ILLmessage | nil msg msg with metadata or nil when no msg that fits filters is received
function Networking.receiveMsgTypes(timeout, channel, msgTypes)
    return {
        arguments = {"number or nil", "number or nil", "table of msgTypes as defined in Modules/Networking/Messages.lua"},
        returns = {"table or nil"}
    }
end

---Receive a message
---@param timeout number | nil if nil will wait indefinently otherwise waits for timeout for message to come in
---@param channel number | nil when a number is given only messages received on this channel will be returned (useful for broadcasts)
---@param responseTo number | nil allows for precise message filtering when a pc sends a message back as a response to a msg this pc send then the responseTo field will be set to the message id it is responding too
---@return ILLmessage | nil msg msg with metadata or nil when no msg that fits filters {llId (internal id), to (this pc or broadcast channel), from (sender), QOS (quality of service for message), payload (data that is being sent)}
function Networking.receive(timeout, channel, responseTo)
    return {
        arguments = {"number or nil", "number or nil", "number or nil"},
        returns = {"table or nil"}
    }
end

return Networking
