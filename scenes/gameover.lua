local composer = require( "composer" )
 
local scene = composer.newScene()
local background, message, restart

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
    local sceneGroup = self.view
    background = display.newImageRect(sceneGroup, 'assets/gameover_background.jpg', CW, CH)
    background.x = HW; background.y = HH
    background.alpha = 0.7
    
    message = display.newText(sceneGroup, "Game Over", HW, HH, "PressStart2P-Regular.ttf", CH/12)

    restart = display.newImageRect(sceneGroup, 'assets/restart.png',CW/12, CW/12)
    restart.x = HW; restart.y = HH + CH/5

    restart:addEventListener("touch", function ()
        composer.gotoScene('scenes.menu',{ effect = "fade", time = 1000 })
    end)
 
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