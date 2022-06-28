-- "main.lua" for Love2D 
local thisFile = "main.lua"
print("["..thisFile.."] loaded/running.")


--local mainFile = "learn5/learn5a"  --(path-like syntax)
--local mainFile = "learn7.learn7"  --(preferred syntax for modules)
local mainFile = "DragonPaint"

print("[main.lua] loading "..mainFile..".lua\n")
require(mainFile) -- load the file with the main Love2D Callbacks. 

