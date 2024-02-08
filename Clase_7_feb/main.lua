-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
display.setStatusBar( display.HiddenStatusBar)
local CAW = display.actualContentWidth; local CAH = display.safeActualContentHeight
local CW = display.contentWidth; local CH = display.contentHeight
print( display.contentWidth, display.contentHeight )
print(display.actualContentWidth, display.actualContentHeight)

local linea1 = display.newLine(30,51,30,55)
linea1.strokeWidth = 3
local linea2 = display.newLine(20,50,80,25)
linea2:append(65,125, 60,120, 20,50)

local diferencia_altura = CAH - CH
local diferencia_ancho = CAW - CW
print(diferencia_altura)
local mitad_altura = diferencia_altura/2
local mitad_diferencia_ancho = diferencia_ancho/2

local diagonal = display.newLine(0  ,0, CW ,CH)
print(diagonal)
diagonal.strokeWidth = 4
diagonal:setStrokeColor(120/255, 140/255, 204/255)

-- POLIGON
local vertices = { 0,-110, 27,-35, 105,-35, 43,16, 65,90, 0,45, -65,90, -43,15, -105,-35, -27,-35, }

local cuadrado = display.newRect(200, 10 , 170, 180)
cuadrado.anchorY = 0
cuadrado.y = 200

local poligono = display.newPolygon( CW/2, CH/2, vertices )
poligono:setFillColor( 0, 0, 1)
poligono.strokeWidth = 2 
poligono:setStrokeColor( 1,0,0 )
poligono.anchorX = 0
poligono.anchorY = 1
-- cuadrado:toFront( )
poligono:toBack( )


local circle = display.newCircle(100, 50, 10)
circle:setFillColor( 0, 1, 0 )



print(cuadrado.x, cuadrado.y, cuadrado.anchorX, cuadrado.anchorY)
print(cuadrado.width, cuadrado.contentHeight)
cuadrado.width = 150

local imagen = display.newImage("Icon.png")
imagen.x = CW/2; imagen.y = CH/2
print("Dimensiones", imagen.width, imagen.height)
local imagen2 = display.newImageRect( "Imagen.jpg", 160, 190 )
imagen2.x = 100; imagen2.y = CH/2 +50


