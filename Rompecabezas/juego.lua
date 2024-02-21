local composer = require( "composer" )
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
 
 local fondo
 local puntaje
 local clock
 local valor_movimientos = 0
 local grupoFondo, grupoInterfaz
 local destino_R
 local rompecabezas_I = {}
 local posicionesX = {}
 local posicionesY = {}
 local tiempo_R = 0
 local tiempo_Aux = 0
 local lista_Ordenada = {{0, 0}, {0, 1}, {0, 2}, 
                        {1, 0}, {1, 1}, {1, 2},
                        {2, 0}, {2, 1}}
 local lista = {}
local vacio = {x = 0, y = 0}
local size_Bloque
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
function round(numero)
    if numero == nil then
        print ("numero nulo")
    else
        return math.floor(numero + 0.5)
    end
end

function distancia(image)
    if (round(image.x - size_Bloque) == round(vacio.x)) or ( round((image.x + size_Bloque)) == round(vacio.x)) then
        return true
    elseif (round((image.y - size_Bloque)) == round(vacio.y)) or (round((image.y + size_Bloque)) == round(vacio.y)) then
        
        return true
    else
        print ((image.x - size_Bloque), vacio.x)
        print ((image.x + size_Bloque), vacio.x)
        print ((image.y - size_Bloque), vacio.y)
        print ((image.y + size_Bloque), vacio.y)
        return false
    end
end

function ejeIgual(image)
    if ((image.x == vacio.x) or (image.y == vacio.y)) then
        return true
    else
        return false
    end

end

function decreaseCounter()
    tiempo_R = tiempo_R - 1
    clock.text = "TIME:" .. tiempo_R
    if tiempo_R == 0 then
        print("You lost")
        goBoard(0)    
    end
end 

function getDifficulty(num)
    if num == 1 then
        return "resources/Easy/"
    elseif num == 2 then
        return  "resources/Medium/"
    else
        return "resources/Hard/"
    end
end
local function shuffleMatrix()
    for i=0,2,1 do
        for j=0,2,1 do
            if (i==2 and j ==2) then
                break
            end
            local primerValor = lista[1]
            local x = primerValor[1]
            local y = primerValor[2]
            transition.to(rompecabezas_I[i][j], {x=posicionesX[x][y] ,y=posicionesY[x][y]})
            rompecabezas_I[i][j].isVisible = true
            print ("Moviendo el rompezabezas: " .. i .. j .. "A la posicion: " .. posicionesX[x][y] .. " " ..posicionesX[x][y])
            table.remove(lista, 1)
        end
    end
end

function move(self, event)
    if event.phase == "ended" then
        print (distancia(self), ejeIgual(self))
        if(distancia(self) and ejeIgual(self)) then
            local aux = {x = self.x, y = self.y} 
            transition.to(self, {x=vacio.x ,y=vacio.y})
            vacio.x = aux.x
            vacio.y = aux.y
            valor_movimientos = valor_movimientos + 1
            puntaje.text = "MOVES: " .. valor_movimientos
            timer.performWithDelay(1000, check)
        else 
            print (distancia(self), ejeIgual(self))
        end
    end
    return true
end

function check()
    for i=0,2,1 do
        for j=0,2,1 do
            if (i==2 and j ==2) then
                break
            end
            if (round(posicionesX[i][j]) ~= round(rompecabezas_I[i][j].x) or round(posicionesY[i][j]) ~= round(rompecabezas_I[i][j].y)) then
                return false
            end 
        end
    end
    print("GANASTE!!")
    rompecabezas_I[2][2].isVisible = true
    timer.performWithDelay(500, function() goBoard(1) end)
    return true
end

-- Generar un rompecabezas hasta obtener uno soluble
function generateSolvablePuzzle()
    local lista_Ordenada = {{0, 0}, {0, 1}, {0, 2}, 
                            {1, 0}, {1, 1}, {1, 2},
                            {2, 0}, {2, 1}}
    
    while true do
        local puzzle = {}
        local indices = {1, 2, 3, 4, 5, 6, 7, 8} 
        
        while #indices > 0 do
            local index = math.random(#indices)
            table.insert(puzzle, lista_Ordenada[indices[index]])
            table.remove(indices, index)
        end
        
        if isSolvable(puzzle) then
            return puzzle
        end
    end
end
function isSolvable(puzzle)
    local inversions = 0
    for i = 1, #puzzle do
        for j = i + 1, #puzzle do
            local xi, yi = puzzle[i][1], puzzle[i][2]
            local xj, yj = puzzle[j][1], puzzle[j][2]
            if xi > xj or (xi == xj and yi > yj) then
                inversions = inversions + 1
            end
        end
    end
    return inversions % 2 == 0
end

function crearRompecabezas()
    local size_T = CW-50
    size_Bloque = size_T/3
    local inicio_x = CW/2-size_Bloque
    local inicio_y = CH/2-size_Bloque
    for i=0,2,1 do
        rompecabezas_I[i] = {}
        posicionesX[i]   = {}
        posicionesY[i]   = {}
        for j=0,2,1 do
            local imageName = destino_R .. i .. j .. ".jpg"
            
            rompecabezas_I[i][j] = display.newImageRect(grupoInterfaz,  imageName , size_Bloque, size_Bloque)
            rompecabezas_I[i][j].x = inicio_x + i*size_Bloque
            rompecabezas_I[i][j].y = inicio_y + j*size_Bloque
            rompecabezas_I[i][j].touch = move
            rompecabezas_I[i][j]:addEventListener( "touch", rompecabezas_I[i][j] )
            posicionesX[i][j] = rompecabezas_I[i][j].x 
            posicionesY[i][j] = rompecabezas_I[i][j].y           
            rompecabezas_I[i][j].isVisible = true
            if (i==2 and j ==2) then
                vacio.x = rompecabezas_I[i][j].x
                vacio.y = rompecabezas_I[i][j].y
                rompecabezas_I[i][j].isVisible = false
            end
        end
    end
    
    lista = generateSolvablePuzzle()
    shuffleMatrix()
end
function goBoard(num)
    local options =
        {
            effect = "zoomInOut",
            time = 500,
            params = {
                movimientos = valor_movimientos,
                tiempo = tiempo_Aux - tiempo_R,
                ended = num
            }
        }
        composer.removeScene("juego") 
        composer.gotoScene( "board" , options )
end

-- create()
function scene:create( event )
    destino_R = getDifficulty(event.params.dificultad); print( destino_R)
    
    tiempo_R = event.params.tiempo; print (tiempo_R)
    tiempo_Aux = event.params.tiempo

    local sceneGroup = self.view
    grupoFondo = display.newGroup()
    sceneGroup:insert(grupoFondo)
    grupoInterfaz = display.newGroup()
    sceneGroup:insert( grupoInterfaz)
    
    fondo = display.newImageRect(grupoFondo,  carpeta_recursos .. "fondo de juego.jpg", CH, CH)
    fondo.x = CW/2; fondo.y= CH/2

    crearRompecabezas()

    puntaje = display.newText(grupoInterfaz,"MOVES: "  .. valor_movimientos, 0, CH/20, "Arial Black", 40 )
    puntaje.anchorX = 0; puntaje.y = 130; puntaje.x = 30 

    clock = display.newText(grupoInterfaz,"TIME: "  .. tiempo_R, 0, CH/20, "Arial Black", 40 )
    clock.anchorX = 0; clock.y = 130; clock.x = CW - 300; clock:setFillColor(0,0,0)

    timer.performWithDelay( 1000, decreaseCounter, tiempo_R)
end

-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then

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
    grupoFondo:removeSelf()
    grupoInterfaz:removeSelf()
    tiempo_R = 0
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
    sceneGroup:removeSelf()

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