local Monster = {}
Monster.__index = Monster

function Monster:new(x, y)
    local o = {
        x = x or 400,
        y = y or 300,
        w = 64,
        h = 64,
        speed   = 100,
        chasing = false
    }
    return setmetatable(o, Monster)
end

function Monster:update(dt, player)
    local dx, dy = player.x - self.x, player.y - self.y
    local dist   = math.sqrt(dx * dx + dy * dy)

    if dist < 300 then
        self.chasing = true
        local nx, ny = dx / dist, dy / dist
        self.x = self.x + nx * self.speed * dt
        self.y = self.y + ny * self.speed * dt
    else
        self.chasing = false
        self.x = self.x + math.sin(love.timer.getTime()) * 20 * dt
    end
end

function Monster:draw()
    love.graphics.setColor(1, 0.2, 0.2)
    love.graphics.rectangle("fill",
        self.x - self.w / 2, self.y - self.h / 2, self.w, self.h)
end

return Monster
