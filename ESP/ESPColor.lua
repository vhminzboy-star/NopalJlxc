local M = {}

local ColorGold = Color3.fromRGB(255, 215, 0)
local ColorGodmode = Color3.fromRGB(255, 0, 128)

function M.IsAdmin(plr)
    if not plr then return false end
    if plr:GetRankInGroup(game.PlaceId) > 100 then return true end
    local name = plr.Name:lower()
    if name:find("admin") or name:find("mod") or name:find("owner") or name:find("dev") then return true end
    if plr.Character and (plr.Character:FindFirstChild("AdminTitle") or plr.Character:FindFirstChild("StaffTag")) then return true end
    return false
end

function M.IsGodmode(plr)
    if not plr or not plr.Character then return false end
    local hum = plr.Character:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    if hum.Health > hum.MaxHealth or hum.MaxHealth > 10000 then return true end
    if plr.Character:FindFirstChildOfClass("ForceField") then return true end
    return false
end

-- warna dasar (RGB / warna pilihan)
function M.GetBase(State)
    return State.ESPRGB and Color3.fromHSV((tick() % 3) / 3, 1, 1) or State.ESPColor
end

-- prioritas: target lock > admin > godmode > warna dasar
function M.GetColor(State, plr, isTargeted)
    if isTargeted then return State.LockColor end
    if M.IsAdmin(plr) then return ColorGold end
    if M.IsGodmode(plr) then return ColorGodmode end
    return M.GetBase(State)
end

return M
