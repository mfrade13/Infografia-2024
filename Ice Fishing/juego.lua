local composer = require( "composer" )
 
local scene = composer.newScene()

local physics = require ("physics")
physics.start()
physics.setGravity( 0, 0 )

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
 local lives = 3
 local score_value = 0
 local grupoFondo, grupoPersonajes, grupoControles, grupoInterfaz, jellyFishGroup
 local hooked=false
 local enemies=false
 local won=false
 local level=0
 local hasworm = true
 
 local finalscore
 local bckg, hielo, pingu, gusano, bucket, btn_up, btn_down, btn_close, hook, line
 local life
 local direction
 local delay 
 local move
--------------------------------------------------------------------------------------
--SPRITES
--------------------------------------------------------------------------------------
--Fish Animation Info

 local fish_sheet={
    width=220*0.8,
    height=80*0.8,
    numFrames=3,
    sheetContentWidth=220*0.8,
    sheetContentHeight=240*0.8
 }

 local fish = graphics.newImageSheet( res_folder.."fishSprite.png", fish_sheet )

 local sequenceData = {name = "normalRun", start=1,count=3,time=300}

 local jellyfish_sheet={
    width=123,
    height=142,
    numFrames=4,
    sheetContentWidth=246,
    sheetContentHeight=284
 }

 local jellyfish = graphics.newImageSheet( res_folder.."jellyfish.png", jellyfish_sheet )

 local jellysequenceData = {name = "normalRun", start=1,count=4,time=600}

 local line_sheet={
    width=35,
    height=139,
    numFrames=3,
    sheetContentWidth=105,
    sheetContentHeight=139
 }

 local line_electrocuted = graphics.newImageSheet( res_folder.."line_elect.png", line_sheet )

 local linesequenceData = {name = "normalRun", start=1,count=3,time=100}
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
function updateDifficulty()
    score_value = score_value + 1
    score.text = score_value
    if score_value>=60 then
        print("won!!")
        won=true
    elseif score_value>50 then
        print("level5")
        level=5
        bucket.fill={type="image", filename= res_folder .."bucket5.png"}
        bucket.width=(327)*0.9
        bucket.height=(151)*0.9
        bucket.anchorX = (327)*0.9; bucket.anchorY = (151)*0.9
    elseif score_value>40 then
        print("level4")
        level=4
        bucket.fill={type="image", filename= res_folder .."bucket4.png"}
        bucket.width=(314)*0.9
        bucket.height=(143)*0.9
        bucket.anchorX = (314)*0.9; bucket.anchorY = (143)*0.9
    elseif score_value>30 then
        print("level3")
        level=3
        bucket.fill={type="image", filename= res_folder .."bucket3.png"}
        bucket.width=(312)*0.9
        bucket.height=(136)*0.9
        bucket.anchorX = (312)*0.9; bucket.anchorY = (136)*0.9
    elseif score_value>20 then
        print("level2")
        level=2
        bucket.fill={type="image", filename= res_folder .."bucket2.png"}
        bucket.width=(291)*0.9
        bucket.height=(131)*0.9
        bucket.anchorX = (291)*0.9; bucket.anchorY = (131)*0.9
    elseif score_value>10 then
        print("level1")
        enemies=true
        level=1
        bucket.fill={type="image", filename= res_folder .."bucket1.png"}
        bucket.width=(289)*0.9
        bucket.height=(133)*0.9
        bucket.anchorX = (289)*0.9; bucket.anchorY = (133)*0.9
    else
        if score_value%2==0 then 
        bucket.fill={type="image", filename= res_folder .."bucket_"..score_value..".png"}
        bucket.width=(154)*0.9
        bucket.height=(112+score_value)*0.9
        bucket.anchorX = (154)*0.9; bucket.anchorY = (112+score_value)*0.9
        end
    end
end

function move_up(event)
    local up
    if (event.phase=="began") then 
        direction=-5
        startMoving()
    elseif (event.phase=="ended") then
        stopMoving()
    end
    return true
end

function move_down(event)
    
    if (event.phase=="began") then 
        direction=5
        startMoving()
    elseif (event.phase=="ended") then
        stopMoving()
    end
    return true
end

function startMoving()
    move = timer.performWithDelay( 10, moving , 0)
end

function stopMoving()
    if move then
        timer.cancel(move)
    end
end

function moving()
    if hook.y > CH-90 then
        print("not allowed")
        hook.y= CH-95
        line:removeSelf()
        line = display.newLine(grupoInterfaz, CW*14/29, CH*(1/9), CW*14/29, hook.y)
        line:setStrokeColor(0,0,0)
        line.strokeWidth = 2
        line:toBack()
        hielo:toFront()
        stopMoving()
    elseif hook.y < CH*(1/5) then
        print("not allowed")
        hook.y= CH*(1/5)+5
        line:removeSelf()
        line = display.newLine(grupoInterfaz, CW*14/29, CH*(1/9), CW*14/29, hook.y)
        line:setStrokeColor(0,0,0)
        line.strokeWidth = 2
        line:toBack()
        hielo:toFront()
        stopMoving()
    else
        hook.y=hook.y + direction
        line:removeSelf()
        line = display.newLine(grupoInterfaz, CW*14/29, CH*(1/9), CW*14/29, hook.y)
        line:setStrokeColor(0,0,0)
        line.strokeWidth = 2
        line:toBack()
        hielo:toFront()
        if hooked ==true and hook.y < CH*(1/5)+7 then
            hooked = false
            hook.fill={type="image", filename= res_folder .. "hook2.png"}
            hook.width=(49)*0.9
            hook.height=(51)*0.9
            updateDifficulty()
        elseif hasworm==false and hook.y < CH*(1/5)+7 then
            hasworm=true
            hook.fill={type="image", filename= res_folder .. "hook2.png"}
            hook.width=(49)*0.9
            hook.height=(51)*0.9
            pingu.fill={type="image", filename= res_folder .. "Penguin.png"}
        end
        
    end
end
function catch(event)
    if event.phase == "began" then
        if hasworm==true and hooked == false and event.other.myName=="fish" then
            print("Catched!")
            hooked=true
            print(event.other.myName)
            display.remove(event.other)
            
            hook.fill={type="image", filename= res_folder .. "hookfish.png"}
            hook.width=53
            hook.height=138
        elseif event.other.myName=="jellyfish" then
            electrocuted()
        else
            print("Already hooked")
        end
        
    end
    return true
end

function electrocuted()
    print("electrocuted")
    if hasworm==true then
        lives = lives - 1
        life.text = "x "..lives
        hooked=false
        if lives<=0 then
            gameOver()
        end
    end
    local newline_elect = display.newSprite( grupoPersonajes, line_electrocuted, linesequenceData )        
    newline_elect.x =  CW*14/29; newline_elect.y =CH*(1/9)
    newline_elect.anchorY=0
    newline_elect.height = hook.y - (CH/9)
    newline_elect:play()
    hielo:toFront()
    hook.fill={type="image", filename= res_folder .. "hook1.png"}
        hook.width=15
        hook.height=35
    hasworm=false
    pingu.fill={type="image",  filename= res_folder .. "Penguin_sad.png"}
    transition.to(newline_elect,{time=600, onComplete= function() display.remove(newline_elect)  end})
end

function verify_area(event)
    local left=(CW*14/29)+1
    local right=(CW*14/29)-1
    local height=hook.y
    for i=1,jellyFishGroup.numChildren do
        local jelly=jellyFishGroup[i]
        if(jelly.x>right and jelly.x<left and jelly.y<height) then
            electrocuted()
    end
    end
end

function create_fish()
        local newFish = display.newSprite( grupoPersonajes, fish, sequenceData )
        
        newFish:play()
        physics.addBody(newFish,"dynamic")
        newFish.isSensor=true
        newFish.myName="fish"
        newFish.anchorX = 0;newFish.anchorY = 0

        local h=math.random(CH/3, CH-90)
        local t=math.random(4000, 6000)
        if h%2==0 then
            newFish.x = -(220*0.8); newFish.y = h
            transition.to(newFish, {x=CW, y=h, time=t, 
            onComplete = function() display.remove(newFish)  end})
        else
            newFish:scale(-1,1)
            newFish.x = (CW+220*0.8); newFish.y = h
            transition.to(newFish, {x=-1, y=h, time=t, 
            onComplete = function() display.remove(newFish)  end})
        end
end

function create_jellyfish()
    if enemies == true then

        local newjellyFish = display.newSprite( grupoPersonajes, jellyfish, jellysequenceData )
        newjellyFish:play()
        physics.addBody(newjellyFish,"dynamic")
        newjellyFish.isSensor=true
        newjellyFish.myName="jellyfish"
        newjellyFish.anchorX = 58 ;newjellyFish.anchorY = 12
        newjellyFish:scale(0.8,0.8)
        jellyFishGroup:insert(newjellyFish)

        local h=math.random((CH/3)+150, CH-100)
        local t=math.random(5000, 7000)
        if h%2==0 then
            newjellyFish:rotate(60)
            newjellyFish.x = (0); newjellyFish.y = h
            transition.to(newjellyFish, {x=CW+100, y=h, time=t, 
            onComplete = function() display.remove(newjellyFish) end})
        else
            newjellyFish:rotate(300)
            newjellyFish:scale(-1,1)
            newjellyFish.x = (CW); newjellyFish.y = h
            transition.to(newjellyFish, {x=-100, y=h, time=t, 
            onComplete = function() display.remove(newjellyFish) end})
        end
    end
end

function gameOver()
    local options =
        {
            effect = "fade",
            time = 1000,
            params = {
                finalscore=score_value,
                lives=lives
            }
        }
        composer.gotoScene( "end" , options )
end

function go_back(e)
    if e.phase == "ended" then
        local options =
        {
            effect = "fromTop",
            time = 1000
        }
        composer.gotoScene("menu", options)
    end
 
 end

-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    display.remove( sceneGroup )


    grupoFondo = display.newGroup( )
    sceneGroup:insert(grupoFondo)
    grupoPersonajes = display.newGroup( )
    sceneGroup:insert(grupoPersonajes)
    grupoInterfaz = display.newGroup()
    sceneGroup:insert( grupoInterfaz)
    jellyFishGroup = display.newGroup()
    sceneGroup:insert( jellyFishGroup)
    -- Code here runs when the scene is first created but has not yet appeared on screen
    bckg = display.newImageRect(grupoFondo,  res_folder .. "IFbackground.png", CW, CH)
    bckg.x = CW/2; bckg.y= CH/2

    gusano = display.newImageRect(grupoFondo,  res_folder .. "worm.png", 15, 60)
    gusano.x = (CW/21); gusano.y= CH/12

    line = display.newLine(grupoInterfaz, CW*14/29, CH*(1/9), CW*14/29, CH*(1/5))
    line:setStrokeColor(0,0,0)
    line.strokeWidth = 2

    hook = display.newImageRect(grupoPersonajes,  res_folder .. "hook2.png", (49)*0.9, (51)*0.9)
    hook.x = CW*14/29; hook.y= CH*(1/5)
    hook.anchorY=0
    physics.addBody(hook)
    hook.isSensor=true

    pingu = display.newImageRect(grupoFondo,  res_folder .. "Penguin.png", (225)*0.9, (172)*0.9)
    pingu.x = CW*11/19; pingu.y= CH*(1/5)

    bucket = display.newImageRect(grupoFondo,  res_folder .. "bucket0.png", (160)*0.9, (128)*0.9)
    bucket.x = CW*3/7; bucket.y= CH*(2/7)
    bucket.anchorX = (160)*0.9; bucket.anchorY = (128)*0.9

    life = display.newText(grupoInterfaz,"x "  .. lives, CW/16, CH/12,"arial bold", 30 )
    life:setFillColor( 0)
    life.anchorX = 0

    score = display.newText(grupoInterfaz,score_value, (CW*3/7)-35, (CH*2/7)-40, "arial bold", 28 )
    score:setFillColor(0)

    btn_close = display.newText(grupoInterfaz,"X", CW*24/25, CH*2/23, "arial bold",30)
    btn_close:setFillColor(0)

    btn_up = display.newImageRect(grupoInterfaz,  res_folder .. "arrow.png", 60, 60)
    btn_up.x = (CW*18/20); btn_up.y= CH*(2/16)

    btn_down = display.newImageRect(grupoInterfaz,  res_folder .. "arrow.png", 60, 60)
    btn_down.x = (CW*18/20); btn_down.y= CH*(4/16)
    btn_down:scale(1,-1)

    hielo = display.newImageRect(grupoFondo,  res_folder .. "ice.png", CW*1.2, 50)
    hielo.x = (CW/2); hielo.y= CH*(1.55/5)

end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        delay=math.random(2000, 3000)
        timer.performWithDelay( delay, create_fish, 0)

        local delay2=math.random(4000, 6000)
        timer.performWithDelay( delay2, create_jellyfish, 0)
        
        btn_close:addEventListener("touch", go_back)

        btn_up:addEventListener("touch", move_up)
        btn_down:addEventListener("touch", move_down)
        
        hook:addEventListener("collision", catch)
        --end
        Runtime:addEventListener("enterFrame", verify_area)
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
        composer.removeScene("juego")
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