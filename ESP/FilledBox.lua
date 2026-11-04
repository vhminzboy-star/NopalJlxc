local M = {}

function M.Create(new)
    return {FilledBox = new("Square", {Thickness = 0, Filled = true, Transparency = 0.35, Visible = false})}
end

function M.Hide(draw) draw.FilledBox.Visible = false end

function M.Update(draw, ctx)
    -- kalau GradientBox aktif, dia yang menang (sama kayak script asli)
    if not ctx.State.ESP_FilledBox or ctx.State.ESP_GradientBox then return M.Hide(draw) end
    local b = draw.FilledBox
    b.Size = Vector2.new(ctx.width, ctx.height)
    b.Position = Vector2.new(ctx.minX, ctx.minY)
    b.Color = ctx.color
    b.Transparency = 0.25 + (math.sin(tick() * 4) * 0.1)
    b.Visible = true
end

return M
