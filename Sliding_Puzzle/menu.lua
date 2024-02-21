local composer = require( "composer" )

local scene = composer.newScene()

-- Variables

local background, overlay
local buttons = {}
local levelTexts = {}

-- Groups

local backgroundGroup

-- Functions

function goToGame(event)
    if event.phase == "ended" then 
        local buttonNumber = event.target.number
        local options = 
        {
            effect = "fade",
            time = 1000,
            params = {
                level = buttonNumber
            }
        }
        composer.gotoScene("game", options)
    end 
    return true
end

function createButtons()
    for i=1,3,1 do 
        buttons[i] = display.newImageRect(backgroundGroup, resourcesPath .. "startButton.png", 320, 120)
        buttons[i].x = CW/2; buttons[i].y = CH/4 + ((i-1)*180)
        buttons[i].number = i
        buttons[i]:addEventListener("touch", goToGame)

        levelTexts[i] = display.newText({
            parent = backgroundGroup,
            text = "LEVEL " .. i,
            x = buttons[i].x,
            y = buttons[i].y + 10,
            font = "PressStart2P-Regular.ttf",
            fontSize = 30
        })
        levelTexts[i]:setFillColor(1, 1, 1)  
    end
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view

    backgroundGroup = display.newGroup()
    sceneGroup:insert(backgroundGroup)

    background = display.newImageRect(backgroundGroup, resourcesPath .. "background.jpg", CW, CH)
    background.x = CW/2; background.y = CH/2

    overlay = display.newRect(backgroundGroup, CW/2, CH/2, CW, CH)
    overlay:setFillColor(0, 0, 0) 
    overlay.alpha = 0.6

    createButtons()
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
        composer.removeScene("menu")
 
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