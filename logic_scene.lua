require 'character'
require 'obstacle'
require 'collision_masks'
local Object = require 'middleclass'.Object
local lp = love.physics

function getBodySpeedSquared(body)
	local x,y = body:getLinearVelocity()
	return x*x+y*y
end

Scene = Object:subclass'Scene'

function Scene:initialize()
	self.world = lp.newWorld()
	self.characters = {}
	self.obstacles = {}

	self.world:setCallbacks( beginContact, nil, nil, nil )

	self.ground = lp.newBody(self.world, 0, 0,'static')
end

function beginContact(a, b, coll)
	a = a:getUserData()
	b = b:getUserData()
	if (a and b) then
		a:collide(b,coll)
		b:collide(a,coll)
	end
end

function Scene:serialize()
end

function Scene:deserialize()
end

function Scene:addObstacle(parameters)
	local c = (parameters.unitType or Obstacle)()
	table.insert(self.obstacles, c)
	c.shape = lp.newRectangleShape(parameters.w, parameters.h)
	c.body = lp.newBody(self.world, parameters.x, parameters.y, 'static')
	c.fixture = lp.newFixture(c.body, c.shape, parameters.density or 1)
	c.fixture:setUserData(c)
	initializeCollisionMasksForFixture(c.fixture, parameters.collisionType or 'obstacle')
	c.w, c.h = parameters.w, parameters.h
	return c
end

function Scene:addCharacter(parameters)
	local c = (parameters.unitType or Character)()
	table.insert(self.characters, c)
	c.shape = lp.newCircleShape(parameters.radius)
	c.body = lp.newBody(self.world,parameters.x, parameters.y,'dynamic')
	c.fixture = lp.newFixture(c.body,c.shape)
	c.fixture:setUserData(c)
	c.intent = {}
	c.radius = parameters.radius
	c.moveForce = parameters.moveForce
	c.friction = (parameters.friction_factor or 250) * c.body:getMass()
	initializeCollisionMasksForFixture(c.fixture, parameters.collisionType)
	c.collisionType = parameters.collisionType
	if (parameters.vx) then
		c.body:setLinearVelocity(parameters.vx, parameters.vy)
	end
	return c
end

function Scene:removeObstacle(obstacle)
end

function Scene:removeCharacter(character)
end

function Scene:update(dt)
	local toRemove = {}
	for _,character in ipairs(self.characters) do
		assert(character.intent, "A character must have an intent")
		local fx, fy = character.intent.x, character.intent.y
		local vx, vy = character.body:getLinearVelocity()
		if character.intent.action == "move" then
			if dot(fx,fy,vx,vy) < character.intent.intendedSpeedSquared then
				vx, vy = normalize(vx, vy)
				local x,y = perpendicular(vx,vy, fx,fy)
				fx, fy = (fx - x) * character.moveForce, (fy - y) * character.moveForce
				character.body:applyForce(fx, fy)
			end
			character.body:setAngle(math.atan2(vy, vx))
		end
		local x,y = normalize(vx,vy)
		character.body:applyForce(-character.friction/2 * x, -character.friction/2 * y)
		if character.markedForRemoval then
			toRemove[character] = true
			print (character, "to be removed")
		end
	end
	for character,_ in pairs(toRemove) do
		setAllMasks(character.fixture)
	end
	self.world:update(dt)
	for character,_ in pairs(toRemove) do
		for i,c in ipairs(self.characters) do
			if character == c then
				table.remove(self.characters, i)
				c.fixture:destroy()
				c.body:destroy()
			end
		end
	end
end

function Scene:draw(x,y,w,h)
	for _,character in ipairs(self.characters) do
		character:draw()
	end
	for _,obstacle in ipairs(self.obstacles) do
		obstacle:draw()
	end
end

return Scene