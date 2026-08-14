local DayNight = {}

DayNight.time = 0.45
DayNight.length = 360 -- > time in seconds

function DayNight:update(dt)
    self.time = self.time + dt / self.length

    if self.time >= 1 then
        self.time = self.time - 1
    end
end

function DayNight:getDarkness()
    local angle = (self.time - 0.25) * math.pi * 2
    local sunlight = math.sin(angle)

    sunlight = math.max(0, sunlight)

    return 1 - sunlight
end

return DayNight
