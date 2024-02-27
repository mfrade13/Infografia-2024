local composer = require( "composer" )
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 local fondo
 
 
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
--[[
    escalas para viñetas
    1 xScale =1.5, yScale= 3.2
    2 xScale = 3, yScale= 3.2, x=-2060 y=0
 ]]--

-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    local bg = display.newRect(sceneGroup, CW/2,CH/2, CW,CH)
    bg:setFillColor(0.22)
    
    fondo = display.newImageRect(sceneGroup, "spiderman2.jpg", CW, CH)
    fondo.anchorX = 0; fondo.anchorY = 0
    --fondo:scale(3, 3.2)
    --fondo:translate(-2060 ,0)
    --fondo.height = 
    print(fondo.contentWidth, fondo.contentHeight)
    

end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        transition.to(fondo, {xScale=1.5, yScale=3.2, time=1500, delay=1000})
        transition.to(fondo, {xScale=3,x=-2060, yScale=3.2, time=1500, delay=3000})

        -- local panel = display.newRect(CW, CH/2, 20, CH)
        -- panel:setFillColor(0)
        -- panel.anchorX = 1
        -- transition.to(panel, {xScale =5, time =1500})
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