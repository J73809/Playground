local Player = {}


Player.__index = Player

function Player:new()

    local self = setmetatable({}, Player)

    self.x = 820
    self.y = 412

    self.width = 32
    self.height = 64

    self.velocityX = 2000
    self.velocityY = -1800

    self.gravity = 560
    self.onGround = false
    self.spectate = false

    return self
end

return Player
