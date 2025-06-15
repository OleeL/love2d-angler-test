local OrbManager = {}
OrbManager.__index = OrbManager

function OrbManager:new(platforms, respawnTime)
    local o = {
        list        = {},
        platforms   = platforms,
        respawnTime = respawnTime or 5,
        timer       = 0
    }
    setmetatable(o, OrbManager)
    o:spawn()
    return o
end

function OrbManager:spawn()
    self.timer = 0
    self.list  = {}

    local idx  = love.math.random(2, #self.platforms) -- avoid ground
    local p    = self.platforms[idx]
    table.insert(self.list, {
        r = 16,
        x = love.math.random(p.x + 16, p.x + p.w - 16),
        y = p.y - 16
    })
end

function OrbManager:update(dt, player)
    self.timer = self.timer + dt

    -- collision check
    for i, orb in ipairs(self.list) do
        local dx, dy = player.x - orb.x, player.y - orb.y
        if dx * dx + dy * dy < (player.w / 2 + orb.r) ^ 2 then
            player.score = player.score + 1
            player.x, player.y = 100, 100
            self.list = {}
            break
        end
    end

    -- respawn logic
    if #self.list == 0 and self.timer >= self.respawnTime then
        self:spawn()
    end
end

function OrbManager:draw()
    love.graphics.setColor(0.7, 0.9, 1.0)
    for _, orb in ipairs(self.list) do
        love.graphics.circle("fill", orb.x, orb.y, orb.r)
    end
end

return OrbManager
