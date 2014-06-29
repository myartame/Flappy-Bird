local physics = require "physics"

physics.start()
--physics.setDrawMode("hybrid")
physics.setGravity(0, 22)

local bg = display.newImageRect("bg.png", 320, 512)
bg.x = display.contentWidth / 2; bg.y = display.contentHeight / 2
local floor = display.newImageRect("floor.png", 320, 112)
floor.x = display.contentWidth / 2; floor.y = display.contentHeight - floor.height / 2
local ready = display.newImage("ready.png")
ready.x = display.contentWidth / 2; ready.y = display.contentHeight / 2
local bird = display.newSprite(graphics.newImageSheet("bird.png", { width = 102 / 3, height = 24, numFrames = 3 }), 
	{ start = 1, count = 3, time = 300 })
bird.x = 110; bird.y = display.contentHeight / 2
bird:play()
bird.postCollision = function(self, event)
	physics.stop()
	native.showAlert("Game End", "리로드 만들기 귀찮다 하하", { "OK" })
end
bird:addEventListener("postCollision", bird)

Runtime:addEventListener("tap", function(event) 
	if ready ~= nil then
		ready:removeSelf(); ready = nil;
		start()
	else
		bird.bodyType = "static"
		transition.to(bird, { time = 300, rotation = -30, y = bird.y - 40, onComplete = function() bird.bodyType = "dynamic" end })
	end
end)

local pipe_table = {}
local function createPipe()
	local hole = math.random(200, 280)
	local up_pipe = display.newImage("pipe_up.png")
	up_pipe.x = display.contentWidth + up_pipe.width / 2; up_pipe.y = hole + up_pipe.height / 2 + 20
	local down_pipe = display.newImage("pipe_down.png")
	down_pipe.x = display.contentWidth + down_pipe.width / 2; down_pipe.y = hole - down_pipe.height / 2 - 80
	physics.addBody(up_pipe, "static")
	physics.addBody(down_pipe, "static")
	transition.to(up_pipe, { time = 3000, x = -up_pipe.width / 2 })
	transition.to(down_pipe, { time = 3000, x = -down_pipe.width / 2 })
	table.insert(pipe_table, up_pipe)
	floor:toFront()
end

local point = 0
local point_img = display.newImage("0.png")
point_img.x = display.contentWidth / 2; point_img.y = 100

function start()
	physics.addBody(bird, "static")
	timer.performWithDelay(2000, createPipe, 0)

	Runtime:addEventListener("enterFrame", function(event)
		for i,v in pairs(pipe_table) do
			if v.x - 10 <= bird.x then
				point = point + 1;
				point_img:removeSelf(); point_img = nil;
				point_img = display.newImage(point .. ".png")
				point_img.x = display.contentWidth / 2; point_img.y = 100
				table.remove(pipe_table, i)
			end
		end

		if bird.bodyType == "dynamic" then
			if bird.rotation < 90 then bird.rotation = bird.rotation + 5 end
			else bird.rotation = 90 
		end
	end)
end