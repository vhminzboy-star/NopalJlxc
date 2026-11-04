local M = {}

local Default = Color3.fromRGB(0, 240, 255)

function M.Get(State)
    return State.FOVColor or Default
end

function M.Set(State, color)
    State.FOVColor = color or Default
end

return M
