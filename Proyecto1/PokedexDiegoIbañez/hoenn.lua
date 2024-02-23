local composer = require("composer")
local json = require("json")
local network = require("network")

local scene = composer.newScene()

local CW, CH = display.contentWidth, display.contentHeight
local carpeta_recursos = "resources/"

local botonSound = audio.loadSound(carpeta_recursos .. "SoundA.mp3")
local descripcionText, NumeroText
local fondo, titulo, botonVolver, imagenArriba, imagenAbajo, imagenEstatica, PokedexImg
local inputID, btnBuscar
local pokemonID = 1  
local previousBtn, nextBtn  

local deslizadoArriba, deslizadoAbajo  

function scene:create(event)
    local sceneGroup = self.view

    
    fondo = display.newImageRect(carpeta_recursos .. "Fondo.jpg", 360, 480)
    fondo.x = display.contentCenterX
    fondo.y = display.contentCenterY

    
    titulo = display.newImageRect(carpeta_recursos .. "Hoenn.PNG", 160, 60)  
    titulo.x = display.contentCenterX
    titulo.y = 45

    
    botonVolver = display.newImageRect(carpeta_recursos .. "Volver.PNG", 80, 50)
    botonVolver.x = CW * 0.1
    botonVolver.y = CH * 0.1
    botonVolver:addEventListener("tap", function()
        composer.removeScene("hoenn")  
        composer.gotoScene("Menu", {effect = "slideRight", time = 500}) 
    end)

    
    imagenEstatica = display.newImageRect(carpeta_recursos .. "PokedexHoennPantalla.jpg", CW * 0.8, CH * 0.45)
    imagenEstatica.x = CW / 2
    imagenEstatica.y = CH *0.6

    
    imagenAbajo = display.newImageRect(carpeta_recursos .. "PokedexHoennAbajo.jpg", CW * 0.8, CH * 0.3)
    imagenAbajo.x = CW / 2
    imagenAbajo.y = CH * 0.75
    imagenAbajo.originalY = imagenAbajo.y  

    
    imagenArriba = display.newImageRect(carpeta_recursos .. "PokedexHoennArriba.jpg", CW * 0.8, CH * 0.3)
    imagenArriba.x = CW / 2
    imagenArriba.y = CH / 2
    imagenArriba.originalY = imagenArriba.y  

    descripcionText = display.newText({
        text = "",
        x = CW * 0.51,
        y = CH * 0.92,
        width = CW * 0.8,
        height = CH * 0.5,
        font = native.systemFont,
        fontSize = 10,
        align = "left"
    })
    descripcionText:setFillColor(0, 0, 0)

    
    previousBtn = display.newText("<", CW * 0.3, CH * 0.5, native.systemFont, 40)
    previousBtn:setFillColor(0, 0, 0)
    previousBtn:addEventListener("tap", function()
        audio.play(botonSound)
        pokemonID = pokemonID - 1
        if pokemonID < 252 then
            pokemonID = 252
        end
        if pokemonID > 386 then
            pokemonID = 386
        end
        cargarPokemon(pokemonID)
    end)

    nextBtn = display.newText(">", CW * 0.7, CH * 0.5, native.systemFont, 40)
    nextBtn:setFillColor(0, 0, 0)
    nextBtn:addEventListener("tap", function()
        audio.play(botonSound)
        pokemonID = pokemonID + 1
        if pokemonID < 252 then
            pokemonID = 252
        end
        if pokemonID > 386 then
            pokemonID = 386
        end
        cargarPokemon(pokemonID)
    end)

    inputID = native.newTextField(display.contentCenterX, 120, 200, 40)
    inputID.placeholder = "ID del Pokémon"
    
    btnBuscar = display.newRect(250, 170 , 80, 40)
    btnBuscar:setFillColor(0.5, 0.5, 0.5)
    local txtBuscar = display.newText("Buscar", 250, 170, native.systemFont, 20)
    txtBuscar:setFillColor(1, 1, 1)
    btnBuscar:addEventListener("tap", buscarPokemon)

    deslizadoArriba = false


    local function deslizarArriba(event)
        if event.phase == "began" and not deslizadoArriba then
            transition.to(imagenArriba, {y = imagenArriba.y - 100, time = 500})
            deslizadoArriba = true
        end
    end


    deslizadoAbajo = false


    local function deslizarAbajo(event)
        if event.phase == "began" and not deslizadoAbajo then
            transition.to(imagenAbajo, {y = imagenAbajo.y + 100, time = 500})
            deslizadoAbajo = true
        end
    end


    local pantalla = display.newRect(CW / 2, CH / 2, CW, CH)
    pantalla.alpha = 0.01  
    pantalla:addEventListener("touch", deslizarArriba) 
    pantalla:addEventListener("touch", deslizarAbajo)   

    NumeroText = display.newText({
        text = "",
        x = CW * 0.67,
        y = CH * 0.45,
        width = CW * 0.4,
        height = CH * 0.1,
        font = native.systemFont,
        fontSize = 12,
        align = "left"
    })
    NumeroText:setFillColor(0, 0, 0)
    
    sceneGroup:insert(fondo)
    sceneGroup:insert(titulo)
    sceneGroup:insert(botonVolver)
    sceneGroup:insert(imagenEstatica)
    sceneGroup:insert(pantalla)
    sceneGroup:insert(previousBtn)
    sceneGroup:insert(nextBtn)
    sceneGroup:insert(inputID)
    sceneGroup:insert(imagenArriba)
    sceneGroup:insert(imagenAbajo)
    sceneGroup:insert(btnBuscar)
    sceneGroup:insert(txtBuscar)
    sceneGroup:insert(descripcionText)
    sceneGroup:insert(NumeroText)
    
end

function buscarPokemon()
    local id = tonumber(inputID.text)
    if id then
        if id < 252 then
            id = 252
        elseif id > 386 then
            id = 386
        end
        pokemonID = id
        cargarPokemon(pokemonID)
    else
        print("Por favor ingrese un ID válido")
    end
end

function cargarPokemon(id)
    local url_imagen = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/" .. id .. ".png"
    display.loadRemoteImage(
        url_imagen,
        "GET",
        function(event)
            if (event.isError) then
                print("Error al cargar la imagen")
            else
              
                if PokedexImg then
                    PokedexImg:removeSelf()
                    PokedexImg = nil
                end
                NumeroText.text = id
                PokedexImg = event.target
                PokedexImg.x = CW * 0.5
                PokedexImg.y = CH * 0.54
                scene.view:insert(PokedexImg)
            end
        end,
        "pokemon" .. id .. ".png",
        system.TemporaryDirectory
    )

    
    local url_descripcion = "https://pokeapi.co/api/v2/pokemon-species/" .. id

    network.request(
        url_descripcion,
        "GET",
        function(event)
            if (not event.isError) then
                local data = json.decode(event.response)
                local description = "Descripción no disponible"
                for _, entry in ipairs(data.flavor_text_entries) do
                    if entry.language.name == "es" then
                        description = entry.flavor_text
                        break
                    end
                end
                descripcionText.text = description
            else
                print("Error al cargar la descripción del Pokémon")
            end
        end
    )
end



function scene:destroy(event)
    local sceneGroup = self.view
end

scene:addEventListener("create", scene)
scene:addEventListener("destroy", scene)

return scene
