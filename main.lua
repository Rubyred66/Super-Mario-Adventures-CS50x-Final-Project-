--SUPER MARIO ADVENTURES (CS50X FINAL PROJECT)

function love.load()
    love.window.setMode(800, 600, {resizable=false, vsync=false, minwidth=400, minheight=300})

    anim8 = require 'libraries/anim8/anim8'
    sti = require 'libraries/Simple-Tiled-Implementation/sti'
    cameraFile = require 'libraries/hump/camera'
    timer = require 'libraries/hump/timer'

    fonts = {}
    fonts.coinFont = love.graphics.newFont("fonts/YellowrabbitPersonaluse-qZYyd.otf", 60)
    fonts.coin2Font = love.graphics.newFont("fonts/CraftyNotesRegular-9YW77.ttf", 60)
    fonts.main = love.graphics.newFont("fonts/rubydance.ttf", 60)
    fonts.mario = love.graphics.newFont("fonts/SuperMario286.ttf", 30)

    cam = cameraFile()

    sounds = {}
    sounds.music = love.audio.newSource("audio/world1.wav", "stream")
    sounds.music:setLooping(true)

    sprites = {}
    sprites.logo = love.graphics.newImage('sprites/supermarioadventureslogo.png')

    sprites.playerSheet = love.graphics.newImage('sprites/MarioSpriteSheet.png')
    sprites.blocksSheet = love.graphics.newImage('sprites/T8.png')
    sprites.blocksSheet2 = love.graphics.newImage('sprites/T9.png')
    sprites.coins = love.graphics.newImage('sprites/T10.png')
    sprites.world1 = love.graphics.newImage('sprites/world1.png')
    sprites.toadSheet = love.graphics.newImage('sprites/toadSpritesSheet.png')
    sprites.goombaSheet = love.graphics.newImage('sprites/goombaSpriteSheet.png')

    local grid = anim8.newGrid(32, 40, sprites.playerSheet:getWidth(), sprites.playerSheet:getHeight(), 0, 0.5, 0.1)
    local blockgrid = anim8.newGrid(64, 64, sprites.blocksSheet:getWidth(), sprites.blocksSheet:getHeight(), 0, -4, 4)
    local toadgrid = anim8.newGrid(32, 46, sprites.toadSheet:getWidth(), sprites.toadSheet:getHeight())
    local goombagrid = anim8.newGrid(24, 24, sprites.goombaSheet:getWidth(), sprites.goombaSheet:getHeight(), 0, 0, 1)
    local coingrid = anim8.newGrid(64, 60, sprites.coins:getWidth(), sprites.coins:getHeight(), 0, -4, 4)

    animations = {}
    animations.marioStand = anim8.newAnimation(grid('3-7', 1), {0.3, 0.8, 0.2, 0.2, 0.3})
    animations.marioRun = anim8.newAnimation(grid('1-8', 3), 0.1)
    animations.marioJump = anim8.newAnimation(grid('1-2', 6), 0.5)
    animations.marioFall = anim8.newAnimation(grid('1-3', 7), 0.3)
    animations.marioDown = anim8.newAnimation(grid('1-2', 9), {1, 2})
    animations.marioDown2 = anim8.newAnimation(grid('3-4', 9), 0.3)
    animations.marioHurt = anim8.newAnimation(grid('1-4', 5), 0.1)

    animations.block1 = anim8.newAnimation(blockgrid('1-4', 1), 1)
    animations.block2 = anim8.newAnimation(blockgrid('3-5', 1), 1)

    animations.coins = anim8.newAnimation(coingrid('1-4', 1), 1)

    animations.toad1 = anim8.newAnimation(toadgrid('1-8', 1), 0.6)
    animations.toad2 = anim8.newAnimation(toadgrid('1-5', 2), 0.1)
    animations.toad3 = anim8.newAnimation(toadgrid('1-4', 3), 0.6)

    animations.enemy1 = anim8.newAnimation(goombagrid('1-8', 1), 0.3)
    animations.enemy2 = anim8.newAnimation(goombagrid('9-10', 1), 0.15)
    --animations.toad4 = anim8.newAnimation(toadgrid('1-8', 4), 0.6)

    wf = require 'libraries/windfield/windfield'
    world = wf.newWorld(0, 800, false)
    world:setQueryDebugDrawing(true)

    world:addCollisionClass('Platform')
    world:addCollisionClass('Player')
    world:addCollisionClass('Enemy')
    world:addCollisionClass('Helper', {ignores = {'Player'}})
    world:addCollisionClass('Danger')
    world:addCollisionClass('???')
    world:addCollisionClass('Coin', {ignores = {'Player'}})
    world:addCollisionClass('BlockCoin', {ignores = {'Player'}})
    world:addCollisionClass('Pipe')

    danger = {}

    require 'player'
    require 'enemy'
    require 'pipe'
    
    Coins = 0

    platforms = {}
    blocks1 = {}
    toads = {}
    coins = {}
    coinsInBlocks = {}

    finish = {}
    gameState = 1
    loadMap()
end    

function love.update(dt)
    if gameState == 2 then
        world:update(dt)
        gameMap:update(dt)
        timer.update(dt)

        local px, py = mario:getPosition()
        cam:lookAt(px, py)

        if mario.body then
            playerUpdate(dt)
            enemyUpdate(dt)
            pipeUpdate(dt)

            for i,b in ipairs(blocks1) do
                b.animation:update(dt)

                local bx, by = b:getPosition()
                local collidersJump = world:queryRectangleArea(bx - 27, by + 34, 60, 2, {'Player'})

                if #collidersJump > 0 and  b.animation ~= animations.block2 then
                    b.animation = animations.block2
                    b.animation:pauseAtEnd()
                    Coins = Coins + 1

                    b:setType('dynamic')
                    b:applyLinearImpulse(0, 100)
                    timer.after(0.3, function() b:setType('static') end) 
                end
            end

            for i,t in ipairs(toads) do
                local x, y = t:getPosition()

                t.animation:update(dt)
                local colliders = world:queryCircleArea(x - 50, y - 50, 100, {'Player'})
                if #colliders ~= 0 then
                    t.animation = animations.toad2
                else
                    t.animation = animations.toad1
                    t.animation:pauseAtStart()
                end
            end

            for i,c in ipairs(coins) do
                if c.body then
                    c.animation:update(dt)
                    local cx, cy = c:getPosition()
                    local collidersCoin = world:queryRectangleArea(cx - 10, cy - 20, 40, 40, {'Player'})
                    if #collidersCoin > 0 then
                        timer.after(0.1, function() c.show = false end) 
                        Coins = Coins + 1
                        c:destroy()
                    end 
                end
            end

            for i,c in ipairs(coinsInBlocks) do
                c.animation:update(dt)
                local cx, cy = c:getPosition()
                local collidersCoin = world:queryRectangleArea(cx - 20, cy + 15, 40, 2, {'???'})
                if #collidersCoin > 0 then
                    c.show = true
                    timer.after(0.2, function() c.show = false end) 
                end 
            end

            if mario:enter('Danger') then
                mario:setX(PlayerX)
                mario:setY(PlayerY)
            end
        end
    end
end

function love.draw()
    love.graphics.setColor(1, 1, 1)
    if gameState == 1 then
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(sprites.world1, -100, -120, nil, 1.98)
        love.graphics.draw(sprites.logo, 27, 60, nil, 0.3)

        love.graphics.setFont(fonts.main)
        love.graphics.setColor(0,0.05,0.10)
        love.graphics.printf("Click Anywhere to Begin!", 10, 420, love.graphics.getWidth(), "center")
    end
    
    if gameState == 2 then
        sounds.music:play()
        love.graphics.draw(sprites.world1, -100, -120, nil, 1.98)
        cam:attach()
            gameMap:drawLayer(gameMap.layers["Desen Katmanı 1"])
            gameMap:drawLayer(gameMap.layers["Background2"])
            --world:draw()
            if mario.body then
                playerDraw()
                enemyDraw()
                
                love.graphics.setColor(1, 1, 1)

                for i,b in ipairs(blocks1) do
                    local x, y = b:getPosition()
                    b.animation:draw(sprites.blocksSheet, x, y, nil, 1, 1, 32, 32)
                end

                for i,t in ipairs(toads) do
                    local x, y = t:getPosition()
                    t.animation:draw(sprites.toadSheet, x, y + 15, nil, 2.5 * t.direction, 2.5, 16, 24)
                end

                for i,c in ipairs(coins) do
                    if c.show and c.body then
                        local x, y = c:getPosition()
                        c.animation:draw(sprites.coins, x, y, nil, 1, 1, 16, 24)
                    end
                end

                for i,c in ipairs(coinsInBlocks) do
                    if c.show and c.body then
                        local x, y = c:getPosition()
                        c.animation:draw(sprites.coins, x, y, nil, 1, 1, 16, 24)
                    end
                end
            end
            gameMap:drawLayer(gameMap.layers["Background"])
        cam:detach()

        love.graphics.setColor(0.01,0.02,0.19)
        love.graphics.setFont(fonts.mario)
        love.graphics.printf("Coins: " .. math.ceil(Coins),30, 30, 300, "left")
    end
end    

function spawnPlatform(x, y, width, height)
    if width > 0 and height > 0 then
        local platform = world:newRectangleCollider(x, y, width ,height, {collision_class = 'Platform'})
        platform:setType('static')
        table.insert(platforms, platform)
    end
end

function spawnBlock1(x, y)
    local block1 = world:newRectangleCollider(x, y, 64 ,64, {collision_class = '???'})
    block1:setType('static')
    block1:setFixedRotation(true)
    block1.animation = animations.block1
    table.insert(blocks1, block1)
end

function spawnDanger(x, y)
    local danger = world:newRectangleCollider(x - 1500, y, 3000, 2, {collision_class = 'Danger'})
    danger:setType('static')
    table.insert(danger, danger)
end

function spawnToads(x, y)
    local toad = world:newRectangleCollider(x, y, 32 ,46, {collision_class = 'Helper'})
    toad:setType('static')
    toad.animation = animations.toad2
    toad.direction = 1
    table.insert(toads, toad)
end

function spawnCoins(x, y)
    local coin = world:newRectangleCollider(x, y, 8 ,30, {collision_class = 'Coin'})
    coin:setType('static')
    coin.animation = animations.coins
    coin.show = true
    table.insert(coins, coin)
end

function spawnCoinsInBlocks(x, y)
    local coinInBlock = world:newRectangleCollider(x, y, 10 ,30, {collision_class = 'BlockCoin'})
    coinInBlock:setType('static')
    coinInBlock.animation = animations.coins
    coinInBlock.show = false
    table.insert(coinsInBlocks, coinInBlock)
end

function loadMap()
    gameMap = sti("maps/2.lua")
    for i, obj in pairs(gameMap.layers["Platform"].objects) do 
        spawnPlatform(obj.x, obj.y, obj.width, obj.height)
    end

    for i, obj in pairs(gameMap.layers["Danger"].objects) do 
        spawnDanger(obj.x, obj.y)
    end

    for i, obj in pairs(gameMap.layers["???"].objects) do 
        spawnBlock1(obj.x, obj.y)
    end

    for i, obj in pairs(gameMap.layers["Toad"].objects) do 
        spawnToads(obj.x, obj.y)
    end

    for i, obj in pairs(gameMap.layers["Coins"].objects) do 
        spawnCoins(obj.x, obj.y)
    end

    for i, obj in pairs(gameMap.layers["CoinsInBlocks"].objects) do 
        spawnCoinsInBlocks(obj.x, obj.y)
    end

    for i, obj in pairs(gameMap.layers["Enemy1"].objects) do 
        spawnEnemies(obj.x, obj.y)
    end

    for i, obj in pairs(gameMap.layers["Pipe"].objects) do 
        spawnPipe(obj.x, obj.y)
    end

    for i, obj in pairs(gameMap.layers["FinishPipe"].objects) do 
        pipeX = obj.x 
        pipeY = obj.y 
        spawnFinish(obj.x, obj.y)
    end
end

function love.mousepressed(x, y, button)
    if button == 1 and gameState == 1 then
        gameState = 2
    end
end