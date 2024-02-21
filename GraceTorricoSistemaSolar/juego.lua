local composer = require( "composer" )
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
 
local mainpath = "resources/"
local CW = display.contentWidth
local CH = display.contentHeight
local fondo, play, stop
local sol
local isPlaying = false
local mainOrbits = {}
local mainMoons = {}
local showingMoons = false
local orbits = {}
local orbit
local planetsButtonGroup
local planetsAuxButtons = {}
local planets
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
 function setMainScenario()
    fondo = display.newImageRect(mainpath.."bckg.jpg",CW,CH)
    fondo.anchorX=0; fondo.anchorY=0
    fondo.alpha=1
    planets = {"mercurio", "venus", "tierra", "marte", "jupiter", "saturno", "urano", "neptuno"}
    play = display.newImageRect(mainpath.."play.png", 60, 60)
    play.x = 50; play.y = 720
    play:addEventListener("touch", pressPlay)
    stop = display.newImageRect(mainpath.."stop.png", 60, 60)
    stop.x = 120; stop.y = 720
    stop:addEventListener("touch", pressStop)
    createButtons()
    createAuxiliaryButtons()
    createPlanets()
    local s = 20
    mainOrbits = {
        mercurio = {a = 270, b = 100 - s, theta = math.pi, center = sol},
        venus = {a = 300, b = 120 - s, theta = math.pi + 1, center = sol},
        tierra = {a = 330, b = 140 - s, theta = math.pi + 1.5, center = sol},
        marte = {a = 360, b = 160 - s, theta = math.pi + 2, center = sol},
        jupiter = {a = 390, b = 180 - s, theta = math.pi + 2.5, center = sol},
        saturno = {a = 420, b = 200 - s, theta = math.pi + 3, center = sol},
        urano = {a = 450, b = 220 - s, theta = math.pi + 3.5, center = sol},
        neptuno = {a = 480, b = 240 - s, theta = math.pi + 4, center = sol}
    }
    
    createOrbits()
    createMoons()
end

function createButtons()
    planetsButtonGroup = display.newGroup()

    local btnWidth = 80
    local btnHeight = 40
    local startX = play.x + 170
    local gapX = 100

    for i, planet in ipairs(planets) do
        local btn = display.newImageRect(mainpath.."button_"..planet..".png", btnWidth, btnHeight)
        btn.x = play.x + 70
        btn.y=play.y + 70
        btn.initX = startX + (i - 1) * gapX
        btn.initY =play.y
        btn.isVisible = false
        planetsButtonGroup:insert(btn)
        btn:addEventListener("touch", function(event)
            if event.phase == "ended" then
                local planetButtonSet = planetsAuxButtons[planet]
                for _, auxBtn in ipairs(planetButtonSet) do
                    auxBtn.isVisible = not auxBtn.isVisible
                end
            end
        end)
    end
end

function createAuxiliaryButton(planet, imagePath, posX, posY, initPosX, initPosY, onTouch)
    local btnWidth = 30
    local btnHeight = 30
    local btn = display.newImageRect(mainpath..imagePath, btnWidth, btnHeight)
    btn.x = posX
    btn.y = posY
    btn.initX = initPosX
    btn.initY = initPosY
    btn.isVisible = false
    btn.pressed = false
    planetsButtonGroup:insert(btn)
    btn:addEventListener("touch", onTouch)

    if not planetsAuxButtons[planet] then
        planetsAuxButtons[planet] = {}
    end
    
    table.insert(planetsAuxButtons[planet], btn)
    return btn
end

function createAuxiliaryButtons()
    local btnStartX = play.x + 145
    local startY = 720
    local gapX = 100
    local x = play.x + 70
    local y = play.y + 70

    for i, planet in ipairs(planets) do
        local initX = btnStartX + (i - 1) * gapX
        local initY = startY - 40

        local btnPlanet = createAuxiliaryButton(planet, planet:gsub("^%l", string.upper)..".png", x, y, initX, initY, function(event)
            if event.phase == "ended" then
                local planetObject = _G[planet]
                if planetObject then
                    planetObject.isVisible = not planetObject.isVisible
                end
            end
        end)

        local btnOrbit = createAuxiliaryButton(planet,"pencil.png", x, y, initX + 30, initY, function(event)
            local orbitP = orbits[planet]
            if event.phase == "ended" then
                if orbitP then
                    orbitP.isVisible = not orbitP.isVisible
                end
            end
        end)

        local btnMoon = createAuxiliaryButton(planet,"Luna.png", x, y, initX + 60, initY, function(event)
            if event.phase == "ended" then
                local btn = event.target
                btn.pressed = not btn.pressed
                if btn.pressed then
                    removeMoonsFromPlanet(planet)
                else
                    addMoon(planet)
                end
            end
        end)
    end
end

function toggleMoonVisibility(planet)
    if mainMoons[planet] then
        for _, moon in ipairs(mainMoons[planet]) do
            moon.isVisible = not moon.isVisible
        end
    end
end

function showPlanetsButtons()
    for i = 1, planetsButtonGroup.numChildren do
        local btn = planetsButtonGroup[i]
        transition.to(btn, {x = btn.initX, y = btn.initY, time = 2000})
        btn.isVisible = true
    end
    toggleAuxiliaryButtonsVisibility(false)
end

function movePlanetsButtonsToCenter()
    for i = 1, planetsButtonGroup.numChildren do
        local btn = planetsButtonGroup[i]
        transition.to(btn, {x = play.x, y = play.y, time = 2000})
    end
    timer.performWithDelay(2000, function()
        for i = 1, planetsButtonGroup.numChildren do
            planetsButtonGroup[i].isVisible = false
        end
    end)
end

function toggleAuxiliaryButtonsVisibility(visible)
    for _, planet in ipairs(planets) do
        local planetButtonSet = planetsAuxButtons[planet]
        for _, auxBtn in ipairs(planetButtonSet) do
            auxBtn.isVisible = visible
        end
    end
end

function pressPlay()
    if not isPlaying then
        toggleAuxiliaryButtonsVisibility(false)
        Runtime:addEventListener("enterFrame", rotate)
        bigBang()
        isPlaying = true 
        showPlanetsButtons()
    end
end

function createPlanets()
    sol = display.newImageRect(mainpath.."Sol1.png", 200, 200)
    mercurio = display.newImageRect(mainpath.."Mercurio.png", 70, 70)
    venus = display.newImageRect(mainpath.."Venus.png", 70, 70)
    tierra = display.newImageRect(mainpath.."Tierra.png", 70, 70)
    marte = display.newImageRect(mainpath.."Marte.png", 70, 70)
    jupiter = display.newImageRect(mainpath.."Jupiter.png", 70, 70)
    saturno = display.newImageRect(mainpath.."Saturno.png", 130, 70)
    urano = display.newImageRect(mainpath.."Urano.png", 70, 70)
    neptuno = display.newImageRect(mainpath.."Neptuno.png", 70, 70)
end

function placePlanets()
    transition.to(sol, { x=CW/2, y=60, time=2000 })
    transition.to(mercurio, { x=250, y=100, time=2000 })
    transition.to(venus, { x=850, y=100, time=2000 })
    transition.to(tierra, { x=250, y=100, time=2000 })
    transition.to(marte, { x=850, y=100, time=2000 })
    transition.to(jupiter, { x=250, y=100, time=2000 })
    transition.to(saturno, { x=850, y=100, time=2000 })
    transition.to(urano, { x=250, y=100, time=2000 })
    transition.to(neptuno, { x=840, y=100, time=2000 })
end

function bigBang()
    local s = 20
    local t = system.getTimer() * 0.001
    transition.to(sol, {x = CW / 2, y = CH / 2 - 50, time = 2000})
    transition.to(mercurio, {x = CW / 2 + 270 * math.cos(math.pi + t), y = CH / 2 - (100 - s) * math.sin(math.pi + t), time = 2000})
    transition.to(venus, {x = CW / 2 + 300 * math.cos(math.pi + 1 + t), y = CH / 2 - (120 - s) * math.sin(math.pi + 1 + t), time = 2000})
    transition.to(tierra, {x = CW / 2 + 330 * math.cos(math.pi + 1.5 + t), y = CH / 2 - (140 - s) * math.sin(math.pi + 1.5 + t), time = 2000})
    transition.to(marte, {x = CW / 2 + 360 * math.cos(math.pi + 2 + t), y = CH / 2 - (160 - s) * math.sin(math.pi + 2 + t), time = 2000})
    transition.to(jupiter, {x = CW / 2 + 390 * math.cos(math.pi + 2.5 + t), y = CH / 2 - (180 - s) * math.sin(math.pi + 2.5 + t), time = 2000})
    transition.to(saturno, {x = CW / 2 + 420 * math.cos(math.pi + 3 + t), y = CH / 2 - (200 - s) * math.sin(math.pi + 3 + t), time = 2000})
    transition.to(urano, {x = CW / 2 + 450 * math.cos(math.pi + 3.5 + t), y = CH / 2 - (220 - s) * math.sin(math.pi + 3.5 + t), time = 2000})
    transition.to(neptuno, {x = CW / 2 + 480 * math.cos(math.pi + 4 + t), y = CH / 2 - (240 - s) * math.sin(math.pi + 4 + t), time = 2000, onComplete = start})
end


function addMoon(planet)
    local moon = display.newImageRect(mainpath.."Luna.png", 20, 20)
    moon.planet = planet  
    local planetObject = _G[planet]
    if planetObject then
        moon.x = planetObject.x + 30  
        moon.y = planetObject.y - 30 
        moon.theta = math.random()
        if not mainMoons[planet] then
            mainMoons[planet] = {}  
        end
        table.insert(mainMoons[planet], moon)  
    end
end

function createMoons()

    for planet, _ in pairs(mainOrbits) do
        addMoon(planet)
    end
end

function moveMoon(planet)
    local planetObject = _G[planet]
    local moons = mainMoons[planet]
    if moons and planetObject then
        local t = system.getTimer() * 0.003
        for _, moon in ipairs(moons) do 
            if moon.isVisible then  
                local x = planetObject.x + 70 * math.cos(moon.theta + t)
                local y = planetObject.y - 30 * math.sin(moon.theta + t)
                moon.x = x ; moon.y = y
                t = t + 0.1
            end
        end
    end
end


function movePlanet(planet)
    local orbit = orbits[planet]
    local t = system.getTimer() * 0.001
    local x = orbit.center.x + orbit.a * math.cos(orbit.theta + t)
    local y = orbit.center.y - orbit.b * math.sin(orbit.theta + t)
    local planetObject = _G[planet]

    if planetObject then    
        planetObject.x = x 
        planetObject.y = y
        planetObject:toFront()
    end
end

function createOrbit(a, b, theta, center)
    orbit = display.newLine(0, 0, 0, 0)
    orbit:setStrokeColor(math.random(), math.random(), math.random())
    orbit.strokeWidth = 4
    orbit.a = a
    orbit.b = b
    orbit.theta = theta
    orbit.center = center
    return orbit
end

function createOrbits()
    for planet, data in pairs(mainOrbits) do
        orbits[planet] = createOrbit(data.a, data.b, data.theta, data.center)
    end
end

function updateOrbits()
    for _, orbit in pairs(orbits) do
        local t = system.getTimer() * 0.001
        local x = orbit.center.x + orbit.a * math.cos(orbit.theta + t) 
        local y = orbit.center.y - orbit.b * math.sin(orbit.theta + t) 
        orbit:append(x, y)
    end
end

function move(e)
    showingMoons = true
    moonVisibility()
    for planet, _ in pairs(mainOrbits) do
        movePlanet(planet)
        moveMoon(planet)
    end
    print(e.time)
end

function rotate()
    sol.rotation = sol.rotation+1
    mercurio.rotation = mercurio.rotation-1
    venus.rotation = venus.rotation+1
    tierra.rotation = tierra.rotation-1
    marte.rotation = marte.rotation+1
    jupiter.rotation = jupiter.rotation-1
    saturno.rotation = saturno.rotation+1
    urano.rotation = urano.rotation-1
    neptuno.rotation = neptuno.rotation+1
end

function removeMoonsFromPlanet(planet)
    if mainMoons[planet] then
        for i = #mainMoons[planet], 1, -1 do
            mainMoons[planet][i]:removeSelf()
            table.remove(mainMoons[planet], i)
        end
    end
end

function removeAllMoons()
    for planet, moons in pairs(mainMoons) do
        for i = #moons, 1, -1 do
            moons[i]:removeSelf()
            table.remove(moons, i)
        end
    end
end

function moonVisibility()
    for _, moons in pairs(mainMoons) do
        for _, moon in ipairs(moons) do
            moon.isVisible = showingMoons
        end
    end
end


function start()
    createOrbits()
    Runtime:addEventListener("enterFrame", updateOrbits)
    Runtime:addEventListener("enterFrame", move)
    sol:toFront()
end

function pressStop(event)
    if move then
        Runtime:removeEventListener("enterFrame", move)
        Runtime:removeEventListener("enterFrame", rotate)
        Runtime:removeEventListener("enterFrame", updateOrbits)
        sol:toFront()

        for _, orbit in pairs(orbits) do
            orbit:removeSelf()
        end
        orbits = {}
        showingMoons = false
        moonVisibility()
    end
    transition.cancel()
    placePlanets()
    movePlanetsButtonsToCenter()
    isPlaying = false
    toggleAuxiliaryButtonsVisibility(false)
end

-- create()
function scene:create( event )
    setMainScenario()
    placePlanets()
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