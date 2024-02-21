--LIBRERIAS
local composer = require( "composer" )
local widget = require("widget")
local audio = require("audio")
 
local scene = composer.newScene()

--RECURSOS
--local recursosTexto = "Fuentes/"
--local recursosImagenes = "Imagenes/"

--COLORES ORBITAS
local color_blanco = {1,1,1}
local color_amarillo = {1,1,153/255}

--CONTROLADORES PARA LOS BOTONES DE ANIMACION Y COMETA
local animacion = false
local cometaAnimacion = true

--DIMENSIONES GENERALES DE LA PANTALLA DEL DISPOSITIVO
--local CW = display.contentWidth
--local CH = display.contentHeight

--FONDO DE LA ANIMACIÓN
local fondo

--CENTRO DE LA PARTE DE LA ANIMACIÓN
local centroXFondo, centroYFondo

--GRUPO PARA LOS ELEMENTOS DE FONDO
local grupoFondo = display.newGroup()

--GRUPO PARA LA SECCION DE BOTONES
local grupoFondoBotones = display.newGroup()

--GRUPO PARA LA SECCION DE BOTONES
local grupoBotones = display.newGroup()

--GRUPO PARA LOS ASTROS (SOL Y PLANETAS)
local grupoAstros = display.newGroup()

--GRUPO PARA LOS EFECTIS
local grupoEfectos = display.newGroup()

--SECCIÓN DE BOTONES
local fondoBotones

--NOMBRES DE LOS PLANETAS
local nombresPlanetas = {
    {nombre = "mercurio", ancho = 28, alto = 32, varEjeMayor = 0, varEjeMenor = 0, inclinacion = 0},
    {nombre = "venus", ancho = 31, alto = 31, varEjeMayor = 20, varEjeMenor = 0, inclinacion = -50},
    {nombre = "tierra", ancho = 33, alto = 33, varEjeMayor = 0, varEjeMenor = 0, inclinacion = 0, nombreLunas = {"luna"}, anchoLunas = {20}, altoLunas = {18}},
    {nombre = "marte", ancho = 33, alto = 25.5, varEjeMayor = 0, varEjeMenor = 10, inclinacion = 0, nombreLunas = {"deimos"}, anchoLunas = {15}, altoLunas = {15}},
    {nombre = "jupiter", ancho = 50, alto = 47, varEjeMayor = 0, varEjeMenor = 0, inclinacion = 0},
    {nombre = "saturno", ancho = 50, alto = 50, varEjeMayor = 25, varEjeMenor = 0, inclinacion = 80, nombreLunas = {"titan", "rea"}, anchoLunas = {15,20}, altoLunas = {15,20}},
    {nombre = "urano", ancho = 60, alto = 60, varEjeMayor = 0, varEjeMenor = 0, inclinacion = 0},
    {nombre = "neptuno", ancho = 55, alto = 42, varEjeMayor = 0, varEjeMenor = 75, inclinacion = -70, nombreLunas = {"triton", "galatea","proteo"}, anchoLunas = {20,25,22}, altoLunas = {20,19,22}},
}

--TEXTOS DE LOS BOTONES
local textosBotones = {"Iniciar","Cometa","Mercurio","Venus","Tierra","Marte","Júpiter","Saturno","Urano","Neptuno","Salir"}
  
--FUNCIONES
local options = {
    effect = "slideRight",
    time = 2200,
    --time = 500
}

function ir_inicio(event)
    composer.gotoScene("splashScreen",options)
end

function salir(self,event)
    if event.phase == "began" then
        audio.play(sonidoClick)
        self:setFillColor(0.24)
    elseif event.phase == "ended" then
        self:setFillColor(0.44)
        ir_inicio()
    end
   return true
end

--REFACCIONAR
function tocar(self, event )
	if event.phase == "began" then
        audio.play(sonidoClick)
		self:setFillColor( 0.24 )
	elseif event.phase == "ended" then
        local elemento --GRUPO DE CUERPOS ACORDE A UN PLANETA (EL PLANETA EN SI Y SUS LUNAS)
        local cuerpo --PLANETA O LUNA (ELEMENTO) DEL GRUPO DE CUERPOS
        if animacion == false then
            --audio.play(sonidoExplosion)
            grupoBotones[1][2].text = "Detener"
            for i = 2, grupoAstros.numChildren  do
                elemento = grupoAstros[i][2]
                for j = 1, elemento.numChildren do
                    cuerpo = grupoAstros[i][2][j]
                    if i == grupoAstros.numChildren and j == elemento.numChildren then
                        transition.to(cuerpo, {time = 700, x = cuerpo.posx, y = cuerpo.posy, onComplete=function() Runtime:addEventListener("enterFrame", animar) end})
                    else
                        transition.to(cuerpo, {time = 700, x = cuerpo.posx, y = cuerpo.posy})
                    end
                end
            end       
            local explosion = display.newCircle(grupoEfectos,centroXFondo, centroYFondo, 10)
            explosion:setFillColor(1)
            local explosion1 = display.newCircle(grupoEfectos,centroXFondo, centroYFondo, 10)
            explosion1:setFillColor(1); explosion1.xScale = 70; explosion1.yScale = 70; explosion1.alpha = 0
            transition.to(explosion, {time = 700, xScale = 70, yScale = 70, alpha = 0, onComplete = function() explosion:removeSelf() end})
            transition.to(explosion1, {time = 600, xScale = 1, yScale = 1, alpha = 0.7, onComplete = function() explosion1:removeSelf() end})
            transition.to(grupoAstros,{time = 700, alpha = 1})
            animacion = true
        else
            cometaAnimacion = false
            grupoBotones[1][2].text = "Iniciar"
            for i = 2, grupoAstros.numChildren  do
                elemento = grupoAstros[i][2]
                for j = 1, elemento.numChildren do
                    cuerpo = grupoAstros[i][2][j]
                    transition.to(cuerpo, {time = 500, x = centroXFondo, y = centroYFondo})
                    cuerpo.posx = cuerpo.x; cuerpo.posy = cuerpo.y
                end
            end
            local explosion = display.newCircle(grupoEfectos,centroXFondo, centroYFondo, 10)
            explosion:setFillColor(0); explosion.xScale = 70; explosion.yScale = 70; explosion.alpha = 0
            transition.to(explosion, {time = 600, xScale = 1, yScale = 1, alpha = 1, onComplete = function() explosion:removeSelf(); cometaAnimacion = true end})
            transition.to(grupoAstros,{time = 600, alpha = 0})
            Runtime:removeEventListener("enterFrame", animar)
            animacion = false
        end
		self:setFillColor( 0.44 )
	end
	return true
end

function animar()
    local elemento --(CON i=1 es el sol) ES EL SOL O UN GRUPO DE CUERPOS DE UN PLANETA (QUE CONTIENE A LAS ORBITAS Y A LOS CUERPOS)
    local cuerpo --PLANETA O LUNA (ELEMENTO) DEL GRUPO DE CUERPOS
    for i = 1, grupoAstros.numChildren  do
        elemento = grupoAstros[i]
        if i ~= 1 then
            for k = 1, elemento.numChildren do
                for j = 1, elemento[k].numChildren do  --ITERO EN EL GRUPO DE PLANETAS
                    cuerpo = elemento[k][j]
                    if k == 1 and j ~= 1 then
                        cuerpo.x = elemento[2][1].x; cuerpo.y = elemento[2][1].y
                    elseif k == 2 then
                        cuerpo.rotation = cuerpo.rotation + cuerpo.velRotacion
                        if j == 1 then
                            cuerpo.x, cuerpo.y = actualizarPosicion(cuerpo,centroXFondo,centroYFondo)
                        else
                            cuerpo.x, cuerpo.y = actualizarPosicion(cuerpo,elemento[k][1].x,elemento[k][1].y)
                        end
                    end
                end
            end
        else
            elemento.rotation = elemento.rotation + elemento.velRotacion
        end
    end
end

function crearOrbita(grupo,xCentro,yCentro,ejeMayor,ejeMenor,inclinacion,nombre,color)
    local elipse = display.newCircle(grupo, xCentro, yCentro, ejeMayor)
    elipse.strokeWidth = 2
    elipse:setStrokeColor(unpack(color))
    elipse:setFillColor(0, 0, 0, 0)
    elipse.yScale = ejeMenor / ejeMayor
    elipse.rotation = inclinacion
    elipse.nombre = "elipse " .. nombre
end

function actualizarPosicion(cuerpoCeleste, centroX, centroY)
    cuerpoCeleste.angulo = cuerpoCeleste.angulo + cuerpoCeleste.velTraslacion
    
    local x = centroX + cuerpoCeleste.ejeMayor * math.cos(math.rad(cuerpoCeleste.angulo))
    local y = centroY + cuerpoCeleste.ejeMenor * math.sin(math.rad(cuerpoCeleste.angulo))

    local anguloInclinacion = math.rad(cuerpoCeleste.inclinacion)
    local xRotado = (x - centroX) * math.cos(anguloInclinacion) - (y - centroY) * math.sin(anguloInclinacion) + centroX
    local yRotado = (x - centroX) * math.sin(anguloInclinacion) + (y - centroY) * math.cos(anguloInclinacion) + centroY

    return xRotado, yRotado
end

function crearPlaneta(grupo,elemento,indice)
    local valorAux
    local aux = display.newImageRect( grupo,recursosImagenes..elemento.nombre..".png", elemento.ancho,elemento.alto )
    aux.x = centroXFondo; aux.y = centroYFondo
    aux.nombre = elemento.nombre
    aux.velRotacion = math.random(1, 5); aux.velTraslacion = math.random(1,2)
    if indice % 2 == 1 then
        aux.angulo = 90
        valorAux = CH - (centroYFondo/19 * (18-2*indice))
    else
        aux.angulo = 270
        valorAux = centroYFondo/19 * (18-2*indice)
    end
    aux.ejeMayor = math.abs(centroYFondo - valorAux + elemento.varEjeMayor)
    aux.ejeMenor = math.abs(centroYFondo - valorAux + elemento.varEjeMenor)
    aux.inclinacion = elemento.inclinacion
    aux.posx, aux.posy = actualizarPosicion(aux, centroXFondo, centroYFondo) --actualizando posicion acorde a la elipse
    
    return aux
end

function crearLuna(grupo,nombre,ancho,alto,planeta, indice)
    local aux = display.newImageRect( grupo,recursosImagenes..nombre..".png", ancho, alto)
    aux.x = centroXFondo; aux.y = centroYFondo
    aux.nombre = nombre
    aux.velRotacion = math.random(1, 5); aux.velTraslacion = math.random(1, 5)
    aux.angulo = 0; aux.inclinacion = 0
    aux.ejeMayor = 30 * indice; aux.ejeMenor = 30 * indice
    aux.posx, aux.posy = actualizarPosicion(aux, planeta.posx, planeta.posy)
    return aux
end

function crearBotonPrincipal(grupo,indice,nombre,cantidadBotones)
    local grupoBoton = display.newGroup()
    grupo:insert(grupoBoton)
    local boton = display.newRoundedRect(grupoBoton,fondoBotones.x, (fondoBotones.y/13*2 * indice) + 65 , 120, 35, 10)
    boton:setFillColor(0.44)
    boton.strokeWidth = 2
    boton:setStrokeColor(1)
    boton.indice = indice
    if indice > 2 and indice < cantidadBotones then
        boton.touch = tocarBotonPlaneta
        boton:addEventListener('touch',boton)
        boton.popUp = crearPopUpMenu(grupoBoton,boton)
    end

    local texto = display.newText(grupoBoton,nombre, fondoBotones.x, (fondoBotones.y/13*2 * indice) + 67, recursosTexto.."Opcion1.ttf", 25)
    texto:setFillColor(1)
end

function crearBotonPopMenu(grupoPop,botonPadre,varX,varY,ancho,textoBoton,tipo,funcion)
    local boton = display.newRoundedRect(grupoPop, 0, 0, ancho, 35, 10)
    boton.strokeWidth = 2
    boton.x = varX
    boton.y = varY
    boton.indice = botonPadre.indice
    boton: addEventListener('touch',boton)
    local texto = display.newText(grupoPop, textoBoton, boton.x, boton.y + 2, recursosTexto.."Opcion1.ttf", 23)
    if tipo == 0 then --boton
        boton.touch = funcion
        boton:setFillColor(0.44)
        boton:setStrokeColor(1)
        texto:setFillColor(1)
    elseif tipo == 1 then --texto para mostrar
        boton:setFillColor(1)
        boton:setStrokeColor(1)
        texto:setFillColor(0)
    end
end

function crearPopUpMenu(grupo,botonPadre)
    local popupMenu = display.newGroup()
    grupo:insert(popupMenu)

    popupMenu.x = botonPadre.x - 130 
    popupMenu.y = botonPadre.y

    crearBotonPopMenu(popupMenu,botonPadre,-48,-60,215,"Ocultar "..grupoAstros[botonPadre.indice - 1][2][1].nombre,0,ocultar)
    crearBotonPopMenu(popupMenu,botonPadre,13,-20,30,"+",0,aumentarVelTraslacion)
    crearBotonPopMenu(popupMenu,botonPadre,45,-20,30,"-",0,disminuirVelTraslacion)
    crearBotonPopMenu(popupMenu,botonPadre,-80,-20,150,"Traslación: "..grupoAstros[botonPadre.indice - 1][2][1].velTraslacion,1)
    crearBotonPopMenu(popupMenu,botonPadre,13,20,30,"+",0,aumentarVelRotacion)
    crearBotonPopMenu(popupMenu,botonPadre,45,20,30,"-",0,disminuirVelRotacion)
    crearBotonPopMenu(popupMenu,botonPadre,-80,20,150,"Rotación: "..grupoAstros[botonPadre.indice - 1][2][1].velTraslacion,1)
    crearBotonPopMenu(popupMenu,botonPadre,-120,60,70,"Incl.",1)

    local slider = widget.newSlider { x = -10, y = 60, width = 120, id = botonPadre.indice,value = convertirValor(grupoAstros[botonPadre.indice - 1][1][1].rotation,-180,180,0,100),listener = cambiarInclinacion} 
    slider.indice = botonPadre.indice
    popupMenu:insert( slider )

    popupMenu.isVisible = false
    return popupMenu
end

function cambiarInclinacion(event)
    if event.phase == "began" then
        event.target.traslacion = grupoAstros[event.target.indice - 1][2][1].velTraslacion 
        event.target.rotacion = grupoAstros[event.target.indice - 1][2][1].velRotacion
        grupoAstros[event.target.indice - 1][2][1].velTraslacion = 0
        grupoAstros[event.target.indice - 1][2][1].velRotacion = 0
    elseif event.phase == "moved" then
        grupoAstros[event.target.indice - 1][2][1].inclinacion = convertirValor(event.value,0,100,-180,180)
        grupoAstros[event.target.indice - 1][1][1].rotation = convertirValor(event.value,0,100,-180,180)
    elseif event.phase == "ended" then
        grupoAstros[event.target.indice - 1][2][1].velTraslacion = event.target.traslacion
        grupoAstros[event.target.indice - 1][2][1].velRotacion = event.target.rotacion
        event.value = convertirValor(event.value,-180,180,0,100)
    end
    return true
end


function ocultarPopUps(indice)
    for i=3,grupoBotones.numChildren - 1 do
        if i ~= indice then
            grupoBotones[i][2].isVisible = false
        end
    end
end

function tocarBotonPlaneta(self, event)
    if event.phase == "began" then
        audio.play(sonidoClick)
        self:setFillColor(0.24)
    elseif event.phase == "ended" then
        self:setFillColor(0.44)
        ocultarPopUps(self.indice)
        self.popUp.isVisible = not self.popUp.isVisible
    end
    return true
end


function ocultar(self, event)
    if event.phase == "began" then
        audio.play(sonidoClick)
        self:setFillColor(0.24)
    elseif event.phase == "ended" then
        self:setFillColor(0.44)
        if grupoBotones[self.indice][2][2].text == "Ocultar "..grupoAstros[self.indice - 1][2][1].nombre then
            grupoBotones[self.indice][2][2].text = "Mostrar "..grupoAstros[self.indice - 1][2][1].nombre
        else
            grupoBotones[self.indice][2][2].text = "Ocultar "..grupoAstros[self.indice - 1][2][1].nombre
        end
        grupoAstros[self.indice - 1].isVisible = not grupoAstros[self.indice - 1].isVisible
    end
    return true
end

function aumentarVelTraslacion(self, event)
    if event.phase == "began" then
        audio.play(sonidoClick)
        self:setFillColor(0.24)
    elseif event.phase == "ended" then
        self:setFillColor(0.44)
        if grupoAstros[self.indice - 1][2][1].velTraslacion < 8 then
            local incremento = grupoAstros[self.indice - 1][2][1].velTraslacion + 1
            grupoAstros[self.indice - 1][2][1].velTraslacion = incremento
            grupoBotones[self.indice][2][8].text = "Traslación: ".. incremento
        else
            desplegarMensaje(grupoEfectos,"Velocidad de traslación máxima alcanzada")
        end
    end
    return true
end

function disminuirVelTraslacion(self, event)
    if event.phase == "began" then
        audio.play(sonidoClick)
        self:setFillColor(0.24)
    elseif event.phase == "ended" then
        self:setFillColor(0.44)
        if grupoAstros[self.indice - 1][2][1].velTraslacion > 0 then
            local incremento = grupoAstros[self.indice - 1][2][1].velTraslacion - 1
            grupoAstros[self.indice - 1][2][1].velTraslacion = incremento
            grupoBotones[self.indice][2][8].text = "Traslación: ".. incremento
        else
            desplegarMensaje(grupoEfectos,"Velocidad de traslación mínima alcanzada")
        end
    end
    return true
end

function aumentarVelRotacion(self, event)
    if event.phase == "began" then
        audio.play(sonidoClick)
        self:setFillColor(0.24)
    elseif event.phase == "ended" then
        self:setFillColor(0.44)
        if grupoAstros[self.indice - 1][2][1].velRotacion < 10 then
            local incremento = grupoAstros[self.indice - 1][2][1].velRotacion + 1
            grupoAstros[self.indice - 1][2][1].velRotacion = incremento
            grupoBotones[self.indice][2][14].text = "Rotación: ".. incremento
        else
            desplegarMensaje(grupoEfectos,"Velocidad de rotación máxima alcanzada")
        end
    end
    return true
end

function disminuirVelRotacion(self, event)
    if event.phase == "began" then
        audio.play(sonidoClick)
        self:setFillColor(0.24)
    elseif event.phase == "ended" then
        self:setFillColor(0.44)
        if grupoAstros[self.indice - 1][2][1].velRotacion > 0 then
            local incremento = grupoAstros[self.indice - 1][2][1].velRotacion - 1
            grupoAstros[self.indice - 1][2][1].velRotacion = incremento
            grupoBotones[self.indice][2][14].text = "Rotación: ".. incremento
        else
            desplegarMensaje(grupoEfectos,"Velocidad de rotación mínima alcanzada")
        end
    end
    return true
end

function convertirValor(valor, minValorOriginal, maxValorOriginal, minValorNuevo, maxValorNuevo)
    local porcentaje = (valor - minValorOriginal) / (maxValorOriginal - minValorOriginal)
    local nuevoValor = minValorNuevo + (porcentaje * (maxValorNuevo - minValorNuevo))
    return nuevoValor
end

--REFACCIONAR
function cometa(self, event)
    if event.phase == "began" then
        audio.play(sonidoClick)
        self:setFillColor(0.24)
    elseif event.phase == "ended" then
        self:setFillColor(0.44)
        if cometaAnimacion and animacion then
            audio.play(sonidoCometa)
            local sentido = math.random(0, 1)
            local cometa = display.newImageRect(grupoEfectos, recursosImagenes.."cometa.png", 100, 50)
            cometa.x = math.random(0, centroXFondo * 2)
            local destinoX = math.random(0, centroXFondo * 2)
            local duracionPrincipal = math.random(400, 550)  -- Duración del movimiento del cometa principal
            local destinoY
            if sentido == 0 then
                cometa.y = -50
                destinoY = CH + 50
            elseif sentido == 1 then
                cometa.y = CH + 50
                destinoY = -50
            end
            local deltaX = destinoX - cometa.x
            local deltaY = destinoY - cometa.y
            local angulo = math.atan2(deltaY, deltaX) * 180 / math.pi
            cometa.rotation = angulo
            transition.to(cometa, {y = destinoY, x = destinoX, time = duracionPrincipal, onComplete = function() cometa:removeSelf() end})

            -- Crear efecto de rastro punteado
            local numTraslapos = 10  -- Número de instancias del cometa para el rastro
            local intervaloTraslapo = duracionPrincipal / numTraslapos  -- El rastro se mueve más rápido que el cometa principal
            local duracionTraslapo = 500  -- Duración del movimiento de cada instancia del rastro
            local opacidadInicial = 1  -- Opacidad inicial del rastro
            local opacidadFinal = 0  -- Opacidad final del rastro
            for i = 1, numTraslapos do
                local cometaTraslapo = display.newImageRect(grupoEfectos, recursosImagenes.."cometa.png", 100, 50)
                cometaTraslapo.x = cometa.x
                cometaTraslapo.y = cometa.y
                cometaTraslapo.rotation = cometa.rotation
                cometaTraslapo.alpha = opacidadInicial - (opacidadInicial - opacidadFinal) * (i / numTraslapos)  -- Ajustar la opacidad
                grupoEfectos:insert(1, cometaTraslapo)  -- Insertar el cometa traslapo al inicio del grupo para que aparezca detrás
                transition.to(cometaTraslapo, {y = destinoY, x = destinoX, time = duracionTraslapo, delay = intervaloTraslapo * (i - 1) + duracionPrincipal - duracionTraslapo, onComplete = function() cometaTraslapo:removeSelf() end})
            end
        else 
            desplegarMensaje(grupoEfectos,"Inicia la animación para mostrar los cometas")
        end
    end
    return true
end

function desplegarMensaje(grupo,texto)
    local texto = display.newText(grupo, texto, centroXFondo, CH/6 * 5, recursosTexto.."Opcion1.ttf", 25)
    texto.alpha = 0
    transition.to(texto,{alpha = 1,time = 500,size=35})
    transition.to(texto, { delay= 1000, alpha = 0, time = 500, onComplete = function() texto:removeSelf() end })
end

-- create()
function scene:create( event )
 
    local sceneGroup = self.view

    sceneGroup:insert(grupoFondo)
    sceneGroup:insert(grupoAstros)
    sceneGroup:insert(grupoEfectos)
    sceneGroup:insert(grupoFondoBotones)

    fondo = display.newImageRect(grupoFondo,recursosImagenes.."fondoEspacio.png", CW, CH)
    fondo.x = CW / 2; fondo.y = CH / 2

    fondoBotones = display.newImageRect(grupoFondoBotones,recursosImagenes.."fondoBotones.png", CW/6.5, CH)
    fondoBotones.x = CW/9*8.3; fondoBotones.y = CH/2
    fondoBotones.alpha = 0.5

    centroXFondo = (fondo.width - fondoBotones.width)/2; centroYFondo = fondo.y

    local texto = display.newText(grupoFondoBotones,"Botones", fondoBotones.x, fondoBotones.y/6, recursosTexto.."Opcion2.ttf", 25)
    texto:setFillColor(1)

    local sol = display.newImageRect( grupoAstros,recursosImagenes.."sol.png", 83,83 )
    sol.x = centroXFondo; sol.y = centroYFondo
    sol.posx = centroXFondo; sol.posy = centroYFondo
    sol.velRotacion = 1

    local grupoAux  --GRUPO GENERAL DE UN PLANETA
    local grupoAuxPlanetas --GRUPO DE PLANETAS Y LUNAS
    local grupoAuxOrbitas --GRUPO DE ORBITAS
    grupoAstros.alpha = 0
    for i = 1, #nombresPlanetas do
        local elemento = nombresPlanetas[i]
        grupoAux = display.newGroup()
        grupoAstros:insert(grupoAux)
        grupoAuxOrbitas = display.newGroup()
        grupoAux:insert(grupoAuxOrbitas)
        grupoAuxPlanetas = display.newGroup()
        grupoAux:insert(grupoAuxPlanetas)
        local auxPlaneta = crearPlaneta(grupoAuxPlanetas,elemento,i)
        crearOrbita(grupoAuxOrbitas,centroXFondo,centroYFondo,auxPlaneta.ejeMayor,auxPlaneta.ejeMenor,auxPlaneta.inclinacion,auxPlaneta.nombre,color_blanco)

        if elemento.nombreLunas then
            for i = 1, #elemento.nombreLunas do
                local auxLuna = crearLuna(grupoAuxPlanetas,elemento.nombreLunas[i],elemento.anchoLunas[i],elemento.altoLunas[i],auxPlaneta,i)
                crearOrbita(grupoAuxOrbitas,auxPlaneta.posx,auxPlaneta.posy,auxLuna.ejeMayor,auxLuna.ejeMenor,auxLuna.inclinacion,auxLuna.nombre,color_amarillo)
            end
        end
    end

    grupoFondoBotones:insert(grupoBotones)

    for i=1,#textosBotones do
        local elemento = textosBotones[i]
        crearBotonPrincipal(grupoBotones,i,elemento,#textosBotones)
    end
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        grupoBotones[1][1].touch = tocar
        grupoBotones[1][1]:addEventListener('touch',grupoBotones[1][1])
        grupoBotones[2][1].touch = cometa
        grupoBotones[2][1]:addEventListener('touch',grupoBotones[2][1])
        grupoBotones[grupoBotones.numChildren][1].touch = salir
        grupoBotones[grupoBotones.numChildren][1]:addEventListener('touch',grupoBotones[grupoBotones.numChildren][1])
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
        if animacion == true then
            tocar(grupoBotones[1][1],{phase = "ended"})
        end
        for i=3,grupoBotones.numChildren - 1 do
            grupoBotones[i][2].isVisible = false
        end
        grupoBotones[1][1]:removeEventListener('touch',grupoBotones[1][1])
        grupoBotones[2][1]:removeEventListener('touch',grupoBotones[2][1])
        grupoBotones[grupoBotones.numChildren][1]:removeEventListener('touch',grupoBotones[grupoBotones.numChildren][1])
 
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