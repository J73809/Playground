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
    color1 = {89/255, 193/255, 53/255},
    color2 = {113/255, 65/255, 59/255},
    hardness = 0.6
}

Tiles[2] = {
    name = "dirt",
    solid = true,
    visible = true,
    sprite = love.graphics.newImage("assets/images/tiles/dirt.png"),
    color1 = {113/255, 65/255, 59/255},
    color2 = {50/255, 43/255, 40/255},
    hardness = 0.6
}

Tiles[3] = {
    name = "stone",
    solid = true,
    visible = true,
    sprite = love.graphics.newImage("assets/images/tiles/stone.png"),
    color1 = {74/255, 84/255, 98/255},
    color2 = {51/255, 57/255, 65/255},
    hardness = 1.2
}

Tiles[4] = {
    name = "background dirt",
    solid = false,
    visible = true,
    sprite = love.graphics.newImage("assets/images/tiles/background_dirt.png")
}

Tiles[5] = {
    name = "background dirt",
    solid = false,
    visible = true,
    sprite = love.graphics.newImage("assets/images/tiles/background_stone.png")
}

Tiles[00000001111111] = {
    name = "???",
    solid = true,
    visible = true,
    sprite = love.graphics.newImage("assets/images/tiles/textureless.png"),
    color1 = {1, 1, 1, 0},
    color2 = {1, 1, 1, 0},
    hardness = 0
}


return Tiles
