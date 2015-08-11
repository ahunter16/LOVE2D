--a simple "game" I've been making at lunch!
debug = true

player= { x = 200, y = 510, speed= 200, img = nil}

canShoot = true
canShootTimerMax = 0.2
canShootTimer = canShootTimerMax

bulletImg = nil

bullets = {}

createEnemyTimerMax = 0.4
createEnemyTimer = createEnemyTimerMax

enemyImg = nil

enemies = {}

isAlive = true

score = 0

function CheckCollision(e1, e2)

	return e1.x < e2.x+e2.img:getWidth() and
         e2.x < e1.x+e1.img:getWidth() and
         e1.y < e2.y+e2.img:getHeight() and
         e2.y < e1.y+e1.img:getHeight()
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

	if love.keyboard.isDown('left', 'a') then
		if player.x > 0 then
			player.x = (player.x - (player.speed*dt))
		end
	elseif love.keyboard.isDown('right', 'd') then
		if player.x < (love.graphics.getWidth() - player.img:getWidth()) then
			player.x = (player.x + (player.speed*dt))
		end
	end

	if love.keyboard.isDown(' ') and canShoot then
		newBullet = { x = player.x + (player.img:getWidth()/2), y = player.y, img = bulletImg }
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

	for i, enemy in ipairs(enemies) do
		enemy.y = enemy.y + (100 * dt)

		if enemy.y > 650 then
			table.remove(enemies, i)
		end
	end


	createEnemyTimer = createEnemyTimer - (1 * dt)
	if createEnemyTimer < 0 then
		createEnemyTimer = createEnemyTimerMax
		randomNumber = math.random(10, love.graphics.getWidth() - 10)
		newEnemy = {x = randomNumber, y = -10, img = enemyImg }
		table.insert(enemies, newEnemy)
	end

	for i, enemy in ipairs(enemies) do
		for j, bullet in ipairs(bullets) do
			if CheckCollision(enemy, bullet) then
				table.remove(bullets, j)
				table.remove(enemies, i)
				score = score + 1
			end
		end

		if CheckCollision(enemy, player) and isAlive then
			table.remove(enemies, i)
			--isAlive = false
		end
	end

end

function love.draw(dt)
	love.graphics.draw(player.img, player.x, player.y)
	for i, bullet in ipairs(bullets) do
		love.graphics.draw(bullet.img, bullet.x, bullet.y)
	end

	for i, enemy in ipairs(enemies) do
		love.graphics.draw(enemy.img, enemy.x, enemy.y)
	end

	love.graphics.print(score, 0, 0)


end