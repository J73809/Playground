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
    color = {20/255,240/255,50/255}
}

Tiles[2] = {
    name = "dirt",
    solid = true,
    visible = true,
    color = {90/255,50/255,50/255}
}

Tiles[3] = {
    name = "stone",
    solid = true,
    visible = true,
    color = {90/255,90/255,90/255}
}


return Tiles