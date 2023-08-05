--// VARIABLES \\--
local Math = {}
local Record = require(script.Parent.record)

-- ARITHMETIC
function Math.add(x:number, y:number):number
    return x + y
end

function Math.mult(x:number, y:number):number
    return x * y
end

-- RECORD HANDLING
local MathWithRecords = setmetatable({}, {__index = function(self, func)
    local tie = Math[func]
    if not tie then
        error("Attempt to call nil value")
    end

    return function(...)
        local rawInputs = {}
        local inputs = {}
        for index, input in next, {...} do
            local recorded = Record.update(input, `Passed into Math.{func}`)
            inputs[index] = recorded
            rawInputs[index] = Record.evaluate(recorded)

        end

        local rawOutputs = {tie(unpack(rawInputs))}
        local outputs = {}
        for index, output in next, rawOutputs do
            local input = inputs[index]
            outputs[index] =
                input.status == Record.Invalid and input or
                #input.logs > 1 and Record.update(output, `Returned from Math.{func}`) or
                Record.evaluate(output)
        end

    end

end})

--// TYPES \\--
export type Math = typeof(Math) & typeof(math)
Math = (require(script.Parent.merge)(math, Math))

return MathWithRecords::Math