local Player = {}


Player.__index = Player

function Player:new()

    local self = setmetatable({}, Player)

    self.x = 800
    self.y = 400
    
    self.width = 32
    self.height = 64

    self.velocityX = 250
    self.velocityY = 100

    self.gravity = 560
    self.onGround = false

    return self

end

function Player:update(dt, world)

    self.velocityY = self.velocityY + self.gravity * dt

    self.y = self.y + self.velocityY * dt

    -- ## Ground Collision ##
    if world:isSolid(
        self.x + self.width / 2,
        self.y + self.height
    ) then

        self.y = math.floor(self.y / world.tileSize) * world.tileSize
        self.velocityY = 0
        self.onGround = true

    else self.onGround = false
    
    end

    -- ## Wall Collision ##
    if world:isSolid(
        self.x + self.width,
        self.y + self.height / 2
    ) then

        self.x = math.floor(self.x / world.tileSize) * world.tileSize

    end

    if world:isSolid(
        self.x,
        self.y + self.height / 2
    ) then

        self.x = math.ceil(self.x / world.tileSize) * world.tileSize
    
    end

end

return Player