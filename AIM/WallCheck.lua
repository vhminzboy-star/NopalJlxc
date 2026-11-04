local M = {}
local Workspace = game:GetService("Workspace")

-- true  = target kelihatan (atau WallCheck mati)
-- false = target terhalang tembok
function M.IsVisible(State, env, targetPart)
    if not State.WallCheck then return true end
    if not targetPart or not targetPart.Parent then return false end

    local char = targetPart.Parent
    local camPos = env.Camera.CFrame.Position

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {env.LocalPlayer.Character, char, env.Camera}
    params.IgnoreWater = true

    local points = {targetPart.Position}
    local head = char:FindFirstChild("Head")
    local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    if head and head ~= targetPart then table.insert(points, head.Position) end
    if torso and torso ~= targetPart then table.insert(points, torso.Position) end

    -- cukup satu titik yang tidak terhalang
    for _, p in ipairs(points) do
        if not Workspace:Raycast(camPos, p - camPos, params) then return true end
    end
    return false
end

return M
