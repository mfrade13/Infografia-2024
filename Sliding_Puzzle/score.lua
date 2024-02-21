local composer = require( "composer" )
 
local scene = composer.newScene()
 
-- Variables

local time, moves
local background, overlay
local puzzleInitialX = 130 
local puzzleInitialY = 90
local woodScoreBox, completedText, timeText, movementsText
local goBackButton

-- Functions

local function goToMenu(event)
    local options = 
    {
        effect = "slideRight",
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

    time = event.params.time
    moves = event.params.moves

    local minutes = math.floor(time / 60000)
    local seconds = math.floor((time % 60000) / 1000)

    background = display.newImageRect(sceneGroup, resourcesPath .. "background.jpg", CW, CH)
    background.x = CW/2; background.y = CH/2

    overlay = display.newRect(sceneGroup, CW/2, CH/2, CW, CH)
    overlay:setFillColor(0, 0, 0) 
    overlay.alpha = 0.6

    woodScoreBox = display.newImageRect(sceneGroup, resourcesPath .. "woodenscorebox.png", 800, 600)
    woodScoreBox.x = puzzleInitialX; woodScoreBox.y = puzzleInitialY
    woodScoreBox.anchorX = 0; woodScoreBox.anchorY = 0

    completedText = display.newText({
        parent = sceneGroup,
        text = "COMPLETE",
        x = puzzleInitialX + 120,
        y = puzzleInitialY + 170,
        font = "PressStart2P-Regular.ttf",
        fontSize = 70
    })
    completedText:setFillColor(1, 1, 1)
    completedText.anchorX = 0; completedText.anchorY = 0

    timeText = display.newText({
        parent = sceneGroup,
        text = string.format("TIME: %02d:%02d", minutes, seconds),
        x = puzzleInitialX + 260,
        y = puzzleInitialY + 300,
        font = "PressStart2P-Regular.ttf",
        fontSize = 30
    })
    timeText:setFillColor(1, 1, 1)
    timeText.anchorX = 0; timeText.anchorY = 0

    movementsText = display.newText({
        parent = sceneGroup,
        text = "MOVES: " .. moves,
        x = puzzleInitialX + 260,
        y = puzzleInitialY + 400,
        font = "PressStart2P-Regular.ttf",
        fontSize = 30
    })
    movementsText:setFillColor(1, 1, 1)
    movementsText.anchorX = 0; movementsText.anchorY = 0

    goBackButton = display.newImageRect(sceneGroup, resourcesPath .. "goBack.png", 80, 80)
    goBackButton.x = puzzleInitialX - 100; goBackButton.y = puzzleInitialY - 50
    goBackButton.anchorX = 0; goBackButton.anchorY = 0
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        goBackButton:addEventListener("touch", goToMenu)
 
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