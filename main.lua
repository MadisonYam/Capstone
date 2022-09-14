-- Gamestate library
Gamestate = require 'libraries.gamestate'
local menu = {}
local game = {}

-- Initializes the main menu at a very basic level
function menu:draw()
    love.graphics.print("Press enter to play", 10, 10)
end

function menu:keyreleased(key, code)
    if key == 'return' then
        Gamestate.switch(game)
    end
end

function game:enter()
    -- Hitbox library
    wf = require 'libraries/windfield'
    -- Tiled implementation library
    sti = require 'libraries/sti'
    -- Animations library
    anim8 = require 'libraries/anim8'
    -- Camera library
    cam = require 'libraries/camera'

    -- Makes the character stretch not blurry 
    love.graphics.setDefaultFilter("nearest", "nearest")
    
    camera = cam()

    -- loads in the map
    testingMap = sti('maps/testing-zone.lua')

    -- draws the window size
    world = wf.newWorld(0, 0)
    love.window.setMode(2000, 1000)

    -- Player table: 
    --          Contains player information 
    player = {}
    
        player.speed = 250
        player.x = 0
        player.y = 0
        player.speed = 2.5
        player.spriteSheet = love.graphics.newImage('sprites/loose-sprites.png')
        player.grid = anim8.newGrid( 16, 16, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())

    -- Player Animation table: 
    --          Contains animations and assigns them to their given direction
    player.animations = {}
        
        player.animations.down = anim8.newAnimation( player.grid('1-4', 1), 0.2 )
        player.animations.left = anim8.newAnimation( player.grid('1-4', 3), 0.2 )
        player.animations.right = anim8.newAnimation( player.grid('1-4', 7), 0.2 )
        player.animations.up = anim8.newAnimation( player.grid('1-4', 5), 0.2 )
    
    -- Initializes player animations and allows the movment keys to 
    -- influence which animation plays
    player.anim = player.animations.left

    timer = 0 
end

function game:update(dt)
    timer = timer + dt

    local isMoving = false

    -- Player Movement
   if love.keyboard.isDown("d") then
       player.x = player.x + player.speed
       player.anim = player.animations.right
       isMoving = true
   end
   if love.keyboard.isDown("a") then
       player.x = player.x - player.speed
       player.anim = player.animations.left
       isMoving = true
   end
   if love.keyboard.isDown("s") then
       player.y = player.y + player.speed
       player.anim = player.animations.down
       isMoving = true
   end
   if love.keyboard.isDown("w") then
       player.y = player.y - player.speed
       player.anim = player.animations.up
       isMoving = true
   end

   -- switches game back into the main menu
   if love.keyboard.isDown("escape") then
        Gamestate.switch(menu)
   end

   -- Freezes the frame on the idle sprite in that direction
   if (isMoving == false) then
        player.anim:gotoFrame(3)
   end

   -- Moves the camera according to the players movements
   camera:lookAt(player.x, player.y)

   player.anim:update(dt)

   world:update(dt)
   
end

function game:draw()
    -- Tells the game where to start looking through the camera POV
    camera:attach()
        testingMap:drawLayer(testingMap.layers["Tile Layer 1"])
        testingMap:drawLayer(testingMap.layers["grate"])
        testingMap:drawLayer(testingMap.layers["Walls"])
        player.anim:draw(player.spriteSheet, player.x, player.y, nil, 6, nil, 8, 8)
    camera:detach()
end

-- prepares the game for switches
function love.load()
    Gamestate.registerEvents()
    Gamestate.switch(menu)
end