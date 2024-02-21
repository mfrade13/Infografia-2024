local composer = require( "composer" )
 
local scene = composer.newScene()
 

 local bckg

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
function go_back(e)
    if e.phase == "ended" then
        local options =
        {
            effect = "fade",
            time = 800
        }
        composer.gotoScene("menu", options)
    end
 end
 

 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    bckg = display.newImageRect(sceneGroup,  res_folder .. "IFmenu.png", CW, CH)
    bckg.anchorX = 0; bckg.anchorY=0

    btn_play = display.newImageRect(sceneGroup, res_folder.."IFplay.jpg", 200, 50)
    btn_play.x = CW*(4/5); btn_play.y = CH*(3.8/5)

    btn_instructions= display.newImageRect(sceneGroup, res_folder.."instructions.png", 200, 50)
    btn_instructions.x = CW*(4/5); btn_instructions.y = CH*(4.2/5)

    logo = display.newImageRect(sceneGroup, res_folder.."IceFishingLogo.png", 288*(0.8), 184*(0.8))
    logo.x = CW*(1.3/5); logo.y = CH*(4/5)
    
 
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        btn_play:addEventListener("touch", goto_game)
        btn_instructions:addEventListener("touch", open_instructions)
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