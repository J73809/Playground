-- ### Player ###
local Player = require("player")
local player

-- ### World ###
local World = require("world")

-- ### Camera ###
local Camera = require("libraries/camera")
local cam = Camera()

-- ### Window ###
local width, height = 50 * World.tileSize, 30 * World.tileSize
love.window.setMode(width, height)

-- ### Loads ###
function love.load()
    player = Player:new()

    World:generate()
end

-- ### Single Imputs ###
function love.keypressed(key)
    if key == "space" and player.onGround then
        player.velocityY = -480
    end
end

-- ### Updating ###
function love.update(dt)
    player:update(dt, World)

    if love.keyboard.isDown("a") then
        player.x = player.x - player.velocityX * dt

    elseif love.keyboard.isDown("d") then
        player.x = player.x + player.velocityX * dt

    end

    cam:lookAt(
        player.x + player.width / 2,
        player.y + player.height / 2
    )

end

-- ### Rendering ###
function love.draw()
    cam:attach()
        World:draw()
        love.graphics.setColor(200/255, 40/255, 40/255)
        love.graphics.rectangle("fill", player.x, player.y, player.width, player.height)
    cam:detach()

end