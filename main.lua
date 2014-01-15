require 'system'

local projection_scene = require'projection_scene'

local units = {}

local scene = require 'logic_scene'

require 'flying_sword'

local chr

local fs = FlyingSword()

for i=1,40 do
	for j=1,30 do
		table.insert(units,{i * 20, j * 20,0})
	end
end

function love.load()
	chr = scene:addCharacter{x = 100, y = 100, radius = 16, moveForce = 800, collisionType = 'player'}
	scene:addCharacter{x = 200, y = 100, radius = 16, moveForce = 800, collisionType = 'player'}
	scene:addCharacter{x = 300, y = 100, radius = 16, moveForce = 800, collisionType = 'enemy'}
	assert(chr, "character creation failed")

	scene:addObstacle{x = 250, y = 300, w = 400, h = 25}
end

function love.update(dt)
	local x,y = get_direction()
	if not (x == 0 and y == 0) then
		assert (x and y)
		chr.intent = {
			action = "move",
			intendedSpeedSquared = 100,
			x = x,
			y = y
		}
	else
		chr.intent = {}
	end
	scene:update(dt)
end

function love.keypressed(k)
	if k == ' ' then
		fs:cast(scene, nil, chr)
	end
end

function love.draw()
	scene:draw()
end