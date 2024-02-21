local widget = require("widget")

local expression = "" 


local displayText = display.newText({
    text = "",
    x = display.contentCenterX,
    y = 100,
    width = display.contentWidth - 40,
    height = 40,
    font = native.systemFont,
    fontSize = 24,
    align = "right"
})

local function handleNumber(event)
    expression = expression .. event.target.number
    displayText.text = expression
end

-- eventos 
local function handleOperation(event)
    local operation = event.target.operation
    if operation == "clear" then
        expression = ""
    elseif operation == "calculate" then
        -- calcular
        local success, result = pcall(function() return loadstring("return " .. expression)() end)
        if success then
            expression = tostring(result)
        else
            expression = "Error: " .. result
        end
    elseif operation == "√" then
        -- raíz cuadrada
        expression = "math.sqrt(" .. expression .. ")"
    elseif operation == "round" then
        -- redondeo
        expression = "math.round(" .. expression .. ")"
    elseif operation == "%" then
        -- porcentaje
        expression = "(" .. expression .. ")/100"
    elseif operation == "log" then
        -- logaritmo base 10
        expression = "math.log10(" .. expression .. ")"
    elseif operation == "ln" then
        -- logaritmo natural
        expression = "math.log(" .. expression .. ")"
    elseif operation == "sin" then
        -- sen
        expression = "math.sin(math.rad(" .. expression .. "))"
    elseif operation == "cos" then
        -- cos
        expression = "math.cos(math.rad(" .. expression .. "))"
    elseif operation == "tan" then
        -- tan
        expression = "math.tan(math.rad(" .. expression .. "))"
    else
        
        expression = expression .. operation
    end
    displayText.text = expression
end

-- botones numeros
local numbers = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "."}

for i, number in ipairs(numbers) do
    local button = widget.newButton({
        label = number,
        x = 40 + (i-1)%3 * 80,
        y = 300 + math.floor((i-1)/3) * 60,
        width = 70,
        height = 50,
        onPress = handleNumber
    })
    button.number = number
end

-- botones operaciones
local operations = {"+", "-", "*", "/", "√", "round", "^2", "^", "%", "log", "ln", "sin", "cos", "tan", "*-1", "clear", "calculate"}

for i, operation in ipairs(operations) do
    local button = widget.newButton({
        label = operation,
        x = 260 + (i-1)%2 * 80,
        y = 300 + math.floor((i-1)/2) * 60,
        width = 70,
        height = 50,
        onPress = handleOperation
    })
    button.operation = operation
end
