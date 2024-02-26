-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
local CW = display.contentWidth
local CH = display.contentHeight

local path = "resources/"

local fondo = display.newRect(CW/2, CH/2, CW, CH)
fondo:setFillColor(0.22)

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

local cazador = display.newSprite(image_sheet_acciones_d, secuencia)
cazador.x = CW/2; cazador.y = CH/2
print(cazador.xScale, cazador.yScale)
cazador.xScale =1

cazador:setSequence("reposo_derecha")
cazador:play()
direccion = "derecha"
local xTarget
function mover(e)
    if e.phase == "began" then
        print("Empieza a avanzar")
        cazador:setSequence("avanza_derecha")
        
        if cazador.x >= CW  then
            direccion = "izquierda"
            cazador.xScale =  -1
        elseif cazador.x <= 0 then
            direccion = "derecha"
            cazador.xScale = 1
        end

        if direccion == "derecha" then
            xTarget = CW
        elseif direccion == "izquierda" then
            xTarget = 0
        end
        transition.to(cazador, {x=xTarget, time=3000})
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

local boton_avanzar_derecha = display.newRect(CW-100, CH-100, 100, 70)
boton_avanzar_derecha:addEventListener("touch", mover)


local boton_frames = display.newRect(CW/2, boton_avanzar_derecha.y, 100,70)
boton_frames:addEventListener("touch", function()
    cazador:setSequence("avanza_derecha")
    cazador:setFrame(math.random(1,8))
    cazador:pause()
end)


