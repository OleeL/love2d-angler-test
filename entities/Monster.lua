local Monster = {}
Monster.__index = Monster

function Monster:new(x, y)
    local self      = setmetatable({}, Monster)
    self.x, self.y  = x or 400, y or 300
    self.w, self.h  = 64, 64
    self.speed      = 100
    self.chasing    = false

    -- load sounds once per monster
    self.roamSound  = love.audio.newSource("assets/angler_roam.mp3", "stream")
    self.chaseSound = love.audio.newSource("assets/angler_chase.mp3", "stream")
    self.roamSound:setLooping(true)
    self.chaseSound:setLooping(true)
    self.roamSound:play()

    return self
end

function Monster:update(dt, player)
    local dx, dy = player.x - self.x, player.y - self.y
    local dist   = math.sqrt(dx * dx + dy * dy)

    if dist < 300 then -- chase
        self.chasing = true
        local nx, ny = dx / dist, dy / dist
        self.x = self.x + nx * self.speed * dt
        self.y = self.y + ny * self.speed * dt
    else -- wander
        self.chasing = false
        self.x = self.x + math.sin(love.timer.getTime()) * 20 * dt
    end

    -- sound swap handled here
    if self.chasing then
        if self.roamSound:isPlaying() then self.roamSound:stop() end
        if not self.chaseSound:isPlaying() then self.chaseSound:play() end
    else
        if self.chaseSound:isPlaying() then self.chaseSound:stop() end
        if not self.roamSound:isPlaying() then self.roamSound:play() end
    end
end

function Monster:stopSounds()
    self.roamSound:stop()
    self.chaseSound:stop()
end

function Monster:draw()
    love.graphics.setColor(1, 0.2, 0.2)
    love.graphics.rectangle("fill",
        self.x - self.w / 2, self.y - self.h / 2, self.w, self.h)
end

return Monster
