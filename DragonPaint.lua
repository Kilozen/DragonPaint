local thisFile = "DragonPaint.lua"
local gameTitle = "DragonPaint"
local dpVersion = "0.06 (in progress)"
local dpVdate = "7/28/22"
print("[" .. thisFile .. "] version " .. dpVersion .. "\n")

--local strict = require "C:/Program Files/lua54/k_libraries/strict"
--print(strict.version)
local strict = require "strict"

local lg = love.graphics -- handy abbreviation
--local gameFont = 0 -- (declare as file-local, but can't set until window is created)

--[[ Design Notes ------------------------------------
This program requires the Love2D framework. 
(See the GitHub Wiki for more info.)

! Remember to run Auto-Format before major checkins (or right after), so random diffs don't appear. 

Let the DraImgList be Global. 

TODO: 
- add click/touch for mobile devices 
- scale the screen to fit mobile (it did show as landscape by default.. I'm not sure why)
- scale the window so the *height* matches the narrow dimension 
  (up to some max... keep it windowed on PCs) and scale the width proportionaly
  center it on the screen (black bars on phone edges?)
- add an 'exit' button? 

- setup 'adb' for fast transfer of test files to the phone... 

- have a lightly textured backgroud, always moving (clouds?)

- make a "credits" page.. spash screen or exit screen saying who the devs/owners 
are and what the "official" source site is.  (because games can be copied around 
and leave no trace of their origin.. other than their name.)
--]] -------------------------------------------------


-- dragon image info
local DraImgList = {} -- a table of 4 body regions: {region image,  color}


local function getRandomColor() -- returns a color as a Table

    -- math.random(lower, upper) generates integer numbers between lower and upper (both inclusive).
    local rb = math.random(0, 255)
    local gb = math.random(0, 255)
    local bb = math.random(0, 255)
    local ab = 255
    print("rgb color = ", rb, gb, bb)

    local colorT = { love.math.colorFromBytes(rb, gb, bb, ab) } -- pack into a Table...
    -- print("color = ", unpack(color))
    -- NOTE: Love2D/LuaJIT/Lua5.1 does not appear to have table.unpack()... it just has "unpack()"

    return colorT
end

local function loadDragonImageList() -- store image regions, materials, & colors

    local drImage = nil -- dragon Image var
    local rColorT = {} -- table to hold 3 parts of an RGB color

    -- [] maybe make a "config file" of available images?
    local imfile_old = {
        outlines  = "images/dragontestLines.png",
        primary   = "images/dragontestPrimary.png",
        secondary = "images/dragontestSecondary.png",
        tertiary  = "images/dragontestTertiary.png"
    }

    local imfile = {
        outlines  = "images/simpleAgricosLines.png",
        primary   = "images/simpleAgricosPrimary.png",
        secondary = "images/simpleAgricosSecondary.png",
        tertiary  = "images/simpleAgricosTertiary.png",
    }



    local primMatPick = math.random(2)
    if primMatPick == 1 then
        primaryMat = "images/simpleAgricosPrimaryGlass.png"
    else
        primaryMat = "images/simpleAgricosPrimarySand.png"
    end


    local secMatPick = math.random(2)
    if secMatPick == 1 then
        secondaryMat = "images/simpleAgricosSecondaryGlass.png"
    else
        secondaryMat = "images/simpleAgricosSecondarySand.png"
    end


    local tertMatPick = math.random(2)
    if tertMatPick == 1 then
        tertiaryMat = "images/simpleAgricosTertiaryGlass.png"
    else
        tertiaryMat = "images/simpleAgricosTertiarySand.png"
    end





    --[[  Not in use atm

    local matfile = {
        primaryGlass = "images/simpleAgricosPrimaryGlass.png",
        secondaryGlass = "images/simpleAgricosSecondaryGlass.png",
        tertiaryGlass = "images/simpleAgricosTertiaryGlass.png",
        primarySand = "images/simpleAgricosPrimarySand.png",
        secondarySand = "images/simpleAgricosSecondarySand.png",
        tertiarySand = "images/simpleAgricosTertiarySand.png"
    }
--]]

    drImage = love.graphics.newImage(imfile.outlines)
    --drImage = love.graphics.newImage("images/dragontestLines.png")
    -- color won't matter for the Outline, because it's black, but
    -- just in case anything in the outline image is filled white (e.g. eyes)
    -- the color for the "outline" image should be set to white.
    rColorT = { 1, 1, 1 }
    DraImgList.outlines = { image = drImage, color = rColorT }

    drImage = love.graphics.newImage(imfile.primary)
    rColorT = getRandomColor()
    DraImgList.primary = { image = drImage, color = rColorT }

    drImage = love.graphics.newImage(imfile.secondary)
    rColorT = getRandomColor()
    DraImgList.secondary = { image = drImage, color = rColorT }


    drImage = love.graphics.newImage(imfile.tertiary)
    --local width = drImage:getWidth()
    --local height = drImage:getHeight()
    --print("width, height: ", width, height)
    rColorT = getRandomColor()
    --print("rColorT =", rColorT)
    --print("rColorT = ", unpack(rColorT))
    DraImgList.tertiary = { image = drImage, color = rColorT }




    --start material pick


    drImage = love.graphics.newImage(primaryMat)
    rColorT = { 1, 1, 1 }
    DraImgList.primaryMat = { image = drImage, color = rColorT }

    drImage = love.graphics.newImage(secondaryMat)
    rColorT = { 1, 1, 1 }
    DraImgList.secondaryMat = { image = drImage, color = rColorT }

    drImage = love.graphics.newImage(tertiaryMat)
    rColorT = { 1, 1, 1 }
    DraImgList.tertiaryMat = { image = drImage, color = rColorT }

end

local function reColorDragonImageList()
    print ""
    DraImgList.primary.color = getRandomColor()
    DraImgList.secondary.color = getRandomColor()
    DraImgList.tertiary.color = getRandomColor()


    local primMatPick = math.random(2)
    if primMatPick == 1 then
        drImage = love.graphics.newImage("images/simpleAgricosPrimaryGlass.png")
    else
        drImage = love.graphics.newImage("images/simpleAgricosPrimarySand.png")
    end
    DraImgList.primaryMat.image = drImage


    local secMatPick = math.random(2)
    if secMatPick == 1 then
        drImage = love.graphics.newImage("images/simpleAgricosSecondaryGlass.png")
    else
        drImage = love.graphics.newImage("images/simpleAgricosSecondarySand.png")
    end
    DraImgList.secondaryMat.image = drImage


    local tertMatPick = math.random(2)
    if tertMatPick == 1 then
        drImage = love.graphics.newImage("images/simpleAgricosTertiaryGlass.png")
    else
        drImage = love.graphics.newImage("images/simpleAgricosTertiarySand.png")
    end
    DraImgList.tertiaryMat.image = drImage

end

function love.load() -- this is where Love2D does it's FIRST initialization.
    --love.window.setMode(640, 360, {resizable=true, minwidth=400, minheight=300} )
    --love.window.setMode(640*2, 360*2)
    --love.window.setMode(640, 360)  -- create game window if not already in conf.lua

    love.window.setTitle(gameTitle .. " " .. dpVersion)

    math.randomseed(os.time()) -- (lua5.1 always returns nil)

    gameFont = lg.newFont(20)
    love.graphics.setBackgroundColor(1, 1, 1)
    love.graphics.setColor(0, 0, 0)

    loadDragonImageList()

    -- TEMPORARY --
    print ""
    print("window width/2 = " .. math.floor(love.graphics.getWidth() / 2))
    print("window height/2 = " .. math.floor(love.graphics.getHeight() / 2))

    local img = DraImgList.outlines.image
    print("0.5 image width/2 = " .. math.floor(img:getWidth() / 2 * 0.5))
    print("0.5 image height/2 = " .. math.floor(img:getHeight() / 2 * 0.5))
    print ""
end

function love.update(dt) -- Love2D calls this 60 times per second.
    -- nothing needed here so far...
end

function love.draw() -- Love2D calls this 60 times per second.

    -- image placement, declare with default values, then recalculate below.
    local xloc = 10
    local yloc = 10

    local ww = love.graphics.getWidth() -- window width
    local wh = love.graphics.getHeight()
    local iw = DraImgList.outlines.image:getWidth() -- image width
    local ih = DraImgList.outlines.image:getHeight()

    -- how much the images need to be scaled
    local xscale = .3
    local yscale = .3


    -- Centering offset
    -- x-offset needed is the Window center minus the Image center.
    -- how far is the image center from the window center?
    -- draw it that far to the right...
    xloc = (ww / 2) - (math.floor(iw / 2 * xscale))
    yloc = (wh / 2) - (math.floor(ih / 2 * yscale))
    -- (the above could be calculated  once, then passed in)



    -- Draw the Dragon parts [IMPORTANT STEP]
    love.graphics.setColor(unpack(DraImgList.outlines.color))
    love.graphics.draw(DraImgList.outlines.image, xloc, yloc, 0, xscale, yscale)


    love.graphics.setColor(unpack(DraImgList.primary.color))
    love.graphics.draw(DraImgList.primary.image, xloc, yloc, 0, xscale, yscale)

    love.graphics.setColor(unpack(DraImgList.secondary.color))
    love.graphics.draw(DraImgList.secondary.image, xloc, yloc, 0, xscale, yscale)

    love.graphics.setColor(unpack(DraImgList.tertiary.color))
    love.graphics.draw(DraImgList.tertiary.image, xloc, yloc, 0, xscale, yscale)


    -- Materials (textures)
    love.graphics.setColor(unpack(DraImgList.primaryMat.color))
    love.graphics.draw(DraImgList.primaryMat.image, xloc, yloc, 0, xscale, yscale)

    love.graphics.setColor(unpack(DraImgList.secondaryMat.color))
    love.graphics.draw(DraImgList.secondaryMat.image, xloc, yloc, 0, xscale, yscale)

    love.graphics.setColor(unpack(DraImgList.tertiaryMat.color))
    love.graphics.draw(DraImgList.tertiaryMat.image, xloc, yloc, 0, xscale, yscale)

    love.graphics.setColor(0, .5, 1)
    love.graphics.setFont(gameFont)
    love.graphics.print("[Esc] to exit", 350, 10)
    love.graphics.print("[Space] to change colors", 350, 40)

end

function love.keypressed(key)

    if key == "space" then
        reColorDragonImageList()
    end

    if key == "escape" then
        love.event.quit()
    end
end

function love.touchpressed(id, x, y, dx, dy, pressure)
    reColorDragonImageList()
end

--
--print("\n\n"); error("dke ----- BEAKPOINT -----") -- *********** BREAKPOINT **********
