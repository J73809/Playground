local shaders = {}

shaders.light = love.graphics.newShader[[
    extern vec2 playerPosition;
    extern number nightAmount;
    extern number lightRadius;
    extern number lightFalloff;

    vec4 effect(vec4 color, Image texture, vec2 texture_cords, vec2 screen_cords) {

        float distance = length(screen_cords - playerPosition);

        float alpha = pow(distance / lightRadius, lightFalloff);
        alpha = clamp(alpha, 0.0, 0.95);

        return vec4(0.0, 0.0, 0.0, alpha * nightAmount);
    }
]]

return shaders
