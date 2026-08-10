-- ### Player ###
local Player = require("player")
local player

-- ### World ###
local World = require("world")

-- ### Physics Engine ###
local wf = require("libraries/windfield")

local physicsWorld = wf.newWorld()
local playerHitbox

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

-- ### Debugging ###
local debug = false

local function drawDebug()
    local x = 10
    local y = 10
    local spacing = 18
    local debugFont = love.graphics.newFont("assets/fonts/JetBrainsMono-Regular.ttf", 18)
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(debugFont)

    love.graphics.print("FPS: " .. love.timer.getFPS(), x, y)
    love.graphics.print(
        string.format("X: %.1f  |  Y: %.1f", player.x, player.y),
        x, y + spacing
    )
    love.graphics.print(
        string.format(
            "Velocity: %.1f, %.1f",
            playerHitbox:getLinearVelocity()
        ),
        x, y + spacing * 2
    )

    love.graphics.print(
        "State: " .. (player.spectate and "Spectating" or
            (player.onGround and "Grounded" or "Airborne")),
        x, y + spacing * 3
    )
end

-- ### Window ###
local scr_width, scr_height = 50 * World.tileSize, 30 * World.tileSize
love.window.setMode(scr_width, scr_height)

-- ### Loads ###
function love.load()
    player = Player:new()
    playerHitbox = physicsWorld:newBSGRectangleCollider(
        player.x,
        player.y,
        player.width,
        player.height,
        5
    )
    playerHitbox:setFixedRotation(true)
    playerHitbox:setFriction(0)
    physicsWorld:setGravity(0, player.gravity)

    physicsWorld:addCollisionClass("Player")
    physicsWorld:addCollisionClass("Ground")

    playerHitbox:setCollisionClass("Player")

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
        playerHitbox:applyLinearImpulse(0, player.velocityY)
    end

    if key == "f3" and not debug then
        debug = true
    elseif key == "f3" and debug then
        debug = false
    end

    if key == "g" and not player.spectate then
        player.spectate = true
        physicsWorld:setGravity(0, 0)

    elseif key == "g" and player.spectate then
        player.spectate = false
        physicsWorld:setGravity(0, player.gravity)
    end
end

-- ### Updating ###
function love.update(dt)
    player.onGround = false

    local pvx, pvy = playerHitbox:getLinearVelocity()
    local maxSpeed = 320

    if love.keyboard.isDown("a") then
        playerHitbox:applyForce(-player.velocityX, 0)
    elseif love.keyboard.isDown("d") then
        playerHitbox:applyForce(player.velocityX, 0)
    elseif love.keyboard.isDown("w") and player.spectate then
        playerHitbox:applyForce(0, player.velocityY)
    elseif love.keyboard.isDown("s") and player.spectate then
        playerHitbox:applyForce(0, -player.velocityY)
    end

    if pvx > maxSpeed then
        pvx = maxSpeed
    elseif pvx < -maxSpeed then
        pvx = -maxSpeed
    end

    if not love.keyboard.isDown("a") and not love.keyboard.isDown("d") then pvx = pvx * 0.85 end

    playerHitbox:setLinearVelocity(pvx, pvy)

    playerHitbox:setPreSolve(function(collider1, collider2, contact)
        local nx, ny = contact:getNormal()

        if collider2.collision_class == "Ground" then
            if ny > 0.5 then
                player.onGround = true
            end
        end
    end)

    physicsWorld:update(dt)
    World:checkColliders(player, physicsWorld)

    player.x = playerHitbox:getX() - player.width / 2
    player.y = playerHitbox:getY() - player.height / 2

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

    if debug then physicsWorld:draw() end

    cam:detach()

    if debug then drawDebug() end

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
