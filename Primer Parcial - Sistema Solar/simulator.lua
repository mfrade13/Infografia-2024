local composer = require( "composer" )
 
local scene = composer.newScene()

CW = display.contentWidth
CH = display.contentHeight
carpeta_recursos = "resources/"

print( CW, CH )

local Xo = CW/2
local Yo = CH/2
local angule = 0
local betha = 45
local sun, mercury, venus, earth, mars, jupiter, saturn, uranus, neptune
local pauseButton, startButton, sunButton, mercuryButton, venusButton, earthButton, marsButton, jupiterButton, saturnButton, uranusButton, neptuneButton, asteroideButton
local planetas, asteroides, moons
local pausado = true 
local transition_expand = false
local iconX = 30
local iconY = 30

function draw_background()
    print( "Creando Fondo" )
    local star = display.newCircle(groupBackground, math.random(0, CW), math.random(0, CH), math.random(0.1, 2))
    star.x = math.random(35, CW-35)
    star.y = math.random(35, CH-35)
    transition.to(star, {x=math.random(0,CW), y=math.random(0,CH), time=100})
end

function create_moon(group, path, planet, xo, yo, sizeX, sizeY, Rx, Ry, angule, distance, rotation, speed)
    print("LUNA CREADA")
    local moon = display.newImageRect(group, carpeta_recursos .. path, sizeX, sizeY)
    moon.x = xo + distance
    moon.y = yo
    moon.Xo = xo
    moon.Yo = yo
    moon.Rx = Rx
    moon.Ry = Ry
    moon.angule = angule
    moon.rotationMove = rotation
    moon.speed = speed
    moon.planet = string.lower(planet)
    moon.name = planet
    moon.group = group
    print("Distance:", distance)

    return moon
end

function create_button(path, x, y, sizeX, sizeY)

    local button = display.newImageRect( grupoBotones, carpeta_recursos .. path .. ".png", sizeX, sizeY)
    button.x = x
    button.y = y

    local text = display.newText( grupoBotones, path, x + sizeX, y, "arial", 18)
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
    punto:toBack( )
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
        for _, moon in pairs(moons) do
            local planet = planetas[moon.planet]
            print("MOOOON   Distance:", moon.distance)
            local newX, newY = get_elipse_values(planet.x, planet.y, planet.Rx, planet.Ry, planet.angule + 15)
            local rotationOffsetX = 15 * math.cos(moon.angule)
            local rotationOffsetY = 15 * math.sin(moon.angule)
            moon.x = newX + rotationOffsetX
            moon.y = newY + rotationOffsetY
            moon.angule = moon.angule + moon.speed
        end
    end 
end

--Eliptical Move
function get_rotated_ellipse_values(xEje, yEje, Rx, Ry, angule, axisRotation)
    local xAxis = xEje * math.cos(axisRotation) - yEje * math.sin(axisRotation)
    local yAxis = xEje * math.sin(axisRotation) + yEje * math.cos(axisRotation)

    local X = xAxis + Rx * math.cos(angule)
    local Y = yAxis + Ry * math.sin(angule)

    return X, Y
end

function move_asteroide(event)
    if (pausado == false and transition_expand == false) then
        for k,asteroid in pairs(asteroides) do
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
            time = 600,
            x = Xo,
            y = Yo,
            xScale = 0.01,
            yScale = 0.01
        }
        transition.to( planet, params )
        
        for _, moon in pairs(moons) do
            if moon.group == planet.group then
                transition.to( moon, params )
            end
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
            time = 600,
            x = planet.lastX,
            y = planet.lastY,
            xScale = 1,
            yScale = 1,
            onComplete = function()
                transition_expand = false
            end
        }

        transition.to( planet, params )

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

function set_planet_buttons()
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
    asteroideButton.touch = set_asteroide_visibility
    asteroideButton:addEventListener( "touch", asteroideButton)
end


-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    print("Simulator")

    groupBackground = display.newGroup( )
    sceneGroup:insert(groupBackground)

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
        mercury = create_planet(groupMercury, "Mercury", Xo, Yo, CW/70, CW/70, 100, 60, 0, 65, 0.9, 0.04),
        venus = create_planet(groupVenus, "Venus", Xo, Yo, CW/50, CW/50, 120, 115, 0, 90, 0.60, 0.031),
        earth = create_planet(groupEarth, "Earth", Xo, Yo, CW/40, CW/40, 170, 150, 0, 125, 0.53, 0.02),
        mars = create_planet(groupMars, "Mars", Xo, Yo, CW/45, CW/45, 250, 190, 0, 160, 0.30, 0.01),
        jupiter = create_planet(groupJupiter, "Jupiter", Xo, Yo, CW/15, CW/15, 300, 240, 0, 230, 0.22, 0.009),
        saturn = create_planet(groupSaturn, "Saturn", Xo, Yo, CW/25, CW/40,340, 290, 0, 310, 0.14, 0.006),
        uranus = create_planet(groupUranus, "Uranus", Xo, Yo, CW/20, CW/35, 380, 330, 0, 380, 0.10, 0.0045),
        neptune = create_planet(groupNeptune, "Neptune", Xo, Yo, CW/21, CW/20, 420, 350, 0, 450, 0.08, 0.0025)
        ,asteroide = create_asteroide(groupAsteroide, "Asteroide", Xo, Yo, CW/33, CW/80, 250, 250, 0, 300, 0.7, 0.02)
    }

    moons = {
        --(group, path, xo, yo, sizeX, sizeY, Rx, Ry, angule, distance, rotation, speed)
        moonEarth = create_moon(groupEarth, "Moon.png", "Earth", planetas["earth"].x, planetas["earth"].y, CW/90, CW/90, 35, 20, 0, 20, 0.08, 0.02),
        moonMars1 = create_moon(groupMars, "Moon.png", "Mars", planetas["mars"].x, planetas["mars"].y, CW/90, CW/90, 35, 20, 0, 20, 0.08, 0.01),
        moonMars2 = create_moon(groupMars, "Moon.png", "Mars", planetas["mars"].x, planetas["mars"].y, CW/90, CW/90, 35, 20, 1, 20, 0.08, 0.01 ),
        moonUranus = create_moon(groupUranus, "Moon.png", "Uranus", planetas["uranus"].x, planetas["uranus"].y, CW/90, CW/90, 35, 20, 0, 20, 0.08, 0.0025)
    }


    --asteroides = {
    --    asteroide = create_asteroide(groupAsteroide, "Asteroide", Xo, Yo, CW/33, CW/80, 100, 390, 45, 0, -0.5, 0.05)
    --}

    --collapse_planets()

    pauseButton, textPause = create_button("Pause", CW/25,  CH/7, iconX, iconY)
    startButton, textStart = create_button("Play", CW/25,  CH/7, iconX, iconY)
    mercuryButton = create_button("Mercury", CW/25, CH/7 + 60, iconX, iconY)
    venusButton = create_button("Venus", CW/25, CH/7 + 60*2, iconX, iconY)
    earthButton = create_button("Earth", CW/25, CH/7 + 60*3, iconX, iconY)
    marsButton = create_button("Mars", CW/25, CH/7 + 60*4, iconX, iconY)
    jupiterButton = create_button("Jupiter", CW/25, CH/7 + 60*5, iconX, iconY)
    saturnButton = create_button("Saturn", CW/25, CH/7 + 60*6, 60, iconY)
    uranusButton = create_button("Uranus", CW/25, CH/7 + 60*7, 65, iconY)
    neptuneButton = create_button("Neptune", CW/25, CH/7 + 60*8, iconX, iconY)
    asteroideButton = create_button("Asteroide", CW/25, CH/7 + 60*9, iconX, iconY)

    startButton:addEventListener( "touch",  change_status)
    pauseButton:addEventListener( "touch",  change_status)

    set_planet_buttons()

    Runtime:addEventListener("enterFrame",  rotate)
    Runtime:addEventListener( "enterFrame", move_planet)
   -- Runtime:addEventListener( "enterFrame", move_asteroide)

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