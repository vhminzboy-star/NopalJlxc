-- ========================================================
-- NOPAL JLXC — BETA CPB JELYZX (FIXED ESP DELAY & ORIGINAL UI)
-- Showcase Logo: https://create.roblox.com/store/asset/129775661697970
-- Background Logo: https://create.roblox.com/store/asset/111989994218720
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

    HitboxExpander = false,
    HitboxSize = 2,

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
    RollingSpeed = 45,
    IsRolling = false,

    SpinBotEnabled = false,
    SpinSpeed = 30,

    SpectateEnabled = false,
    SpectateIndex = 1,
    SpectateHidden = false,

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

local function isAdminPlayer(plr)
    if not plr then return false end
    pcall(function()
        if game.PlaceId and plr:GetRankInGroup(game.PlaceId) > 100 then return true end
    end)
    local name = plr.Name:lower()
    if name:find("admin") or name:find("mod") or name:find("owner") or name:find("dev") or name:find("staff") then return true end
    return false
end

local function isGodmodePlayer(plr)
    if not plr or not plr.Character then return false end
    local hum = plr.Character:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    if hum.Health > hum.MaxHealth or hum.MaxHealth > 10000 then return true end
    return false
end

local CurrentActiveTarget = nil

-- DRAWING FOV & CROSSHAIR
local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 1
fovCircle.NumSides = 48
fovCircle.Filled = false
fovCircle.Transparency = 0.8
fovCircle.Color = State.FOVColor
fovCircle.Visible = State.ShowFOV

local chLines = {}
for i = 1, 4 do
    local l = Drawing.new("Line")
    l.Thickness = 1.2
    l.Visible = false
    chLines[i] = l
end

local chCircle = Drawing.new("Circle")
chCircle.Thickness = 1.2
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

-- SPECTATE WATERMARK
local specWatermark = Instance.new("TextLabel")
specWatermark.Name = "SpecWatermark"
specWatermark.Size = UDim2.new(0, 180, 0, 20)
specWatermark.Position = UDim2.new(1, -190, 0, 8)
specWatermark.BackgroundColor3 = Color3.fromRGB(12, 14, 20)
specWatermark.BackgroundTransparency = 0.3
specWatermark.Font = Enum.Font.GothamBold
specWatermark.Text = "SPECTATING: OFF"
specWatermark.TextColor3 = Color3.fromRGB(0, 240, 255)
specWatermark.TextSize = 9
specWatermark.Visible = false
specWatermark.Parent = gui
Instance.new("UICorner", specWatermark).CornerRadius = UDim.new(0, 4)

-- FLY CONTROLS
local flyControls = Instance.new("Frame")
flyControls.Name = "ModernFlyUI"
flyControls.Size = UDim2.new(0, 50, 0, 110)
flyControls.Position = UDim2.new(1, -60, 0.4, 0)
flyControls.BackgroundTransparency = 1
flyControls.Visible = false
flyControls.Parent = gui

local btnUp = Instance.new("TextButton")
btnUp.Size = UDim2.new(0, 44, 0, 44)
btnUp.Position = UDim2.new(0.5, -22, 0, 0)
btnUp.BackgroundColor3 = Color3.fromRGB(15, 20, 30)
btnUp.BackgroundTransparency = 0.2
btnUp.Text = "▲\nUP"
btnUp.TextColor3 = Color3.fromRGB(0, 255, 170)
btnUp.Font = Enum.Font.GothamBold
btnUp.TextSize = 9
btnUp.Parent = flyControls
Instance.new("UICorner", btnUp).CornerRadius = UDim.new(0, 6)

local btnDown = Instance.new("TextButton")
btnDown.Size = UDim2.new(0, 44, 0, 44)
btnDown.Position = UDim2.new(0.5, -22, 0, 52)
btnDown.BackgroundColor3 = Color3.fromRGB(15, 20, 30)
btnDown.BackgroundTransparency = 0.2
btnDown.Text = "▼\nDOWN"
btnDown.TextColor3 = Color3.fromRGB(255, 55, 80)
btnDown.Font = Enum.Font.GothamBold
btnDown.TextSize = 9
btnDown.Parent = flyControls
Instance.new("UICorner", btnDown).CornerRadius = UDim.new(0, 6)

btnUp.MouseButton1Down:Connect(function() State.FlyUp = true end)
btnUp.MouseButton1Up:Connect(function() State.FlyUp = false end)
btnUp.InputEnded:Connect(function() State.FlyUp = false end)
btnDown.MouseButton1Down:Connect(function() State.FlyDown = true end)
btnDown.MouseButton1Up:Connect(function() State.FlyDown = false end)
btnDown.InputEnded:Connect(function() State.FlyDown = false end)

-- SPECTATE SYSTEM UI
local spectateUI = Instance.new("Frame")
spectateUI.Name = "SpectateSystemUI"
spectateUI.Size = UDim2.new(0, 240, 0, 34)
spectateUI.Position = UDim2.new(0.5, 0, 0.82, 0)
spectateUI.AnchorPoint = Vector2.new(0.5, 0.5)
spectateUI.BackgroundColor3 = Color3.fromRGB(12, 14, 20)
spectateUI.BackgroundTransparency = 0.2
spectateUI.Visible = false
spectateUI.Parent = gui
Instance.new("UICorner", spectateUI).CornerRadius = UDim.new(0, 6)

local btnSpecPrev = Instance.new("TextButton")
btnSpecPrev.Size = UDim2.new(0, 30, 1, 0)
btnSpecPrev.Position = UDim2.new(0, 0, 0, 0)
btnSpecPrev.BackgroundTransparency = 1
btnSpecPrev.Text = "◄"
btnSpecPrev.TextColor3 = Color3.fromRGB(0, 240, 255)
btnSpecPrev.Font = Enum.Font.GothamBold
btnSpecPrev.TextSize = 12
btnSpecPrev.Parent = spectateUI

local btnSpecNext = Instance.new("TextButton")
btnSpecNext.Size = UDim2.new(0, 30, 1, 0)
btnSpecNext.Position = UDim2.new(1, -30, 0, 0)
btnSpecNext.BackgroundTransparency = 1
btnSpecNext.Text = "►"
btnSpecNext.TextColor3 = Color3.fromRGB(0, 240, 255)
btnSpecNext.Font = Enum.Font.GothamBold
btnSpecNext.TextSize = 12
btnSpecNext.Parent = spectateUI

local specName = Instance.new("TextLabel")
specName.Size = UDim2.new(1, -60, 0, 16)
specName.Position = UDim2.new(0, 30, 0, 2)
specName.BackgroundTransparency = 1
specName.Font = Enum.Font.GothamBold
specName.Text = "SPECTATING: NONE"
specName.TextColor3 = Color3.fromRGB(255, 255, 255)
specName.TextSize = 9
specName.Parent = spectateUI

local specStatus = Instance.new("TextLabel")
specStatus.Size = UDim2.new(1, -60, 0, 14)
specStatus.Position = UDim2.new(0, 30, 0, 16)
specStatus.BackgroundTransparency = 1
specStatus.Font = Enum.Font.GothamMedium
specStatus.Text = "HP: 100/100"
specStatus.TextColor3 = Color3.fromRGB(0, 255, 150)
specStatus.TextSize = 8
specStatus.Parent = spectateUI

local function getSpectateList()
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(list, p) end
    end
    return list
end

local function updateSpectate()
    if not State.SpectateEnabled then 
        specWatermark.Visible = false
        return 
    end
    
    specWatermark.Visible = true
    local list = getSpectateList()
    if #list == 0 then
        Camera.CameraSubject = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        specName.Text = "NO PLAYERS FOUND"
        specStatus.Text = "-"
        specWatermark.Text = "SPEC: NO PLAYERS"
        return
    end

    if State.SpectateIndex > #list then State.SpectateIndex = 1 end
    if State.SpectateIndex < 1 then State.SpectateIndex = #list end

    local targetPlr = list[State.SpectateIndex]
    if targetPlr and targetPlr.Character and targetPlr.Character:FindFirstChildOfClass("Humanoid") then
        local hum = targetPlr.Character:FindFirstChildOfClass("Humanoid")
        local hrp = targetPlr.Character:FindFirstChild("HumanoidRootPart")
        Camera.CameraSubject = hum
        
        local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local dist = (myHrp and hrp) and math.floor((myHrp.Position - hrp.Position).Magnitude) or 0

        specName.Text = string.format("[%d/%d] %s", State.SpectateIndex, #list, targetPlr.Name:upper())
        specStatus.Text = string.format("HP: %d/%d | DIST: %dm", math.floor(hum.Health), math.floor(hum.MaxHealth), dist)
        specWatermark.Text = string.format("SPEC [%s]: %d HP", targetPlr.Name, math.floor(hum.Health))
    else
        specName.Text = string.format("[%d/%d] %s (DEAD)", State.SpectateIndex, #list, targetPlr.Name:upper())
        specStatus.Text = "DEAD"
        specWatermark.Text = string.format("SPEC [%s]: DEAD", targetPlr.Name)
    end
end

btnSpecNext.MouseButton1Click:Connect(function()
    State.SpectateIndex = State.SpectateIndex + 1
    updateSpectate()
end)

btnSpecPrev.MouseButton1Click:Connect(function()
    State.SpectateIndex = State.SpectateIndex - 1
    updateSpectate()
end)

-- FREECAM TOUCH UI SYSTEM
local freecamUI = Instance.new("Frame")
freecamUI.Name = "FreecamControlsUI"
freecamUI.Size = UDim2.new(1, 0, 1, 0)
freecamUI.BackgroundTransparency = 1
freecamUI.Visible = false
freecamUI.Parent = gui

local freecamDirFrame = Instance.new("Frame")
freecamDirFrame.Size = UDim2.new(0, 100, 0, 100)
freecamDirFrame.Position = UDim2.new(0, 15, 0.65, 0)
freecamDirFrame.BackgroundTransparency = 1
freecamDirFrame.Parent = freecamUI

local function makeFCBtn(name, text, pos)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0, 30, 0, 30)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(15, 20, 30)
    btn.BackgroundTransparency = 0.3
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(0, 240, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 8
    btn.Parent = freecamDirFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

local fcFwd  = makeFCBtn("FC_Fwd", "▲", UDim2.new(0.5, -15, 0, 0))
local fcBack = makeFCBtn("FC_Back", "▼", UDim2.new(0.5, -15, 1, -30))
local fcLeft = makeFCBtn("FC_Left", "◄", UDim2.new(0, 0, 0.5, -15))
local fcRight= makeFCBtn("FC_Right", "►", UDim2.new(1, -30, 0.5, -15))

local function bindTouchBtn(btn, stateKey)
    btn.MouseButton1Down:Connect(function() State[stateKey] = true end)
    btn.MouseButton1Up:Connect(function() State[stateKey] = false end)
    btn.InputEnded:Connect(function() State[stateKey] = false end)
end

bindTouchBtn(fcFwd, "FreecamForward")
bindTouchBtn(fcBack, "FreecamBackward")
bindTouchBtn(fcLeft, "FreecamLeft")
bindTouchBtn(fcRight, "FreecamRight")

local freecamUpDown = Instance.new("Frame")
freecamUpDown.Size = UDim2.new(0, 40, 0, 90)
freecamUpDown.Position = UDim2.new(1, -50, 0.65, 0)
freecamUpDown.BackgroundTransparency = 1
freecamUpDown.Parent = freecamUI

local fcUp = Instance.new("TextButton")
fcUp.Size = UDim2.new(0, 36, 0, 36)
fcUp.Position = UDim2.new(0.5, -18, 0, 0)
fcUp.BackgroundColor3 = Color3.fromRGB(15, 20, 30)
fcUp.BackgroundTransparency = 0.3
fcUp.Text = "▲\nUP"
fcUp.TextColor3 = Color3.fromRGB(0, 255, 170)
fcUp.Font = Enum.Font.GothamBold
fcUp.TextSize = 8
fcUp.Parent = freecamUpDown
Instance.new("UICorner", fcUp).CornerRadius = UDim.new(0, 6)

local fcDown = Instance.new("TextButton")
fcDown.Size = UDim2.new(0, 36, 0, 36)
fcDown.Position = UDim2.new(0.5, -18, 1, -36)
fcDown.BackgroundColor3 = Color3.fromRGB(15, 20, 30)
fcDown.BackgroundTransparency = 0.3
fcDown.Text = "▼\nDN"
fcDown.TextColor3 = Color3.fromRGB(255, 55, 80)
fcDown.Font = Enum.Font.GothamBold
fcDown.TextSize = 8
fcDown.Parent = freecamUpDown
Instance.new("UICorner", fcDown).CornerRadius = UDim.new(0, 6)

bindTouchBtn(fcUp, "FreecamUp")
bindTouchBtn(fcDown, "FreecamDown")

-- MAIN PANEL (DESAIN ASLI / LAMA)
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 360, 0, 210)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(11, 13, 20)
main.BackgroundTransparency = 0.15
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Visible = false
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(255, 45, 65)
mainStroke.Thickness = 1.2
mainStroke.Parent = main

-- INTRO OVERLAY
local introBg = Instance.new("Frame")
introBg.Name = "IntroOverlay"
introBg.Size = UDim2.new(1, 0, 1, 0)
introBg.BackgroundColor3 = Color3.fromRGB(3, 4, 7)
introBg.BackgroundTransparency = 0.1
introBg.BorderSizePixel = 0
introBg.Parent = gui

local introCard = Instance.new("Frame")
introCard.Size = UDim2.new(0, 320, 0, 160)
introCard.Position = UDim2.new(0.5, 0, 0.5, 0)
introCard.AnchorPoint = Vector2.new(0.5, 0.5)
introCard.BackgroundColor3 = Color3.fromRGB(10, 12, 18)
introCard.BackgroundTransparency = 0.15
introCard.BorderSizePixel = 0
introCard.Parent = introBg
Instance.new("UICorner", introCard).CornerRadius = UDim.new(0, 10)

local bgLogoOld = Instance.new("ImageLabel")
bgLogoOld.Size = UDim2.new(1, 0, 1, 0)
bgLogoOld.BackgroundTransparency = 1
bgLogoOld.Image = CUSTOM_LOGO_ID
bgLogoOld.ImageTransparency = 0.25
bgLogoOld.ScaleType = Enum.ScaleType.Fit
bgLogoOld.Parent = introCard

local introTitle = Instance.new("TextLabel")
introTitle.Size = UDim2.new(1, 0, 0, 24)
introTitle.Position = UDim2.new(0, 0, 0, 30)
introTitle.BackgroundTransparency = 1
introTitle.Font = Enum.Font.GothamBlack
introTitle.Text = "<font color=\"#FFFFFF\">NOPAL</font> <font color=\"#FF2D41\">JLXC</font> <font color=\"#00F0FF\">SYSTEM</font>"
introTitle.RichText = true
introTitle.TextSize = 14
introTitle.Parent = introCard

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, 0, 0, 14)
statusText.Position = UDim2.new(0, 0, 0, 60)
statusText.BackgroundTransparency = 1
statusText.Font = Enum.Font.GothamBold
statusText.Text = "LOADING SYSTEM..."
statusText.TextColor3 = Color3.fromRGB(0, 240, 255)
statusText.TextSize = 8.5
statusText.Parent = introCard

local barContainer = Instance.new("Frame")
barContainer.Size = UDim2.new(0, 240, 0, 8)
barContainer.Position = UDim2.new(0.5, -120, 0, 85)
barContainer.BackgroundColor3 = Color3.fromRGB(15, 18, 28)
barContainer.BorderSizePixel = 0
barContainer.Parent = introCard
Instance.new("UICorner", barContainer).CornerRadius = UDim.new(1, 0)

local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(255, 45, 65)
barFill.BorderSizePixel = 0
barFill.Parent = barContainer
Instance.new("UICorner", barFill).CornerRadius = UDim.new(1, 0)

task.spawn(function()
    TweenService:Create(barFill, TweenInfo.new(1.2, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
        Size = UDim2.new(1, 0, 1, 0)
    }):Play()
    task.wait(1.3)
    
    local closeIntro = TweenService:Create(introCard, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0, 0)})
    local fadeBg = TweenService:Create(introBg, TweenInfo.new(0.2), {BackgroundTransparency = 1})
    closeIntro:Play()
    fadeBg:Play()
    closeIntro.Completed:Wait()
    introBg:Destroy()
    
    main.Visible = true
    playSound(SOUND_UI_OPEN, 0.7)
end)

-- TOP BAR & TABS
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 30)
topBar.BackgroundTransparency = 1
topBar.Parent = main

local logoHolder = Instance.new("Frame")
logoHolder.Size = UDim2.new(0, 22, 0, 22)
logoHolder.Position = UDim2.new(0, 6, 0.5, -11)
logoHolder.BackgroundColor3 = Color3.fromRGB(22, 26, 38)
logoHolder.BorderSizePixel = 0
logoHolder.Parent = topBar
Instance.new("UICorner", logoHolder).CornerRadius = UDim.new(0, 4)

local logoIcon = Instance.new("ImageLabel")
logoIcon.Size = UDim2.new(1, -2, 1, -2)
logoIcon.Position = UDim2.new(0, 1, 0, 1)
logoIcon.BackgroundTransparency = 1
logoIcon.Image = CUSTOM_LOGO_ID
logoIcon.Parent = logoHolder

local titleLbl = Instance.new("TextLabel")
titleLbl.Size = UDim2.new(1, -100, 1, 0)
titleLbl.Position = UDim2.new(0, 34, 0, 0)
titleLbl.BackgroundTransparency = 1
titleLbl.Font = Enum.Font.GothamBlack
titleLbl.Text = "NOPAL <font color=\"#FF2D41\">JLXC</font> <font color=\"#6C7B9B\">| BETA CPB JELYZX</font>"
titleLbl.RichText = true
titleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLbl.TextSize = 9
titleLbl.TextXAlignment = Enum.TextXAlignment.Left
titleLbl.Parent = topBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 16, 0, 16)
closeBtn.Position = UDim2.new(1, -22, 0.5, -8)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 45, 65)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 8
closeBtn.Parent = topBar
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 4)

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 16, 0, 16)
minBtn.Position = UDim2.new(1, -42, 0.5, -8)
minBtn.BackgroundColor3 = Color3.fromRGB(40, 48, 70)
minBtn.Text = "-"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 10
minBtn.Parent = topBar
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 4)

local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 90, 1, -34)
sidebar.Position = UDim2.new(0, 6, 0, 32)
sidebar.BackgroundTransparency = 1
sidebar.Parent = main

local sideLayout = Instance.new("UIListLayout")
sideLayout.Padding = UDim.new(0, 3)
sideLayout.Parent = sidebar

local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, -106, 1, -36)
contentArea.Position = UDim2.new(0, 100, 0, 32)
contentArea.BackgroundTransparency = 1
contentArea.Parent = main

local menuVisible = true
minBtn.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    sidebar.Visible = menuVisible
    contentArea.Visible = menuVisible
    main.Size = menuVisible and UDim2.new(0, 360, 0, 210) or UDim2.new(0, 360, 0, 30)
    minBtn.Text = menuVisible and "-" or "+"
end)

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
    tabBtn.Size = UDim2.new(1, 0, 0, 20)
    tabBtn.BackgroundColor3 = Color3.fromRGB(16, 20, 30)
    tabBtn.BackgroundTransparency = 0.2
    tabBtn.Text = name
    tabBtn.TextColor3 = Color3.fromRGB(140, 150, 175)
    tabBtn.Font = Enum.Font.GothamMedium
    tabBtn.TextSize = 8
    tabBtn.Parent = sidebar
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 4)

    local container = Instance.new("ScrollingFrame")
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.ScrollBarThickness = 2
    container.ScrollBarImageColor3 = Color3.fromRGB(255, 45, 65)
    container.Visible = false
    container.Parent = contentArea
    container.AutomaticCanvasSize = Enum.AutomaticSize.Y

    local containerLayout = Instance.new("UIListLayout")
    containerLayout.Padding = UDim.new(0, 4)
    containerLayout.Parent = container

    tabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(tabs) do
            t.Btn.BackgroundColor3 = Color3.fromRGB(16, 20, 30)
            t.Btn.TextColor3 = Color3.fromRGB(140, 150, 175)
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

local function addToggle(parent, text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -4, 0, 18)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.75, 0, 1, 0)
    lbl.Position = UDim2.new(0, 2, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextColor3 = Color3.fromRGB(220, 225, 240)
    lbl.TextSize = 8
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame

    local switch = Instance.new("TextButton")
    switch.Size = UDim2.new(0, 22, 0, 10)
    switch.Position = UDim2.new(1, -24, 0.5, -5)
    switch.BackgroundColor3 = default and Color3.fromRGB(255, 45, 65) or Color3.fromRGB(35, 42, 55)
    switch.Text = ""
    switch.Parent = frame
    Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)

    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 8, 0, 8)
    dot.Position = default and UDim2.new(1, -9, 0.5, -4) or UDim2.new(0, 1, 0.5, -4)
    dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    dot.Parent = switch
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    local state = default
    switch.MouseButton1Click:Connect(function()
        state = not state
        if state then playSound(SOUND_TOGGLE_ON, 0.5) else playSound(SOUND_TOGGLE_OFF, 0.5) end
        switch.BackgroundColor3 = state and Color3.fromRGB(255, 45, 65) or Color3.fromRGB(35, 42, 55)
        dot.Position = state and UDim2.new(1, -9, 0.5, -4) or UDim2.new(0, 1, 0.5, -4)
        callback(state)
    end)
end

local function addSlider(parent, text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -4, 0, 20)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.6, 0, 0, 10)
    lbl.Position = UDim2.new(0, 2, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextColor3 = Color3.fromRGB(220, 225, 240)
    lbl.TextSize = 8
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame

    local valInput = Instance.new("TextLabel")
    valInput.Size = UDim2.new(0.35, -4, 0, 10)
    valInput.Position = UDim2.new(0.65, 0, 0, 0)
    valInput.BackgroundTransparency = 1
    valInput.Text = tostring(default)
    valInput.Font = Enum.Font.GothamBold
    valInput.TextColor3 = Color3.fromRGB(255, 45, 65)
    valInput.TextSize = 8
    valInput.TextXAlignment = Enum.TextXAlignment.Right
    valInput.Parent = frame

    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -4, 0, 2)
    track.Position = UDim2.new(0, 2, 0, 14)
    track.BackgroundColor3 = Color3.fromRGB(35, 42, 55)
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
    frame.Size = UDim2.new(1, -4, 0, 18)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.5, 0, 1, 0)
    lbl.Position = UDim2.new(0, 2, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextColor3 = Color3.fromRGB(220, 225, 240)
    lbl.TextSize = 8
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 75, 0, 14)
    btn.Position = UDim2.new(1, -77, 0.5, -7)
    btn.BackgroundColor3 = Color3.fromRGB(22, 28, 40)
    btn.Text = options[defaultIndex] .. " ▼"
    btn.TextColor3 = Color3.fromRGB(255, 45, 65)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 7.5
    btn.Parent = frame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 3)

    local currIndex = defaultIndex
    btn.MouseButton1Click:Connect(function()
        currIndex = (currIndex % #options) + 1
        btn.Text = options[currIndex] .. " ▼"
        callback(options[currIndex])
    end)
end

-- TABS POPULATION
local combatTab = createTab("Combat")
local espTab = createTab("ESP Config")
local resoTab = createTab("Resolusi")
local moveTab = createTab("Movement")

local colorList = {"Biru Cyan", "Hijau Neon", "Merah", "Kuning", "Ungu", "Pink Neon", "Oranye", "Putih", "Emas", "Lime", "Biru Tua"}

-- COMBAT TAB
addToggle(combatTab, "Camera Lock (Aimbot)", false, function(v) State.AimbotEnabled = v end)
addToggle(combatTab, "Instant Lock Mode", false, function(v) State.DirectLock = v end)
addSlider(combatTab, "Smoothness Speed", 1, 50, 5, function(v) State.Smoothness = v / 50 end)
addToggle(combatTab, "Movement Prediction", false, function(v) State.Prediction = v end)
addToggle(combatTab, "Wall Check (Ultra Presisi)", false, function(v) State.WallCheck = v end)
addSelector(combatTab, "Target Part", {"Head", "Torso", "HumanoidRootPart"}, 1, function(v) State.TargetPart = v end)
addToggle(combatTab, "Show FOV Circle", false, function(v) State.ShowFOV = v end)
addSlider(combatTab, "FOV Radius", 50, 1500, 150, function(v) State.FOVRadius = v end)
addSelector(combatTab, "Warna FOV Circle", colorList, 1, function(v)
    State.FOVColor = ColorMap[v] or Color3.fromRGB(0, 240, 255)
end)

addToggle(combatTab, "Anti-Spectate Admin/Staff", false, function(v) State.AntiSpectateAdmin = v end)

addToggle(combatTab, "Invisible Mode (Full Ghost)", false, function(v) 
    State.InvisibleMode = v 
    if not v and LocalPlayer.Character then
        for _, p in ipairs(LocalPlayer.Character:GetDescendants()) do
            if p:IsA("BasePart") or p:IsA("Decal") or p:IsA("Texture") then
                if p.Name ~= "HumanoidRootPart" then 
                    p.Transparency = 0 
                    if p:IsA("BasePart") then p.LocalTransparencyModifier = 0 end
                end
            elseif p:IsA("BillboardGui") or p:IsA("SurfaceGui") then
                p.Enabled = true
            end
        end
    end
end)

addToggle(combatTab, "Show Custom Crosshair", false, function(v) State.CustomCrosshair = v end)
addSelector(combatTab, "Model Crosshair", {"Silang (+)", "Dot (.)", "Kotak (Square)", "X-Shape (X)", "Lingkaran (Circle)"}, 1, function(v) State.CrosshairType = v end)
addSelector(combatTab, "Warna Crosshair", colorList, 2, function(v)
    State.CrosshairColorName = v
    State.CrosshairColor = ColorMap[v] or Color3.fromRGB(0, 255, 150)
end)

addToggle(combatTab, "Spawn Instant Full Health", false, function(v) State.SpawnFullHealth = v end)

-- ESP TAB
addToggle(espTab, "Precision Box ESP", false, function(v) State.ESP_CornerBox = v end)
addToggle(espTab, "Health Bar ESP", false, function(v) State.ESP_HealthBar = v end)
addToggle(espTab, "Skeleton ESP", false, function(v) State.ESP_Skeleton = v end)
addToggle(espTab, "Snapline Tracer", false, function(v) State.ESP_Tracers = v end)
addSelector(espTab, "Posisi Line Tracer", {"Bawah Tengah", "Tengah Tengah", "Atas Tengah"}, 1, function(v) State.ESP_TracerPos = v end)
addSelector(espTab, "Warna Utama ESP/Tracer", colorList, 1, function(v)
    State.ESPColor = ColorMap[v] or Color3.fromRGB(0, 240, 255)
end)
addToggle(espTab, "Head Dot ESP", false, function(v) State.ESP_HeadDots = v end)
addToggle(espTab, "Overhead Name", false, function(v) State.ESP_Names = v end)
addToggle(espTab, "Team Check", false, function(v) State.ESP_TeamCheck = v end)

-- RESO TAB
addToggle(resoTab, "Mode Gepeng FiveM Real", false, function(v) 
    State.RealGepengEnabled = v 
    if not v and not State.LYR360Enabled then Camera.FieldOfView = 70 end
end)
addSlider(resoTab, "Tingkat Gepeng Ekstrem", 10, 80, 35, function(v) 
    State.GepengRatio = v / 100 
end)

addToggle(resoTab, "Mode LYR 360%", false, function(v) 
    State.LYR360Enabled = v 
    if not v and not State.RealGepengEnabled then Camera.FieldOfView = 70 end
end)
addSlider(resoTab, "FOVs 360 Wide", 80, 160, 135, function(v) 
    State.LYR360Val = v 
end)
addSlider(resoTab, "Curvature / Fisheye Roll", 1, 30, 18, function(v) 
    State.LYRFisheyeDegree = v / 10
end)

-- MOVEMENT TAB
addSlider(moveTab, "Walk Speed Bypass", 16, 300, 16, function(v) State.WalkSpeedVal = v end)
addSlider(moveTab, "Jump Power", 50, 1000, 50, function(v) State.JumpPowerVal = v end)

addToggle(moveTab, "Super Smooth Movement", false, function(v) State.SmoothMovement = v end)
addSlider(moveTab, "Smoothness Factor", 1, 50, 25, function(v) State.SmoothFactor = v / 100 end)

addToggle(moveTab, "FiveM Blink (Desync Musuh)", false, function(v) State.FiveMBlink = v end)
addSlider(moveTab, "Blink Intensity", 1, 30, 10, function(v) State.BlinkIntensity = v end)

addToggle(moveTab, "Infinite Jump", false, function(v) State.InfiniteJump = v end)
addToggle(moveTab, "Noclip Mode", false, function(v) State.NoclipEnabled = v end)
addToggle(moveTab, "Fly Mode UI", false, function(v) 
    State.FlyEnabled = v 
    flyControls.Visible = v
end)
addSlider(moveTab, "Fly Speed", 20, 500, 100, function(v) State.FlySpeed = v end)
addToggle(moveTab, "Spinbot Karakter", false, function(v) State.SpinBotEnabled = v end)
addSlider(moveTab, "Kecepatan Spin", 10, 300, 50, function(v) State.SpinSpeed = v end)

addToggle(moveTab, "Spectate Player System", false, function(v)
    State.SpectateEnabled = v
    spectateUI.Visible = v
    if not v then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            Camera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        end
    else
        updateSpectate()
    end
end)

local freecamCFrame = CFrame.new()
addToggle(moveTab, "Freecam Mobile (UI Tombol)", false, function(v)
    State.FreecamEnabled = v
    freecamUI.Visible = v
    if v then
        freecamCFrame = Camera.CFrame
        Camera.CameraType = Enum.CameraType.Scriptable
    else
        Camera.CameraType = Enum.CameraType.Custom
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            Camera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        end
    end
end)
addSlider(moveTab, "Freecam Speed", 10, 300, 50, function(v) State.FreecamSpeed = v end)

-- LOGIKA AIMBOT & ESP (NO LAG / NO STACKING)
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

local function checkWallObstructionBrutal(targetPart)
    if not targetPart or not targetPart.Parent then return false end
    local char = targetPart.Parent
    local camPos = Camera.CFrame.Position

    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    rayParams.FilterDescendantsInstances = {LocalPlayer.Character, char, Camera}
    rayParams.IgnoreWater = true

    local rayResult = Workspace:Raycast(camPos, targetPart.Position - camPos, rayParams)
    return rayResult == nil
end

local function isTargetValidForAimbot(targetPart)
    if not targetPart or not targetPart.Parent then return false end
    local char = targetPart.Parent
    if not isCharacterAlive(char) then return false end

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

-- SPAWN FULL HEALTH
local function applyFullHealthOnSpawn(character)
    if not character then return end
    local hum = character:WaitForChild("Humanoid", 5)
    if hum and State.SpawnFullHealth then hum.Health = hum.MaxHealth end
end

if LocalPlayer.Character then applyFullHealthOnSpawn(LocalPlayer.Character) end
table.insert(_G.JelyzxConnections, LocalPlayer.CharacterAdded:Connect(applyFullHealthOnSpawn))

-- ESP ENGINE (OPTIMIZED FOR NO-DELAY)
local ESPObjects = {}
local function createDrawing(class, properties)
    local obj = Drawing.new(class)
    for prop, val in pairs(properties or {}) do obj[prop] = val end
    return obj
end

local function removePlayerESP(plr)
    if ESPObjects[plr] then
        for _, obj in pairs(ESPObjects[plr].Drawing) do 
            pcall(function() obj:Remove() end) 
        end
        ESPObjects[plr] = nil
    end
end

local function setupPlayerESP(plr)
    if plr == LocalPlayer or ESPObjects[plr] then return end
    local draw = {
        C1 = createDrawing("Line", {Thickness = 1.2, Visible = false}),
        C2 = createDrawing("Line", {Thickness = 1.2, Visible = false}),
        C3 = createDrawing("Line", {Thickness = 1.2, Visible = false}),
        C4 = createDrawing("Line", {Thickness = 1.2, Visible = false}),
        C5 = createDrawing("Line", {Thickness = 1.2, Visible = false}),
        C6 = createDrawing("Line", {Thickness = 1.2, Visible = false}),
        C7 = createDrawing("Line", {Thickness = 1.2, Visible = false}),
        C8 = createDrawing("Line", {Thickness = 1.2, Visible = false}),

        HealthBarOutline = createDrawing("Square", {Thickness = 1, Filled = true, Color = Color3.fromRGB(0, 0, 0), Visible = false}),
        HealthBar = createDrawing("Square", {Thickness = 1, Filled = true, Visible = false}),
        HeadDot = createDrawing("Circle", {Radius = 2.5, Filled = true, Visible = false}),
        NameText = createDrawing("Text", {Size = 9, Center = true, Outline = true, Visible = false}),
        Tracer = createDrawing("Line", {Thickness = 1, Visible = false}),

        Skel1 = createDrawing("Line", {Thickness = 1, Visible = false}),
        Skel2 = createDrawing("Line", {Thickness = 1, Visible = false}),
        Skel3 = createDrawing("Line", {Thickness = 1, Visible = false}),
        Skel4 = createDrawing("Line", {Thickness = 1, Visible = false}),
        Skel5 = createDrawing("Line", {Thickness = 1, Visible = false})
    }
    ESPObjects[plr] = {Player = plr, Drawing = draw}
end

for _, p in ipairs(Players:GetPlayers()) do setupPlayerESP(p) end
table.insert(_G.JelyzxConnections, Players.PlayerAdded:Connect(setupPlayerESP))
table.insert(_G.JelyzxConnections, Players.PlayerRemoving:Connect(removePlayerESP))

local function resetAllDrawings(draw)
    for _, item in pairs(draw) do item.Visible = false end
end

local function updateESPPosition()
    local viewX, viewY = Camera.ViewportSize.X, Camera.ViewportSize.Y

    for plr, data in pairs(ESPObjects) do
        local draw = data.Drawing
        local char = plr.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local head = char and char:FindFirstChild("Head")
        local hum = char and char:FindFirstChildOfClass("Humanoid")

        local isTeam = State.ESP_TeamCheck and (plr.Team == LocalPlayer.Team)
        local dist = hrp and (Camera.CFrame.Position - hrp.Position).Magnitude or 99999
        local isTargeted = CurrentActiveTarget and CurrentActiveTarget.Parent == char
        
        local activeColor = State.ESPColor
        if isTargeted then
            activeColor = State.LockColor
        elseif isAdminPlayer(plr) then
            activeColor = ColorGold
        elseif isGodmodePlayer(plr) then
            activeColor = ColorGodmode
        end

        if char and hrp and head and hum and hum.Health > 0 and not isTeam and dist <= State.ESP_MaxDistance then
            local hrpPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            if onScreen and hrpPos.Z > 0 then
                local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                local legPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))

                local height = math.abs(headPos.Y - legPos.Y)
                local width = height * 0.6
                local minX, minY = hrpPos.X - (width / 2), headPos.Y

                if State.ESP_CornerBox then
                    local lineLen = width * 0.25
                    draw.C1.From = Vector2.new(minX, minY); draw.C1.To = Vector2.new(minX + lineLen, minY); draw.C1.Color = activeColor; draw.C1.Visible = true
                    draw.C2.From = Vector2.new(minX, minY); draw.C2.To = Vector2.new(minX, minY + lineLen); draw.C2.Color = activeColor; draw.C2.Visible = true
                    draw.C3.From = Vector2.new(minX + width, minY); draw.C3.To = Vector2.new(minX + width - lineLen, minY); draw.C3.Color = activeColor; draw.C3.Visible = true
                    draw.C4.From = Vector2.new(minX + width, minY); draw.C4.To = Vector2.new(minX + width, minY + lineLen); draw.C4.Color = activeColor; draw.C4.Visible = true
                    draw.C5.From = Vector2.new(minX, minY + height); draw.C5.To = Vector2.new(minX + lineLen, minY + height); draw.C5.Color = activeColor; draw.C5.Visible = true
                    draw.C6.From = Vector2.new(minX, minY + height); draw.C6.To = Vector2.new(minX, minY + height - lineLen); draw.C6.Color = activeColor; draw.C6.Visible = true
                    draw.C7.From = Vector2.new(minX + width, minY + height); draw.C7.To = Vector2.new(minX + width - lineLen, minY + height); draw.C7.Color = activeColor; draw.C7.Visible = true
                    draw.C8.From = Vector2.new(minX + width, minY + height); draw.C8.To = Vector2.new(minX + width, minY + height - lineLen); draw.C8.Color = activeColor; draw.C8.Visible = true
                else
                    for i = 1, 8 do draw["C"..i].Visible = false end
                end

                if State.ESP_HealthBar then
                    local healthPct = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                    local barWidth = 2
                    local barX, barY = minX - barWidth - 3, minY
                    draw.HealthBarOutline.Size = Vector2.new(barWidth, height)
                    draw.HealthBarOutline.Position = Vector2.new(barX, barY)
                    draw.HealthBarOutline.Visible = true

                    local barHeight = height * healthPct
                    draw.HealthBar.Size = Vector2.new(barWidth, barHeight)
                    draw.HealthBar.Position = Vector2.new(barX, barY + (height - barHeight))
                    draw.HealthBar.Color = Color3.fromHSV(healthPct * 0.3, 1, 1)
                    draw.HealthBar.Visible = true
                else
                    draw.HealthBarOutline.Visible = false; draw.HealthBar.Visible = false
                end

                if State.ESP_Tracers then
                    local startPos = Vector2.new(viewX / 2, viewY)
                    if State.ESP_TracerPos == "Tengah Tengah" then startPos = Vector2.new(viewX / 2, viewY / 2)
                    elseif State.ESP_TracerPos == "Atas Tengah" then startPos = Vector2.new(viewX / 2, 0) end
                    draw.Tracer.From = startPos
                    draw.Tracer.To = Vector2.new(hrpPos.X, minY + height)
                    draw.Tracer.Color = activeColor; draw.Tracer.Visible = true
                else
                    draw.Tracer.Visible = false
                end

                if State.ESP_HeadDots then
                    draw.HeadDot.Position = Vector2.new(headPos.X, headPos.Y)
                    draw.HeadDot.Color = activeColor; draw.HeadDot.Visible = true
                else
                    draw.HeadDot.Visible = false
                end

                if State.ESP_Names then
                    draw.NameText.Text = string.format("%s [%dm]", plr.Name, math.floor(dist))
                    draw.NameText.Position = Vector2.new(hrpPos.X, minY - 12)
                    draw.NameText.Color = Color3.fromRGB(255, 255, 255)
                    draw.NameText.Visible = true
                else
                    draw.NameText.Visible = false
                end

                if State.ESP_Skeleton then
                    local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or hrp
                    local leftArm = char:FindFirstChild("LeftHand") or char:FindFirstChild("Left Arm")
                    local rightArm = char:FindFirstChild("RightHand") or char:FindFirstChild("Right Arm")
                    local leftLeg = char:FindFirstChild("LeftFoot") or char:FindFirstChild("Left Leg")
                    local rightLeg = char:FindFirstChild("RightFoot") or char:FindFirstChild("Right Leg")

                    local function connectParts(lineObj, p1, p2)
                        if p1 and p2 then
                            local pos1 = Camera:WorldToViewportPoint(p1.Position)
                            local pos2 = Camera:WorldToViewportPoint(p2.Position)
                            if pos1.Z > 0 and pos2.Z > 0 then
                                lineObj.From = Vector2.new(pos1.X, pos1.Y)
                                lineObj.To = Vector2.new(pos2.X, pos2.Y)
                                lineObj.Color = activeColor; lineObj.Visible = true
                                return
                            end
                        end
                        lineObj.Visible = false
                    end

                    connectParts(draw.Skel1, head, torso)
                    connectParts(draw.Skel2, torso, leftArm)
                    connectParts(draw.Skel3, torso, rightArm)
                    connectParts(draw.Skel4, torso, leftLeg)
                    connectParts(draw.Skel5, torso, rightLeg)
                else
                    draw.Skel1.Visible = false; draw.Skel2.Visible = false; draw.Skel3.Visible = false; draw.Skel4.Visible = false; draw.Skel5.Visible = false
                end
            else
                resetAllDrawings(draw)
            end
        else
            resetAllDrawings(draw)
        end
    end
end

-- RENDER LOOP (OPTIMIZED)
local mainRenderConn = RunService.RenderStepped:Connect(function(deltaTime)
    if not State.ScriptActive then return end

    if State.AntiSpectateAdmin and LocalPlayer.Character then
        local myHum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and isAdminPlayer(plr) and plr.Character then
                local pHum = plr.Character:FindFirstChildOfClass("Humanoid")
                if pHum and pHum.CameraSubject == myHum then pHum.CameraSubject = pHum end
            end
        end
    end

    if State.InvisibleMode and LocalPlayer.Character then
        for _, item in ipairs(LocalPlayer.Character:GetDescendants()) do
            if item:IsA("BasePart") then
                item.Transparency = 1; item.LocalTransparencyModifier = 1
            elseif item:IsA("Decal") or item:IsA("Texture") then
                item.Transparency = 1
            elseif item:IsA("BillboardGui") or item:IsA("SurfaceGui") then
                item.Enabled = false
            end
        end
    end

    if State.FreecamEnabled then
        local fwdVel = (State.FreecamForward and 1 or 0) - (State.FreecamBackward and 1 or 0)
        local sideVel = (State.FreecamRight and 1 or 0) - (State.FreecamLeft and 1 or 0)
        local upVel = (State.FreecamUp and 1 or 0) - (State.FreecamDown and 1 or 0)

        local speed = State.FreecamSpeed * deltaTime
        local frameCFrame = freecamCFrame
        
        local translation = (frameCFrame.RightVector * sideVel) + (frameCFrame.LookVector * fwdVel) + (Vector3.new(0, 1, 0) * upVel)
        freecamCFrame = frameCFrame + (translation * speed)
        Camera.CFrame = freecamCFrame
    else
        local baseCFrame = Camera.CFrame
        if State.AimbotEnabled then
            local targetPart = getBestTargetBrutal()
            if targetPart then
                local targetPos = targetPart.Position
                if State.Prediction and targetPart.Parent then
                    local hrp = targetPart.Parent:FindFirstChild("HumanoidRootPart")
                    if hrp then targetPos = targetPos + (hrp.AssemblyLinearVelocity * State.PredictionMult) end
                end

                local targetCFrame = CFrame.lookAt(Camera.CFrame.Position, targetPos)
                if State.DirectLock then
                    baseCFrame = targetCFrame
                else
                    local smoothness = math.clamp(State.Smoothness * 30, 1, 50)
                    local lerpAlpha = 1 - math.exp(-smoothness * deltaTime)
                    baseCFrame = Camera.CFrame:Lerp(targetCFrame, math.clamp(lerpAlpha, 0.01, 1))
                end
            else
                CurrentActiveTarget = nil
            end
        else
            CurrentActiveTarget = nil
        end

        if State.LYR360Enabled then
            Camera.FieldOfView = State.LYR360Val
            baseCFrame = baseCFrame * CFrame.Angles(0, 0, math.rad(math.sin(tick() * 2) * State.LYRFisheyeDegree))
        end

        if State.RealGepengEnabled then
            baseCFrame = baseCFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, State.GepengRatio, 0, 0, 0, 1)
        end

        Camera.CFrame = baseCFrame
    end

    if State.SpectateEnabled then updateSpectate() end

    local viewportCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    fovCircle.Position = viewportCenter
    fovCircle.Radius = State.FOVRadius
    fovCircle.Color = CurrentActiveTarget and State.LockColor or State.FOVColor
    fovCircle.Visible = State.ShowFOV and State.AimbotEnabled

    hideAllCrosshair()
    if State.CustomCrosshair then
        local cColor = State.CrosshairColor
        local cType = State.CrosshairType
        
        if cType == "Silang (+)" then
            local len = 6
            chLines[1].From = Vector2.new(viewportCenter.X - len, viewportCenter.Y); chLines[1].To = Vector2.new(viewportCenter.X + len, viewportCenter.Y); chLines[1].Color = cColor; chLines[1].Visible = true
            chLines[2].From = Vector2.new(viewportCenter.X, viewportCenter.Y - len); chLines[2].To = Vector2.new(viewportCenter.X, viewportCenter.Y + len); chLines[2].Color = cColor; chLines[2].Visible = true
        elseif cType == "Dot (.)" then
            chCircle.Position = viewportCenter; chCircle.Radius = 2; chCircle.Filled = true; chCircle.Color = cColor; chCircle.Visible = true
        end
    end

    updateESPPosition()
end)
table.insert(_G.JelyzxConnections, mainRenderConn)

-- INFINITE JUMP
table.insert(_G.JelyzxConnections, UserInputService.JumpRequest:Connect(function()
    if State.InfiniteJump and State.ScriptActive and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hum and hrp then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
            hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, State.JumpPowerVal or 50, hrp.AssemblyLinearVelocity.Z)
        end
    end
end))

-- PHYSICS LOOP
local spinAngle = 0
local flyBodyVelocity = nil
local flyBodyGyro = nil

local stepConn = RunService.Stepped:Connect(function(_, deltaTime)
    if not State.ScriptActive then return end
    pcall(function()
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")

            if hum and hrp then
                hum.WalkSpeed = State.WalkSpeedVal
                if State.WalkSpeedVal > 16 and hum.MoveDirection.Magnitude > 0 then
                    local targetVelocity = hum.MoveDirection * State.WalkSpeedVal
                    hrp.AssemblyLinearVelocity = Vector3.new(targetVelocity.X, hrp.AssemblyLinearVelocity.Y, targetVelocity.Z)
                end
                hum.UseJumpPower = true
                hum.JumpPower = State.JumpPowerVal
            end

            if State.SpinBotEnabled and hrp then
                spinAngle = (spinAngle + (State.SpinSpeed * deltaTime * 10)) % 360
                hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, math.rad(spinAngle), 0)
            end

            if State.NoclipEnabled then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end

            if State.FlyEnabled and hrp and hum then
                if not flyBodyVelocity or flyBodyVelocity.Parent ~= hrp then
                    flyBodyVelocity = Instance.new("BodyVelocity")
                    flyBodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                    flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
                    flyBodyVelocity.Parent = hrp
                end

                if not flyBodyGyro or flyBodyGyro.Parent ~= hrp then
                    flyBodyGyro = Instance.new("BodyGyro")
                    flyBodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
                    flyBodyGyro.CFrame = hrp.CFrame
                    flyBodyGyro.Parent = hrp
                end

                local moveDir = hum.MoveDirection
                local targetYVelocity = State.FlyUp and State.FlySpeed or (State.FlyDown and -State.FlySpeed or 0)
                flyBodyVelocity.Velocity = Vector3.new(moveDir.X * State.FlySpeed, targetYVelocity, moveDir.Z * State.FlySpeed)
                flyBodyGyro.CFrame = Camera.CFrame
            else
                if flyBodyVelocity then flyBodyVelocity:Destroy(); flyBodyVelocity = nil end
                if flyBodyGyro then flyBodyGyro:Destroy(); flyBodyGyro = nil end
            end
        end
    end)
end)
table.insert(_G.JelyzxConnections, stepConn)

-- ANTI AFK
LocalPlayer.Idled:Connect(function()
    if State.AntiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

-- CLEANUP
closeBtn.MouseButton1Click:Connect(function()
    State.ScriptActive = false
    fovCircle.Visible = false
    hideAllCrosshair()
    pcall(function() 
        fovCircle:Remove()
        for _, l in ipairs(chLines) do l:Remove() end
        chCircle:Remove()
    end)
    if flyBodyVelocity then flyBodyVelocity:Destroy() end
    if flyBodyGyro then flyBodyGyro:Destroy() end
    Camera.CameraType = Enum.CameraType.Custom
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        Camera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    end
    Camera.FieldOfView = 70
    for _, conn in ipairs(_G.JelyzxConnections) do pcall(function() conn:Disconnect() end) end
    table.clear(_G.JelyzxConnections)
    for plr in pairs(ESPObjects) do removePlayerESP(plr) end
    gui:Destroy()
end)

Kirim langsung full scripnya kyk gini
