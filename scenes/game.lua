local composer = require( "composer" )
 
local scene = composer.newScene()
local background
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
local score = 0
local lifes = 3
local katanas = {}
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

        for i = 1, #fruits, 1 do
            local fruit = fruits[i][1]

            if (event.x >= fruit.contentBounds.xMin) and (event.x <= fruit.contentBounds.xMax) and
                (event.y >= fruit.contentBounds.yMin) and (event.y <= fruit.contentBounds.yMax) and fruits[i][7] then
                score = score + 10
                
                if (fruit.tag == "bomb") then
                    endGame()
                end
                fruit.isVisible =false
                fruits[i][7] = false
                scoreLabel.text = score .. "p"

            end
        end
        
    end
end

function updateTrail()
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

function updateFruitPosition(fruit, xo, yo, velocity, angle, t)
    local gravity = 0.04

    fruit.x = xo + velocity * math.cos(angle) * t
    fruit.y = yo -  velocity * math.sin(angle) * t + 0.5 * gravity * t^2
end

function addFruit(isBomb)
    local isBomb = isBomb or nil

    if isBomb then 
        local bomb = display.newImageRect(grpMain,'assets/bomb.png', 90,120 )
        
        bomb.x = math.random(200, CW-200)
        bomb.y = CH
        bomb.tag = "bomb"
        local velocity = math.random(7,12)
        local angle = math.random(math.pi/3, math.pi-math.pi/3)
        local xo = bomb.x
        local yo = bomb.y
        local time = 0
        fruits[#fruits + 1] = {bomb, xo, yo, velocity, angle, time, true}
    end
    for i = #fruitNames, 1, -1 do
        local fruit       
        rand = math.random(1,#fruitNames)
        if rand == 3 then --pineapple           
            fruit = display.newImageRect(grpMain, fruitNames[rand], 150,180)
        else
            fruit = display.newImageRect(grpMain, fruitNames[rand], 120,120)
        end
        

        fruit.x = math.random(200, CW-200)
        fruit.y = CH
        local velocity = math.random(5,9)
        local angle = math.random(math.pi/3, math.pi-math.pi*2/3)
        local xo = fruit.x
        local yo = fruit.y
        local time = 0
        fruits[#fruits + 1] = {fruit, xo, yo, velocity, angle, time, true}
    end   
end

function manageFruits()
    for i = #fruits, 1, -1 do
        local localFruit = fruits[i][1]
        fruits[i][6] = fruits[i][6] + 1

        updateFruitPosition(fruits[i][1],fruits[i][2], fruits[i][3], fruits[i][4], fruits[i][5], fruits[i][6])

        if localFruit.x <= 0 then -- left collision
            fruits[i][2] = fruits[i][1].x -- xo
            fruits[i][3] = fruits[i][1].y -- yo
            fruits[i][4] = - (fruits[i][4] + 2)-- velocity
            fruits[i][5] = fruits[i][5] + math.pi/4
            fruits[i][6] = 0
        elseif localFruit.x >= CW  then -- right collision
            fruits[i][2] = fruits[i][1].x -- xo
            fruits[i][3] = fruits[i][1].y -- yo
            fruits[i][5] = fruits[i][5] + math.pi * 9/10
            fruits[i][6] = 0
        elseif localFruit.y <= 0 then -- top collision
            fruits[i][2] = fruits[i][1].x
            fruits[i][3] = fruits[i][1].y
            fruits[i][4] = - fruits[i][4]
            fruits[i][5] = fruits[i][5] + math.pi/9
            fruits[i][6] = 0
        end

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
        addFruit()
    elseif numberFrames == 150 then
        addFruit(true)
    end

    numberFrames = numberFrames + 1
end



function update()
    updateTrail()
    manageFruits()
    
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
    background = display.newImageRect(grpMain, 'assets/background.png', CW, CH)
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
 
    elseif ( phase == "did" ) then
        
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
        
    elseif ( phase == "did" ) then
        
        
        
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