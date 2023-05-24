local Git = require("Modules.Git")
Git.getFileIfNeeded(Git.userRepo, "Modules/Logger.lua")
-- Git.getFileIfNeeded(Git.userRepo, "Modules/ParamCheck.lua")
local Dbg = require("Modules.Logger")
-- local PC = require("Modules.ParamCheck")

local Utils = {}

function Utils.findElementInTable(tableT, element)
    -- PC.expect(1, tableT, "table")
    for k, v in pairs(tableT) do
        if v == element then
            return k
        end
    end
    return nil
end

return Utils
