--
-- Import

local composer = require("composer")
local relayout = require("libs.relayout")
local utilities = require("classes.utilities")


--
-- Set variables

-- Layout
local _W, _H, _CX, _CY = relayout._W, relayout._H, relayout._CX, relayout._CY 

-- Scene
local scene = composer.newScene()

-- Groups
local _grpMain

-- Sounds
local _click = audio.loadStream("assets/sounds/click.mp3")


--
-- Local functions

local function gotoGame()

    utilities:playSound(_click)

    composer.gotoScene( "scenes.game" )
end

local function gotoSettings()

    utilities:playSound(_click)

    composer.gotoScene( "scenes.settings" )
end


--
-- Scene events functions

function scene:create( event )

    print("scene:create - menu")

    _grpMain = display.newGroup()

    self.view:insert(_grpMain)

    local background = display.newImageRect(_grpMain, "assets/images/background.jpg", _W, _H)
    background.x = _CX
    background.y = _CY

    local lblTitle = display.newText("Colors!", _CX, 100, native.systemFont, 76)
    lblTitle.fill = { 1, 1, 1 }
    _grpMain:insert(lblTitle)

    local btnPlay = display.newRoundedRect( _grpMain, _CX, _CY, 220, 80, 20)
    btnPlay.fill = { 1, 1, 1 }
    btnPlay.alpha = 0.4;

    local lblPlay = display.newText("Play", _CX, _CY + 4, native.systemFont, 50)
    lblPlay.fill = { 0, 0, 0 } 
    _grpMain:insert(lblPlay)

    btnPlay:addEventListener("tap", gotoGame)

    local lblSettings = display.newText("Settings", _CX, _H - 200, native.systemFont, 40)
    lblSettings.fill = { 0, 0, 0 }
    _grpMain:insert(lblSettings)

    lblSettings:addEventListener("tap", gotoSettings)

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


--
-- Listeners

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene