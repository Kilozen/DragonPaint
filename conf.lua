-- conf.lua -- Love2d Configuration File

function love.conf(t)
	t.console = true
	--t.version = "11.4"  -- This creates a warning when run with other versions.

	t.window.title = "DragonPaint"
	t.window.icon = "images/DragonPaint_icon.png"

	local scale = 1  -- normally '1' 
	t.window.width = 640 * scale  -- use multiples of 640x360 for mobile dimensions. 
	t.window.height = 360 * scale
	--t.window = nil -- defer window creation until window.setMode is called
end
