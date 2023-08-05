--// VARIABLES \\--
local cache = setmetatable({}, {__mode = "k"})
local symbolMt = {}
local createSymbol

-- SYMBOL METATABLE
local function wrapCall(callback)
    local output = createSymbol(debug.info(3, "sl")..":"..tostring(debug.info(2, "f")))
    getmetatable(output).__call = function(self, storage)
        storage[output] = callback(storage)

        return storage[output]

    end

    return output

end

function symbolMt.__concat(symbol, v)
    return wrapCall(function(storage)
        return storage[symbol]..v
    end)
end
function symbolMt.__unm(symbol)
    return wrapCall(function(storage)
        return -storage[symbol]
    end)
end
function symbolMt.__add(symbol, v)
    return wrapCall(function(storage)
        return storage[symbol] + v
    end)
end
function symbolMt.__sub(symbol, v)
    return wrapCall(function(storage)
        return storage[symbol] - v
    end)
end
function symbolMt.__mul(symbol, v)
    return wrapCall(function(storage)
        return storage[symbol] * v
    end)
end
function symbolMt.__div(symbol, v)
    return wrapCall(function(storage)
        return storage[symbol] / v
    end)
end
function symbolMt.__mod(symbol, v)
    return wrapCall(function(storage)
        return storage[symbol] % v
    end)
end
function symbolMt.__pow(symbol, v)
    return wrapCall(function(storage)
        return storage[symbol] ^ v
    end)
end
function symbolMt.__eq(symbol, v)
    return wrapCall(function(storage)
        return storage[symbol] == v
    end)
end
function symbolMt.__lt(symbol, v)
    return wrapCall(function(storage)
        return storage[symbol] < v
    end)
end
function symbolMt.__le(symbol, v)
    return wrapCall(function(storage)
        return storage[symbol] <= v
    end)
end
function symbolMt.__len(symbol)
    return wrapCall(function(storage)
        return #storage[symbol]
    end)
end

createSymbol = function(index)
    if cache[index] then return cache[index] end

    cache[index] = newproxy(true)
    local mt = getmetatable(cache[index])
    mt.__tostring = function() return index end
    for k, v in next, symbolMt do mt[k] = v end

    return cache[index]

end

return createSymbol