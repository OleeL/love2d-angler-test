local Player = {}
Player.__index = Player

local function clamp(v, lo, hi) return math.max(lo, math.min(hi, v)) end

function Player:new(x, y)
    local o = {
        x = x or 100,
        y = y or 300,
        w = 32,
        h = 48,
        vx = 0,
        vy = 0,
        speed     = 200,
        jumpForce = -400,
        gravity   = 800,
        onGround  = false,
        score     = 0
    }
    return setmetatable(o, Player)
end

function Player:update(dt, platforms, worldW)
    -- ===== input =====
    if love.keyboard.isDown("left", "a") then
        self.vx = -self.speed
    elseif love.keyboard.isDown("right", "d") then
        self.vx = self.speed
    else
        self.vx = 0
    end

    if love.keyboard.isDown("space") and self.onGround then
        self.vy = self.jumpForce; self.onGround = false
    end

    -- ===== physics & landing =====
    self.vy = self.vy + self.gravity * dt
    local nx = self.x + self.vx * dt
    local ny = self.y + self.vy * dt

    self.onGround = false
    for _, p in ipairs(platforms) do
        local footNow, footNext = self.y + self.h / 2, ny + self.h / 2
        if self.vy > 0 and footNow <= p.y and footNext >= p.y then
            if nx > p.x and nx < p.x + p.w then
                ny = p.y - self.h / 2; self.vy = 0; self.onGround = true; break
            end
        end
    end

    self.x = clamp(nx, self.w / 2, worldW - self.w / 2)
    self.y = ny
end

function Player:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill",
        self.x - self.w / 2, self.y - self.h / 2, self.w, self.h)
end

return Player
