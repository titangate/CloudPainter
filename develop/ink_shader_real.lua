local example = {}
example.title = "Cloud painter (GPU)"
example.category = "Unit development"

local InkEffect = {
	w = 600,
	h = 375
}

local circle = love.graphics.newImage'assets/images/circle.png'
local sky = love.graphics.newImage'assets/images/sky.png'

function example.func(demo)
	
	local frame = loveframes.Create("frame")
	frame:SetName("Scene")
	frame:CenterWithinArea(unpack(demo.centerarea))
	frame:SetSize(600,400)
		
	local scene = loveframes.Create("scene_renderer", frame)
	scene:SetSize(frame.width,frame.height - 25)
	scene:SetPos(0,25)

	local s = Scene()
	scene:SetScene(InkEffect)

	InkEffect:load()
end

function InkEffect:load()
	local image = love.graphics.newImage("assets/images/testimage.jpg")
	assert(image)
	self.canvas = love.graphics.newCanvas(self.w, self.h)
	self.canvas2 = love.graphics.newCanvas(self.w, self.h)
	self.vField = love.graphics.newCanvas(self.w, self.h)
	self.vField2 = love.graphics.newCanvas(self.w, self.h)
	love.graphics.setCanvas(self.canvas)
	--love.graphics.draw(image)
	love.graphics.setCanvas()
	love.graphics.setCanvas(self.vField)
	love.graphics.setBackgroundColor(127,127,0,255)
	love.graphics.clear()
	love.graphics.setCanvas()
	self.diffuseShader = love.graphics.newShader(shaders.fragment.ink_diffuse)
	self.diffuseShader:send('width',self.w)
	self.diffuseShader:send('height',self.h)
	self.diff = 10

	self.advectShader = love.graphics.newShader(shaders.fragment.ink_advect)
	self.advectShader:send('width',self.w)
	self.advectShader:send('height',self.h)

	self.intensityShader = love.graphics.newShader(shaders.fragment.intensity_alpha)
end

function InkEffect:exchangeCanvas()
	self.canvas, self.canvas2 = self.canvas2, self.canvas
end

function InkEffect:exchangeVField()
	self.vField, self.vField2 = self.vField2, self.vField
end

function InkEffect:update(dt,r)
	if love.keyboard.isDown'd' then
		self.diff = self.diff + dt * 10
		elseif love.keyboard.isDown'a' then
			self.diff = self.diff - dt * 10
		end
	self.diffuseShader:send('diff', self.diff * dt)
	
	love.graphics.setCanvas(self.vField2)
	love.graphics.setShader(self.diffuseShader)
	love.graphics.draw(self.vField)
	love.graphics.setShader()
	if love.mouse.isDown'l' then
		local x,y = getMouseVelocity()
		if not (x == 127 and y == 127) then
			x,y = -x * 5, y * 5
			x,y = x + 127, y + 127
			if x < 0 then x = 0 end
			if y < 0 then y = 0 end
			if x > 255 then x = 255 end
			if y > 255 then y = 255 end
			love.graphics.setColor(x,y,0,255)
			x,y = love.mouse.getPosition()
			--love.graphics.circle('fill',x - r.x, y - r.y,32)
			love.graphics.draw(circle,x - r.x, y - r.y, 0, 3, nil, 32, 32)
			love.graphics.setColor(255,255,255,255)
		end
	end
	love.graphics.setCanvas()
	self:exchangeVField()

	love.graphics.setCanvas(self.canvas2)
	love.graphics.setShader(self.advectShader)
	self.advectShader:send('diff', self.diff * dt * 10)
	self.advectShader:send('velocityField', self.vField)
	love.graphics.draw(self.canvas)
	love.graphics.setShader()
	if love.mouse.isDown'r' then
		local x,y = love.mouse.getPosition()
		love.graphics.setColor(255,255,255,255)
		love.graphics.draw(circle,x - r.x, y - r.y, 0, 1, nil, 32, 32)	
	end
	love.graphics.setCanvas()
	self:exchangeCanvas()

	love.graphics.setCanvas(self.canvas2)
	love.graphics.setShader(self.diffuseShader)
	love.graphics.draw(self.canvas)
	love.graphics.setShader()
	love.graphics.setCanvas()
	self:exchangeCanvas()
end

function InkEffect:draw()
	love.graphics.setColor(255,255,255)
	love.graphics.draw(sky,0,0,0,.5)
	love.graphics.push()
	love.graphics.setShader(self.intensityShader)
	love.graphics.draw(self.canvas)
	love.graphics.setShader()
	love.graphics.print('This is a reference text',10,10)
	love.graphics.pop()
end

return example