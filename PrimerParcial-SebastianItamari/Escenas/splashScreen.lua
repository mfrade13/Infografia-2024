--LIBRERIAS
local composer = require( "composer" )
local audio = require("audio")
 
local scene = composer.newScene()

--RECURSOS
recursosTexto = "Fuentes/"
recursosImagenes = "Imagenes/"
recursosAudio = "Audios/"

--SONIDOS GLOBALES
sonidoClick = audio.loadSound(recursosAudio.."click.wav")
sonidoCometa = audio.loadSound(recursosAudio.."cometa.mp3")
sonidoFondo = audio.loadStream(recursosAudio.."fondo.mp3")
sonidoExplosion = audio.loadSound(recursosAudio.."explosion.mp3")
sonidoSuccion = audio.loadSound(recursosAudio.."succion.mp3")

--DIMENSIONES GENERALES DE LA PANTALLA DEL DISPOSITIVO
CW = display.contentWidth
CH = display.contentHeight

--VARIABLES DE LA ESCENA
local fondo, icono, mensajeCarga, titulo, boton, textoBoton
local indiceCarga = 0
local tempTimer

function ir_animacion(event)
    local options = {effect = "slideLeft",time = 2200}
    composer.gotoScene("Escenas.animacion",options)
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
        audio.play(sonidoClick)
    elseif event.phase == "ended" then
        self:setFillColor(0.44)
        textoBoton.isVisible = false
        boton.isVisible = false
        icono.isVisible = true
        mensajeCarga.isVisible = true

        tempTimer = timer.performWithDelay(200, cambiarTextoCarga, 0)

        transition.to(titulo,{y = CH/2 + 50, time = 100}) 
        transition.to(icono, {rotation = 360,time = 2700, onComplete = ir_animacion})   
    end
    return true
end

-- CREATE()
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
    textoBoton = display.newText(sceneGroup, "INICIAR", boton.x, boton.y, recursosTexto.."Opcion2.ttf", 32)
    textoBoton:setFillColor(1)
    
    icono = display.newImageRect(sceneGroup,recursosImagenes .. "icono.png",160,160)
    icono.x = CW/2; icono.y = CH/2 - 80
    mensajeCarga = display.newText(sceneGroup, "Cargando", CW / 2, CH / 2 + 120, recursosTexto.."Opcion1.ttf", 50)
    audio.play(sonidoFondo, { loops = -1 }) 
end

-- SHOW()
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
        boton.touch = cargar
        boton: addEventListener('touch',boton)   
    end
end

-- HIDE()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
    if ( phase == "will" ) then
        timer.cancel(tempTimer)
        boton: removeEventListener('touch',boton)
    elseif ( phase == "did" ) then
        
    end
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )

return scene