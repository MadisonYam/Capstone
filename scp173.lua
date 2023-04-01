Gamestate = require 'libraries.gamestate'
anim8 = require 'libraries/anim8'

-- makes stretch not blurry
love.graphics.setDefaultFilter("nearest", "nearest")
--scp173.spawn(-2687,6930)
scp173 = {}
    scp173.x = -2687
    scp173.y = 6930
    scp173.width = 5
    scp173.height = 5
    scp173.speed = 80
    scp173.friction = 7.5
    scp173.spriteSheet = love.graphics.newImage('sprites/eyeballW.png')
    scp173.grid = anim8.newGrid(32, 32, scp173.spriteSheet:getWidth(), scp173.spriteSheet:getHeight())
    scp173.found = false


scp173.animations = {}
    scp173.animations.right = anim8.newAnimation(scp173.grid('1-4', 2), 0.25)
    scp173.animations.left = anim8.newAnimation(scp173.grid('1-4', 7), 0.25)
    scp173.animations.idleR = anim8.newAnimation(scp173.grid('1-4', 1), 0.25)
    scp173.animations.idleL = anim8.newAnimation(scp173.grid('1-4', 6), 0.25)
    scp173.anim = scp173.animations.right

function scp173.spawn(x,y)
    table.insert(scp173, {x = x, y=y, xvel=0,yvel=0, health = 2, width = 2, height = 2})
end

function scp173.load()
    scp173.collider = world:newBSGRectangleCollider(scp173.x, scp173.y, 45, 45, 14)
    scp173.collider:setFixedRotation(true)
    scp173.colX = 0
    scp173.colY = 0
    scp173.timer = 0
    scp173.colxvel = 0
    scp173.colyvel = 0
    scp173.x = -2687
    scp173.y = 6930
    scp173.lastx = 0
    scp173.lasty = 0

end

function scp173.draw()
        love.graphics.setColor(255,255,255)
        --love.graphics.rectangle('fill',scp173.colX,scp173.colY,scp173.width,scp173.height)
        scp173.anim:draw(scp173.spriteSheet, scp173.x,scp173.y, nil, 3, nil, 4, 4)
end




function scp173.colAI(dt)

    --scp173.timer = scp173.timer +1
    scp173.distance = ((player.x - scp173.collider:getX())^2 + (player.y - scp173.collider:getY())^2)^(1/2)
    scp173.xdist = ((player.x - scp173.collider:getX())^2)^(1/2)
    scp173.ydist = ((player.y - scp173.collider:getY())^2)^(1/2)
    scp173.xvect = (player.x - scp173.collider:getX()) / scp173.xdist
    scp173.yvect = (player.y - scp173.collider:getY()) / scp173.ydist

--snap out of player view
    if scp173.distance > 700 then
        --scp173.collider:setPosition(50+((player.x + scp173.colX)/2), -(50+(-player.y + -scp173.colY)/2))
    end

--snap back to player
    if scp173.distance > 1000 then
        --scp173.collider:setPosition((player.x), ((player.y)))
        scp173.found = false
    else
        scp173.found = true
    end


--check distance to player
        if scp173.distance > 1 and scp173.found == true then
            scp173.colxvel = 0
            scp173.colyvel = 0
        --check scp173 right
            if (player.x > scp173.collider:getX() and player.anim ~= player.animations.left) or (player.x > scp173.collider:getX() and shaders.flashlight == false) then
                print(shaders.flashlight)
                if scp173.colxvel == 0 then
                    scp173.colxvel = scp173.speed
                end
                --scp173.colxvel = scp173.speed
                --scp173.anim = scp173.animations.right
            end
        --check scp173 left
            if (player.x < scp173.collider:getX() and player.anim ~= player.animations.right) or (player.x < scp173.collider:getX() and shaders.flashlight == false) then
                print(shaders.flashlight)
                if scp173.colxvel == 0 then
                    scp173.colxvel = -scp173.speed
                end
                --scp173.colxvel = -scp173.speed
                --scp173.anim = scp173.animations.left
            end
        --check scp173 below
            if (player.y > scp173.collider:getY() + 20 and player.anim ~= player.animations.up) or (player.y > scp173.collider:getY() + 20 and shaders.flashlight == false) then
                if scp173.colyvel == 0 then
                scp173.colyvel = scp173.speed
                end
                --scp173.anim = scp173.animations.left
            end
        --check scp173 above
            if (player.y < scp173.collider:getY() -20 and player.anim ~= player.animations.down) or (player.y < scp173.collider:getY() -20 and shaders.flashlight == false) then
                if scp173.colyvel == 0 then
                scp173.colyvel = -scp173.speed
                end
                --scp173.anim = scp173.animations.right
            end
            if scp173.colxvel < 0 and scp173.xdist > 5 then
                scp173.anim = scp173.animations.left
        end
        if scp173.colxvel > 0 and scp173.xdist > 5 then
            scp173.anim = scp173.animations.right  
    end

        else
            if (player.timer%5 == 0) then
            scp173.colxvel = math.random(-100,100)
            scp173.colyvel = math.random(-100,100)

            if (math.random(0,100) == 19) then
                if scp173.anim == scp173.animations.idleR then
                scp173.anim = scp173.animations.idleL
                else
                    scp173.anim = scp173.animations.idleR
                end
            end
            end
        end

        scp173.colX = scp173.colX + scp173.colxvel *dt
        scp173.colY = scp173.colY + scp173.colyvel *dt
        scp173.colxvel = scp173.colxvel * (1-math.min(dt*scp173.friction,1))
        scp173.colyvel = scp173.colyvel * (1-math.min(dt*scp173.friction,1))

        scp173.collider:setLinearVelocity(scp173.colxvel, scp173.colyvel)

end

function scp173.collision()
    if scp173.xdist < 90 then
        if scp173.ydist < 55 then
        --scp173.colxvel = player.xvel
        Sounds.collision:play()
        player.health = player.health - .1
        end
    end
    if scp173.ydist < 120 then
        if scp173.xdist < 70 then
        --scp173.colyvel = player.yvel
        Sounds.collision:play()
        player.health = player.health - .1
        end
    end
end

function scp173.pathing()

end

function scp173.colliderMatching(dt)
    scp173.x = scp173.collider:getX() -43
    scp173.y = scp173.collider:getY() -15
end

 function DRAW_scp173()
     scp173.draw()
end

function UPDATE_scp173(dt)
    scp173.colAI(dt)
    scp173.collision()
    scp173.colliderMatching(dt)
end