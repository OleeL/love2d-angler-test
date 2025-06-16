local PlatformManager = {}
PlatformManager.__index = PlatformManager

function PlatformManager:new(worldW, worldH)
    local o = { list = {} }
    setmetatable(o, PlatformManager)

    -- World-space platforms
    o.list = {
        {
            x = 0,
            y = worldH - 32,
            w = worldW,
            h = 32
        },
        {
            x = math.random(0, worldW - 300),
            y = worldH - math.random(32, 128),
            w = 300,
            h = 32
        },
    }

    print(worldW, o.list[2].x)



    for _ = 1, 20 do
        local prev = o.list[#o.list]
        local blockWidth = 300
        local blockHeight = 32
        local range = 128
        table.insert(o.list,
            {
                x = math.random(
                    math.max(0, prev.x - range),
                    math.min(prev.x + prev.w + range, worldW - blockWidth)
                ),
                y = prev.y - math.random(64, 96),
                w = blockWidth,
                h = blockHeight
            })
    end
    return o
end

function PlatformManager:draw()
    love.graphics.setColor(0.3, 0.8, 0.3)
    for _, p in ipairs(self.list) do
        love.graphics.rectangle("fill", p.x, p.y, p.w, p.h)
    end
end

return PlatformManager
