--// CHAIN \\--
local function chain(...)
    local funcs = {...}

    return function(...)
        local output = {...}
        for _, f in next, funcs do
            output = {f(unpack(output))}
        end

        return unpack(output)
    
    end

end

return chain