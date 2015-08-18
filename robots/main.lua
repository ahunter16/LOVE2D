debug = true

player = {shapes = {}, x = love.graphics:getWidth()/2, y = 510, r = 0, speed= 0, img = nil, fw='w', bk='s', lf='a', rt='d', fire = ' ', lsc = 'q', rsc = 'e', dmg = 10, health = 100, accel = 30}
player2 = { shapes = {}, x = love.graphics:getWidth()/2, y = 100, r = 180, speed= 0, img= nil, fw='up', bk='down', lf='left', rt='right', fire = 'm', lsc = 1, rsc = 3, dmg = 10, health = 100, accel = 30}
circle = { dmg = 1, x = 0, y = 0, offset =1.2, angle = 0} --offset = distance from center, angle = clockwiseangle from horizontal 

players = {}
canShoot = true
canShootTimerMax = 0.2
canshoot2 = 0.2
canshoot2 = canShootTimerMax
canShootTimer = canShootTimerMax

bulletImg = nil

bullets = {}

function AddShape(player, shape)
	table.insert(player.shapes, shape)
end

function CheckCollision(e1, e2) -- modify to make 2 entities with central coordinates collide

	return e1.x - e1.img:getHeight()/2 < e2.x+e2.img:getWidth()/2 and
         e2.x < e1.x+e1.img:getWidth()/2+e2.img:getWidth()/2 and
         e1.y - e1.img:getHeight()/2 < e2.y+e2.img:getHeight()/2 and
         e2.y < e1.y+e1.img:getHeight()/2+e2.img:getHeight()/2
end

function ObjCoord(shape, player)
	shape.x = player.x - ((player.img:getWidth()/2) * shape.offset * math.cos(math.rad(player.r)+ shape.angle))
	shape.y = player.y - ((player.img:getWidth()/2) * shape.offset * math.sin(math.rad(player.r)+ shape.angle))
end

function love.load(arg)
	player.img = love.graphics.newImage('assets/comp.png')
	player2.img = love.graphics.newImage('assets/enemy.png')
	bulletImg = love.graphics.newImage('assets/bullet.png')
	table.insert(players, player)
	table.insert(players, player2)
	circle.angle= math.rad(22) + math.atan((player2.img:getHeight()/2)/player2.img:getWidth()/2)

end

function love.update(dt)
	if love.keyboard.isDown('escape') then
		love.event.push('quit')
	end

	--triangle.pos={player.x+player.img:getWidth(), player.y + player.img:getHeight()/2, player.x+player.img:getWidth(), player.y + player.img:getHeight()/2, player.x, player.y + player.img:getHeight()}

	for i, player in ipairs(players) do 
		if love.keyboard.isDown(player.fw) or love.keyboard.isDown(player.bk) then
			player.speed = player.speed
		elseif player.speed > player.accel then
			player.speed = player.speed - player.accel
		else player.speed = 0
		end

		if love.keyboard.isDown(player.fw) then
			--if player. y > player.img:getHeight()/2 then
				player.speed = player.speed + player.accel
				player.y = player.y - (player.speed * dt)*math.cos(math.rad(player.r))
				player.x = player.x + (player.speed * dt)*math.sin(math.rad(player.r))

			--end
		end

		if love.keyboard.isDown(player.bk) then
			--if player. y > player.img:getHeight()/2 then
			player.speed = player.accel + player.speed
				player.y = player.y + (player.speed * dt)*math.cos(math.rad(player.r))
				player.x = player.x - (player.speed * dt)*math.sin(math.rad(player.r))
			--end
		end


		if love.keyboard.isDown(player.lf) then
			if player.r - dt < 0 then
				player.r = 360 + (player.r - 100*dt)
			else player.r = player.r - 100*dt
			end
		end

		if love.keyboard.isDown(player.rt) then
			if player.r + dt > 360 then
				player.r = (player.r + 100*dt) - 360 
			else player.r = player.r + 100*dt
			end
		end

		if love.keyboard.isDown(player.lsc) then
			player.x = player.x - player.speed * dt
		end

		if love.keyboard.isDown(player.rsc) then
			player.x = player.x + player.speed * dt
		end


		if love.keyboard.isDown(player.fire) then--and canShoot then
			newBullet = { dmg = player.dmg, x = player.x + (player.img:getHeight())*math.sin(math.rad(player.r)), y = player.y - (player.img:getHeight())*math.cos(math.rad(player.r)), img = bulletImg, angle = math.rad(player.r), xvel = 1000*math.sin(math.rad(player.r)), yvel = 1000 * math.cos(math.rad(player.r))}
			table.insert(bullets, newBullet)
			canShoot = false
			canShootTimer = canShootTimerMax
		end
	end

	canShootTimer = canShootTimer - dt
	canshoot2 = canshoot2 - dt

	if canShootTimer < 0 then
		canShoot= true
	end

	for i, bullet in ipairs(bullets) do
		for j, player in ipairs(players) do
			if CheckCollision(player, bullet) then
				player.health = player.health - bullet.dmg
				table.remove(bullets, i)
			end
		end
	end

	for i, bullet in ipairs(bullets) do 
		bullet.x = bullet.x + bullet.xvel*dt
		bullet.y = bullet.y - bullet.yvel*dt
		if bullet.y < 0 then
			table.remove(bullets, i)
		end
	end
	ObjCoord(circle, player2)


end

function love.draw(dt)
	for i, player in ipairs(players) do
		love.graphics.draw(player.img, player.x, player.y, math.rad(player.r), 1, 1, player.img:getWidth()/2, player.img:getHeight()/2)
	end
	for i, bullet in ipairs(bullets) do
		love.graphics.draw(bullet.img, bullet.x, bullet.y, bullet.angle, 1, 1, bullet.img:getWidth()/2, bullet.img:getHeight()/2)

	end

	love.graphics.circle("fill", circle.x, circle.y, 10) 
	love.graphics.print(player.health, 20, 0)
	love.graphics.print(player2.health, 100, 0)
	love.graphics.print(circle.angle, 20, 12)
	--love.graphics.print(AngularCoords(player), 20, 12)

	--love.graphics.polygon("fill", 100, 0, 125, 50, 75, 50)
	--love.graphics.polygon("fill", triangle.pos)
	--love.graphics.print(score, 0, 0)	
end