local composer = require( "composer" )
local rectCreator = require( "Utilities.rectangles" )
local scene = composer.newScene()

local barrasInfo
local barras
local totalDisparos
local totalFalladas

local returnBTN
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
local function crearBarras(sceneGroup)

    local espacio = (CW - CW*0.05*2) / 5
    local posX = CW*0.05
    for i = 1, 6 do
        local info = barrasInfo[i]
        local myRect = display.newRect(sceneGroup, posX, display.contentCenterY, CW*0.05, info[1]/totalDisparos * display.contentCenterX*0.3)
        local primerChar = string.sub(info[2], 1, 1)
        if (primerChar ~= 'F') then
            myRect:setFillColor(14/255, 201/255, 17/255)
        else
            myRect:setFillColor(232/255, 30/255, 47/255)
        end
        myRect.anchorY = 1
        local label = display.newText(info[2], posX, display.contentCenterY*1.3, font, 15)
        sceneGroup:insert(label)
        posX = posX + espacio
    end
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    
    local totalHitsCabeza = event.params.totalHitsCabeza
    local totalTorsoSuperior = event.params.totalTorsoSuperior
    local totalTorsoInferior = event.params.totalTorsoInferior
    local totalExtremidadesInferiores = event.params.totalExtremidadesInferiores
    local totalExtremidadesSuperiores = event.params.totalExtremidadesSuperiores
    totalDisparos = event.params.totalDisparos
    totalFalladas = totalDisparos - totalHitsCabeza - totalTorsoSuperior - totalTorsoInferior - totalExtremidadesInferiores - totalExtremidadesSuperiores

    barrasInfo = {
        {totalHitsCabeza, "CABEZA: " .. totalHitsCabeza},
        {totalTorsoSuperior, "TORSO\n SUPERIOR: " .. totalTorsoSuperior},
        {totalTorsoInferior, "TORSO\n INFERIOR: " .. totalTorsoInferior},
        {totalExtremidadesSuperiores, "EXTREMIDADES\n SUPERIORES: " .. totalExtremidadesSuperiores},
        {totalExtremidadesInferiores, "EXTREMIDADES\n INFERIORES: " .. totalExtremidadesInferiores},
        {totalFalladas, "FALLOS: " .. totalFalladas}
    }

    crearBarras(sceneGroup) 
    local titles = display.newText("RESULTADOS", display.contentCenterX, display.contentCenterY *0.35, font, 50)   
    sceneGroup:insert(titles)

end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        local efec = math.round((totalDisparos - totalFalladas)/totalFalladas * 1000) / 1000
        local titles = display.newText("EFECTIVIDAD PARA " .. totalDisparos .. " DISPAROS: \n" .. efec .. "%", display.contentCenterX, display.contentCenterY *1.7, font, 40)
        sceneGroup:insert(titles)
        transition.from(titles, {time = 1500, x = -display.contentWidth, transition = easing.outExpo})
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