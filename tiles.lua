local Tiles = {}

Tiles[0] = {
    name = "air",
    solid = false,
    visible = false,
}

Tiles[1] = {
    name = "grass",
    solid = true,
    visible = true,
    sprite = love.graphics.newImage("assets/images/tiles/grass.png"),
    hardness = 0.6
}

Tiles[2] = {
    name = "dirt",
    solid = true,
    visible = true,
    sprite = love.graphics.newImage("assets/images/tiles/dirt.png"),
    hardness = 0.6
}

Tiles[3] = {
    name = "stone",
    solid = true,
    visible = true,
    sprite = love.graphics.newImage("assets/images/tiles/stone.png"),
    hardness = 1.2
}

Tiles[00000001111111] = {
    name = "???",
    solid = true,
    visible = true,
    sprite = love.graphics.newImage("assets/images/tiles/textureless.png"),
    hardness = 0
}


return Tiles
