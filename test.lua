if not fs.exists("Modules/Git.lua") then
    local url = "https://raw.githubusercontent.com/ConnorSwis/CC-Repo/master/Modules/Git.lua"
    local response = http.get(url)
    if response then
        local contents = response.readAll()
        response.close()
        local fh = fs.open("Modules/Git.lua", "w")
        fh.write(contents)
        fh.close()
    else
        error("Couldn't download Git")
    end
end

local Git = require("Modules.Git")

Git.getFileIfNeeded(Git.userRepo, "Modules/Logger.lua")
Git.getFileIfNeeded(Git.userRepo, "Modules/Networking/HW/Modems.lua")

local Dbg = require("Modules.Logger")
local Modems = require("Modules.Networking.HW.Modems")

Dbg.setOutputTerminal(term.current())

local nwHardware = Modems.new()

while true do
    Dbg.logI("Server", "Started...")
    nwHardware.transmit({
        msg = "hello world"
    })
    local recMsg = nwHardware.receive()
    Dbg.logNoTag(recMsg)
end

-- TODO "https://youtu.be/X1KLO0gHETY?t=4290"
