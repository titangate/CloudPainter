require 'system'

local projection_scene = require'projection_scene'

local units = {}

local scene = require 'logic_scene'

local chr

for i=1,40 do
	for j=1,30 do
		table.insert(units,{i * 20, j * 20,0})
	end
end

function love.load()
	chr = scene:add_character{x = 100, y = 100, radius = 16, move_force = 800}
	assert(chr, "character creation failed")
end

function love.update(dt)
	local x,y = get_direction()
	if not (x == 0 and y == 0) then
		assert (x and y)
		chr.intent = {
			action = "move",
			intended_speed_squared = 100,
			x = x,
			y = y
		}
	else
		chr.intent = {}
	end
	scene:update(dt)
end

function love.draw()
	scene:draw()
end