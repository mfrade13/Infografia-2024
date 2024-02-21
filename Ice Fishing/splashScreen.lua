local composer = require( "composer" )
 
local scene = composer.newScene()
 
CW = display.contentWidth
CH = display.contentHeight
res_folder = "resources/"

local bckg, logo


function goto_menu()
    local options =
        {
            effect = "fade",
            time = 500,
            params = {
                nivel = 1,
                tiempo = 60
            }
        }
        composer.gotoScene( "menu", options )
end

-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    
    bckg = display.newRect( 0, 0, CW, CH )
    bckg.anchorX = 0; bckg.anchorY = 0
    bckg:setFillColor(0)

    logo = display.newImageRect(res_folder.. "IceFishingLogo.png", 288, 184)
    logo.x = CW/2; logo.y = CH/2

    sceneGroup:insert(bckg)
    sceneGroup:insert(logo)

end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        transition.to(logo, {time=2000, onComplete=goto_menu})
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