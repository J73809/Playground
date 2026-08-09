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
    self.spectate = false

    return self
end

function Player:update(dt, world)

    self.velocityY = self.velocityY + self.gravity * dt
    self.y = self.y + self.velocityY * dt

    local right = self.x + self.width
    local left = self.x
    local top = self.y + 1
    local bottom = self.y + self.height - 1

    if not self.spectate then
        -- ## Ground Collision ##
        if world:isSolid(
                self.x + self.width / 2,
                self.y + self.height
            ) then

            self.y = math.floor(self.y / world.tileSize) * world.tileSize
            self.velocityY = 0
            self.onGround = true
        else
            self.onGround = false
        end

        -- ## Ceiling Collision ##
        if world:isSolid(
            self.x + self.width / 2,
            self.y
        ) then
        self.y = math.floor(self.y / world.tileSize + 1) * world.tileSize
        self.velocityY = 0
        end

        -- ## Wall Collision ##
        if world:isSolid(right, bottom) then
            self.x = math.floor(self.x / world.tileSize) * world.tileSize
        end

        if world:isSolid(left, bottom) then
            local tileX = math.floor(left / world.tileSize)
            self.x = (tileX + 1) * world.tileSize
        end

        if world:isSolid(right, top) then
            local tileX = math.floor(right / world.tileSize)
            self.x = tileX * world.tileSize - self.width
        end

        if world:isSolid(left, top) then
            local tileX = math.floor(left / world.tileSize)
            self.x = (tileX + 1) * world.tileSize
        end

    end

end

return Player
