local physics = require("physics")
physics.start()
local fondoBlanco = display.newRect(display.contentCenterX, display.contentCenterY, display.contentWidth+40, display.contentHeight)
fondoBlanco:setFillColor(1) -- Blanco
---texto--
local muertes = 0
local ganadas = 0
-- Función para actualizar el texto en la pantalla
local function actualizarTexto()
    if textoMuertes then
        textoMuertes:removeSelf()
    end
    if textoGanadas then
        textoGanadas:removeSelf()
    end
    -- Crear texto para mostrar las muertes
    textoMuertes = display.newText("Losses: " .. muertes, 250, 400, native.systemFontBold, 35)
    textoMuertes:setFillColor(1, 0, 0) -- Rojo
    
    -- Crear texto para mostrar las ganadas
    textoGanadas = display.newText("Wins: " .. ganadas, 250, 450, native.systemFontBold, 35)
    textoGanadas:setFillColor(0, 1, 0) -- Verde
end

actualizarTexto()
-- Crear el personaje
local personaje = display.newRect(0, 20, 15, 15)
personaje:setFillColor(0, 0, 1)
physics.addBody(personaje, "dynamic")
personaje.gravityScale = 0
-- Crear Meta
local meta = display.newRect(160, 178, 15, 15)
meta:setFillColor(0, 1, 0) -- Verde
physics.addBody(meta, "static")
-- Crear Enemigos
local Enemigo = {}

function Enemigo:new(x, y, width, height)
    local nuevoEnemigo = display.newRect(x, y, width, height)
    nuevoEnemigo:setFillColor(1, 0, 0) -- Color rojo
    physics.addBody(nuevoEnemigo, "dynamic")
    nuevoEnemigo.gravityScale = 0

    local function onCollision(event)
        if (event.phase == "began") then
            local obj1 = event.target
            local obj2 = event.other
            
            -- Verificar si la colisión involucra al enemigo y al jugador
            if (obj1 == nuevoEnemigo and obj2 == personaje) or (obj1 == personaje and obj2 == nuevoEnemigo) then
                -- Notificar al jugador para reestablecer su posición
                print("¡Perdiste!")
                velocidadX = 0
                velocidadY = 0

                 table.insert(personaje.collisionObjects, nuevoEnemigo)
            end
        end
        if event.phase == "ended" then
            local obj1 = event.target
            local obj2 = event.other
            if (obj1 == personaje and obj2 == nuevoEnemigo) or (obj1 == nuevoEnemigo and obj2 == personaje) then
                print("ya no esta colisionando")
                local index = table.indexOf(personaje.collisionObjects, nuevoEnemigo)
                if index then
                    table.remove(personaje.collisionObjects, index)
                end
            end
        end
    end

    nuevoEnemigo:addEventListener("collision", onCollision)

    return nuevoEnemigo
end
local enemigo1 = Enemigo:new(display.contentCenterX, display.contentCenterY, 15, 15)
local enemigo2 = Enemigo:new(display.contentCenterX+10, display.contentCenterY+20, 15, 15)
local enemigo3 = Enemigo:new(display.contentCenterX-30, display.contentCenterY+45, 15, 15)
local enemigo4 = Enemigo:new(display.contentCenterX+70, display.contentCenterY+70, 15, 15)
local enemigo5 = Enemigo:new(display.contentCenterX-70, display.contentCenterY+80, 15, 15)
local enemigo6 = Enemigo:new(display.contentCenterX+100, display.contentCenterY-165, 15, 15)
local enemigo7 = Enemigo:new(display.contentCenterX-150, display.contentCenterY-165, 15, 15)
local enemigo8 = Enemigo:new(display.contentCenterX+140, display.contentCenterY+65, 15, 15)
-- Paredes
local Pared = {}

function Pared:new(x, y, width, height)
    local nuevaPared = display.newRect(x, y, width, height)
    nuevaPared:setFillColor(0)
    physics.addBody(nuevaPared, "static")
    local function onCollision(event)
        if (event.phase == "began") then
            local obj1 = event.target
            local obj2 = event.other
            if (obj1 == nuevaPared and obj2 == personaje) or (obj1 == personaje and obj2 == nuevaPared) then
            --print("Chocaste con una Pared!")
            end
        end
    end
    nuevaPared:addEventListener("collision", onCollision)
    return nuevaPared
end

-- Crear una nueva pared
local paredTecho = Pared:new(160, 5, 350, 10)
local paredPiso = Pared:new(160, 350, 350, 10)
local paredDerecha = Pared:new(335, 130, 10, 450)
local paredIzquierda = Pared:new(-15, 130, 10, 450)
--techo
--local pared5 = Pared:new(display.contentCenterX, 35, 300, 10)
local pared32 = Pared:new(display.contentCenterX+50, 35, 200, 10)
local pared33 = Pared:new(display.contentCenterX-120, 35, 60, 10)
--local pared14 = Pared:new(display.contentCenterX, 65, 240,10)
local pared30 = Pared:new(display.contentCenterX-45, 65, 140,10)
local pared31 = Pared:new(display.contentCenterX+80, 65, 60,10)
--local pared16 = Pared:new(display.contentCenterX, 95, 300,10)
--local pared16 = Pared:new(display.contentCenterX, 95, 180,10)
local pared16 = Pared:new(display.contentCenterX+50, 95, 80,10)
local pared32 = Pared:new(display.contentCenterX-50, 95, 80,10)
local pared17 = Pared:new(display.contentCenterX, 125, 120,10)
local pared18 = Pared:new(display.contentCenterX, 155, 60,10)
--ParedIzquierda
local pared6 = Pared:new(paredIzquierda.x+30, 40+30, 10, 60)
local pared9 = Pared:new(paredIzquierda.x+30, 220, 10, 200)
local pared19 = Pared:new(paredIzquierda.x+60, 175, 10, 230)
local pared20 = Pared:new(paredIzquierda.x+30+60, 180, 10, 170)
--local pared21 = Pared:new(paredIzquierda.x+30+90, 180, 10, 110)
local pared21 = Pared:new(paredIzquierda.x+30+90, 180-20, 10, 80)
--local pared22 = Pared:new(paredIzquierda.x+30+120, 180, 10, 50)
local pared22 = Pared:new(paredIzquierda.x+30+120, 180-15, 10, 15)
--ParedDerecha
local pared8 = Pared:new(paredDerecha.x-30, 130, 10, 180)
local pared10 = Pared:new(paredDerecha.x-30, 295, 10, 60)
local pared23 = Pared:new(paredDerecha.x-60, 175, 10, 230)
local pared24 = Pared:new(paredDerecha.x-90, 180, 10, 170)
--local pared25 = Pared:new(paredDerecha.x-120, 180, 10, 110)
local pared25 = Pared:new(paredDerecha.x-120, 180+15, 10, 80)
--local pared26 = Pared:new(paredDerecha.x-150, 180, 10, 50)
local pared26 = Pared:new(paredDerecha.x-150, 180+10, 10, 15)
--piso
local pared11 = Pared:new(display.contentCenterX, 320, 300, 10)
local pared12 = Pared:new(display.contentCenterX, 290, 240, 10)
local pared27 = Pared:new(display.contentCenterX, 260, 180, 10)
local pared28 = Pared:new(display.contentCenterX, 230, 120, 10)
local pared29 = Pared:new(display.contentCenterX, 200, 60, 10)
--Moverse---

local velocidadX = 0
local velocidadY = 0
local velocidad = 2

personaje.collisionObjects = {}

local function actualizarMovimiento()
     local isCollidingWithEnemy = false
     for i = 1, #personaje.collisionObjects do
         if personaje.collisionObjects[i] == enemigo1 then
             isCollidingWithEnemy = true
             personaje.x = 0
             personaje.y = 20
             muertes = muertes + 1
             actualizarTexto()
             break
         end
         if personaje.collisionObjects[i] == enemigo2 then
            isCollidingWithEnemy = true
            personaje.x = 0
            personaje.y = 20
            muertes = muertes + 1
            actualizarTexto()
            break
        end
        if personaje.collisionObjects[i] == enemigo3 then
            isCollidingWithEnemy = true
            personaje.x = 0
            personaje.y = 20
            muertes = muertes + 1
            actualizarTexto()
            break
        end
        if personaje.collisionObjects[i] == enemigo4 then
            isCollidingWithEnemy = true
            personaje.x = 0
            personaje.y = 20
            muertes = muertes + 1
            actualizarTexto()
            break
        end
        if personaje.collisionObjects[i] == meta then
            isCollidingWithEnemy = true
            personaje.x = 0
            personaje.y = 20
            ganadas = ganadas + 1
            actualizarTexto()
            break
        end
        if personaje.collisionObjects[i] == enemigo5 then
            isCollidingWithEnemy = true
            personaje.x = 0
            personaje.y = 20
            muertes = muertes + 1
            actualizarTexto()
            break
        end
        if personaje.collisionObjects[i] == enemigo6 then
            isCollidingWithEnemy = true
            personaje.x = 0
            personaje.y = 20
            muertes = muertes + 1
            actualizarTexto()
            break
        end
        if personaje.collisionObjects[i] == enemigo7 then
            isCollidingWithEnemy = true
            personaje.x = 0
            personaje.y = 20
            muertes = muertes + 1
            actualizarTexto()
            break
        end
        if personaje.collisionObjects[i] == enemigo8 then
            isCollidingWithEnemy = true
            personaje.x = 0
            personaje.y = 20
            muertes = muertes + 1
            actualizarTexto()
            break
        end
        
        
     end
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

local function moveEnemyH(enemy, speed)
    local distance = display.contentWidth - enemy.width
    local time = distance / speed * 1000
    
    transition.to(enemy, {
        time = time,
        x = display.contentWidth - enemy.width / 2, 
        onComplete = function()
            transition.to(enemy, {
                time = time,
                x = enemy.width / 2, 
                onComplete = function() 
                    moveEnemyH(enemy, speed)
                end
            })
        end
    })
end
local function moveEnemyV(enemy, speed)
    local startY = 0
    local endY = 350
    local time = math.abs((endY - startY) / speed) * 1000

    transition.to(enemy, {
        time = time,
        y = endY,
        onComplete = function()
            transition.to(enemy, {
                time = time,
                y = startY,
                onComplete = function()
                    moveEnemyV(enemy, speed)
                end
            })
        end
    })
end

moveEnemyH(enemigo1, 200)
moveEnemyH(enemigo2, 100)
moveEnemyH(enemigo3, 400)
moveEnemyH(enemigo4, 500)

moveEnemyV(enemigo1, 200)
moveEnemyV(enemigo2, 100)
moveEnemyV(enemigo5, 200)
moveEnemyV(enemigo6, 300)

local function onMetaCollision(event)
    if event.phase == "began" then
        local obj1 = event.target
        local obj2 = event.other
        
        -- Verificar si la colisión involucra al personaje y al objeto "Meta"
        if (obj1 == personaje and obj2 == meta) or (obj1 == meta and obj2 == personaje) then
            -- Mostrar mensaje de "Has alcanzado la meta"
            print("¡Has alcanzado la meta!")
            table.insert(personaje.collisionObjects, meta)
        end
    end
    if event.phase == "ended" then
        local obj1 = event.target
        local obj2 = event.other
        if (obj1 == personaje and obj2 == meta) or (obj1 == meta and obj2 == personaje) then
            print("ya no esta colisionando con la meta")
            local index = table.indexOf(personaje.collisionObjects, meta)
            if index then
                table.remove(personaje.collisionObjects, index)
            end
        end
    end
end

meta:addEventListener("collision", onMetaCollision)

Runtime:addEventListener("enterFrame", actualizarMovimiento)