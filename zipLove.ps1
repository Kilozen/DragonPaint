# Script (powershell) to package DragonPaint files as a .love file 

# 9/5/22 - update to include ColorListSelector library. 
# 9/7/22 - fix lack of subfolders.  just COPY all the files I need, then zip there, then delete. 

write-host "`n"

# create (temporary) release folders:
New-Item -Path '.\tmp_Delete\DragonPaint' -ItemType Directory 
New-Item -Path '.\tmp_Delete\DragonPaint\lib' -ItemType Directory 
New-Item -Path '.\tmp_Delete\DragonPaint\lib\ColorListSelector' -ItemType Directory 

write-host "`n"

# --------------------------------------------------------------------- 
# Copy all the files needed for build, into their proper subfolders 

$copies = @{
    LiteralPath  = ".\main.lua", ".\DragonPaint.lua", ".\conf.lua", ".\ColorListConfig.lua"
    Destination  = ".\tmp_Delete\DragonPaint\"
}
#Copy-Item -WhatIf @copies   # show Test output ('WhatIf')
Copy-Item @copies 


$copies = @{
    LiteralPath  = ".\images\"
    Destination  = ".\tmp_Delete\DragonPaint\"
}
#Copy-Item -WhatIf @copies -Recurse
Copy-Item @copies -Recurse  # have to use -Recurse, or it won't inclue the files... 


$copies = @{
    LiteralPath  = ".\lib\strict.lua" 
    Destination  = ".\tmp_Delete\DragonPaint\lib\"
}
#Copy-Item -WhatIf @copies 
Copy-Item @copies 


$copies = @{
    LiteralPath  = ".\lib\ColorListSelector\ColorListSelector.lua", ".\lib\ColorListSelector\ColorListConfig.lua" 
    Destination  = ".\tmp_Delete\DragonPaint\lib\ColorListSelector\"
}
#Copy-Item -WhatIf @copies 
Copy-Item @copies 

write-host "`n"


# --------------------------------------------------------------------- 
# .zip all necessary project files together: 
# old: Compress-Archive -LiteralPath .\main.lua, .\DragonPaint.lua, .\conf.lua, .\strict.lua, .\images -CompressionLevel Optimal -DestinationPath .\DragonPaint.zip 
#
# multi-line style (more readable)
$compress = @{
    #LiteralPath = ".\tmp_Delete\DragonPaint\" # (no.. don't use 2 subfolders deep.) 
    Path = ".\tmp_Delete\DragonPaint\*"
    CompressionLevel = "Optimal"
    DestinationPath  = ".\DragonPaint.zip"
}
Compress-Archive -WhatIf @compress  # show Test output ('WhatIf')
Compress-Archive @compress 


# vv OLD vv 
# The single 'path' string below no longer works after library subdirectories were added; 
# it moves all the subdir files to the Root level... duh! 
$compress = @{
    LiteralPath      = ".\main.lua", ".\DragonPaint.lua", ".\conf.lua", ".\images", ".\lib\strict.lua", 
    ".\lib\ColorListSelector\ColorListSelector.lua", ".\lib\ColorListSelector\ColorListConfig.lua", ".\ColorListConfig.lua"
    CompressionLevel = "Optimal"
    DestinationPath  = ".\DragonPaint.zip"
}
#Compress-Archive -WhatIf @compress  # show Test output ('WhatIf')
#Compress-Archive @compress 
# ^^ OLD ^^ 

write-host "`n" 


# --------------------------------------------------------------------- 
# Rename .zip to .love 
Rename-Item -WhatIf -Path .\DragonPaint.zip -NewName .\DragonPaint.love   # show Test output  
Rename-Item -Path .\DragonPaint.zip -NewName .\DragonPaint.love


write-host "`n" 

# delete tmp folder:  '.\tmp_Delete\' 
Remove-Item '.\tmp_Delete' -Recurse   # (use -Recurse if you Don't want to be prompted for confirmation)
#Remove-Item '.\tmp_Delete'
