local M = {}

-- Pilih bagian tubuh yang dibidik sesuai State.TargetPart
function M.GetPart(State, character)
    if not character then return nil end
    local sel = State.TargetPart
    if sel == "Head" then
        return character:FindFirstChild("Head")
    elseif sel == "Torso" then
        return character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso") or character:FindFirstChild("HumanoidRootPart")
    else
        return character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso") or character:FindFirstChild("Head")
    end
end

return M
