require 'buff.buff'
require 'unit.sword_spirit_unit'

SwordSpirit = Buff:subclass'SwordSpirit'

function SwordSpirit:initialize(...)
	Buff.initialize(self,...)
	self.timeElapsed = 0
	self.unitSpirits = {}
end

function SwordSpirit:update(dt, unit)
	self.timeElapsed = self.timeElapsed + dt
	local x,y = unit:getPosition()
	for i,sword in ipairs(self.unitSpirits) do
		local c,s = math.cos(self.timeElapsed + i*math.pi*2/#self.unitSpirits), math.sin(self.timeElapsed + i*math.pi*2/#self.unitSpirits)
		sword:setPosition(x+c*300, y+s*300)
	end
end

function SwordSpirit:draw()
end

function SwordSpirit:apply(unit)
	local scene = unit.scene
	for i = 1,4 do
		local sword = scene:addCharacter{
		unitType = SwordSpiritUnit,
		disablePhysics = true}
		table.insert(self.unitSpirits, sword)
	end
end