local Settings = {
    playerVelocityX = 2000,
    playerVelocityY = -1800,
    playerMaxSpeed = 320,
    gravity = 560,

    renderDistance = 3,
    hitboxRenderDistance = 12,

    mountainBackSpeedX = 0.20,
    mountainMiddleSpeedX = 0.25,
    mountainFrontSpeedX = 0.3,

    mountainBackSpeedY = 0.20,
    mountainMiddleSpeedY = 0.25,
    mountainFrontSpeedY = 0.3,
}

local slider = love.graphics.newImage("assets/images/ui/slider.png")
local knob = love.graphics.newImage("assets/images/ui/knob.png")

local draggingSlider = nil

function Settings:drawSlider(x, y, length, minVal, maxVal, value)
    local sliderWidth = slider:getWidth()
    local sliderHeight = slider:getHeight()

    love.graphics.draw(
        slider,
        x,
        y,
        0,
        length / sliderWidth,
        1
    )

    local percent = (value - minVal) / (maxVal - minVal)
    percent = math.max(0, math.min(1, percent))
    local knobX = x + percent * length

    love.graphics.draw(
        knob,
        knobX - knob:getWidth() / 2,
        y - knob:getHeight() / 2 + 2
    )
end

function Settings:updateSlider(
    x, y, length,
    minVal, maxVal,
    value,
    id
)
    local mouseX = love.mouse.getX()
    local mouseY = love.mouse.getY()

    local knobX = x + ((value - minVal) / (maxVal - minVal)) * length

    -- Start dragging if we click the knob
    if love.mouse.isDown(1) and draggingSlider == nil then
        if math.abs(mouseX - knobX) <= 10
            and math.abs(mouseY - y) <= 12 then

            draggingSlider = id
        end
    end

    -- Continue dragging
    if draggingSlider == id then
        if love.mouse.isDown(1) then
            local percent = (mouseX - x) / length
            percent = math.max(0, math.min(1, percent))

            value = minVal + percent * (maxVal - minVal)

            return value
        else
            draggingSlider = nil
        end
    end

    return value
end

return Settings
