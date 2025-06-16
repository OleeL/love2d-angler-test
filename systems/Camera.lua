-- Tight-follow camera (instant-correct on spawn, smooth afterwards) ----------
local Camera = {}
Camera.__index = Camera

local function clamp(v, lo, hi) return math.max(lo, math.min(hi, v)) end

-- screenW/H : window size (virtual)
-- worldW/H  : size of the scrollable world
-- targetX/Y : entity position to centre on at spawn
-- followLerp: smoothing factor (0-1) per frame; default 0.25
function Camera:new(screenW, screenH, worldW, worldH,
                    targetX, targetY, followLerp)
    local initX = clamp(targetX - screenW * 0.5, 0, worldW - screenW)
    local initY = clamp(targetY - screenH * 0.5, 0, worldH - screenH)

    local o = {
        x = initX,
        y = initY,
        screenW = screenW,
        screenH = screenH,
        worldW = worldW,
        worldH = worldH,
        followLerp = followLerp or 0.25
    }
    return setmetatable(o, Camera)
end

-- dt, targetX/Y : update toward target with smoothing
function Camera:update(dt, targetX, targetY)
    local desiredX = clamp(targetX - self.screenW * 0.5, 0,
        self.worldW - self.screenW)
    local desiredY = clamp(targetY - self.screenH * 0.5, 0,
        self.worldH - self.screenH)

    -- frame-rate-independent lerp
    local alpha = 1 - (1 - self.followLerp) ^ (dt * 60)
    self.x = self.x + (desiredX - self.x) * alpha
    self.y = self.y + (desiredY - self.y) * alpha
end

function Camera:attach()
    love.graphics.push()
    love.graphics.translate(-math.floor(self.x), -math.floor(self.y))
end

function Camera:detach()
    love.graphics.pop()
end

return Camera
