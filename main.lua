local Player           = require("entities.Player")
local Monster          = require("entities.Monster")
local PlatformManager  = require("systems.PlatformManager")
local OrbManager       = require("systems.OrbManager")
local Camera           = require("systems.Camera")

-- virtual screen
local VIRT_W, VIRT_H   = 800, 600
local WORLD_W, WORLD_H = 1600, 600

-- state
local platformMgr, player, monster, orbMgr, camera
local monsterRoamSound, monsterSound
local gameOver         = false

-- full-screen helpers
local renderCanvas   -- 800×600 canvas
local scaleX, scaleY -- stretch factors

-----------------------------------------------------------------
local function resetGame()
    platformMgr      = PlatformManager:new(WORLD_W, WORLD_H)
    player           = Player:new()
    monster          = Monster:new(600, 300)
    orbMgr           = OrbManager:new(platformMgr.list, 5)
    camera           = Camera:new(VIRT_W, VIRT_H, WORLD_W, WORLD_H)

    monsterRoamSound = love.audio.newSource("assets/angler_roam.mp3", "stream")
    monsterSound     = love.audio.newSource("assets/angler_chase.mp3", "stream")
    monsterRoamSound:setLooping(true); monsterSound:setLooping(true)
    love.audio.play(monsterRoamSound)

    gameOver = false
end
-----------------------------------------------------------------

function love.load()
    -- desktop-fullscreen, keep user’s desktop resolution
    love.window.setMode(0, 0, { fullscreen = true, fullscreentype = "desktop" })

    -- real monitor size
    local realW, realH = love.graphics.getDimensions()
    scaleX, scaleY     = realW / VIRT_W, realH / VIRT_H

    -- create canvas at virtual resolution
    renderCanvas       = love.graphics.newCanvas(VIRT_W, VIRT_H)

    resetGame()
end

function love.update(dt)
    if gameOver then
        if love.keyboard.isDown("r") then resetGame() end
        return
    end

    player:update(dt, platformMgr.list, WORLD_W)
    monster:update(dt, player)
    orbMgr:update(dt, player)
    camera:update(player.x, player.y)

    -- sound swap (unchanged)
    if monster.chasing then
        if monsterRoamSound:isPlaying() then monsterRoamSound:stop() end
        if not monsterSound:isPlaying() then monsterSound:play() end
    else
        if monsterSound:isPlaying() then monsterSound:stop() end
        if not monsterRoamSound:isPlaying() then monsterRoamSound:play() end
    end

    -- game-over?
    local dx, dy = player.x - monster.x, player.y - monster.y
    if dx * dx + dy * dy < (player.w / 2 + monster.w / 2) ^ 2 then
        gameOver = true
        love.audio.stop(monsterSound); love.audio.stop(monsterRoamSound)
    end
end

function love.draw()
    -----------------------------------------------------------------
    -- draw everything to the 800×600 canvas
    -----------------------------------------------------------------
    love.graphics.setCanvas(renderCanvas)
    love.graphics.clear(0.07, 0.07, 0.12)

    camera:attach()
    platformMgr:draw()
    orbMgr:draw()
    player:draw()
    monster:draw()
    camera:detach()

    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Score: " .. player.score, 10, 10)
    if gameOver then
        love.graphics.printf("You were eaten! Press R to restart",
            0, VIRT_H / 2 - 10, VIRT_W, "center")
    end

    love.graphics.setCanvas() -- back to real screen
    -----------------------------------------------------------------
    -- upscale canvas to monitor size (non-uniform stretch allowed)
    -----------------------------------------------------------------
    love.graphics.draw(renderCanvas, 0, 0, 0, scaleX, scaleY)
end
