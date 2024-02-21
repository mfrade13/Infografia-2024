local composer = require( "composer" )
local colTool = require( "Utilities.colistions" )
local scene = composer.newScene()
local buttonsGroup, targetsGroup, shotsGroup
local centerX = display.contentCenterX
local centerY = display.contentCenterY

-- Parametros
local targets
local precision
local weaponSelection
-- Circulos
local cabeza = {}
local hombroIzquierdo = {}
local hombroDerecho = {}
local caderaIzquierda = {}
local caderaDerecha = {}
-- Rectangulos
local brazoIzquierdo = {}
local brazoDerecho = {}
local pecho = {}
local piernaIzquierda = {}
local piernaDerecha = {}
-- Triangulos
local pieIzquierdo = {}
local pieDerecho = {}
-- Adicional
local resultsBTN
local shots = {}
local valoresAleatorios
local countHitsTerminado = false
local fondo
-- Resultados
local totalHitsCabeza = 0
local totalHitsTorsoSuperior = 0
local totalHitsTorsoInferior = 0
local totalHitsExtremidadesInferiores = 0
local totalHitsExtremidadesSuperiores = 0
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local function createCircle(radio, sceneGroup, posXF1, posYF1, posXF2, posYF2, jump, tableInsert)

    for i = 1, 3 do
        if valoresAleatorios[i] ~= nil then
            -- Create Circle
            local myCircle = display.newCircle(sceneGroup, posXF1, posYF1, radio)
            myCircle:setFillColor(1, 1, 1)
            myCircle.anchorX = 0
            myCircle.anchorY = 0

            table.insert(tableInsert, myCircle)
            posXF1 = posXF1 + jump
        end
    end

    for i = 4, 6 do
        if valoresAleatorios[i] ~= nil then
            -- Create Circle
            local myCircle = display.newCircle(sceneGroup, posXF2, posYF2, radio)
            myCircle:setFillColor(1, 1, 1)
            myCircle.anchorX = 0
            myCircle.anchorY = 0

            table.insert(tableInsert, myCircle)
            posXF2 = posXF2 + jump
        end
    end
end

local function createRect(width, length, sceneGroup, posXF1, posYF1, posXF2, posYF2, jump, tableInsert)

    for i = 1, 3 do
        if valoresAleatorios[i] ~= nil then
            -- Create Circle
            local myRect = display.newRect(sceneGroup, posXF1, posYF1, width, length)
            myRect:setFillColor(1, 1, 1)
            myRect.anchorX = 0
            myRect.anchorY = 0

            table.insert(tableInsert, myRect)
            posXF1 = posXF1 + jump
        end
    end

    for i = 4, 6 do
        if valoresAleatorios[i] ~= nil then
            -- Create Circle
            local myRect = display.newRect(sceneGroup, posXF2, posYF2, width, length)
            myRect:setFillColor(1, 1, 1)
            myRect.anchorX = 0
            myRect.anchorY = 0

            table.insert(tableInsert, myRect)
            posXF2 = posXF2 + jump
        end
    end
end

local function createFaces (sceneGroup)

    -- SUPERIOR 
    local posXF1 = centerX * 0.2
    local posYF1 = centerY * 0.3
    local jump = CW/2 - centerX * 0.3

   -- INFERIOR
    local posXF2 = centerX * 0.2
    local posYF2 = centerY * 1.2

    createCircle(centerX*0.05, sceneGroup, posXF1, posYF1, posXF2, posYF2, jump, cabeza)

end

local function createTorsos (sceneGroup)

    local circleRadios = centerX * 0.05 * 2

    -- SUPERIOR 
    local posXF1 = centerX * 0.2
    local posYF1 = centerY * 0.3 + circleRadios
    local jump = CW/2 - centerX * 0.3
    -- INFERIOR
    local posXF2 = centerX * 0.2
    local posYF2 = centerY * 1.2 + circleRadios

    createRect(centerX*0.1, centerX*0.2, sceneGroup, posXF1, posYF1, posXF2, posYF2, jump, pecho)
end

local function createShoulders (sceneGroup)

    local torsoWidth = centerX*0.1
    local circleRadios = centerX * 0.05 * 2
    -- Izquierdo 
    -- Superior
    local posXF1 = centerX * 0.2 - centerX*0.025*2
    local posYF1 = centerY * 0.3 + circleRadios
    local jump = CW/2 - centerX * 0.3
    -- Inferior
    local posXF2 = centerX * 0.2 - centerX*0.025*2
    local posYF2 = centerY * 1.2 + circleRadios

    createCircle(centerX*0.025, sceneGroup, posXF1, posYF1, posXF2, posYF2, jump, hombroIzquierdo)

    -- Derecho
    -- Superior
    posXF1 = centerX * 0.2 + centerX* 0.025*4
    posYF1 = centerY * 0.3 + circleRadios
    jump = CW/2 - centerX * 0.3
    -- Inferior
    posXF2 = centerX * 0.2 + centerX * 0.025*4
    posYF2 = centerY * 1.2 + circleRadios

    createCircle(centerX*0.025, sceneGroup, posXF1, posYF1, posXF2, posYF2, jump, hombroDerecho)

end

local function createArms (sceneGroup)

    local circleRadios = centerX * 0.05 * 2
    local circleRadiosShoulders = centerX*0.025 * 2

    -- DERECHO 
    -- SUPERIOR 
    local posXF1 = centerX * 0.2 - centerX*0.025*2
    local posYF1 = centerY * 0.3 + circleRadios + circleRadiosShoulders
    local jump = CW/2 - centerX * 0.3
    -- INFERIOR
    local posXF2 = centerX * 0.2 - centerX*0.025*2
    local posYF2 = centerY * 1.2 + circleRadios + circleRadiosShoulders
    
    createRect(centerX*0.035, centerX*0.14, sceneGroup, posXF1, posYF1, posXF2, posYF2, jump, brazoIzquierdo)

    -- IZQUIERDO
    -- SUPERIOR 
    posXF1 = centerX * 0.2 + centerX*0.025*4.4
    posYF1 = centerY * 0.3 + circleRadios + circleRadiosShoulders
    -- INFERIOR
    posXF2 = centerX * 0.2 + centerX*0.025*4.4
    posYF2 = centerY * 1.2 + circleRadios + circleRadiosShoulders
   
    createRect(centerX*0.035, centerX*0.14, sceneGroup, posXF1, posYF1, posXF2, posYF2, jump, brazoDerecho)

end

local function createHips (sceneGroup)

    local circleRadios = centerX * 0.05 * 2
    local lengthTorso = centerX*0.2

    -- IZQUIERDA
    -- SUPERIOR 
    local posXF1 = centerX * 0.2
    local posYF1 = centerY * 0.3 + circleRadios + lengthTorso
    local jump = CW/2 - centerX * 0.3
    -- INFERIOR
    local posXF2 = centerX * 0.2
    local posYF2 = centerY * 1.2 + circleRadios + lengthTorso

    createCircle(centerX*0.025, sceneGroup, posXF1, posYF1, posXF2, posYF2, jump, caderaIzquierda)

    -- DERECHA
    -- SUPERIOR 
    posXF1 = centerX * 0.2 + centerX*0.025 * 2
    posYF1 = centerY * 0.3 + circleRadios + lengthTorso
    jump = CW/2 - centerX * 0.3
    -- INFERIOR
    posXF2 = centerX * 0.2 + centerX*0.025 * 2
    posYF2 = centerY * 1.2 + circleRadios + lengthTorso

    createCircle(centerX*0.025, sceneGroup, posXF1, posYF1, posXF2, posYF2, jump, caderaDerecha)

end

local function createLegs (sceneGroup)

    local circleRadios = centerX * 0.05 * 2
    local circleHips = centerX*0.025 * 2
    local lengthTorso = centerX*0.2

    -- IZQUIERDA
    -- SUPERIOR 
    local posXF1 = centerX * 0.2
    local posYF1 = centerY * 0.3 + circleRadios + lengthTorso + circleHips
    local jump = CW/2 - centerX * 0.3
    -- INFERIOR
    local posXF2 = centerX * 0.2
    local posYF2 = centerY * 1.2 + circleRadios + lengthTorso + circleHips

    createRect(centerX*0.035, centerX*0.14, sceneGroup, posXF1, posYF1, posXF2, posYF2, jump, piernaIzquierda)

    -- DERECHA
    -- SUPERIOR 
    posXF1 = centerX * 0.2 + centerX*0.025 * 2.44
    posYF1 = centerY * 0.3 + circleRadios + lengthTorso + circleHips
    jump = CW/2 - centerX * 0.3
    -- INFERIOR
    posXF2 = centerX * 0.2 + centerX*0.025 * 2.44
    posYF2 = centerY * 1.2 + circleRadios + lengthTorso + circleHips

    createRect(centerX*0.035, centerX*0.14, sceneGroup, posXF1, posYF1, posXF2, posYF2, jump, piernaDerecha)

end


local function createFoot(triangleVertices, recDistance, posXF1, posYF1, posXF2, posYF2, jump, tableInsert, sceneGroup)

    for i = 1, 3 do
        if valoresAleatorios[i] ~= nil then
            local myTriangle = display.newPolygon(sceneGroup, posXF1, posYF1, triangleVertices)
            myTriangle:setFillColor(1, 1, 1)
            posXF1 = posXF1 + jump
            table.insert(tableInsert, {myTriangle, {triangleVertices[1] + posXF1 - recDistance, triangleVertices[2] + posYF1- recDistance/2} , {triangleVertices[3] + posXF1 - recDistance, triangleVertices[4] + posYF1 - recDistance/2} , {triangleVertices[5] + posXF1 - recDistance, triangleVertices[6] + posYF1 - recDistance/2} })
        end
    end

    for i = 4, 6 do
        if valoresAleatorios[i] ~= nil then
            local myTriangle = display.newPolygon(sceneGroup, posXF2, posYF2, triangleVertices)
            myTriangle:setFillColor(1, 1, 1)
            posXF2 = posXF2 + jump
            table.insert(tableInsert, {myTriangle, {triangleVertices[1] + posXF2 - recDistance, triangleVertices[2] + posYF2- recDistance/2} , {triangleVertices[3] + posXF2 - recDistance, triangleVertices[4] + posYF2 - recDistance/2} , {triangleVertices[5] + posXF2 - recDistance, triangleVertices[6] + posYF2 - recDistance/2}})
        end
    end
end

local function createFeet (sceneGroup)
    -- Size Triangle
    local recDistance = centerX * 0.025
    local triangleVertices = {recDistance, 0, recDistance * 2, recDistance, 0, recDistance}
    
    local circleRadios = centerX * 0.05 * 2
    local circleHips = centerX * 0.025 * 2
    local lengthTorso = centerX * 0.2
    local lengthLegs = centerX * 0.14
    local widthLegs = centerX * 0.035

    -- IZQUIERDA
    -- SUPERIOR 
    local posXF1 = centerX * 0.2
    local posYF1 = centerY * 0.3 + circleRadios + lengthTorso + circleHips + lengthLegs + centerX*0.025
    local jump = CW/2 - centerX * 0.3
    -- INFERIOR
    local posXF2 = centerX * 0.2
    local posYF2 = centerY * 1.2 + circleRadios + lengthTorso + circleHips + lengthLegs + centerX*0.025
    
    createFoot(triangleVertices, recDistance, posXF1, posYF1, posXF2, posYF2, jump, pieIzquierdo, sceneGroup)

    -- DERECHA

    -- SUPERIOR 
    posXF1 = centerX * 0.2 + 2*centerX*0.035
    posYF1 = centerY * 0.3 + circleRadios + lengthTorso + circleHips + lengthLegs + centerX*0.025
    jump = CW/2 - centerX * 0.3
    -- INFERIOR
    posXF2 = centerX * 0.2 + 2*centerX*0.035
    posYF2 = centerY * 1.2 + circleRadios + lengthTorso + circleHips + lengthLegs + centerX*0.025

    createFoot(triangleVertices, recDistance, posXF1, posYF1, posXF2, posYF2, jump, pieDerecho, sceneGroup)

end

local function createRandomCircle(sceneGroup)
    local circle = display.newCircle(
        sceneGroup,
        math.random(CW), 
        math.random(CH),
        centerX*0.005
    )
    circle:setFillColor(0,0,0)
    
    return circle
end

local function checkTriangleHits(x, y, table)
    for i, c in ipairs(table) do
        if (colTool.pointInTriangle(c[2],c[3],c[4],{x,y})) then
            return true
        end
    end
    return false
end

local function checkCircleHits(x, y, table, radius)
    for i, c in ipairs(table) do
        local vs = colTool.getCircleValues(c, radius)
        if (colTool.inCircunference(x, y, vs[1], vs[2], radius)) then
            return true
        end
    end
    return false
end

local function checkRectHits(x, y, table)
    for i, r in ipairs(table) do
        local vs = colTool.getRectVertices(r)
        if (colTool.pointInPolygon(x,y,vs)) then
            return true
        end
    end
    return false
end

local function countHits ()
    for i, shot in ipairs(shots) do
        local centroX = shot.x
        local centroY = shot.y

        -- Check Hits Cabeza
        if (checkCircleHits(centroX, centroY, cabeza, centerX*0.05)) then
            shot:setFillColor(0,1,0)

            totalHitsCabeza = totalHitsCabeza + 1
        end

        -- Check Hits Torso Superior
        if (checkRectHits(centroX, centroY, pecho)) then
            shot:setFillColor(0,1,0)

            totalHitsTorsoSuperior = totalHitsTorsoSuperior + 1
        end

        -- Check Hits Torso Inferior
        if (checkCircleHits(centroX, centroY, caderaIzquierda, centerX*0.025) or checkCircleHits(centroX, centroY, caderaDerecha, centerX*0.025)) then
            shot:setFillColor(0,1,0)

            totalHitsTorsoInferior = totalHitsTorsoInferior + 1
        end

        -- Check Extremidades Superiores
        if (checkRectHits(centroX, centroY, brazoDerecho) or checkRectHits(centroX, centroY, brazoIzquierdo) or checkCircleHits(centroX, centroY, hombroIzquierdo, centerX*0.025) or checkCircleHits(centroX, centroY, hombroDerecho, centerX*0.025)) then
            shot:setFillColor(0,1,0)

            totalHitsExtremidadesSuperiores = totalHitsExtremidadesSuperiores + 1
        end

        -- Check Extremidades Inferiores
        if (checkRectHits(centroX, centroY, piernaIzquierda) or checkRectHits(centroX, centroY, piernaDerecha) or checkTriangleHits(centroX, centroY, pieIzquierdo) or checkTriangleHits(centroX, centroY, pieDerecho)) then
            shot:setFillColor(0,1,0)

            totalHitsExtremidadesInferiores = totalHitsExtremidadesInferiores + 1
        end

    end
    countHitsTerminado = true
end

local function mostrarResultados()
    if (countHitsTerminado) then
        local opciones = {
            effect = "slideLeft",
            time = 500,
            params = {
                totalHitsCabeza = totalHitsCabeza,
                totalTorsoSuperior = totalHitsTorsoSuperior,
                totalTorsoInferior = totalHitsTorsoInferior,
                totalExtremidadesInferiores = totalHitsExtremidadesInferiores,
                totalExtremidadesSuperiores = totalHitsExtremidadesSuperiores,
                totalDisparos = precision
            }
        }
        composer.gotoScene("results", opciones)
    end
end

local function obtenerValoresAleatorios(n)
    local valores = {}  -- Tabla para almacenar los valores
    local disponibles = {1, 2, 3, 4, 5, 6}  -- Valores disponibles

    for i = 1, n do
        local indice = math.random(#disponibles)  -- Obtener un índice aleatorio
        local valor = table.remove(disponibles, indice)  -- Quitar y obtener el valor
        valores[valor] = true  -- Agregar el valor a la tabla de resultados
    end

    return valores
end

local function insertCircleWithDelay(index)
    local circle = createRandomCircle(shotsGroup)
    table.insert(shots, circle)  -- Inserta el círculo en la tabla 'shots'
    
    if index < precision then
        timer.performWithDelay(100*weaponSelection, function() insertCircleWithDelay(index + 1) end)
    else
        countHits()  -- Llamar a countHits después de insertar todos los círculos
    end
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view

    fondo = display.newRect( 0, 0, CW, CH )
    fondo.anchorX = 0; fondo.anchorY = 0
    fondo:setFillColor( 0.44 )
    sceneGroup:insert(fondo)

    targetsGroup = display.newGroup()
    sceneGroup:insert(targetsGroup)
    shotsGroup = display.newGroup()
    sceneGroup:insert(shotsGroup)
    buttonsGroup = display.newGroup()
    sceneGroup:insert(buttonsGroup)
    -- Code here runs when the scene is first created but has not yet appeared on screen
    

    targets = event.params.targets
    valoresAleatorios = obtenerValoresAleatorios(targets)
    precision = event.params.precision
    weaponSelection = event.params.weaponSelection

    createFaces(targetsGroup)
    createTorsos(targetsGroup)
    createShoulders(targetsGroup)
    createArms(targetsGroup)
    createHips(targetsGroup)
    createLegs(targetsGroup)
    createFeet(targetsGroup)

           
    resultsBTN = display.newImageRect(buttonsGroup, carpeta_recursos .. "play.png", CW * 0.08, CH * 0.09)
    resultsBTN.x = display.contentCenterX * 1.8
    resultsBTN.y = display.contentCenterY
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then

               
        insertCircleWithDelay(1)

        countHits()

        resultsBTN:addEventListener("tap", mostrarResultados)
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