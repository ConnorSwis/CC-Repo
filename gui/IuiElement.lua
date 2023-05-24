---@class IuiElement
local IuiElement = {}

---handle ui element events
---@param eventInfo table eventInfo as received from {os.pullEvent()}
function IuiElement.handle(eventInfo)
    return {
        arguments = {"table (eventInfo)"},
        returns = {}
    }
end

---draw the element in the terminal does not have to be called externally
function IuiElement.draw()
    return {
        arguments = {},
        returns = {}
    }
end

return IuiElement
