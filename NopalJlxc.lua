-- ========================================================
-- NOPAL JLXC — BETA CPB JELYZX (ULTRA SAFE & ULTIMATE V3)
-- Showcase Logo: https://create.roblox.com/store/asset/129775661697970
-- Background Logo: https://create.roblox.com/store/asset/111989994218720
-- ========================================================

if _G.JelyzxConnections then
    for _, conn in ipairs(_G.JelyzxConnections) do
        pcall(function() conn:Disconnect() end)
    end
end
_G.JelyzxConnections = {}

-----------------------------------------------------------
-- 🔒 ANTI-CHEAT & METATABLE PROTECTION LAYER V3
-----------------------------------------------------------
local RawMetatable = getrawmetatable or debug.getmetatable
local SetReadOnly = setreadonly or make_writeable

local State = {
    -- Combat & Targeting
    AimbotEnabled = false,
    SilentAim = false,
    Smoothness = 0.15, 
    DirectLock = false,
    TargetPart = "Head",
    WallCheck = false,
    FOVRadius = 150,
    ShowFOV = false,
    FOVColor = Color3.fromRGB(0, 240, 255),
    Prediction = false, 
    PredictionMult = 0.01,
    LockColor = Color3.fromRGB(255, 30, 30),
    TargetSnapline = false,
    
    SpawnFullHealth = false,
    InvisibleMode = false,

    CustomCrosshair = false,
    CrosshairType = "Silang (+)",
    CrosshairColorName = "Hijau Neon",
    CrosshairColor = Color3.fromRGB(0, 255, 150),

    ESP_CornerBox = false,
    ESP_HealthBar = false,
    ESP_Skeleton = false,
    ESP_Tracers = false,
    ESP_TracerPos = "Bawah Tengah",
    ESP_HeadDots = false,
    ESP_Names = false,
    ESP_Chams = false,
    ESP_TeamCheck = false,
    ESP_MaxDistance = 999999,
    ESPColor = Color3.fromRGB(0, 240, 255),
    ESPRGB = false,

    HitboxExpander = false,
    HitboxSize = 15,

    LYR360Enabled = false,
    LYR360Val = 135,
    LYRFisheyeDegree = 1.8,

    RealGepengEnabled = false,
    GepengRatio = 0.35,

    WalkSpeedVal = 16,
    JumpPowerVal = 50,
    NoclipEnabled = false,
    InfiniteJump = false,
    FlyEnabled = false,
    FlySpeed = 50,
    FlyUp = false,
    FlyDown = false,

    SmoothMovement = false,
    SmoothFactor = 0.25,
    FiveMBlink = false,
    BlinkIntensity = 15,
    RollingSpeed = 45,
    IsRolling = false,

    SpinBotEnabled = false,
    SpinSpeed = 30,

    AntiAFK = true,
    ScriptActive = true
}

local CurrentActiveTarget = nil

if RawMetatable and SetReadOnly then
    local oldNamecall = nil
    local oldIndex = nil
    local mt = RawMetatable(game)
    SetReadOnly(mt, false)
    
    oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if not checkcaller() then
            if method == "Kick" or method == "kick" then return nil end
        end
        return oldNamecall(self, ...)
    end))

    oldIndex = hookmetamethod(game, "__index", newcclosure(function(self, key)
        if not checkcaller() and self:IsA("Humanoid") then
            if key == "WalkSpeed" then return 16 end
            if key == "JumpPower" then return 50 end
        end
        return oldIndex(self, key)
    end))

    SetReadOnly(mt, true)
end

local Services = setmetatable({}, {
    __index = function(_, serviceName) return game:GetService(serviceName) end
})

local Players = Services.Players
local UserInputService = Services.UserInputService
local RunService = Services.RunService
local CoreGui = Services.CoreGui
local Workspace = Services.Workspace
local VirtualUser = Services.VirtualUser
local TweenService = Services.TweenService
local SoundService = Services.SoundService

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local function getGuiParent()
    local parent = nil
    pcall(function() if gethui then parent = gethui() end end)
    if not parent then
        pcall(function()
            if syn and syn.protect_gui then
                syn.protect_gui(CoreGui)
                parent = CoreGui
            end
        end)
    end
    return parent or (LocalPlayer:WaitForChild("PlayerGui", 5) or CoreGui)
end

local parentGui = getGuiParent()
local oldGui = parentGui:FindFirstChild("JELYZX_V20_FULL_GUI") or LocalPlayer.PlayerGui:FindFirstChild("JELYZX_V20_FULL_GUI")
if oldGui then oldGui:Destroy() end

local RAW_ID = "111989994218720"
local SHOWCASE_ID = "129775661697970"
local CUSTOM_LOGO_ID = "rbxthumb://type=Asset&id=" .. RAW_ID .. "&w=420&h=420"
local SHOWCASE_LOGO_ID = "rbxthumb://type=Asset&id=" .. SHOWCASE_ID .. "&w=420&h=420"

local function playSound(soundId, volume)
    task.spawn(function()
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://" .. tostring(soundId)
        sound.Volume = volume or 0.5
        sound.Parent = SoundService
        sound:Play()
        sound.Ended:Connect(function() sound:Destroy() end)
    end)
end

local SOUND_UI_OPEN = "6112625298"
local SOUND_TOGGLE_ON = "8486683243"
local SOUND_TOGGLE_OFF = "131390520971848"

local ColorMap = {
    ["Biru Cyan"]  = Color3.fromRGB(0, 240, 255),
    ["Hijau Neon"] = Color3.fromRGB(0, 255, 150),
    ["Merah"]      = Color3.fromRGB(255, 45, 65),
    ["Kuning"]     = Color3.fromRGB(255, 220, 0),
    ["Ungu"]       = Color3.fromRGB(180, 50, 255),
    ["Pink Neon"]  = Color3.fromRGB(255, 20, 147),
    ["Oranye"]     = Color3.fromRGB(255, 140, 0),
    ["Putih"]      = Color3.fromRGB(255, 255, 255),
    ["Emas"]       = Color3.fromRGB(255, 215, 0),
    ["Lime"]       = Color3.fromRGB(50, 205, 50),
    ["Biru Tua"]   = Color3.fromRGB(30, 144, 255)
}

local ColorGold = Color3.fromRGB(255, 215, 0)
local ColorGodmode = Color3.fromRGB(255, 0, 128)

local function isAdminPlayer(plr)
    if not plr then return false end
    local success, rank = pcall(function() return plr:GetRankInGroup(game.PlaceId) end)
    if success and rank > 100 then return true end
    local name = plr.Name:lower()
    if name:find("admin") or name:find("mod") or name:find("owner") or name:find("dev") then return true end
    return false
end

local function isGodmodePlayer(plr)
    if not plr or not plr.Character then return false end
    local hum = plr.Character:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    if hum.Health > hum.MaxHealth or hum.MaxHealth > 10000 then return true end
    return false
end

-- DRAWINGS
local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 1.5
fovCircle.NumSides = 64
fovCircle.Filled = false
fovCircle.Transparency = 0.85
fovCircle.Color = State.FOVColor
fovCircle.Visible = State.ShowFOV

local targetLine = Drawing.new("Line")
targetLine.Thickness = 1.8
targetLine.Color = State.LockColor
targetLine.Visible = false

local chLines = {}
for i = 1, 4 do
    local l = Drawing.new("Line")
    l.Thickness = 1.5
    l.Visible = false
    chLines[i] = l
end

local chCircle = Drawing.new("Circle")
chCircle.Thickness = 1.5
chCircle.Filled = false
chCircle.Visible = false

local function hideAllCrosshair()
    for _, l in ipairs(chLines) do l.Visible = false end
    chCircle.Visible = false
end

-- GUI BASE
local gui = Instance.new("ScreenGui")
gui.Name = "JELYZX_V20_FULL_GUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = parentGui

-- FLY TOUCH UI
local flyControls = Instance.new("Frame")
flyControls.Name = "ModernFlyUI"
flyControls.Size = UDim2.new(0, 75, 0, 160)
flyControls.Position = UDim2.new(1, -90, 0.5, -80)
flyControls.BackgroundColor3 = Color3.fromRGB(12, 15, 24)
flyControls.BackgroundTransparency = 0.35
flyControls.Visible = false
flyControls.Parent = gui
Instance.new("UICorner", flyControls).CornerRadius = UDim.new(0, 16)

local flyStroke = Instance.new("UIStroke", flyControls)
flyStroke.Color = Color3.fromRGB(0, 240, 255)
flyStroke.Thickness = 1.5

local btnUp = Instance.new("TextButton")
btnUp.Size = UDim2.new(0, 61, 0, 60)
btnUp.Position = UDim2.new(0.5, -30, 0, 26)
btnUp.BackgroundColor3 = Color3.fromRGB(20, 28, 45)
btnUp.Text = "▲\nUP"
btnUp.TextColor3 = Color3.fromRGB(0, 255, 170)
btnUp.Font = Enum.Font.GothamBlack
btnUp.TextSize = 11
btnUp.Parent = flyControls
Instance.new("UICorner", btnUp).CornerRadius = UDim.new(0, 12)

local btnDown = Instance.new("TextButton")
btnDown.Size = UDim2.new(0, 61, 0, 60)
btnDown.Position = UDim2.new(0.5, -30, 0, 92)
btnDown.BackgroundColor3 = Color3.fromRGB(20, 28, 45)
btnDown.Text = "▼\nDOWN"
btnDown.TextColor3 = Color3.fromRGB(255, 55, 80)
btnDown.Font = Enum.Font.GothamBlack
btnDown.TextSize = 11
btnDown.Parent = flyControls
Instance.new("UICorner", btnDown).CornerRadius = UDim.new(0, 12)

btnUp.MouseButton1Down:Connect(function() State.FlyUp = true end)
btnUp.MouseButton1Up:Connect(function() State.FlyUp = false end)
btnUp.InputEnded:Connect(function() State.FlyUp = false end)
btnDown.MouseButton1Down:Connect(function() State.FlyDown = true end)
btnDown.MouseButton1Up:Connect(function() State.FlyDown = false end)
btnDown.InputEnded:Connect(function() State.FlyDown = false end)

-- MAIN UI PANEL
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 420, 0, 260)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(11, 13, 20)
main.BackgroundTransparency = 0.25
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Visible = true
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = Color3.fromRGB(255, 45, 65)
mainStroke.Thickness = 1.8

local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 38)
topBar.BackgroundTransparency = 1
topBar.Parent = main

local titleLbl = Instance.new("TextLabel")
titleLbl.Size = UDim2.new(1, -140, 1, 0)
titleLbl.Position = UDim2.new(0, 15, 0, 0)
titleLbl.BackgroundTransparency = 1
titleLbl.Font = Enum.Font.GothamBlack
titleLbl.Text = "NOPAL <font color=\"#FF2D41\">JLXC</font> <font color=\"#00F0FF\">| ULTIMATE V3</font>"
titleLbl.RichText = true
titleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLbl.TextSize = 10
titleLbl.TextXAlignment = Enum.TextXAlignment.Left
titleLbl.Parent = topBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 20, 0, 20)
closeBtn.Position = UDim2.new(1, -28, 0.5, -10)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 45, 65)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 10
closeBtn.Parent = topBar
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 5)

local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 115, 1, -44)
sidebar.Position = UDim2.new(0, 8, 0, 42)
sidebar.BackgroundTransparency = 1
sidebar.Parent = main

local sideLayout = Instance.new("UIListLayout")
sideLayout.Padding = UDim.new(0, 4)
sideLayout.Parent = sidebar

local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, -135, 1, -48)
contentArea.Position = UDim2.new(0, 127, 0, 42)
contentArea.BackgroundTransparency = 1
contentArea.Parent = main

local dragging, dragStart, startPos
topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = main.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

local tabs = {}
local function createTab(name)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, 0, 0, 24)
    tabBtn.BackgroundColor3 = Color3.fromRGB(16, 20, 30)
    tabBtn.BackgroundTransparency = 0.4
    tabBtn.Text = name
    tabBtn.TextColor3 = Color3.fromRGB(140, 150, 175)
    tabBtn.Font = Enum.Font.GothamMedium
    tabBtn.TextSize = 8.5
    tabBtn.Parent = sidebar
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 5)

    local container = Instance.new("ScrollingFrame")
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.ScrollBarThickness = 2
    container.ScrollBarImageColor3 = Color3.fromRGB(255, 45, 65)
    container.Visible = false
    container.Parent = contentArea
    container.AutomaticCanvasSize = Enum.AutomaticSize.Y

    local containerLayout = Instance.new("UIListLayout")
    containerLayout.Padding = UDim.new(0, 5)
    containerLayout.Parent = container

    tabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(tabs) do
            t.Btn.BackgroundColor3 = Color3.fromRGB(16, 20, 30)
            t.Btn.BackgroundTransparency = 0.4
            t.Btn.TextColor3 = Color3.fromRGB(140, 150, 175)
            t.Container.Visible = false
        end
        tabBtn.BackgroundColor3 = Color3.fromRGB(255, 45, 65)
        tabBtn.BackgroundTransparency = 0
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        container.Visible = true
    end)

    table.insert(tabs, {Btn = tabBtn, Container = container})
    if #tabs == 1 then
        tabBtn.BackgroundColor3 = Color3.fromRGB(255, 45, 65)
        tabBtn.BackgroundTransparency = 0
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        container.Visible = true
    end
    return container
end

local function addToggle(parent, text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -6, 0, 24)
    frame.BackgroundColor3 = Color3.fromRGB(16, 20, 32)
    frame.BackgroundTransparency = 0.3
    frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 5)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.7, 0, 1, 0)
    lbl.Position = UDim2.new(0, 8, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextColor3 = Color3.fromRGB(220, 225, 240)
    lbl.TextSize = 9
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame

    local switch = Instance.new("TextButton")
    switch.Size = UDim2.new(0, 30, 0, 14)
    switch.Position = UDim2.new(1, -34, 0.5, -7)
    switch.BackgroundColor3 = default and Color3.fromRGB(255, 45, 65) or Color3.fromRGB(30, 36, 50)
    switch.Text = ""
    switch.Parent = frame
    Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)

    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 10, 0, 10)
    dot.Position = default and UDim2.new(1, -12, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)
    dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    dot.Parent = switch
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    local state = default
    switch.MouseButton1Click:Connect(function()
        state = not state
        if state then playSound(SOUND_TOGGLE_ON, 0.6) else playSound(SOUND_TOGGLE_OFF, 0.6) end
        TweenService:Create(switch, TweenInfo.new(0.15), {BackgroundColor3 = state and Color3.fromRGB(255, 45, 65) or Color3.fromRGB(30, 36, 50)}):Play()
        TweenService:Create(dot, TweenInfo.new(0.15), {Position = state and UDim2.new(1, -12, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)}):Play()
        callback(state)
    end)
end

local function addSlider(parent, text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -6, 0, 26)
    frame.BackgroundColor3 = Color3.fromRGB(16, 20, 32)
    frame.BackgroundTransparency = 0.3
    frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 5)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.6, 0, 0, 12)
    lbl.Position = UDim2.new(0, 8, 0, 2)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextColor3 = Color3.fromRGB(220, 225, 240)
    lbl.TextSize = 9
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame

    local valInput = Instance.new("TextLabel")
    valInput.Size = UDim2.new(0.35, -8, 0, 12)
    valInput.Position = UDim2.new(0.65, 0, 0, 2)
    valInput.BackgroundTransparency = 1
    valInput.Text = tostring(default)
    valInput.Font = Enum.Font.GothamBold
    valInput.TextColor3 = Color3.fromRGB(255, 45, 65)
    valInput.TextSize = 9
    valInput.TextXAlignment = Enum.TextXAlignment.Right
    valInput.Parent = frame

    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -16, 0, 3)
    track.Position = UDim2.new(0, 8, 0, 18)
    track.BackgroundColor3 = Color3.fromRGB(30, 36, 50)
    track.Parent = frame

    local fill = Instance.new("Frame")
    local pct = math.clamp((default - min) / (max - min), 0, 1)
    fill.Size = UDim2.new(pct, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(255, 45, 65)
    fill.Parent = track

    local draggingBar = false
    local function update(inputX)
        local p = math.clamp((inputX - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        fill.Size = UDim2.new(p, 0, 1, 0)
        local v = math.floor(min + (max - min) * p)
        valInput.Text = tostring(v)
        callback(v)
    end

    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingBar = true; update(input.Position.X)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if draggingBar and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then update(input.Position.X) end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then draggingBar = false end
    end)
end

local function addSelector(parent, text, options, defaultIndex, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -6, 0, 24)
    frame.BackgroundColor3 = Color3.fromRGB(16, 20, 32)
    frame.BackgroundTransparency = 0.3
    frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 5)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.45, 0, 1, 0)
    lbl.Position = UDim2.new(0, 8, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextColor3 = Color3.fromRGB(220, 225, 240)
    lbl.TextSize = 9
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 0, 16)
    btn.Position = UDim2.new(1, -104, 0.5, -8)
    btn.BackgroundColor3 = Color3.fromRGB(26, 32, 46)
    btn.Text = options[defaultIndex] .. " ▼"
    btn.TextColor3 = Color3.fromRGB(255, 45, 65)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 8
    btn.Parent = frame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

    local currIndex = defaultIndex
    btn.MouseButton1Click:Connect(function()
        currIndex = (currIndex % #options) + 1
        btn.Text = options[currIndex] .. " ▼"
        callback(options[currIndex])
    end)
end

-- TABS
local combatTab = createTab("Combat")
local espTab = createTab("ESP Config")
local resoTab = createTab("Resolusi")
local moveTab = createTab("Movement")

local colorList = {"Biru Cyan", "Hijau Neon", "Merah", "Kuning", "Ungu", "Pink Neon", "Oranye", "Putih", "Emas", "Lime", "Biru Tua"}

-- COMBAT TAB
addToggle(combatTab, "Camera Lock (Aimbot)", false, function(v) State.AimbotEnabled = v end)
addToggle(combatTab, "Silent Aim Mode", false, function(v) State.SilentAim = v end)
addToggle(combatTab, "Instant Lock Mode", false, function(v) State.DirectLock = v end)
addSlider(combatTab, "Smoothness Speed", 1, 50, 5, function(v) State.Smoothness = v / 50 end)
addToggle(combatTab, "Movement Prediction", false, function(v) State.Prediction = v end)
addToggle(combatTab, "Wall Check (Ultra Presisi)", false, function(v) State.WallCheck = v end)
addSelector(combatTab, "Target Part", {"Head", "Torso", "HumanoidRootPart"}, 1, function(v) State.TargetPart = v end)
addToggle(combatTab, "Show FOV Circle", false, function(v) State.ShowFOV = v end)
addSlider(combatTab, "FOV Radius", 50, 1500, 150, function(v) State.FOVRadius = v end)
addToggle(combatTab, "Target Snapline", false, function(v) State.TargetSnapline = v end)
addSelector(combatTab, "Warna FOV Circle", colorList, 1, function(v) State.FOVColor = ColorMap[v] or Color3.fromRGB(0, 240, 255) end)

addToggle(combatTab, "Invisible Mode (Ghost)", false, function(v) State.InvisibleMode = v end)
addToggle(combatTab, "Show Custom Crosshair", false, function(v) State.CustomCrosshair = v end)
addSelector(combatTab, "Model Crosshair", {"Silang (+)", "Dot (.)", "Kotak (Square)", "X-Shape (X)", "Lingkaran (Circle)"}, 1, function(v) State.CrosshairType = v end)
addSelector(combatTab, "Warna Crosshair", colorList, 2, function(v) State.CrosshairColor = ColorMap[v] end)
addToggle(combatTab, "Hitbox Expander", false, function(v) State.HitboxExpander = v end)
addSlider(combatTab, "Hitbox Size", 0, 100, 15, function(v) State.HitboxSize = v end)

-- ESP TAB
addToggle(espTab, "Precision Box ESP", false, function(v) State.ESP_CornerBox = v end)
addToggle(espTab, "Chams (Highlight Glow)", false, function(v) State.ESP_Chams = v end)
addToggle(espTab, "Health Bar ESP", false, function(v) State.ESP_HealthBar = v end)
addToggle(espTab, "Skeleton ESP", false, function(v) State.ESP_Skeleton = v end)
addToggle(espTab, "Snapline Tracer", false, function(v) State.ESP_Tracers = v end)
addSelector(espTab, "Posisi Line Tracer", {"Bawah Tengah", "Tengah Tengah", "Atas Tengah"}, 1, function(v) State.ESP_TracerPos = v end)
addSelector(espTab, "Warna Utama ESP/Tracer", colorList, 1, function(v) State.ESPColor = ColorMap[v] end)
addToggle(espTab, "Head Dot ESP", false, function(v) State.ESP_HeadDots = v end)
addToggle(espTab, "Overhead Name", false, function(v) State.ESP_Names = v end)
addToggle(espTab, "Team Check", false, function(v) State.ESP_TeamCheck = v end)

-- RESO TAB
addToggle(resoTab, "Mode Gepeng FiveM Real", false, function(v) 
    State.RealGepengEnabled = v 
    if not v and not State.LYR360Enabled then Camera.FieldOfView = 70 end
end)
addSlider(resoTab, "Tingkat Gepeng Ekstrem", 10, 80, 35, function(v) State.GepengRatio = v / 100 end)
addToggle(resoTab, "Mode LYR 360%", false, function(v) 
    State.LYR360Enabled = v 
    if not v and not State.RealGepengEnabled then Camera.FieldOfView = 70 end
end)
addSlider(resoTab, "FOVs 360 Wide", 80, 160, 135, function(v) State.LYR360Val = v end)

-- MOVEMENT TAB
addSlider(moveTab, "Walk Speed", 16, 500, 30, function(v) State.WalkSpeedVal = v end)
addSlider(moveTab, "Jump Power", 50, 1000, 100, function(v) State.JumpPowerVal = v end)
addToggle(moveTab, "Super Smooth Movement", false, function(v) State.SmoothMovement = v end)
addToggle(moveTab, "FiveM Blink (Lag POV)", false, function(v) State.FiveMBlink = v end)
addToggle(moveTab, "Infinite Jump", false, function(v) State.InfiniteJump = v end)
addToggle(moveTab, "Noclip Mode", false, function(v) State.NoclipEnabled = v end)
addToggle(moveTab, "Fly Mode UI", false, function(v) 
    State.FlyEnabled = v 
    flyControls.Visible = v
end)
addSlider(moveTab, "Fly Speed", 20, 500, 100, function(v) State.FlySpeed = v end)
addToggle(moveTab, "Spinbot Karakter", false, function(v) State.SpinBotEnabled = v end)

-- KEYBINDS: ROLLING ('C') & FLASH STEP / TELEPORT DASH ('V')
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed or not State.ScriptActive then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    
    if input.KeyCode == Enum.KeyCode.C and not State.IsRolling then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hrp and hum and hum.MoveDirection.Magnitude > 0 then
            State.IsRolling = true
            task.spawn(function()
                local moveDir = hum.MoveDirection
                for i = 1, 10 do
                    hrp.CFrame = hrp.CFrame + (moveDir * (State.RollingSpeed / 10))
                    task.wait(0.01)
                end
                State.IsRolling = false
            end)
        end
    elseif input.KeyCode == Enum.KeyCode.V and hrp then
        -- Flash Step Dash (Teleport 25 studs ke depan arah pandangan)
        hrp.CFrame = hrp.CFrame + (Camera.CFrame.LookVector * 25)
    end
end)

-- ESP & AIMBOT UTILS
local function getExactTargetPart(character)
    if not character then return nil end
    local selected = State.TargetPart
    if selected == "Head" then return character:FindFirstChild("Head")
    elseif selected == "Torso" then return character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso") or character:FindFirstChild("HumanoidRootPart")
    else return character:FindFirstChild("HumanoidRootPart") end
end

local function checkWallObstructionBrutal(targetPart)
    if not targetPart or not targetPart.Parent then return false end
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    rayParams.FilterDescendantsInstances = {LocalPlayer.Character, targetPart.Parent, Camera}
    local rayResult = Workspace:Raycast(Camera.CFrame.Position, targetPart.Position - Camera.CFrame.Position, rayParams)
    return not rayResult
end

local function isTargetValidForAimbot(targetPart)
    if not targetPart or not targetPart.Parent then return false end
    local char = targetPart.Parent
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return false end

    local plr = Players:GetPlayerFromCharacter(char)
    if plr and State.ESP_TeamCheck and plr.Team == LocalPlayer.Team then return false end

    local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
    if not onScreen or screenPos.Z <= 0 then return false end

    local viewportCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    if (Vector2.new(screenPos.X, screenPos.Y) - viewportCenter).Magnitude > State.FOVRadius then return false end
    
    if State.WallCheck and not checkWallObstructionBrutal(targetPart) then return false end
    return true
end

local function getBestTargetBrutal()
    if CurrentActiveTarget and isTargetValidForAimbot(CurrentActiveTarget) then return CurrentActiveTarget end
    local viewportCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local closestPart, minDistance = nil, State.FOVRadius

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            if State.ESP_TeamCheck and plr.Team == LocalPlayer.Team then continue end
            local targetPart = getExactTargetPart(plr.Character)
            if targetPart and isTargetValidForAimbot(targetPart) then
                local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                if onScreen and screenPos.Z > 0 then
                    local distFromCenter = (Vector2.new(screenPos.X, screenPos.Y) - viewportCenter).Magnitude
                    if distFromCenter < minDistance then
                        closestPart = targetPart; minDistance = distFromCenter
                    end
                end
            end
        end
    end
    CurrentActiveTarget = closestPart
    return closestPart
end

-- ESP SYSTEM
local ESPObjects = {}
local function setupPlayerESP(plr)
    if plr == LocalPlayer or ESPObjects[plr] then return end
    local draw = {
        C1 = Drawing.new("Line"), C2 = Drawing.new("Line"), C3 = Drawing.new("Line"), C4 = Drawing.new("Line"),
        C5 = Drawing.new("Line"), C6 = Drawing.new("Line"), C7 = Drawing.new("Line"), C8 = Drawing.new("Line"),
        HealthBarOutline = Drawing.new("Square"), HealthBar = Drawing.new("Square"),
        HeadDot = Drawing.new("Circle"), NameText = Drawing.new("Text"), Tracer = Drawing.new("Line")
    }
    for _, d in pairs(draw) do d.Visible = false end
    ESPObjects[plr] = {Player = plr, Drawing = draw}
end

for _, p in ipairs(Players:GetPlayers()) do setupPlayerESP(p) end
table.insert(_G.JelyzxConnections, Players.PlayerAdded:Connect(setupPlayerESP))

local function updateESPPosition()
    local viewX, viewY = Camera.ViewportSize.X, Camera.ViewportSize.Y

    for plr, data in pairs(ESPObjects) do
        local draw = data.Drawing
        local char = plr.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local head = char and char:FindFirstChild("Head")
        local hum = char and char:FindFirstChildOfClass("Humanoid")

        if char and hrp and head and hum and hum.Health > 0 then
            -- Chams Highlight Implementation
            local highlight = char:FindFirstChild("JelyzxChams")
            if State.ESP_Chams then
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "JelyzxChams"
                    highlight.Parent = char
                end
                highlight.FillColor = State.ESPColor
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.Enabled = true
            elseif highlight then
                highlight.Enabled = false
            end

            local hrpPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            if onScreen and hrpPos.Z > 0 then
                local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                local legPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                local height = math.abs(headPos.Y - legPos.Y)
                local width = height * 0.65
                local minX, minY = hrpPos.X - (width / 2), headPos.Y

                if State.ESP_CornerBox then
                    local lineLen = width * 0.25
                    draw.C1.From = Vector2.new(minX, minY); draw.C1.To = Vector2.new(minX + lineLen, minY); draw.C1.Color = State.ESPColor; draw.C1.Visible = true
                    draw.C2.From = Vector2.new(minX, minY); draw.C2.To = Vector2.new(minX, minY + lineLen); draw.C2.Color = State.ESPColor; draw.C2.Visible = true
                    draw.C3.From = Vector2.new(minX + width, minY); draw.C3.To = Vector2.new(minX + width - lineLen, minY); draw.C3.Color = State.ESPColor; draw.C3.Visible = true
                    draw.C4.From = Vector2.new(minX + width, minY); draw.C4.To = Vector2.new(minX + width, minY + lineLen); draw.C4.Color = State.ESPColor; draw.C4.Visible = true
                else
                    for i = 1, 4 do draw["C"..i].Visible = false end
                end

                if State.ESP_Names then
                    draw.NameText.Text = string.format("%s [%dm]", plr.Name, math.floor((Camera.CFrame.Position - hrp.Position).Magnitude))
                    draw.NameText.Position = Vector2.new(hrpPos.X, minY - 14)
                    draw.NameText.Color = Color3.fromRGB(255, 255, 255)
                    draw.NameText.Visible = true
                else
                    draw.NameText.Visible = false
                end
            end
        else
            for _, item in pairs(draw) do item.Visible = false end
        end
    end
end

-- RENDER LOOP
table.insert(_G.JelyzxConnections, RunService.RenderStepped:Connect(function(deltaTime)
    if not State.ScriptActive then return end

    local baseCFrame = Camera.CFrame
    local targetPart = getBestTargetBrutal()

    if State.AimbotEnabled and targetPart then
        local targetPos = targetPart.Position
        if State.Prediction and targetPart.Parent and targetPart.Parent:FindFirstChild("HumanoidRootPart") then
            targetPos = targetPos + (targetPart.Parent.HumanoidRootPart.AssemblyLinearVelocity * State.PredictionMult)
        end

        local targetCFrame = CFrame.lookAt(Camera.CFrame.Position, targetPos)

        if not State.SilentAim then
            if State.DirectLock then
                baseCFrame = targetCFrame
            else
                local smoothness = math.clamp(State.Smoothness * 50, 1, 50)
                baseCFrame = Camera.CFrame:Lerp(targetCFrame, math.clamp(1 - math.exp(-smoothness * deltaTime), 0.01, 1))
            end
        end

        if State.TargetSnapline then
            local tPos = Camera:WorldToViewportPoint(targetPos)
            targetLine.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
            targetLine.To = Vector2.new(tPos.X, tPos.Y)
            targetLine.Visible = true
        else
            targetLine.Visible = false
        end
    else
        targetLine.Visible = false
    end

    if State.LYR360Enabled then Camera.FieldOfView = State.LYR360Val end
    if State.RealGepengEnabled then baseCFrame = baseCFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, State.GepengRatio, 0, 0, 0, 1) end

    Camera.CFrame = baseCFrame
    fovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    fovCircle.Radius = State.FOVRadius
    fovCircle.Visible = State.ShowFOV and State.AimbotEnabled

    updateESPPosition()
end))

-- PHYSICS & MOVEMENT LOOP
table.insert(_G.JelyzxConnections, RunService.Stepped:Connect(function()
    if not State.ScriptActive then return end
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")

        if hum then
            hum.WalkSpeed = State.WalkSpeedVal
            hum.JumpPower = State.JumpPowerVal
        end

        if State.NoclipEnabled then
            for _, p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end
    end
end))

-- CLEANUP
closeBtn.MouseButton1Click:Connect(function()
    State.ScriptActive = false
    fovCircle.Visible = false
    targetLine.Visible = false
    for _, conn in ipairs(_G.JelyzxConnections) do pcall(function() conn:Disconnect() end) end
    gui:Destroy()
end)
