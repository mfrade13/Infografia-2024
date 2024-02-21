local composer = require( "composer" )
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
local cw = display.contentWidth
local ch = display.contentHeight
local fondo, tablero, fu, fd, fl, fr, titulo, cuadro, txt, txtScore, instrucciones, fondoGO, imgGO, imgPlay, cuadroR, txtR, txtRecord
local casillas, nums, fc = {}, {}, {}
local score = 0
local record = 0
local matrizC = {
    {0,526,32,2},
    {0,1024,64,4},
    {0,2048,128,8},
    {0,4096,256,16}
}
local matriz = {
    {0,0,0,0},
    {0,0,0,0},
    {0,0,0,0},
    {0,0,0,0}
}

--FUNCIONES AUXILIARES
function newGame(e)
    if e.phase == "ended" then
        if (score > record) then
            record = score
        end

        score = 0
        fondoGO.alpha = 0
        imgGO.alpha = 0
        cuadroR.alpha = 0
        txtR.alpha = 0
        txtRecord.alpha = 0
        imgPlay.x, imgPlay.y, imgPlay.width, imgPlay.height = cw*0.05,ch*0.96,ch*0.06,ch*0.06
        cuadro.x, cuadro.y = cw*0.73, ch*0.08
        txt.x, txt.y = cw*0.73, ch*0.045
        txtScore.x,txtScore.y =  cw*0.73, ch*0.1
        matriz = {
            {0,0,0,0},
            {0,0,0,0},
            {0,0,0,0},
            {0,0,0,0}
        }

        colocarEn0()
        actM()
        actB()
    end
    return
end
function gameOver()
    fondoGO:toFront( )
    imgGO:toFront( )
    imgPlay:toFront( )
    cuadro:toFront( )
    txt:toFront( )
    txtScore:toFront( )
    cuadroR:toFront( )
    txtR:toFront( )
    txtRecord:toFront( )

    transition.to(fondoGO,{alpha=0.75,time=1000})
    transition.to(imgGO,{alpha=0.5,time=1000})
    transition.to(imgPlay,{x=cw/2,y=ch*0.85,width=cw*0.25,height=cw*0.25,time=1000})
    transition.to(cuadro,{x=cw*0.25,y=ch*0.6,time=1000})
    transition.to(txt,{x=cw*0.25,y=ch*0.56,time=1000})
    transition.to(txtScore,{x=cw*0.25,y=ch*0.62,time=1000})
    transition.to(cuadroR,{alpha=1,time=1500})
    transition.to(txtR,{alpha=1,time=1500})
    transition.to(txtRecord,{alpha=1,time=1500})

    if (score > record) then
        record = score
    end
    txtRecord.text = record
end
function actB()
    local r,l,d,u = checkR(), checkL(), checkD(), checkU()
    fr.isVisible = r
    fl.isVisible = l
    fd.isVisible = d
    fu.isVisible = u
    if not (r or l or d or u) then
        timer.performWithDelay(2000, function()
            gameOver()
        end)
    end
end
function actM()
    for i=1, 4 do
        for j=1, 4 do
            if matriz[i][j] ~= 0 then
                nums[i][j].text = matriz[i][j]
                casillas[i][j]:setFillColor(130/255,(11 - math.log10(nums[i][j].text)/math.log10(2))/11,130/255)
            else
                nums[i][j].text = ""
                casillas[i][j]:setFillColor(1)
            end
            local l = cw*0.2
            casillas[i][j].x = tablero.x + (j - 2.5)*l
            casillas[i][j].y = tablero.y + (i - 2.5)*l
            nums[i][j].x = casillas[i][j].x
            nums[i][j].y = casillas[i][j].y
        end
    end
    txtScore.text = score
end
function colocarEn0()
    local posis = {}
    local ls = {2,4}
    for i=1, 4 do
        for j=1, 4 do
            if matriz[i][j] == 0 then
                table.insert(posis,{i,j})
            end 
        end
    end
    local ind = math.random( 1, #posis )
    local r = math.random( 1,2 )
    matriz[posis[ind][1]][posis[ind][2]] = ls[r]
end
function impT()
    for i=1, 4 do
        print( matriz[i][1], matriz[i][2], matriz[i][3], matriz[i][4])
    end
end
function desplazar(a,b,c,d)
    casillas[a][b]:toFront( )
    transition.to(casillas[a][b],{x=casillas[c][d].x, y=casillas[c][d].y, time=200})
    nums[a][b]:toFront( )
    transition.to(nums[a][b],{x=nums[c][d].x, y=nums[c][d].y, time=200})
end
--FUNCIONES DE MOVIMIENTO
function moveRL(sm,ultimo,inicio,fin,paso,suma,paso2)
    print("----------------------------"..sm.."--------------------------------")
    impT()
    local u = {ultimo,ultimo,ultimo,ultimo}
    local indice,valor
    for j=inicio, fin, paso do
        for i=1, 4 do
            if matriz[i][j] ~= 0 then
                local c = false
                for a=u[i], j+suma , paso2 do
                    if matriz[i][a] == 0 then
                        desplazar(i,j,i,a)
                        matriz[i][j], matriz[i][a] = matriz[i][a], matriz[i][j]
                        u[i] = a
                        c = true
                        print( "Se mueve: "..i..","..j.." a: "..i..","..a )
                        break
                    elseif matriz[i][j] == matriz[i][a] then
                        desplazar(i,j,i,a)
                        score = score + matriz[i][j]*2
                        matriz[i][a] = matriz[i][j]*2
                        matriz[i][j] = 0
                        u[i] = a
                        c = true
                        print( "Se junta: "..i..","..j.." con: "..i..","..a )
                        break
                    end
                end
                if not c then
                    u[i] = j
                    print( "No se mueve :"..i..","..j)
                end
            else
                print( "Casilla 0 en: "..i..","..j )
            end
        end
    end
    colocarEn0()
    timer.performWithDelay(300, function()
        actM()
    end)
    actB()
    print( "------------------------------------------------------------" )
end
function moveR( event )
    if event.phase == "ended" then
        moveRL("DERECHA",4,3,1,-1,1,-1)
    end
end
function moveL( event )
    if event.phase == "ended" then
        moveRL("IZQUIERDA",1,2,4,1,-1,1)
    end
end
--[[
function moveR(event)
    if event.phase == "ended" then
        print("----------------------------DERECHA--------------------------------")
        impT()
        local u = {4,4,4,4}
        for j=3, 1, -1 do
            for i=1, 4 do
                if matriz[i][j] ~= 0 then
                    local c = false
                    for a=u[i], j+1 , -1 do
                        if matriz[i][a] == 0 then
                            desplazar(i,j,i,a)
                            matriz[i][j], matriz[i][a] = matriz[i][a], matriz[i][j]
                            u[i] = a
                            c = true
                            print( "Se mueve: "..i..","..j.." a: "..i..","..a )
                            break
                        elseif matriz[i][j] == matriz[i][a] then
                            desplazar(i,j,i,a)
                            score = score + matriz[i][j]*2
                            matriz[i][a] = matriz[i][j]*2
                            matriz[i][j] = 0
                            u[i] = a
                            c = true
                            print( "Se junta: "..i..","..j.." con: "..i..","..a )
                            break
                        end
                    end
                    if not c then
                        u[i] = j
                        print( "No se mueve :"..i..","..j)
                    end
                else
                    print( "Casilla 0 en: "..i..","..j )
                end
            end
        end
        colocarEn0()
        timer.performWithDelay(300, function()
            actM()
        end)
        actB()
        print( "------------------------------------------------------------" )
    end
    return
end
function moveL(event)
    if event.phase == "ended" then
        print("----------------------------IZQUIERDA--------------------------------")
        impT()
        local u = {1,1,1,1}
        for j=2, 4 do
            for i=1, 4 do
                if matriz[i][j] ~= 0 then
                    local c = false
                    for a=u[i], j-1 do
                        if matriz[i][a] == 0 then
                            desplazar(i,j,i,a)
                            matriz[i][j], matriz[i][a] = matriz[i][a], matriz[i][j]
                            u[i] = a
                            c = true
                            print( "Se mueve: "..i..","..j.." a: "..i..","..a )
                            break
                        elseif matriz[i][j] == matriz[i][a] then
                            desplazar(i,j,i,a)
                            score = score + matriz[i][j]*2
                            matriz[i][a] = matriz[i][j]*2
                            matriz[i][j] = 0
                            u[i] = a
                            c = true
                            print( "Se junta: "..i..","..j.." con: "..i..","..a )
                            break
                        end
                    end
                    if not c then
                        u[i] = j
                        print( "No se mueve :"..i..","..j)
                    end
                else
                    print( "Casilla 0 en: "..i..","..j )
                end
            end
        end
        colocarEn0()
        timer.performWithDelay(300, function()
            actM()
        end)
        actB()
        print( "------------------------------------------------------------" )
    end
    return
end
--]]
function moveDU(sm,ultimo,inicio,fin,paso,suma,paso2)
    print("----------------------------"..sm.."--------------------------------")
    impT()
    local u = {ultimo,ultimo,ultimo,ultimo}
    for i=inicio, fin, paso do
        for j=1, 4 do
            if matriz[i][j] ~= 0 then
                local c = false
                for a=u[j], i+suma , paso2 do
                    if matriz[a][j] == 0 then
                        desplazar(i,j,a,j)
                        matriz[i][j], matriz[a][j] = matriz[a][j], matriz[i][j]
                        u[j] = a
                        c = true
                        print( "Se mueve: "..i..","..j.." a: "..a..","..j )
                        break
                    elseif matriz[i][j] == matriz[a][j] then
                        desplazar(i,j,a,j)
                        score = score + matriz[i][j]*2
                        matriz[a][j] = matriz[i][j]*2
                        matriz[i][j] = 0
                        u[j] = a
                        c = true
                        print( "Se junta: "..i..","..j.." con: "..a..","..j )
                        break
                    end
                end
                if not c then
                    u[j] = i
                    print( "No se mueve :"..i..","..j)
                end
            else
                print( "Casilla 0 en: "..i..","..j )
            end
        end
    end
    colocarEn0()
    timer.performWithDelay(300, function()
        actM()
    end)
    actB()
    print( "------------------------------------------------------------" )
end
function moveD(event)
    if event.phase == "ended" then
        moveDU("ABAJO",4,3,1,-1,1,-1)
    end
end
function moveU(event)
    if event.phase == "ended" then
        moveDU("ARRIBA",1,2,4,1,-1,1)
    end
end
--[[
function moveD(event)
    if event.phase == "ended" then
        print("----------------------------ABAJO--------------------------------")
        impT()
        local u = {4,4,4,4}
        for i=3, 1, -1 do
            for j=1, 4 do
                if matriz[i][j] ~= 0 then
                    local c = false
                    for a=u[j], i+1 , -1 do
                        if matriz[a][j] == 0 then
                            desplazar(i,j,a,j)
                            matriz[i][j], matriz[a][j] = matriz[a][j], matriz[i][j]
                            u[j] = a
                            c = true
                            print( "Se mueve: "..i..","..j.." a: "..a..","..j )
                            break
                        elseif matriz[i][j] == matriz[a][j] then
                            desplazar(i,j,a,j)
                            score = score + matriz[i][j]*2
                            matriz[a][j] = matriz[i][j]*2
                            matriz[i][j] = 0
                            u[j] = a
                            c = true
                            print( "Se junta: "..i..","..j.." con: "..a..","..j )
                            break
                        end
                    end
                    if not c then
                        u[j] = i
                        print( "No se mueve :"..i..","..j)
                    end
                else
                    print( "Casilla 0 en: "..i..","..j )
                end
            end
        end
        colocarEn0()
        timer.performWithDelay(300, function()
            actM()
        end)
        actB()
        print( "------------------------------------------------------------" )
    end
    return
end
function moveU(event)
    if event.phase == "ended" then
        print("----------------------------ARRIBA--------------------------------")
        impT()
        local u = {1,1,1,1}
        for i=2, 4 do
            for j=1, 4 do
                if matriz[i][j] ~= 0 then
                    local c = false
                    for a=u[j], i-1  do
                        if matriz[a][j] == 0 then
                            desplazar(i,j,a,j)
                            matriz[i][j], matriz[a][j] = matriz[a][j], matriz[i][j]
                            u[j] = a
                            c = true
                            print( "Se mueve: "..i..","..j.." a: "..a..","..j )
                            break
                        elseif matriz[i][j] == matriz[a][j] then
                            desplazar(i,j,a,j)
                            score = score + matriz[i][j]*2
                            matriz[a][j] = matriz[i][j]*2
                            matriz[i][j] = 0
                            u[j] = a
                            c = true
                            print( "Se junta: "..i..","..j.." con: "..a..","..j )
                            break
                        end
                    end
                    if not c then
                        u[j] = i
                        print( "No se mueve :"..i..","..j)
                    end
                else
                    print( "Casilla 0 en: "..i..","..j )
                end
            end
        end
        colocarEn0()
        timer.performWithDelay(300, function()
            actM()
        end)
        actB()
        print( "------------------------------------------------------------" )
    end
    return
end
]]
--FUNCIONES CHECK DE MOVIMIENTOS
function checkRL(ultimo,inicio,fin,paso,suma,paso2)
    local u = {ultimo,ultimo,ultimo,ultimo}
    for j=inicio, fin, paso do
        for i=1, 4 do
            if matriz[i][j] ~= 0 then
                local c = false
                for a=u[i], j+suma , paso2 do
                    if matriz[i][a] == 0 then
                        return true
                    elseif matriz[i][j] == matriz[i][a] then
                        return true
                    end
                end
                if not c then
                    u[i] = j
                end
            end
        end
    end
    return false
end
function checkR()
    return checkRL(4,3,1,-1,1,-1)
end
function checkL()
    return checkRL(1,2,4,1,-1,1)
end
--[[
function checkR()
    local u = {4,4,4,4}
    for j=3, 1, -1 do
        for i=1, 4 do
            if matriz[i][j] ~= 0 then
                local c = false
                for a=u[i], j+1 , -1 do
                    if matriz[i][a] == 0 then
                        return true
                    elseif matriz[i][j] == matriz[i][a] then
                        return true
                    end
                end
                if not c then
                    u[i] = j
                end
            end
        end
    end
    return false
end
function checkL()
    local u = {1,1,1,1}
    for j=2, 4 do
        for i=1, 4 do
            if matriz[i][j] ~= 0 then
                local c = false
                for a=u[i], j-1 do
                    if matriz[i][a] == 0 then
                        return true
                    elseif matriz[i][j] == matriz[i][a] then
                        return true
                    end
                end
                if not c then
                    u[i] = j
                end
            end
        end
    end
    return false
end
]]
function checkDU(ultimo,inicio,fin,paso,suma,paso2)
    local u = {ultimo,ultimo,ultimo,ultimo}
    for i=inicio, fin, paso do
        for j=1, 4 do
            if matriz[i][j] ~= 0 then
                local c = false
                for a=u[j], i+suma , paso2 do
                    if matriz[a][j] == 0 then
                        return true
                    elseif matriz[i][j] == matriz[a][j] then
                        return true
                    end
                end
                if not c then
                    u[j] = i
                end
            end
        end
    end
    return false
end
function checkD()
    return checkDU(4,3,1,-1,1,-1)
end
function checkU()
    return checkDU(1,2,4,1,-1,1)
end
--[[
function checkD()
    local u = {4,4,4,4}
    for i=3, 1, -1 do
        for j=1, 4 do
            if matriz[i][j] ~= 0 then
                local c = false
                for a=u[j], i+1 , -1 do
                    if matriz[a][j] == 0 then
                        return true
                    elseif matriz[i][j] == matriz[a][j] then
                        return true
                    end
                end
                if not c then
                    u[j] = i
                end
            end
        end
    end
    return false
end
function checkU()
    local u = {1,1,1,1}
    for i=2, 4 do
        for j=1, 4 do
            if matriz[i][j] ~= 0 then
                local c = false
                for a=u[j], i-1  do
                    if matriz[a][j] == 0 then
                        return true
                    elseif matriz[i][j] == matriz[a][j] then
                        return true
                    end
                end
                if not c then
                    u[j] = i
                end
            end
        end
    end
    return false
end
]]
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    --fondo
    fondo = display.newRect(sceneGroup,cw/2,ch/2,cw,ch)
    fondo:setFillColor(235/255,245/255,240/255)
    --tablero
    tablero = display.newRect(sceneGroup,cw/2,ch*0.62,cw*0.8,cw*0.8)
    tablero:setFillColor(225/255,225/255,200/255)
    tablero:setStrokeColor(0)
    tablero.strokeWidth = 5
    --casillas y textos
    local l = cw*0.2
    for i=1, 4 do
        casillas[i] = {}
        nums[i] = {}
        fc[i] = {}
        for j=1, 4 do
            fc[i][j] = display.newRect(sceneGroup,tablero.x + (j-2.5)*l, tablero.y + (i-2.5)*l, l*0.9, l*0.9)
            fc[i][j]:setFillColor(1)
            fc[i][j]:setStrokeColor(0)
            fc[i][j].strokeWidth = 5
            casillas[i][j] = display.newRect(sceneGroup,tablero.x + (j-2.5)*l, tablero.y + (i-2.5)*l, l*0.9, l*0.9)
            casillas[i][j]:setStrokeColor(0)
            casillas[i][j].strokeWidth = 5
            nums[i][j] = display.newText(sceneGroup,"",tablero.x + (j-2.5)*l, tablero.y + (i-2.5)*l)
            nums[i][j]:setFillColor(1)
        end
    end
    --flechas o botones
    fu = display.newRect(sceneGroup,cw/2,ch*0.28,cw*0.8,cw*0.07)
    fu:setFillColor(225/255,250/255,255/255)
    fu:setStrokeColor(0)
    fu.strokeWidth = 5
    fd = display.newRect(sceneGroup,cw/2,ch*0.96,cw*0.8,cw*0.07)
    fd:setFillColor(225/255,250/255,255/255)
    fd:setStrokeColor(0)
    fd.strokeWidth = 5
    fl = display.newRect(sceneGroup,cw*0.05,ch*0.62,cw*0.07,cw*0.8)
    fl:setFillColor(225/255,200/255,255/255)
    fl:setStrokeColor(0)
    fl.strokeWidth = 5
    fr = display.newRect(sceneGroup,cw*0.95,ch*0.62,cw*0.07,cw*0.8)
    fr:setFillColor(225/255,200/255,255/255)
    fr:setStrokeColor(0)
    fr.strokeWidth = 5
    --titulo del juego
    titulo = display.newText(sceneGroup, "2048", cw*0.25, ch*0.08)
    titulo:setFillColor(130/255,0,130/255)
    titulo.size = 150
    --cuadro del score
    cuadro = display.newRect(sceneGroup, cw*0.73, ch*0.08, 350, 125)
    cuadro:setFillColor(225/255,225/255,200/255)
    cuadro:setStrokeColor(0)
    cuadro.strokeWidth = 5
    --texto score
    txt = display.newText(sceneGroup, "Score:", cw*0.73, ch*0.045)
    txt:setFillColor( 0 )
    --numero score
    txtScore = display.newText(sceneGroup, "0", cw*0.73, ch*0.1)
    txtScore.size = 75
    --instrucciones
    instrucciones = display.newText(sceneGroup, "¡Junta los numeros y llega al 2048!", cw/2, ch*0.2)
    instrucciones:setFillColor( 0 )
    --fondo gameover
    fondoGO = display.newRect(sceneGroup,cw/2,ch/2,cw,ch)
    fondoGO:setFillColor(0)
    fondoGO.alpha = 0
    --imagen gameover
    imgGO = display.newImageRect(sceneGroup,"defeat.png",cw,ch*0.6)
    imgGO.x, imgGO.y = cw/2,ch*0.25
    imgGO.alpha = 0
    --imagen home
    imgPlay = display.newImageRect(sceneGroup,"play.png",ch*0.06,ch*0.06)
    imgPlay.x,imgPlay.y = cw*0.05,ch*0.96
    --cuadro del record
    cuadroR = display.newRect(sceneGroup, cw*0.75, ch*0.6, 350, 125)
    cuadroR:setFillColor(225/255,225/255,240/255)
    cuadroR:setStrokeColor(0)
    cuadroR.strokeWidth = 5
    cuadroR.alpha = 0
    --texto record
    txtR = display.newText(sceneGroup, "Record:", cw*0.75, ch*0.56)
    txtR:setFillColor( 0 )
    txtR.alpha = 0
    --numero record
    txtRecord = display.newText(sceneGroup, "0", cw*0.75, ch*0.62)
    txtRecord.size = 75
    txtRecord.alpha = 0
    --asignar la primera casilla
    colocarEn0()
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        actM()
        actB()
        fr:addEventListener( "touch", moveR )
        fl:addEventListener( "touch", moveL )
        fd:addEventListener( "touch", moveD )
        fu:addEventListener( "touch", moveU )
        imgPlay:addEventListener( "touch", newGame )
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
        fr:removeEventListener( "touch", moveR )
        fl:removeEventListener( "touch", moveL )
        fd:removeEventListener( "touch", moveD )
        fu:removeEventListener( "touch", moveU )
        imgPlay:removeEventListener( "touch", newGame )
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