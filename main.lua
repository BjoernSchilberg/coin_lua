-- Window width & height
width = love.graphics.getWidth()
height = love.graphics.getHeight()

timer = 0
score = 0
game_over = false

fox = {}
coin = {}
mouse = {}

function love.resize(w, h)
    width, height = w, h
    scale = height / 1024
end

-- Collision detection function;
-- Returns true if two boxes overlap, false if they don't; x1,y1 are the
-- top-left coords of the first box, while w1,h1 are its width and height;
-- x2,y2,w2 & h2 are the same, but for the second box.
-- Source: https://love2d.org/wiki/BoundingBox.lua
function CheckCollision(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and x2 < x1 + w1 and y1 < y2 + h2 and y2 < y1 + h1
end

function place_coin()
    coin.x = math.random(20, width - 20)
    coin.y = math.random(20, height - 20)
end

function love.load()
    love.resize(love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setBackgroundColor(0, 255, 0)
    font = love.graphics.newFont('tic-80-wide-font.ttf', 25)
    love.graphics.setFont(font)

    -- fox
    fox.image = love.graphics.newImage('images/fox.png')
    fox.x = 100
    fox.y = 100
    fox.speed = 300

    -- coin
    coin.image = love.graphics.newImage('images/coin.png')
    coin.x = 200
    coin.y = 200

    place_coin()
end

function love.update(dt)
    -- Increase variable timer by 1 every second
    timer = timer + dt
    -- Game over after 15 seconds
    if timer > 15 then
        game_over = true
    end

    if love.keyboard.isDown('right') then
        fox.x = fox.x + (fox.speed * dt)
    end
    if love.keyboard.isDown('left') then
        fox.x = fox.x - (fox.speed * dt)
    end
    if love.keyboard.isDown('down') then
        fox.y = fox.y + (fox.speed * dt)
    end
    if love.keyboard.isDown('up') then
        fox.y = fox.y - (fox.speed * dt)
    end
    if love.mouse.isDown(1) then
        mouse.x, mouse.y = love.mouse.getPosition()

        if fox.x < mouse.x then
            fox.x = fox.x + (fox.speed * 2.5 * dt)
        end
        if fox.x > mouse.x then
            fox.x = fox.x - (fox.speed * 2.5 * dt)
        end
        if fox.y < mouse.y then
            fox.y = fox.y + (fox.speed * 2.5 * dt)
        end
        if fox.y > mouse.y then
            fox.y = fox.y - (fox.speed * 2.5 * dt)
        end
    end
    if
        CheckCollision(
            fox.x,
            fox.y,
            fox.image:getWidth(),
            fox.image:getHeight(),
            coin.x,
            coin.y,
            coin.image:getWidth(),
            coin.image:getHeight()
        )
     then
        score = score + 1
        place_coin()
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.draw()
    love.graphics.draw(fox.image, fox.x, fox.y)
    love.graphics.draw(coin.image, coin.x, coin.y)
    love.graphics.print('Score: ' .. tostring(score), 10, 10)

    if game_over then
        -- Clear screen and set pink background
        love.graphics.clear(255 / 255, 160 / 255, 122 / 255, 255 / 255)
        font = love.graphics.newFont('tic-80-wide-font.ttf', 40)
        love.graphics.setFont(font)
        love.graphics.print('Final Score: ' .. tostring(score), 10, 10)
    -- TODO
    --love.graphics.draw(fox.image, width/2, height/2)
    -- love.event.quit('restart')
    end
end
