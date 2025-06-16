local Game             = require("systems.Game")

-- virtual-screen constants
local VIRT_W, VIRT_H   = 800, 600
local WORLD_W, WORLD_H = 1600, 3000000

local game

function love.load()
    -- desktop-fullscreen, keep native desktop resolution
    local realW, realH = love.graphics.getDimensions()

    game = Game:new {
        virtW = VIRT_W, virtH = VIRT_H,
        worldW = WORLD_W, worldH = WORLD_H,
        scaleX = realW / VIRT_W,
        scaleY = realH / VIRT_H
    }
end

function love.update(dt)
    game:update(dt)
end

function love.draw()
    game:draw()
end
