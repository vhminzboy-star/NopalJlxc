local M = {}

function M.Create(new)
    local d = {}
    for i = 1, 8 do d["C"..i] = new("Line", {Thickness = 1.5, Visible = false}) end
    return d
end

function M.Hide(draw)
    for i = 1, 8 do draw["C"..i].Visible = false end
end

function M.Update(draw, ctx)
    if not ctx.State.ESP_CornerBox then return M.Hide(draw) end
    local x, y, w, h, col = ctx.minX, ctx.minY, ctx.width, ctx.height, ctx.color
    local l, V = w * 0.25, Vector2.new
    local lines = {
        {V(x, y), V(x + l, y)},                 {V(x, y), V(x, y + l)},
        {V(x + w, y), V(x + w - l, y)},         {V(x + w, y), V(x + w, y + l)},
        {V(x, y + h), V(x + l, y + h)},         {V(x, y + h), V(x, y + h - l)},
        {V(x + w, y + h), V(x + w - l, y + h)}, {V(x + w, y + h), V(x + w, y + h - l)},
    }
    for i, p in ipairs(lines) do
        local ln = draw["C"..i]
        ln.From = p[1]; ln.To = p[2]; ln.Color = col; ln.Visible = true
    end
end

return M
