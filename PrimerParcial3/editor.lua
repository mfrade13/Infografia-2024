CW = display.contentWidth
CH = display.contentHeight
anchoPixel = CW / 21
altoPixel = CH / 12
unidadPixel = anchoPixel / 4
colorOscuro = {0.26274509803921568627450980392157, 0.32156862745098039215686274509804, 0.23921568627450980392156862745098}
colorClaro = {0.78039215686274509803921568627451, 0.94117647058823529411764705882353, 0.84705882352941176470588235294118}
puntosNivel = 0

local posicionX, posicionY, posArriba, posAbajo, posIzquierda, posDerecha
local bloqueArriba, bloqueAbajo, bloqueIzquierda, bloqueDerecha, bloqueActual
local teclasPresionadas = {}
local bloquesAgua = {}

local step = audio.loadSound('step.wav')
local win = audio.loadSound('win.wav')
local lose = audio.loadSound('lose.wav')
local key = audio.loadSound('key.wav')
local door = audio.loadSound('door.wav')

--[[
nivel =  
   {"wwwwwwwwwwwwwwwwwwwww",
    "wwwwwwwwwwwwwwwwwwwww",
    "wwwwwwwwwwwwwwwwwwwww",
    "wwwwwwwwwwwwwwwwwwwww",
    "wwwwwwwwwwwwwwwwwwwww",
    "wwwwwwwwwwwwwwwwwwwww",
    "wwwwwwwwwwwwwwwwwwwww",
    "wwwwwwwwwwwwwwwwwwwww",
    "wwwwwwwwwwwwwwwwwwwww",
    "wwwwwwwwwwwwwwwwwwwww",
    "wwwwwwwwwwwwwwwwwwwww",
    "wwwwwwwwwwwwwwwwwwwww"}
]]

function copiarNivel()
    nivelCopia = {}
    for k,v in pairs(nivel) do
        nivelCopia[k] = v
    end
end

local function dibujarPared(x, y)
    local pared = display.newRect( anchoPixel*(x-1), altoPixel*(y-1), anchoPixel, altoPixel )
    pared.anchorX = 0; pared.anchorY = 0
    pared:setFillColor( unpack(colorOscuro) )

    local brillo = display.newRect( anchoPixel*(x-1)+unidadPixel, altoPixel*(y-1)+unidadPixel, 2*unidadPixel, 2*unidadPixel )
    brillo.anchorX = 0; brillo.anchorY = 0
    brillo:setFillColor(unpack(colorClaro))

    local oscuro = display.newRect( anchoPixel*(x-1)+2*unidadPixel, altoPixel*(y-1)+2*unidadPixel, unidadPixel, unidadPixel )
    oscuro.anchorX = 0; oscuro.anchorY = 0
    oscuro:setFillColor(unpack(colorOscuro))

    sceneGroup:insert(pared)
    sceneGroup:insert(brillo)
    sceneGroup:insert(oscuro)
end

local function dibujarMeta(x, y)
    for i=0,3 do
        for j=0,3 do
            if((i+j) % 2 == 0) then
                local pixel = display.newRect(anchoPixel*(x-1) + unidadPixel*j, altoPixel*(y-1)+unidadPixel*i, unidadPixel, unidadPixel)
                pixel.anchorX = 0; pixel.anchorY = 0
                pixel:setFillColor( unpack(colorOscuro) )
                sceneGroup:insert(pixel)
            end
        end
    end
end

local function dibujarBloqueDoble(x, y)
    local bloque1 = display.newRect(anchoPixel*(x-1), altoPixel*(y-1), unidadPixel, 2*unidadPixel)
    local bloque2 = display.newRect(anchoPixel*(x-1) + 2*unidadPixel, altoPixel*(y-1), 2*unidadPixel, unidadPixel)
    local bloque3 = display.newRect(anchoPixel*(x-1), altoPixel*(y-1) + 3*unidadPixel, 2*unidadPixel, unidadPixel)
    local bloque4 = display.newRect(anchoPixel*(x-1)+3*unidadPixel, altoPixel*(y-1) + 2*unidadPixel, unidadPixel, 2*unidadPixel)

    bloque1.anchorX = 0; bloque1.anchorY = 0
    bloque2.anchorX = 0; bloque2.anchorY = 0
    bloque3.anchorX = 0; bloque3.anchorY = 0
    bloque4.anchorX = 0; bloque4.anchorY = 0

    bloque1:setFillColor( unpack( colorOscuro ) )
    bloque2:setFillColor( unpack( colorOscuro ) )
    bloque3:setFillColor( unpack( colorOscuro ) )
    bloque4:setFillColor( unpack( colorOscuro ) )

    sceneGroup:insert( bloque1 )
    sceneGroup:insert( bloque2 )
    sceneGroup:insert( bloque3 )
    sceneGroup:insert( bloque4 )
end

local function dibujarLlave(x,y)
    local bloque1 = display.newRect(sceneGroup, anchoPixel*(x-1), altoPixel*(y-1), unidadPixel, unidadPixel)
    local bloque2 = display.newRect(sceneGroup, anchoPixel*(x-1)+unidadPixel, altoPixel*(y-1)+unidadPixel, unidadPixel, unidadPixel)
    local bloque3 = display.newRect(sceneGroup, anchoPixel*(x-1)+2*unidadPixel, altoPixel*(y-1)+2*unidadPixel, 2*unidadPixel, 2*unidadPixel)

    bloque1.anchorX = 0; bloque1.anchorY = 0
    bloque2.anchorX = 0; bloque2.anchorY = 0
    bloque3.anchorX = 0; bloque3.anchorY = 0

    bloque1:setFillColor( unpack( colorOscuro ) )
    bloque2:setFillColor( unpack( colorOscuro ) )
    bloque3:setFillColor( unpack( colorOscuro ) )

    sceneGroup:insert( bloque1 )
    sceneGroup:insert( bloque2 )
    sceneGroup:insert( bloque3 )
end

local function dibujarPuerta(x, y)
    local bloque1 = display.newRect(sceneGroup, anchoPixel*(x-1), altoPixel*(y-1), anchoPixel, altoPixel)
    local bloque2 = display.newRect(sceneGroup, anchoPixel*(x-1) + 2*unidadPixel, altoPixel*(y-1)+unidadPixel, unidadPixel, 2*unidadPixel)

    bloque1.anchorX = 0; bloque1.anchorY = 0
    bloque2.anchorX = 0; bloque2.anchorY = 0

    bloque1:setFillColor( unpack(colorOscuro) )
    bloque2:setFillColor( unpack(colorClaro) )
end

local function eliminarBloque(x, y)
    nivelCopia[y] = string.sub(nivelCopia[y], 1, x-1) .. 'a' .. string.sub(nivelCopia[y], x+1)
    local agua = display.newRect( anchoPixel*(x-1), altoPixel*(y-1), anchoPixel, altoPixel )
    agua.anchorX = 0; agua.anchorY = 0
    agua:setFillColor( unpack( colorOscuro ) )

    table.insert(bloquesAgua, agua)
    sceneGroup:insert(agua)
end

local function eliminarBloqueEspecial(x, y)
    local piso = display.newRect( anchoPixel*(x-1), altoPixel*(y-1), anchoPixel, altoPixel )
    piso.anchorX = 0; piso.anchorY = 0
    piso:setFillColor( unpack( colorClaro ) )

    sceneGroup:insert(piso)
    jugadorSprite:toFront( )
end

local function renombrarBloqueEspecial(x, y)
    nivelCopia[y] = string.sub(nivelCopia[y], 1, x-1) .. 'w' .. string.sub(nivelCopia[y], x+1)
end

local function actualizarAlrededores()

    bloqueArriba = string.sub(nivelCopia[posArriba], posicionX, posicionX)
    bloqueAbajo = string.sub(nivelCopia[posAbajo], posicionX, posicionX)
    bloqueIzquierda = string.sub(nivelCopia[posicionY], posIzquierda, posIzquierda)
    bloqueDerecha = string.sub(nivelCopia[posicionY], posDerecha, posDerecha)
    bloqueActual = string.sub( nivelCopia[posicionY], posicionX, posicionX )
end

local function mover(x, y)

    if (bloqueActual ~= 'x') then
        eliminarBloque(posicionX, posicionY)
    else
        renombrarBloqueEspecial(posicionX,posicionY)
    end
    puntosNivel = puntosNivel + 1

    jugadorSprite.x = jugadorSprite.x + anchoPixel * x
    jugadorSprite.y = jugadorSprite.y + altoPixel * y
    posicionX = posicionX + x
    posicionY = posicionY + y
    posArriba = posArriba + y
    posAbajo = posAbajo + y
    posIzquierda = posIzquierda + x
    posDerecha = posDerecha + x

    

    actualizarAlrededores()


    if (bloqueActual == 'a') then
        print('Game Over')
        audio.play(lose)
        jugadorSprite:toFront( )
        jugadorSprite:setFillColor(unpack(colorClaro))
        Runtime:removeEventListener( "key", onKeyEvent )
        timer.performWithDelay( 500, reiniciar )

    elseif (bloqueActual == 'm') then
        print('Nivel completado!')
        audio.play(win)
        Runtime:removeEventListener( "key", onKeyEvent )
        timer.performWithDelay( 500, siguiente )

    elseif (bloqueActual == 'x') then
        eliminarBloqueEspecial(posicionX, posicionY)
        audio.play(step)

    elseif (bloqueActual == 'l') then
        eliminarBloqueEspecial(posicionX, posicionY)
        audio.play(key)
        traeLlave = true

    elseif (bloqueActual == 'w') then
        audio.play(step)
    end

    if (traeLlave) then
        if (bloqueArriba == 'p') then eliminarBloqueEspecial(posicionX, posicionY-1); renombrarBloqueEspecial(posicionX, posicionY-1); audio.play( door )
        elseif (bloqueAbajo == 'p') then eliminarBloqueEspecial(posicionX, posicionY+1); renombrarBloqueEspecial(posicionX, posicionY+1); audio.play( door )
        elseif (bloqueIzquierda == 'p') then eliminarBloqueEspecial(posicionX-1, posicionY); renombrarBloqueEspecial(posicionX-1, posicionY); audio.play( door )
        elseif (bloqueDerecha == 'p') then eliminarBloqueEspecial(posicionX+1, posicionY); renombrarBloqueEspecial(posicionX+1, posicionY); audio.play( door )
        end
    end
end

function onKeyEvent( event )
 
    if(event.phase == "down") then
        
        actualizarAlrededores()

        if(event.keyName == 'up' and bloqueArriba ~= 'b' and bloqueArriba ~= 'p') then
            mover(0, -1)
        elseif (event.keyName == 'down' and bloqueAbajo ~= 'b' and bloqueAbajo ~= 'p') then
            mover(0, 1)
        elseif (event.keyName == 'left' and bloqueIzquierda ~= 'b' and bloqueIzquierda ~= 'p') then
            mover(-1, 0)
        elseif (event.keyName == 'right' and bloqueDerecha ~= 'b'  and bloqueDerecha ~= 'p') then
            mover(1, 0)
        end
    end
end

function reiniciar(event)

    for i=1,#bloquesAgua do
        sceneGroup:remove(bloquesAgua[i])
        --display.remove(bloquesAgua[i])
    end

    Runtime:removeEventListener( "key", onKeyEvent )
    puntosNivel = 0
    bloquesAgua = {}
    construirNivel()
end

function siguiente(event)
    if puntos == nil then
        puntos = 0
    end
    puntos = puntos + puntosNivel
    puntosNivel = 0
    print('puntos', puntos)
    Runtime:removeEventListener( "key", onKeyEvent )
    cmp.removeScene(nivelActual)
    cmp.gotoScene(siguienteNivel)
end

function construirNivel()

    copiarNivel()
    print(nivel)
    for i=1,12 do

        print(nivel[i])
        for j=1,21 do

            local bloque = string.sub(nivel[i],j,j)

            if(bloque == 'b') then
                dibujarPared(j, i)

            elseif(bloque == 'm') then
                dibujarMeta(j, i)

            elseif(bloque == 'x') then
                dibujarBloqueDoble(j, i)

            elseif (bloque == 'l') then
                dibujarLlave(j, i)

            elseif(bloque == 'p') then
                dibujarPuerta(j, i)

            elseif(bloque == 's') then
                posicionX = j
                posicionY = i
                posArriba = i-1
                posAbajo = i+1
                posIzquierda = j-1
                posDerecha = j+1

                if jugadorSprite then
                    jugadorSprite:setFillColor( unpack(colorOscuro) )
                    jugadorSprite.x = anchoPixel*(j-1)+unidadPixel
                    jugadorSprite.y = altoPixel*(i-1)+unidadPixel

                else
                    jugadorSprite = display.newRect(anchoPixel*(j-1)+unidadPixel, altoPixel*(i-1)+unidadPixel, anchoPixel-2*unidadPixel, altoPixel-2*unidadPixel)
                    jugadorSprite:setFillColor( unpack(colorOscuro) )
                    jugadorSprite.anchorX = 0; jugadorSprite.anchorY = 0
                    sceneGroup:insert(jugadorSprite)

                end

            end

        end

    end

    Runtime:addEventListener( "key", onKeyEvent )
    print(posicionX, posicionY)

end

