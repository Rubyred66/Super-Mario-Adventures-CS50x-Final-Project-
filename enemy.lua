enemies = {}

function spawnEnemies(x, y)
    local enemy = world:newRectangleCollider(x, y + 10, 32 ,50, {collision_class = 'Enemy'})
    enemy:setType('static')
    enemy.animation = animations.enemy1
    enemy.direction = 1
    enemy.speed = 200
    enemy.dead = false
    table.insert(enemies, enemy)
end

function enemyUpdate(dt)
    for i,e in ipairs(enemies) do
        e.animation:update(dt)
        if e.dead == false then
            local ex, ey = e:getPosition()

            local colliders = world:queryRectangleArea(ex + (40 * e.direction), ey - 10, 1, 40, {'Platform', 'Helper', 'Pipe'})
            local colliders2 = world:queryRectangleArea(ex + (40 * e.direction) , ey + 30, 40, 2, {'Platform'})
            if #colliders ~= 0 or #colliders2 == 0 then
                e.direction = e.direction * -1
            end

            e:setX(ex + e.speed * dt * e.direction) 

            local collidersM = world:queryRectangleArea(ex - 20, ey - 27, 40, 3, {'Player'})
            if #collidersM > 0  and mario.grounded == false then
                e.dead = true
                e.animation = animations.enemy2
                timer.after(0.3, function() e:destroy() end) 

            elseif mario:enter('Enemy') and mario.grounded then
                marioDamage()
                e.direction = e.direction * -1
                e:applyLinearImpulse(100 * e.direction, 0)
            end 
        end
    end
end

function enemyDraw()
    for i,e in ipairs(enemies) do
        if e.body then
            local x, y = e:getPosition()
            e.animation:draw(sprites.goombaSheet, x, y, nil, 3 * e.direction, 3, 10, 15)
        end
    end
end