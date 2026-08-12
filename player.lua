local Player = {}


Player.__index = Player

function Player:new(settigs)

    local self = setmetatable({}, Player)

    self.x = 820
    self.y = 412

    self.width = 32
    self.height = 64

    self.velocityX = settigs.playerVelocityX
    self.velocityY = settigs.playerVelocityY

    self.gravity = settigs.gravity
    self.onGround = false
    self.spectate = false

    return self
end

return Player
