-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

display.setStatusBar( display.HiddenStatusBar )

local CW = display.contentWidth
local CH = display.contentHeight

------------------------------
-- CREATE NEW GROUPS
------------------------------
local screenGroup = display.newGroup()

----------------------
-- BEGIN SAMPLE CODE
----------------------

-- Require libraries/plugins
local widget = require( "widget" )
local textbox

local function onOrientationChange( event )
	local orientation = system.orientation
--	"faceDown"
	local text = textbox.text
	if orientation == "portrait" or orientation == "portraitUpsideDown" then
		display.remove(screenGroup)
		screenGroup = display.newGroup()
		portrait()
		textbox.text=text
	elseif   orientation == "landscapeLeft" or orientation == "landscapeRight" then 
		display.remove(screenGroup)
		screenGroup = display.newGroup()
		landscape()
		textbox.text=text
	end

end

-- Add Event Listener for orientation
Runtime:addEventListener( "orientation", onOrientationChange ) 

function Displaybckground(x, y)
	-- Background image
	local background = display.newImageRect( screenGroup, "Fondo.png", 10000, 10000 )
	background.x, background.y = display.contentCenterX, display.contentCenterY

	-- Textbox
	textbox = display.newText( screenGroup, "", x, y, native.systemFont, 35 )
	textbox:setFillColor( 1,1,1 )
	textbox.anchorX = 1
	textbox.align = "right"
end

----------------------
-- BUTTON FUNCTIONS
----------------------

local calculate=""

-- AC function
function cleanEvent( event )
	textbox.text = ''
	calculate = ""
	textbox.size =35
end

-- Operators function
function operation( event )
	if textbox.text == "Syntax Error" then
		calculate = event.target.value
		textbox.text = event.target.value
	elseif event.target.value == "sin" or  event.target.value == "cos" or event.target.value == "tan" then
		calculate = calculate .. " math." .. event.target.value .."("
		textbox.text = textbox.text .. " " .. event.target.value .. "("
	elseif event.target.value == "ln" then
		calculate = calculate .. " math.log("
		textbox.text = textbox.text .. " " .. event.target.value .."("
	elseif event.target.value == "log" then
		calculate = calculate .. " math.log10("
		textbox.text = textbox.text .. " " .. event.target.value .."("
	elseif event.target.value == "e" then
		calculate = calculate .. " math.exp(1)"
		textbox.text = textbox.text .. "" .. event.target.value
	elseif event.target.value == "π" then
		calculate = calculate .. " math.pi"
		textbox.text = textbox.text .. "" .. event.target.value
	elseif event.target.value == "√" then
		calculate = calculate .. " math.sqrt("
		textbox.text = textbox.text .. " √("
	elseif event.target.value == "x^2" then
		calculate = calculate .. "^2"
		textbox.text = textbox.text .. "^2"
	elseif event.target.value == "1/x" then
		calculate = calculate .. "1/"
		textbox.text = textbox.text .. "1/"
	else
		calculate = calculate .. "" .. event.target.value
		textbox.text = textbox.text .. "" .. event.target.value
	end
	verify_border()
end

-- Delete function
function delete( event )
	
	if string.ends(textbox.text, "sin")  or string.ends(textbox.text, "cos") or string.ends(textbox.text, "tan") then
		calculate = calculate:sub(1, -9)
		textbox.text = textbox.text:sub(1, -4)
	elseif string.ends(textbox.text, "log")then
		calculate = calculate:sub(1, -11)
		textbox.text = textbox.text:sub(1, -4)
	elseif string.ends(textbox.text, "ln")then
		calculate = calculate:sub(1, -9)
		textbox.text = textbox.text:sub(1, -3)
	elseif string.ends(textbox.text, "e")then
		calculate = calculate:sub(1, -12)
		textbox.text = textbox.text:sub(1, -2)	
	elseif string.ends(textbox.text, "π") then
		calculate = calculate:sub(1, -8)
		textbox.text = textbox.text:sub(1, -3)	
	else
		textbox.text = textbox.text:sub(1, -2)
		calculate = calculate:sub(1, -2)
	end
end

-- Calculate
function Calculate( event )
	local expression = "return " .. calculate
	local func = loadstring(expression)
	if pcall(func) then
		textbox.text = func()
		calculate = textbox.text
	else
		textbox.text = "Syntax Error"
		calculate = ""
	end
end


function isNumber( value )
    local pattern = "^[-+]?%d*%.?%d+$"
    return value:match(pattern) ~= nil
end

--Round
function round( event )
	if isNumber(textbox.text)then
		local expression = "return math.floor(" .. calculate .. "+ 0.5)"
		local func = loadstring(expression)
		textbox.text = func()
		calculate = textbox.text
	end
end

----------------------
-- BUTTON DECLARATION
----------------------
local radio = 0.4*display.contentWidth/4
local diametro = 2*radio + 6
local min_x = radio/2
local min_y = CH*2/5

function createButton(options, value, group )
	local button = widget.newButton(options)
	button.value = value
	group:insert( button )
end

function landscape()
	local r = radio*5/8
	local d = 2*r+12

	local m_y = display.contentHeight*2/5
	local m_x = display.screenOriginY - display.contentWidth/r
	Displaybckground(display.contentWidth - r, 70+display.screenOriginY)
	local Vlist = {
		"AC", "7","8","9","*", "sin", "^", "√",
		"(", "4","5","6","+",  "cos", "e", "x^2",
		")", "1","2","3","-", "tan", "log", "1/x",
		"/", "0",".","<-","=", "π" , "ln", ".00"
	}
	local x = 0 
	local y = 0
	local event = operation

	for i=1, 32 do
		if Vlist[i] == "=" then
			event = Calculate
		elseif Vlist[i] == "AC" then
			event = cleanEvent 
		elseif Vlist[i] == "<-" then 
			event = delete
		elseif Vlist[i] == ".00" then 
			event = round
		else 
			event = operation
		end
		local options = {
			label = Vlist[i],
			labelAlign ='center',
			id = Vlist[i],
			left = m_x + x*d,
			top = m_y + y*d,
			width = 50,
        	height = 30,
			cornerRadius  = r,
			shape = "roundedRect",
			fontSize = 22,
			fillColor = { default={ 0.31, 0.31, 0.31}, over={ 0.31, 0.31, 0.31} },
			labelColor = { default={ 1,1,1,1}, over={ 1,1,1,1} },
			onPress = event
		}
		createButton(options, Vlist[i], screenGroup)
		x = x + 1
		if x > 7 then
			x = 0
			y = y + 1
		end
	end
end

function portrait()
	Displaybckground(display.contentWidth - radio, 150+display.screenOriginY)
	local m_y = display.contentHeight*2/5
	local m_x = display.screenOriginY
	local Vlist = {
		"AC", "(",")","/",
		"7","8","9","*",
		"4","5","6","+",
		"1","2","3","-",
		"0",".","<-","="
	}
	local x = 0 
	local y = 0
	local event

	for i=1, 20 do
		if Vlist[i] == "=" then
			event = Calculate
		elseif Vlist[i] == "AC" then
			event = cleanEvent 
		elseif Vlist[i] == "<-" then 
			event = delete
		else 
			event = operation
		end
		local options = {
			label = Vlist[i],
			labelAlign ='center',
			id = Vlist[i],
			left = min_x + x*diametro,
			top = min_y + y*diametro,
			radius = radio,
			shape = "circle",
			fontSize = 35,
			fillColor = { default={ 0.31, 0.31, 0.31}, over={ 0.31, 0.31, 0.31} },
			labelColor = { default={ 1,1,1,1}, over={ 1,1,1,1} },
			onPress = event
		}
		createButton(options, Vlist[i], screenGroup)
		x = x + 1
		if x > 3 then
			x = 0
			y = y + 1
		end
	end
end

function verify_border()
    if textbox.size > 20 then 
		print(string.len( textbox.text ), display.contentWidth / textbox.size)
		if (string.len( textbox.text ) > display.contentWidth / textbox.size) then
			textbox.size = textbox.size - 3
		end
	end
end

portrait()