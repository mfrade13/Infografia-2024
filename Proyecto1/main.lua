local sunX, sunY
local planetNames = {"assets/mercurio.png", "assets/venus.png", "assets/tierra.png", "assets/marte.png", "assets/jupiter.png", "assets/saturno.png", "assets/urano.png", "assets/neptuno.png"}
local moonNames = {"assets/luna1.png", "assets/luna2.png", "assets/luna3.png"} 
local solI = {"assets/sol.png"}
local planets = {}
local moons = {} -- Tabla para almacenar las lunas
local planetSpeeds = {0.007, 0.005, 0.009, 0.006, 0.008, 0.004, 0.010, 0.003}
local moonSpeeds = {0.015, 0.02, 0.018} 
local planetRadiuses = {0,0,0,0,0,0,0,0}
local moonRadiuses = {21, 25, 30} 
local planetAngles = {0, 0, 0, 0, 0, 0, 0, 0}
local moonAngles = {0, 0, 0} 
local isSunRotating = true 
local isRandomMovement = false 
local planetPositions = {} 

local function calculateOrbit(centerX, centerY, radiusX, radiusY, angle)
    local x = centerX + radiusX * math.cos(angle)
    local y = centerY + radiusY * math.sin(angle)
    return x, y
end

local function drawPlanetsAndMoons()
    -- Dibujar los planetas
    for i = 1, #planets do
        local planet = planets[i]
        local planetX, planetY = calculateOrbit(sunX, sunY, planet.radiusX, planet.radiusY, planet.angle)
        planet.image.x = planetX
        planet.image.y = planetY

        -- Dibujar las lunas para los planetas seleccionados
        if i >= 2 and i <= 4 then 
            local moon = moons[i-1] 
            local moonX, moonY = calculateOrbit(planetX, planetY, moon.radiusX, moon.radiusY, moon.angle)
            moon.image.x = moonX
            moon.image.y = moonY
        end
    end
end

local function updatePlanetsAndMoons()
    -- Incrementar los ángulos para la próxima iteración (para simular movimiento)
    for i = 1, #planets do
        local planet = planets[i]
        planet.angle = planet.angle + planet.speed
    end

    -- Incrementar los ángulos de las lunas para la próxima iteración
    for i = 1, #moons do
        local moon = moons[i]
        moon.angle = moon.angle + moon.speed
    end
end

sunX, sunY = display.contentCenterX, display.contentCenterY

-- Crear planetas con órbitas 
for i = 1, 8 do
    local planet = {
        radiusX = 200 + i * 50,  -- Radio en el eje X
        radiusY = 4 + i * 40,   -- Radio en el eje Y
        speed = planetSpeeds[i], -- Velocidad de rotación
        angle = planetAngles[i] -- Ángulo inicial
    }

    -- Cargar la imagen del planeta
    planet.image = display.newImage(planetNames[i])
    planet.image:scale(0.1, 0.1)

    table.insert(planets, planet)
end

-- Crear lunas para los primeros 3 planetas
for i = 2, 4 do
    local moon = {
        radiusX = moonRadiuses[i-1], -- Radio de la órbita en el eje X
        radiusY = moonRadiuses[i-1], -- Radio de la órbita en el eje Y (asumiendo órbitas circulares)
        speed = moonSpeeds[i-1], -- Velocidad de rotación
        angle = moonAngles[i-1] -- Ángulo inicial
    }

    -- Cargar la imagen de la luna
    moon.image = display.newImage(moonNames[i-1])
    moon.image:scale(0.05, 0.05)
    table.insert(moons, moon)
end

drawPlanetsAndMoons()
Runtime:addEventListener("enterFrame", function()
    updatePlanetsAndMoons()
    drawPlanetsAndMoons()
end)

local background = display.newImage("assets/fondo.png")
background.x = display.contentCenterX
background.y = display.contentCenterY
background:toBack()  

local scaleFactorX = display.actualContentWidth / background.width
local scaleFactorY = display.actualContentHeight / background.height
background:scale(scaleFactorX, scaleFactorY)

local sol = display.newImage(solI[1], sunX, sunY)
sol:scale(0.5,0.5)

local function rotateSun()
    if isSunRotating then
        sol.rotation = sol.rotation + 0.5 
    end 
end
Runtime:addEventListener("enterFrame", rotateSun)

Runtime:addEventListener("enterFrame", function()
    updatePlanetsAndMoons()
    drawPlanetsAndMoons()
end)

local function updateAndDraw()
    updatePlanetsAndMoons()
    drawPlanetsAndMoons()
end
----------------------------------------Botones

local playButton = display.newImage("assets/play.png")
playButton.x = playButton.width / 2 - 100
playButton.y = playButton.height / 2 - 100
playButton:scale(0.4,0.4)

local pauseButton = display.newImage("assets/pause.png")
pauseButton.x = pauseButton.width / 2 - 100
pauseButton.y = pauseButton.height / 2 - 100
pauseButton:scale(0.4,0.4)
pauseButton.isVisible = false
pauseButton.isHitTestable = false 

local function startAnimation()
    isSunRotating = true
    
    -- Mostrar los planetas en el centro del sol
    for i, planet in ipairs(planets) do
        planet.image.isVisible = true
        planet.image.x = sunX
        planet.image.y = sunY
    end
    
    -- Transición para mover los planetas desde el centro del sol hacia sus posiciones orbitales
    for i, planet in ipairs(planets) do
        local destinationX, destinationY = planetPositions[i].x, planetPositions[i].y
        transition.to(planet.image, {
            time = 1000, 
            x = destinationX, 
            y = destinationY, 
            transition = easing.inOutQuad
        })
    end
    
    -- Ocultar el botón de reproducción y mostrar el botón de pausa
    pauseButton.isVisible = true
    pauseButton.isHitTestable = true
    playButton.isVisible = false
    playButton.isHitTestable = false
    
    -- Iniciar la rotación del sol
    Runtime:addEventListener("enterFrame", rotateSun)
    
    -- Iniciar la animación de los planetas y las lunas
    Runtime:addEventListener("enterFrame", updateAndDraw)
end

local function pauseAnimation()

    isSunRotating = false

    for i, planet in ipairs(planets) do
        planetPositions[i] = {x = planet.image.x, y = planet.image.y}
    end

    -- Detener la animación de los planetas y las lunas
    Runtime:removeEventListener("enterFrame", updateAndDraw)
    
    -- Detener la rotación del sol
    Runtime:removeEventListener("enterFrame", rotateSun)
    sol.rotation = 0
    
    -- Mover los planetas y las lunas al centro del sol con una animación de transición
    local numPlanets = #planets
    local numMoons = #moons
    
    local function onTransitionComplete()
        -- Ocultar los planetas y las lunas después de la animación
        for i = 1, numPlanets do
            planets[i].image.isVisible = false
        end
        for i = 1, numMoons do
            moons[i].image.isVisible = false
        end
    end
    
    for i = 1, numPlanets do
        local planet = planets[i]
        transition.to(planet.image, {time = 1000, x = sunX, y = sunY, transition = easing.inOutQuad, onComplete = onTransitionComplete})
    end
    for i = 1, numMoons do
        local moon = moons[i]
        transition.to(moon.image, {time = 1000, x = sunX, y = sunY, transition = easing.inOutQuad})
    end
    
    pauseButton.isVisible = false
    pauseButton.isHitTestable = false
    playButton.isVisible = true
    playButton.isHitTestable = true
    
    Runtime:addEventListener("enterFrame", rotateSun)
end

playButton.isVisible = false
playButton.isHitTestable = false
pauseButton.isVisible = true
pauseButton.isHitTestable = true


playButton:addEventListener("tap", startAnimation)
pauseButton:addEventListener("tap", pauseAnimation)

local hideMoonsButton = display.newImage("assets/planeta.png") 
hideMoonsButton:scale(0.2,0.2)
hideMoonsButton.x = display.contentWidth - hideMoonsButton.width / 2 + 200
hideMoonsButton.y = display.contentHeight - hideMoonsButton.height / 2 - 250


hideMoonsButton.onHideMoonsButtonClick = function(event)
    for i, moon in ipairs(moons) do
        moon.image.isVisible = not moon.image.isVisible
    end
end

hideMoonsButton:addEventListener("tap", hideMoonsButton.onHideMoonsButtonClick)

local hidePlanetsButton = display.newImage("assets/planeta2.png") 
hidePlanetsButton.x = hideMoonsButton.x
hidePlanetsButton.y = hideMoonsButton.y - hideMoonsButton.height * 0.3 
hidePlanetsButton:scale(0.2, 0.2)

hidePlanetsButton.onHidePlanetsButtonClick = function(event)
    for i, planet in ipairs(planets) do
        planet.image.isVisible = not planet.image.isVisible
    end
end

hidePlanetsButton:addEventListener("tap", hidePlanetsButton.onHidePlanetsButtonClick)