-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

local composer = require("composer")

composer.gotoScene("menu")


--[[
-- Definir el tamaño de la pantalla
local screenWidth = display.actualContentWidth
local screenHeight = display.actualContentHeight

local centerX = display.contentCenterX
local centerY = display.contentCenterY

-- Función para generar estrellas aleatorias
local function createStar()
    local star = display.newRect(math.random(0, screenWidth), math.random(0, screenHeight), 2, 2)
    star:setFillColor(1, 1, 1)
    return star
end

-- Función para generar círculos aleatorios
local function createCircle()
    local circle = display.newCircle(math.random(0, screenWidth), math.random(0, screenHeight), math.random(5, 20))
    circle:setFillColor(math.random(), math.random(), math.random())
    return circle
end

-- Crear estrellas y círculos
local stars = {}
local circles = {}

for i = 1, 200 do
    stars[i] = createStar()
    --circles[i] = createCircle()
end

-- Función de actualización para mover los objetos hacia afuera de la pantalla
local function update(event)
    for i = 1, #stars do
        stars[i].x = stars[i].x + 0.5  -- Mover hacia la derecha
        stars[i].y = stars[i].y + 0.5  -- Mover hacia abajo
        if stars[i].x > screenWidth or stars[i].y > screenHeight then
            stars[i].x = math.random(0, screenWidth)
            stars[i].y = -10
        end
    end
end

--Hacia el centro pero número limitado
local function update(event)
    for i = 1, #stars do
        local dx = centerX - stars[i].x
        local dy = centerY - stars[i].y
        stars[i].x = stars[i].x + dx * 0.001  -- Mover hacia el centro en el eje X
        stars[i].y = stars[i].y + dy * 0.001  -- Mover hacia el centro en el eje Y
    end

end

local function update(event)
    for i = 1, #stars do
        local dx = centerX - stars[i].x
        local dy = centerY - stars[i].y
        stars[i].x = stars[i].x + dx * 0.001  -- Mover hacia el centro en el eje X
        stars[i].y = stars[i].y + dy * 0.001  -- Mover hacia el centro en el eje Y

        if math.abs(dx) < 1 and math.abs(dy) < 1 then
            stars[i].x = math.random(0, screenWidth)
            stars[i].y = math.random(0, screenHeight)
        end
    end

    for i = 1, #circles do
        local dx = centerX - circles[i].x
        local dy = centerY - circles[i].y
        circles[i].x = circles[i].x + dx * 0.001  -- Mover hacia el centro en el eje X
        circles[i].y = circles[i].y + dy * 0.001  -- Mover hacia el centro en el eje Y

        if math.abs(dx) < 1 and math.abs(dy) < 1 then
            circles[i].x = math.random(0, screenWidth)
            circles[i].y = math.random(0, screenHeight)
        end
    end
end

-- Actualizar la pantalla
Runtime:addEventListener("enterFrame", update)
]]--
