local Dbg = require("Logger")
Dbg.setOutputTerminal(term.current())

while true do
    local eventInfo = {os.pullEvent()}
    Dbg.logNoTag(eventInfo)
end
