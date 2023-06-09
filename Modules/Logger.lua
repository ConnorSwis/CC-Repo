local LogFile = "/logs.txt"

---@class LoggerLevel
local DebugLevel = {
    None = {
        prefix = "",
        color = colors.black,
        severity = 0
    },
    error = {
        prefix = "E",
        color = colors.red,
        severity = 1
    },
    Warning = {
        prefix = "W",
        color = colors.yellow,
        severity = 2
    },
    Info = {
        prefix = "I",
        color = colors.green,
        severity = 3
    },
    Debug = {
        prefix = "D",
        color = colors.blue,
        severity = 4
    },
    Verbose = {
        prefix = "V",
        color = colors.cyan,
        severity = 5
    }
}
Logger = {
    Levels = DebugLevel,
    Logs = {},
    _p = {
        Tags = {},
        LogLevel = DebugLevel.Verbose,
        LogsToKeep = 100,
        outputTerminal = nil
    }
}

-- override error function to print stack traceback into logs
if _G.overrides == nil then
    _G.overrides = {}
end
if _G.overrides.oldError == nil then
    _G.overrides.oldError = error
    _G.error = function(message, level)
        if level ~= nil then
            level = level + 1
        end
        local file = nil
        if not fs.exists(LogFile) then
            file = fs.open(LogFile, "w")
        else
            file = fs.open(LogFile, "a")
        end
        local trace = debug.traceback()
        file.write(trace .. "\r\n")
        if message then
            file.write(message)
            file.write("\r\n")
        end
        file.close()
        _G.overrides.oldError(message, level)
    end
end

---opens log files, writes all logs to it, closes log file
local function addToLogFile()
    local file = fs.open(LogFile, "w")
    if file then
        for _, v in pairs(Logger.Logs) do
            file.write(v.tostring())
        end
        file.close()
    end
end

---amount of logs to keep
---@param size number size of logs to keep in entries
function Logger.setLogSize(size)
    if type(size) ~= "number" then
        error(("bad argument #%d (expected %s, got %s)"):format(1, "number", type(size)), 2)
    end
    Logger._p.LogsToKeep = size
    while #Logger.Logs > Logger.LogsToKeep do
        table.remove(Logger.Logs, 1)
    end
end

---set log level for a tag
---@param tag string tag to set log level for
---@param level LoggerLevel Logger.Levels debug level
function Logger.setLogLevel(tag, level)
    if type(tag) ~= "string" then
        error(("bad argument #%d (expected %s, got %s)"):format(1, "string", type(tag)), 2)
    end
    if type(level) ~= "table" then
        error(("bad argument #%d (expected %s, got %s)"):format(2, "table", type(level)), 2)
    end
    Logger._p.Tags[tag] = level
end

---set global log level
---@param level LoggerLevel Logger.Levels debug level
function Logger.setGlobalLogLevel(level)
    if type(level) ~= "table" then
        error(("bad argument #%d (expected %s, got %s)"):format(1, "table", type(level)), 2)
    end
    Logger._p.LogLevel = level
    for k, _ in pairs(Logger._p.Tags) do
        Logger._p.Tags[k] = level
    end
end

---sets output terminal for text, if set will also output new log text to this terminal
---@param outputTerminal table terminal with print function
function Logger.setOutputTerminal(outputTerminal)
    Logger._p.outputTerminal = outputTerminal
end

---log without setting a tag, useful for quick debugging.
---@vararg any any thing you wish to log
function Logger.logNoTag(...)
    local tag = ""
    Logger.log(tag, DebugLevel.error, ...)
end

---Log a error
---@param tag string tag to log for
---@vararg any any thing you wish to log
function Logger.logE(tag, ...)
    if type(tag) ~= "string" then
        error(("bad argument #%d (expected %s, got %s)"):format(1, "string", type(tag)), 2)
    end
    Logger.log(tag, DebugLevel.error, ...)
end

---Log a warning
---@param tag string tag to log for
---@vararg any any thing you wish to log
function Logger.logW(tag, ...)
    if type(tag) ~= "string" then
        error(("bad argument #%d (expected %s, got %s)"):format(1, "string", type(tag)), 2)
    end
    Logger.log(tag, DebugLevel.Warning, ...)
end

---Log a info message
---@param tag string tag to log for
---@vararg any any thing you wish to log
function Logger.logI(tag, ...)
    if type(tag) ~= "string" then
        error(("bad argument #%d (expected %s, got %s)"):format(1, "string", type(tag)), 2)
    end
    Logger.log(tag, DebugLevel.Info, ...)
end

---Log a debug message
---@param tag string tag to log for
---@vararg any any thing you wish to log
function Logger.logD(tag, ...)
    if type(tag) ~= "string" then
        error(("bad argument #%d (expected %s, got %s)"):format(1, "string", type(tag)), 2)
    end
    Logger.log(tag, DebugLevel.Debug, ...)
end

---Log a verbose message
---@param tag string tag to log for
---@vararg any any thing you wish to log
function Logger.logV(tag, ...)
    if type(tag) ~= "string" then
        error(("bad argument #%d (expected %s, got %s)"):format(1, "string", type(tag)), 2)
    end
    Logger.log(tag, DebugLevel.Verbose, ...)
end

---internal function to format recursive table printing
---@param curDepth number current depth in table
---@return string string string containing apropriate amount of tabs
local function handleCurDepthTabs(curDepth)
    local retString = ""
    for _ = 1, curDepth do
        retString = retString .. "\t"
    end
    return retString
end

---print tables recursively (will print tables in tables in tables ...)
---@param tableToPrint table
---@param curDepth number | nil optional parameter used by recursive calls that gets current array Depth used for fancy printing
---@return string table table in string form to feed to your printer of choice
local function printTableRecursive(tableToPrint, curDepth)
    if curDepth == nil then
        curDepth = 1
    end
    local retString = handleCurDepthTabs(curDepth - 1) .. "{\r\n"
    for k, v in pairs(tableToPrint) do
        if type(v) == "table" then
            retString = retString .. handleCurDepthTabs(curDepth) .. tostring(k) .. " :\r\n"
            retString = retString .. printTableRecursive(v, curDepth + 1)
        else
            retString = retString .. handleCurDepthTabs(curDepth) .. tostring(k) .. " : " .. tostring(v) .. "\r\n"
        end
    end
    retString = retString .. handleCurDepthTabs(curDepth - 1)
    if curDepth > 1 then
        retString = retString .. "}\r\n"
    else
        retString = retString .. "}"
    end
    return retString
end

---convert table of input arguments into printable string for logging
---@vararg any stuff to log
---@return string loggableString loggable string
local function buildLogString(...)
    local toLog = {...}
    local retString = ""
    for i = 1, #toLog do
        local curItem = toLog[i]
        if type(curItem) == "boolean" then
            if curItem then
                retString = retString .. "true"
            else
                retString = retString .. "false"
            end
        elseif type(curItem) == "function" then
            retString = retString .. tostring(curItem)
        elseif type(curItem) == "nil" then
            retString = retString .. tostring(curItem)
        elseif type(curItem) == "number" then
            retString = retString .. tostring(curItem)
        elseif type(curItem) == "string" then
            retString = retString .. curItem
        elseif type(curItem) == "table" then
            retString = retString .. printTableRecursive(curItem)
        elseif type(curItem) == "thread" then
            retString = retString .. tostring(curItem)
        elseif type(curItem) == "userdata" then
            retString = retString .. tostring(curItem)
        end
        if i ~= #toLog then
            retString = retString .. " "
        end
    end
    return retString .. "\r\n"
end

---log a message with level
---@param tag string tag to log as
---@param level table logging level
---@vararg any any thing you wish to log
function Logger.log(tag, level, ...)
    if Logger._p.Tags[tag] == nil then
        Logger._p.Tags[tag] = Logger._p.LogLevel
    end

    if Logger._p.Tags[tag].severity >= level.severity then
        local text = buildLogString(...)
        -- log to output terminal if set
        if Logger._p.outputTerminal then
            local oldTerm = term.redirect(Logger._p.outputTerminal)
            local oldColor = term.getTextColor()
            term.setTextColor(level.color)
            -- print but strip out last newline
            if #tag > 1 then
                tag = "[" .. tag .. "] "
            end
            print(level.prefix .. ": " .. tag .. text:sub(0, string.len(text) - 2))
            term.setTextColor(oldColor)
            term.redirect(oldTerm)
        end
        -- add item to logfile
        local logItem = {
            listboxTextColor = level.color,
            tostring = function(width)
                return level.prefix .. ": " .. tag .. ": " .. text
            end
        }
        table.insert(Logger.Logs, logItem)
        addToLogFile()
        -- delete oldest logs if size was exceeded
        while #Logger.Logs > Logger._p.LogsToKeep do
            table.remove(Logger.Logs, 1)
        end
    end
end

return Logger
