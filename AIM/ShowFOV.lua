local M = {}

function M.Create()
    local c = Drawing.new("Circle")
    c.Thickness = 1.5
    c.NumSides = 64
    c.Filled = false
    c.Transparency = 0.85
    c.Visible = false
    return c
end

-- color dihitung di luar (FOVColor / LockColor)
function M.Update(circle, State, Camera, color)
    circle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    circle.Radius = State.FOVRadius
    circle.Color = color
    circle.Visible = State.ShowFOV and State.AimbotEnabled
end

function M.Destroy(circle)
    pcall(function() circle:Remove() end)
end

return M
