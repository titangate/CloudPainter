local Object = require 'middleclass'.Object
Unit = Object:subclass'Unit'

function Unit:update(dt)
	if self.HP then
		if self.HPRate then
			self.HP = self.HPRate + self.HP
		end
	end
end

function Unit:damage(damageMeta)
	self.HP = self.HP - damageMeta.amount
	if self.HP <= 0 then
		self:kill()
	end
end

function Unit:kill()
	self.markedForRemoval = true
end


function Unit:draw()
	love.graphics.setColor(255,255,255)
	local x,y = self:getPosition()
	love.graphics.circle('fill', x, y, self.radius)
end

function Unit:getPosition()
	return self.body:getPosition()
end

function Unit:getFacingVector()
	local angle = self.body:getAngle()
	local x, y = math.cos(angle), math.sin(angle)
	return x, y
end


function Unit:collide(object, collisionDetail)
	print ('collision detected')
end