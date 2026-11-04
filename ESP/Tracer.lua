local M = {}

function M.Create(new)
    return {Tracer = new("Line", {Thickness = 1.2, Visible = false})}
end

function M.Hide(draw) draw.Tracer.Visible = false end

function M.Update(draw, ctx)
    local S = ctx.State
    if not S.ESP_Tracers then return M.Hide(draw) end
    local vx, vy = ctx.viewX, ctx.viewY
    local startPos = Vector2.new(vx / 2, vy) -- "Bawah Tengah"
    if S.ESP_TracerPos == "Tengah Tengah" then
        startPos = Vector2.new(vx / 2, vy / 2)
    elseif S.ESP_TracerPos == "Atas Tengah" then
        startPos = Vector2.new(vx / 2, 0)
    end
    draw.Tracer.From = startPos
    draw.Tracer.To = Vector2.new(ctx.hrpPos.X, ctx.minY + ctx.height)
    draw.Tracer.Color = ctx.color
    draw.Tracer.Visible = true
end

return M
