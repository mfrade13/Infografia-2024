local composer = require( "composer" )
 
local scene = composer.newScene()
 

 local fondo,titulo, boton_play

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
 function ir_level(e)
    if e.phase == "ended" then
        local options =
        {
            effect = "zoomInOut",
            time = 500,
            params = {
            }
        }
        composer.gotoScene( "level" , options )
    end
 
 end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view

    fondo = display.newImageRect(sceneGroup,  carpeta_recursos .. "fondomenu.png", CW+300, CH+300)
    fondo.x = CW/2; fondo.y=CH/2
    
    titulo = display.newImageRect(sceneGroup, carpeta_recursos.."titulo.jpg", 300, 300)
    titulo.x = CW/2; titulo.y = CH/4

    boton_play = display.newImageRect(sceneGroup, carpeta_recursos.."start.png", 300, 300)
    boton_play.x = CW/2; boton_play.y = CH/1.5


end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        boton_play:addEventListener("touch", ir_level)
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