local shaders = {}

shaders.light = love.graphics.newShader[[
    extern vec2 playerPosition;

    vec4 effect(vec4 color, Image texture, vec2 texture_cords, vec2 screen_cords) {

    float distance = length(screen_cords - playerPosition);

    float alpha = pow(distance / 250.0, 2.0);
    alpha = clamp(alpha, 0.0, 0.95);

    return vec4(0.0, 0.0, 0.0, alpha);
}
]]

return shaders