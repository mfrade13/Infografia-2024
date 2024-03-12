-- Definir la clase Personaje
local Personaje = {}
Personaje.__index = Personaje

function Personaje.new()
    local self = setmetatable({}, Personaje)
    self.shape = display.newRect(0, 0, 15, 15)
    self.shape:setFillColor(0, 0, 1)
    physics.addBody(self.shape, "dynamic")
    self.shape.gravityScale = 0
    self.collisionObjects = {}
    return self
end

function Personaje:updateMovement(velocidadX, velocidadY)
    local isCollidingWithEnemy = false
    for i = 1, #self.collisionObjects do
        if self.collisionObjects[i].type == "Enemigo" then
            isCollidingWithEnemy = true
            self.shape.x = 0
            self.shape.y = 0
            break
        end
    end

    if not isCollidingWithEnemy then
        self.shape.x = self.shape.x + velocidadX
        self.shape.y = self.shape.y + velocidadY
    end
    self.collisionObjects = {}
end

-- Definir la clase Enemigo
local Enemigo = {}
Enemigo.__index = Enemigo

function Enemigo.new()
    local self = setmetatable({}, Enemigo)
    self.shape = display.newRect(display.contentCenterX, display.contentCenterY, 50, 50)
    self.shape:setFillColor(1, 0, 0)
    physics.addBody(self.shape, "dynamic")
    self.shape.gravityScale = 0
    self.shape.type = "Enemigo"
    return self
end

-- Definir la clase Pared
local Pared = {}
Pared.__index = Pared

function Pared.new(x, y, width, height)
    local self = setmetatable({}, Pared)
    self.shape = display.newRect(x, y, width, height)
    self.shape:setFillColor(0)
    physics.addBody(self.shape, "static")
    return self
end

-- Crear instancias de las clases
local personaje = Personaje.new()
local enemigo = Enemigo.new()
local pared = Pared.new(200, 100, 300, 10)

-- Resto del código para manejar el movimiento y las colisiones