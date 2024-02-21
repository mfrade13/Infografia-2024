local composer = require("composer")

local scene = composer.newScene()

CW = display.contentWidth
CH = display.contentHeight
carpeta_recursos = "resources/"

local fondo, icono

local function ir_menu()
    local options = {
        effect = "slideLeft",
        time = 500
    }
    composer.gotoScene("menu", options)
end

function scene:create(event)

    local sceneGroup = self.view

    fondo = display.newRect(0, 0, CW, CH)
    fondo.anchorX = 0
    fondo.anchorY = 0
    fondo:setFillColor(0.44)

    icono = display.newImageRect(carpeta_recursos .. "Logo.jpg", 320, 480)
    icono.x = CW / 2
    icono.y = CH / 2

    sceneGroup:insert(fondo)

end


function scene:show(event)

    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then

    elseif (phase == "did") then
        transition.to(icono, { alpha = 0, time = 2000, onComplete = ir_menu })
    end
end


function scene:hide(event)

    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then

    elseif (phase == "did") then

    end
end


function scene:destroy(event)

    local sceneGroup = self.view

end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
