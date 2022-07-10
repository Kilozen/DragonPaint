local thisFile = "DragonPaint.lua"
local gameTitle = "DragonPaint"
local dpVersion = "0.03 (in progress)"
local dpVdate = "7/10/22"
print("[" .. thisFile .. "] version " .. dpVersion .. "\n")

--local strict = require "C:/Program Files/lua54/k_libraries/strict"
--print(strict.version)
local strict = require "strict"


--[[ Design Notes ------------------------------------
This program requires the Love2D framework.

let the drImages be Global...

?create an option to "save" & replay favorites.
perhaps "rate" from 0 (ignored), 1 "good/interesting", to 2 "especially good/interesting"
save little thumbnail images w/codes?

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


-- dragon image info 
local DraImgList = {} -- a table of 4 regions: {region image,  color} 


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

-- old.. Deleteable? 
local function setRandomColor()

    local rColor = getRandomColor()
    love.graphics.setColor(rColor)
end



local function loadDragonImageList() -- store image regions & colors

    local drImage = nil  -- dragon Image var 
    local rColorT = {}   -- table to hold 3 parts of an RGB color 

    -- [] maybe make a "config file" of available images? 
    local imfile = {
        outlines  = "images/dragontestLines.png",
        primary   = "images/dragontestPrimary.png",
        secondary = "images/dragontestSecondary.png",
        tertiary  = "images/dragontestTertiary.png"
    }

    local imfile2 = {
        outlines  = "images/simpleAgricosLines.png",
        primary   = "images/simpleAgricosPrimary.png",
        secondary = "images/simpleAgricosSecondary.png",
        tertiary  = "images/simpleAgricosTertiary.png"
    }

    drImage = love.graphics.newImage(imfile.outlines)
    --drImage = love.graphics.newImage("images/dragontestLines.png")
    -- color won't matter for the Outline, because it's black, but
    -- just in case anything in the outline image is filled white (e.g. eyes)
    -- the color for the "outline" image should be set to white.
    rColorT = {1,1,1}
    DraImgList["outlines"] = { image = drImage, color = rColorT }

    drImage = love.graphics.newImage(imfile.primary)
    rColorT = getRandomColor()
    DraImgList["primary"] = { image = drImage, color = rColorT }

    drImage = love.graphics.newImage(imfile.secondary)
    rColorT = getRandomColor()
    DraImgList["secondary"] = { image = drImage, color = rColorT }


    drImage = love.graphics.newImage(imfile.tertiary)
    --local width = drImage:getWidth()
    --local height = drImage:getHeight()
    --print("width, height: ", width, height)
    rColorT = getRandomColor()
    --print("rColorT =", rColorT)
    --print("rColorT = ", unpack(rColorT))
    DraImgList["tertiary"] = { image = drImage, color = rColorT }

end

local function reColorDragonImageList()
    print ""
    DraImgList["primary"].color = getRandomColor()
    DraImgList["secondary"].color = getRandomColor()
    DraImgList["tertiary"].color = getRandomColor()
end


function love.load() -- this is where Love2D does it's FIRST initialization. 

    love.window.setTitle(gameTitle.." "..dpVersion)

    math.randomseed(os.time()) -- (lua5.1 always returns nil)

    love.graphics.setBackgroundColor(1,1,1)
    love.graphics.setColor(0,0,0)

    loadDragonImageList()

    -- TEMPORARY -- 
    print ""
    print("window width/2 = ".. math.floor(love.graphics.getWidth()/2) )
    print("window height/2 = ".. math.floor(love.graphics.getHeight()/2) )

    local img = DraImgList["outlines"].image
    print("0.5 image width/2 = ".. math.floor(img:getWidth()/2 *0.5) )
    print("0.5 image height/2 = ".. math.floor(img:getHeight()/2 *0.5) )
    print ""
end


function love.update(dt) -- Love2D calls this 60 times per second. 
    -- nothing needed here so far... 
end

function love.draw() -- Love2D calls this 60 times per second. 

    -- how much the images need to be scaled 
    local xscale = 0.5
    local yscale = 0.5

    -- image placement, declare with default values, then recalculate below. 
    local xloc = 40
    local yloc = 30

    -- how far is the image center from the window center? 
    -- draw it that far to the right... 
    local img = DraImgList["outlines"].image

    -- x-offset needed is the Window center minus the Image center. 
    xloc = (love.graphics.getWidth()/2)  - (math.floor(img:getWidth()/2 * xscale))
    yloc = (love.graphics.getHeight()/2) - (math.floor(img:getHeight()/2 * yscale))
    -- (the above could be calculated  once, then passed in)


    -- Draw the Dragon parts 
    love.graphics.setColor( unpack(DraImgList["outlines"].color) )
    love.graphics.draw(DraImgList["outlines"].image, xloc, yloc, 0, xscale, yscale)

    love.graphics.setColor( unpack(DraImgList["primary"].color) )
    love.graphics.draw(DraImgList["primary"].image, xloc, yloc, 0, xscale, yscale)

    love.graphics.setColor( unpack(DraImgList["secondary"].color) )
    love.graphics.draw(DraImgList["secondary"].image, xloc, yloc, 0, xscale, yscale)

    love.graphics.setColor( unpack(DraImgList["tertiary"].color) )
    love.graphics.draw(DraImgList["tertiary"].image, xloc, yloc, 0, xscale, yscale)

end


function love.keypressed(key)

    if key == "space" then
        reColorDragonImageList()
    end

    if key == "escape" then
        love.event.quit()
    end
end

--print("\n\n"); error("dke ----- BEAKPOINT -----") -- *********** BREAKPOINT **********

