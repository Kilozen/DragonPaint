local thisFile = "DragonPaint.lua"
local dpVersion = "0.01"
local dpVdate = "6/24/22"
print("[" .. thisFile .. "] version " .. dpVersion .. "\n")

--local strict = require "C:/Program Files/lua54/k_libraries/strict"
local strict = require "strict"
--local version = strict.version

--[[ Design Notes ------------------------------------
This program requires the Love2D framework.

let the drImages be Global...

--UI--
[space] to change color
[esc] to exit

[] Eva Task:
make the program screen look nicer.
find links to L2D documentation (& keep your own notes)
in the UI.lua module...
make a Screen Title:
to start, probably just use  love.graphics.print()
then make a bigger font, add colors.. whatever
maybe? figure out how to load fancier fonts?
(maybe make some border art etc?  fancier background? gradient?)

------------------------------------------------------
other stuff:

maybe "animate" the image a bit? move,rotate,shear? tween? blink?
alternate 2 'idle' images? (steady breathing, or occational look/blink?)

fade to new colors more slowly?
--]] -------------------------------------------------

-- a global table with some namespace protection
-- all true globals (accessible outside this file) go inside here:
ekGlobals = {
    myGlobal1 = "ek's global one",
    myGlobal2 = "ek's global two"
}

local localGlobal = "global ONLY within this file"

local DrImgList = {} -- locally "global" table of dragon image info



local function getRandomColor() -- returns a color as a Table

    -- math.random(lower, upper) generates integer numbers between lower and upper (both inclusive).
    local rb = math.random(0, 255)
    local gb = math.random(0, 255)
    local bb = math.random(0, 255)
    local ab = 255
    print("rgb color = ", rb, gb, bb)

    local colorT = { love.math.colorFromBytes(rb, gb, bb, ab) }  -- pack into a Table...
    -- print("color = ", unpack(color))
    -- NOTE: Love2D/LuaJIT/Lua5.1 does not appear to have table.unpack()... it just has "unpack()"

    return colorT
end

local function setRandomColor()

    local rColor = getRandomColor()
    love.graphics.setColor(rColor)
end



local function loadDragonImageList() -- store image regions & colors

    local drImage = nil
    local rColorT = {}

    drImage = love.graphics.newImage("images/dragontestLines.png")
    -- color won't matter for the Outline, because it's black, but
    -- just in case anything in the outline image is filled white (e.g. eyes)
    -- the color for the "outline" image should be set to white.
    rColorT = {1,1,1}
    DrImgList[#DrImgList + 1] = { image = drImage, color = rColorT }

    drImage = love.graphics.newImage("images/dragontestPrimary.png")
    rColorT = getRandomColor()
    DrImgList[#DrImgList + 1] = { image = drImage, color = rColorT }

    drImage = love.graphics.newImage("images/dragontestSecondary.png")
    rColorT = getRandomColor()
    DrImgList[#DrImgList + 1] = { image = drImage, color = rColorT }


    drImage = love.graphics.newImage("images/dragontestTertiary.png")
    --local width = drImage:getWidth()
    --local height = drImage:getHeight()
    --print("width, height: ", width, height)
    rColorT = getRandomColor()
    --print("rColorT =", rColorT)
    --print("rColorT = ", unpack(rColorT))
    DrImgList[#DrImgList + 1] = { image = drImage, color = rColorT }

end


function love.load()
    math.randomseed(os.time()) -- (lua5.1 always returns nil)

    love.graphics.setBackgroundColor(1,1,1)
    love.graphics.setColor(0,0,0)

    loadDragonImageList()
end

function love.update(dt)

end

function love.draw()

    love.graphics.setColor( unpack(DrImgList[1].color) )
    love.graphics.draw(DrImgList[1].image, 100, 100, 0, 0.5, 0.5)

    love.graphics.setColor( unpack(DrImgList[2].color) )
    love.graphics.draw(DrImgList[2].image, 100, 100, 0, 0.5, 0.5)

    love.graphics.setColor( unpack(DrImgList[3].color) )
    love.graphics.draw(DrImgList[3].image, 100, 100, 0, 0.5, 0.5)

    love.graphics.setColor( unpack(DrImgList[4].color) )
    love.graphics.draw(DrImgList[4].image, 100, 100, 0, 0.5, 0.5)

end


function love.keypressed(key)

    if key == "space" then
        love.event.quit()
    end

    if key == "escape" then
        love.event.quit()
    end
end

--print("\n\n"); error("dke ----- BEAKPOINT -----") -- *********** BREAKPOINT **********

