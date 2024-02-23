local shooter = {}
shooter.__index = shooter

local config1 = {
    width1 = 128,
    height1 = 128,
    numFrames1 = 8,
    sheetContentWidth1 = 1024,
    sheetContentHeight1 = 128,
    width2 = 128,
    height2 = 128,
    numFrames2 = 9,
    sheetContentWidth2 = 1152,
    sheetContentHeight2 = 128,
    width3 = 128,
    height3 = 128,
    numFrames3 = 4,
    sheetContentWidth3 = 512,
    sheetContentHeight3 = 128,
    width4 = 128,
    height4 = 128,
    numFrames4 = 4,
    sheetContentWidth4 = 512,
    sheetContentHeight4 = 128,
    time1 =400,
    time2 = 400,
    time3 = 200,
    time4 = 1000
}

local config2 = {
    width1 = 128,
    height1 = 128,
    numFrames1 = 8,
    sheetContentWidth1 = 1024,
    sheetContentHeight1 = 128,
    width2 = 128,
    height2 = 128,
    numFrames2 = 7,
    sheetContentWidth2 = 896,
    sheetContentHeight2 = 128,
    width3 = 128,
    height3 = 128,
    numFrames3 = 4,
    sheetContentWidth3 = 512,
    sheetContentHeight3 = 128,
    width4 = 128,
    height4 = 128,
    numFrames4 = 4,
    sheetContentWidth4 = 512,
    sheetContentHeight4 = 128,
    time1 =400,
    time2 = 400,
    time3 = 300,
    time4 = 1000
}

local config3 = {
    width1 = 128,
    height1 = 128,
    numFrames1 = 6,
    sheetContentWidth1 = 768,
    sheetContentHeight1 = 128,
    width2 = 128,
    height2 = 128,
    numFrames2 = 7,
    sheetContentWidth2 = 896,
    sheetContentHeight2 = 128,
    width3 = 128,
    height3 = 128,
    numFrames3 = 4,
    sheetContentWidth3 = 512,
    sheetContentHeight3 = 128,
    width4 = 128,
    height4 = 128,
    numFrames4 = 5,
    sheetContentWidth4 = 640,
    sheetContentHeight4 = 128,
    time1 = 600,
    time2 = 500,
    time3 = 800,
    time4 = 1300
}

local config = {config1, config2, config3}

function shooter.init ()

    local sheet = {
        width = 128,
        height = 128,
        numFrames = 8,
        sheetContentWidth = 1024,
        sheetContentHeight = 128
    }
    
    shooter.playerImage1Running = graphics.newImageSheet('Sprites/Soldier_1/Run.png', sheet)

    shooter.sequenceRun = {
        name = 'running',
        start = 1,
        count = 8,
        time = 500,
        loopCount = 0,
        loopDirection = 'forward'
    }    

    return shooter
end

function shooter.initop1 (operator)
    
    local sht = setmetatable({}, shooter)
    local sheetData1 = {
        width = config[operator].width1,
        height = config[operator].height1,
        numFrames = config[operator].numFrames1,
        sheetContentWidth = config[operator].sheetContentWidth1,
        sheetContentHeight = config[operator].sheetContentHeight1
    }
    
    local sheet1 = graphics.newImageSheet('Sprites/Soldier_'..operator..'/Run.png', sheetData1)

    local sheetData2 = {
        width = config[operator].width2,
        height = config[operator].height2,
        numFrames = config[operator].numFrames2,
        sheetContentWidth = config[operator].sheetContentWidth2,
        sheetContentHeight = config[operator].sheetContentHeight2
    }

    local sheet2 = graphics.newImageSheet('Sprites/Soldier_'..operator..'/Idle.png', sheetData2)

    local sheetData3 = {
        width = config[operator].width3,
        height = config[operator].height3,
        numFrames = config[operator].numFrames3,
        sheetContentWidth = config[operator].sheetContentWidth3,
        sheetContentHeight = config[operator].sheetContentHeight3
    }

    local sheet3 = graphics.newImageSheet('Sprites/Soldier_'..operator..'/Shot_1.png', sheetData3)

    local sheetData4 = {
        width = config[operator].width4,
        height = config[operator].height4,
        numFrames = config[operator].numFrames4,
        sheetContentWidth = config[operator].sheetContentWidth4,
        sheetContentHeight = config[operator].sheetContentHeight4
    }

    local sheet4 = graphics.newImageSheet('Sprites/Soldier_'..operator..'/Dead.png', sheetData4)

    local sequenceData = {
        {
            name = 'op1Running',
            sheet = sheet1,
            start = 1,
            count = 8,
            time = config[operator].time1,
            loopDirection = 'forward'
        },
        {
            name = 'op1Idle',
            sheet = sheet2,
            start = 1,
            count = 7,
            time = config[operator].time2,
            loopDirection = 'forward'
        },
        {
            name = 'op1Shoot',
            sheet = sheet3,
            start = 1,
            count = 4,
            time = config[operator].time3,
            loopDirection = 'forward'
        },
        {
            name = 'op1Dead',
            sheet = sheet4,
            start = 1,
            count = 7,
            time = config[operator].time4,
            loopCount = 1,
            loopDirection = 'forward'
        }
    }
    sht.animation = display.newSprite( sheet1, sequenceData )
    
    return sht
end

function shooter:shoot()

    self.animation:setSequence( "op1Shoot" )
    self.animation:play()

    timer.performWithDelay(5000, function()
        self.animation:setSequence( "op1Idle" )
        self.animation:play()
    end)
end

function shooter:idle()

    self.animation:setSequence( "op1Idle" )
    self.animation:play()

    timer.performWithDelay(3000, function() self:shoot() end)

end

function shooter:renderGameSequence()

    self.animation.x = 0
    self.animation.y = display.contentCenterY * 1.8
    self.animation:scale(2, 2)
    self.animation:setSequence("op1Running")
    self.animation:play()

    local T1 = transition.to(self.animation, {
        x = display.contentCenterX * 0.5,
        y = display.contentCenterY * 1.5,
        time = 2000,
        onComplete = function() self:idle() end
    })

end

function shooter:Tidle()
    self.animation:setSequence("op1Idle")
    self.animation:play()

    local randomNumber = math.random(2)
    local randomValue = 0.8 + math.random() * 0.8
    if randomNumber == 1 then
        -- Probabilidad del 33%
        timer.performWithDelay(4000*randomValue, function() 
            self.animation:setSequence("op1Dead")
            self.animation:play()
        end)
    end
end
function shooter:renderTargetSequence(finalX, finalY)

    self.animation.x = CW*1.3
    self.animation.y = display.contentCenterY * 1.8
    self.animation.xScale = -1
    self.animation:scale(2, 2)
    self.animation:setSequence("op1Running")
    self.animation:play()

    local T1 = transition.to(self.animation, {
        x = finalX,
        y = finalY,
        time = 2500,
        onComplete = function() self:Tidle() end
    })

end

function shooter.renderRunIntro(callback)
    shooter.player = display.newSprite(shooter.playerImage1Running, shooter.sequenceRun)
    shooter.player.x = 0
    shooter.player.y = display.contentCenterY * 0.7  
    shooter.player:scale(3,3)
    shooter.player:play()

    local T1 = transition.to(shooter.player, {
        x = display.contentCenterX * 2,
        y = display.contentCenterY * 0.7 ,
        time = 2000,
        onComplete = function()
            callback()
            shooter.destroy()
        end
    })
end

function shooter.destroy ()
    shooter.player:removeSelf()
    shooter.player = nil
end

return shooter