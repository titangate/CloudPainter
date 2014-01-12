local lp = love.physics

function get_body_speed_squared(body)
	local x,y = body:getLinearVelocity()
	return x*x+y*y
end

local Scene = {
	world = lp.newWorld(),
	characters = {},
	obstacles = {}
}

Scene.world:setGravity(0,0)

Scene.ground = lp.newBody(Scene.world, 0, 0,'static')

function Scene:serialize()
end

function Scene:deserialize()
end

function Scene:add_obstacle(parameters)

end

function Scene:add_character(parameters)
	local c = {}
	table.insert(self.characters, c)
	c.shape = lp.newCircleShape(parameters.radius)
	c.body = lp.newBody(self.world,parameters.x, parameters.y,'dynamic')
	c.fixture = lp.newFixture(c.body,c.shape)
	c.intent = {}
	c.radius = parameters.radius
	c.move_force = parameters.move_force
	return c
end

function Scene:remove_obstacle(obstacle)
end

function Scene:remove_character(character)
end

function Scene:update(dt)
	for _,character in ipairs(self.characters) do
		assert(character.intent, "A character must have an intent")
		local fx, fy = character.intent.x, character.intent.y
		local vx, vy = character.body:getLinearVelocity()
		if character.intent.action == "move" then
			if dot(fx,fy,vx,vy) < character.intent.intended_speed_squared then
				fx, fy = fx * character.move_force, fy * character.move_force
				character.body:applyForce(fx, fy)
			end
		end
		local x,y = normalize(vx,vy)
		character.body:applyForce(-character.move_force/2 * x, -character.move_force/2 * y)
	end
	self.world:update(dt)
end

function Scene:draw()
	for _,character in ipairs(self.characters) do
		local x,y = character.body:getPosition()
		love.graphics.circle('fill', x, y, character.radius)
	end
end

return Scene