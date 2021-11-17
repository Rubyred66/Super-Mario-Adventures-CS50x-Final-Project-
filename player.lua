PlayerX = 180
PlayerY = 1065

mario = world:newRectangleCollider(PlayerX, PlayerY, 50, 100, {collision_class = 'Player'})

mario.animation = animations.marioStand
mario:setFixedRotation(true)
mario.speed = 240
mario.direction = 1
mario.grounded = false
mario.isMoving = false
mario.isDown = false
mario.playable = true

function playerUpdate(dt)
    local colliders = world:queryRectangleArea(mario:getX() - 20, mario:getY() + 50, 50, 2, { 'Platform', '???', 'Pipe'} )
    if #colliders > 0 then
        mario.grounded = true
    else
        mario.grounded = false
    end

    mario.isMoving = false
    mario.isDown = false
    local x, y = mario:getPosition()

    if mario.playable and gameState == 2 then
        if love.keyboard.isDown("left") then
            mario:setX(x - mario.speed *dt)
            mario.isMoving = true
            mario.direction = -1
        end

        if love.keyboard.isDown("right") then
            mario:setX(x + mario.speed *dt)
            mario.isMoving = true
            mario.direction = 1
        end

        if love.keyboard.isDown("down") then
            mario.isDown = true
            local collidersGround = world:queryRectangleArea(mario:getX() - 20, mario:getY() - 15, 50, 2, { 'Platform', '???'} )
        end
    end
    mario.animation:update(dt)
end

function playerDraw()
    if mario.body and gameState == 2 then
        local px, py = mario:getPosition()
        mario.animation:draw(sprites.playerSheet, px, py, nil, 2.7 * mario.direction, 2.7, 15, 22)

        if mario.grounded and mario.playable then
            if mario.isDown == false then
                if mario.isMoving then
                    mario.animation = animations.marioRun
                else
                    mario.animation = animations.marioStand
                end
            else
                if mario.isMoving then
                    mario.animation = animations.marioDown2
                else
                    mario.animation = animations.marioDown
                    mario.animation:pauseAtEnd()
                end
            end
        elseif mario.grounded == false and mario.playable and gameState == 2 then
            mario.animation = animations.marioJump
            mario.animation:pauseAtEnd()
        end
    end
end

function love.keypressed(key)
    if mario.body and mario.playable and gameState == 2 then
        if key == "up" and mario.grounded == true or key == "space" and mario.grounded == true then
            mario:applyLinearImpulse(0, -5500)
        end
    end
end

function marioDamage()
    mario.playable = false
    mario.animation = animations.marioHurt
    mario:applyLinearImpulse(200 * mario.direction * -1, -1)
    timer.after(0.4, function() mario.playable = true end) 
    timer.after(0.6, function() mario.animation = animations.marioStand end) 
end

function marioPipe(number)
    mario.playable = false
    mario.animation = animations.marioStand
    local x, y = mario:getPosition()

    timer.after(1, function() 
        if number == 1 then
            mario:setX(4607)
            mario:setY(1155)
        elseif number == 2 then
            mario:setX(6210)
            mario:setY(518)
        end

        mario.playable = true
        mario:applyLinearImpulse(0, -5500)
    end)

    timer.after(2, function() mario.playable = true end) 
end

function marioFinish()
    mario.playable = false
    mario.animation = animations.marioStand
end