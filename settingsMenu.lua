local SettingsMenu = {}

local Settings = require("settings")
local font = love.graphics.newFont("assets/fonts/Silkscreen-Regular.ttf", 18)
love.graphics.setFont(font)

local sections = {
    {
        name = "PLAYER",
        sliders = {
            {
                name = "Move Speed",
                setting = "playerMaxSpeed",
                min = 100,
                max = 1000,
                decimals = 0
            },
            {
                name = "Jump Force",
                setting = "playerVelocityY",
                min = -5000,
                max = -800,
                decimals = 0
            },
            {
                name = "Gravity",
                setting = "gravity",
                min = 100,
                max = 1000,
                decimals = 0
            }
        }
    },

    {
        name = "WORLD",
        sliders = {
            {
                name = "Render Distance",
                setting = "renderDistance",
                min = 1,
                max = 8,
                decimals = 0
            },
            {
                name = "Hitbox Render Distance",
                setting = "hitboxRenderDistance",
                min = 4,
                max = 50,
                decimals = 0
            }
        }
    },

    {
        name = "PARALLAX",
        sliders = {
            {
                name = "Mountain Back Speed (X)",
                setting = "mountainBackSpeedX",
                min = 0.09,
                max = 0.3,
                decimals = 2
            },
            {
                name = "Mountain Middle Speed (X)",
                setting = "mountainMiddleSpeedX",
                min = 0.09,
                max = 0.3,
                decimals = 2
            },
            {
                name = "Mountain Front Speed (X)",
                setting = "mountainFrontSpeedX",
                min = 0.09,
                max = 0.3,
                decimals = 2
            },
            {
                name = "Mountain Back Speed (Y)",
                setting = "mountainBackSpeedY",
                min = 0.09,
                max = 0.3,
                decimals = 2
            },
            {
                name = "Mountain Middle Speed (Y)",
                setting = "mountainMiddleSpeedY",
                min = 0.09,
                max = 0.3,
                decimals = 2
            },
            {
                name = "Mountain Front Speed (Y)",
                setting = "mountainFrontSpeedY",
                min = 0.09,
                max = 0.3,
                decimals = 2
            }
        }
    }
}

local menu = love.graphics.newImage("assets/images/ui/settings_menu.png")

local menuX = 400
local menuY = 240
local menuScale = 4

function SettingsMenu:draw()

    love.graphics.setColor(15 / 255, 15 / 255, 20 / 255, 0.80)
    love.graphics.rectangle("fill", 0, 0, 1600, 960)

    love.graphics.setColor(1, 1, 1)

    love.graphics.draw(
        menu,
        menuX,
        menuY,
        0,
        menuScale,
        menuScale
    )

    local leftX = menuX + 48
    local rightX = menuX + 380
    local startY = menuY + 85

    local sectionSpacing = 28
    local sliderSpacing = 48

    local sliderOffset = 30
    local valueOffsetX = 170
    local valueOffsetY = 19

    -- LEFT COLUMN
    local y = startY

    love.graphics.print("PLAYER", leftX, y)
    y = y + sectionSpacing

    for _, slider in ipairs(sections[1].sliders) do
        local value = Settings[slider.setting]

        love.graphics.print(
            slider.name,
            leftX,
            y - 2
        )

        Settings:drawSlider(
            leftX,
            y + sliderOffset,
            150,
            slider.min,
            slider.max,
            value
        )

        local format = "%." .. slider.decimals .. "f"

        love.graphics.print(
            string.format(format, value),
            leftX + valueOffsetX,
            y + valueOffsetY
        )

        y = y + sliderSpacing
    end

    y = y + 8

    love.graphics.print("WORLD", leftX, y)
    y = y + sectionSpacing

    for _, slider in ipairs(sections[2].sliders) do
        local value = Settings[slider.setting]

        love.graphics.print(
            slider.name,
            leftX,
            y - 2
        )

        Settings:drawSlider(
            leftX,
            y + sliderOffset,
            150,
            slider.min,
            slider.max,
            value
        )

        local format = "%." .. slider.decimals .. "f"

        love.graphics.print(
            string.format(format, value),
            leftX + valueOffsetX,
            y + valueOffsetY
        )

        y = y + sliderSpacing
    end

    -- RIGHT COLUMN
    y = startY

    love.graphics.print("PARALLAX", rightX, y)
    y = y + sectionSpacing

    for _, slider in ipairs(sections[3].sliders) do
        local value = Settings[slider.setting]

        love.graphics.print(
            slider.name,
            rightX,
            y - 2
        )

        Settings:drawSlider(
            rightX,
            y + sliderOffset,
            150,
            slider.min,
            slider.max,
            value
        )

        local format = "%." .. slider.decimals .. "f"

        love.graphics.print(
            string.format(format, value),
            rightX + valueOffsetX,
            y + valueOffsetY
        )

        y = y + sliderSpacing
    end
end

function SettingsMenu:update()

    local leftX = menuX + 48
    local rightX = menuX + 380
    local startY = menuY + 85

    local sectionSpacing = 28
    local sliderSpacing = 48
    local sliderOffset = 27

    -- PLAYER
    local y = startY + sectionSpacing

    for i, slider in ipairs(sections[1].sliders) do

        Settings[slider.setting] = Settings:updateSlider(
            leftX,
            y + sliderOffset,
            150,
            slider.min,
            slider.max,
            Settings[slider.setting],
            i
        )

        y = y + sliderSpacing
    end

    -- WORLD
    y = y + 8 + sectionSpacing

    for i, slider in ipairs(sections[2].sliders) do

        Settings[slider.setting] = Settings:updateSlider(
            leftX,
            y + sliderOffset,
            150,
            slider.min,
            slider.max,
            Settings[slider.setting],
            i + 3
        )

        y = y + sliderSpacing
    end

    -- PARALLAX
    y = startY + sectionSpacing

    for i, slider in ipairs(sections[3].sliders) do

        Settings[slider.setting] = Settings:updateSlider(
            rightX,
            y + sliderOffset,
            150,
            slider.min,
            slider.max,
            Settings[slider.setting],
            i + 5
        )

        y = y + sliderSpacing
    end
end

return SettingsMenu
