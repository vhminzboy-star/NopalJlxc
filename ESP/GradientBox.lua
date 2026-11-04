local M = {}

function M.Create(new)
    return {GradientBox = new("Square", {Thickness = 0, Filled = true, Transparency = 0.35, Visible = false})}
end

function M.Hide(draw) draw.GradientBox.Visible = false end

function M.Update(draw, ctx)
    if not ctx.State.ESP_GradientBox then return M.Hide(draw) end
    local b = draw.GradientBox
    local pulse = math.abs(math.sin(tick() * 3))
    b.Size = Vector2.new(ctx.width, ctx.height)
    b.Position = Vector2.new(ctx.minX, ctx.minY)
    b.Color = ctx.color:Lerp(Color3.fromRGB(0, 0, 0), pulse * 0.5)
    b.Transparency = 0.2 + (pulse * 0.3)
    b.Visible = true
end

return M
