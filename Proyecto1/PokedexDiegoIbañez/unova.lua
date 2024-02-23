local composer = require("composer")
local json = require("json")
local network = require("network")

local scene = composer.newScene()

local CW, CH = display.contentWidth, display.contentHeight
local carpeta_recursos = "resources/"

local descripcionText, NumeroText
local botonSound = audio.loadSound(carpeta_recursos .. "SoundA.mp3")
local fondo, titulo, botonVolver, PokedexUnovaArriba, PokedexUnovaAbajo, PokedexImg
local inputID, btnBuscar
local imagenDeslizada = false  
local pokemonID = 1 
local previousBtn, nextBtn  

function scene:create(event)
    local sceneGroup = self.view

    
    fondo = display.newImageRect(carpeta_recursos .. "Fondo.jpg", 360, 480)
    fondo.x = display.contentCenterX
    fondo.y = display.contentCenterY

 
    titulo = display.newImageRect(carpeta_recursos .. "Unova.PNG", 160, 60)  
    titulo.x = display.contentCenterX
    titulo.y = 45

    
    botonVolver = display.newImageRect(carpeta_recursos .. "Volver.PNG", 80, 50)
    botonVolver.x = CW * 0.1  
    botonVolver.y = CH * 0.1
    botonVolver:addEventListener("tap", function()
        composer.removeScene("unova")  
        composer.gotoScene("Menu", {effect = "slideRight", time = 500}) 
    end)

    
    PokedexUnovaArriba = display.newImageRect(carpeta_recursos .. "PokedexUnovaArriba.png", 250, 135)
    PokedexUnovaArriba.x = CW / 2
    PokedexUnovaArriba.y = CH *0.6

    PokedexUnovaAbajo = display.newImageRect(carpeta_recursos .. "PokedexUnovaAbajo.png", 250, 300)
    PokedexUnovaAbajo.x = CW / 2
    PokedexUnovaAbajo.y = CH * 0.68

    
    local function deslizarImagen(event)
        if event.phase == "began" and not imagenDeslizada then
            transition.to(PokedexUnovaArriba, {y = PokedexUnovaArriba.y - 150, time = 500})
            imagenDeslizada = true  
        end
    end

    descripcionText = display.newText({
        text = "",
        x = CW * 0.51,
        y = CH * 0.52,
        width = CW * 0.6,
        height = CH * 0.2,
        font = native.systemFont,
        fontSize = 12,
        align = "left"
    })
    descripcionText:setFillColor(0, 0, 0)

    
     previousBtn = display.newText("<", CW * 0.25, CH * 0.90, native.systemFont, 40)
     previousBtn:setFillColor(0, 0, 0)
     previousBtn:addEventListener("tap", function()
        audio.play(botonSound)
         pokemonID = pokemonID - 1
         if pokemonID < 494 then
            pokemonID = 494
        end
        if pokemonID > 649 then
            pokemonID = 649
        end
         cargarPokemon(pokemonID)
     end)
 
     nextBtn = display.newText(">", CW * 0.75, CH * 0.90, native.systemFont, 40)
     nextBtn:setFillColor(0, 0, 0)
     nextBtn:addEventListener("tap", function()
        audio.play(botonSound)
         pokemonID = pokemonID + 1
         if pokemonID < 494 then
            pokemonID = 494
        end
        if pokemonID > 649 then
            pokemonID = 649
        end
         cargarPokemon(pokemonID)
     end)
 
     inputID = native.newTextField(display.contentCenterX, CH * 0.75, 200, 40)
     inputID.placeholder = "ID del Pokémon"
     
     btnBuscar = display.newRect(CW/2, CH * 0.90 , 80, 40)
     btnBuscar:setFillColor(0.5, 0.5, 0.5)

     local txtBuscar = display.newText("Buscar", CW/2, CH * 0.90, native.systemFont, 20)
     txtBuscar:setFillColor(1, 1, 1)
     btnBuscar:addEventListener("tap", buscarPokemon)

    
    local pantalla = display.newRect(CW / 2, CH / 2, CW, CH)
    pantalla.alpha = 0.01  
    pantalla:addEventListener("touch", deslizarImagen)

    NumeroText = display.newText({
        text = "",
        x = CW * 0.45,
        y = CH * 0.3,
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
    sceneGroup:insert(PokedexUnovaArriba)
    sceneGroup:insert(PokedexUnovaAbajo)
    sceneGroup:insert(pantalla)
    sceneGroup:insert(previousBtn)
    sceneGroup:insert(nextBtn)
    sceneGroup:insert(inputID)
    sceneGroup:insert(btnBuscar)
    sceneGroup:insert(txtBuscar)
    sceneGroup:insert(descripcionText)
    sceneGroup:insert(NumeroText)
end

function buscarPokemon()
    local id = tonumber(inputID.text)
    if id then
        if id < 494 then
            id = 494
        elseif id > 649 then
            id = 649
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
                PokedexImg.x = CW * 0.50
                PokedexImg.y = CH * 0.26
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
