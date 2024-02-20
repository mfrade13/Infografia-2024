--LIBRERIAS
local composer = require( "composer" )
 
local scene = composer.newScene()

--RECURSOS
local recursosTexto = "Fuentes/"
local recursosImagenes = "Imagenes/"

--DIMENSIONES GENERALES DE LA PANTALLA DEL DISPOSITIVO
CW = display.contentWidth
CH = display.contentHeight


local fondo, icono, mensajeCarga, titulo, boton, textoBoton
local indiceCarga = 0

local options = {
    effect = "slideLeft",
    time = 2200,
    --time = 500
}

function ir_animacion(event)
    composer.gotoScene("animacion",options)
end

function cambiarTextoCarga()
    if indiceCarga == 4 then
        mensajeCarga.text = "Cargando"
    else
        mensajeCarga.text = mensajeCarga.text .. "."
    end
    indiceCarga = indiceCarga % 4 + 1
end

function cargar(self,event)
    if event.phase == "began" then
        self:setFillColor(0.24)
    elseif event.phase == "ended" then
        self:setFillColor(0.44)
        textoBoton.isVisible = false
        boton.isVisible = false
        icono.isVisible = true
        mensajeCarga.isVisible = true
        
        local tempTimer = timer.performWithDelay(200, cambiarTextoCarga, 0)
        
        transition.to(titulo,{y = CH/2 + 50, time = 100}) 
        transition.to(icono, {rotation = 360,time = 2700,
        onComplete = function() ir_animacion()
                if tempTimer then
                    timer.cancel(tempTimer)
                end
            end
        })
        --transition.to(icono,{rotation=360,time=500,onComplete=ir_animacion})       
    end
    return true
end

-- create()
function scene:create( event )
    local sceneGroup = self.view

    fondo = display.newImageRect(sceneGroup,recursosImagenes .. "inicio.png",CW*1.3,CH)
    fondo.x = CW; fondo.y = CH
    fondo.anchorX = 1; fondo.anchorY = 1

    titulo = display.newText(sceneGroup, "Sistema Solar", CW / 2, CH / 2, recursosTexto.."Opcion3.ttf", 45)

    boton = display.newRoundedRect(sceneGroup, CW/2, CH/2 + 85, 280, 80, 30)
    boton.strokeWidth = 2
    boton:setFillColor(0.44)
    boton:setStrokeColor(1)
    boton.touch = cargar
    boton: addEventListener('touch',boton)
    textoBoton = display.newText(sceneGroup, "INICIAR", boton.x, boton.y, recursosTexto.."Opcion2.ttf", 32)
    textoBoton:setFillColor(1)
    
    
    icono = display.newImageRect(sceneGroup,recursosImagenes .. "icono.png",160,160)
    icono.x = CW/2; icono.y = CH/2 - 80
    
    mensajeCarga = display.newText(sceneGroup, "Cargando", CW / 2, CH / 2 + 120, recursosTexto.."Opcion1.ttf", 50)
end

-- show()
function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        icono.rotation = 0
        titulo.y = CH/2
        icono.isVisible = false
        mensajeCarga.isVisible = false
        textoBoton.isVisible = true
        boton.isVisible = true
    elseif ( phase == "did" ) then
        
    end
end

function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
    if ( phase == "will" ) then

    elseif ( phase == "did" ) then
        
    end
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )

return scene