local thisFile = "DragonPaint.lua"
local gameTitle = "DragonPaint"
local dpVersion = "0.06 (in progress)"
local dpVdate = "7/28/22"
print("[" .. thisFile .. "] version " .. dpVersion .. "\n")

local strict = require "strict"
--print(strict.version)

local lg = love.graphics -- handy abbreviation

local mobile = false -- detect if running on an android phone

-- get timestamp of last save of thisFile (to use as a "minor version number")
local fileInfo = love.filesystem.getInfo(thisFile)
local verMinutes = math.floor((fileInfo.modtime - 1659000000) / 60)
print(thisFile .. " minutes since first version " .. verMinutes)
--(this is approximately the minutes since the first mobile version)


--[[ Design Notes ------------------------------------
This program requires the Love2D framework. 
(See the GitHub Wiki for more info.)

! Remember to run Auto-Format before major checkins (or right after), so random diffs don't appear. 

Let the DraImgList be Global. 

TODO: 

organize material types as: 
1, mat1
2, mat2
etc. so they can be randomized, 
then within each one: 
mat1.primary = file 
mat1.secondary = file 
etc... 
like: sand.primary = file 


[x] print a build timestamp or something randomly different each "build" to help show that a crossload did indeed get updated.
  (how can code read the timestamp of it's own save time?) 

- scale the window so the *height* matches the narrow dimension 
  (up to some max... keep it windowed on PCs) and scale the width proportionaly
  center it on the screen (black bars on phone edges?)
- add an 'exit' button? 

- clean up how materials are done (make an extendable list) & cleanup globals 

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



local function colorDragonImageList()
    print ""
    DraImgList.primary.color = getRandomColor()
    DraImgList.secondary.color = getRandomColor()
    DraImgList.tertiary.color = getRandomColor()
end


local function materialDragonImageList()
    print ""

    local primMatPick = math.random(2)
    if primMatPick == 1 then
        drImage = lg.newImage("images/simpleAgricosPrimaryGlass.png")
    else
        drImage = lg.newImage("images/simpleAgricosPrimarySand.png")
    end
    DraImgList.primaryMat.image = drImage


    local secMatPick = math.random(2)
    if secMatPick == 1 then
        drImage = lg.newImage("images/simpleAgricosSecondaryGlass.png")
    else
        drImage = lg.newImage("images/simpleAgricosSecondarySand.png")
    end
    DraImgList.secondaryMat.image = drImage


    local tertMatPick = math.random(2)
    if tertMatPick == 1 then
        drImage = lg.newImage("images/simpleAgricosTertiaryGlass.png")
    else
        drImage = lg.newImage("images/simpleAgricosTertiarySand.png")
    end
    DraImgList.tertiaryMat.image = drImage
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

    -- color won't matter for the Outline, because it's black, but
    -- just in case anything in the outline image is filled white (e.g. eyes)
    -- the color for the "outline" image should be set to white.
    rColorT = { 1, 1, 1 }
    DraImgList.outlines = { image = lg.newImage(imfile.outlines), color = rColorT } -- kmk: move this color set to where the others are
    DraImgList.primary = { image = lg.newImage(imfile.primary) } -- (have to use ~constructor syntax for first assignment) 
    DraImgList.secondary = { image = lg.newImage(imfile.secondary) }
    DraImgList.tertiary = { image = lg.newImage(imfile.tertiary) }

    colorDragonImageList()


    
    --start material pick
    rColorT = { 1, 1, 1 }

    drImage = lg.newImage(primaryMat)
    DraImgList.primaryMat = { image = drImage, color = rColorT }

    drImage = lg.newImage(secondaryMat)
    DraImgList.secondaryMat = { image = drImage, color = rColorT }

    drImage = lg.newImage(tertiaryMat)
    DraImgList.tertiaryMat = { image = drImage, color = rColorT }

    materialDragonImageList()
end



function love.load() -- this is where Love2D does it's FIRST initialization.
    --create game window if not already in conf.lua
    --love.window.setMode(640, 360, {resizable=true, minwidth=400, minheight=300} )

    if love.system.getOS() == "Android" then
        mobile = true
    else
        mobile = false
        love.window.setMode(640 * 2, 360 * 2, { resizable = true })
        -- (fix? to get rid of the blink & resize, could set window to nil in conf.lua and only create them here) 
    end

    love.window.setTitle(gameTitle .. " " .. dpVersion)
    --lg.setBackgroundColor(.7, .8, .9)  -- pale blue
    lg.setBackgroundColor(.9, .9, .8) -- pale tan 
    lg.setColor(0, 0, 0)

    math.randomseed(os.time()) -- (lua5.1 always returns nil)

    loadDragonImageList()

    -- TEMPORARY --
    print ""
    print("window width/2 = " .. math.floor(lg.getWidth() / 2))
    print("window height/2 = " .. math.floor(lg.getHeight() / 2))

    local img = DraImgList.outlines.image
    print("0.5 image width/2 = " .. math.floor(img:getWidth() / 2 * 0.5))
    print("0.5 image height/2 = " .. math.floor(img:getHeight() / 2 * 0.5))
    print ""
end

function love.update(dt) -- Love2D calls this 60 times per second.
    -- nothing needed here so far...
end



function love.draw() -- Love2D calls this 60 times per second.

    lg.setFont(lg.newFont(18))
    lg.setColor(0, .5, 1)

    if mobile then
        lg.print("Tap to change colors", 20, 35)
        lg.print(verMinutes .. " minutes", 20, 60)
    else
        lg.print("[Space] to change colors", 20, 10)
        lg.print("[Esc] to exit", 20, 35)
        lg.print(verMinutes .. " minutes", 20, 60)
    end

    -- image placement, declare with default values, then recalculate below.
    local xloc = 10
    local yloc = 10

    local ww = lg.getWidth() -- window width
    local wh = lg.getHeight()
    local iw = DraImgList.outlines.image:getWidth() -- image width
    local ih = DraImgList.outlines.image:getHeight()

    local wiRatio = wh / ih -- window to image ratio (scaling by 'height', the smaller dimension)

    -- how much the images need to be scaled
    local xscale = wiRatio
    local yscale = wiRatio -- just scale dimensions evenly.. no stretching

    -- Centering offset
    -- x-offset needed is the Window center minus the Image center.
    -- how far is the image center from the window center?
    -- draw it that far to the right...
    xloc = (ww / 2) - (math.floor(iw / 2 * xscale))
    yloc = (wh / 2) - (math.floor(ih / 2 * yscale))
    -- (the above could be calculated  once, then passed in)


    -- Draw the Dragon parts [IMPORTANT STEP]
    lg.setColor(unpack(DraImgList.outlines.color))
    lg.draw(DraImgList.outlines.image, xloc, yloc, 0, xscale, yscale)

    lg.setColor(unpack(DraImgList.primary.color))
    lg.draw(DraImgList.primary.image, xloc, yloc, 0, xscale, yscale)

    lg.setColor(unpack(DraImgList.secondary.color))
    lg.draw(DraImgList.secondary.image, xloc, yloc, 0, xscale, yscale)

    lg.setColor(unpack(DraImgList.tertiary.color))
    lg.draw(DraImgList.tertiary.image, xloc, yloc, 0, xscale, yscale)


    -- Materials (textures)
    --lg.setColor(0, 0, 0) -- (if you wanted "all black" textures)
    local matAlpha = 0.6 -- a value of 0.6 or so let's the underneath show through. 
    lg.setColor(1, 1, 1, matAlpha) -- setting to White means the textures will show in their source-file colors. 
    lg.draw(DraImgList.primaryMat.image, xloc, yloc, 0, xscale, yscale)
    lg.draw(DraImgList.secondaryMat.image, xloc, yloc, 0, xscale, yscale)
    lg.draw(DraImgList.tertiaryMat.image, xloc, yloc, 0, xscale, yscale)
end

function love.keypressed(key)

    if key == "space" then
        colorDragonImageList()
        materialDragonImageList()
    end

    if key == "escape" then
        love.event.quit()
    end
end

function love.touchpressed(id, x, y, dx, dy, pressure)
    colorDragonImageList()
    materialDragonImageList()
end

--
--print("\n\n"); error("dke ----- BEAKPOINT -----") -- *********** BREAKPOINT **********
