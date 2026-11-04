local M = {}

function M.Create(new)
    local d = {}
    for i = 1, 5 do d["Skel"..i] = new("Line", {Thickness = 1.2, Visible = false}) end
    return d
end

function M.Hide(draw)
    for i = 1, 5 do draw["Skel"..i].Visible = false end
end

function M.Update(draw, ctx)
    if not ctx.State.ESP_Skeleton then return M.Hide(draw) end
    local char, cam, col = ctx.char, ctx.Camera, ctx.color
    local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or ctx.hrp
    local lArm = char:FindFirstChild("LeftHand") or char:FindFirstChild("Left Arm")
    local rArm = char:FindFirstChild("RightHand") or char:FindFirstChild("Right Arm")
    local lLeg = char:FindFirstChild("LeftFoot") or char:FindFirstChild("Left Leg")
    local rLeg = char:FindFirstChild("RightFoot") or char:FindFirstChild("Right Leg")

    local function connect(line, p1, p2)
        if p1 and p2 then
            local a = cam:WorldToViewportPoint(p1.Position)
            local b = cam:WorldToViewportPoint(p2.Position)
            if a.Z > 0 and b.Z > 0 then
                line.From = Vector2.new(a.X, a.Y)
                line.To = Vector2.new(b.X, b.Y)
                line.Color = col
                line.Visible = true
                return
            end
        end
        line.Visible = false
    end

    connect(draw.Skel1, ctx.head, torso)
    connect(draw.Skel2, torso, lArm)
    connect(draw.Skel3, torso, rArm)
    connect(draw.Skel4, torso, lLeg)
    connect(draw.Skel5, torso, rLeg)
end

return M
