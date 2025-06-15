local PlatformManager = {}
PlatformManager.__index = PlatformManager

function PlatformManager:new(worldW, worldH)
    local o = { list = {} }
    setmetatable(o, PlatformManager)

    -- World-space platforms
    o.list = {
        { x = 0,    y = worldH - 32, w = worldW, h = 32 },
        { x = 250,  y = worldH - 160, w = 160,  h = 16 },
        { x = 600,  y = worldH - 260, w = 160,  h = 16 },
        { x = 950,  y = worldH - 360, w = 160,  h = 16 },
        { x = 1300, y = worldH - 220, w = 200,  h = 16 }
    }
    return o
end

function PlatformManager:draw()
    love.graphics.setColor(0.3, 0.8, 0.3)
    for _, p in ipairs(self.list) do
        love.graphics.rectangle("fill", p.x, p.y, p.w, p.h)
    end
end

return PlatformManager
