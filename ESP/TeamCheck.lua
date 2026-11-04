local M = {}

-- true kalau plr satu tim dengan LocalPlayer DAN Team Check aktif
function M.IsTeammate(State, LocalPlayer, plr)
    return (State.ESP_TeamCheck and plr.Team == LocalPlayer.Team) and true or false
end

return M
