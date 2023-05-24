local Dbg = require("Modules.Logger")
local Git = require("Modules.Git")

Dbg.setOutputTerminal(term.current())

Git.hasGit("Programs/eventBasedTimer.lua")