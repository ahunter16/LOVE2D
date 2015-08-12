debug = true

player = { x = 200, y = 510, r = 0, speed= 200, img = nil}
triangle = { dmg = 1, pos = {0,0,0,0,0,0}}

canShoot = true
canShootTimerMax = 0.2
canShootTimer = canShootTimerMax

bulletImg = nil

bullets = {}

function CheckCollision(e1, e2)

	return e1.x < e2.x+e2.img:getWidth()/2 and
         e2.x < e1.x+e1.img:getWidth()+e2.img:getWidth()/2 and
         e1.y < e2.y+e2.img:getHeight()/2 and
         e2.y < e1.y+e1.img:getHeight()+e2.img:getHeight()/2
end

function love.load(arg)
	player.img = love.graphics.newImage('assets/comp.png')
	bulletImg = love.graphics.newImage('assets/bullet.png')
	enemyImg = love.graphics.newImage('assets/enemy.png')
end

function love.update(dt)
	if love.keyboard.isDown('escape') then
		love.event.push('quit')
	end

	triangle.pos={player.x+player.img:getWidth(), player.y + player.img:getHeight()/2, player.x+player.img:getWidth(), player.y + player.img:getHeight()/2, player.x, player.y + player.img:getHeight()}

	if love.keyboard.isDown('w') then
		if player. y > player.img:getHeight()/2 then
			player.y = player.y - (player.speed * dt)*math.cos(math.rad(player.r)) -- convert to radians
			player.x = player.x + (player.speed * dt)*math.sin(math.rad(player.r))
		end
	end
	if love.keyboard.isDown('s') then
		if player. y > player.img:getHeight()/2 then
			player.y = player.y + (player.speed * dt)*math.cos(math.rad(player.r)) -- convert to radians
			player.x = player.x - (player.speed * dt)*math.sin(math.rad(player.r))
		end
	end

	if love.keyboard.isDown('a') then
		if player.r - dt < 0 then
			player.r = 360 + (player.r - 100*dt)
		else player.r = player.r - 100*dt
		end
	end

	if love.keyboard.isDown('d') then
		if player.r + dt > 360 then
			player.r = (player.r + 100*dt) - 360 
		else player.r = player.r + 100*dt
		end
	end


	if love.keyboard.isDown(' ') and canShoot then
		newBullet = { x = player.x, y = player.y + (player.img:getHeight()/2), img = bulletImg }
		table.insert(bullets, newBullet)
		canShoot = false
		canShootTimer = canShootTimerMax
	end

	canShootTimer = canShootTimer - (1*dt)

	if canShootTimer < 0 then
		canShoot= true
	end

	for i, bullet in ipairs(bullets) do 
		bullet.y = bullet.y - (500 * dt)
		if bullet.y < 0 then
			table.remove(bullets, i)
		end
	end


end

function love.draw(dt)
	love.graphics.draw(player.img, player.x, player.y, math.rad(player.r), 1, 1, player.img:getWidth()/2, player.img:getHeight()/2)
	for i, bullet in ipairs(bullets) do
		love.graphics.draw(bullet.img, bullet.x, bullet.y)
	end
	love.graphics.print(player.r, 20, 0)

	love.graphics.polygon("fill", triangle.pos)
	--love.graphics.print(score, 0, 0)
	


end