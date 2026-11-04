local M = {}

function M.Get(State)
    return State.LockColor
end

-- kalau lagi lock target -> LockColor, kalau tidak -> warna normal
function M.Pick(State, isLocked, normalColor)
    if isLocked then return State.LockColor end
    return normalColor
end

return M
