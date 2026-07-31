-- ### Player ###
local Player = require("player")
local player

-- ### World ###
local World = require("world")

-- ### Camera ###
local Camera = require("libraries/camera")
local cam = Camera()

-- ### Background ###
local background

-- ### Shaders ###
local shaders = require("shaders")

-- ### Window ###
local width, height = 50 * World.tileSize, 30 * World.tileSize
love.window.setMode(width, height)

-- ### Loads ###
function love.load()
    player = Player:new()

    background = love.graphics.newImage("assets/images/backgrounds/background.png")

    shaders.light:send(
        "playerPosition",
        {
            player.x,
            player.y + player.height
        }
    )

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

    if love.mouse.isDown("2") then
        local mouseX, mouseY = cam:mousePosition()

        local y = math.floor(mouseY / World.tileSize) + 1
        local x = math.floor(mouseX / World.tileSize) + 1

        World:delete(x, y)
    end

    cam:lookAt(
        player.x + player.width / 2,
        player.y + player.height / 2
    )

end

-- ### Rendering ###
function love.draw()

    love.graphics.setColor(1, 1, 1)

    cam:attach()

        love.graphics.draw(background, player.x - width/2, player.y - height/2)

        World:draw()

        love.graphics.setColor(200/255, 40/255, 40/255)
        love.graphics.rectangle(
            "fill",
            player.x,
            player.y,
            player.width,
            player.height
        )

    cam:detach()


    love.graphics.setShader(shaders.light)

    love.graphics.setColor(0, 0, 0, 0.95)

    love.graphics.rectangle(
        "fill",
        0,
        0,
        width,
        height
    )

    love.graphics.setShader()

end