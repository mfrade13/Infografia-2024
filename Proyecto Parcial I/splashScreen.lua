local composer = require( "composer" )
local player = require('player')
local scene = composer.newScene()
local introLogo

function ir_menu()
    local options =
    {
        time = 500,
        params = {
            nivel = 1,
            tiempo = 60,
            cantidad_enemigos = 5

        }
    }
    composer.gotoScene( "menu", options )
end

-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    
    local fondo = display.newRect( 0, 0, CW, CH )
    fondo.anchorX = 0; fondo.anchorY = 0
    fondo:setFillColor( 0.44 )
    sceneGroup:insert(fondo)

    introLogo = player.init()  

end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        local titles = display.newText("ANÁLISIS BALÍSTICO ", display.contentCenterX, display.contentCenterY, font, 40)
        sceneGroup:insert(titles)
        transition.from(titles, {time = 1500, x = -display.contentWidth, transition = easing.outExpo})
        introLogo.renderRunIntro( function() ir_menu() end )
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