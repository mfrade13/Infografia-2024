local composer = require( "composer" )
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 local fondo
 
function volverPortada()
    -- if e.phase == "ended" then 
        composer.gotoScene("portada", 
        {time=1000, effect = "slideRight"})
    -- end
    -- return true
end
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 local cuadro_actual = 0
--[[
    escalas para viñetas
    1 xScale =1.5, yScale= 3.2
    2 xScale = 3, yScale= 3.2, x=-2060 y=0
    3 xScale =3.5, yScale = 3, x =0 y=-755
 ]]--
 local transiciones = {
    {xScale = 1.5, yScale=3.2, x=0, y=0},
    {xScale = 3, yScale=3.2, x=-2060, y=0},
    {xScale = 3.45, yScale=3, x=0, y=-755}
}

function cambiar(e)
    if e.phase == "ended" or e.phase == "cancelled" then
        print(cuadro_actual)
        if cuadro_actual >= 3 then
            volverPortada()
            return true
        else 
            cuadro_actual = cuadro_actual + 1
            local t = transiciones[cuadro_actual]
            transition.to(fondo, {x=t.x, y=t.y, xScale=t.xScale, yScale=t.yScale, time =2000})
        end
    end
    return true
end

-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    local bg = display.newRect(sceneGroup, CW/2,CH/2, CW,CH)
    bg:setFillColor(0.22)
    
    fondo = display.newImageRect(sceneGroup, "spiderman2.jpg", CW, CH)
    fondo.anchorX = 0; fondo.anchorY = 0
    -- fondo:scale( 3.45, 3.)
    -- fondo:translate(-0 , -755)
    --fondo.height = 
    print(fondo.contentWidth, fondo.contentHeight)
    

end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase

 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        -- transition.to(fondo, {xScale=1.5, yScale=3.2, time=1500, delay=1000})
        -- transition.to(fondo, {xScale=3,x=-2060, yScale=3.2, time=1500, delay=3000})
        -- transition.to(fondo, {xScale=3.45,x=0, yScale=3,y=-755, time=1500, delay=5000})
        cuadro_actual = 0
        fondo.x = 0; fondo.y=0
        fondo.xScale=1; fondo.yScale=1
        print("llamada al show")
        fondo:addEventListener("touch", cambiar)
        -- local panel = display.newRect(CW, CH/2, 20, CH)
        -- panel:setFillColor(0)
        -- panel.anchorX = 1
        -- transition.to(panel, {xScale =5, time =1500})
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
        fondo:removeEventListener("touch", cambiar)
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
        fondo:removeEventListener("touch", fondo)

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