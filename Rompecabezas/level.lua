local composer = require( "composer" )
 
local scene = composer.newScene()
 

 local fondo, easy_btn, medium_btn, hard_btn
 local vidas = 3
local dificultad = 0
local tiempo = 0
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
 function ir_juego(e)
    if e.phase == "ended" then
        tiempo = getTime(e.target.num)
        local options =
        {
            effect = "zoomInOut",
            time = 500,
            params = {
                dificultad = e.target.num,
                tiempo = tiempo
            }
        }
        composer.removeScene("level")
        composer.gotoScene( "juego" , options )
    end
 
 end

function getTime(num)
    if num == 1 then return 120
    elseif num == 2 then return 60
    elseif num == 3 then return 45
    end
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    fondo = display.newImageRect(sceneGroup,  carpeta_recursos .. "fondomenu.png", CW+300, CH+300)
    fondo.x = CW/2; fondo.y=CH/2
    
    titulo = display.newImageRect(sceneGroup, carpeta_recursos.."titulo_L.jpg", 300, 100)
    titulo.x = CW/2; titulo.y = CH/5

    easy_btn = display.newImageRect(sceneGroup, carpeta_recursos.."easy.png", 300, 100)
    easy_btn.x = CW/2; easy_btn.y = CH/3; easy_btn.num = 1;

    medium_btn = display.newImageRect(sceneGroup, carpeta_recursos.."medium.png", 300, 100)
    medium_btn.x = CW/2; medium_btn.y = CH/2; medium_btn.num = 2

    hard_btn = display.newImageRect(sceneGroup, carpeta_recursos.."hard.png", 300, 100)
    hard_btn.x = CW/2; hard_btn.y = CH/1.5; hard_btn.num = 3


end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        easy_btn:addEventListener("touch", ir_juego)
        medium_btn:addEventListener("touch", ir_juego)
        hard_btn:addEventListener("touch", ir_juego)
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