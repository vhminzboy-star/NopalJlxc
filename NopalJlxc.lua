-- ========================================================
-- NOPAL JLXC — CPB JELYZX (FIXED EDITION: FIXED ESP & REAL STRETCH RES)
-- Showcase Logo: https://create.roblox.com/store/asset/129775661697970
-- Background Logo: https://create.roblox.com/store/asset/111989994218720
-- ========================================================

if _G.JelyzxConnections then
    for _, conn in ipairs(_G.JelyzxConnections) do
        pcall(function() conn:Disconnect() end)
    end
end
_G.JelyzxConnections = {}

local function generateRandomName(length)
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local res = ""
    for i = 1, (length or 14) do
        local rand = math.random(1, #chars)
        res = res .. string.sub(chars, rand, rand)
    end
    return res
end

local SECURE_GUI_NAME = generateRandomName(18)

-- Safe Service Retrieval
local function getService(name)
    local s
    pcall(function() s = game:GetService(name) end)
    return s
end

local Players = getService("Players")
local UserInputService = getService("UserInputService")
local RunService = getService("RunService")
local CoreGui = getService("CoreGui")
local Workspace = getService("Workspace")
local VirtualUser = getService("VirtualUser")
local TweenService = getService("TweenService")
local SoundService = getService("SoundService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local function getGuiParent()
    local parent = nil
    pcall(function() if gethui then parent = gethui() end end)
    if not parent then
        pcall(function()
            if syn and syn.protect_gui then
                parent = Instance.new("Folder")
                syn.protect_gui(parent)
                parent.Parent = CoreGui
            end
        end)
    end
    return parent or (LocalPlayer:WaitForChild("PlayerGui", 5) or CoreGui)
end

local parentGui = getGuiParent()

for _, old in ipairs(parentGui:GetChildren()) do
    if old:IsA("ScreenGui") and old:FindFirstChild("IntroOverlay") then
        pcall(function() old:Destroy() end)
    end
end

local RAW_ID = "111989994218720"
local SHOWCASE_ID = "129775661697970"
local CUSTOM_LOGO_ID = "rbxthumb://type=Asset&id=" .. RAW_ID .. "&w=420&h=420"
local SHOWCASE_LOGO_ID = "rbxthumb://type=Asset&id=" .. SHOWCASE_ID .. "&w=420&h=420"

local function playSound(soundId, volume)
    task.spawn(function()
        pcall(function()
            local sound = Instance.new("Sound")
            sound.SoundId = "rbxassetid://" .. tostring(soundId)
            sound.Volume = volume or 0.5
            sound.Parent = SoundService
            sound:Play()
            sound.Ended:Connect(function() sound:Destroy() end)
        end)
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

local State = {
    AimjlxcEnabled = false,
    Smoothness = 0.15, 
    DirectLock = false,
    TargetPart = "Head",
    WallCheck = false,
    AimPOVRadius = 150,
    ShowAimPOV = false,
    AimPOVColor = Color3.fromRGB(0, 240, 255),
    Prediction = false, 
    PredictionMult = 0.013,
    LockColor = Color3.fromRGB(255, 30, 30),
    
    SpawnFullHealth = false,
    AntiSpectateAdmin = false,

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
    ESP_TeamCheck = false,
    ESP_MaxDistance = 999999,
    ESPColor = Color3.fromRGB(0, 240, 255),
    ESPRGB = false,

    HitboxExpander = false,
    HitboxSize = 15,

    LYR360Enabled = false,
    LYR360Val = 90,

    RealGepengEnabled = false,
    GepengRatio = 0.5,

    WalkSpeedVal = 16,
    JumpPowerVal = 50,
    NoclipEnabled = false,
    InfiniteJump = false,
    FlyEnabled = false,
    FlySpeed = 50,
    FlyUp = false,
    FlyDown = false,

    FreecamEnabled = false,
    FreecamSpeed = 2,
    FreecamSens = 1.2,
    FreecamUIScale = 1.0,
    FreecamDir = { Forward = false, Backward = false, Left = false, Right = false, Up = false, Down = false },

    SpectateEnabled = false,
    SpectateTargetIndex = 1,
    SpectateTargetPlayer = nil,
    SpectateUIScale = 1.0,
    SpectateCardCollapsed = false,

    SmoothMovement = false,
    SmoothFactor = 0.25,
    FiveMBlink = false,
    BlinkIntensity = 10,
    RollingSpeed = 45,
    IsRolling = false,

    SpinBotEnabled = false,
    SpinSpeed = 30,

    AntiAFK = true,
    ScriptActive = true
}

local ColorGold = Color3.fromRGB(255, 215, 0)
local ColorGodmode = Color3.fromRGB(255, 0, 128)

-- FIXED: Sichere Welt-zu-Bildschirm Koordinatenberechnung
local function worldToAdjustedViewportPoint(pos)
    local screenPos, onScreen = Camera:WorldToViewportPoint(pos)
    return screenPos, (onScreen and screenPos.Z > 0)
end

local function isAdminPlayer(plr)
    if not plr then return false end
    local res = false
    pcall(function()
        if game.PlaceId and plr:GetRankInGroup(game.PlaceId) > 100 then res = true end
    end)
    if res then return true end
    local name = plr.Name:lower()
    if name:find("admin") or name:find("mod") or name:find("owner") or name:find("dev") or name:find("staff") then return true end
    if plr.Character and (plr.Character:FindFirstChild("AdminTitle") or plr.Character:FindFirstChild("StaffTag")) then return true end
    return false
end

local function isGodmodePlayer(plr)
    if not plr or not plr.Character then return false end
    local hum = plr.Character:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    if hum.Health > hum.MaxHealth or hum.MaxHealth > 10000 then return true end
    if plr.Character:FindFirstChildOfClass("ForceField") then return true end
    return false
end

local CurrentActiveTarget = nil

local function safeDrawingNew(class)
    local obj = nil
    pcall(function()
        if Drawing and Drawing.new then
            obj = Drawing.new(class)
        end
    end)
    return obj
end

local aimPovCircle = safeDrawingNew("Circle")
if aimPovCircle then
    aimPovCircle.Thickness = 1.5
    aimPovCircle.NumSides = 64
    aimPovCircle.Filled = false
    aimPovCircle.Transparency = 0.85
    aimPovCircle.Color = State.AimPOVColor
    aimPovCircle.Visible = State.ShowAimPOV
end

local chLines = {}
for i = 1, 4 do
    local l = safeDrawingNew("Line")
    if l then
        l.Thickness = 1.5
        l.Visible = false
        chLines[i] = l
    end
end

local chCircle = safeDrawingNew("Circle")
if chCircle then
    chCircle.Thickness = 1.5
    chCircle.Filled = false
    chCircle.Visible = false
end

local function hideAllCrosshair()
    for _, l in ipairs(chLines) do if l then l.Visible = false end end
    if chCircle then chCircle.Visible = false end
end

local gui = Instance.new("ScreenGui")
gui.Name = SECURE_GUI_NAME
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = parentGui

-- MAIN PANEL & UI CREATION
local main = Instance.new("Frame")
main.Name = generateRandomName(12)
main.Size = UDim2.new(0, 0, 0, 0)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(11, 13, 20)
main.BackgroundTransparency = 0.25
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Visible = false
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = Color3.fromRGB(255, 45, 65)
mainStroke.Thickness = 1.8
mainStroke.Transparency = 0.15

-- INTRO OVERLAY
local introBg = Instance.new("Frame")
introBg.Name = "IntroOverlay"
introBg.Size = UDim2.new(1, 0, 1, 0)
introBg.BackgroundColor3 = Color3.fromRGB(3, 4, 7)
introBg.BackgroundTransparency = 0.1
introBg.BorderSizePixel = 0
introBg.Parent = gui

local introCard = Instance.new("Frame")
introCard.Size = UDim2.new(0, 380, 0, 200)
introCard.Position = UDim2.new(0.5, 0, 0.5, 20)
introCard.AnchorPoint = Vector2.new(0.5, 0.5)
introCard.BackgroundColor3 = Color3.fromRGB(10, 12, 18)
introCard.BackgroundTransparency = 0.15
introCard.BorderSizePixel = 0
introCard.ClipsDescendants = false
introCard.Parent = introBg
Instance.new("UICorner", introCard).CornerRadius = UDim.new(0, 16)

local introTitle = Instance.new("TextLabel")
introTitle.Size = UDim2.new(1, 0, 0, 26)
introTitle.Position = UDim2.new(0, 0, 0, 50)
introTitle.BackgroundTransparency = 1
introTitle.Font = Enum.Font.GothamBlack
introTitle.Text = "<font color=\"#FFFFFF\">NOPAL</font> <font color=\"#FF2D41\">JLXC</font> <font color=\"#00F0FF\">SYSTEM</font>"
introTitle.RichText = true
introTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
introTitle.TextSize = 17
introTitle.Parent = introCard

task.spawn(function()
    task.wait(0.5)
    introBg:Destroy()
    main.Visible = true
    playSound(SOUND_UI_OPEN, 0.7)
    TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 420, 0, 260)
    }):Play()
end)

-- TOP BAR
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 38)
topBar.BackgroundTransparency = 1
topBar.Parent = main

local titleLbl = Instance.new("TextLabel")
titleLbl.Size = UDim2.new(0, 300, 1, 0)
titleLbl.Position = UDim2.new(0, 16, 0, 0)
titleLbl.BackgroundTransparency = 1
titleLbl.Font = Enum.Font.GothamBlack
titleLbl.Text = "NOPAL <font color=\"#FF2D41\">JLXC</font> <font color=\"#808080\">|</font> <font color=\"#808080\">FIXED EDITION</font>"
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
    return frame
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
    return frame
end

-- TABS SETUP
local combatTab = createTab("Combat")
local visualTab = createTab("Visual & Display")
local espTab = createTab("ESP Config")

-- VISUAL TAB CONFIG
addToggle(visualTab, "Layar Gepeng (FiveM Stretch Res)", State.RealGepengEnabled, function(v)
    State.RealGepengEnabled = v
    if not v then
        Camera.FieldOfView = 70
    end
end)

addSlider(visualTab, "Intensitas Gepeng", 10, 90, math.floor(State.GepengRatio * 100), function(v)
    State.GepengRatio = v / 100
end)

-- ESP CONFIG & SYSTEM
addToggle(espTab, "Corner Box ESP", State.ESP_CornerBox, function(v) State.ESP_CornerBox = v end)
addToggle(espTab, "Health Bar ESP", State.ESP_HealthBar, function(v) State.ESP_HealthBar = v end)
addToggle(espTab, "Skeleton ESP", State.ESP_Skeleton, function(v) State.ESP_Skeleton = v end)
addToggle(espTab, "Tracers ESP", State.ESP_Tracers, function(v) State.ESP_Tracers = v end)

local ESPObjects = {}
local function removePlayerESP(plr)
    if ESPObjects[plr] then
        for _, obj in pairs(ESPObjects[plr].Drawing) do 
            if obj then pcall(function() obj:Remove() end) end
        end
        ESPObjects[plr] = nil
    end
end

local function setupPlayerESP(plr)
    if plr == LocalPlayer or ESPObjects[plr] then return end
    local draw = {
        C1 = safeDrawingNew("Line"), C2 = safeDrawingNew("Line"),
        C3 = safeDrawingNew("Line"), C4 = safeDrawingNew("Line"),
        C5 = safeDrawingNew("Line"), C6 = safeDrawingNew("Line"),
        C7 = safeDrawingNew("Line"), C8 = safeDrawingNew("Line"),
        HealthBarOutline = safeDrawingNew("Square"),
        HealthBar = safeDrawingNew("Square"),
        Tracer = safeDrawingNew("Line")
    }
    
    for k, v in pairs(draw) do
        if v then
            v.Visible = false
            v.Thickness = 1.5
        end
    end
    
    ESPObjects[plr] = {Player = plr, Drawing = draw}
end

for _, p in ipairs(Players:GetPlayers()) do setupPlayerESP(p) end
table.insert(_G.JelyzxConnections, Players.PlayerAdded:Connect(setupPlayerESP))
table.insert(_G.JelyzxConnections, Players.PlayerRemoving:Connect(removePlayerESP))

-- FIXED RENDER LOOP: Stabilized FOV Stretch Res & Correct ESP Alignment
local mainRenderConn = RunService.RenderStepped:Connect(function()
    if not State.ScriptActive then return end

    -- FIXED: Stretch Res via FOV Stretching (FiveM Style)
    if State.RealGepengEnabled then
        local targetFov = 70 + ((1 - State.GepengRatio) * 45)
        Camera.FieldOfView = math.clamp(targetFov, 70, 120)
    end

    -- FIXED: Safe ESP Drawing Update Loop
    local viewX, viewY = Camera.ViewportSize.X, Camera.ViewportSize.Y

    for plr, data in pairs(ESPObjects) do
        local draw = data.Drawing
        local char = plr.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local head = char and char:FindFirstChild("Head")
        local hum = char and char:FindFirstChildOfClass("Humanoid")

        if char and hrp and head and hum and hum.Health > 0 then
            local hrpPos, onScreen = worldToAdjustedViewportPoint(hrp.Position)
            
            if onScreen then
                local headPos = worldToAdjustedViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                local legPos = worldToAdjustedViewportPoint(hrp.Position - Vector3.new(0, 3, 0))

                local height = math.abs(headPos.Y - legPos.Y)
                local width = height * 0.6
                local minX, minY = hrpPos.X - (width / 2), headPos.Y
                local activeColor = State.ESPColor

                -- Corner Box Rendering
                if State.ESP_CornerBox then
                    local l = width * 0.25
                    if draw.C1 then draw.C1.From = Vector2.new(minX, minY); draw.C1.To = Vector2.new(minX + l, minY); draw.C1.Color = activeColor; draw.C1.Visible = true end
                    if draw.C2 then draw.C2.From = Vector2.new(minX, minY); draw.C2.To = Vector2.new(minX, minY + l); draw.C2.Color = activeColor; draw.C2.Visible = true end
                    if draw.C3 then draw.C3.From = Vector2.new(minX + width, minY); draw.C3.To = Vector2.new(minX + width - l, minY); draw.C3.Color = activeColor; draw.C3.Visible = true end
                    if draw.C4 then draw.C4.From = Vector2.new(minX + width, minY); draw.C4.To = Vector2.new(minX + width, minY + l); draw.C4.Color = activeColor; draw.C4.Visible = true end
                else
                    for i = 1, 8 do if draw["C"..i] then draw["C"..i].Visible = false end end
                end

                -- Health Bar Rendering
                if State.ESP_HealthBar and draw.HealthBar then
                    local pct = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                    draw.HealthBar.Size = Vector2.new(2, height * pct)
                    draw.HealthBar.Position = Vector2.new(minX - 5, minY + (height * (1 - pct)))
                    draw.HealthBar.Color = Color3.fromHSV(pct * 0.3, 1, 1)
                    draw.HealthBar.Visible = true
                else
                    if draw.HealthBar then draw.HealthBar.Visible = false end
                end

                -- Tracer Line Rendering
                if State.ESP_Tracers and draw.Tracer then
                    draw.Tracer.From = Vector2.new(viewX / 2, viewY)
                    draw.Tracer.To = Vector2.new(hrpPos.X, hrpPos.Y)
                    draw.Tracer.Color = activeColor
                    draw.Tracer.Visible = true
                else
                    if draw.Tracer then draw.Tracer.Visible = false end
                end
            else
                for _, obj in pairs(draw) do if obj then obj.Visible = false end end
            end
        else
            for _, obj in pairs(draw) do if obj then obj.Visible = false end end
        end
    end
end)
table.insert(_G.JelyzxConnections, mainRenderConn)

-- CLEANUP
closeBtn.MouseButton1Click:Connect(function()
    State.ScriptActive = false
    Camera.FieldOfView = 70
    for _, conn in ipairs(_G.JelyzxConnections) do pcall(function() conn:Disconnect() end) end
    table.clear(_G.JelyzxConnections)
    for plr in pairs(ESPObjects) do removePlayerESP(plr) end
    gui:Destroy()
end)
