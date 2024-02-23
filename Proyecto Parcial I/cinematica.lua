local composer = require( "composer" )
local player = require('player')
local targetPlayers = {}
local targetPositions = {}
local rectCreator = require( "Utilities.rectangles" )

local scene = composer.newScene()
local shooter
local targets = 1
local precision
local weaponSelection
local nextPerspectiveBTN

local centerX = display.contentCenterX
local centerY = display.contentCenterY
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
local function ir_targets()
    local opciones = {
        effect = "slideLeft",
        time = 500,
        params = {
            targets = targets,
            precision = precision,
            weaponSelection = weaponSelection
        }
    }
    
    composer.gotoScene("targets", opciones)
end

function createTargets (sceneGroup)

    for i = 1, targets do
        local offsetY = math.random(CH*0.2)
        local offsetX = math.random(CW*0.3)
        targetPositions[i] = { x = centerX * 1.2 + offsetX, y = centerY * 1.4 +  offsetY }
        local weapon = math.random(3)
        local newTgt = player.initop1(weapon)
        sceneGroup:insert(newTgt.animation)
        targetPlayers[i] = newTgt
    end
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    local fondo = rectCreator.createRectImage(sceneGroup, carpeta_recursos .. "background.jpg", CW, CH, centerX, centerY)

    targets = event.params.targets
    precision = event.params.precision
    weaponSelection = event.params.armaSeleccionadaIndex

    shooter = player.initop1(weaponSelection)
    sceneGroup:insert(shooter.animation)

    nextPerspectiveBTN = rectCreator.createRectImage(sceneGroup, carpeta_recursos .. "play.png", CW * 0.08, CH * 0.09, centerX * 1.8, centerY * 0.9)
    createTargets(sceneGroup)
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        shooter:renderGameSequence()
        for i = 1, targets do
            targetPlayers[i]:renderTargetSequence(targetPositions[i].x,targetPositions[i].y)
        end
        nextPerspectiveBTN:addEventListener("tap", ir_targets)
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