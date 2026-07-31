local Tiles = {}

Tiles[0] = {
    name = "air",
    solid = false,
    visible = false
}

Tiles[1] = {
    name = "grass",
    solid = true,
    visible = true,
    sprite = love.graphics.newImage("assets/images/tiles/grass.png")
}

Tiles[2] = {
    name = "dirt",
    solid = true,
    visible = true,
    sprite = love.graphics.newImage("assets/images/tiles/dirt.png")
}

Tiles[3] = {
    name = "stone",
    solid = true,
    visible = true,
    sprite = love.graphics.newImage("assets/images/tiles/stone.png")
}


return Tiles