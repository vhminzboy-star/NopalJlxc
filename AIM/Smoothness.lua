local M = {}

-- Gerakkan kamera pelan-pelan ke arah target (makin besar nilai, makin cepat)
function M.Apply(State, currentCFrame, targetCFrame, dt)
    local s = math.clamp(State.Smoothness * 50, 1, 50)
    local alpha = 1 - math.exp(-s * dt)
    return currentCFrame:Lerp(targetCFrame, math.clamp(alpha, 0.01, 1))
end

return M
