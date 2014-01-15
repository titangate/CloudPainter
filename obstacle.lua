local Object = require 'middleclass'.Object
Obstacle = Object:subclass'Obstacle'

function Obstacle:draw()
	local x,y = self.body:getPosition()
	local w,h = self.w, self.h
	love.graphics.rectangle('fill', x - w/2, y - h/2, w, h)
end



function Obstacle:collide(object, collisionDetail)
	print ('collision detected')
end