-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
-- Habilitar físicas
local physics = require("physics")
physics.start()
-- Crear el fondo blanco
local fondoBlanco = display.newRect(display.contentCenterX, display.contentCenterY, display.contentWidth+40, display.contentHeight)
fondoBlanco:setFillColor(1) -- Blanco
-- Crear el personaje
local personaje = display.newRect(0, 0, 15, 15)
personaje:setFillColor(0, 0, 1)
physics.addBody(personaje, "dynamic")
personaje.gravityScale = 0
-- Crear Enemigo
local Enemigo = display.newRect(display.contentCenterX, display.contentCenterY, 50, 50)
Enemigo:setFillColor(1, 0, 0) -- Rojo
physics.addBody(Enemigo, "dynamic")
Enemigo.gravityScale = 0

-- Crear pared
local pared1 = display.newRect(200, 100, 300, 10) -- Ejemplo de pared horizontal
pared1:setFillColor(0) -- Negro
physics.addBody(pared1, "static")

--Moverse---

local velocidadX = 0
local velocidadY = 0
local velocidad = 2

personaje.collisionObjects = {}

local function actualizarMovimiento()
     -- Verificar si el personaje está en colisión con el enemigo
     local isCollidingWithEnemy = false
     for i = 1, #personaje.collisionObjects do
         if personaje.collisionObjects[i] == Enemigo then
             isCollidingWithEnemy = true
             personaje.x = 0
             personaje.y = 0
             
             break
         end
     end
 
     -- Si no está en colisión con el enemigo, permitir el movimiento
     if not isCollidingWithEnemy then
         personaje.x = personaje.x + velocidadX
         personaje.y = personaje.y + velocidadY
     end
     personaje.collisionObjects = {}
end
local direcciones = { norte = { x = 0, y = -1 }, sur = { x = 0, y = 1 }, este = { x = 1, y = 0 }, oeste = { x = -1, y = 0 } }
local function mover(event)
    if event.phase == "began" then
        local direccion = direcciones[event.target.id]
        if direccion then
            velocidadX = direccion.x * velocidad
            velocidadY = direccion.y * velocidad
        end
    elseif event.phase == "ended" then
        -- Restablecer las velocidades a cero cuando se levanta el dedo del botón
        velocidadX = 0
        velocidadY = 0
    end
end

local botonNorte = display.newRect(70, 390, 50, 50)
botonNorte:setFillColor(0)
botonNorte.id = "norte"
botonNorte:addEventListener("touch", mover)

local botonSur = display.newRect(70, 450, 50, 50)
botonSur:setFillColor(0)
botonSur.id = "sur"
botonSur:addEventListener("touch", mover)

local botonEste = display.newRect(130, 450, 50, 50)
botonEste:setFillColor(0)
botonEste.id = "este"
botonEste:addEventListener("touch", mover)

local botonOeste = display.newRect(10, 450, 50, 50)
botonOeste:setFillColor(0)
botonOeste.id = "oeste"
botonOeste:addEventListener("touch", mover)

local function onCollision(event)
    if (event.phase == "began") then
        local obj1 = event.target
        local obj2 = event.other
        
        -- Verificar si el personaje colisiona con la pared
        if (obj1 == personaje and obj2 == pared1) or (obj1 == pared1 and obj2 == personaje) then
            -- Aquí puedes agregar el código para manejar la colisión
            print("¡El personaje ha chocado con la pared!")
            velocidadX = 0
            velocidadY = 0
        end

    end
end
local function onEnemyCollision(event)
    if event.phase == "began" then
        local obj1 = event.target
        local obj2 = event.other
        -- Verificar si la colisión involucra al personaje y al enemigo
        if (obj1 == personaje and obj2 == Enemigo) or (obj1 == Enemigo and obj2 == personaje) then
            -- Mostrar mensaje de "perdiste"
            print("¡Perdiste!")
            velocidadX = 0
            velocidadY = 0
            -- Eliminar el cuerpo físico del Enemigo

            table.insert(personaje.collisionObjects, Enemigo)
        end
    end
    if event.phase == "ended" then
        local obj1 = event.target
        local obj2 = event.other
        if (obj1 == personaje and obj2 == Enemigo) or (obj1 == Enemigo and obj2 == personaje) then
            print("ya no esta colisionando")
            local index = table.indexOf(personaje.collisionObjects, Enemigo)
            if index then
                table.remove(personaje.collisionObjects, index)
            end
        end
    end
end

local function moveEnemy()
    transition.to(Enemigo, {time = 1000, x = display.contentWidth - Enemigo.width/2, delay = 0, onComplete = function()
        transition.to(Enemigo, {time = 1000, x = Enemigo.width/2, onComplete = moveEnemy})
    end})
end

moveEnemy()
pared1:addEventListener("collision", onCollision)
Enemigo:addEventListener("collision", onEnemyCollision)
Runtime:addEventListener("enterFrame", actualizarMovimiento)