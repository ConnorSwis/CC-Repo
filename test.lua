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

Git.getFileIfNeeded("ConnorSwis/CC-Repo/master/", "Modules/Logger.lua")
Git.getFileIfNeeded("ConnorSwis/CC-Repo/master/", "Programs/eventBasedTimer.lua")

local Dbg = require("Modules/Logger")

Dbg.setOutputTerminal(term.current())
