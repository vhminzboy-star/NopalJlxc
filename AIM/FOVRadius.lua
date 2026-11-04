local M = {}

function M.Center(Camera)
    return Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
end

-- true kalau titik layar berada di dalam lingkaran FOV
function M.IsInside(State, Camera, screenPos)
    local d = (Vector2.new(screenPos.X, screenPos.Y) - M.Center(Camera)).Magnitude
    return d <= State.FOVRadius
end

return M
