local World = {}

World.tileSize = 32
World.chunkSize = 16
World.renderDistance = 3

World.chunks = {}

local Tiles = require("tiles")
local Particles = require("particles")

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

-- not necessary
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

function World:generateChunks(chunkX, chunkY)
    self:createChunk(chunkX, chunkY)

    local chunk = self.chunks[chunkY][chunkX]

    for y = 1, self.chunkSize do
        chunk.tiles[y] = {}

        for x = 1, self.chunkSize do
            local worldX = (chunkX - 1) * self.chunkSize + x
            local worldY = (chunkY - 1) * self.chunkSize + y

            local surface = 15 + math.floor(
                love.math.noise(worldX * 0.1) * 10
            )

            local underground_surface = 28 + math.floor(
                love.math.noise(worldX * 0.1) * 8
            )

            local cave = love.math.noise(worldX * 0.15, worldY * 0.15)
            local detailNoise = love.math.noise(worldX * 0.3, worldY * 0.3)

            if worldY >= surface then
                if worldY > surface + 3 and cave > 0.7 and detailNoise > 0.45 then
                    chunk.tiles[y][x] = 0
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

    for y = 2, self.chunkSize - 1 do
        for x = 1, self.chunkSize do

            if chunk.tiles[y][x] ~= 0
            and chunk.tiles[y-1][x] == 0
            and chunk.tiles[y+1][x] == 2 then
                chunk.tiles[y][x] = 1
            end

        end
    end
end

function World:draw(player)

    local tileX = math.floor(player.x / self.tileSize) + 1
    local tileY = math.floor(player.y / self.tileSize) + 1

    local chunkX, chunkY = self:getChunkPosition(tileX, tileY)

    for chunk_y = chunkY - self.renderDistance, chunkY + self.renderDistance do
        for chunk_x = chunkX - self.renderDistance, chunkX + self.renderDistance do

            local chunk = self.chunks[chunk_y] and self.chunks[chunk_y][chunk_x]

            if not chunk then
                self:generateChunks(chunk_x, chunk_y)
                chunk = self.chunks[chunk_y][chunk_x]
            end

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

    local breaking = true

    local color
    if math.random(1, 3) == 1 then
        color = Tiles[tileId].color1
    else
        color = Tiles[tileId].color2
    end

    if breaking then
        if tileId ~= 0 then
            breakTimer = breakTimer + dt

            Particles:spawn((x - 1) * self.tileSize + self.tileSize / 2,
                            (y - 1) * self.tileSize + self.tileSize / 2,
                            color
            )

            if breakTimer > breakTime then
                self:setTile(x, y, 0)

                breaking = false
                breakTimer = 0
            end
        end
    end
end

function World:place(x, y)
    if self:getTileId(x, y) == 0 then
        self:setTile(x, y, 00000001111111)
    end
end

return World
