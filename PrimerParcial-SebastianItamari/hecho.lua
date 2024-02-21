-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
--CONTROLADORES PARA LOS BOTONES
local animacion = false
--DIMENSIONES GENERALES DE LA PANTALLA DEL DISPOSITIVO
local CW = display.contentWidth
local CH = display.contentHeight

--NOMBRES DE LOS PLANETAS
local nombresPlanetas = {
    "mercurio",
    "venus",
    "tierra",
    "marte",
    "saturno",
    "jupiter",
    "urano",
    "neptuno",
}

--FONDO DE LA ANIMACIÓN
local fondo = display.newImageRect("Imagenes/fondoEspacio.png", CW, CH)
fondo.x = CW / 2; fondo.y = CH / 2

--LISTA PARA TODOS LOS ELEMENTOS
local cuerposCelestes = {}


--SECCIÓN DE BOTONES
local fondoBotones = display.newImageRect("Imagenes/fondoBotones.png", CW/6.5, CH)
fondoBotones.x = CW/9*8.3; fondoBotones.y = CH/2
fondoBotones.alpha = 0.5
local texto = display.newText("Botones", fondoBotones.x, fondoBotones.y/6, "Comic Sans MS", 33)
texto:setFillColor(1, 1, 1)

--BOTONES
local botonPlay = display.newRoundedRect(fondoBotones.x, fondoBotones.y/6*2 , 120, 35, 10) -- (x, y, ancho, alto, radio)
botonPlay:setFillColor(0.44) -- Color de relleno del rectángulo
botonPlay.strokeWidth = 2 -- Grosor del borde del rectángulo
botonPlay:setStrokeColor(1) -- Color del borde del rectángulo

--CENTRO DE LA PARTE DE LA ANIMACIÓN
local centroXFondo = (fondo.width - fondoBotones.width)/2
local centroYFondo = fondo.y

--SOL
local sol = display.newImageRect( "Imagenes/sol.png", 83,83 )
sol.x = centroXFondo; sol.y = centroYFondo
sol.posx = centroXFondo; sol.posy = centroYFondo
sol.velRotacion = 1
--cuerposCelestes:insert(sol) 
table.insert(cuerposCelestes, sol)

--PLANETAS
local mercurio = display.newImageRect( "Imagenes/mercurio.png", 28,33 )
mercurio.x = centroXFondo; mercurio.y = centroYFondo
mercurio.posx = centroXFondo; mercurio.posy = CH - (centroYFondo / 19 * 16) 
mercurio.velRotacion = 6
mercurio.ejeMayor = centroYFondo - mercurio.posy; mercurio.ejeMenor = centroYFondo - mercurio.posy
mercurio.anguloInicial = 0
--cuerposCelestes:insert(mercurio) 
table.insert(cuerposCelestes, mercurio)

local venus = display.newImageRect( "Imagenes/venus.png", 28,31 )
venus.x = centroXFondo; venus.y = centroYFondo
venus.posx = centroXFondo; venus.posy = centroYFondo / 19 * 14
venus.velRotacion = 4
venus.ejeMayor = centroYFondo - venus.posy; venus.ejeMenor = centroYFondo - venus.posy
venus.anguloInicial = 0
--cuerposCelestes:insert(venus) 
table.insert(cuerposCelestes, venus)

local tierra = display.newImageRect( "Imagenes/tierra.png", 30,33 )
tierra.x = centroXFondo; tierra.y = centroYFondo
tierra.posx = centroXFondo; tierra.posy = CH - (centroYFondo / 19 * 12)
tierra.velRotacion = 4
tierra.ejeMayor = centroYFondo - tierra.posy; tierra.ejeMenor = centroYFondo - tierra.posy
tierra.anguloInicial = 0
--cuerposCelestes:insert(tierra) 
table.insert(cuerposCelestes, tierra)

local marte = display.newImageRect( "Imagenes/marte.png", 33,23 )
marte.x = centroXFondo; marte.y = centroYFondo
marte.posx = centroXFondo; marte.posy = centroYFondo / 19 * 10
marte.velRotacion = 5
marte.ejeMayor = centroYFondo - marte.posy; marte.ejeMenor = centroYFondo - marte.posy
marte.anguloInicial = 0
--cuerposCelestes:insert(marte) 
table.insert(cuerposCelestes, marte)

local jupiter = display.newImageRect( "Imagenes/jupiter.png", 50,45 )
jupiter.x = centroXFondo; jupiter.y = centroYFondo
jupiter.posx = centroXFondo; jupiter.posy = CH - (centroYFondo / 19 * 8)
jupiter.velRotacion = 1
jupiter.ejeMayor = centroYFondo - jupiter.posy; jupiter.ejeMenor = centroYFondo - jupiter.posy
jupiter.anguloInicial = 0
--cuerposCelestes:insert(jupiter) 
table.insert(cuerposCelestes, jupiter)

local saturno = display.newImageRect( "Imagenes/saturno.png", 50,50 )
saturno.x = centroXFondo; saturno.y = centroYFondo
saturno.posx = centroXFondo; saturno.posy = centroYFondo / 19 * 6
saturno.velRotacion = 2
saturno.ejeMayor = centroYFondo - saturno.posy; saturno.ejeMenor = centroYFondo - saturno.posy
saturno.anguloInicial = 0
--cuerposCelestes:insert(saturno) 
table.insert(cuerposCelestes, saturno)

local urano = display.newImageRect( "Imagenes/urano.png", 60,57 )
urano.x = centroXFondo; urano.y = centroYFondo
urano.posx = centroXFondo; urano.posy = CH - (centroYFondo / 19 * 4)
urano.velRotacion = 1
urano.ejeMayor = centroYFondo - urano.posy; urano.ejeMenor = centroYFondo - urano.posy
urano.anguloInicial = 0
--cuerposCelestes:insert(urano) 
table.insert(cuerposCelestes, urano)

local neptuno = display.newImageRect( "Imagenes/neptuno.png", 55,42 )
neptuno.x = centroXFondo; neptuno.y = centroYFondo
neptuno.posx = centroXFondo; neptuno.posy = centroYFondo / 19 * 2
neptuno.velRotacion = 2
neptuno.ejeMayor = centroYFondo - neptuno.posy; neptuno.ejeMenor = centroYFondo - neptuno.posy
neptuno.anguloInicial = 0
--cuerposCelestes:insert(neptuno) 
table.insert(cuerposCelestes, neptuno)

local function loop()
    for i = 1, #cuerposCelestes do
        local elemento = cuerposCelestes[i]
        if i ~= 1 then
            --revisar
            elemento.anguloInicial = elemento.anguloInicial + elemento.velRotacion
            elemento.x = centroXFondo + math.abs(elemento.ejeMayor) * math.cos(math.rad(elemento.anguloInicial))
            elemento.y = centroYFondo + math.abs(elemento.ejeMenor) * math.sin(math.rad(elemento.anguloInicial))  
        end
        elemento.rotation = elemento.rotation + elemento.velRotacion
    end
end

function animar()
    if animacion == false then
        Runtime:addEventListener("enterFrame", loop)
        animacion = true     
    end
end

function tocar(self, event )
	if event.phase == "began" then
		self:setFillColor( 0.24 )
	elseif event.phase == "ended" then
        if animacion == false then
            for i = 1, #cuerposCelestes do
                local elemento = cuerposCelestes[i]
                transition.to(elemento, {time = 1000, x = elemento.posx, y = elemento.posy, onComplete = animar})
            end       
        else
            for i = 1, #cuerposCelestes do
                local elemento = cuerposCelestes[i]
                transition.to(elemento, {time = 500, x = centroXFondo, y = centroYFondo})
            end
            Runtime:removeEventListener("enterFrame", loop)
            animacion = false
            --cuerposCelestes.isVisible = false
        end
		self:setFillColor( 0.44 )
	end
	return true
end

botonPlay.touch = tocar
botonPlay:addEventListener("touch", botonPlay)

-- Definir variables para la elipse
local centerX, centerY = centroXFondo, centroYFondo
local semiejeMayor = 150
local semiejeMenor = 100
local speed = 2 -- Velocidad de rotación (puedes ajustarla según tus preferencias)
local angle = 0

-- Dibujar la elipse en el fondo
local elipse = display.newCircle(centerX, centerY, semiejeMayor)  -- Creamos un círculo
elipse.strokeWidth = 4  -- Grosor de la línea
elipse:setStrokeColor(1, 1, 1, 0.5) -- Color blanco con transparencia
elipse:setFillColor(0, 0, 0, 0) -- Rellenamos el círculo con transparencia

-- Escalar el círculo en el eje Y para hacerlo parecer una elipse
elipse.yScale = semiejeMenor / semiejeMayor

-- Cargar la imagen para el objeto giratorio
local image = display.newImage("Icon.png")  -- Reemplaza "Icon.png" con la ruta de tu imagen
image.x = centerX + semiejeMayor
image.y = centerY

-- Definir el ángulo de inclinación en grados
local inclinacionGrados = -50  -- Por ejemplo, inclinamos la elipse 30 grados

-- Función para rotar el objeto
local function rotateObject()
    angle = angle + speed
    
    -- Calcular la posición de la imagen en la elipse
    local x = centerX + semiejeMayor * math.cos(math.rad(angle))
    local y = centerY + semiejeMenor * math.sin(math.rad(angle))
    
    -- Aplicar inclinación a la posición de la imagen
    local anguloInclinacion = math.rad(inclinacionGrados)  -- Convertir la inclinación a radianes
    local xRotado = (x - centerX) * math.cos(anguloInclinacion) - (y - centerY) * math.sin(anguloInclinacion) + centerX
    local yRotado = (x - centerX) * math.sin(anguloInclinacion) + (y - centerY) * math.cos(anguloInclinacion) + centerY
    
    -- Establecer la nueva posición y rotación de la imagen
    image.x, image.y = xRotado, yRotado
    image.rotation = image.rotation + 5
    
    -- Aplicar inclinación a la elipse
    elipse.rotation = inclinacionGrados
end
-- Función de bucle de juego
local function gameLoop()
    rotateObject()
end

-- Iniciar el bucle de juego
Runtime:addEventListener("enterFrame", gameLoop)
