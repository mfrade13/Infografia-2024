-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
local physics = require("physics")

-- Your code here
local CW = display.contentWidth
local CH = display.contentHeight

local path = "resources/"
physics.start( )
physics.setDrawMode( "hybrid" )

print(physics.getGravity())
physics.setGravity( 0, 9.8 )


--local fondo = display.newRect(CW/2, CH/2, CW, CH)
local fondo = display.newImageRect(path.."1.jpg", CW, CH)
--fondo:setFillColor(0.22)
fondo.x = CW/2; fondo.y = CH/2

local options = {
    width = 300,
    height = 300,
    numFrames = 8
}
local options_attack = {
    width = 533,
    height = 300,
    numFrames = 6
}


local image_sheet = graphics.newImageSheet(path.."avanza_derecha.png", options)
local image_sheet_izquierda = graphics.newImageSheet(path.."avanza_izquierda.png", options)
local image_sheet_acciones_d = graphics.newImageSheet(path.. "accion_derecha.png", options_attack)
local secuencia = {
    {
        name = "atacar",
        frames = {1,2,3},
        loopCount = 1,
        time = 500,
        loopDirection = "bounce",
        sheet = image_sheet_acciones_d 
     },
    {
        name = "reposo_derecha",
        frames = {5,6},
        loopCount = 0,
        time = 400,
        sheet = image_sheet
    },
    {
        name = "avanza_derecha",
    --    start = 5,
    --    count = 3,
        frames = {5,6,7,8,1,2,3,4},
    --    frames = {1,3,5,6},
        loopCount = 0,
        time = 700,
        sheet = image_sheet
    },{
        name = "avanza_izquierda",
        frames= {8,7,6,5,4,3,2,1},
        time = 700,
        sheet = image_sheet_izquierda
    }


}

local cuerpo_box_cazador = { halfWidth=55, halfHeight=100, x=0, y=0, angle=0 }


local cazador = display.newSprite(image_sheet_acciones_d, secuencia)
cazador.x = CW/2; cazador.y = CH/2
cazador.nombre = "cazador"
print(cazador.xScale, cazador.yScale)
cazador.xScale =1
physics.addBody( cazador, "dynamic", {box=cuerpo_box_cazador, bounce = 0.5,density =1, friccion = 0.2} )
print(cazador.bodyType)
--physics.addBody(cazador, "dynamic", {radius = 85})

local piso = display.newRect(CW/2, CH-150, CW, 30)
piso:setFillColor( 0,1,0, 0.4 )
piso.nombre = "piso"
physics.addBody(piso, "static", {friccion=0.2})

local ball = display.newCircle(CW/3,CH/2, 50)
ball:setFillColor( 0,0,1 )
ball.nombre = "ball"
physics.addBody(ball, "kinematic", {radius=50, bounce = 1, isSensor = true})
ball.gravityScale = 0.25

cazador:setSequence("reposo_derecha")
cazador:play()
--direccion = "derecha"
local xTarget

function mover(e)
    if e.phase == "began" then
        print("Empieza a avanzar")
        cazador:setSequence("avanza_derecha")
        local direccion = e.target.direccion
        local fuerzaX = e.target.fuerza
        --Runtime verificar boton apretado para avanzar con su posicion en X
        if direccion == "derecha" then
            cazador.xScale =  1
            xTarget = CW
        elseif direccion == "izquierda" then
            cazador.xScale =  -1
            xTarget = 0
        end
        cazador:applyLinearImpulse(fuerzaX, 0, cazador.x, cazador.y)
        print("Masa cazador: ",cazador.mass)
 --       cazador:applyForce(fuerzaX,0,cazador.x, cazador.y)
--transition.to(cazador, {x=xTarget, time=3000})
        cazador:play()
        --cazador:translate(10,0)
    elseif e.phase == "ended" or e.phase == "cancelled" then
        print("se detiene")
        transition.cancel(cazador)
        cazador:setSequence("reposo_derecha")
        cazador:play()
    end
    return true
end

function cazador_collision(self, event)
    if event.phase == "began" then
        if event.other.nombre == "ball" then
            display.remove(event.other)
            print("Sumar puntos")
        end
    elseif event.phase == "ended" then
        print(event.target.nombre .. " ha colisionado contra: " .. event.other.nombre)

    end
end

cazador.collision = cazador_collision
cazador:addEventListener( "collision", cazador )


local boton_avanzar_derecha = display.newRect(CW-100, CH-100, 100, 70)
boton_avanzar_derecha.direccion = "derecha"
boton_avanzar_derecha.fuerza = 10
boton_avanzar_derecha:addEventListener("touch", mover)

local boton_avanzar_izquierda = display.newRect(100, CH-100, 100, 70)
boton_avanzar_izquierda.direccion = "izquierda"
boton_avanzar_izquierda.fuerza = -10
boton_avanzar_izquierda:addEventListener("touch", mover)

local boton_frames = display.newRect(CW/2, boton_avanzar_derecha.y, 100,70)
boton_frames:addEventListener("touch", function()
    cazador:setSequence("atacar")
    cazador:play()
    cazador.bodyType = "dynamic"
    timer.performWithDelay( 1200, function()
        cazador:setSequence( "reposo_derecha" )
        cazador:play( )
        end, 1)
    -- cazador:setFrame(math.random(1,8))
    -- cazador:pause()
end)


