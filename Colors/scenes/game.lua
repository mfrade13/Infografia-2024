--
-- Import

local composer = require("composer") -- Importando Composer para el manejo de escenas
local relayout = require("libs.relayout") -- Importando una biblioteca para ajuste de diseño
local utilities = require("classes.utilities") -- Importando una clase de utilidades


-- Variables
local _W, _H, _CX, _CY = relayout._W, relayout._H, relayout._CX, relayout._CY  -- Obteniendo dimensiones de la pantalla

-- Escena
local scene = composer.newScene() -- Creando una nueva escena con Composer

-- Groups
local _grpMain -- Grupo principal de visualización
local _grpBackgrounds -- Grupo para los objetos de fondo
local _grpWorld -- Grupo para los objetos del mundo
local _grpHud -- Grupo para los elementos de la interfaz de usuario (HUD)

-- Misc
local _playing = false -- Bandera para rastrear si el juego está en curso
local _score = 0 -- Puntuación del jugador
local _blockWidth = _W * 0.25 -- Ancho de cada bloque
local _words = {"Awesome", "Nice", "Wow", "Great"} -- Array de palabras para efectos visuales

-- Interfaz de usuario (HUD)
local _lblScore = "" -- Etiqueta de puntuación
local _lblTapToStart = "" -- Etiqueta para "Toque para comenzar"

-- Object
local _player -- Objeto del jugador
--bloques
local _b1
local _b2
local _b3
local _b4
local _backgrounds = {} -- Array para almacenar objetos de fondo
local _blockIDS = {1, 2, 3, 4} -- Array para rastrear IDs de bloques
local _blocks = {} -- Array para almacenar objetos de bloque

-- Colors
local _clrRed = {209/255, 42/255, 95/255}
local _clrGreen = {122/255, 184/255, 79/255}
local _clrBlue = {77/255, 157/255, 191/255}
local _clrYellow = {201/255, 201/255, 85/255}

-- Sounds
local _sndJump = audio.loadStream("assets/sounds/jump.mp3")
local _sndLose = audio.loadStream("assets/sounds/crash.mp3")
local _click = audio.loadStream("assets/sounds/click.mp3")

--
-- Functions

local touch = {}
local enterFrame = {}


--
-- Local functions

-- Función para ir a la escena de fin del juego
local function gotoGameover()

    composer.gotoScene("scenes.gameover")
end

local function gameOver()

    Runtime:removeEventListener("touch", touch)
    Runtime:removeEventListener("enterFrame", enterFrame)

    utilities:playSound(_sndLose)

    _playing = false

    utilities:setTmpScore(_score)

    transition.to(_player, {time=550, xScale=0.01, yScale=0.01, onComplete=gotoGameover})
end

-- Función para mezclar elementos en una tabla
local function shuffle(tbl)
    local len = #tbl -- obtienes el lenght de table / list

    -- Hacemos un random y retornamos
   
    for i = len, 2, -1 do
        local j = math.random( 1, i )

        tbl[i], tbl[j] = tbl[j], tbl[i]
    end

    return tbl;
end

-- Función para aleatorizar colores y posiciones de los bloques
local function randomizeBlocks()

    _player.colorID = math.random(1, 4)

    if _player.colorID == 1 then
        _player.fill = _clrRed
    elseif _player.colorID == 2 then
        _player.fill = _clrGreen
    elseif _player.colorID == 3 then
        _player.fill = _clrBlue
    else
        _player.fill = _clrYellow
    end

    --

    _blockIDS = shuffle(_blockIDS)

    for i=1, #_blocks do
        local block = _blocks[i]
        block.colorID = _blockIDS[i]

        if block.colorID == 1 then
            block.fill = _clrRed
        elseif block.colorID == 2 then
            block.fill = _clrGreen
        elseif block.colorID == 3 then
            block.fill = _clrBlue
        else
            block.fill = _clrYellow
        end
    end
end

-- Función para verificar colisión entre jugador y un bloque
local function checkCollision(block)

    local left  = (block.contentBounds.xMin) <= _player.contentBounds.xMin and (block.contentBounds.xMax) >= _player.contentBounds.xMin
    local right = (block.contentBounds.xMin) >= _player.contentBounds.xMin and (block.contentBounds.xMin) <= _player.contentBounds.xMax
    local up    = (block.contentBounds.yMin) <= _player.contentBounds.yMin and (block.contentBounds.yMax) >= _player.contentBounds.yMin
    local down  = (block.contentBounds.yMin) >= _player.contentBounds.yMin and (block.contentBounds.yMin) <= _player.contentBounds.yMax + 2

    return (left or right) and (up or down)
end

-- Función para subir los bloques del juego y la puntuación
local function increaseLevel()
    -- tengo que verificar si mi jugador puede incrementar su score (solo puedo incrementar mi score una vez por direccion)
    if _player.canIncreaseScore and _playing then
        _player.canIncreaseScore = false

        utilities:playSound(_sndJump)

        _score = _score + 1

        _lblScore.text = _score

        -- Animar nuestra lbl del score
        transition.to(_lblScore, {time=150, xScale=1.5, yScale=1.5})
        transition.to(_lblScore, {time=150, xScale=1, yScale=1, delay=150})

        -- mostrar las palabras de aliento
        local rand = math.random(1, #_words)
        local lblRandom = display.newText(_words[rand], _CX, _CY, native.systemFont, 46)
        lblRandom.fill = { 1, 1, 1 }
        _grpHud:insert(lblRandom)

        transition.to(lblRandom, {time=300, y=_CY - 60, alpha=0, delay=600, onComplete=function(obj)
            obj:removeSelf()
        end})
        --vamos subiendo y si llegamos a y=450 entonces bajamos desde donde empezamos
        if _player.y > 450 then
            transition.to(_b1, {time=100, y=_b1.y-20})
            transition.to(_b2, {time=100, y=_b2.y-20})
            transition.to(_b3, {time=100, y=_b3.y-20})
            transition.to(_b4, {time=100, y=_b4.y-20})
            transition.to(_player, {time=100, y=_player.y-20})
        else
            transition.to(_b1, {time=100, y=_b1.y+400})
            transition.to(_b2, {time=100, y=_b2.y+400})
            transition.to(_b3, {time=100, y=_b3.y+400})
            transition.to(_b4, {time=100, y=_b4.y+400})
            transition.to(_player, {time=100, y=_player.y+400})
        end
    end
end

-- Manejar los eventos touch
function touch( event ) 

    if event.phase == 'began' then
        -- Comienza el juego
        if _playing == false then
            _playing = true

            utilities:playSound(_sndJump)

            transition.to(_lblTapToStart, {time=200, alpha=0})
            transition.to(_lblScore, {time=200, alpha=0.3, delay=400})
        --pero si el juego ya esta corriendo:
        else
            --lo declaro en falso para que se resetee cada vez que toco la pantalla
            _player.crashed = false

            if checkCollision(_b1) and _b1.colorID ~= _player.colorID then
                _player.crashed = true
            elseif checkCollision(_b2) and _b2.colorID ~= _player.colorID then
                _player.crashed = true
            elseif checkCollision(_b3) and _b3.colorID ~= _player.colorID then
                _player.crashed = true
            elseif checkCollision(_b4) and _b4.colorID ~= _player.colorID then
                _player.crashed = true
            end

            if _player.crashed == false then
                increaseLevel()
            else
                gameOver()
            end
        end
    end
end

--movemos al jugador
function enterFrame()

    if _playing then
        if _player.direction == 'right' then
            _player.x = _player.x + _player.speed
        else
            _player.x = _player.x - _player.speed
        end

        --si llega al final de la screen cambiamos de direccion
        if _player.x > (_W - _player.width / 2) then
            if not _player.canIncreaseScore then
                _player.direction = 'left'
                _player.canIncreaseScore = true
                --cambiamos los colores de los bloques y del player
                randomizeBlocks()
            else
                gameOver()
            end
        end

        --Hacemos lo mismo solo que a la izquierda
        if _player.x < (0 + _player.width / 2) then
            if not _player.canIncreaseScore then
                _player.direction = 'right'
                _player.canIncreaseScore = true

                randomizeBlocks()
            else
                gameOver()
            end
        end
    end
end


--
-- Función de crear la escena

function scene:create( event )

    print("scene:create - game")

    _grpMain = display.newGroup()

    self.view:insert(_grpMain)

    --

    _grpBackgrounds = display.newGroup()
    _grpMain:insert(_grpBackgrounds)

    _grpWorld = display.newGroup()
    _grpMain:insert(_grpWorld)

    _grpHud = display.newGroup()
    _grpMain:insert(_grpHud)

    --

    -- Backgrounds

    local back1 = display.newImageRect(_grpBackgrounds, "assets/images/background.jpg", _W, _H)
    back1.x = _CX
    back1.y = _CY
    back1.alpha = 0.3

    _backgrounds[#_backgrounds+1] = back1

    local back2 = display.newImageRect(_grpBackgrounds, "assets/images/background.jpg", _W, _H)
    back2.x = _CX
    back2.y = _CY - _H
    back2.alpha = 0.3

    _backgrounds[#_backgrounds+1] = back2

    local back3 = display.newImageRect(_grpBackgrounds, "assets/images/background.jpg", _W, _H)
    back3.x = _CX
    back3.y = _CY - (_H * 2)
    back3.alpha = 0.3

    _backgrounds[#_backgrounds+1] = back3

    -- lbl del Score

    _lblScore = display.newText("0", _CX, 150, native.systemFont, 78) 
    _lblScore.fill = { 1, 1, 1 }
    _lblScore.alpha = 0 
    _grpHud:insert(_lblScore)

    -- lbl del tap to start
    _lblTapToStart = display.newText("Tap to start", _CX, _CY, native.systemFont, 46)
    _lblTapToStart.fill = { 1, 1, 1 }
    _grpHud:insert(_lblTapToStart)

    transition.to(_lblTapToStart, {time=2000, y=_CY + 50})
    transition.to(_lblTapToStart, {time=2000, y=_CY - 50, delay=2000})
    transition.to(_lblTapToStart, {time=2000, y=_CY + 50, delay=4000})
    transition.to(_lblTapToStart, {time=2000, y=_CY - 50, delay=6000})

    -- Bloques

    _b1 = display.newRect( _grpMain, _blockWidth * 0.5, _H - 20, _blockWidth, 10)
    _b1.colorID = 1
    _b1.fill = _clrRed
    _b1.anchorY = 0

    _blocks[#_blocks+1] = _b1

    _b2 = display.newRect( _grpMain, _blockWidth + _blockWidth * 0.5, _H - 20, _blockWidth, 10)
    _b2.colorID = 2
    _b2.fill = _clrGreen
    _b2.anchorY = 0

    _blocks[#_blocks+1] = _b2

    _b3 = display.newRect( _grpMain, _blockWidth + _blockWidth * 1.5, _H - 20, _blockWidth, 10)
    _b3.colorID = 3
    _b3.fill = _clrBlue
    _b3.anchorY = 0

    _blocks[#_blocks+1] = _b3

    _b4 = display.newRect( _grpMain, _blockWidth + _blockWidth * 2.5, _H - 20, _blockWidth, 10)
    _b4.colorID = 4
    _b4.fill = _clrYellow
    _b4.anchorY = 0

    _blocks[#_blocks+1] = _b4

    -- player
    _player = display.newRect( _grpMain, 20, _H - 26, 12, 12 )
    _player.colorID = 3 
    _player.speed = 3
    _player.direction = 'right'
    _player.crashed = false
    _player.canIncreaseScore = true 
    _player.fill = _clrBlue
    _player.showEmitterNum = 0

    randomizeBlocks()


    Runtime:addEventListener("touch", touch)
    Runtime:addEventListener("enterFrame", enterFrame)
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