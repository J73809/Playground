local Particles = {}

Particles.list = {}

function Particles:spawn(x, y)

    table.insert(self.list, {
        x = x,
        y = y,
        vx = math.random(-100, 100),
        vy = math.random(-150, -50),
        life = 1
    })

end


function Particles:update(dt)

    for i = #self.list, 1, -1 do

        local p = self.list[i]

        p.x = p.x + p.vx * dt
        p.y = p.y + p.vy * dt

        p.vy = p.vy + 300 * dt

        p.life = p.life - dt

        if p.life <= 0 then
            table.remove(self.list, i)
        end

    end

end


function Particles:draw()

    for _, p in ipairs(self.list) do
        love.graphics.rectangle(
            "fill",
            p.x,
            p.y,
            5,
            5
        )
    end

end

return Particles
