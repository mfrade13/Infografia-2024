local composer = require( "composer" )
local scene = composer.newScene()

-- Groups

local grpMain = display.newGroup()

-- Variables

local fruitNames = {
    "assets/apple.png", 
    "assets/banana.png", 
    "assets/pineapple.png", 
    "assets/strawberry.png"
}

local fruits = {}
local trail = {}
local katanas = {}
local score = 0
local lifes = 3
local numberFrames = 0
local minVelocityBomb = 7
local maxVelocityBomb = 10
local minVelocityFruit = 5
local maxVelocityFruit = 8
local minAngleFruit = math.pi/2.76
local maxAngleFruit = math.pi*1.9/3
local minAngleBomb = math.pi/3
local maxAngleBomb = math.pi*2/3
local numberFrames2Fruit = 200
local probabilityBomb = 0.005
local nextLevelScore = 200

-- Display objects

local scoreLabel

function endGame()
    composer.gotoScene("scenes.gameover", { effect = "fade", time = 1000 })
end

function createTrail(event)

    if event.phase == "moved" then
        local x = event.x
        local y = event.y

        local dot = display.newCircle(grpMain, x, y, 10)
        dot:setFillColor(1,1,1)
        dot.alpha = 0.6
        table.insert(trail,dot)

        -- Verify collision with every fruit
        for i = 1, #fruits, 1 do
            local fruit = fruits[i][1]

            if (event.x >= fruit.contentBounds.xMin) and (event.x <= fruit.contentBounds.xMax) and
                (event.y >= fruit.contentBounds.yMin) and (event.y <= fruit.contentBounds.yMax) and
                fruits[i][7] then
                score = score + 10
                
                if (fruit.tag == "bomb") then
                    local fire = display.newImageRect(grpMain, 'assets/fire.png', 20, 20)
                    fire.x = event.x
                    fire.y = event.y
                    
                    transition.to(fire, { time = 1000, xScale = 50, yScale = 50, rotation = 2720, onComplete = endGame})                    
                end

                fruit.isVisible = false
                fruits[i][7] = false
                scoreLabel.text = score .. "p"

            end
        end
    end
end

function updateTrail()
    for i = 1, #trail, 1 do
        local dot = trail[i]
        dot.alpha = dot.alpha - 0.02

        if dot.alpha < -1 then
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

function updateFruitPosition(fruit, xo, yo, velocity, angle, t)
    local gravity = 0.04

    fruit.x = xo + velocity * math.cos(angle) * t
    fruit.y = yo -  velocity * math.sin(angle) * t + 0.5 * gravity * t^2

end

function addObject(tag, minAngle, maxAngle, minVelocity, maxVelocity)
    local image, sizeX, sizeY

    if tag == "bomb" then
        image = 'assets/bomb.png'
        sizeX = 90
        sizeY = 120
    else
        local randomFruitIndex = math.random(1, #fruitNames)
        image = fruitNames[randomFruitIndex]

        if randomFruitIndex == 3 then --pineapple           
            sizeX = 150
            sizeY = 180
        else
            sizeX = 120
            sizeY = 120
        end
    end

    local object = display.newImageRect(grpMain, image, sizeX, sizeY)
        
    object.x = math.random(200, CW-200)
    object.y = CH
    object.tag = tag

    local velocity = math.random(minVelocity, maxVelocity)
    local angle = math.random(minAngle, maxAngle)
    local xo = object.x
    local yo = object.y
    local time = 0

    fruits[#fruits + 1] = {object, xo, yo, velocity, angle, time, true} -- Last argument: isActive
end

function addFruits(isBomb)
    local isBomb = isBomb or nil

    if isBomb then 
        addObject("bomb", minAngleBomb, maxAngleBomb, minVelocityBomb, maxVelocityBomb)
    else
        for i = 1, #fruitNames, 1 do
            addObject("fruit", minAngleFruit, maxAngleFruit, minVelocityFruit, maxVelocityFruit)
         end   
    end
end

function throwBomb()
    
    if math.random() < probabilityBomb then
        return true
    else
        return false
    end

end

function checkCollision(object, i)
    if object.x <= 0 then -- right collision
        fruits[i][2] = fruits[i][1].x -- xo
        fruits[i][3] = fruits[i][1].y -- yo
        fruits[i][4] = - (fruits[i][4] + 2)-- velocity
        fruits[i][5] = fruits[i][5] + math.pi/4
        fruits[i][6] = 0
    elseif object.x >= CW  then -- left collision
        fruits[i][2] = fruits[i][1].x -- xo
        fruits[i][3] = fruits[i][1].y -- yo
        fruits[i][5] = fruits[i][5] + math.pi * 9/10
        fruits[i][6] = 0
    elseif object.y <= 0 then -- top collision
        fruits[i][2] = fruits[i][1].x
        fruits[i][3] = fruits[i][1].y
        fruits[i][4] = - fruits[i][4]
        fruits[i][5] = fruits[i][5] + math.pi/9
        fruits[i][6] = 0
    end
end

function manageFruits()
    for i = #fruits, 1, -1 do
        
        local localFruit = fruits[i][1]
        fruits[i][6] = fruits[i][6] + 1 --time

        updateFruitPosition(fruits[i][1],fruits[i][2], fruits[i][3], fruits[i][4], fruits[i][5], fruits[i][6])
        checkCollision(localFruit, i)

        if localFruit.y > CH + 80 or fruits[i][7] == false then

            if (localFruit.y > CH + 80 and fruits[i][7] == true and lifes > 0 and localFruit.tag  ~= "bomb") then
                local katana = katanas[#katanas]
                table.remove(katanas, #katanas)
                katana:removeSelf()
                katana = nil
                fruits[i][7] = false
                lifes = lifes - 1
            end

            local b = table.remove(fruits, i)

            if b ~= nil then
                b[1]:removeSelf()
                b = nil 
            end
        end       
    end

    if numberFrames > 200 then
        numberFrames = 0
        addFruits()
    end

    if throwBomb() then
        addFruits(true)
    end

    numberFrames = numberFrames + 1
end

function incrementLevel()

    if score >= nextLevelScore then
        minVelocityFruit = minVelocityFruit + 0.2
        maxVelocityFruit = maxVelocityFruit + 0.2
        probabilityBomb = probabilityBomb + 0.001
        minVelocityBomb = minVelocityBomb + 0.2
        maxVelocityBomb = maxVelocityBomb + 0.2
        
        nextLevelScore = nextLevelScore + 200
    end

end



function update()
    updateTrail()
    manageFruits()
    incrementLevel()

    if (lifes == 0 ) then
        endGame()
    end
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
    local sceneGroup = self.view
    sceneGroup:insert(grpMain)
    
    local background = display.newImageRect(grpMain, 'assets/background.png', CW, CH)
    background.x = HW; background.y = HH
    

    for i=1, lifes, 1 do
        local katana = display.newImageRect(grpMain,    'assets/katana.png', 100, 100)
        katana.y = CH/9.8; katana .x = 5*CW/7 +  (60 * i)
        katana.tag = i
        table.insert(katanas, katana)
    end

    scoreLabel = display.newText(grpMain, score .. "p", CW/7, CH/9, "PressStart2P-Regular.ttf", CH/20)


end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        Runtime:addEventListener("enterFrame", update)
        Runtime:addEventListener("touch", createTrail)
        lifes = 3
    end

end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        Runtime:removeEventListener("enterFrame", update)
        Runtime:removeEventListener("touch", createTrail)
        composer.removeScene("scenes.game") 
    end

end
 
 
-- destroy()
function scene:destroy( event )
    local sceneGroup = self.view    
end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event function li histeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene