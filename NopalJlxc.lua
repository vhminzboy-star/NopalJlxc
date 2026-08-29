-- ========================================================
-- NOPAL JLXC — BETA CPB JELYZX (FULL UI RESTORED)
-- Logo Asset: https://create.roblox.com/store/asset/129775661697970
-- ========================================================
if _G.JelyzxConnections then
    for _, conn in ipairs(_G.JelyzxConnections) do
        pcall(function() conn:Disconnect() end)
    end
end
_G.JelyzxConnections = {}

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
local oldGui = parentGui:FindFirstChild("JELYZX_V20_FULL_GUI") or (LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("JELYZX_V20_FULL_GUI"))
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
        sound.Ended:Connect(function()
            sound:Destroy()
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
    AimbotEnabled = false,
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
    
    AutoFarm = false,
    AutoClicker = false,
    SpawnFullHealth = false,
    InvisibleMode = false,
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
    BlinkIntensity = 10,

    SpinBotEnabled = false,
    SpinSpeed = 30,

    SpectateEnabled = false,
    SpectateIndex = 1,

    FreecamEnabled = false,
    FreecamSpeed = 50,
    FreecamUp = false,
    FreecamDown = false,
    FreecamForward = false,
    FreecamBackward = false,
    FreecamLeft = false,
    FreecamRight = false,

    AntiAFK = true,
    ScriptActive = true
}

local ColorGold = Color3.fromRGB(255, 215, 0)
local ColorGodmode = Color3.fromRGB(255, 0, 128)

local CurrentActiveTarget = nil

-- DRAWING FOV & CROSSHAIR
local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 1.5
fovCircle.NumSides = 64
fovCircle.Filled = false
fovCircle.Transparency = 0.8
fovCircle.Color = State.FOVColor
fovCircle.Visible = State.ShowFOV

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

-- MAIN PANEL (DESAIN DISESUAIKAN DENGAN SCREENSHOT)
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 480, 0, 290) -- Ukuran diperbesar agar opsi muat sempurna
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(12, 14, 20)
main.BackgroundTransparency = 0.1
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Visible = true
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(255, 45, 65)
mainStroke.Thickness = 1.5
mainStroke.Parent = main

-- TOP BAR
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 36)
topBar.BackgroundTransparency = 1
topBar.Parent = main

local logoHolder = Instance.new("Frame")
logoHolder.Size = UDim2.new(0, 26, 0, 26)
logoHolder.Position = UDim2.new(0, 8, 0.5, -13)
logoHolder.BackgroundColor3 = Color3.fromRGB(22, 26, 38)
logoHolder.BorderSizePixel = 0
logoHolder.Parent = topBar
Instance.new("UICorner", logoHolder).CornerRadius = UDim.new(0, 6)

local logoIcon = Instance.new("ImageLabel")
logoIcon.Size = UDim2.new(1, -2, 1, -2)
logoIcon.Position = UDim2.new(0, 1, 0, 1)
logoIcon.BackgroundTransparency = 1
logoIcon.Image = SHOWCASE_LOGO_ID
logoIcon.Parent = logoHolder

local titleLbl = Instance.new("TextLabel")
titleLbl.Size = UDim2.new(1, -120, 1, 0)
titleLbl.Position = UDim2.new(0, 42, 0, 0)
titleLbl.BackgroundTransparency = 1
titleLbl.Font = Enum.Font.GothamBlack
titleLbl.Text = "NOPAL <font color=\"#FF2D41\">JLXC</font> <font color=\"#6C7B9B\">| BETA CPB JELYZX</font>"
titleLbl.RichText = true
titleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLbl.TextSize = 11
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

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 20, 0, 20)
minBtn.Position = UDim2.new(1, -52, 0.5, -10)
minBtn.BackgroundColor3 = Color3.fromRGB(40, 48, 70)
minBtn.Text = "-"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 12
minBtn.Parent = topBar
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 5)

-- SIDEBAR & CONTENT AREA
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 110, 1, -44)
sidebar.Position = UDim2.new(0, 8, 0, 38)
sidebar.BackgroundTransparency = 1
sidebar.Parent = main

local sideLayout = Instance.new("UIListLayout")
sideLayout.Padding = UDim.new(0, 5)
sideLayout.Parent = sidebar

local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, -132, 1, -44)
contentArea.Position = UDim2.new(0, 124, 0, 38)
contentArea.BackgroundTransparency = 1
contentArea.Parent = main

local menuVisible = true
minBtn.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    sidebar.Visible = menuVisible
    contentArea.Visible = menuVisible
    main.Size = menuVisible and UDim2.new(0, 480, 0, 290) or UDim2.new(0, 480, 0, 36)
    minBtn.Text = menuVisible and "-" or "+"
end)

-- DRAGGING LOGIC
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

-- TAB GENERATOR
local tabs = {}
local function createTab(name)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, 0, 0, 26)
    tabBtn.BackgroundColor3 = Color3.fromRGB(18, 22, 32)
    tabBtn.BackgroundTransparency = 0.2
    tabBtn.Text = name
    tabBtn.TextColor3 = Color3.fromRGB(150, 160, 185)
    tabBtn.Font = Enum.Font.GothamMedium
    tabBtn.TextSize = 9.5
    tabBtn.Parent = sidebar
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 6)

    local container = Instance.new("ScrollingFrame")
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.ScrollBarThickness = 3
    container.ScrollBarImageColor3 = Color3.fromRGB(255, 45, 65)
    container.Visible = false
    container.Parent = contentArea
    container.CanvasSize = UDim2.new(0, 0, 0, 0)
    container.AutomaticCanvasSize = Enum.AutomaticSize.Y

    local containerLayout = Instance.new("UIListLayout")
    containerLayout.Padding = UDim.new(0, 6)
    containerLayout.Parent = container

    tabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(tabs) do
            t.Btn.BackgroundColor3 = Color3.fromRGB(18, 22, 32)
            t.Btn.TextColor3 = Color3.fromRGB(150, 160, 185)
            t.Container.Visible = false
        end
        tabBtn.BackgroundColor3 = Color3.fromRGB(255, 45, 65)
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        container.Visible = true
    end)

    table.insert(tabs, {Btn = tabBtn, Container = container})
    if #tabs == 1 then
        tabBtn.BackgroundColor3 = Color3.fromRGB(255, 45, 65)
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        container.Visible = true
    end
    return container
end

-- UI CONTROLS GENERATOR
local function addToggle(parent, text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -8, 0, 22)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.75, 0, 1, 0)
    lbl.Position = UDim2.new(0, 2, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextColor3 = Color3.fromRGB(220, 225, 240)
    lbl.TextSize = 9.5
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame

    local switch = Instance.new("TextButton")
    switch.Size = UDim2.new(0, 28, 0, 14)
    switch.Position = UDim2.new(1, -30, 0.5, -7)
    switch.BackgroundColor3 = default and Color3.fromRGB(255, 45, 65) or Color3.fromRGB(35, 42, 55)
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
        if state then playSound(SOUND_TOGGLE_ON, 0.5) else playSound(SOUND_TOGGLE_OFF, 0.5) end
        switch.BackgroundColor3 = state and Color3.fromRGB(255, 45, 65) or Color3.fromRGB(35, 42, 55)
        dot.Position = state and UDim2.new(1, -12, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)
        callback(state)
    end)
end

local function addSlider(parent, text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -8, 0, 26)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.6, 0, 0, 12)
    lbl.Position = UDim2.new(0, 2, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextColor3 = Color3.fromRGB(220, 225, 240)
    lbl.TextSize = 9.5
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame

    local valInput = Instance.new("TextLabel")
    valInput.Size = UDim2.new(0.35, -4, 0, 12)
    valInput.Position = UDim2.new(0.65, 0, 0, 0)
    valInput.BackgroundTransparency = 1
    valInput.Text = tostring(default)
    valInput.Font = Enum.Font.GothamBold
    valInput.TextColor3 = Color3.fromRGB(255, 45, 65)
    valInput.TextSize = 9.5
    valInput.TextXAlignment = Enum.TextXAlignment.Right
    valInput.Parent = frame

    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -4, 0, 4)
    track.Position = UDim2.new(0, 2, 0, 18)
    track.BackgroundColor3 = Color3.fromRGB(35, 42, 55)
    track.Parent = frame
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame")
    local pct = math.clamp((default - min) / (max - min), 0, 1)
    fill.Size = UDim2.new(pct, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(255, 45, 65)
    fill.Parent = track
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

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
    frame.Size = UDim2.new(1, -8, 0, 22)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.5, 0, 1, 0)
    lbl.Position = UDim2.new(0, 2, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextColor3 = Color3.fromRGB(220, 225, 240)
    lbl.TextSize = 9.5
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 95, 0, 18)
    btn.Position = UDim2.new(1, -97, 0.5, -9)
    btn.BackgroundColor3 = Color3.fromRGB(22, 28, 40)
    btn.Text = options[defaultIndex] .. " ▼"
    btn.TextColor3 = Color3.fromRGB(255, 45, 65)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 8.5
    btn.Parent = frame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

    local currIndex = defaultIndex
    btn.MouseButton1Click:Connect(function()
        currIndex = (currIndex % #options) + 1
        btn.Text = options[currIndex] .. " ▼"
        callback(options[currIndex])
    end)
end

-- TABS POPULATION (SESUAI GAMBAR DENGAN SEMUA OPSI)
local combatTab     = createTab("Combat")
local espTab        = createTab("ESP Config")
local moveTab       = createTab("Movement")
local autoTab       = createTab("Automation")
local visualTab     = createTab("Visuals")

local colorList = {"Biru Cyan", "Hijau Neon", "Merah", "Kuning", "Ungu", "Pink Neon", "Oranye", "Putih", "Emas", "Lime", "Biru Tua"}

-- COMBAT
addToggle(combatTab, "Camera Lock (Aimbot)", false, function(v) State.AimbotEnabled = v end)
addSlider(combatTab, "Smoothness Speed", 1, 50, 5, function(v) State.Smoothness = v / 50 end)
addToggle(combatTab, "Instant Lock Mode", false, function(v) State.DirectLock = v end)
addToggle(combatTab, "Movement Prediction", false, function(v) State.Prediction = v end)
addToggle(combatTab, "Wall Check", false, function(v) State.WallCheck = v end)
addSelector(combatTab, "Target Part", {"Head", "Torso", "HumanoidRootPart"}, 1, function(v) State.TargetPart = v end)
addToggle(combatTab, "Show FOV Circle", false, function(v) State.ShowFOV = v end)
addSlider(combatTab, "FOV Radius", 50, 1500, 150, function(v) State.FOVRadius = v end)
addSelector(combatTab, "Warna FOV Circle", colorList, 1, function(v) State.FOVColor = ColorMap[v] or Color3.fromRGB(0, 240, 255) end)

-- ESP CONFIG
addToggle(espTab, "Precision Box ESP", false, function(v) State.ESP_CornerBox = v end)
addToggle(espTab, "Health Bar ESP", false, function(v) State.ESP_HealthBar = v end)
addToggle(espTab, "Skeleton ESP", false, function(v) State.ESP_Skeleton = v end)
addToggle(espTab, "Snapline Tracer", false, function(v) State.ESP_Tracers = v end)
addSelector(espTab, "Posisi Line Tracer", {"Bawah Tengah", "Tengah Tengah", "Atas Tengah"}, 1, function(v) State.ESP_TracerPos = v end)
addSelector(espTab, "Warna Utama ESP/Tracer", colorList, 1, function(v) State.ESPColor = ColorMap[v] or Color3.fromRGB(0, 240, 255) end)
addToggle(espTab, "Head Dot ESP", false, function(v) State.ESP_HeadDots = v end)
addToggle(espTab, "Overhead Name", false, function(v) State.ESP_Names = v end)
addToggle(espTab, "Team Check", false, function(v) State.ESP_TeamCheck = v end)

-- MOVEMENT
addSlider(moveTab, "Walk Speed Bypass", 16, 300, 16, function(v) State.WalkSpeedVal = v end)
addSlider(moveTab, "Jump Power", 50, 1000, 50, function(v) State.JumpPowerVal = v end)
addToggle(moveTab, "Super Smooth Movement", false, function(v) State.SmoothMovement = v end)
addToggle(moveTab, "FiveM Blink", false, function(v) State.FiveMBlink = v end)
addToggle(moveTab, "Infinite Jump", false, function(v) State.InfiniteJump = v end)
addToggle(moveTab, "Noclip Mode", false, function(v) State.NoclipEnabled = v end)
addToggle(moveTab, "Fly Mode UI", false, function(v) State.FlyEnabled = v end)
addSlider(moveTab, "Fly Speed", 20, 500, 100, function(v) State.FlySpeed = v end)
addToggle(moveTab, "Spinbot Karakter", false, function(v) State.SpinBotEnabled = v end)

-- AUTOMATION
addToggle(autoTab, "Auto Farm", false, function(v) State.AutoFarm = v end)
addToggle(autoTab, "Auto Clicker", false, function(v) State.AutoClicker = v end)
addToggle(autoTab, "Spawn Instant Full Health", false, function(v) State.SpawnFullHealth = v end)
addToggle(autoTab, "Anti-Spectate Admin/Staff", false, function(v) State.AntiSpectateAdmin = v end)

-- VISUALS & RESOLUSI
addToggle(visualTab, "Mode Gepeng FiveM Real", false, function(v) State.RealGepengEnabled = v if not v then Camera.FieldOfView = 70 end end)
addSlider(visualTab, "Tingkat Gepeng", 10, 80, 35, function(v) State.GepengRatio = v / 100 end)
addToggle(visualTab, "Mode LYR 360%", false, function(v) State.LYR360Enabled = v if not v then Camera.FieldOfView = 70 end end)
addSlider(visualTab, "FOVs 360 Wide", 80, 160, 135, function(v) State.LYR360Val = v end)
addToggle(visualTab, "Show Custom Crosshair", false, function(v) State.CustomCrosshair = v end)
addSelector(visualTab, "Model Crosshair", {"Silang (+)", "Dot (.)", "Kotak (Square)"}, 1, function(v) State.CrosshairType = v end)

-- RENDER & PHYSICS ENGINE (AIMBOT, ESP, & MOVEMENT)
local function isCharacterAlive(char)
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    return hum and hum.Health > 0
end

local function getExactTargetPart(character)
    if not character then return nil end
    local selected = State.TargetPart
    if selected == "Head" then
        return character:FindFirstChild("Head")
    elseif selected == "Torso" then
        return character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso") or character:FindFirstChild("HumanoidRootPart")
    else
        return character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso") or character:FindFirstChild("Head")
    end
end

local function getBestTarget()
    local viewportCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local closestPart, minDistance = nil, State.FOVRadius

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and isCharacterAlive(plr.Character) then
            if State.ESP_TeamCheck and plr.Team == LocalPlayer.Team then continue end
            local targetPart = getExactTargetPart(plr.Character)
            if targetPart then
                local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                if onScreen and screenPos.Z > 0 then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - viewportCenter).Magnitude
                    if dist < minDistance then
                        closestPart = targetPart
                        minDistance = dist
                    end
                end
            end
        end
    end
    CurrentActiveTarget = closestPart
    return closestPart
end

table.insert(_G.JelyzxConnections, RunService.RenderStepped:Connect(function(deltaTime)
    if not State.ScriptActive then return end

    if State.AimbotEnabled then
        local targetPart = getBestTarget()
        if targetPart then
            local targetPos = targetPart.Position
            if State.Prediction and targetPart.Parent then
                local hrp = targetPart.Parent:FindFirstChild("HumanoidRootPart")
                if hrp then targetPos = targetPos + (hrp.AssemblyLinearVelocity * State.PredictionMult) end
            end
            local targetCFrame = CFrame.lookAt(Camera.CFrame.Position, targetPos)
            if State.DirectLock then
                Camera.CFrame = targetCFrame
            else
                Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, math.clamp(State.Smoothness * 30 * deltaTime, 0.01, 1))
            end
        end
    end

    if State.LYR360Enabled then
        Camera.FieldOfView = State.LYR360Val
    end

    local viewportCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    fovCircle.Position = viewportCenter
    fovCircle.Radius = State.FOVRadius
    fovCircle.Color = CurrentActiveTarget and State.LockColor or State.FOVColor
    fovCircle.Visible = State.ShowFOV and State.AimbotEnabled
end))

-- PHYSICS LOOP
table.insert(_G.JelyzxConnections, RunService.Stepped:Connect(function()
    if not State.ScriptActive then return end
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hum and hrp then
            hum.WalkSpeed = State.WalkSpeedVal
            hum.JumpPower = State.JumpPowerVal
            if State.NoclipEnabled then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end
    end
end))

-- CLEANUP & CLOSE
closeBtn.MouseButton1Click:Connect(function()
    State.ScriptActive = false
    fovCircle.Visible = false
    hideAllCrosshair()
    pcall(function() fovCircle:Remove() end)
    for _, conn in ipairs(_G.JelyzxConnections) do pcall(function() conn:Disconnect() end) end
    table.clear(_G.JelyzxConnections)
    gui:Destroy()
end)
