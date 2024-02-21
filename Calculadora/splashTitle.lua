local composer = require( "composer" )
 
local scene = composer.newScene()

local CH = display.contentHeight
local CW = display.contentWidth

local fondo , title

function ir_menu(event)
    local options =
        {
            effect = "zoomInOut",
            time = 500,
            params = {
                nivel = 1,
                tiempo = 60,
                cantidad_enemigos = 5

            }
        }
        composer.gotoScene( "calculadora", options )
end
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    fondo = display.newRect(CW/2,CH/2,CW,CH)
    fondo:setFillColor(unpack({0.816, 0.898, 0.965}))

    title = display.newText("Calculadora",CW/2,CH/2,"arial",80)
    title:setFillColor(unpack({{0.004, 0.259, 0.404}}))
    title.alpha = 0
    

    sceneGroup:insert(fondo)
    sceneGroup:insert(title)
 
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        transition.to(title, {alpha=1, time=1500, onComplete=ir_menu})
 
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