local Player          = require("entities.Player")
local Monster         = require("entities.Monster")
local PlatformManager = require("systems.PlatformManager")
local OrbManager      = require("systems.OrbManager")
local Camera          = require("systems.Camera")

local Game            = {}
Game.__index          = Game

function Game:new(cfg)
    -- cfg = {virtW,virtH,worldW,worldH}
    local o = {
        VIRT_W      = cfg.virtW,
        VIRT_H      = cfg.virtH,
        WORLD_W     = cfg.worldW,
        WORLD_H     = cfg.worldH,

        platformMgr = nil,
        player      = nil,
        monster     = nil,
        orbMgr      = nil,
        camera      = nil,

        -- off-screen render target
        canvas      = love.graphics.newCanvas(cfg.virtW, cfg.virtH),
        scaleX      = cfg.scaleX,
        scaleY      = cfg.scaleY,

        gameOver    = false
    }
    setmetatable(o, Game)
    o:reset()
    return o
end

function Game:reset()
    self.platformMgr = PlatformManager:new(self.WORLD_W, self.WORLD_H)
    self.player      = Player:new(100, self.WORLD_H - 128)
    self.monster     = Monster:new(600, self.WORLD_H - 128)
    self.orbMgr      = OrbManager:new(self.platformMgr.list, 5)
    self.camera      = Camera:new(
        self.VIRT_W, self.VIRT_H,
        self.WORLD_W, self.WORLD_H,
        self.player.x, self.player.y, -- target to lock on at spawn
        0.3                           -- optional: tighter smoothing
    )

    self.gameOver    = false
end

function Game:update(dt)
    if self.gameOver then
        if love.keyboard.isDown("r") then self:reset() end
        return
    end

    self.player:update(dt, self.platformMgr.list, self.WORLD_W)
    self.monster:update(dt, self.player) -- monster handles own SFX
    self.orbMgr:update(dt, self.player)
    self.camera:update(dt, self.player.x, self.player.y)

    -- death check
    local dx, dy = self.player.x - self.monster.x,
        self.player.y - self.monster.y
    if dx * dx + dy * dy < (self.player.w / 2 + self.monster.w / 2) ^ 2 then
        self.gameOver = true
        self.monster:stopSounds()
    end
end

function Game:draw()
    love.graphics.setCanvas(self.canvas)
    love.graphics.clear(0.07, 0.07, 0.12)

    self.camera:attach()
    self.platformMgr:draw()
    self.orbMgr:draw()
    self.player:draw()
    self.monster:draw()
    self.camera:detach()

    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Score: " .. self.player.score, 10, 10)
    if self.gameOver then
        love.graphics.printf("You were eaten! Press R to restart",
            0, self.VIRT_H / 2 - 10, self.VIRT_W, "center")
    end

    love.graphics.setCanvas()

    -- upscale canvas to desktop resolution
    love.graphics.draw(self.canvas, 0, 0, 0, self.scaleX, self.scaleY)
end

return Game
