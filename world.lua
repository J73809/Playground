local World = {}

World.width = 140
World.height = 50
World.tileSize = 32

World.tiles = {}

local Tiles = require("tiles")

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

            if y >= surface and self.tiles[y-1][x] == 0 then
                self.tiles[y][x] = 1
            elseif y >= surface and self.tiles[y-1][x] ~= 0 then
                if y >= underground_surface then
                    self.tiles[y][x] = 3
                else 
                    self.tiles[y][x] = 2
                end
            else
                self.tiles[y][x] = 0
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
                    (x-1) * self.tileSize,
                    (y-1) * self.tileSize
                )

            end
        end
    end

end

function World:delete(x, y) 
    if self.tiles[y][x] ~= nil then -- problem with this 
        self.tiles[y][x] = 0
    end
end

return World