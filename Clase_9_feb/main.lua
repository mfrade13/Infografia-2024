-----------------------------------------------------------------------------------------
local CW = display.contentWidth
local CH = display.contentHeight
local fondo = display.newRect(CW/2, CH/2, CW, CH)
fondo:setFillColor(0.43)
local color_rojo = {1,0,0}
local color_verde = {0,1,0}
local color = color_rojo
local boton = display.newCircle(CW/2, CH*0.75, 50)
boton.nombre = "Boton circular"
boton.puntos = 20
local boton2 = display.newRect(CW/2, CH*0.25, 100,50)
boton2.nombre = "Boton2"
local boton3 = display.newRect(CW/2, CH/2, 100,50)
boton3.nombre = "Soy el boton 3"

local botones = {
}

function darNombre(self, e)
	if e.phase == "ended" then 
		print("Mi nombre es " .. self.nombre)
	end
	return true
end

for i=1,3,1 do
	botones[i] = display.newRect(CW/4, CH/4 + (i *100), 100, 50)
	botones[i].nombre = "boton_arreglo" .. i
	-- SINTAXIS NO VALIDA PARA ARREGLOS 
	-- function botones[i]:touch(event)
	-- 	if e.phase == "ended" then 
	-- 		print("Mi nombre es " .. self.nombre)
	-- 	end
	-- 	return true
	-- end
	botones[i].touch = darNombre
	botones[i]:addEventListener( "touch", botones[i] )
end


function dibujar(event)
	if event.phase == "moved" then
		if (event.x >= boton.x - 50 and event.x <= boton.x + 50 and event.y <= boton.y + 50 and event.y >= boton.y - 50) then
			print("estoy dentro del circulo no debo dibujar")

		else
			local punto = display.newCircle(event.x,event.y, 5)
			punto:setFillColor(unpack( color ))
		end
	end
	return true
end
function tocar( event )
	if event.phase == "began" then
		print("Fase began")
		print(event.x, event.y)
	elseif event.phase == "moved"  then
		print("fase moved", event.x, event.y)
	elseif event.phase == "ended" then
		print("fase ended", event.x, event.y, event.id, event.name, event.target.nombre)
		print("Sume " .. event.target.puntos .. " puntos a mi score")

		color = color_verde
		fondo:setFillColor(math.random( 0,255 )/255,math.random( 0,255 )/255,math.random( 0,255 )/255  )
		--display.remove(event.target)
		event.target:removeSelf( )
	end
	return true
end
function tocar_2(self, event )
	if event.phase == "began" then
		boton2:setFillColor( 0.8 )
	elseif event.phase == "moved"  then
		-- -- print("fase moved")
		-- boton2.x = event.x
		-- boton2.y = event.y
	elseif event.phase == "ended" then
		print("Fase began")
		boton2:setFillColor( 1 )
		boton2.x = event.x
		boton2.y = event.y
		print(self.nombre)

	end
	return true
end


function boton3:touch( event )
	if event.phase == "ended" then
		self.width = 150; self.height = 80
		print(self.nombre)
	end
	return true
end

boton2.touch = tocar_2


boton:addEventListener( "touch", tocar )
boton2:addEventListener( "touch", boton2 )
fondo:addEventListener( "touch", dibujar )
boton3:addEventListener( "touch", boton3 )
