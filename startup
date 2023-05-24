if not settings.get("import") then
    io.write("Enter import chest name (minecraft:chest_0):\n\t-> ")
    settings.set("import", read())
    settings.save()
end

if not settings.get("export") then
    io.write("Enter export chest name (minecraft:chest_0):\n\t-> ")
    settings.set("export", read())
    settings.save()
end

term.clear()
term.setCursorPos(1, 1)
io.write("Running...")

local importName = settings.get("import")
local exportName = settings.get("export")

local import = peripheral.wrap(importName)
local export = peripheral.wrap(exportName)
local storage = {peripheral.find("inventory", function(name, wrapped)return name ~= peripheral.getName(import) and name ~= peripheral.getName(export)end)}

local function isEmpty(chest, slot)
    return chest.getItemDetail(slot) == nil
end

local function isFull(chest, slot)
    local stack = chest.getItemDetail(slot)
    return stack and stack.count >= stack.maxCount
end

local function condenseStacks()
    local partialStacks = {}

    for _, chest in ipairs(storage) do
        if #chest.list() > 0 then
            for slot = 1, chest.size() do
                if not isEmpty(chest, slot) and not isFull(chest, slot) then
                    local stack = chest.getItemDetail(slot)
                    local itemKey = stack.name

                    if not partialStacks[itemKey] then
                        partialStacks[itemKey] = {}
                    end

                    table.insert(partialStacks[itemKey], {
                        chest = chest,
                        slot = slot
                    })
                end
            end
        end
    end

    for _, slots in pairs(partialStacks) do
        if #slots > 1 then
            local targetSlot = slots[1]

            for i = 2, #slots do
                local currentSlot = slots[i]
                local sourceChest = currentSlot.chest
                local sourceSlot = currentSlot.slot

                sourceChest.pushItems(peripheral.getName(targetSlot.chest), sourceSlot, 64, targetSlot.slot)
            end
        end
    end
end

local function tableLength(tbl)
    if tbl ~= nil then
        local count = 0
        for _ in pairs(tbl) do
            count = count + 1
        end
        return count
    end
end

local function pushToStorage()
    if import and tableLength(import.list()) > 0 then
        for _, chest in pairs(storage) do
            for i, _ in pairs(import.list()) do
                chest.pullItems(peripheral.getName(import), i)
            end
        end
    end
end

parallel.waitForAny(function()
    while true do
        condenseStacks()
        os.sleep(0.1)
    end
end, function()
    while true do
        pushToStorage()
        os.sleep(0.1)
    end
end)
