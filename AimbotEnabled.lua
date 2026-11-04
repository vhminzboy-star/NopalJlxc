-- Otak aimbot: cari target terbaik lalu hitung CFrame kamera baru.
-- Taruh bareng folder Aimbot/ (readfile("Aimbot/...")).
local function load(n) return loadstring(readfile("Aimbot/"..n..".lua"))() end

local TargetPart = load("TargetPart")
local WallCheck  = load("WallCheck")
local FOVRadius  = load("FOVRadius")
local Prediction = load("Prediction")
local Smoothness = load("Smoothness")
local DirectLock = load("DirectLock")

local M = {}
M.CurrentTarget = nil -- pengganti CurrentActiveTarget

local function isAlive(char)
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    return hum and hum.Health > 0 and hum:GetState() ~= Enum.HumanoidStateType.Dead
end

-- env = {State=, Camera=, LocalPlayer=, Players=}
local function isValid(env, part)
    local State, Camera = env.State, env.Camera
    if not part or not part.Parent then return false end
    local char = part.Parent
    if not isAlive(char) then return false end

    local plr = env.Players:GetPlayerFromCharacter(char)
    if plr and State.ESP_TeamCheck and plr.Team == env.LocalPlayer.Team then return false end

    local sp, onScreen = Camera:WorldToViewportPoint(part.Position)
    if not onScreen or sp.Z <= 0 then return false end
    if not FOVRadius.IsInside(State, Camera, sp) then return false end
    if not WallCheck.IsVisible(State, env, part) then return false end
    return true
end

local function getBest(env)
    local State, Camera = env.State, env.Camera
    if M.CurrentTarget and isValid(env, M.CurrentTarget) then return M.CurrentTarget end

    local center = FOVRadius.Center(Camera)
    local closest, minDist = nil, State.FOVRadius

    for _, plr in ipairs(env.Players:GetPlayers()) do
        if plr ~= env.LocalPlayer and plr.Character then
            if State.ESP_TeamCheck and plr.Team == env.LocalPlayer.Team then continue end
            local part = TargetPart.GetPart(State, plr.Character)
            if part and isValid(env, part) then
                local sp, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen and sp.Z > 0 then
                    local d = (Vector2.new(sp.X, sp.Y) - center).Magnitude
                    if d < minDist then closest, minDist = part, d end
                end
            end
        end
    end

    M.CurrentTarget = closest
    return closest
end

-- Panggil tiap frame di RenderStepped. Return CFrame kamera baru.
function M.Update(env, baseCFrame, dt)
    local State, Camera = env.State, env.Camera
    if not State.AimbotEnabled then
        M.CurrentTarget = nil
        return baseCFrame
    end

    local part = getBest(env)
    if not part then
        M.CurrentTarget = nil
        return baseCFrame
    end

    local targetPos = Prediction.Apply(State, part)
    local targetCFrame = CFrame.lookAt(Camera.CFrame.Position, targetPos)
    return DirectLock.Apply(State, Camera.CFrame, targetCFrame, dt, Smoothness.Apply)
end

return M
