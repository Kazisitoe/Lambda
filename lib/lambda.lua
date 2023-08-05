--// VARIABLES \\--
local TempSymbols = require(script.Parent.tempSymbols)
local Lambda = {
    definitions = {},
}

--// TYPES \\--
export type Definition = typeof(TempSymbols("x"))

-- SYMBOLS
setmetatable(Lambda.definitions, {__index = function(self, variable)
    return TempSymbols(variable)
end})

-- DEFINITIONS
function Lambda.lambda(...:Definition)
    local keys = {...}

    local closure = {}
    local assigner = function(s) return s end

    local function defining(...)
        local values = {...}

        assigner = function(initialStorage)
            local storage = table.clone(initialStorage)

            local key = false
            for _, value in next, values do
                if key then
                    storage[key] = value(storage)
                end
                key = if key then false else value
                    
            end

            return storage

        end

        return closure

    end
    local function yielding(func)
        return function(...)
            local storage = {}
            for index, input in next, {...} do
                storage[keys[index]] = input
            end

            storage = assigner(storage)

            return func(storage)

        end

    end

    closure.defining, closure.yielding = defining, yielding
    table.freeze(closure)

    return closure

end

--- BOOLEAN MATH
function Lambda.both(symbol1, symbol2)
    return function(storage)
        return storage[symbol1] and storage[symbol2]
    end

end
function Lambda.first(symbol1, symbol2)
    return function(storage)
        return storage[symbol1] or storage[symbol2]
    end

end
function Lambda.invert(symbol)
    return function(storage)
        return not storage[symbol]
    end

end

local d = Lambda.definitions
Lambda.lambda(d.x, d.y).yielding(Lambda.x + 3)
Lambda.lambda(d.x).defining(d.something, d.x + 3).yielding(Lambda.d + 3)