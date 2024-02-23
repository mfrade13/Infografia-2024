local composer = require("composer")
local widget = require("widget")

local scene = composer.newScene()

local CW = display.contentWidth
local CH = display.contentHeight
local carpeta_recursos = "resources/"

local fondo, Kanto, Hoenn, Unova

local titulo = display.newImageRect(carpeta_recursos .. "Titulo.PNG", 160, 60)  
titulo.x = display.contentCenterX
titulo.y = 45


local function ir_menu(region)
    local options = {
        effect = "slideLeft",
        time = 500,
        params = {
            region = region
        }
    }
    composer.gotoScene( region, options)
end

function scene:create(event)
    local sceneGroup = self.view

    fondo = display.newImageRect(carpeta_recursos .. "Fondo.jpg", 360, 480)
    fondo.x = display.contentCenterX
    fondo.y = display.contentCenterY

    local botonAncho = CW * 0.6
    local botonAlto = CH * 0.15

    Kanto = widget.newButton({
        x = CW / 2,
        y = CH / 4,
        defaultFile = carpeta_recursos .. "Kanto2.PNG",
        overFile = carpeta_recursos .. "Kanto2.PNG",
        width = botonAncho,
        height = botonAlto,
        onEvent = function(event) 
            if (event.phase == "ended") then
                ir_menu("kanto")
            end
        end
    })

    Hoenn = widget.newButton({
        x = CW / 2,
        y = CH / 2,
        defaultFile = carpeta_recursos .. "Hoenn2.PNG",
        overFile = carpeta_recursos .. "Hoenn2.PNG",
        width = botonAncho,
        height = botonAlto,
        onEvent = function(event) 
            if (event.phase == "ended") then
                ir_menu("hoenn") 
            end
        end
    })

    Unova = widget.newButton({
        x = CW / 2,
        y = 3 * CH / 4,
        defaultFile = carpeta_recursos .. "Unova2.PNG",
        overFile = carpeta_recursos .. "Unova2.PNG",
        width = botonAncho,
        height = botonAlto,
        onEvent = function(event) 
            if (event.phase == "ended") then
                ir_menu("unova")
            end
        end
    })

    sceneGroup:insert(fondo)
    sceneGroup:insert(Kanto)
    sceneGroup:insert(Hoenn)
    sceneGroup:insert(Unova)
    sceneGroup:insert(titulo)
end


function scene:destroy(event)
    local sceneGroup = self.view
end

scene:addEventListener("create", scene)
scene:addEventListener("destroy", scene)

return scene
