local CollisionCategory = {player = 1, enemy = 2, playerBullet = 3, enemyBullet = 4, 
obstacle = 5, obstacleLow = 6, item = 7}

local CollisionMasks = {}

local function buildCollisionMask(a,b)
	local m1 = CollisionCategory[a]
	local m2 = CollisionCategory[b]
	CollisionMasks[a] = CollisionMasks[a] or {}
	CollisionMasks[b] = CollisionMasks[b] or {}
	if a ~= b then
		table.insert(CollisionMasks[a],m2)
	end
	table.insert(CollisionMasks[b],m1)
end

buildCollisionMask("player","player")
buildCollisionMask("enemy","enemy")
buildCollisionMask("player","playerBullet")
buildCollisionMask("enemy","enemyBullet")
buildCollisionMask("obstacleLow","playerBullet")
buildCollisionMask("obstacleLow","enemyBullet")
buildCollisionMask("obstacle","obstacle")
buildCollisionMask("playerBullet","playerBullet")
buildCollisionMask("enemyBullet","enemyBullet")

function initializeCollisionMasksForFixture(fixture,category)
	fixture:setCategory(CollisionCategory[category])
	assert(CollisionMasks[category], string.format("%s does not have a collision category", category))
	fixture:setMask(unpack(CollisionMasks[category]))
end

function setAllMasks(fixture)
	fixture:setMask(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16)
end