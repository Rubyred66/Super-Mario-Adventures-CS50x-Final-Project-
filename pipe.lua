pipes = {}

pipeX = 0
pipeY = 0

function pipeUpdate(dt)
    for i,p in ipairs(pipes) do
        if p.body then
            local px, py = p:getPosition()
            local colliders = world:queryRectangleArea(px - 50, py - 70, 100, 2, {'Player'})
            if #colliders > 0 and love.keyboard.isDown("down") then
                p:setY(py + 100)

                for i,o in ipairs(pipes) do
                    local x, y = o:getPosition()
                    o:setY(y + 100)
                    timer.after(2, function() o:setY(o.y) end) 
                end

                if px > 6000 then 
                    marioPipe(1)
                else
                    marioPipe(2)
                end
                timer.after(1, function() p:setY(p.y) end)
            end 
        end
    end

    for i,f in ipairs(finish) do
        if f.body then
            local x, y = f:getPosition()
            local colliders = world:queryRectangleArea(x - 50, y - 70, 100, 2, {'Player'})
            if #colliders > 0 and love.keyboard.isDown("down") then
                f:destroy()
                marioFinish()
            end 
        end
    end
end

function spawnPipe(x, y)
    local pipe = world:newRectangleCollider(x - 10, y, 130 ,130, {collision_class = 'Pipe'})
    pipe:setType('static')
    pipe.x, pipe.y = pipe:getPosition()
    table.insert(pipes, pipe)
end

function spawnFinish(x, y)
    local pipe = world:newRectangleCollider(x - 10, y, 130 ,130, {collision_class = 'Pipe'})
    pipe:setType('static')
    pipe.x, pipe.y = pipe:getPosition()
    table.insert(finish, pipe)
end