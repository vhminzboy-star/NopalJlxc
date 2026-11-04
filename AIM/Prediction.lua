local M = {}

-- Geser titik bidik ke depan sesuai kecepatan target
-- (State.Prediction = on/off, State.PredictionMult = seberapa jauh)
function M.Apply(State, targetPart)
    local pos = targetPart.Position
    if State.Prediction and targetPart.Parent then
        local hrp = targetPart.Parent:FindFirstChild("HumanoidRootPart")
        if hrp then
            pos = pos + (hrp.AssemblyLinearVelocity * State.PredictionMult)
        end
    end
    return pos
end

return M
