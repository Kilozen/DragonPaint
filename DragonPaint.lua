local thisFile = "DragonPaint.lua"
local gameTitle = "DragonPaint"
local dpVersion = "0.07"
local dpVdate = "8/1/22"
print("[" .. thisFile .. "] version " .. dpVersion .. "\n")

local strict = require "lib.strict"
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
- change 'none' to '[smooth] plastic'
- add an 'exit' button? 
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

    -- having an indexed table makes random picking easier than elseifs
    local materials = { 'none', 'glass', 'sand' }

    local matfile = {}
    matfile.none = {}
    matfile.glass = {}
    matfile.sand = {}

    -- list of filenames makes it easy to add new material files
    matfile['none'].primary = "images/transparentPixel.png"
    matfile['none'].secondary = "images/transparentPixel.png"
    matfile['none'].tertiary = "images/transparentPixel.png"

    matfile['glass'].primary = "images/simpleAgricosPrimaryGlass.png"
    matfile['glass'].secondary = "images/simpleAgricosSecondaryGlass.png"
    matfile['glass'].tertiary = "images/simpleAgricosTertiaryGlass.png"

    matfile['sand'].primary = "images/simpleAgricosPrimarySand.png"
    matfile['sand'].secondary = "images/simpleAgricosSecondarySand.png"
    matfile['sand'].tertiary = "images/simpleAgricosTertiarySand.png"


    -- pick materials with random()
    local matPick = materials[math.random(#materials)]
    --print(matPick)
    --print(matfile[matPick].primary)
    DraImgList.primary.matImage = lg.newImage(matfile[matPick].primary)

    matPick = materials[math.random(#materials)]
    --print(matfile[matPick].secondary)
    DraImgList.secondary.matImage = lg.newImage(matfile[matPick].secondary)

    matPick = materials[math.random(#materials)]
    --print(matfile[matPick].tertiary)
    DraImgList.tertiary.matImage = lg.newImage(matfile[matPick].tertiary)
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

    -- color won't matter for the Outline, because it's black, but
    -- just in case anything in the outline image is filled white (e.g. eyes)
    -- the color for the "outline" image should be set to white.
    rColorT = { 1, 1, 1 }
    DraImgList.outlines = { image = lg.newImage(imfile.outlines), color = rColorT } -- kmk: move this color set to where the others are
    DraImgList.primary = { image = lg.newImage(imfile.primary) } -- (have to use ~constructor syntax for first assignment)
    DraImgList.secondary = { image = lg.newImage(imfile.secondary) }
    DraImgList.tertiary = { image = lg.newImage(imfile.tertiary) }

    colorDragonImageList()
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

    love.window.setTitle(gameTitle .. "  v" .. dpVersion .. "-" .. verMinutes)
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
        -- lg.print(verMinutes .. " minutes", 20, 60)
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


    -- Draw the Dragon parts (in colors)
    lg.setColor(unpack(DraImgList.outlines.color))
    lg.draw(DraImgList.outlines.image, xloc, yloc, 0, xscale, yscale)

    lg.setColor(unpack(DraImgList.primary.color))
    lg.draw(DraImgList.primary.image, xloc, yloc, 0, xscale, yscale)

    lg.setColor(unpack(DraImgList.secondary.color))
    lg.draw(DraImgList.secondary.image, xloc, yloc, 0, xscale, yscale)

    lg.setColor(unpack(DraImgList.tertiary.color))
    lg.draw(DraImgList.tertiary.image, xloc, yloc, 0, xscale, yscale)


    -- draw the Material types (textures)
    --lg.setColor(0, 0, 0) -- (if you wanted "all black" textures)
    local matAlpha = 0.6 -- a value of 0.6 or so lets the underneath show through.
    lg.setColor(1, 1, 1, matAlpha) -- setting to White means the textures will show in their source-file colors.
    lg.draw(DraImgList.primary.matImage, xloc, yloc, 0, xscale, yscale)
    lg.draw(DraImgList.secondary.matImage, xloc, yloc, 0, xscale, yscale)
    lg.draw(DraImgList.tertiary.matImage, xloc, yloc, 0, xscale, yscale)
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


-- kmk instead, should this just use mousetouched(istouch) mousereleased(istouch)?
function love.touchpressed(id, x, y, dx, dy, pressure)
    colorDragonImageList()
    materialDragonImageList()
end


function love.mousereleased(x, y, button, istouch, presses)
    print("mouse at " .. x, y)

    colorDragonImageList()
    materialDragonImageList()
end


--
--print("\n\n"); error("dke ----- BEAKPOINT -----") -- *********** BREAKPOINT **********
