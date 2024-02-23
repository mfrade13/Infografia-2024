local composer = require( "composer" )
 
local scene = composer.newScene()

CW = display.contentWidth
CH = display.contentHeight

newFontSource = "PressStart2P-Regular.ttf"

local Xo = CW/2 + 40
local Yo = CH/2

stars = {}

local buttonStar, textButton, title
 
function create_star()
    local star = display.newRect(math.random(0 ,CW + 100), math.random(0,CH + 100),2,2)
    
    star:setFillColor(1)
    star.xSale = 2
    star.yScale = 2
    return star
end

function move_background(event)
    for i = 1, #stars do
        local dx = CW/2 - stars[i].x
        local dy = CH/2 - stars[i].y

        if math.abs(dx) < math.random(1,10) or math.random(1,10) < 1 then
            stars[i].x = math.random(0,CW + 10)
            stars[i].y = math.random(0,CH + 10)
            stars[i].xScale = 1
            stars[i].yScale = 1
        else
            stars[i].x = stars[i].x + dx * 0.002
            stars[i].y = stars[i].y + dy * 0.002
            stars[i].xScale = stars[i].xScale * 0.995
            stars[i].yScale = stars[i].yScale * 0.995
        end
    end
end

function goto_simulador(event)
    print("Touch event fired!")
    if event.phase == "ended" then
        local options = {
        effect = "slideLeft",
        time = 2000
        }
        composer.gotoScene("simulator", options)
    end
    return true
end

-- create()
function scene:create( event )
    print( "CREATE MENU" )
 
    local sceneGroup = self.view

    for i=1,800 do
        stars[i] = create_star()
    end

    title = display.newText(sceneGroup, "Solar System", CW/2, CH/3, newFontSource, 65)

    buttonStart = display.newRoundedRect(sceneGroup, CW/2, CH/3*2, 300, 100, 10 )
    buttonStart:setFillColor(0, 0, 0, 0.1)
    buttonStart.strokeWidth = 4
    buttonStart:setStrokeColor(1, 1, 1) 

    textButton = display.newText(sceneGroup, "START", CW/2, CH/3*2, newFontSource, 45)
    textButton:setFillColor(1, 1, 1) 

    sceneGroup:insert(buttonStart)
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen

        buttonStart:addEventListener( "touch", goto_simulador )
        Runtime:addEventListener( "enterFrame", move_background)
 
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