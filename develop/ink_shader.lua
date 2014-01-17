local example = {}
example.title = "Ink Shader"
example.category = "Unit development"

local InkShader = {
	w = 300,
	h = 300
}

function example.func(demo)
	
	local frame = loveframes.Create("frame")
	frame:SetName("Scene")
	frame:CenterWithinArea(unpack(demo.centerarea))
	frame:SetSize(600,400)
		
	local scene = loveframes.Create("scene_renderer", frame)
	scene:SetSize(frame.width,frame.height - 25)
	scene:SetPos(0,25)

	local s = Scene()
	scene:SetScene(InkShader)

	InkShader.load()
end

function imd(array,x,y,d)
	if d then
		if d ~= 0 then
			array[y * InkShader.h + x] = d
		end
	else
		return array[y * InkShader.h + x] or 0
	end
end



function InkShader.load()
	InkShader.x = {}
	InkShader.x0 = {}
	InkShader.n = {}
	InkShader.u = {}
	InkShader.v = {}
	InkShader.u0 = {}
	InkShader.v0 = {}
	InkShader.wasDown = false
	for i=20,50 do
		for j=20,50 do
			imd(InkShader.x, i,j,255)
		end
	end
	for i=1,300 do
		for j=1,300 do
			imd(InkShader.u, i,j,0.05*math.random(-1,1))
			imd(InkShader.v, i,j,0.05*math.random(-1,1))
		end
	end
end

function InkShader:update(dt,r)
	local x,y = love.mouse.getPosition()
	x,y = x - r.x - 150, y - r.y
	if love.mouse.isDown'l' then
		if not InkShader.wasDown then
			InkShader.wasDown = true
			InkShader.m_x,InkShader.m_y = x,y
		end
		local vx, vy = x - InkShader.m_x,y - InkShader.m_y
			InkShader.m_x,InkShader.m_y = x,y
		print (vx,vy)
		for i=x-20,x+20 do
			for j=y-20,y+20 do
				imd(InkShader.x, i,j,255)
				imd(InkShader.u, i,j,vx*0.01)
				imd(InkShader.v, i,j,vy*0.01)
			end
		end
	end

	local iter = 5

	local function addSource(n, x, s)
		local size = (n+2)*(n+2)
		for i=1,size do
			x[i] = x[i] or 0 + dt * (s[i] or 0)
		end
	end

	local function diffuse(n, b, x, x0, diff, dt)
		local i,j,k
		local a = dt * diff * n * n
		for k=1,iter do
			for i=2,n do
				for j=2,n do
					local d = (imd(x0,i,j) + a * (imd(x,i-1,j) + imd(x,i+1,j)
						+ imd(x,i,j-1) + imd(x,i,j+1)))/(1+4*a)
					imd(x, i, j, d)
				end
			end
		end
	end

	local function advect(n, b, d, d0, u, v, dt)
		local i, j, i0, j0, i1, j1
		local x, y, s0, t0, s1, t1, dt0

		local dt0 = dt * n
		for i=2,n do
			for j=2,n do
				x = i - dt0 * imd(u,i,j)
				y = j - dt0 * imd(v,i,j)
				if x<0.5 then x = 0.5 end
				if x>n+0.5 then x = n + 0.5 end
				i0 = math.floor(x)
				i1 = i0+1
				if y<0.5 then y = 0.5 end
				if y>n+0.5 then y = n + 0.5 end
				j0 = math.floor(y)
				j1 = j0+1
				s1 = x-i0
				s0 = 1-s1
				t1 = y-j0
				t0 = 1-t1
				imd(d,i,j,s0*(t0*imd(d0,i0,j0) + t1*imd(d0,i0,j1)) +
					s1*(t0*imd(d0,i1,j0) + t1*imd(d0,i1,j1)))
			end
		end
	end

	local function project(n, u, v, p , div)
		local i,j,k,h
		h = 1
		for i=2,n do
			for j=2,n do
				local d = -0.5*h*(imd(u,i+1,j)-imd(u,i-1,j)+imd(v,i,j+1)-imd(v,i,j-1))
				imd(div,i,j,d)
			end
		end
		for k=1,iter do
			for i=2,n do
				for j=2,n do
					local d = imd(div,i,j)+imd(p,i-1,j)+imd(p,i+1,j)+imd(p,i,j-1)+imd(p,i,j+1)
					imd(p,i,j,d/4)
				end
			end
		end
		for i=2,n do
			for j=2,n do
				local d = 0.5*(imd(p,i+1,j)-imd(p,i-1,j))/h
				imd(u,i,j,imd(u,i,j)-d)
				local e = 0.5*(imd(p,i,j+1)-imd(p,i,j-1))/h
				imd(v,i,j,imd(u,i,j)-e)
			end
		end
	end
	local n = InkShader.w - 2

	InkShader.u, InkShader.u0 = InkShader.u0, InkShader.u
	diffuse(n, nil, InkShader.u, InkShader.u0, 0.0001, dt)
	InkShader.v, InkShader.v0 = InkShader.v0, InkShader.v
	diffuse(n, nil, InkShader.v, InkShader.v0, 0.0001, dt)
	
	project(n, InkShader.u, InkShader.v, InkShader.u0, InkShader.v0)
	InkShader.u, InkShader.u0 = InkShader.u0, InkShader.u
	InkShader.v, InkShader.v0 = InkShader.v0, InkShader.v
	advect(n, nil, InkShader.u, InkShader.u0, InkShader.u, InkShader.v, dt)
	advect(n, nil, InkShader.v, InkShader.v0, InkShader.u, InkShader.v, dt)
	project(n, InkShader.u, InkShader.v, InkShader.u0, InkShader.v0)


	InkShader.x, InkShader.x0 = InkShader.x0, InkShader.x
	diffuse(n, nil, InkShader.x, InkShader.x0, 0.001, dt)
	InkShader.x, InkShader.x0 = InkShader.x0, InkShader.x
	advect(n, nil, InkShader.x, InkShader.x0, InkShader.u, InkShader.v, dt)
end

function InkShader:draw()
	for i=2,InkShader.w do
		for j=2,InkShader.h do
			local c = imd(InkShader.x,i,j)
			love.graphics.setColor(255,255,255,math.min(255,c))
			love.graphics.point(i,j)
		end
	end
end

return example