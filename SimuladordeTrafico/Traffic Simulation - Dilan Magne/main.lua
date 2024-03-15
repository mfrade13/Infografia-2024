
-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
local physics = require("physics")
physics.start()
-- Calle
local background = display.newImageRect( "33191.png", 500, 1030 )
background.x = display.contentCenterX
background.y = display.contentCenterY
-- Autos
local auto1 = display.newRect(0, 0, 50, 50) 
auto1:setFillColor(1, 0, 0)  -- Color rojo
auto1.x = display.contentCenterX - 150
auto1.y = display.contentCenterY + 55
physics.addBody(auto1, "dynamic")
auto1.gravityScale = 0

local auto2 = display.newRect(0, 0, 50, 50)
auto2:setFillColor(0, 0, 1)  -- Color azul
auto2.x = display.contentCenterX  -- Centrado horizontalmente
auto2.y = 1  -- Comienza arriba de la pantalla
physics.addBody(auto2, "dynamic")
auto2.gravityScale = 0 

-- Barreras
local barrera1 = display.newRect(0, 0, 10, 215)
barrera1:setFillColor(1) -- Color blanco
barrera1.x = display.contentCenterX-57 -- Posición en el lado izquierdo de la calle
barrera1.y = display.contentCenterY -- Altura de la calle
physics.addBody(barrera1, "static")
barrera1.gravityScale = 0
barrera1.isVisible = true
local barreraActiva1 = true

local barrera2 = display.newRect(0, 0, 105, 10) 
barrera2:setFillColor(1) -- Color blanco
barrera2.x = display.contentCenterX -- Posición en el lado izquierdo de la calle
barrera2.y = display.contentCenterY-120 -- Altura de la calle
physics.addBody(barrera2, "static")
barrera2.gravityScale = 0
barrera2.isVisible = true
local barreraActiva2 = true

-- Crear el semáforo horizontal (círculo)
local semaforoHorizontal = display.newCircle(display.contentCenterX, 50, 10)
semaforoHorizontal.x = display.contentCenterX-55
semaforoHorizontal.y = display.contentCenterY
semaforoHorizontal:setFillColor(1, 0, 0)  -- Rojo por defecto

-- Crear el semáforo vertical (círculo)
local semaforoVertical = display.newCircle(display.contentCenterX, 50, 10)
semaforoVertical.x = display.contentCenterX
semaforoVertical.y = display.contentCenterY-118
semaforoVertical:setFillColor(0, 1, 0)  -- Verde por defecto

-- Crear una variable local para almacenar el color actual de los semáforos
local colorSemaforoHorizontal = "rojo"
local colorSemaforoVertical = "verde"

-- Botón
local boton = display.newRect(display.contentWidth - 50, display.contentHeight - 50, 100, 100)
boton:setFillColor(1, 0.85, 0)  -- Color dorado

-- Función para mover el auto rojo de izquierda a derecha
local function moverAutoIzquierda()
    transition.to(auto1, {x = display.contentWidth + auto1.width, time = 7000, onComplete = function()
        auto1.x = -auto1.width  -- Restablecer la posición del auto a la izquierda de la pantalla
        moverAutoIzquierda() -- Mover el auto nuevamente
    end})
end

-- Función para mover el auto azul de arriba abajo
local function moverAutoAbajo()
    transition.to(auto2, {y = display.contentHeight + auto2.height, time = 7000, onComplete = function()
        auto2.y = -auto2.height  -- Restablecer la posición del auto arriba de la pantalla
        moverAutoAbajo() -- Mover el auto nuevamente
    end})
end

local autosMoviendo = false

-- Función para comenzar a mover los autos cuando se toca el botón
local function comenzarMovimientoAutos(event)
    if event.phase == "ended" and not autosMoviendo then
        autosMoviendo = true  -- Establecer la bandera para indicar que los autos se están moviendo
        moverAutoIzquierda() -- Comenzar a mover el auto rojo
        moverAutoAbajo() -- Comenzar a mover el auto azul
    end
    return true
end

-- Función para activar la barrera 1
local function activarBarrera1()
    barreraActiva1 = true
    physics.addBody(barrera1,"static")
    barrera1.gravityScale = 0
    barrera1.isVisible = true  -- Hacer visible la barrera
end

-- Función para desactivar la barrera 1
local function desactivarBarrera1()
    barreraActiva1 = false
    physics.removeBody(barrera1)
    barrera1.isVisible = false
    moverAutoIzquierda()
end

-- Función para activar la barrera 2
local function activarBarrera2()
    barreraActiva2 = true
    physics.addBody(barrera2,"static")
    barrera2.gravityScale = 0
    barrera2.isVisible = true  -- Hacer visible la barrera
end

-- Función para desactivar la barrera 2
local function desactivarBarrera2()
    barreraActiva2 = false
    physics.removeBody(barrera2)
    barrera2.isVisible = false
    moverAutoAbajo()
end

-- Función para cambiar el color del semáforo horizontal
local function cambiarColorSemaforoHorizontal()
    if colorSemaforoHorizontal == "rojo" then
        semaforoHorizontal:setFillColor(0, 1, 0)  -- Cambiar a verde
        desactivarBarrera1()
        colorSemaforoHorizontal = "verde"
    elseif colorSemaforoHorizontal == "verde" then
        semaforoHorizontal:setFillColor(1, 1, 0)  -- Cambiar a amarillo
        activarBarrera1()
        colorSemaforoHorizontal = "amarillo"
    else
        semaforoHorizontal:setFillColor(1, 0, 0)  -- Cambiar a rojo
        activarBarrera1()
        colorSemaforoHorizontal = "rojo"
    end
end

-- Cambiar el color del semáforo cada 7 segundos
timer.performWithDelay(7000, function()
    cambiarColorSemaforoHorizontal()
end, 0)
-------------
local function cambiarColorSemaforoVertical()
    if colorSemaforoVertical == "verde" then
        semaforoVertical:setFillColor(1, 1, 0)  -- Cambiar a amarillo
        activarBarrera2()
        colorSemaforoVertical = "amarillo"
    elseif colorSemaforoVertical == "amarillo" then
        semaforoVertical:setFillColor(1, 0, 0)  -- Cambiar a Rojo
        activarBarrera2()
        colorSemaforoVertical = "rojo"
    else
        semaforoVertical:setFillColor(0, 1, 0)  -- Cambiar a verde
        desactivarBarrera2()
        colorSemaforoVertical = "verde"
    end
end
-- Cambiar el color del semáforo cada 7 segundos
timer.performWithDelay(7000, function()
    cambiarColorSemaforoVertical()
end, 0)

local function onCollision(event)
    if (event.phase == "began" and barreraActiva1) then
        -- Detener el movimiento del auto
        transition.pause(auto1)
    elseif (event.phase == "began" and barreraActiva2) then
        transition.pause(auto2)
    else
        transition.resume(auto1)
        transition.resume(auto2)
    end
end

Runtime:addEventListener("collision", onCollision)
boton:addEventListener("touch", comenzarMovimientoAutos)