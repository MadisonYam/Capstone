player = {}


function player.load()

        player.collider = world:newBSGRectangleCollider(400, 250, 65, 100, 14)
        player.collider:setFixedRotation(true)
        player.x = 0
        player.y = 0
        player.xvel = 0
        player.yvel = 0
        player.friction = 5
        player.speed = 250
        player.spriteSheet = love.graphics.newImage('sprites/guard_yellow_spritesheet.png')
        player.grid = anim8.newGrid( 16, 16, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())

end


function player:update(dt)
        player.control(dt)
        player.physics(dt)
        player.colliderMatching(dt)
end

function player.colliderMatching(dt)
        player.x = player.collider:getX()
        player.y = player.collider:getY()
end

function player.control(dt)
        local isMoving = false
        player.xvel = 0
        player.yvel = 0
        -- Player Movement
       if love.keyboard.isDown("d") then
           player.xvel = player.speed
           player.anim = player.animations.right
           isMoving = true
       end
       if love.keyboard.isDown("a") then
           player.xvel = player.speed * -1
           player.anim = player.animations.left
           isMoving = true
       end
       if love.keyboard.isDown("s") then
           player.yvel = player.speed
           player.anim = player.animations.down
           isMoving = true
       end
       if love.keyboard.isDown("w") then
           player.yvel = player.speed * -1
           player.anim = player.animations.up
           isMoving = true
       end
    
       -- Sets the players hitbox to move with where our 
       -- player is currently moving
       player.collider:setLinearVelocity(player.xvel, player.yvel)

    
       -- switches game back into the main menu
       if love.keyboard.isDown("escape") then
            Gamestate.switch(menu)
       end
    
       -- Freezes the frame on the idle sprite in that direction
       if (isMoving == false) then
            player.anim:gotoFrame(3)
       end
end

function player.physics(dt)
	player.x = player.x + player.xvel * dt
	player.y = player.y + player.yvel * dt
	player.xvel = player.xvel * (1 - math.min(dt*player.friction, 1))
	player.yvel = player.yvel * (1 - math.min(dt*player.friction, 1))
end

