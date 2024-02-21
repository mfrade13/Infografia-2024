-- Import

local composer = require("composer")
local relayout = require("libs.relayout")
local utilities = require("classes.utilities")


local _W, _H, _CX, _CY = relayout._W, relayout._H, relayout._CX, relayout._CY 

-- Scene
local scene = composer.newScene()

-- Grupos
local _grpMain
local _grpContent

-- Sonidos
local _click = audio.loadStream("assets/sounds/click.mp3")


--
-- Funciones

local function gotoMenu()

    utilities:playSound(_click)
    composer.gotoScene("scenes.menu")
end

local function gotoGame()

    utilities:playSound(_click)
    composer.gotoScene("scenes.game")
end


--
-- Scene events

function scene:create( event )

    print("scene:create - game over")

    _grpMain = display.newGroup()

    self.view:insert(_grpMain)

    local background = display.newImageRect(_grpMain, "assets/images/background.jpg", _W, _H)
    background.x = _CX
    background.y = _CY

    _grpContent = display.newGroup()
    _grpMain:insert(_grpContent)

    -- Titulo

    local title = display.newText("Game over", _CX, 100, native.systemFont, 60)
    title.fill = { 0, 0, 0 }
    _grpContent:insert(title)   

    local isHighscore = utilities:setHighscore(utilities:getTmpScore())

    local lblScore = display.newText("Score: " .. utilities:getTmpScore(), _CX, _CY - 30, native.systemFont, 26)
    lblScore.fill = { 0, 0, 0 }
    _grpContent:insert(lblScore)

    local lblCurrentHighscore = display.newText("Highscore: " .. utilities:getHighscore(), _CX, _CY - 5, native.systemFont, 16)
    lblCurrentHighscore.fill = { 0, 0, 0 }
    _grpContent:insert(lblCurrentHighscore)

    if isHighscore then
        local lblHighscore = display.newText("HIGHSCORE!", _CX, _CY - 80, native.systemFont, 30)
        lblHighscore.fill = { 0, 0, 0 }
        _grpContent:insert(lblHighscore)

        transition.to(lblHighscore, {time=200, xScale=1.5, yScale=1.5})
        transition.to(lblHighscore, {time=200, xScale=1, yScale=1, delay=200})
        transition.to(lblHighscore, {time=200, xScale=1.5, yScale=1.5, delay=400})
        transition.to(lblHighscore, {time=200, xScale=1, yScale=1, delay=600})
        transition.to(lblHighscore, {time=200, xScale=1.5, yScale=1.5, delay=800})
        transition.to(lblHighscore, {time=200, xScale=1, yScale=1, delay=1000})
    end

    -- Restart btn
    local btnPlay = display.newRoundedRect( _grpContent, _CX, _CY + 80, 220, 80, 20)
    btnPlay.fill = { 1, 1, 1 }
    btnPlay.alpha = 0.4;

    btnPlay:addEventListener("tap", gotoGame)

    local lblPlay = display.newText("Restart", _CX, _CY + 84, native.systemFont, 50)
    lblPlay.fill = { 0, 0, 0 }
    _grpContent:insert(lblPlay)

    -- Menu btn
    local btnMenu = display.newText("Menu", _CX, _H - 100, native.systemFont, 26)
    btnMenu.fill = { 0, 0, 0 }
    _grpContent:insert(btnMenu)

    btnMenu:addEventListener("tap", gotoMenu)

end

function scene:show( event )

    if ( event.phase == "will" ) then
    elseif ( event.phase == "did" ) then
    end
end

function scene:hide( event )

    if ( event.phase == "will" ) then
    elseif ( event.phase == "did" ) then
    end
end

function scene:destroy( event )

    if ( event.phase == "will" ) then
    elseif ( event.phase == "did" ) then
    end
end

-- listeners

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene