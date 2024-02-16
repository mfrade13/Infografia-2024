-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
local CW = display.contentWidth
local CH = display.contentHeight


local fondo = display.newRect(CW/2, CH/2, CW,CH)
fondo:setFillColor(0.44)
fondo.alpha=1
local imagen


function rotar_imagen()
	print(imagen)
transition.to(imagen, {rotation=720, time=3000, tag="icono", xScale=2.25, yScale=0.5, 
	onComplete=cambios_imagen, onStart=cambios_imagen})
end
imagen = display.newImageRect("Icon.png", 100, 100)
imagen.x = CW/2; imagen.y= CH/2
--imagen.rotation = 180

local T1 = transition.to(imagen, {x=300, y=200, time=2000, tag="icono", onComplete=rotar_imagen})
print(imagen.xScale, imagen.yScale)
local menu = display.newRect(  0, CH/2, 50, CH )
menu.alpha = 0
print(menu.alpha, menu.isVisible, menu.rotation)
menu.isVisible = true
local pause = false


local texto = display.newText("DOOM", CW/2, CH/6, "arial", 40)
print(texto.size)

function cambios_imagen( obj )
	print(imagen.width, imagen.xScale)
end

transition.to(menu, {alpha = 1, width=50, time=1000, iterations=5})
--transition.to(fondo, {alpha=1, time =2000})
-- transition.to(imagen, {delay=2000, rotation=720, time=3000, xScale=2.25, yScale=0.5, 
-- 	onComplete=cambios_imagen, onStart=cambios_imagen})
local t2 = transition.to(texto, {size = 80, time=2000, iterations = 4})
local t_blink = transition.blink(texto, {time=2000, tag="icono"})

function detener_trancisiones(e)
	if e.phase == "ended" then 
		if pause == false then
--		transition.pause( "icono" )
--		transition.pause(imagen)
--		transition.pause(T1)
			transition.cancel(t_blink)
			transition.pause()
			pause = true
		else
			pause = false
			transition.resume()
		end
	end
	return true
end

fondo:addEventListener( "touch", detener_trancisiones )
