-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

display.setStatusBar(display.HiddenStatusBar)
native.setProperty("preferredScreenEdgesDeferringSystemGestures", true)

-- Music
local utilities = require("classes.utilities")
local music = audio.loadStream("assets/sounds/loop1.mp3")
utilities:playMusic(music)

-- Create composer
local composer = require('composer')
composer.recycleOnSceneChange = true
composer.gotoScene( "scenes.menu" )