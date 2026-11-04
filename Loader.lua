local BASE_URL =
"https://raw.githubusercontent.com/vhminzboy-star/KENOX-BASE/main/Base.lua"

local source = game:HttpGet(BASE_URL)
local Base = loadstring(source)()

return Base
