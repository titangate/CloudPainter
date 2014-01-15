require 'skill'
require 'projectile'

local FlyingSwordProjectile = Projectile:subclass'FlyingSwordProjectile'

function FlyingSwordProjectile:collide(object, collisionDetail)
	print 'w00t'
		self:kill()
end

FlyingSword = Skill:subclass'FlyingSword'

function FlyingSword:cast(scene, target, owner)
	local x,y = owner:getPosition()
	local vx, vy = owner:getFacingVector()
	local missile = scene:addCharacter{
		unitType = FlyingSwordProjectile,
		radius = 8,
		friction_factor = 0,
		collisionType = owner.collisionType.."Bullet",
		x = x,
		y = y,
		vx = vx * 300,
		vy = vy * 300,
		density = 5
	}
end