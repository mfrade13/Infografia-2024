local composer = require("composer")
local json = require("json")
local network = require("network")

local scene = composer.newScene()

local CW, CH = display.contentWidth, display.contentHeight
local carpeta_recursos = "resources/"

local botonSound = audio.loadSound(carpeta_recursos .. "SoundA.mp3")
local descripcionText , NumeroText
local fondo, titulo, botonVolver, PokedexImg
local inputID, btnBuscar
local pokemonID = 0  
local previousBtn, nextBtn  

function scene:create(event)
    local sceneGroup = self.view

    fondo = display.newImageRect(carpeta_recursos .. "Fondo.jpg", 360, 480)
    fondo.x = display.contentCenterX
    fondo.y = display.contentCenterY

    titulo = display.newImageRect(carpeta_recursos .. "Kanto.PNG", 160, 60)  
    titulo.x = display.contentCenterX
    titulo.y = 45

    local Pokedex= display.newImageRect(carpeta_recursos .. "Poke.png", CW * 1, CH * 0.8) 
    Pokedex.x = CW / 2
    Pokedex.y = CH / 1.8

    botonVolver = display.newImageRect(carpeta_recursos .. "Volver.PNG", 80, 50)
    botonVolver.x = CW * 0.1
    botonVolver.y = CH * 0.1
    botonVolver:addEventListener("tap", function()
        composer.removeScene("kanto")  
        composer.gotoScene("Menu", {effect = "slideRight", time = 500}) 
        
    end)

    descripcionText = display.newText({
        text = "",
        x = CW * 0.77,
        y = CH * 0.54,
        width = CW * 0.4,
        height = CH * 0.2,
        font = native.systemFont,
        fontSize = 8,
        align = "left"
    })
    descripcionText:setFillColor(0, 0, 0)


    
    previousBtn = display.newText("<", CW * 0.35, CH * 0.79, native.systemFont, 40)
    previousBtn:setFillColor(0, 0, 0)
    previousBtn:addEventListener("tap", function()
        audio.play(botonSound)
        pokemonID = pokemonID - 1
        if pokemonID < 1 then
            pokemonID = 1
        end
        cargarPokemon(pokemonID)
    end)

    nextBtn = display.newText(">", CW * 0.42, CH * 0.79, native.systemFont, 40)
    nextBtn:setFillColor(0, 0, 0)
    nextBtn:addEventListener("tap", function()
        audio.play(botonSound)
        pokemonID = pokemonID + 1
        if pokemonID > 151 then
            pokemonID = 151
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

    NumeroText = display.newText({
        text = "",
        x = CW * 0.28,
        y = CH * 0.25,
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
    sceneGroup:insert(nextBtn)
    sceneGroup:insert(previousBtn)
    sceneGroup:insert(Pokedex)
    sceneGroup:insert(descripcionText)
    sceneGroup:insert(inputID)
    sceneGroup:insert(btnBuscar)
    sceneGroup:insert(txtBuscar)
    sceneGroup:insert(NumeroText)
end

function buscarPokemon()
    local id = tonumber(inputID.text)
    if id then
        if id < 1 then
            id = 1
        elseif id > 151 then
            id = 151
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
                PokedexImg.x = CW * 0.25
                PokedexImg.y = CH * 0.5
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
