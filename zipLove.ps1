# Script (powershell) to package DragonPaint files: 

write-host "`n"
# how Test output ('WhatIf')
#Compress-Archive -WhatIf -LiteralPath .\main.lua, .\DragonPaint.lua, .\conf.lua, .\strict.lua, .\images -CompressionLevel Optimal -DestinationPath .\DragonPaint.zip 

# .zip all necessary project files together: 
#Compress-Archive -LiteralPath .\main.lua, .\DragonPaint.lua, .\conf.lua, .\strict.lua, .\images -CompressionLevel Optimal -DestinationPath .\DragonPaint.zip 

# multi-line style (more readable)
$compress = @{
    LiteralPath      = ".\main.lua", ".\DragonPaint.lua", ".\conf.lua", ".\strict.lua", ".\images"
    CompressionLevel = "Optimal"
    DestinationPath  = ".\DragonPaint.zip"
}
Compress-Archive -WhatIf @compress 
Compress-Archive @compress 



write-host "`n" 
# show Test output  
Rename-Item -WhatIf -Path .\DragonPaint.zip -NewName .\DragonPaint.love
# Rename .zip to .love 
Rename-Item -Path .\DragonPaint.zip -NewName .\DragonPaint.love

