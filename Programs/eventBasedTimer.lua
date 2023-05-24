local Dbg = require("Modules.Logger")
Dbg.setOutputTerminal(term.current())

---------------------------------------- GLOBAL VARIABLES ----------------------------------------
local outputSides = {"left", "right", "top", "back", "bottom" }
local inputSide = "front"
local invertLogic = false
local timerOn = 0.5
local timerOff = 1



---------------------------------------- FUNCTIONS ----------------------------------------

---set all outputs to a state
---@param sides string[] sides to set
---@param state boolean state to set sides too
local function setOutputs(sides, state)
    for _, side in pairs(sides) do
        rs.setOutput(side, state)
    end
end

---handles redstone event
---@param timerId number current timer id
---@param switchSide string side switch is on
---@return number | nil newTimerId if new timer is started returns new timerId else returns nil
local function handleRedstone(timerId, switchSide)
    if rs.getInput(switchSide) then
        --start the clock
        Dbg.logNoTag("starting clock")
        return os.startTimer(0)
    else
        Dbg.logNoTag("stopping clock")
        os.cancelTimer(timerId)
        setOutputs(outputSides, invertLogic)
        return nil
    end
end

---handles timer events
---@param timerState boolean current timer state
---@return number timerId new timer id
---@return boolean timerState new timer state
local function handleTimer(timerState)
    setOutputs(outputSides, timerState)
    if timerState then
        Dbg.logNoTag("timer is on")
        setOutputs(outputSides, not invertLogic)
        timerId = os.startTimer(timerOn)
    else
        Dbg.logNoTag("timer is off")
        setOutputs(outputSides, invertLogic)
        timerId = os.startTimer(timerOff)
    end
    timerState = not timerState
    return timerId, timerState
end

---------------------------------------- MAIN ----------------------------------------
if rs.getInput(inputSide) then
    timerId = os.startTimer(timerOff)
end

local timerId = nil
local timerState = false
while true do
    local eventInfo = { os.pullEvent() }
    if eventInfo[1] == "redstone" then
        timerId = handleRedstone(timerId, inputSide)
    elseif eventInfo[1] == "timer" then
        timerId, timerState = handleTimer(timerState)
    end
end
