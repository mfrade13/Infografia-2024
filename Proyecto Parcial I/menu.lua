local composer = require( "composer" )
local rectCreator = require( "Utilities.rectangles" )
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local contornoColor = {129/255, 191/255, 214/255}
local contornoAncho = 5


-- TARGETS
local targetIncrementBTN
local targetDecrementBTN
local targetTotalBox
local targetTotalTextBox
local targets = 2
-- PRESICION
local precisionIncrementBTN
local precisionDecrementBTN
local precisionTotalTextBox
local precisionTotalBox
local precision = {
    { pr = 45, name = "45 ROUNDS" },
    { pr = 55, name = "55 ROUNDS" },
    { pr = 65, name = "65 ROUNDS" },
    { pr = 75, name = "75 ROUNDS" },
    { pr = 85, name = "85 ROUNDS" }
}
local precisionIndex = 1

-- WEAPONS
local sniperIMG
local scarIMG
local famasIMG
local weaponSelection = 1
local weapons = {} 

-- PLAY
local playBTN

local function agregarContorno(imagen, contornoColor, contornoAncho)
    local contorno = display.newRect(imagen.parent, imagen.x, imagen.y, imagen.width + contornoAncho, imagen.height + contornoAncho)
    contorno:setFillColor(0, 0, 0, 0) 
    contorno.strokeWidth = contornoAncho 
    contorno:setStrokeColor(unpack(contornoColor))
    contorno.rotation = imagen.rotation
    imagen:toFront()

    return contorno 
end

local function seleccionarArma(arma, index)

    for _, weapon in ipairs(weapons) do
        if weapon.contorno then
            weapon.contorno:removeSelf()
            weapon.contorno = nil
        end
    end

    arma.contorno = agregarContorno(arma, contornoColor, contornoAncho)

    weaponSelection = index
    print(weaponSelection)
end

local function incrementarTargets()
    targets = math.min(6, targets + 1)
    targetTotalTextBox.text = tostring(targets)
    print(targets)
    print(precision[precisionIndex].pr)
    print(weaponSelection)
end

local function decrementarTargets()
    targets = math.max(2, targets - 1)
    targetTotalTextBox.text = tostring(targets)
end

local function incrementarPrecision()
    precisionIndex = precisionIndex + 1
    if precisionIndex > #precision then
        precisionIndex = 1
    end
    precisionTotalTextBox.text = precision[precisionIndex].name
end

local function decrementarPrecision()
    precisionIndex = precisionIndex - 1
    if precisionIndex < 1 then
        precisionIndex = #precision
    end
    precisionTotalTextBox.text = precision[precisionIndex].name
end

local function ir_cinematica()
    local opciones = {
        effect = "slideLeft",
        time = 500,
        params = {
            targets = targets,
            precision = precision[precisionIndex].pr,
            armaSeleccionadaIndex = weaponSelection
        }
    }
    composer.gotoScene("cinematica", opciones)
end


local centerX = display.contentCenterX
local centerY = display.contentCenterY
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view

    -- MENU
    local menuBox = rectCreator.createRectImage(sceneGroup, carpeta_recursos .. "MenuBox.png", CW, CH, centerX, centerY)
    -- Target

    local targetTextBox = display.newText("CANTIDAD DE OBJETIVOS: ", display.contentCenterX*0.5, display.contentCenterY*0.5, font, 25)
    sceneGroup:insert(targetTextBox)

    targetTotalBox = rectCreator.createRectImage(sceneGroup, carpeta_recursos .. "SmallBox.png", CW * 0.1, CH * 0.1, centerX, centerY*0.5)

    targetTotalTextBox = display.newText(targets, display.contentCenterX, display.contentCenterY*0.5, font, 25)
    sceneGroup:insert(targetTotalTextBox)

    targetIncrementBTN = rectCreator.createRectImage(sceneGroup, carpeta_recursos .. "ArrowUp.png", CW * 0.05, CH * 0.05, centerX*1.2, centerY*0.4)

    targetDecrementBTN = rectCreator.createRectImage(sceneGroup, carpeta_recursos .. "ArrowDown.png", CW * 0.05, CH * 0.05, centerX*1.2, centerY*0.55)

    -- Precision
    local precisionTextBox = display.newText("RANGO DEL SOLDADO: ", display.contentCenterX*0.5, display.contentCenterY*0.8, font, 25)
    sceneGroup:insert(precisionTextBox)

    precisionTotalBox = rectCreator.createRectImage(sceneGroup, carpeta_recursos .. "SmallBox.png", CW * 0.20, CH * 0.1, centerX, centerY*0.8)

    precisionTotalTextBox = display.newText(precision[1].name, display.contentCenterX, display.contentCenterY*0.8, font, 25)
    sceneGroup:insert(precisionTotalTextBox)

    precisionIncrementBTN = rectCreator.createRectImage(sceneGroup, carpeta_recursos .. "ArrowUp.png", CW * 0.05, CH * 0.05, centerX * 1.3, centerY* 0.7)

    precisionDecrementBTN = rectCreator.createRectImage(sceneGroup, carpeta_recursos .. "ArrowDown.png", CW * 0.05, CH * 0.05, centerX * 1.3, centerY * 0.85)

    -- Weapon    
    local selectWeaponText = display.newText("ELIJA EL ARMA: ", display.contentCenterX*0.5, display.contentCenterY*1.05, font, 25)
    sceneGroup:insert(selectWeaponText)

    famasIMG = rectCreator.createRectImage(sceneGroup, carpeta_recursos .. "Famas.png", 223*0.4, 606*0.4, centerX*0.4, centerY*1.45)
    famasIMG.rotation = famasIMG.rotation - 40
    table.insert(weapons, famasIMG)

    scarIMG = rectCreator.createRectImage(sceneGroup, carpeta_recursos .. "SCAR.png", 326*0.31, 980*0.31, centerX, centerY * 1.36)
    scarIMG.rotation = scarIMG.rotation - 40
    table.insert(weapons, scarIMG)

    sniperIMG = rectCreator.createRectImage(sceneGroup, carpeta_recursos .. "Sniper.png", 373*0.22, 1805*0.22, centerX*1.6, centerY * 1.36)
    sniperIMG.rotation = sniperIMG.rotation - 40
    table.insert(weapons, sniperIMG)

    -- PLAY
    playBTN = rectCreator.createRectImage(sceneGroup, carpeta_recursos .. "play.png", CW * 0.08, CH * 0.09, centerX*1.8, centerY*0.9)

    -- ARMA POR DEFECTO
    seleccionarArma(famasIMG, 1)
    -- Code here runs when the scene is first created but has not yet appeared on screen
 
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen

        targetIncrementBTN:addEventListener("tap", incrementarTargets)
        targetDecrementBTN:addEventListener("tap", decrementarTargets)
        precisionIncrementBTN:addEventListener("tap", incrementarPrecision)
        precisionDecrementBTN:addEventListener("tap", decrementarPrecision)

        for index, weapon in ipairs(weapons) do
            weapon:addEventListener("tap", function() seleccionarArma(weapon, index) end)
        end
        
        playBTN:addEventListener("tap", ir_cinematica)
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