local composer = require( "composer" )
 
local scene = composer.newScene()

local CW = display.contentWidth
local CH = display.contentHeight

print(CH,CW)

local ancho_pixel = (CW)/5
local alto_pixel = (CH/2)/5

local fondo , texto , operacion_anterior
local texto_calcular = ""
local botones = {}
local color_numeros = {0.282, 0.635, 0.945}
local color_funciones = {0.192, 0.4, 0.533}
local color_operaciones = {0.945, 0.647, 0.208}
local color_igual = {0.145, 0.808, 0.333}
local color_borrar = {0.945, 0.404, 0.416}
local numeros = {
    {3,10,1,1,'0'},
    {2,9,1,1,'1'},
    {3,9,1,1,'2'},
    {4,9,1,1,'3'},
    {2,8,1,1,'4'},
    {3,8,1,1,'5'},
    {4,8,1,1,'6'},
    {2,7,1,1,'7'},
    {3,7,1,1,'8'},
    {4,7,1,1,'9'}
}

local funciones = {
    {1,5,1,1,'('},
    {2,5,1,1,')'},
    {3,5,1,1,'π'},
    {1,6,1,1,'%'},
    {2,6,1,1,'CE'},
    {3,6,1,1,'C'},
    {4,6,1,1,'rnd('},
    {5,6,1,1,'/'},
    {1,7,1,1,'sqrt('},
    {5,7,1,1,'*'},
    {1,8,1,1,'^2'},
    {5,8,1,1,'-'},
    {1,9,1,1,'^('},
    {5,9,1,1,'+'},
    {1,10,1,1,'log10('},
    {2,10,1,1,'(-1)*'},
    {4,10,1,1,'.'},
    {5,10,1,1,'='}
}


function dibujar_numeros( x1,y1,ancho,alto, simbolo,color  ,sceneGroup)
	local contorno = display.newRect((x1-1) *ancho_pixel , (y1-1) *alto_pixel, ancho * (ancho_pixel-5), alto*(alto_pixel-5))
    contorno:addEventListener( "touch", concatenar_numeros)
    botones[contorno] = simbolo
    sceneGroup:insert(contorno)
	
    contorno.anchorX=0; contorno.anchorY=0
    local numero = display.newText({
        text = simbolo,
        x = contorno.x + ancho_pixel/2,
        y = contorno.y + alto_pixel/2,
        fontSize = 25
    })
    sceneGroup:insert(numero)
    numero:setFillColor(1)

	contorno:setFillColor( unpack(color) )
end

function dibujar_operadores(x1,y1,ancho,alto, simbolo,color  ,sceneGroup)
    local contorno = display.newRect((x1-1) *ancho_pixel , (y1-1) *alto_pixel, ancho * (ancho_pixel-5), alto*(alto_pixel-5))
    contorno:setFillColor( unpack(color) )
    if simbolo == '=' then
        contorno:addEventListener("touch",calcular)
        contorno:setFillColor( unpack(color_igual) )
    elseif simbolo == '/' or simbolo == '*' or simbolo == '-' or simbolo == '+' then
        contorno:setFillColor( unpack(color_operaciones) )
        contorno:addEventListener( "touch", concatenar_operacion)
    elseif simbolo == 'CE' or simbolo == 'C' then
        contorno:setFillColor( unpack(color_borrar) )
        contorno:addEventListener( "touch", concatenar_operacion)
    else
        contorno:addEventListener( "touch", concatenar_operacion)
    end
    botones[contorno] = simbolo
    sceneGroup:insert(contorno)
	
    contorno.anchorX=0; contorno.anchorY=0
    local numero = display.newText({
        text = simbolo,
        x = contorno.x + ancho_pixel/2,
        y = contorno.y + alto_pixel/2,
        fontSize = 25
    })
    sceneGroup:insert(numero)
    numero:setFillColor(1)
end

function concatenar_operacion(event)
    if event.phase == "ended" then
        local simbol = botones[event.target]
        if texto.text == nil then

            if simbol == 'sqrt(' then
                texto.text = tostring(simbol)
                texto_calcular = "math.sqrt("
                --print("math.sqrt(")
            elseif simbol == "log10(" then
                texto.text = tostring(simbol)
                texto_calcular = "math.log10("
            elseif simbol == "rnd(" then
                texto.text = tostring(simbol)
                texto_calcular = "math.floor(0.5 + "
            elseif simbol == 'π' then
                texto.text = 'π'
                texto_calcular = "math.pi"
            else
                texto.text = tostring(simbol)
                texto_calcular =  tostring(simbol)
            end
        else
            if simbol == 'CE' then
                texto.text = ""
                operacion_anterior.text = ""
                texto.size = 100
                texto_calcular = ""
            elseif simbol == 'C' then
                print(string.sub(texto.text,-1))
                if(string.sub(texto.text,-1)) == '(' then
                    funcion_antes_parentecis = string.sub(texto.text,-6)
                    --print(funcion_antes_parentecis)
                    if string.find(funcion_antes_parentecis,"sqrt",1,true) then
                        texto.text = string.sub(texto.text,1,-6)
                        texto_calcular = string.sub(texto_calcular,1,-11)
                    elseif string.find(funcion_antes_parentecis,"log10",1,true) then
                        texto.text = string.sub(texto.text,1,-7)
                        texto_calcular = string.sub(texto_calcular,1,-12)
                    elseif string.find(funcion_antes_parentecis,"rnd",1,true) then
                        texto.text = string.sub(texto.text,1,-5)
                        texto_calcular = string.sub(texto_calcular,1,-18)
                    else
                        texto.text = string.sub(texto.text,1,-2)
                        texto_calcular = string.sub(texto_calcular,1,-2)
                    end
                else
                    if (string.sub(texto_calcular,-2)) == 'pi' then
                        print("borrado de pi")
                        texto.text = string.sub(texto.text,1,-3)
                        texto_calcular = string.sub(texto_calcular,1,-8)
                    else
                        texto.text = string.sub(texto.text,1,-2)
                        texto_calcular = string.sub(texto_calcular,1,-2)
                    end
                end
            elseif simbol == 'sqrt(' then
                texto.text = texto.text .. tostring(simbol)
                texto_calcular = texto_calcular .. "math.sqrt("
                --print("math.sqrt(")
            elseif simbol == "log10(" then
                texto.text = texto.text .. tostring(simbol)
                texto_calcular = texto_calcular .. "math.log10("
            elseif simbol == "rnd(" then
                texto.text = texto.text .. tostring(simbol)
                texto_calcular = texto_calcular .. "math.floor(0.5 + "
            elseif simbol == 'π' then
                texto.text =  texto.text .. 'π'
                texto_calcular = texto_calcular .. "math.pi"
            else
                texto.text = texto.text .. tostring(simbol)
                texto_calcular = texto_calcular .. tostring(simbol)
            end
        end
        print(simbol)
        verificar_bordes()
    end
    return true
end

function encontrar(palabras,palabraBuscada)
    local encontrada = false
    for _, palabra in ipairs(palabras) do
        if palabra == palabraBuscada then
            encontrada = true
            break
        end
    end
    return encontrada
end

function verificar_bordes()
    -- Verificamos si el texto se sale de la pantalla por la izquierda
    if texto.x - texto.contentWidth / 2 < 0 then
        texto.size = texto.size - 3
    end

    -- Verificamos si el texto se sale de la pantalla por la derecha
    if texto.x + texto.contentWidth / 2 > CW then
        texto.size = texto.size - 3
    end
end

function concatenar_numeros(event)
    if event.phase == "ended" then
        local simbol = botones[event.target]
        if texto.text == nil then
            texto.text = simbol
            texto_calcular = simbol
        else
            texto.text = texto.text .. tostring(simbol)
            texto_calcular = texto_calcular .. tostring(simbol)
        end
        print(simbol)
        verificar_bordes()
    end
    return true
end

function calcular(event)
    if event.phase == "ended" then
        texto.size = 100
        print(texto.text)
        print(texto_calcular)
        --print(verificarParentesis(texto.text))
        if(verificarParentesis(texto.text)==true) then
            local f = loadstring("return " .. texto_calcular)
            --print(f())
            if pcall(f) then
                operacion_anterior.text = texto.text
                texto.text= f()
                texto_calcular = f()
            else
                texto.text= "syntax error"
                texto_calcular = "syntax error"
            end
        else
            texto.text= "syntax error"
            texto_calcular = "syntax error"
        end
        verificar_bordes()
    end
    return true
end

function verificarParentesis(cadena)
    local contador = 0

    for i = 1, #cadena do
        local caracter = cadena:sub(i, i)
        
        if caracter == '(' then
            contador = contador + 1
        elseif caracter == ')' then
            contador = contador - 1
        end
        if contador < 0 then
            return false
        end
    end
    return contador == 0
end

function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    fondo = display.newRect(CW/2, CH/2, CW,CH)
    fondo:setFillColor( unpack({0.816, 0.898, 0.965}) )

    sceneGroup:insert(fondo)

    for i,v in ipairs( funciones ) do
        dibujar_operadores( v[1],v[2],v[3],v[4],v[5], color_funciones ,sceneGroup)
    end

    for i,v in ipairs( numeros ) do 
        dibujar_numeros( v[1],v[2],v[3],v[4],v[5], color_numeros ,sceneGroup)
    end

    --texto = display.newText(
    --    {
    --        text = "Hola",
    --        x = 3*ancho_pixel,
    --        width = 5*alto_pixel,
    --        font =  native.systemFont,
    --        fontSize = 30
    --    }
    --)
    texto = display.newText("",CW/2,3.2*alto_pixel,"arial",100)
    texto:setFillColor(unpack({0.004, 0.259, 0.404}))
    sceneGroup:insert(texto)

    operacion_anterior= display.newText("",CW/2,1.5*alto_pixel,"arial",50)
    operacion_anterior:setFillColor(unpack({0.353, 0.416, 0.471}))
    sceneGroup:insert(operacion_anterior)
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