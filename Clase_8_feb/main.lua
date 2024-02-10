-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local CW = display.contentWidth
local CH = display.contentHeight

print(CW, CH)

local ancho_pixel = CW/21
local alto_pixel = CH/19
local lineaV

local fondo = display.newRect(CW/2, CH/2, CW,CH)
fondo:setFillColor( 0.43 )


--local lineaH = display.newLine(0, 0+alto_pixel, CW, 0+alto_pixel)
charmander = display.newImageRect("charmander2.jpeg", CW*1.5,CH*1.6)
charmander.x=CW/2-30; charmander.y = CH/2 +300
charmander.alpha=0.0


--local colores
local color_negro = {0,0,0}
local color_blanco = {1,1,1}
local color_rojo = {1,0,0}
local color_amarillo = {1,1,0}
local color_naranja = {0.83,0.5,0.15}
print( unpack( color_negro ))

-- fuego rojo
local fuego_rojo = {
{17,2,3,3},
{17,5,5,3}
}

local parte_amarilla = {
    {7,12,4,4}, --pecho
    {18,6,2,3}
}

local parte_naranja = {
	{18,6,1,1},
	{19,5,1,1}
}

local parte_naranja_2 = {
	{4,2,6,9},
	{2,5,10,5},
	{11,9,3,10},
	{11,11,6,4},
	{10,9,1,5},
	{9,11,1,2},
	{8,11,1,1},
	{17,9,2,4}

}
local puntos_blancos = {
	{5,5,1,1},
	{6,14,1,1},
	{11,17,1,1},
	{13,17,1,1}
}

-- contornos
local contornos = {
	{1,6 ,1,3,23,4,3,4,4,3,3,2,2}, --9 elementos
	{2,5,1,1},
	{3,3,1,2},
	{4,2,1,1},
	{5,1,4,1},
	{9,2,1,1},
	{10,3,1,2},
	{11,5,1,2},
	{12,7,1,2},
	{13,9,1,1},
	{14,10,1,2},
	{15,11,1,5},
	{16,10,1,1},
	{17,8,1,2},
	{16,5,1,3},
	{17,2,1,3},
	{18,1,1,1},
	{19,2,1,1},
	{20,3,1,2},
	{21,5,1,3},
	{20,8,1,1},
	{19,8,1,3},
	{18,11,1,2},
	{17,13,1,1},
	{16,14,1,1},
	{14,15,1,3},
	{11,18,3,1},
	{10,17,1,1},
	{9,16,3,1},
	{6,15,3,1},
	{7,14,1,1},
	{5,14,1,1},
	{5,11,3,1},   -- T
	{6,12,1,2},
	{2,9,1,1},
	{3,10,2,1},
	{10,11,1,1},
	{11,10,1,1},
	{11,12,2,1}

}
function dibujar_contornos( x1,y1,ancho,alto, color  )
	local contorno = display.newRect((x1-1) *ancho_pixel , (y1-1) *alto_pixel, ancho *ancho_pixel, alto*alto_pixel)
	contorno.anchorX=0; contorno.anchorY=0

	contorno:setFillColor( unpack(color) )
	

end


for i=1,20,1 do
	local lineaH = display.newLine(0, alto_pixel * i, CW, alto_pixel *i )
	local texto = display.newText( "".. i,      10,     alto_pixel*i, native.systemFont, 20 )
									--texto, posicionX, posicionY, font, tamańo font
end

for i=1,23,1 do
	lineaV = display.newLine(ancho_pixel*i ,0, ancho_pixel*i, CH )
	--lineaV.strokeWidth = 3
	lineaV.nombre = i
	local texto = display.newText( "".. i, ancho_pixel*i, 10, native.systemFont, 20 )
end

--OJO BLOQUE NEGRO
-- local ojo = display.newRect(5*ancho_pixel, 4*alto_pixel, 2*ancho_pixel, 3*alto_pixel)
-- ojo.anchorX =0; ojo.anchorY=0
-- ojo:setFillColor( 0 )
-- --local pupila = display.newRect( 5*ancho_pixel, 5*alto_pixel, 1*ancho_pixel, 1*alto_pixel )
-- local pupila = display.newRect( ojo.x,ojo.y, 1*ancho_pixel, 1*alto_pixel )
-- pupila.anchorX=0; pupila.anchorY=0

--
for i,v in ipairs( fuego_rojo) do
	dibujar_contornos( v[1],v[2],v[3],v[4], color_rojo )
end

for i,v in ipairs( parte_amarilla) do
	dibujar_contornos( v[1],v[2],v[3],v[4], color_amarillo )
end


for i,v in ipairs( parte_naranja_2) do
	dibujar_contornos( v[1],v[2],v[3],v[4], color_naranja )
end



for i,v in ipairs( parte_naranja) do
	dibujar_contornos( v[1],v[2],v[3],v[4], color_naranja )
end

--DIBUJAR CONTORNOS
for i,v in ipairs( contornos) do
	print(i, unpack(v))
	dibujar_contornos( v[1],v[2],v[3],v[4], color_negro )
end

dibujar_contornos(5,5,2,3, color_negro) -- ojo podria ir a contornos


for i,v in ipairs( puntos_blancos) do
	dibujar_contornos( v[1],v[2],v[3],v[4], color_blanco )
end


--dibujar_contornos(5,5,1,1, color_blanco ) -- pupila que fue el gruplo blanco


