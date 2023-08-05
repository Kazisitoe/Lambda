--|| KAZI

--// LIB \\--
local Math = require(script.math)
local Record = require(script.record)
local chain = require(script.chain)
local map = require(script.map)
local merge = require(script.merge)
local Library = {
    chain = chain,
    map = map,
    merge = merge,
    math = Math,
}
--// TYPES \\--
export type Lambda = typeof(Library) & typeof(Record)

Library = merge(Library, Record)

return Library