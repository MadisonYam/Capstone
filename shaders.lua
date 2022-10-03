shaders = {}

-- NOTE: These shaders are written using GLSL for Love2D

windowWidth = 1920
windowHeight = 1080
scale = 2.5
-- Hole-punch light source
shaders.simpleLight = love.graphics.newShader[[
    extern number playerX = 0;
    extern number playerY = 0;
    number radius = 400;
    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ) {
        number distance = pow(pow(screen_coords.x - playerX, 2) + pow(screen_coords.y - playerY, 2), 0.5);
        if (distance < radius) {
            return vec4(0, 0, 0, 0);
        }
        else {
            return vec4(0, 0, 0, 1);
        } 
    }
]]

-- Faded light source
shaders.trueLight = love.graphics.newShader[[
    extern number playerX = 0;
    extern number playerY = 0;
    number radius = 900;
    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ) {
        number distance = pow(pow(screen_coords.x - playerX, 2) + pow(screen_coords.y - playerY, 2), 0.5);
        number alpha = distance / radius;
        return vec4(0, 0, 0, alpha);
    }
]]

-- White damage flash
shaders.whiteout = love.graphics.newShader[[
    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ) {
        vec4 pixel = Texel(texture, texture_coords);
        if (pixel.a == 1) {
            return vec4(1, 1, 1, 1);
        } else {
            return vec4(0, 0, 0, 0);
        }
    }
]]

function shaders:update(dt)


        local px, py = player.collider:getPosition()

        -- Get width/height of background
        local mapW = testingMap.width * testingMap.tilewidth
        local mapH = testingMap.height * testingMap.tileheight

        local lightX = (windowWidth/2)
        local lightY = (windowHeight/2)

        -- Left border
        if player.x < windowWidth/2 then
            lightX = px * scale
        end

        -- Top border
        if player.y < windowHeight/2 then
            lightY = py * scale
        end

        -- Right border
        if player.x > (mapW - windowWidth/2) then
            lightX = (px - player.x) * scale + (windowWidth/2)
        end

        -- Bottom border
        if player.y > (mapH - windowHeight/2) then
            lightY = (py - player.y) * scale + (windowHeight/2)
        end

        shaders.simpleLight:send("playerX", lightX)
        shaders.simpleLight:send("playerY", lightY)
        shaders.trueLight:send("playerX", lightX)
        shaders.trueLight:send("playerY", lightY)
    
end