
--// SYMBOLS \\--
local RecordIdentifier = newproxy(true)
getmetatable(RecordIdentifier).__tostring = function() return "RecordIdentifier" end
local Valid = newproxy(true)
getmetatable(Valid).__tostring = function() return "Valid" end
local Invalid = newproxy(true)
getmetatable(Invalid).__tostring = function() return "Invalid" end

--// TYPES \\--
export type Record<T,S> = {
    value: T,
    logs: {string},
    status: S,
    [typeof(RecordIdentifier)]: true
}
export type Valid = typeof(Valid)
export type Invalid = typeof(Invalid)
export type Status = Valid | Invalid

--// VARIABLES \\--
local Record = {}

-- HANDLING
function Record.evaluate<T>(value:Record<T,Status>|T):T
    return (typeof(value) ~= "table" or not value[RecordIdentifier]) and value or value.value
end
function Record.try<T,S>(record:Record<T,S>, callback:(Record<T>)->any, logger:((any?)->any)?):Record<T,S>
    if record.status == Invalid then
        if logger then logger(record.logs) end

        return record

    end

    callback(record)
    return record

end
function Record.catch<T,S>(record:Record<T,S>, callback):Record<T,S>
    if record.Status == Invalid then callback(record) end

    return record

end
function Record.morph<T,S>(record:Record<T,S>, ...):Record<T,S>
    if record.status == Invalid then return Record.update(record, "Record rejected from morph chain: record invalid") end
    record = Record.update(record, "Morph chain began")
    
    for count, func in next, {...} do
        record = func(record)
        if typeof(record) ~= "table" or not record[RecordIdentifier] then
            error(`Function #{count} in morph chain returned a non-record value {record}`)
        elseif record.status == Invalid then
            return Record.update(record, `Merge chain ended prematurely at {count}: record invalidated`)
        end

    end

    return Record.update(record, "Morph chain ended successfully")

end

-- CREATING
function Record.record<T>(value:T, log:string, status:Status):Record<T,Valid>
    local t = {
        value = value,
        logs = {log},
        status = status,
        [RecordIdentifier] = true
    }
    table.freeze(t)

    return t
    
end
function Record.update<T>(value:T|Record<any,Status>, log:string, newValue:T):Record<T,Status>
    if typeof(value) ~= "table" or not value[RecordIdentifier] then
        return Record.record(value, log, Valid)
    end

    local logs = table.clone(value.logs)
    table.insert(logs, log)
    logs[50] = nil
    table.freeze(logs)

    local t = {
        value = newValue or value.value,
        logs = logs,
        status = value.status,
        [RecordIdentifier] = true
    }
    table.freeze(t)

    return t

end

function Record.invalidate<T>(value:Record<T,Status>, log:string):Record<T,Invalid>
    if typeof(value) ~= "table" or not value[RecordIdentifier] then
        return Record.record(value, "Invalidated: "..log, Invalid)
    end

    local logs = table.clone(value.logs)
    table.insert(logs, log)
    logs[50] = nil
    table.freeze(logs)

    local t = {
        value = value.value,
        status = Invalid,
        logs = logs,
        [RecordIdentifier] = true
    }
    table.freeze(t)

    return t

end
function Record.validate<T>(value:Record<T,Status>, log:string):Record<T,Valid>
    local record = table.clone(Record.update(value, "Validated: "..log))
    record.status = Valid
    table.freeze(record)

    return record

end


Record.Valid, Record.Invalid = Valid, Invalid

return Record