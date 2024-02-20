local composer = require( "composer" )
 
local scene = composer.newScene()
 
CW = display.contentWidth
CH = display.contentHeight
carpeta_recursos = "resources/"

local fondo, astro

function ir_menu()
    local options =
        {
            effect = "zoomInOut",
            time = 500
        }
        composer.gotoScene( "menu", options )
end

-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    fondo = display.newImageRect(carpeta_recursos.. "space.jpg", CW, CH)
    fondo.anchorX = 0; fondo.anchorY = 0

    astro = display.newImageRect(carpeta_recursos.. "astronaut.png", 300, 300)
    astro.x = CW/2; astro.y = CH/2

  --  fondo:addEventListener( "touch", ir_menu )

    sceneGroup:insert(fondo)
    sceneGroup:insert(astro)

end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
 
    elseif ( phase == "did" ) then
        --transition.to(astro, {rotation=360, time=2000, onComplete=ir_menu})
        astro.xScale = 0.1
        astro.yScale = 0.1
        transition.to(astro, {xScale=1, yScale=1, time=2500, transition=easing.outBack})
        transition.to(astro, {rotation=360, time=1800})
        transition.to(astro, {delay=2000, time=500, onComplete=ir_menu})
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
 
    elseif ( phase == "did" ) then
 
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