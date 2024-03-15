-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
-- Pantallas
  -- SplashScreen  -- logo
  -- Menu -- Niveles  Dificultad
  -- Instrucciones Guia -- Tutorial (opcionales)
  -- Configuraciones -- Nombre  audio -- volumen
  -- Pantalla de puntajes   escores por nivel -- logros
  	-- Pausa (mostrar configuraciones) --depende de la complejidad --pop up -- distribuidor
  -- Creditos  -- quienes crearon el proyecto
  -- Juego en si.. controles

-- controles ---
	-- botones para saltar, agacharse, 
	-- movimiento  
	-- sonido
	-- pausa

-- personajes 
	--  principal/protagonista
	-- enemigos
	-- secundarios
	-- NPC  -- Llenar vacios o poblar la pantalla
-- interfaz del juego
		-- timers
		-- vidas 
		-- inventario
		-- chat
		-- mapa
		-- puntaje
		-- objetivos
-- ESCENARIO
	-- FONDO
-- Your code here

local composer = require("composer")

composer.gotoScene("splashScreen")

