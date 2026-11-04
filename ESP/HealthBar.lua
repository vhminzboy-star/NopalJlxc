local M = {}

function M.Create(new)
    return {
        HealthBarOutline = new("Square", {Thickness = 1, Filled = true, Color = Color3.fromRGB(0, 0, 0), Visible = false}),
        HealthBar = new("Square", {Thickness = 1, Filled = true, Visible = false}),
    }
end

function M.Hide(draw)
    draw.HealthBarOutline.Visible = false
    draw.HealthBar.Visible = false
end

function M.Update(draw, ctx)
    if not ctx.State.ESP_HealthBar then return M.Hide(draw) end
    local pct = math.clamp(ctx.hum.Health / ctx.hum.MaxHealth, 0, 1)
    local bw = 2.5
    local bx, by = ctx.minX - bw - 4, ctx.minY

    draw.HealthBarOutline.Size = Vector2.new(bw, ctx.height)
    draw.HealthBarOutline.Position = Vector2.new(bx, by)
    draw.HealthBarOutline.Visible = true

    local bh = ctx.height * pct
    draw.HealthBar.Size = Vector2.new(bw, bh)
    draw.HealthBar.Position = Vector2.new(bx, by + (ctx.height - bh))
    draw.HealthBar.Color = Color3.fromHSV(pct * 0.3, 1, 1)
    draw.HealthBar.Visible = true
end

return M
