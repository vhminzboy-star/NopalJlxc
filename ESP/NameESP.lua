local M = {}

function M.Create(new)
    return {NameText = new("Text", {Size = 10, Center = true, Outline = true, Visible = false})}
end

function M.Hide(draw) draw.NameText.Visible = false end

function M.Update(draw, ctx)
    if not ctx.State.ESP_Names then return M.Hide(draw) end
    draw.NameText.Text = string.format("%s [%dm]", ctx.plr.Name, math.floor(ctx.dist))
    draw.NameText.Position = Vector2.new(ctx.hrpPos.X, ctx.minY - 14)
    draw.NameText.Color = Color3.fromRGB(255, 255, 255)
    draw.NameText.Visible = true
end

return M
