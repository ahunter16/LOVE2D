--a simple "game" I've been making at lunch!
debug = true

player= { x = 200, y = 710, speed= 200, img = nil}

canShoot = true
canShootTimerMax = 0.2
canShootTimer = canShootTimerMax

bulletImg = nil

bullets = {}

createEnemyTimerMax = 0.4
createEnemyTimer = createEnemyTimerMax

enemyImg = nil

enemies = {}

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

		if enemy.y > 850 then
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

end

function love.draw(dt)
	love.graphics.draw(player.img, player.x, player.y)
	for i, bullet in ipairs(bullets) do
		love.graphics.draw(bullet.img, bullet.x, bullet.y)
	end

	for i, enemy in ipairs(enemies) do
		love.graphics.draw(enemy.img, enemy.x, enemy.y)
	end


end