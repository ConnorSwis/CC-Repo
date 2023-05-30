local Git = require("Modules.Git")
Git.getFileIfNeeded(Git.userRepo, "Modules/Logger.lua")
Git.getFileIfNeeded(Git.userRepo, "Modules/Utils.lua")
local Dbg = require("Modules.Logger")
local Utils = require("Modules.Utils")

local TAG = "HWModem"

-- Dbg.setLogLevel(TAG, Dbg.Levels.Info)

---create new networkingHardware for modem
---@param modemChannel number | nil number < 65535, if nil opens 65532
---@param modemsToUse table | nil wrapped modems to use packaged in a table ( as returned from {peripheral.find("modem")}), if nil wraps all modems
---@return ModemHardware instance created instance
local function new(modemChannel, modemsToUse)
    -- PC.expect(1, modemChannel, "number", "nil")
    -- PC.expect(2, modemsToUse, "table", "nil")

    Dbg.logV(TAG, "created new modem hardware")
    local this = {
        modemNames = {},
        modems = {peripheral.find("modem")},
        modemChannel = modemChannel or 65532
    }
    if modemsToUse ~= nil then
        this.modems = modemsToUse
    end
    for _, mod in pairs(this.modems) do
        table.insert(this.modemNames, peripheral.getName(mod))
    end

    ---@class ModemHardware
    local Modems = {}

    ---open a channel on all modems for instance
    ---@param channel number channel to open
    local function openChannelOnModems(channel)
        Dbg.logV(TAG, "opening channel", channel)
        for _, mod in pairs(this.modems) do
            mod.open(channel)
        end
    end

    ---close a channel on all modems for instance
    ---@param channel number channel to close
    local function closeChannelOnModems(channel)
        Dbg.logV(TAG, "closing channel", channel)
        for _, mod in pairs(this.modems) do
            mod.close(channel)
        end
    end

    ---transmits a message
    ---@param msg table msg being send
    function Modems.transmit(msg)
        Dbg.logV(TAG, "transmitting message:", msg)
        for _, mod in pairs(this.modems) do
            mod.transmit(this.modemChannel, this.modemChannel, msg)
        end
    end

    ---receives a message, blocking
    ---@return table message message that was received
    function Modems.receive()
        Dbg.logV(TAG, "Waiting for message")
        local eventInfo = {}
        while type(eventInfo[5]) ~= "table" or not Utils.findElementInTable(this.modemNames, eventInfo[2]) or
            eventInfo[3] ~= this.modemChannel do
            eventInfo = {os.pullEvent("modem_message")}
            Dbg.logV(TAG, "received msg", eventInfo)
        end
        return eventInfo[5]
    end

    openChannelOnModems(this.modemChannel)

    return Modems
end

return {
    new = new
}
