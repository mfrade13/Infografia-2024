local composer = require( "composer" )

local scene = composer.newScene()

-- Variables

local background, icon, overlay
local slidingText, puzzleText

-- Functions

function goToMenu(event)
    local options = 
    {
        effect = "slideLeft",
        time = 1000
    }
    composer.gotoScene("menu", options)
end


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )
 
    local sceneGroup = self.view

    background = display.newImageRect(resourcesPath .. "background.jpg", CW, CH)
    background.x = CW/2; background.y = CH/2

    overlay = display.newRect(CW/2, CH/2, CW, CH)
    overlay:setFillColor(0, 0, 0) 
    overlay.alpha = 0.6

    icon = display.newImageRect(resourcesPath .. "icon.jpg", 200, 200)
    icon.x = CW/2; icon.y = CH/2 - 100

    slidingText = display.newText({
        parent = sceneGroup,
        text = "SLIDING",
        x = CW/2 - 230,
        y = CH/2 + 50,
        font = "PressStart2P-Regular.ttf",
        fontSize = 70
    })
    slidingText:setFillColor(1, 1, 1)
    slidingText.anchorX = 0; slidingText.anchorY = 0

    puzzleText = display.newText({
        parent = sceneGroup,
        text = "PUZZLE",
        x = CW/2 - 200,
        y = CH/2 + 160,
        font = "PressStart2P-Regular.ttf",
        fontSize = 70
    })
    puzzleText:setFillColor(1, 1, 1)
    puzzleText.anchorX = 0; puzzleText.anchorY = 0

    sceneGroup:insert(background)
    sceneGroup:insert(overlay)
    sceneGroup:insert(icon)
    sceneGroup:insert(slidingText)
    sceneGroup:insert(puzzleText)
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        transition.to(icon, {time=1000, onComplete=goToMenu})
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
        composer.removeScene("splashScreen")
 
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