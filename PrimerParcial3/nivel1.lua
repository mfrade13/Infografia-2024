local composer = require( "composer" )
local editor = require( "editor" )
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

-- b -> bloque inmovible / pared
-- w -> espacio en blanco
-- a -> agua
-- s -> punto de inicio
-- m -> meta
-- x -> bloque doble
-- l -> llave
-- p -> puerta

jugadorSprite = nil
puntos = 0
traeLlave = false
nivel =  
   {"wwwwwwwwwwwwwwwwwwwww",
    "wwwwwwwwwwwwwwwwwwwww",
    "wwwwwwwwwwwwwwwwwwwww",
    "wwwwwwwwwwwwwwwwwwwww",
    "wwwbbbbbbbbbbbbbbbwww",
    "wwwbmwwwwwwwwwwwsbwww",
    "wwwbbbbbbbbbbbbbbbwww",
    "wwwwwwwwwwwwwwwwwwwww",
    "wwwwwwwwwwwwwwwwwwwww",
    "wwwwwwwwwwwwwwwwwwwww",
    "wwwwwwwwwwwwwwwwwwwww",
    "wwwwwwwwwwwwwwwwwwwww"}
copiarNivel()
nivelActual = "nivel1"
siguienteNivel = "nivel2"
cmp = composer


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
 
end
 
 
-- show()
function scene:show( event )
 
    sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        local fondo = display.newRect( 0, 0, CW, CH )
        fondo.anchorX = 0; fondo.anchorY = 0
        fondo:setFillColor( unpack(colorClaro) )
        sceneGroup:insert( fondo )

        construirNivel()
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen

    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
 
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
 
end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene