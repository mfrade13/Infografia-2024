local composer = require( "composer" )
 
local scene = composer.newScene()
 
CW = display.contentWidth
CH = display.contentHeight
carpeta_recursos = "resources/"

local fondo, icono

function ir_menu()
    local options =
        {
            effect = "zoomOutInFade",
            time = 500,
            params = {

            }
        }
        composer.gotoScene( "menu", options )
end

-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    fondo = display.newRect( 0, 0, CW, CH )
    fondo.anchorX = 0; fondo.anchorY = 0; fondo:setFillColor( 209/255, 105/255, 106/255 )

    icono = display.newImageRect(carpeta_recursos.. "logoAtari.png", 200, 200)
    icono.x = CW/2; icono.y = CH/2

    sceneGroup:insert(fondo)
    sceneGroup:insert(icono)

end
 
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        transition.to(icono, {rotation=0, time=500, onComplete=ir_menu})
    end
end
 

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