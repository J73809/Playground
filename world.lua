local World = {}

World.width = 140
World.height = 500
World.tileSize = 32

World.tiles = {}

local Tiles = require("tiles")
local Particles = require("particles")

local breakTimer = 0


function World:isSolid(x, y)

    local tileX = math.floor(x / self.tileSize) + 1
    local tileY = math.floor(y / self.tileSize) + 1

    local tile = self.tiles[tileY] and self.tiles[tileY][tileX]

    if tile then
        return Tiles[tile].solid
    end

    return false
end

function World:generate()
    for y = 1, self.height do
        self.tiles[y] = {}

        for x = 1, self.width do
            local surface = 15 + math.floor(
                love.math.noise(x * 0.1) * 10
            )

            local underground_surface = 28 + math.floor(
                love.math.noise(x * 0.1) * 8
            )

            local cave = love.math.noise(x * 0.15, y * 0.15)
            local detailNoise = love.math.noise(x * 0.3, y * 0.3)

            if y >= surface then
                if y > surface + 3 and cave > 0.7 and detailNoise > 0.45 then
                    self.tiles[y][x] = 0
                elseif y >= underground_surface then
                    self.tiles[y][x] = 3
                else
                    self.tiles[y][x] = 2
                end
            else
                self.tiles[y][x] = 0
            end
        end
    end

    for y = 2, self.height - 1 do
        for x = 1, self.width do

            if self.tiles[y][x] ~= 0
            and self.tiles[y-1][x] == 0
            and self.tiles[y+1][x] == 2 then
                self.tiles[y][x] = 1
            end
        end
    end
end


function World:draw()

    for y, row in ipairs(self.tiles) do
        for x, tileID in ipairs(row) do
            local tile = Tiles[tileID]

            if tile and tile.visible then
                love.graphics.draw(
                    tile.sprite,
                    (x - 1) * self.tileSize,
                    (y - 1) * self.tileSize
                )
            end
        end
    end

    Particles:draw()

end

function World:delete(x, y, dt)
    local tileId = self.tiles[y][x]
    local breakTime = Tiles[tileId].hardness

    local breaking = true

    if breaking then
        if self.tiles[y][x] ~= 0 then
            breakTimer = breakTimer + dt

            Particles:spawn((x - 1) * self.tileSize + self.tileSize / 2,
                            (y - 1) * self.tileSize + self.tileSize / 2
            )

            if breakTimer > breakTime then
                self.tiles[y][x] = 0

                breaking = false
                breakTimer = 0
            end
        end
    end
end

function World:place(x, y)
    if self.tiles[y][x] == 0 then
        self.tiles[y][x] = 00000001111111
    end
end

return World
