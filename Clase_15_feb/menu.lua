local composer = require( "composer" )
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
local CW = display.contentWidth
local CH = display.contentHeight

local fondo, titulo, boton
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
function ir_atras(event)
    if event.phase == "ended" then 
    local options =
        {
            effect = "slideRight",
            time = 2000
        }
        composer.gotoScene( "splashScreen", options )
    end
    return true
end

-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    print("Estoy creando la escena del menu")
    print(event.params)
    for k,v in pairs( event.params ) do
        print(k,v)
    end
    fondo = display.newRect( CW/2, CH/2, CW, CH )
    fondo:setFillColor( 0.22, 1,0.2 )

    titulo = display.newText(sceneGroup, "BUSCAMINAS".. event.params.nivel,  CW/2, CH/6, "arial", 30)

    boton = display.newRect(sceneGroup, CW/2, CH/2, 100, 50)
   
    sceneGroup:insert(1, fondo )


end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
    -- print("Volviendo a la escena ya creada")

    -- local boton2 = display.newRect(sceneGroup, math.random(50,CW-50), math.random( 50, CH-50 ), 80, 50)
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
         print("Volviendo a la escena ya creada en la fase will")
         -- "reset"
         
        boton:addEventListener( 'touch', ir_atras )
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        boton2 = display.newRect(sceneGroup, math.random(50,CW-50), math.random( 50, CH-50 ), 80, 50)
        boton2:setFillColor( 1,0,0 )
        transition.to(boton, {rotation = 720, x=0, time=2000})
        print("Volviendo a la escena ya creada en la fase did")
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
        boton.x = CW/2; boton.rotation = 0
        boton2:removeSelf( )
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