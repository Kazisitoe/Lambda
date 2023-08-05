--// MERGE \\--
local function merge(x, y)
    local t = table.clone(x)
    for k, v in next, y do
        t[k] = v
    end
    table.freeze(t)

    return t

end

return merge