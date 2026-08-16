local World = {}

local Tiles = require("tiles")
local Particles = require("particles")
local Settings = require("settings")

World.tileSize = 32
World.chunkSize = 16

World.chunks = {}
World.colliders = {}

World.changes = {}

local breakTimer = 0

function World:isSolid(x, y)

    local tileX = math.floor(x / self.tileSize) + 1
    local tileY = math.floor(y / self.tileSize) + 1

    local chunkX, chunkY, localX, localY = self:getChunkPosition(tileX, tileY)

    local chunk = self.chunks[chunkY] and self.chunks[chunkY][chunkX]

    if chunk then
        local tile = chunk.tiles[localY] and chunk.tiles[localY][localX]

        if tile then
            return Tiles[tile].solid
        end
    end

    return false
end

function World:getChunkPosition(x, y)
    local chunkX = math.floor((x - 1) / World.chunkSize) + 1
    local chunkY = math.floor((y - 1) / World.chunkSize) + 1

    local localX = ((x - 1) % World.chunkSize) + 1
    local localY = ((y - 1) % World.chunkSize) + 1

    return chunkX, chunkY, localX, localY
end

function World:createChunk(chunkX, chunkY)
    if not self.chunks[chunkY] then
        self.chunks[chunkY] = {}
    end

    self.chunks[chunkY][chunkX] = {
        tiles = {}
    }
end

-- not necessary for now
function World:convertToChunks()

    for y, row in ipairs(self.tiles) do
        for x, tileID in ipairs(row) do
            self:setTile(x, y, tileID)
        end
    end
end
-- -----

function World:setTile(x, y, id)
    local chunkX, chunkY, localX, localY = self:getChunkPosition(x, y)

    if not self.chunks[chunkY] then
        self.chunks[chunkY] = {}
    end

    if not self.chunks[chunkY][chunkX] then
        self:createChunk(chunkX, chunkY)
    end

    if not self.chunks[chunkY][chunkX].tiles[localY] then
        self.chunks[chunkY][chunkX].tiles[localY] = {}
    end

    self.chunks[chunkY][chunkX].tiles[localY][localX] = id
end

function World:getTileId(x, y)
    local chunkX, chunkY, localX, localY = self:getChunkPosition(x, y)

    local chunk = self.chunks[chunkY] and self.chunks[chunkY][chunkX]

    if chunk and chunk.tiles[localY] then
        return chunk.tiles[localY][localX]
    end

    return 0
end

function World:getTerrainHeights(x)
    local surface = 15 + math.floor(
        love.math.noise(x * 0.1) * 10
    )

    local underground_surface = 28 + math.floor(
        love.math.noise(x * 0.1) * 8
    )

    return surface, underground_surface
end

function World:generateChunks(chunkX, chunkY)
    self:createChunk(chunkX, chunkY)

    local chunk = self.chunks[chunkY][chunkX]

    for y = 1, self.chunkSize do
        chunk.tiles[y] = {}

        for x = 1, self.chunkSize do
            local worldX = (chunkX - 1) * self.chunkSize + x
            local worldY = (chunkY - 1) * self.chunkSize + y

            local surface, underground_surface = self:getTerrainHeights(worldX)

            local cave = love.math.noise(worldX * 0.065, worldY * 0.078)
            local detailNoise = love.math.noise(worldX * 0.1, worldY * 0.1)

            if worldY >= surface then
                if worldY > surface + 5 and cave > 0.6 and detailNoise > 0.08 then
                    if worldY > underground_surface then
                        chunk.tiles[y][x] = 5
                    else
                        chunk.tiles[y][x] = 4
                    end
                elseif worldY >= underground_surface then
                    chunk.tiles[y][x] = 3
                else
                    chunk.tiles[y][x] = 2
                end
            else
                chunk.tiles[y][x] = 0
            end
        end
    end

    for y = 2, self.chunkSize do
        for x = 1, self.chunkSize do
            local worldX = (chunkX - 1) * self.chunkSize + x
            local worldY = (chunkY - 1) * self.chunkSize + y

            local tile = self:getTileId(worldX, worldY)
            local above = self:getTileId(worldX, worldY - 1)
            local below = self:getTileId(worldX, worldY + 1)

            if tile ~= 0
                and above == 0
                and below == 2 then
                self:setTile(worldX, worldY, 1)
            end
        end
    end

    self:applyChanges(chunkX, chunkY)
end

function World:loadChunk(chunkX, chunkY)
    if not self.chunks[chunkY] then
        self.chunks[chunkY] = {}
    end

    if not self.chunks[chunkY][chunkX] then
        self:generateChunks(chunkX, chunkY)
    end
end

function World:setChange(x, y, id)
    if not self.changes[x] then
        self.changes[x] = {}
    end

    self.changes[x][y] = id
end

function World:getChange(x, y)
    if self.changes[x] then
        return self.changes[x][y]
    end

    return nil
end

function World:applyChanges(chunkX, chunkY)
    local startX = (chunkX - 1) * self.chunkSize + 1
    local startY = (chunkY - 1) * self.chunkSize + 1

    local endX = startX + self.chunkSize - 1
    local endY = startY + self.chunkSize - 1

    for x = startX, endX do
        if self.changes[x] then
            for y = startY, endY do
                local change = self.changes[x][y]

                if change ~= nil then
                    self:setTile(x, y, change)
                end
            end
        end
    end
end

function World:unloadChunk(chunkX, chunkY)
    if self.chunks[chunkY] then
        self.chunks[chunkY][chunkX] = nil

        if next(self.chunks[chunkY]) == nil then
            self.chunks[chunkY] = nil
        end
    end
end

function World:updateChunks(player)
    local tileX = math.floor(player.x / self.tileSize) + 1
    local tileY = math.floor(player.y / self.tileSize) + 1

    local centerChunkX, centerChunkY = self:getChunkPosition(tileX, tileY)
    local renderDistance = math.floor(Settings.renderDistance)

    local wanted = {}

    for chunkY = centerChunkY - renderDistance,
                centerChunkY + renderDistance do
        for chunkX = centerChunkX - renderDistance,
                    centerChunkX + renderDistance do
            self:loadChunk(chunkX, chunkY)

            if not wanted[chunkY] then
                wanted[chunkY] = {}
            end

            wanted[chunkY][chunkX] = true
        end
    end

    for chunkY, row in pairs(self.chunks) do
        for chunkX in pairs(row) do
            if not wanted[chunkY]
                or not wanted[chunkY][chunkX] then
                self:unloadChunk(chunkX, chunkY)
            end
        end
    end
end

function World:checkColliders(player, pWorld)
    for _, collider in ipairs(self.colliders) do
        collider:destroy()
    end

    self.colliders = {}

    local playerX = math.floor(player.x / self.tileSize) + 1
    local playerY = math.floor(player.y / self.tileSize) + 1

    local physicsDistance = math.floor(Settings.hitboxRenderDistance)

    if not player.spectate then
        for y = playerY - physicsDistance,
                playerY + physicsDistance do

            for x = playerX - physicsDistance,
                    playerX + physicsDistance do

                local tileId = self:getTileId(x, y)

                if tileId ~= 0 and Tiles[tileId].solid then
                    local collider = pWorld:newRectangleCollider(
                        (x - 1) * self.tileSize,
                        (y - 1) * self.tileSize,
                        self.tileSize,
                        self.tileSize
                    )

                    collider:setType("static")
                    collider:setCollisionClass("Ground")

                    table.insert(self.colliders, collider)
                end
            end
        end
    end
end

function World:draw(player)

    local tileX = math.floor(player.x / self.tileSize) + 1
    local tileY = math.floor(player.y / self.tileSize) + 1

    local chunkX, chunkY = self:getChunkPosition(tileX, tileY)
    local renderDistance = math.floor(Settings.renderDistance)

    for chunk_y = chunkY - renderDistance,
                   chunkY + renderDistance do
        for chunk_x = chunkX - renderDistance,
                       chunkX + renderDistance do

            local chunk = self.chunks[chunk_y] and self.chunks[chunk_y][chunk_x]

            if chunk then
                for local_y, row in ipairs(chunk.tiles) do
                    for local_x, tileID in ipairs(row) do

                        local tile = Tiles[tileID]

                        if tile and tile.visible then
                            love.graphics.draw(
                            tile.sprite,
                                ((chunk_x - 1) * self.chunkSize + (local_x - 1)) * self.tileSize,
                                ((chunk_y - 1) * self.chunkSize + (local_y - 1)) * self.tileSize
                            )
                        end
                    end
                end
            end

        end
    end

    Particles:draw()
end

function World:delete(x, y, dt)
    local tileId = self:getTileId(x, y)
    local breakTime = Tiles[tileId].hardness
    local breaking

    if Tiles[tileId].solid then
        breaking = true
    end

    local color
    if math.random(1, 3) == 1 then
        color = Tiles[tileId].color1
    else
        color = Tiles[tileId].color2
    end

    local surface, underground_surface = self:getTerrainHeights(x)

    if breaking then
        if tileId ~= 0 then
            breakTimer = breakTimer + dt

            Particles:spawn((x - 1) * self.tileSize + self.tileSize / 2,
                (y - 1) * self.tileSize + self.tileSize / 2,
                color
            )

            if breakTimer > breakTime then
                if y > surface then
                    if y > underground_surface then
                        self:setTile(x, y, 5)
                    else
                        self:setTile(x, y, 4)
                    end
                else
                    self:setTile(x, y, 0)
                end

                breaking = false
                breakTimer = 0
            end
        end
    end

    self:setChange(x, y, self:getTileId(x, y))
end

function World:place(x, y)
    if self:getTileId(x, y) ~= 1
        and self:getTileId(x, y) ~= 2
        and self:getTileId(x, y) ~= 3 then
        self:setTile(x, y, 00000001111111)
    end

    self:setChange(x, y, 00000001111111)
end

return World
