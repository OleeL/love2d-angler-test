-- Very small helper camera (follow-style)
local Camera = {}
Camera.__index = Camera

function Camera:new(screenW, screenH, worldW, worldH)
    local o = {
        x = 0,
        y = 0,
        screenW = screenW,
        screenH = screenH,
        worldW = worldW,
        worldH = worldH
    }
    return setmetatable(o, Camera)
end

local function clamp(v, lo, hi) return math.max(lo, math.min(hi, v)) end

function Camera:update(targetX, targetY)
    -- centre the camera on the target
    self.x = clamp(targetX - self.screenW / 2, 0, self.worldW - self.screenW)
    self.y = clamp(targetY - self.screenH / 2, 0, self.worldH - self.screenH)
end

-- Wrap love.graphics transforms
function Camera:attach()
    love.graphics.push()
    love.graphics.translate(-math.floor(self.x), -math.floor(self.y))
end

function Camera:detach()
    love.graphics.pop()
end

return Camera
