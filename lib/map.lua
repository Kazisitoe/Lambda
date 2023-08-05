--// MAP \\--
local function map(x, ...)
    local mappers = {...}

    local t = {}
    for k, v in next, x do
        local n = v
        for _, m in next, mappers do
            n = m(n)
        end

        t[k] = n

    end
    table.freeze(t)

    return t

end

return map