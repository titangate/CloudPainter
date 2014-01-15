local example = {}
example.title = "Scene Renderer"
example.category = "Integrated development"

function example.func(demo)
	
	local frame = loveframes.Create("frame")
	frame:SetName("Scene")
	frame:CenterWithinArea(unpack(demo.centerarea))
	frame:SetSize(600,400)
		
	local scene = loveframes.Create("scene_renderer", frame)
	scene:SetSize(frame.width,frame.height - 25)
	scene:SetPos(0,25)

	local s = Scene()
	scene:SetScene(s)

	example.loadScene(s)
end

function example.loadScene(s)
	local chr = s:addCharacter{x = 100, y = 100, radius = 16, collisionType = 'player'}
end

return example