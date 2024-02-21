local composer = require( "composer" )
 
local scene = composer.newScene()
 

 local fondo, goback_btn, moves
 local mov_R, W_L
local grupoFondo
local tiempo = 0
local imagepath = carpeta_recursos
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
 function volver_Menu(e)
    if e.phase == "ended" then
        local options =
        {
            effect = "zoomOutInFade",
            time = 500,
            params = {}
        }
        composer.removeScene("board")
        composer.gotoScene( "menu", options )
    end
 
 end
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    mov_R = event.params.movimientos
    tiempo = event.params.tiempo
    W_L = event.params.ended
    local sceneGroup = self.view

    fondo = display.newImageRect(sceneGroup,  carpeta_recursos .. "fondoBoard.jpg", CW, CH+100)
    fondo.x = CW/2; fondo.y=CH/2

    if W_L == 1 then imagepath = carpeta_recursos .. "win.png"
    elseif W_L == 0 then imagepath = carpeta_recursos .. "loose.png"
    end

    titulo = display.newImageRect(sceneGroup, imagepath, 600, 600)
    titulo.x = CW/2; titulo.y = CH/4 + 50

    moves = display.newText(sceneGroup,"Movimientos: "  .. mov_R, 0, CH/20, "Arial Black", 50 )
    moves.y = CH/3 +300; moves.x = CW/2

    elapse = display.newText(sceneGroup,"Tiempo Empleado: "  .. tiempo .. " seg", 0, CH/20, "Arial Black", 50 )
    elapse.y = CH/2 +200; elapse.x = CW/2; elapse:setFillColor(0,0,0)


    goback_btn = display.newImageRect(sceneGroup, carpeta_recursos.."goback.png", 200, 200)
    goback_btn.x = CW/2-200; goback_btn.y = CH -200
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        goback_btn:addEventListener("touch", volver_Menu)
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
    sceneGroup:removeSelf()
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