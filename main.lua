-- ### Player ###
local Player = require("player")
local player

-- ### World ###
local World = require("world")

-- ### Camera ###
local Camera = require("libraries/camera")
local cam = Camera()

-- ### Backgrounds ###
local sky
local mountain_back
local mountain_middle
local mountain_front

-- ### Shaders ###
local shaders = require("shaders")

-- ### Particles ###
local Particles = require("particles")

-- ### Window ###
local scr_width, scr_height = 50 * World.tileSize, 30 * World.tileSize
love.window.setMode(scr_width, scr_height)

-- ### Loads ###
function love.load()
    player = Player:new()

    love.graphics.setDefaultFilter("nearest", "nearest")

    sky = love.graphics.newImage("assets/images/backgrounds/sky.png")
    mountain_back = love.graphics.newImage("assets/images/backgrounds/mountains_background.png")
    mountain_middle = love.graphics.newImage("assets/images/backgrounds/mountains_middleground.png")
    mountain_front = love.graphics.newImage("assets/images/backgrounds/mountains_foreground.png")

    shaders.light:send(
        "playerPosition",
        {
            player.x,
            player.y + player.height
        }
    )

    World:generateChunks(3, 3)
end

-- ### Single Imputs ###
function love.keypressed(key)
    if key == "space" and player.onGround then
        player.velocityY = -480
    end

    if key == "g" and not player.spectate then
        player.spectate = true
        player.gravity = 0
        player.velocityX = player.velocityX * 5
        player.velocityY = 0

    elseif key == "g" and player.spectate then
        player.spectate = false
        player.gravity = 560
        player.velocityX = player.velocityX / 5
        player.velocityY = 100
    end
end

-- ### Updating ###
function love.update(dt)
    player:update(dt, World)

    if love.keyboard.isDown("a") then
        player.x = player.x - player.velocityX * dt
    elseif love.keyboard.isDown("d") then
        player.x = player.x + player.velocityX * dt
    elseif love.keyboard.isDown("w") and player.spectate then
        player.y = player.y - player.velocityX * dt
    elseif love.keyboard.isDown("s") and player.spectate then
        player.y = player.y + player.velocityX * dt
    end

    if love.mouse.isDown(1) then
        local mouseX, mouseY = cam:mousePosition()

        local y = math.floor(mouseY / World.tileSize) + 1
        local x = math.floor(mouseX / World.tileSize) + 1

        World:place(x, y)

    elseif love.mouse.isDown(2) then
        local mouseX, mouseY = cam:mousePosition()

        local y = math.floor(mouseY / World.tileSize) + 1
        local x = math.floor(mouseX / World.tileSize) + 1

        World:delete(x, y, dt)
    end

    cam:lookAt(
        player.x + player.width / 2,
        player.y + player.height / 2 - 120
    )

    World:updateChunks(player)
    Particles:update(dt)
end

-- ### Parallaxing ###
local function drawParallax(image, cameraX, cameraY, horizontalSpeed, verticalSpeed, y, scale)
    local width = image:getWidth() * scale

    local x = (-cameraX * horizontalSpeed) % width
    local drawY = y - cameraY * verticalSpeed

    love.graphics.draw(
        image,
        x - width,
        drawY,
        0,
        scale,
        scale
    )

    love.graphics.draw(
        image,
        x,
        drawY,
        0,
        scale,
        scale
    )
end

-- ### Rendering ###
function love.draw()
    love.graphics.setColor(1, 1, 1)
    local scale = 4

    -- ## Background Rendering ##

    love.graphics.draw(
        sky,
        scr_width / 2,
        scr_height / 2,
        0,
        scale,
        scale,
        sky:getWidth() / 2,
        sky:getHeight() / 2
    )

    local camX = cam.x
    local camy = cam.y

    drawParallax(
        mountain_back,
        camX,
        camy,
        0.20,
        0.19,
        0,
        4
    )

    drawParallax(
        mountain_middle,
        camX,
        camy,
        0.25,
        0.21,
        30,
        4
    )

    drawParallax(
        mountain_front,
        camX,
        camy,
        0.3,
        0.23,
        80,
        4
    )

    -- ## Foreground Rendering ##
    cam:attach()

    World:draw(player)

    love.graphics.setColor(200 / 255, 40 / 255, 40 / 255)
    love.graphics.rectangle(
        "fill",
        player.x,
        player.y,
        player.width,
        player.height
    )

    cam:detach()


    --love.graphics.setShader(shaders.light)

    love.graphics.setColor(0, 0, 0, 0.95)

    --love.graphics.rectangle(
    --    "fill",
    --    0,
    --    0,
    --    width,
    --    height
    --)

    love.graphics.setShader()

    -- print(
    --     "x:", player.x,
    --     "right:", player.x + player.width,
    --     "tile left:", math.floor(player.x / World.tileSize) + 1,
    --     "tile right:", math.floor((player.x + player.width) / World.tileSize) + 1
    -- )
end
