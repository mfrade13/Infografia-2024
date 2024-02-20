-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local mainpath = "resources/"
local CW = display.contentWidth
local CH = display.contentHeight
local fondo, play, stop
local sol, mercurio
local isPlaying = false
local orbits = {}
local orbit

function setMainScenario()
	fondo = display.newImageRect(mainpath.."bckg.jpg",CW,CH)
	fondo.anchorX=0; fondo.anchorY=0
	fondo.alpha=1

	play = display.newImageRect(mainpath.."play.png", 100, 100)
	play.x = 700; play.y = 700
	play:addEventListener("touch", pressPlay)
	stop = display.newImageRect(mainpath.."stop.png", 100, 100)
	stop.x = 900; stop.y = 700
	stop:addEventListener("touch", pressStop)
	createPlanets()
	createOrbits()
end

function pressPlay()
	if not isPlaying then --Preguntar por condicion
		Runtime:addEventListener("enterFrame", rotate)
		bigBang()
		isPlaying = true --Preguntar al inge si el control de doble click en play esta bien
	end
end

function createPlanets()
	sol = display.newImageRect(mainpath.."Sol1.png", 200, 200)
	mercurio = display.newImageRect(mainpath.."Mercurio.png", 100, 100)
	venus = display.newImageRect(mainpath.."Venus.png", 100, 100)
	tierra = display.newImageRect(mainpath.."Tierra.png", 100, 100)
	marte = display.newImageRect(mainpath.."Marte.png", 100, 100)
	jupiter = display.newImageRect(mainpath.."Jupiter.png", 100, 100)
	saturno = display.newImageRect(mainpath.."Saturno.png", 170, 100)
	urano = display.newImageRect(mainpath.."Urano.png", 100, 100)
	neptuno = display.newImageRect(mainpath.."Neptuno.png", 100, 100)
	luna = display.newImageRect(mainpath.."Luna.png",30,30)
end

function placePlanets()
	transition.to(sol, { x=CW/2, y=270, time=2000 })
	transition.to(mercurio, { x=250, y=100, time=2000 })
	transition.to(venus, { x=850, y=100, time=2000 })
	transition.to(tierra, { x=250, y=100, time=2000 })
	transition.to(marte, { x=850, y=100, time=2000 })
	transition.to(jupiter, { x=250, y=100, time=2000 })
	transition.to(saturno, { x=850, y=100, time=2000 })
	transition.to(urano, { x=250, y=100, time=2000 })
	transition.to(neptuno, { x=840, y=100, time=2000 })
	transition.to(luna,{ x=850, y=100, time=2000})
end

function bigBang()
    transition.to(sol, {x= CW/2, y=CH/2, time=2000})
    transition.to(mercurio, {x= sol.x + 250 * math.cos(math.rad(45)) * math.cos(math.pi / 4) - 100 * math.sin(math.rad(45)) * math.sin(math.pi / 4), y= sol.y - 250 * math.cos(math.rad(45)) * math.cos(math.pi / 4) + 100 * math.sin(math.rad(45)) * math.sin(math.pi / 4), time=2000})
    transition.to(venus, {x= 700, y=300, time=2000})
	transition.to(tierra, {x= 340, y=550, time=2000})
	transition.to(marte, {x= 400, y=100, time=2000})
	transition.to(jupiter, {x= 100, y=570, time=2000})
	transition.to(saturno, {x= 340, y=700, time=2000})
	transition.to(urano, {x=670, y=500, time=2000})
	transition.to(luna,{x= 400, y=100, time=2000})
	transition.to(neptuno, {x=800, y=630, time=2000, onComplete=start})
end

function moveMercurio()
    local a = 250  
    local b = 100  
    t = system.getTimer() * 0.001   
    initialAngle = math.pi / 4
    local theta = math.rad(45) 
    mercurio.x = sol.x + a * math.cos(theta) * math.cos(initialAngle + t) - b * math.sin(theta) * math.sin(initialAngle + t)
    mercurio.y = sol.y - a * math.sin(theta) * math.cos(initialAngle + t) + b * math.cos(theta) * math.sin(initialAngle + t)
end

function moveVenus()
    local a = 380 
    local b = 200 
    t = system.getTimer() * 0.001
    initialAngle = math.pi + 30
    local theta = math.rad(75) 
    venus.x = sol.x + a * math.cos(theta) * math.cos(initialAngle + t) - b * math.sin(theta) * math.sin(initialAngle + t)
    venus.y = sol.y - a * math.sin(theta) * math.cos(initialAngle + t) + b * math.cos(theta) * math.sin(initialAngle + t)
end

function moveTierra()
    local a = 380 
    local b = 250 
    t = system.getTimer() * 0.001
    initialAngle = math.pi / 3
    local theta = math.rad(30)  
    tierra.x = sol.x + a * math.cos(theta) * math.cos(initialAngle + t) - b * math.sin(theta) * math.sin(initialAngle + t)
    tierra.y = sol.y - a * math.sin(theta) * math.cos(initialAngle + t) + b * math.cos(theta) * math.sin(initialAngle + t)
end

function moveMarte()
    local a = 550 
    local b = 350 
    t = system.getTimer() * 0.001
    initialAngle = math.pi / 4
    local theta = math.rad(45)  -- inclinación en radianes
    marte.x = sol.x + a * math.cos(initialAngle + t)
    marte.y = sol.y - b * math.sin(initialAngle + t) 
end

function moveJupiter()
    local a = 200 
    local b = 370 
    t = system.getTimer() * 0.001
    initialAngle = math.pi / 1
    local theta = math.rad(45)  -- inclinación en radianes
    jupiter.x = sol.x + a * math.cos(initialAngle + t)
    jupiter.y = sol.y - b * math.sin(initialAngle + t) 
end

function moveSaturno() --Se queda como esta
    local a = 270 
    local b = 50 
    t = system.getTimer() * 0.001
    initialAngle = math.pi / 2
    saturno.x = sol.x + a * math.cos(initialAngle + t)
    saturno.y = sol.y - b * math.sin(initialAngle + t) 
end

function moveUrano()
    local a = 400 
    local b = 350 
    t = system.getTimer() * 0.001
    initialAngle = math.pi / 3
    local theta = math.rad(20)  -- inclinación en radianes
    urano.x = sol.x + a * math.cos(initialAngle + t)
    urano.y = sol.y - b * math.sin(initialAngle + t) 
end

function moveNeptuno()
    local a = 450 
    local b = 250 
    t = system.getTimer() * 0.001
    initialAngle = math.pi
    local theta = math.rad(40)  -- inclinación en radianes
    neptuno.x = sol.x + a * math.cos(initialAngle + t)
    neptuno.y = sol.y - b * math.sin(initialAngle + t) 
end

function moveLuna()
	local a = 70 
    local b = 30 
    t = system.getTimer() * 0.001
    initialAngle = math.pi / 4
    local theta = math.rad(45)  
    luna.x = marte.x + a * math.cos(initialAngle + t)
    luna.y = marte.y - b * math.sin(initialAngle + t) 
end

function createOrbit(a, b, theta)
    orbit = display.newLine(0, 0, 0, 0)
    orbit:setStrokeColor(math.random(), math.random(), math.random())
    orbit.strokeWidth = 4
    orbit.a = a
    orbit.b = b
    orbit.theta = theta
    return orbit
end

function createOrbits()
    orbits.venus= createOrbit(380, 200, math.rad(75))
end

function updateOrbits()
    for _, orbit in pairs(orbits) do
        local t = system.getTimer() * 0.001
        local x = sol.x + orbit.a * math.cos(orbit.theta) * math.cos(t) - orbit.b * math.sin(orbit.theta) * math.sin(t)
        local y = sol.y - orbit.a * math.sin(orbit.theta) * math.cos(t) + orbit.b * math.cos(orbit.theta) * math.sin(t)
        orbit:append(x, y)
    end
end
function move()
	moveMercurio() --Preguntar donde poner moveMercurio
	moveJupiter()
	moveMarte()
	moveMercurio()
	moveNeptuno()
	moveSaturno()
	moveTierra()
	moveUrano()
	moveVenus()
	moveLuna()
	--return true
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

function start()
	Runtime:addEventListener("enterFrame", move)
	--Runtime:addEventListener("enterFrame", updateOrbits)
end

function pressStop(event)
	if move then
    	Runtime:removeEventListener("enterFrame", move)
    	Runtime:removeEventListener("enterFrame", rotate)
    	Runtime:removeEventListener("enterFrame", updateOrbits)
    end
    transition.cancel()
    placePlanets()
    isPlaying = false

end

setMainScenario()
placePlanets()

