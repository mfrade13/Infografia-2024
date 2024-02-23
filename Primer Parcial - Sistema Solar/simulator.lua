local composer = require( "composer" )
 
local scene = composer.newScene()

CW = display.contentWidth
CH = display.contentHeight
carpeta_recursos = "resources/"

print( CW, CH)

local offset = 55
local Xo = CW/2 + offset
local Yo = CH/2
local angule = 0
local sun, mercury, venus, earth, mars, jupiter, saturn, uranus, neptune
local pauseButton, startButton, backButton, sunButton, mercuryButton, venusButton, earthButton, marsButton, jupiterButton, saturnButton, uranusButton, neptuneButton, asteroideButton, moonButton, addAsteroidButton, deleteAsteroidButton, asteroidIcon
local planetas, asteroides, moons
local pausado = true 
local transition_expand = false
local iconX = 40
local iconY = 40

function create_moon(group, path, planet, xo, yo, sizeX, sizeY, Rx, Ry, angule, distance, rotation, speed)
    print("LUNA CREADA")
    local moon = display.newImageRect(group, carpeta_recursos .. path, sizeX, sizeY)
    moon.x = xo
    moon.y = yo
    moon.Xo = xo
    moon.Yo = yo
    moon.Rx = Rx
    moon.Ry = Ry
    moon.angule = angule
    moon.rotationMove = rotation
    moon.speed = speed
    moon.planet = string.lower(planet)
    moon.group = group
    moon.distance = distance

    return moon
end

function create_button(path, x, y, sizeX, sizeY)

    local button = display.newImageRect( grupoBotones, carpeta_recursos .. path .. ".png", sizeX, sizeY)
    button.x = x
    button.y = y

    local text = display.newText( grupoBotones, path, x + sizeX, y, "arial", 19)
    text.x = x + 35
    text.y = y
    text.anchorX = 0

    if(path == "Pause") then
        button.isVisible = false
        text.isVisible = false
    end
    return button, text
end

function draw_orbit(group, x, y)
    local punto = display.newCircle(group, x, y, 0.8)
    punto:setFillColor(0.40)
    print("GRUPO PLANETA", group.numChildren)
    return true
end

function create_planet(group, path, xo, yo, sizeX, sizeY, Rx, Ry, angule, distance, rotation, speed)
    local planet = display.newImageRect(group, carpeta_recursos .. path ..".png", sizeX, sizeY)
    planet.x = xo
    planet.y = yo
    planet.Xo = xo
    planet.Yo = yo
    planet.Rx = Rx
    planet.Ry = Ry
    planet.angule = angule
    planet.rotationMove = rotation
    planet.speed = speed
    planet.group = group
    planet.distance = distance
    planet.name = path

    if(planet.initialX == nil and planet.initialY == nil) then 
        planet.initialX = xo
        planet.initialY = yo
    end

    return planet
end

function create_asteroide(group, path, xo, yo, sizeX, sizeY, Rx, Ry, angule, distance, rotation, speed)
    local asteroid = create_planet(group, path, xo, yo, sizeX, sizeY, Rx, Ry , angule, distance, rotation, speed)
    axisRotation = math.random(0,360)
    asteroid.axisRotation = axisRotation
    return asteroid

end

--Rotation
function rotate(event)
    if (pausado == false) then
        sun.rotation = sun.rotation + 1
    
        for _,planet in pairs(planetas) do
            planet.rotation = planet.rotation + planet.rotationMove
        end

        for _,moon in pairs(moons) do
            moon.rotation = moon.rotation + moon.rotationMove
        end

        for _,asteroid in pairs(asteroides) do
            asteroid.rotation = asteroid.rotation + asteroid.rotationMove
        end
    end
end

--Eliptical Move
function get_elipse_values(xEje, yEje, Rx, Ry, angule)
    local X = xEje + Rx * math.cos(angule)
    local Y = yEje + Ry * math.sin(angule)
    
    return X, Y
end

function move_planet(event)
    if (pausado == false and transition_expand == false) then
        for k,planet in pairs(planetas) do
            local X, Y = get_elipse_values(planet.Xo, planet.Yo, planet.Rx, planet.Ry, planet.angule)
            planet.x = X
            planet.y = Y
            draw_orbit(planet.group, planet.x, planet.y)
            planet.angule = planet.angule + planet.speed
            move_moon()
        end
    end
end

function move_moon(event)
    if (pausado == false and transition_expand == false) then
        for k, moon in pairs(moons) do
            local planet = planetas[moon.planet]
            local X, Y = get_elipse_values(planet.x, planet.y, moon.Rx, moon.Ry, moon.angule + moon.distance)
            moon.x = X
            moon.y = Y
            --draw_orbit(moon.group, moon.x, planet.y)
            moon.angule = moon.angule + moon.speed
        end
    end 
end

--Eliptical Move
function get_rotated_ellipse_values(xEje, yEje, Rx, Ry, angule, axisRotation)

    local X = xEje + (Rx * Ry)/math.sqrt(Ry^2 * (math.cos(angule))^2 + Rx^2 *(math.sin(angule))^2 ) * math.cos(angule) - (Rx * Ry)/math.sqrt(Ry^2 * (math.cos(angule))^2 + Rx^2 *(math.sin(angule))^2 ) * math.sin(angule)
    local Y = yEje + (Rx * Ry)/math.sqrt(Ry^2 * (math.cos(angule))^2 + Rx^2 *(math.sin(angule))^2 ) * math.cos(angule) + (Rx * Ry)/math.sqrt(Ry^2 * (math.cos(angule))^2 + Rx^2 *(math.sin(angule))^2 ) * math.sin(angule)
    
    return X, Y
end

function move_asteroide(event)
    if (pausado == false and transition_expand == false) then
        for k,asteroid in pairs(asteroides) do
            --print(k, asteroid.x, asteroid.y)
            local X, Y = get_rotated_ellipse_values(asteroid.Xo, asteroid.Yo, asteroid.Rx, asteroid.Ry, asteroid.angule, asteroid.axisRotation)
            asteroid.x = X
            asteroid.y = Y
            draw_orbit(asteroid.group, asteroid.x, asteroid.y)
            asteroid.angule = asteroid.angule + asteroid.speed
        end
    end 
end

function change_group_visibility(group, planet_name)
    for i = group.numChildren, 1, -1 do
        local child = group[i]

        if child.name ~= planet_name then
            child.isVisible = false
        end
    end
end

function collapse_planets()
    transition_expand = true
    for k,planet in pairs(planetas) do
        planet.lastX = planet.x
        planet.lastY = planet.y
        local params = {
            time = 1000,
            x = Xo,
            y = Yo,
            xScale = 0.01,
            yScale = 0.01
        }
        transition.to( planet, params )

        for _, moon in pairs(moons) do
            if moon.group == planet.group then
                moon.lastX = moon.x
                moon.lastY = moon.y
                transition.to( moon, params )
            end
        end

        for _, asteroid in pairs(asteroides) do
            transition.to( asteroid, params )
        end

    end

    transition.to(sun, {time = 1000, xScale = 0.01, yScale = 0.01})
    change_group_visibility(groupMercury, "Mercury")
    change_group_visibility(groupVenus, "Venus")
    change_group_visibility(groupEarth, "Earth")
    change_group_visibility(groupMars, "Mars")
    change_group_visibility(groupJupiter, "Jupiter")
    change_group_visibility(groupSaturn, "Saturn")
    change_group_visibility(groupUranus, "Uranus")
    change_group_visibility(groupNeptune, "Neptune")
    change_group_visibility(groupAsteroide, "Asteroide")
end

function expand_planets()
    for k,planet in pairs(planetas) do
        
        local params = {
            time = 800,
            x = planet.lastX,
            y = planet.lastY,
            xScale = 1,
            yScale = 1,
            onComplete = function()
                transition_expand = false
            end
        }

        transition.to( planet, params )

        for k, moon in pairs(moons) do
            if moon.group == planet.group then
                local moonParams = {
                    time = 800,
                    x = moon.lastX,
                    y = moon.lastY,
                    xScale = 1,
                    yScale = 1
                }
                moon.isVisible = true
                transition.to( moon, moonParams )
            end
        end

        for _, asteroid in pairs(asteroides) do
            transition.to( asteroid, params )
        end
    end

    transition.to(sun, {time = 1000, xScale = 1, yScale = 1})

    groupMercury.isVisible = true
    groupVenus.isVisible = true
    groupEarth.isVisible = true
    groupMars.isVisible = true
    groupJupiter.isVisible = true
    groupSaturn.isVisible = true
    groupUranus.isVisible = true
    groupNeptune.isVisible = true
end

--Update Buttons Visibility
function change_status(event)
    if event.phase == "ended" then
        if (pausado == false) then
            collapse_planets()
        else
            expand_planets()
        end

        startButton.isVisible = not pausado
        textStart.isVisible = not pausado
        pauseButton.isVisible = pausado
        textPause.isVisible = pausado
        pausado = not pausado
    end
end

function set_mercury_visibility(self, event)
    print( self.alpha )
    if event.phase == "ended" then
        if(groupMercury.isVisible == true) then
            groupMercury.isVisible = false
            self.alpha = 0.6
        else
            groupMercury.isVisible = true
            self.alpha = 1
        end
    end
end

function set_venus_visibility(self, event)
    if event.phase == "ended" then
        if(groupVenus.isVisible == true) then
            groupVenus.isVisible = false
            self.alpha = 0.6
        else
            groupVenus.isVisible = true
            self.alpha = 1
        end
    end
end

function set_earth_visibility(self, event)
    if event.phase == "ended" then
        if(groupEarth.isVisible == true) then
            groupEarth.isVisible = false
            self.alpha = 0.6
        else
            groupEarth.isVisible = true
            self.alpha = 1
        end
    end
end

function set_mars_visibility(self, event)
    if event.phase == "ended" then
        if(groupMars.isVisible == true) then
            groupMars.isVisible = false
            self.alpha = 0.6
        else
            groupMars.isVisible = true
            self.alpha = 1
        end
    end
end

function set_jupiter_visibility(self, event)
    if event.phase == "ended" then
        if(groupJupiter.isVisible == true) then
            groupJupiter.isVisible = false
            self.alpha = 0.6
        else
            groupJupiter.isVisible = true
            self.alpha = 1
        end
    end
end

function set_saturno_visibility(self, event)
    if event.phase == "ended" then
        if(groupSaturn.isVisible == true) then
            groupSaturn.isVisible = false
            self.alpha = 0.6
        else
            groupSaturn.isVisible = true
            self.alpha = 1
        end
    end
end

function set_uranus_visibility(self, event)
    if event.phase == "ended" then
        if(groupUranus.isVisible == true) then
            groupUranus.isVisible = false
            self.alpha = 0.6
        else
            groupUranus.isVisible = true
            self.alpha = 1
        end
    end
end

function set_neptune_visibility(self, event)
    if event.phase == "ended" then
        if(groupNeptune.isVisible == true) then
            groupNeptune.isVisible = false
            self.alpha = 0.6
        else
            groupNeptune.isVisible = true
            self.alpha = 1
        end
    end
end

function set_asteroide_visibility(self, event)
    if event.phase == "ended" then
        if(groupAsteroide.isVisible == true) then
            groupAsteroide.isVisible = false
            self.alpha = 0.6
        else
            groupAsteroide.isVisible = true
            self.alpha = 1
        end
    end
end

function set_moon_visibility(self, event)
    if event.phase == "ended" then
        for k, moon in pairs(moons) do
            if(moon.isVisible == true) then
                moon.isVisible = false
                self.alpha = 0.6
            else
                moon.isVisible = true
                self.alpha = 1
            end
        end
        
    end
end

function create_asteroid_button(path, x, y, sizeX, sizeY)
    local button = display.newImageRect(grupoBotones, carpeta_recursos .. path .. ".png", sizeX, sizeY)
    button.x = x
    button.y = y

    return button
end

function add_asteroid(event)
    if event.phase == "ended" then 
        local xo = math.random(Xo - 20, Xo + 20)
        local yo = math.random(Yo - 20, Yo + 20)
        local Rx = math.random(100, 300)
        local Ry = math.random(100, 300)
        local angule = math.random( -200, 200 )
        local rotation = math.random(-1, 1)
        local speed = math.random(0.01, 0.09)
        local color = {math.random(), math.random(), math.random()}


        --(group, path, xo, yo, sizeX, sizeY, Rx, Ry, angule, distance, rotation, speed)
        local asteroid = create_asteroide(groupAsteroide, "Asteroide", xo, yo, CW/35, CW/60, Rx, Ry, angule, 0, rotation, speed)
        table.insert(asteroides, asteroid)
    end
end

function delete_asteroid(event)
    if #asteroides >= 1 then
        if event.phase == "ended" then 
            local deletedAsteroid = table.remove(asteroides)
            deletedAsteroid:removeSelf( )
        end
    else
        print( "Cantidad de Asteroides mínima alcanzada" )
    end
end

function got_to_menu(event)
    if event.phase == "ended" then 
        
        --Eliminar eventos
        Runtime:removeEventListener("enterFrame", rotate)
        Runtime:removeEventListener("enterFrame", move_planet)
        Runtime:removeEventListener("enterFrame", move_asteroide)

        startButton:removeEventListener( "touch",  change_status)
        pauseButton:removeEventListener( "touch",  change_status)
        backButton:removeEventListener( "touch",  got_to_menu)
        addAsteroidButton:removeEventListener( "touch", add_asteroid )
        deleteAsteroidButton:removeEventListener("touch", delete_asteroid)

        mercuryButton:removeEventListener("touch", mercuryButton)
        venusButton:removeEventListener("touch", venusButton)
        earthButton:removeEventListener("touch", earthButton)
        marsButton:removeEventListener("touch", marsButton)
        jupiterButton:removeEventListener("touch", jupiterButton)
        saturnButton:removeEventListener("touch", saturnButton)
        uranusButton:removeEventListener("touch", uranusButton)
        neptuneButton:removeEventListener("touch", neptuneButton)
        moonButton:removeEventListener("touch", moonButton)
        asteroideButton:removeEventListener("touch", asteroideButton)

        --composer.removeScene( "simulator")
        

        local options = {
            effect = "slideRight",
            time = 1000
        }
        composer.gotoScene( "menu", options )
    end
    return true
end

-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    print("Simulator")

    groupMercury = display.newGroup( )
    sceneGroup:insert(groupMercury)

    groupVenus = display.newGroup( )
    sceneGroup:insert(groupVenus)

    groupEarth = display.newGroup( )
    sceneGroup:insert(groupEarth)

    groupMars = display.newGroup( )
    sceneGroup:insert(groupMars)

    groupJupiter = display.newGroup( )
    sceneGroup:insert(groupJupiter)

    groupSaturn = display.newGroup()
    sceneGroup:insert(groupSaturn)

    groupUranus = display.newGroup( )
    sceneGroup:insert(groupUranus)

    groupNeptune = display.newGroup( )
    sceneGroup:insert(groupNeptune)

    groupAsteroide = display.newGroup( )
    sceneGroup:insert(groupAsteroide)

    grupoBotones = display.newGroup( )
    sceneGroup:insert(grupoBotones)

    groupSun = display.newGroup( )
    sceneGroup:insert(groupSun)

    sun = display.newImageRect(groupSun, carpeta_recursos .. "Sun1.png", CW/12, CW/12)
    sun.x = Xo
    sun.y = Yo


    planetas = {
        mercury = create_planet(groupMercury, "Mercury", Xo, Yo, CW/70, CW/70, 90, 45, 0, 65, 0.9, 0.04),
        venus = create_planet(groupVenus, "Venus", Xo, Yo, CW/50, CW/50, 120, 105, 0, 90, 0.60, 0.031),
        earth = create_planet(groupEarth, "Earth", Xo, Yo, CW/40, CW/40, 170, 150, 0, 125, 0.53, 0.02),
        mars = create_planet(groupMars, "Mars", Xo, Yo, CW/45, CW/45, 220, 190, 0, 160, 0.30, 0.01),
        jupiter = create_planet(groupJupiter, "Jupiter", Xo, Yo, CW/15, CW/15, 280, 240, 0, 230, 0.22, 0.009),
        saturn = create_planet(groupSaturn, "Saturn", Xo, Yo, CW/27, CW/42, 320, 270, 0, 310, 0.14, 0.006),
        uranus = create_planet(groupUranus, "Uranus", Xo, Yo, CW/20, CW/35, 360, 310, 0, 380, 0.10, 0.0048),
        neptune = create_planet(groupNeptune, "Neptune", Xo, Yo, CW/21, CW/20, 410, 350, 0, 450, 0.08, 0.0029)
    }

    moons = {
        --(group, path, planet, xo, yo, sizeX, sizeY, Rx, Ry, angule, distance, rotation, speed)
        moonEarth = create_moon(groupEarth, "Moon.png", "Earth", planetas["earth"].x, planetas["earth"].y, CW/120, CW/120, 35, 20, 0, 25, 0.09, 0.02),
        moonMars1 = create_moon(groupMars, "Moon.png", "Mars", planetas["mars"].x, planetas["mars"].y, CW/90, CW/90, 35, 20, 0, 20, 0.08, 0.01),
        moonMars2 = create_moon(groupMars, "Moon.png", "Mars", planetas["mars"].x, planetas["mars"].y, CW/100, CW/100, 35, 20, 190, 22, 0.08, 0.01 ),
        moonUranus = create_moon(groupUranus, "Moon.png", "Uranus", planetas["uranus"].x, planetas["uranus"].y, CW/150, CW/150, 35, 20, 0, 70, 0.1, 0.006),
        moonNeptune = create_moon(groupNeptune, "Moon.png", "Neptune", planetas["neptune"].x, planetas["neptune"].y, CW/70, CW/70, 82, 45, 0, 85, 0.2, 0.008)
    }


    asteroides = {
        --(group, path, xo, yo, sizeX, sizeY, Rx, Ry, angule, distance, rotation, speed)
        asteroide = create_asteroide(groupAsteroide, "Asteroide", Xo, Yo, CW/35, CW/60, 100, 280, 55, 0, -0.5, 0.015)
    }

    local i = CH/17.5
    local j = CH/14
    local y = CW/25

    backButton = create_button("Back", CW/25, i + j , iconX, iconY)
    pauseButton, textPause = create_button("Pause", CW/25,  i + j *2, iconX, iconY)
    startButton, textStart = create_button("Play", CW/25,  i + j *2, iconX, iconY)
    mercuryButton = create_button("Mercury", CW/25, i + j *3, iconX, iconY)
    venusButton = create_button("Venus", CW/25, i + j *4, iconX, iconY)
    earthButton = create_button("Earth", CW/25, i + j *5, iconX, iconY)
    marsButton = create_button("Mars", CW/25, i + j *6, iconX, iconY)
    jupiterButton = create_button("Jupiter", CW/25, i + j *7, iconX, iconY)
    saturnButton = create_button("Saturn", CW/25, i + j *8, 60, iconX, iconY)
    uranusButton = create_button("Uranus", CW/25, i + j *9, 65, iconX, iconY)
    neptuneButton = create_button("Neptune", CW/25, i + j *10, iconX, iconY)
    moonButton = create_button("Moon", CW/25, i + j *11, iconX, iconY)
    asteroideButton = create_button("Asteroide", CW/25, i + j *12, iconX, iconY)


    --ADD RANDOM ASTEROIDS BUTTONS

    asteroidIcon = create_asteroid_button("Asteroide", CW - CW/23*3, i + j , iconX, iconY)
    addAsteroidButton = create_asteroid_button("Add", CW - CW/23*2, i + j , iconX, iconY)
    deleteAsteroidButton = create_asteroid_button("Delete", CW - CW/25, i + j , iconX - 5, iconY - 5)
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen

            mercuryButton.touch = set_mercury_visibility
            mercuryButton:addEventListener( "touch", mercuryButton)
            venusButton.touch = set_venus_visibility
            venusButton:addEventListener( "touch", venusButton)
            earthButton.touch = set_earth_visibility
            earthButton:addEventListener( "touch", earthButton)
            marsButton.touch = set_mars_visibility
            marsButton:addEventListener( "touch", marsButton)
            jupiterButton.touch = set_jupiter_visibility
            jupiterButton:addEventListener( "touch", jupiterButton)
            saturnButton.touch = set_saturno_visibility
            saturnButton:addEventListener( "touch", saturnButton)
            uranusButton.touch = set_uranus_visibility
            uranusButton:addEventListener( "touch", uranusButton)
            neptuneButton.touch = set_neptune_visibility
            neptuneButton:addEventListener( "touch", neptuneButton)
            moonButton.touch = set_moon_visibility
            moonButton:addEventListener( "touch", moonButton )
            asteroideButton.touch = set_asteroide_visibility
            asteroideButton:addEventListener( "touch", asteroideButton)

            startButton:addEventListener( "touch",  change_status)
            pauseButton:addEventListener( "touch",  change_status)
            backButton:addEventListener( "touch",  got_to_menu)
            addAsteroidButton:addEventListener( "touch", add_asteroid )
            deleteAsteroidButton:addEventListener("touch", delete_asteroid)

            Runtime:addEventListener("enterFrame",  rotate)
            Runtime:addEventListener( "enterFrame", move_planet)
            Runtime:addEventListener( "enterFrame", move_asteroide)
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