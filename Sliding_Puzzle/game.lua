local composer = require( "composer" )
 
local scene = composer.newScene()

-- Variables

local startTime
local isRunning = false
local elapsedTime = 0 
local movements = 0
local gridSize
local tileSize
local gapSize = 5
local woodBoxPositionX, woodBoxPositionY
local puzzleMatrix = {}
local initialPuzzleState = {}  
local emptyRow, emptyCol
local numberText
local timeText, movementsText
local startButton, startText
local image
local puzzleInitialX = 150 
local puzzleInitialY = 190 
local woodBox, background
local level
local imageName = "tucan"

-- Groups

local puzzleGroup, interfaceGroup, backgroundGroup

-- Functions

local function goToScoreboard()
    local options = 
    {
        effect = "fade",
        time = 2000,
        params = {
            moves= movements,
            time = elapsedTime
        }
    }
    composer.gotoScene("score", options)
end 

local function assignValuesLevel(level)
    if (level == 1) then 
        gridSize = 3
        tileSize = 150
        woodBoxPositionX = puzzleInitialX + (gridSize - 1) * (tileSize + gapSize) - 75
        woodBoxPositionY = puzzleInitialY + (gridSize - 1) * (tileSize + gapSize) - 80 
    elseif (level == 2) then  
        gridSize = 4
        tileSize = 112.5
        woodBoxPositionX = puzzleInitialX + (gridSize - 1) * (tileSize + gapSize) - 115
        woodBoxPositionY = puzzleInitialY + (gridSize - 1) * (tileSize + gapSize) - 120
    else  
        gridSize = 5
        tileSize = 90
        woodBoxPositionX = puzzleInitialX + (gridSize - 1) * (tileSize + gapSize) - 140
        woodBoxPositionY = puzzleInitialY + (gridSize - 1) * (tileSize + gapSize) - 145
    end
end

local function updateTime()
    if isRunning then
        local currentTime = system.getTimer()
        elapsedTime = currentTime - startTime

        local minutes = math.floor(elapsedTime / 60000)
        local seconds = math.floor((elapsedTime % 60000) / 1000)

        timeText.text = string.format("TIME: %02d:%02d", minutes, seconds)
    end
end

local function startTimer(event)
    if event.phase == "ended" then
        startTime = system.getTimer()
        isRunning = true
        Runtime:addEventListener("enterFrame", updateTime)
    end
    return true
end

local function stopTimer()
    if isRunning then
        isRunning = false
        Runtime:removeEventListener("enterFrame", updateTime)
    end
end

local function checkVictory()
    for i = 1, gridSize do
        for j = 1, gridSize do
            if puzzleMatrix[i][j] ~= initialPuzzleState[i][j] then
                return false
            end
        end
    end

    return true
end

local function clearPuzzle()
    display.remove(puzzleGroup)
end

local function clearDisplay()
    display.remove(interfaceGroup)
    display.remove(backgroundGroup)
end


local function completePuzzle()
    if puzzleMatrix[gridSize][gridSize] == "empty" then
        number = gridSize * gridSize
        puzzleMatrix[gridSize][gridSize] = number
        local x = puzzleInitialX + (gridSize - 1) * (tileSize + gapSize) + tileSize/2
        local y = puzzleInitialY + (gridSize - 1) * (tileSize + gapSize) + tileSize/2
        local tile = display.newImageRect(puzzleGroup, resourcesPath .. imageName .. level .. "/" .. imageName .. number .. ".jpg", tileSize, tileSize)
        tile.x = x; tile.y = y
        numberText = display.newText(puzzleGroup, tostring(number), x + tileSize - 10 - tileSize/2, y + tileSize - 10 - tileSize/2, native.systemFont, 24)
        numberText:setTextColor(1, 1, 1)
        numberText.isVisible = false

        tile.yScale = 0.5
        tile.xScale = 0.5

        transition.to(tile, {
            time = 1000,
            xScale = 1,
            yScale = 1,
            onComplete = function()
                numberText.isVisible = true
                timer.performWithDelay(2000, function()
                    clearPuzzle()
                    goToScoreboard()
                end)
            end
        })
    end
end

local function shuffle()
    local possible_moves = {}
    local row, col

    for i, tiles_row in ipairs(puzzleMatrix) do
        for j, tile in ipairs(tiles_row) do
            if tile == "empty" then
                row, col = i, j
            end
        end
    end

    if row > 1 then
        table.insert(possible_moves, "up")
    end
    if row < gridSize then
        table.insert(possible_moves, "down")
    end
    if col > 1 then
        table.insert(possible_moves, "left")
    end
    if col < gridSize then
        table.insert(possible_moves, "right")
    end

    local choice = possible_moves[math.random(#possible_moves)]

    if choice == "right" then
        puzzleMatrix[row][col], puzzleMatrix[row][col + 1] = puzzleMatrix[row][col + 1], puzzleMatrix[row][col]
    elseif choice == "left" then
        puzzleMatrix[row][col], puzzleMatrix[row][col - 1] = puzzleMatrix[row][col - 1], puzzleMatrix[row][col]
    elseif choice == "up" then
        puzzleMatrix[row][col], puzzleMatrix[row - 1][col] = puzzleMatrix[row - 1][col], puzzleMatrix[row][col]
    elseif choice == "down" then
        puzzleMatrix[row][col], puzzleMatrix[row + 1][col] = puzzleMatrix[row + 1][col], puzzleMatrix[row][col]
    end
end

local function tileTouched(event)
    local tile = event.target

    if event.phase == "ended" and isRunning then
        local row, col = math.floor((tile.y - puzzleInitialY) / (tileSize + gapSize)) + 1, math.floor((tile.x - puzzleInitialX) / (tileSize + gapSize)) + 1
        print("Tile touched: Row=" .. row .. ", Col=" .. col)
        local canMove = false

        if (row == emptyRow and col == emptyCol + 1) or
           (row == emptyRow and col == emptyCol - 1) or
           (row == emptyRow + 1 and col == emptyCol) or
           (row == emptyRow - 1 and col == emptyCol) then
            canMove = true
        end

        if canMove then
            movements = movements + 1
            movementsText.text = "MOVES: " .. movements

            local newX = puzzleInitialX + (emptyCol - 1) * (tileSize + gapSize)
            local newY = puzzleInitialY + (emptyRow - 1) * (tileSize + gapSize)

            puzzleMatrix[emptyRow][emptyCol], puzzleMatrix[row][col] = puzzleMatrix[row][col], puzzleMatrix[emptyRow][emptyCol]
            emptyRow, emptyCol = row, col

            transition.to(tile, {time = 200, x = newX, y = newY})
            transition.to(tile.numberText, {time = 200, x = newX + tileSize - 10, y = newY + tileSize - 10})

            if checkVictory() then
                stopTimer()
                completePuzzle()
            end
        end
    end
    return true
end

local function drawPuzzle()
    for i = 1, gridSize do
        for j = 1, gridSize do
            local tileValue = puzzleMatrix[i][j]
            local x = puzzleInitialX + (j - 1) * (tileSize + gapSize)
            local y = puzzleInitialY + (i - 1) * (tileSize + gapSize)

            if tileValue ~= "empty" then
                local tile = display.newImageRect(puzzleGroup, resourcesPath .. imageName .. level .. "/" .. imageName .. tileValue .. ".jpg", tileSize, tileSize)
                tile.x = x; tile.y = y
                tile.anchorX, tile.anchorY = 0, 0

                tile.numberText = display.newText(puzzleGroup, tostring(tileValue), x + tileSize - 10, y + tileSize - 10, native.systemFont, 24)

                tile:addEventListener("touch", tileTouched)
            end
        end
    end
end


local function initPuzzle()
    for i = 1, gridSize do
        puzzleMatrix[i] = {}
        initialPuzzleState[i] = {}
        for j = 1, gridSize do
            puzzleMatrix[i][j] = (i - 1) * gridSize + j
            initialPuzzleState[i][j] = puzzleMatrix[i][j]
        end
    end
    puzzleMatrix[gridSize][gridSize] = "empty"
    initialPuzzleState[gridSize][gridSize] = puzzleMatrix[gridSize][gridSize]

    drawPuzzle()
end
    
local function sufflePuzzle(event)
    if event.phase == "ended" then 
        clearPuzzle()

        puzzleGroup = display.newGroup()

        for _ = 1, 1000 do
            shuffle()
        end

        for i, tiles_row in ipairs(puzzleMatrix) do
            for j, tile in ipairs(tiles_row) do
                if tile == "empty" then
                    emptyRow, emptyCol = i, j
                    break
                end
            end
        end

        drawPuzzle()
    end
    return true
end 

local function buttonTouched(event)
    if event.phase == "ended" then
        startTimer(event)
        sufflePuzzle(event)
    end
    return true
end


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view

    level = event.params.level
    assignValuesLevel(level)

    backgroundGroup = display.newGroup()
    sceneGroup:insert(backgroundGroup)

    puzzleGroup = display.newGroup()
    sceneGroup:insert(puzzleGroup)

    interfaceGroup = display.newGroup()
    sceneGroup:insert(interfaceGroup)

    background = display.newImageRect(backgroundGroup, resourcesPath .. "background.jpg", CW, CH)
    background.x = CW/2; background.y = CH/2

    local overlay = display.newRect(backgroundGroup, CW/2, CH/2, CW, CH)
    overlay:setFillColor(0, 0, 0) 
    overlay.alpha = 0.6
    
    timeText = display.newText({
        parent = interfaceGroup,
        text = "TIME: 0:00",
        x = puzzleInitialX - 20,
        y = puzzleInitialY - 120,
        font = "PressStart2P-Regular.ttf",
        fontSize = 30
    })
    timeText:setFillColor(1, 1, 1)
    timeText.anchorX = 0; timeText.anchorY = 0

    movementsText = display.newText({
        parent = interfaceGroup,
        text = "MOVES: 0",
        x = puzzleInitialX + 500,
        y = puzzleInitialY - 120,
        font = "PressStart2P-Regular.ttf",
        fontSize = 30
    })
    movementsText:setFillColor(1, 1, 1)
    movementsText.anchorX = 0; movementsText.anchorY = 0

    image = display.newImageRect(interfaceGroup, resourcesPath .. imageName .. ".jpg", 200, 200)
    image.x = puzzleInitialX + 600; image.y = puzzleInitialY - 50 
    image.anchorX = 0; image.anchorY = 0

    startButton = display.newImageRect(interfaceGroup, resourcesPath .. "startButton.png", 200, 120)
    startButton.x = puzzleInitialX + 600; startButton.y = puzzleInitialY + (gridSize - 1) * (tileSize + gapSize) - 60
    startButton.anchorX = 0; startButton.anchorY = 0

    startText = display.newText({
        parent = interfaceGroup,
        text = "START",
        x = puzzleInitialX + 700,
        y = puzzleInitialY + (gridSize - 1) * (tileSize + gapSize) + 10,
        font = "PressStart2P-Regular.ttf",
        fontSize = 30
    })

    woodBox = display.newImageRect(backgroundGroup, resourcesPath .. "woodenbox.png", 600, 600)
    woodBox.x = woodBoxPositionX; woodBox.y = woodBoxPositionY

    initPuzzle()
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        startButton:addEventListener("touch", buttonTouched)
 
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
        clearDisplay()
        composer.removeScene("game")
 
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