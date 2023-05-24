local Dbg = require("Modules.Logger")

Dbg.setOutputTerminal(term.current())

Git = {}

function Git.hasGit(fp)
    if not fs.exists(fp) then
        local response = http.get("https://raw.githubusercontent.com/ConnorSwis/CC-Repo/master/" .. fp)
        if response then
            local contents = response.readAll()
            response.close()
            local file = fs.open(fp, "w")
            file.write(contents)
            file.close()
            Dbg.logI("Downloaded Git: " .. fp)
        else
            error("Could not download Git: " .. fp)
        end
    end
end

return Git
