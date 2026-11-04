-- Penyambung semua modul ESP. Taruh bareng folder ESP/ (readfile("ESP/..."))
local function load(name) return loadstring(readfile("ESP/"..name..".lua"))() end

local ORDER = {"PrecisionBox", "FilledBox", "GradientBox", "HealthBar", "Skeleton", "Tracer", "HeadDot", "NameESP"}
local Modules = {}
for _, n in ipairs(ORDER) do Modules[#Modules + 1] = load(n) end
local TeamCheck = load("TeamCheck")
local ESPColor = load("ESPColor")

local Core = {}

function Core.CreateDrawings(createDrawing)
    local draw = {}
    for _, m in ipairs(Modules) do
        for k, v in pairs(m.Create(createDrawing)) do draw[k] = v end
    end
    return draw
end

function Core.HideAll(draw)
    for _, item in pairs(draw) do item.Visible = false end
end

-- env = {State=, Camera=, LocalPlayer=, CurrentTarget=function() ... end, IsAlive=function(char) ... end}
function Core.Update(env, plr, draw)
    local State, Camera, LocalPlayer = env.State, env.Camera, env.LocalPlayer
    local char = plr.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local head = char and char:FindFirstChild("Head")
    local hum = char and char:FindFirstChildOfClass("Humanoid")

    local isTeam = TeamCheck.IsTeammate(State, LocalPlayer, plr)
    local dist = hrp and (Camera.CFrame.Position - hrp.Position).Magnitude or 99999
    local target = env.CurrentTarget()
    local color = ESPColor.GetColor(State, plr, target and target.Parent == char)

    if not (char and hrp and head and hum and env.IsAlive(char) and not isTeam and dist <= State.ESP_MaxDistance) then
        return Core.HideAll(draw)
    end

    if State.HitboxExpander then
        hrp.Size = Vector3.new(State.HitboxSize, State.HitboxSize, State.HitboxSize)
        hrp.Transparency = 0.7
        hrp.CanCollide = false
    else
        hrp.Size = Vector3.new(2, 2, 1)
        hrp.Transparency = 1
    end

    local hrpPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
    if not (onScreen and hrpPos.Z > 0) then return Core.HideAll(draw) end

    local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
    local legPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
    local height = math.abs(headPos.Y - legPos.Y)
    local width = height * 0.65

    local ctx = {
        State = State, Camera = Camera, plr = plr, char = char, hrp = hrp, head = head, hum = hum,
        hrpPos = hrpPos, headPos = headPos, dist = dist, color = color,
        width = width, height = height, minX = hrpPos.X - (width / 2), minY = headPos.Y,
        viewX = Camera.ViewportSize.X, viewY = Camera.ViewportSize.Y,
    }
    for _, m in ipairs(Modules) do m.Update(draw, ctx) end
end

return Core
