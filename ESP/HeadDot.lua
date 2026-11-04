local M = {}

function M.Create(new)
    return {HeadDot = new("Circle", {Radius = 3, Filled = true, Visible = false})}
end

function M.Hide(draw) draw.HeadDot.Visible = false end

function M.Update(draw, ctx)
    if not ctx.State.ESP_HeadDots then return M.Hide(draw) end
    draw.HeadDot.Position = Vector2.new(ctx.headPos.X, ctx.headPos.Y)
    draw.HeadDot.Color = ctx.color
    draw.HeadDot.Visible = true
end

return M
