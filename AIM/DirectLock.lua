local M = {}

-- DirectLock aktif -> kamera langsung nempel ke target.
-- Kalau tidak -> pakai fungsi smooth (Smoothness.Apply).
function M.Apply(State, currentCFrame, targetCFrame, dt, smoothFn)
    if State.DirectLock then return targetCFrame end
    return smoothFn(State, currentCFrame, targetCFrame, dt)
end

return M
