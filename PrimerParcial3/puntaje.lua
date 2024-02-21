local composer = require( "composer" )
local editor = require( "editor" )
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
local function onKeyEvent(event)
    if(event.phase == 'down' and event.keyName == 'enter') then
        Runtime:removeEventListener( "key", onKeyEvent )
        local click = audio.loadSound( 'click.wav' )
        audio.play(click)
        composer.removeScene( "puntaje" )
        composer.gotoScene( "menu" )
    end
end
 
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
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        local fondo = display.newRect( 0, 0, CW, CH )
        fondo.anchorX = 0; fondo.anchorY = 0
        fondo:setFillColor( unpack(colorClaro) )
        sceneGroup:insert( fondo )

        local textoFinal = display.newText( "Game Complete!", 20, 20, 'nokiafc22.ttf', 80 )
        textoFinal.anchorX = 0; textoFinal.anchorY = 0
        textoFinal:setFillColor( unpack(colorOscuro) )
        sceneGroup:insert(textoFinal)

        local puntosTexto = display.newText( "Score: " .. puntos, 20, 120, 'nokiafc22.ttf', 80 )
        puntosTexto.anchorX = 0; puntosTexto.anchorY = 0
        puntosTexto:setFillColor( unpack(colorOscuro) )
        sceneGroup:insert(puntosTexto)

        local bloque = display.newRect( 20, 220, 390, 90 )
        bloque.anchorX = 0; bloque.anchorY = 0
        bloque:setFillColor( unpack(colorOscuro) )
        sceneGroup:insert( bloque )

        local botonMenu = display.newText( "-> Menu", 20, 220, 'nokiafc22.ttf', 80 )
        botonMenu.anchorX = 0; botonMenu.anchorY = 0
        botonMenu:setFillColor( unpack(colorClaro) )
        sceneGroup:insert(botonMenu)

        local gameComplete = audio.loadSound( 'gameComplete.wav' )
        audio.play(gameComplete)

        Runtime:addEventListener("key", onKeyEvent)
 
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