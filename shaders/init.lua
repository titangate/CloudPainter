return {
	fragment = {
		ink_diffuse = love.filesystem.read("shaders/ink_diffuse.frag"),
		ink_advect = love.filesystem.read("shaders/ink_advect.frag"),
		intensity_alpha = love.filesystem.read("shaders/intensity_alpha.frag"),
	}
}