local composer = require( "composer" )
 
local scene = composer.newScene()
local background

-- Variables

local fruitNames = {
    "assets/apple.png", 
    "assets/banana.png", 
    "assets/pineapple.png", 
    "assets/strawberry.png"
}

local fruits = {}
local trail = {}
local score = 0
local numberFrames = 0

local scoreLabel


local xVelocities = {
    -4,
    -2,
    2,
    4
}

local yVelocities = {
    -5,
    -7,
}


local function createTrail(event)

    if event.phase == "moved" then
        local x = event.x
        local y = event.y
        local dot = display.newCircle(x, y, 10)
        dot:setFillColor(1,1,1)
        dot.alpha = 0.6
        table.insert(trail,dot)

        for i = 1, #fruits, 1 do
            local fruit = fruits[i][1]
            if ((event.x >= fruit.contentBounds.xMin) and (event.x <= fruit.contentBounds.xMax) and
                (event.y >= fruit.contentBounds.yMin) and (event.y <= fruit.contentBounds.yMax)) == true
                and fruits[i][4] == true then
                score = score + 10
                print("SCOREEE: " ..score)
                fruit.isVisible =false
                fruits[i][4] = false
                scoreLabel.text = score .. "p"

            end
        end
        
    end
end

local function updateTrail()
    for i = #trail, 1, -1 do
        local dot = trail[i]
        dot.alpha = dot.alpha - 0.02

        if dot.alpha < -20 then
            table.remove(trail, i)
            if dot ~= nil then
                dot:removeSelf()
                dot = nil 
            end
        end
    end
end

--
-- Add Fruits

local function addFruit()

    for i = #fruitNames, 1, -1 do
        local fruit       
        rand = math.random(1,#fruitNames)
        if rand == 3 then --pineapple           
            fruit = display.newImageRect(fruitNames[rand], 150,180)
        else
            fruit = display.newImageRect(fruitNames[rand], 120,120)
        end
        
        fruit.anchorX = 0
        fruit.anchorY = 0
        fruit.x = math.random(200, CW)
        fruit.y = CH
        local xVelocity =xVelocities[math.random (1, #xVelocities)]
        local yVelocity = yVelocities[math.random (1, #yVelocities)]
        fruits[#fruits + 1] = {fruit, xVelocity, yVelocity, true}
    end   
end

local function manageFruits()
    for i = #fruits, 1, -1 do
        local localFruit = fruits[i][1]
        localFruit:translate(fruits[i][2], fruits[i][3])

        if localFruit.y <= CH/5 then
            fruits[i][3] = - fruits[i][3]
        end

        if localFruit.x <-80 or localFruit.y < -80 or localFruit.x > CW + 80
            or localFruit.y > CH +80 or fruits[i][4] == false then
            local b = table.remove(fruits, i)
            if b ~= nil then
                b[1]:removeSelf()
                b = nil 
            end
        end       
    end

    if numberFrames > 150 then
        numberFrames = 0
        addFruit()
    end

    numberFrames = numberFrames + 1
end

local function update()
    updateTrail()
    manageFruits()
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
    local sceneGroup = self.view
    background = display.newImageRect(sceneGroup, 'assets/background.png', CW, CH)
    background.x = HW; background.y = HH

    scoreLabel = display.newText(sceneGroup, score .. "p", CW/7, CH/9, "PressStart2P-Regular.ttf", CH/20)

    Runtime:addEventListener("enterFrame", update)
    Runtime:addEventListener("touch", createTrail)
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