local composer = require( "composer" )
 
local scene = composer.newScene()
 
local CW = display.contentWidth
local CH = display.contentHeight

local fondo

function ir_menu(event)
    if event.phase == "ended" then 
    local options =
        {
            effect = "slideLeft",
            time = 2000,
            params = {
                nivel = 1,
                tiempo = 60,
                cantidad_enemigos = 5

            }
        }
        composer.gotoScene( "menu", options )
    end
    return true
end

-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    
--    fondo = display.newRect( CW/2, CH/2, CW, CH )
    fondo = display.newRect( 0, 0, CW, CH )
    fondo.anchorX = 0; fondo.anchorY = 0
    fondo:setFillColor( 0.44 )

    local icono = display.newImageRect("Icon.png", 100, 100)
    icono.x = CW/2; icono.y = CH/2

    fondo:addEventListener( "touch", ir_menu )

    sceneGroup:insert(fondo)
    sceneGroup:insert(icono)

end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
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