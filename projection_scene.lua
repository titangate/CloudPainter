local s = {ex = -400, ey = -300, ez = -100, euler_x = math.pi/6, euler_y = 0, euler_z = 0, w = 800, h = 600,
ax = 0, ay = 0}

function s:move(x,y)
	self.ex = self.ex + x
	self.ey = self.ey + y
end

function s:moveScene(x,y)
	self.ax = self.ax + x
	self.ay = self.ay + y
end

function s:buildMetrics()
	self.cx, self.cy, self.cz = math.cos(self.euler_x), math.cos(self.euler_y), math.cos(self.euler_z)
	self.sx, self.sy, self.sz = math.sin(self.euler_x), math.sin(self.euler_y), math.sin(self.euler_z)
end

local N,F = -100,300

function s:transform(x,y,z)
	x = x + self.ax
	y = y + self.ay
	local dx = self.cy*(self.sz * y + self.cz * x) - self.sy * z
	local dy = self.sx*(self.cy * z + self.sy * (self.sz * y + self.cz * x))
		+ self.cx * (self.cz * y - self.sz * x)
	local dz = self.cx*(self.cy * z + self.sy * (self.sz * y + self.cz * x))
		- self.sx * (self.cz * y - self.sz * x)
	dz = dz * (N+F)/(N-F)
	dz = dz + 2 * N * F / (N - F)
	local w = self.ez / dz
	local bx = w * dx
	local by = w * dy
	return bx - self.ex,by - self.ey, dz
end

return s