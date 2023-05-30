local Dbg = require("Modules.Logger")
Dbg.setOutputTerminal(term.current())

local function newDog()
    hunger = 100
    local function eats()
        return "meat"
    end

    local function eat()
        hunger = hunger - 1
    end
    local function run()
        hunger = hunger + 5
    end

    local function getHunger()
        return hunger
    end

    return {
        eats = eats,
        eat = eat,
        run = run,
        getHunger = getHunger
    }
end

local function newCat(hunger)
    local function eats()
        return "fish"
    end

    local function eat()
        hunger = hunger - 5
    end

    local function run()
        hunger = hunger + 2
    end

    local function getHunger()
        return hunger
    end

    return {
        eat = eat,
        run = run,
        getHunger = getHunger
    }
end

local function walkAnimal(animal)
    animal.run()
end

local catA = newCat(100)
local catB = newCat(10)
local dogA = newDog()
local dogB = newDog()
walkAnimal(catA)
walkAnimal(dogA)
Dbg.logNoTag(catA, catA.getHunger())
Dbg.logNoTag(catB, catB.getHunger())
Dbg.logNoTag(dogA, dogA.getHunger())
