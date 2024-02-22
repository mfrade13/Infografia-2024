local composer = require( "composer" )
 
local scene = composer.newScene()
 

 local bckg, stats, game, btn_close, finalscore

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

    btn_close = display.newText(sceneGroup,"X", CW*24/25, CH*2/23, "arial bold",30)

    bckg = display.newImageRect(sceneGroup,  res_folder .. "IFgameOver.png", (250)*1.6, (173)*1.6)
    bckg.x = display.contentCenterX; bckg.y=display.contentCenterY

    game=display.newText(sceneGroup,"GAME OVER", CW/2, CH/5, "arial bold",90)
    
    stats=display.newText(sceneGroup,"Fishes: "..event.params.finalscore, CW/2, CH*4/5, "arial bold",50)
   
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        btn_close:addEventListener("touch", go_back)
        
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
        composer.removeScene("end")
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