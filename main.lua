local projection_scene = require'projection_scene'

local units = {}

for i=1,40 do
	for j=1,30 do
		table.insert(units,{i * 20, j * 20,0})
	end
end

function love.update(dt)
	local x,y = 0,0
	if love.keyboard.isDown'a' then
		x = -1
	elseif love.keyboard.isDown'd' then
		x = 1
	end
	if love.keyboard.isDown'w' then
		y = -1
	elseif love.keyboard.isDown's' then
		y = 1
	end

	if love.keyboard.isDown'j' then
		projection_scene.ez = projection_scene.ez - dt * 100
	elseif love.keyboard.isDown'k' then
		projection_scene.ez = projection_scene.ez + dt * 100
	end
	if love.keyboard.isDown'z' then
		projection_scene.euler_x = projection_scene.euler_x + dt
	end
	if love.keyboard.isDown'x' then
		projection_scene.euler_y = projection_scene.euler_y + dt
	end
	if love.keyboard.isDown'c' then
		projection_scene.euler_z = projection_scene.euler_z + dt
	end
	projection_scene:move(100*dt*x, 100*dt*y)


	if love.keyboard.isDown'left' then
		x = -1
	elseif love.keyboard.isDown'right' then
		x = 1
	end
	if love.keyboard.isDown'up' then
		y = -1
	elseif love.keyboard.isDown'down' then
		y = 1
	end
	projection_scene:moveScene(100*dt*x, 100*dt*y)
projection_scene:buildMatrix()
end

function love.draw()
	for i,v in ipairs(units) do
		local x,y,z = unpack(v)
		local s
		x,y = projection_scene:transform(x,y,z)
		love.graphics.circle('fill',x,y,2)
	end
end