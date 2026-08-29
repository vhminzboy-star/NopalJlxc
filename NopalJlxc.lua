-- ========================================================
-- NOPAL JLXC — CPB JELYZX (ENHANCED SAFE BYPASS EDITION)
-- Showcase Logo: https://create.roblox.com/store/asset/129775661697970
-- Background Logo: https://create.roblox.com/store/asset/111989994218720
-- ========================================================

if _G.JelyzxConnections then
    for _, conn in ipairs(_G.JelyzxConnections) do
        pcall(function() conn:Disconnect() end)
    end
end
_G.JelyzxConnections = {}

-- Utility String Randomizer untuk Stealth Naming
local function generateRandomName(length)
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local res = ""
    for i = 1, (length or 12) do
        local rand = math.random(1, #chars)
        res = res .. string.sub(chars, rand, rand)
    end
    return res
end

local SECURE_GUI_NAME = generateRandomName(16)

local Services = setmetatable({}, {
    __index = function(_, serviceName) 
        local s
        pcall(function() s = game:GetService(serviceName) end)
        return s
    end
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

-- ========================================================
-- [STEALTH PC SPOOFER SYSTEM WITH METATABLE BYPASS]
-- ========================================================
pcall(function()
    if hookmetamethod then
        local oldIndex
        oldIndex = hookmetamethod(game, "__index", function(self, index)
            if not checkcaller() and self == UserInputService then
                if index == "TouchEnabled" or index == "GyroscopeEnabled" or index == "AccelerometerEnabled" then
                    return false
                elseif index == "KeyboardEnabled" or index == "MouseEnabled" then
                    return true
                end
            end
            return oldIndex(self, index)
        end)

        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            if not checkcaller() and self == UserInputService then
                if method == "GetPlatform" then
                    return Enum.Platform.Windows
                elseif method == "GetLastInputType" then
                    return Enum.UserInputType.Keyboard
                end
            end
            return oldNamecall(self, ...)
        end)
    elseif setreadonly and getrawmetatable then
        local rawMetatable = getrawmetatable(game)
        local originalNamecall = rawMetatable.__namecall
        local originalIndex = rawMetatable.__index
        
        setreadonly(rawMetatable, false)

        rawMetatable.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if self == UserInputService then
                if method == "GetPlatform" then
                    return Enum.Platform.Windows
                elseif method == "GetLastInputType" then
                    return Enum.UserInputType.Keyboard
                end
            end
            return originalNamecall(self, ...)
        end)

        rawMetatable.__index = newcclosure(function(self, index)
            if self == UserInputService then
                if index == "TouchEnabled" then
                    return false
                elseif index == "KeyboardEnabled" or index == "MouseEnabled" then
                    return true
                elseif index == "GyroscopeEnabled" or index == "AccelerometerEnabled" then
                    return false
                end
            end
            return originalIndex(self, index)
        end)

        setreadonly(rawMetatable, true)
    end
end)

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

-- Cleanup GUI lama berbasis class dan properties tersembunyi
for _, old in ipairs(parentGui:GetChildren()) do
    if old:IsA("ScreenGui") and old:FindFirstChild("IntroOverlay") then
        pcall(function() old:Destroy() end)
    end
end

-- ASSETS ID
local RAW_ID = "111989994218720"
local SHOWCASE_ID = "129775661697970"
local CUSTOM_LOGO_ID = "rbxthumb://type=Asset&id=" .. RAW_ID .. "&w=420&h=420"
local SHOWCASE_LOGO_ID = "rbxthumb://type=Asset&id=" .. SHOWCASE_ID .. "&w=420&h=420"

-- SOUND SYSTEM
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
    PredictionMult = 0.01,
    LockColor = Color3.fromRGB(255, 30, 30),
    
    SpawnFullHealth = false,
    InvisibleMode = false,
    AntiSpectateAdmin = true,

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

    FreecamEnabled = false,
    FreecamSpeed = 2,
    FreecamSens = 1.2,
    FreecamUIScale = 1.0,
    FreecamDir = {
        Forward = false,
        Backward = false,
        Left = false,
        Right = false,
        Up = false,
        Down = false
    },

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

-- ANTI-SPECTATE SYSTEM BYPASS WRAPPER
local function processAntiSpectateProtection()
    if not State.AntiSpectateAdmin or not State.ScriptActive then return end
    pcall(function()
        local myChar = LocalPlayer.Character
        if not myChar then return end
        local myHum = myChar:FindFirstChildOfClass("Humanoid")
        local myRoot = myChar:FindFirstChild("HumanoidRootPart")
        
        if not State.FreecamEnabled and not State.SpectateEnabled then
            if Camera.CameraSubject and Camera.CameraSubject ~= myHum and not Camera.CameraSubject:IsDescendantOf(myChar) then
                Camera.CameraSubject = myHum
            end
        end

        if myRoot then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and isAdminPlayer(plr) then
                    local otherChar = plr.Character
                    if otherChar and otherChar:FindFirstChild("HumanoidRootPart") then
                        local otherRoot = otherChar.HumanoidRootPart
                        local dist = (otherRoot.Position - myRoot.Position).Magnitude
                        
                        if dist < 5 and otherRoot.Transparency > 0.7 then
                            for _, part in ipairs(myChar:GetChildren()) do
                                if part:IsA("BasePart") then
                                    part.LocalTransparencyModifier = 0
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end

local CurrentActiveTarget = nil

-- SAFE DRAWING CREATOR (PROTECTED FROM DETECT)
local function safeDrawingNew(class)
    local obj = nil
    pcall(function()
        obj = Drawing.new(class)
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

-- GUI BASE WITH RANDOMIZED IDENTITY
local gui = Instance.new("ScreenGui")
gui.Name = SECURE_GUI_NAME
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = parentGui

-- FLY TOUCH UI
local flyControls = Instance.new("Frame")
flyControls.Name = generateRandomName(10)
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
flyStroke.Transparency = 0.3

local flyTitle = Instance.new("TextLabel")
flyTitle.Size = UDim2.new(1, 0, 0, 20)
flyTitle.Position = UDim2.new(0, 0, 0, 4)
flyTitle.BackgroundTransparency = 1
flyTitle.Text = "FLY SYSTEM"
flyTitle.Font = Enum.Font.GothamBlack
flyTitle.TextColor3 = Color3.fromRGB(200, 210, 230)
flyTitle.TextSize = 8
flyTitle.Parent = flyControls

local btnUp = Instance.new("TextButton")
btnUp.Size = UDim2.new(0, 61, 0, 60)
btnUp.Position = UDim2.new(0.5, -30, 0, 26)
btnUp.BackgroundColor3 = Color3.fromRGB(20, 28, 45)
btnUp.BackgroundTransparency = 0.2
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
btnDown.BackgroundTransparency = 0.2
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

-- FREECAM UI SYSTEM
local freecamUI = Instance.new("Frame")
freecamUI.Name = generateRandomName(10)
freecamUI.Size = UDim2.new(1, 0, 1, 0)
freecamUI.BackgroundTransparency = 1
freecamUI.Visible = false
freecamUI.Parent = gui

local touchDragArea = Instance.new("TextButton")
touchDragArea.Name = generateRandomName(8)
touchDragArea.Size = UDim2.new(1, 0, 1, 0)
touchDragArea.BackgroundTransparency = 1
touchDragArea.Text = ""
touchDragArea.Parent = freecamUI

local freecamContainer = Instance.new("Frame")
freecamContainer.Name = generateRandomName(8)
freecamContainer.Size = UDim2.new(1, 0, 1, 0)
freecamContainer.BackgroundTransparency = 1
freecamContainer.Parent = freecamUI

local fcScaleConstraint = Instance.new("UIScale", freecamContainer)
fcScaleConstraint.Scale = State.FreecamUIScale

local padDir = Instance.new("Frame")
padDir.Name = generateRandomName(8)
padDir.Size = UDim2.new(0, 130, 0, 130)
padDir.Position = UDim2.new(0, 25, 1, -155)
padDir.BackgroundColor3 = Color3.fromRGB(10, 12, 18)
padDir.BackgroundTransparency = 0.4
padDir.Parent = freecamContainer
Instance.new("UICorner", padDir).CornerRadius = UDim.new(1, 0)

local function makeFcBtn(name, text, pos, size, dirKey)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = size
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(22, 28, 42)
    btn.BackgroundTransparency = 0.2
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(0, 240, 255)
    btn.Font = Enum.Font.GothamBlack
    btn.TextSize = 13
    btn.Parent = padDir
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    btn.MouseButton1Down:Connect(function() State.FreecamDir[dirKey] = true end)
    btn.MouseButton1Up:Connect(function() State.FreecamDir[dirKey] = false end)
    btn.InputEnded:Connect(function() State.FreecamDir[dirKey] = false end)
    return btn
end

makeFcBtn(generateRandomName(5), "▲", UDim2.new(0.5, -18, 0, 6), UDim2.new(0, 36, 0, 36), "Forward")
makeFcBtn(generateRandomName(5), "▼", UDim2.new(0.5, -18, 1, -42), UDim2.new(0, 36, 0, 36), "Backward")
makeFcBtn(generateRandomName(5), "◄", UDim2.new(0, 6, 0.5, -18), UDim2.new(0, 36, 0, 36), "Left")
makeFcBtn(generateRandomName(5), "►", UDim2.new(1, -42, 0.5, -18), UDim2.new(0, 36, 0, 36), "Right")

local padElev = Instance.new("Frame")
padElev.Name = generateRandomName(8)
padElev.Size = UDim2.new(0, 55, 0, 120)
padElev.Position = UDim2.new(1, -80, 1, -145)
padElev.BackgroundColor3 = Color3.fromRGB(10, 12, 18)
padElev.BackgroundTransparency = 0.4
padElev.Parent = freecamContainer
Instance.new("UICorner", padElev).CornerRadius = UDim.new(0, 12)

local btnFcUp = Instance.new("TextButton")
btnFcUp.Size = UDim2.new(0, 43, 0, 48)
btnFcUp.Position = UDim2.new(0.5, -21, 0, 8)
btnFcUp.BackgroundColor3 = Color3.fromRGB(22, 28, 42)
btnFcUp.BackgroundTransparency = 0.2
btnFcUp.Text = "▲\nUP"
btnFcUp.TextColor3 = Color3.fromRGB(0, 255, 170)
btnFcUp.Font = Enum.Font.GothamBlack
btnFcUp.TextSize = 10
btnFcUp.Parent = padElev
Instance.new("UICorner", btnFcUp).CornerRadius = UDim.new(0, 8)

local btnFcDown = Instance.new("TextButton")
btnFcDown.Size = UDim2.new(0, 43, 0, 48)
btnFcDown.Position = UDim2.new(0.5, -21, 1, -56)
btnFcDown.BackgroundColor3 = Color3.fromRGB(22, 28, 42)
btnFcDown.BackgroundTransparency = 0.2
btnFcDown.Text = "▼\nDN"
btnFcDown.TextColor3 = Color3.fromRGB(255, 55, 80)
btnFcDown.Font = Enum.Font.GothamBlack
btnFcDown.TextSize = 10
btnFcDown.Parent = padElev
Instance.new("UICorner", btnFcDown).CornerRadius = UDim.new(0, 8)

btnFcUp.MouseButton1Down:Connect(function() State.FreecamDir.Up = true end)
btnFcUp.MouseButton1Up:Connect(function() State.FreecamDir.Up = false end)
btnFcUp.InputEnded:Connect(function() State.FreecamDir.Up = false end)
btnFcDown.MouseButton1Down:Connect(function() State.FreecamDir.Down = true end)
btnFcDown.MouseButton1Up:Connect(function() State.FreecamDir.Down = false end)
btnFcDown.InputEnded:Connect(function() State.FreecamDir.Down = false end)

local isCamDragging = false
local lastCamTouchPos = Vector2.new()
local freecamRotX = 0
local freecamRotY = 0
local freecamCFrame = CFrame.new()

touchDragArea.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isCamDragging = true
        lastCamTouchPos = Vector2.new(input.Position.X, input.Position.Y)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isCamDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local currentPos = Vector2.new(input.Position.X, input.Position.Y)
        local delta = currentPos - lastCamTouchPos
        lastCamTouchPos = currentPos

        local speedMult = State.FreecamSens * 0.003
        freecamRotY = freecamRotY - (delta.X * speedMult)
        freecamRotX = math.clamp(freecamRotX - (delta.Y * speedMult), -math.rad(89), math.rad(89))
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isCamDragging = false
    end
end)

local function toggleFreecamMode(enable)
    State.FreecamEnabled = enable
    freecamUI.Visible = enable
    
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")

    if enable then
        Camera.CameraType = Enum.CameraType.Scriptable
        freecamCFrame = Camera.CFrame
        local _, rx, ry = freecamCFrame:ToEulerAnglesYXZ()
        freecamRotX = rx
        freecamRotY = ry
        if hrp then hrp.Anchored = true end
    else
        Camera.CameraType = Enum.CameraType.Custom
        if hrp then hrp.Anchored = false end
        for k in pairs(State.FreecamDir) do State.FreecamDir[k] = false end
    end
end

-- SPECTATE UI SYSTEM
local specUI = Instance.new("Frame")
specUI.Name = generateRandomName(10)
specUI.Size = UDim2.new(1, 0, 1, 0)
specUI.BackgroundTransparency = 1
specUI.Visible = false
specUI.Parent = gui

local specContainer = Instance.new("Frame")
specContainer.Name = generateRandomName(8)
specContainer.Size = UDim2.new(1, 0, 1, 0)
specContainer.BackgroundTransparency = 1
specContainer.Parent = specUI

local specScaleConstraint = Instance.new("UIScale", specContainer)
specScaleConstraint.Scale = State.SpectateUIScale

local specCard = Instance.new("Frame")
specCard.Size = UDim2.new(0, 280, 0, 95)
specCard.Position = UDim2.new(0.5, 0, 1, -120)
specCard.AnchorPoint = Vector2.new(0.5, 0)
specCard.BackgroundColor3 = Color3.fromRGB(11, 14, 22)
specCard.BackgroundTransparency = 0.2
specCard.Parent = specContainer
Instance.new("UICorner", specCard).CornerRadius = UDim.new(0, 12)

local specStroke = Instance.new("UIStroke", specCard)
specStroke.Color = Color3.fromRGB(0, 240, 255)
specStroke.Thickness = 1.5

local specTitleBar = Instance.new("TextLabel")
specTitleBar.Size = UDim2.new(1, 0, 0, 18)
specTitleBar.Position = UDim2.new(0, 0, 0, 4)
specTitleBar.BackgroundTransparency = 1
specTitleBar.Text = "★ SPECTATE ENGINE ★"
specTitleBar.Font = Enum.Font.GothamBlack
specTitleBar.TextColor3 = Color3.fromRGB(0, 240, 255)
specTitleBar.TextSize = 9
specTitleBar.Parent = specCard

local targetNameLbl = Instance.new("TextLabel")
targetNameLbl.Size = UDim2.new(1, -20, 0, 20)
targetNameLbl.Position = UDim2.new(0, 10, 0, 20)
targetNameLbl.BackgroundTransparency = 1
targetNameLbl.Text = "TARGET: NONE"
targetNameLbl.Font = Enum.Font.GothamBlack
targetNameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
targetNameLbl.TextSize = 12
targetNameLbl.TextTruncate = Enum.TextTruncate.AtEnd
targetNameLbl.Parent = specCard

local statusListLbl = Instance.new("TextLabel")
statusListLbl.Size = UDim2.new(1, -20, 0, 28)
statusListLbl.Position = UDim2.new(0, 10, 0, 38)
statusListLbl.BackgroundTransparency = 1
statusListLbl.Text = "HP: 100/100 | DIST: 0m\nSTATUS: NORMAL PLAYER"
statusListLbl.Font = Enum.Font.GothamBold
statusListLbl.TextColor3 = Color3.fromRGB(180, 195, 220)
statusListLbl.TextSize = 9
statusListLbl.RichText = true
statusListLbl.Parent = specCard

local btnPrevPlayer = Instance.new("TextButton")
btnPrevPlayer.Size = UDim2.new(0, 40, 0, 22)
btnPrevPlayer.Position = UDim2.new(0, 10, 0, 66)
btnPrevPlayer.BackgroundColor3 = Color3.fromRGB(22, 28, 42)
btnPrevPlayer.Text = "◄"
btnPrevPlayer.TextColor3 = Color3.fromRGB(0, 240, 255)
btnPrevPlayer.Font = Enum.Font.GothamBlack
btnPrevPlayer.TextSize = 14
btnPrevPlayer.Parent = specCard
Instance.new("UICorner", btnPrevPlayer).CornerRadius = UDim.new(0, 6)

local btnNextPlayer = Instance.new("TextButton")
btnNextPlayer.Size = UDim2.new(0, 40, 0, 22)
btnNextPlayer.Position = UDim2.new(1, -50, 0, 66)
btnNextPlayer.BackgroundColor3 = Color3.fromRGB(22, 28, 42)
btnNextPlayer.Text = "►"
btnNextPlayer.TextColor3 = Color3.fromRGB(0, 240, 255)
btnNextPlayer.Font = Enum.Font.GothamBlack
btnNextPlayer.TextSize = 14
btnNextPlayer.Parent = specCard
Instance.new("UICorner", btnNextPlayer).CornerRadius = UDim.new(0, 6)

local btnHideCard = Instance.new("TextButton")
btnHideCard.Size = UDim2.new(0, 170, 0, 22)
btnHideCard.Position = UDim2.new(0.5, -85, 0, 66)
btnHideCard.BackgroundColor3 = Color3.fromRGB(255, 45, 65)
btnHideCard.Text = "HIDE UI"
btnHideCard.TextColor3 = Color3.fromRGB(255, 255, 255)
btnHideCard.Font = Enum.Font.GothamBlack
btnHideCard.TextSize = 9.5
btnHideCard.Parent = specCard
Instance.new("UICorner", btnHideCard).CornerRadius = UDim.new(0, 6)

local function getValidPlayers()
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(list, p) end
    end
    return list
end

local function applySpectateTarget()
    if not State.SpectateEnabled then return end
    local targetPlr = State.SpectateTargetPlayer
    if targetPlr and targetPlr.Character then
        local hum = targetPlr.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            Camera.CameraType = Enum.CameraType.Custom
            Camera.CameraSubject = hum
        end
    end
end

local function updateSpectateTarget(indexOffset)
    local playerList = getValidPlayers()
    if #playerList == 0 then
        State.SpectateTargetPlayer = nil
        targetNameLbl.Text = "TARGET: NO PLAYER FOUND"
        statusListLbl.Text = "HP: 0/0 | DIST: 0m\nSTATUS: NONE"
        Camera.CameraSubject = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        return
    end

    State.SpectateTargetIndex = State.SpectateTargetIndex + indexOffset
    if State.SpectateTargetIndex > #playerList then State.SpectateTargetIndex = 1 end
    if State.SpectateTargetIndex < 1 then State.SpectateTargetIndex = #playerList end

    State.SpectateTargetPlayer = playerList[State.SpectateTargetIndex]
    applySpectateTarget()
end

btnPrevPlayer.MouseButton1Click:Connect(function() updateSpectateTarget(-1) end)
btnNextPlayer.MouseButton1Click:Connect(function() updateSpectateTarget(1) end)

btnHideCard.MouseButton1Click:Connect(function()
    State.SpectateCardCollapsed = not State.SpectateCardCollapsed
    if State.SpectateCardCollapsed then
        specCard.Size = UDim2.new(0, 280, 0, 26)
        statusListLbl.Visible = false
        targetNameLbl.Visible = false
        btnPrevPlayer.Visible = false
        btnNextPlayer.Visible = false
        btnHideCard.Position = UDim2.new(0.5, -85, 0, 2)
        btnHideCard.Text = "UNHIDE UI"
    else
        specCard.Size = UDim2.new(0, 280, 0, 95)
        statusListLbl.Visible = true
        targetNameLbl.Visible = true
        btnPrevPlayer.Visible = true
        btnNextPlayer.Visible = true
        btnHideCard.Position = UDim2.new(0.5, -85, 0, 66)
        btnHideCard.Text = "HIDE UI"
    end
end)

-- UPDATE STATUS DATA TARGET SPECTATE REALTIME
RunService.RenderStepped:Connect(function()
    if State.SpectateEnabled and State.SpectateTargetPlayer then
        pcall(function()
            local targetPlr = State.SpectateTargetPlayer
            local char = targetPlr.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local hrp = char and char:FindFirstChild("HumanoidRootPart")

            if char and hum and hrp then
                if Camera.CameraSubject ~= hum then
                    Camera.CameraSubject = hum
                end

                local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                local dist = myHrp and (myHrp.Position - hrp.Position).Magnitude or 0

                local hp = math.floor(hum.Health)
                local maxHp = math.floor(hum.MaxHealth)

                local statusTags = {}
                if isAdminPlayer(targetPlr) then table.insert(statusTags, "<font color=\"#FFD700\">[ADMIN/STAFF]</font>") end
                if isGodmodePlayer(targetPlr) then table.insert(statusTags, "<font color=\"#FF0080\">[GODMODE]</font>") end
                if targetPlr.Team then table.insert(statusTags, "<font color=\"#00F0FF\">[" .. tostring(targetPlr.Team.Name) .. "]</font>") end

                if #statusTags == 0 then table.insert(statusTags, "<font color=\"#00FF96\">[PLAYER]</font>") end

                targetNameLbl.Text = "TARGET: " .. targetPlr.Name .. " (@" .. targetPlr.DisplayName .. ")"
                statusListLbl.Text = string.format("HP: %d/%d | DIST: %dm\nSTATUS: %s", hp, maxHp, math.floor(dist), table.concat(statusTags, " "))
            else
                targetNameLbl.Text = "TARGET: " .. targetPlr.Name .. " (DEAD)"
                statusListLbl.Text = "HP: 0/0 | DIST: 0m\nSTATUS: RESPAWNING..."
            end
        end)
    end
end)

-- MAIN UI PANEL
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

-- OVERLAY INTRO & LOGO SHOWCASE
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

local introStroke = Instance.new("UIStroke", introCard)
introStroke.Color = Color3.fromRGB(255, 45, 65)
introStroke.Thickness = 2
introStroke.Transparency = 0.2

local bgLogoOld = Instance.new("ImageLabel")
bgLogoOld.Size = UDim2.new(1, 0, 1, 0)
bgLogoOld.Position = UDim2.new(0, 0, 0, 0)
bgLogoOld.BackgroundTransparency = 1
bgLogoOld.Image = CUSTOM_LOGO_ID
bgLogoOld.ImageTransparency = 0.20 
bgLogoOld.ScaleType = Enum.ScaleType.Fit
bgLogoOld.Parent = introCard

local showcaseLogo = Instance.new("ImageLabel")
showcaseLogo.Size = UDim2.new(0, 110, 0, 110)
showcaseLogo.Position = UDim2.new(0.5, 0, 0, -180)
showcaseLogo.AnchorPoint = Vector2.new(0.5, 0.5)
showcaseLogo.BackgroundTransparency = 1
showcaseLogo.Image = SHOWCASE_LOGO_ID
showcaseLogo.ImageTransparency = 1
showcaseLogo.Rotation = -35
showcaseLogo.Parent = introCard

local entranceTween = TweenService:Create(showcaseLogo, TweenInfo.new(1.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 72, 0, 72),
    Position = UDim2.new(0.5, 0, 0, -38),
    ImageTransparency = 0,
    Rotation = 0
})
entranceTween:Play()

task.spawn(function()
    entranceTween.Completed:Wait()
    while showcaseLogo and showcaseLogo.Parent do
        local t1 = TweenService:Create(showcaseLogo, TweenInfo.new(1.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Size = UDim2.new(0, 68, 0, 68),
            Position = UDim2.new(0.5, 0, 0, -36),
            ImageTransparency = 0.45
        })
        t1:Play()
        task.wait(1.1)

        local t2 = TweenService:Create(showcaseLogo, TweenInfo.new(1.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Size = UDim2.new(0, 76, 0, 76),
            Position = UDim2.new(0.5, 0, 0, -40),
            ImageTransparency = 0
        })
        t2:Play()
        task.wait(1.1)
    end
end)

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

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, 0, 0, 16)
statusText.Position = UDim2.new(0, 0, 0, 82)
statusText.BackgroundTransparency = 1
statusText.Font = Enum.Font.GothamBold
statusText.Text = "INITIALIZING ENGINE CORE..."
statusText.TextColor3 = Color3.fromRGB(0, 240, 255)
statusText.TextSize = 9.5
statusText.Parent = introCard

local barContainer = Instance.new("Frame")
barContainer.Size = UDim2.new(0, 300, 0, 12)
barContainer.Position = UDim2.new(0.5, -150, 0, 110)
barContainer.BackgroundColor3 = Color3.fromRGB(15, 18, 28)
barContainer.BorderSizePixel = 0
barContainer.Parent = introCard
Instance.new("UICorner", barContainer).CornerRadius = UDim.new(1, 0)

local barStroke = Instance.new("UIStroke", barContainer)
barStroke.Color = Color3.fromRGB(255, 45, 65)
barStroke.Thickness = 1.2
barStroke.Transparency = 0.4

local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(255, 45, 65)
barFill.BorderSizePixel = 0
barFill.ClipsDescendants = true
barFill.Parent = barContainer
Instance.new("UICorner", barFill).CornerRadius = UDim.new(1, 0)

local barGradient = Instance.new("UIGradient", barFill)
barGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 45, 65)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 120, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 240, 255))
})

local percentText = Instance.new("TextLabel")
percentText.Size = UDim2.new(1, 0, 0, 16)
percentText.Position = UDim2.new(0, 0, 0, 130)
percentText.BackgroundTransparency = 1
percentText.Font = Enum.Font.GothamBlack
percentText.Text = "0%"
percentText.TextColor3 = Color3.fromRGB(220, 230, 255)
percentText.TextSize = 11
percentText.Parent = introCard

task.spawn(function()
    local steps = {
        {p = 0.25, t = "INITIALIZING SECURE ENGINE CORE...", d = 0.8},
        {p = 0.55, t = "SPOOFING DEVICE PLATFORM VIA SECURE HOOK...", d = 0.8},
        {p = 0.85, t = "OPTIMIZING SAFE FREECAM & ADVANCED SPECTATE...", d = 0.8},
        {p = 1.00, t = "BYPASS READY! WELCOME NOPAL JLXC", d = 0.5}
    }

    local currentPercent = 0
    for _, step in ipairs(steps) do
        TweenService:Create(barFill, TweenInfo.new(step.d, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
            Size = UDim2.new(step.p, 0, 1, 0)
        }):Play()
        statusText.Text = step.t
        
        local targetPercent = math.floor(step.p * 100)
        local startPercent = currentPercent
        local stepsCount = targetPercent - startPercent
        local delayPerStep = step.d / math.max(stepsCount, 1)

        task.spawn(function()
            for i = startPercent + 1, targetPercent do
                percentText.Text = i .. "%"
                currentPercent = i
                task.wait(delayPerStep)
            end
        end)
        
        task.wait(step.d)
    end
    
    task.wait(0.2)
    
    local closeIntro = TweenService:Create(introCard, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1
    })
    local fadeBg = TweenService:Create(introBg, TweenInfo.new(0.3), {BackgroundTransparency = 1})
    
    closeIntro:Play()
    fadeBg:Play()
    
    closeIntro.Completed:Wait()
    introBg:Destroy()
    
    main.Visible = true
    playSound(SOUND_UI_OPEN, 0.7)
    TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 420, 0, 260)
    }):Play()
end)

-- TOP BAR & NAVIGATION
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 38)
topBar.BackgroundTransparency = 1
topBar.Parent = main

local logoHolder = Instance.new("Frame")
logoHolder.Size = UDim2.new(0, 32, 0, 32)
logoHolder.Position = UDim2.new(0, 8, 0.5, -16)
logoHolder.BackgroundColor3 = Color3.fromRGB(22, 26, 38)
logoHolder.BorderSizePixel = 0
logoHolder.Parent = topBar
Instance.new("UICorner", logoHolder).CornerRadius = UDim.new(0, 6)

local logoIcon = Instance.new("ImageLabel")
logoIcon.Size = UDim2.new(1, -4, 1, -4)
logoIcon.Position = UDim2.new(0, 2, 0, 2)
logoIcon.BackgroundTransparency = 1
logoIcon.Image = CUSTOM_LOGO_ID
logoIcon.ImageTransparency = 0
logoIcon.Parent = logoHolder
Instance.new("UICorner", logoIcon).CornerRadius = UDim.new(0, 4)

local titleLbl = Instance.new("TextLabel")
titleLbl.Size = UDim2.new(0, 140, 1, 0)
titleLbl.Position = UDim2.new(0, 46, 0, 0)
titleLbl.BackgroundTransparency = 1
titleLbl.Font = Enum.Font.GothamBlack
titleLbl.Text = "NOPAL <font color=\"#FF2D41\">JLXC</font>"
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

local menuVisible = true
minBtn.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    sidebar.Visible = menuVisible
    contentArea.Visible = menuVisible
    TweenService:Create(main, TweenInfo.new(0.2), {
        Size = menuVisible and UDim2.new(0, 420, 0, 260) or UDim2.new(0, 420, 0, 38)
    }):Play()
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
    return frame
end

-- TABS
local combatTab = createTab("Combat")
local espTab = createTab("ESP Config")
local moveTab = createTab("Movement")

local colorList = {"Biru Cyan", "Hijau Neon", "Merah", "Kuning", "Ungu", "Pink Neon", "Oranye", "Putih", "Emas", "Lime", "Biru Tua"}

-- COMBAT TAB
addToggle(combatTab, "Camera Lock (Aimjlxc)", false, function(v) State.AimjlxcEnabled = v end)
addToggle(combatTab, "Instant Lock Mode", false, function(v) State.DirectLock = v end)
addSlider(combatTab, "Smoothness Speed", 1, 50, 5, function(v) State.Smoothness = v / 50 end)
addToggle(combatTab, "Movement Prediction", false, function(v) State.Prediction = v end)
addToggle(combatTab, "Wall Check (Ultra Presisi)", false, function(v) State.WallCheck = v end)
addSelector(combatTab, "Target Part", {"Head", "Torso", "HumanoidRootPart"}, 1, function(v) State.TargetPart = v end)
addToggle(combatTab, "Show AimPOV Circle", false, function(v) State.ShowAimPOV = v end)
addSlider(combatTab, "AimPOV Radius", 50, 1500, 150, function(v) State.AimPOVRadius = v end)
addSelector(combatTab, "Warna AimPOV Circle", colorList, 1, function(v)
    State.AimPOVColor = ColorMap[v] or Color3.fromRGB(0, 240, 255)
end)

addToggle(combatTab, "Anti Spectate Admin", true, function(v)
    State.AntiSpectateAdmin = v
end)

addToggle(combatTab, "Aktifkan Spectate System", false, function(v)
    State.SpectateEnabled = v
    specUI.Visible = v
    if not v then
        Camera.CameraType = Enum.CameraType.Custom
        Camera.CameraSubject = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    else
        updateSpectateTarget(0)
    end
end)

addToggle(combatTab, "Invisible Mode (Full Ghost)", false, function(v) 
    State.InvisibleMode = v 
    if not v and LocalPlayer.Character then
        local myChar = LocalPlayer.Character
        for _, p in ipairs(myChar:GetDescendants()) do
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

addToggle(combatTab, "Hitbox Expander", false, function(v) State.HitboxExpander = v end)
addSlider(combatTab, "Hitbox Size", 0, 100, 15, function(v) State.HitboxSize = v end)
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

-- MOVEMENT TAB
addSlider(moveTab, "Walk Speed Bypass", 16, 300, 16, function(v) State.WalkSpeedVal = v end)
addSlider(moveTab, "Jump Power", 50, 1000, 50, function(v) State.JumpPowerVal = v end)

addToggle(moveTab, "Super Smooth Movement", false, function(v) State.SmoothMovement = v end)
addSlider(moveTab, "Smoothness Factor", 1, 50, 25, function(v) State.SmoothFactor = v / 100 end)

addToggle(moveTab, "FiveM Blink (Desync Musuh)", false, function(v) State.FiveMBlink = v end)
addSlider(moveTab, "Blink Intensity (Intensitas Lag)", 1, 30, 10, function(v) State.BlinkIntensity = v end)

addToggle(moveTab, "Infinite Jump", false, function(v) State.InfiniteJump = v end)
addToggle(moveTab, "Noclip Mode", false, function(v) State.NoclipEnabled = v end)
addToggle(moveTab, "Fly Mode UI (Hover Presisi)", false, function(v) 
    State.FlyEnabled = v 
    flyControls.Visible = v
end)
addSlider(moveTab, "Fly Speed", 20, 500, 100, function(v) State.FlySpeed = v end)

-- FREECAM CONFIGS
local sliderSens, sliderFly, sliderScale

addToggle(moveTab, "Freecam Mode (Touch UI)", false, function(v) 
    toggleFreecamMode(v)
    if sliderSens then sliderSens.Visible = v end
    if sliderFly then sliderFly.Visible = v end
    if sliderScale then sliderScale.Visible = v end
end)

sliderSens = addSlider(moveTab, "Kecepatan Geser Layar", 1, 50, 12, function(v) 
    State.FreecamSens = v / 10 
end)
sliderFly = addSlider(moveTab, "Freecam Fly Speed", 1, 20, 2, function(v) State.FreecamSpeed = v end)
sliderScale = addSlider(moveTab, "Ukuran Scale UI Freecam", 50, 150, 100, function(v)
    State.FreecamUIScale = v / 100
    fcScaleConstraint.Scale = State.FreecamUIScale
end)

sliderSens.Visible = false
sliderFly.Visible = false
sliderScale.Visible = false

addToggle(moveTab, "Spinbot Karakter", false, function(v) State.SpinBotEnabled = v end)
addSlider(moveTab, "Kecepatan Muter (Spin)", 10, 300, 50, function(v) State.SpinSpeed = v end)

-- KEYBIND ROLLING ('C')
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed or not State.ScriptActive then return end
    if input.KeyCode == Enum.KeyCode.C and not State.IsRolling then
        local char = LocalPlayer.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.MoveDirection.Magnitude > 0 then
                State.IsRolling = true
                task.spawn(function()
                    local moveDir = hum.MoveDirection
                    for i = 1, 10 do
                        if hrp and hrp.Parent then
                            hrp.CFrame = hrp.CFrame + (moveDir * (State.RollingSpeed / 10))
                        end
                        task.wait(0.01)
                    end
                    State.IsRolling = false
                end)
            end
        end
    end
end)

local function getCurrentColor()
    return State.ESPRGB and Color3.fromHSV((tick() % 3) / 3, 1, 1) or State.ESPColor
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

-- WALL CHECK
local function checkWallObstructionBrutal(targetPart)
    if not targetPart or not targetPart.Parent then return false end
    local char = targetPart.Parent
    local camPos = Camera.CFrame.Position

    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    rayParams.FilterDescendantsInstances = {LocalPlayer.Character, char, Camera}
    rayParams.IgnoreWater = true

    local checkPoints = {targetPart.Position}
    local head = char:FindFirstChild("Head")
    local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")

    if head and head ~= targetPart then table.insert(checkPoints, head.Position) end
    if torso and torso ~= targetPart then table.insert(checkPoints, torso.Position) end

    for _, point in ipairs(checkPoints) do
        local rayResult = Workspace:Raycast(camPos, point - camPos, rayParams)
        if not rayResult then return true end
    end
    return false
end

local function isCharacterAlive(char)
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 or hum:GetState() == Enum.HumanoidStateType.Dead then return false end
    return true
end

local function isTargetValidForAimjlxc(targetPart)
    if not targetPart or not targetPart.Parent then return false end
    local char = targetPart.Parent
    if not isCharacterAlive(char) then return false end

    local plr = Players:GetPlayerFromCharacter(char)
    if plr and State.ESP_TeamCheck and plr.Team == LocalPlayer.Team then return false end

    local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
    if not onScreen or screenPos.Z <= 0 then return false end

    local viewportCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    if (Vector2.new(screenPos.X, screenPos.Y) - viewportCenter).Magnitude > State.AimPOVRadius then return false end
    
    if State.WallCheck and not checkWallObstructionBrutal(targetPart) then return false end

    return true
end

local function getBestTargetBrutal()
    if CurrentActiveTarget and isTargetValidForAimjlxc(CurrentActiveTarget) then return CurrentActiveTarget end
    local viewportCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local closestPart, minDistance = nil, State.AimPOVRadius

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            if State.ESP_TeamCheck and plr.Team == LocalPlayer.Team then continue end
            local targetPart = getExactTargetPart(plr.Character)
            
            if targetPart and isTargetValidForAimjlxc(targetPart) then
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

-- ESP ENGINE SAFE CREATION
local ESPObjects = {}
local function createDrawing(class, properties)
    local obj = safeDrawingNew(class)
    if obj then
        for prop, val in pairs(properties or {}) do obj[prop] = val end
    end
    return obj
end

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
        C1 = createDrawing("Line", {Thickness = 1.5, Visible = false}),
        C2 = createDrawing("Line", {Thickness = 1.5, Visible = false}),
        C3 = createDrawing("Line", {Thickness = 1.5, Visible = false}),
        C4 = createDrawing("Line", {Thickness = 1.5, Visible = false}),
        C5 = createDrawing("Line", {Thickness = 1.5, Visible = false}),
        C6 = createDrawing("Line", {Thickness = 1.5, Visible = false}),
        C7 = createDrawing("Line", {Thickness = 1.5, Visible = false}),
        C8 = createDrawing("Line", {Thickness = 1.5, Visible = false}),

        HealthBarOutline = createDrawing("Square", {Thickness = 1, Filled = true, Color = Color3.fromRGB(0, 0, 0), Visible = false}),
        HealthBar = createDrawing("Square", {Thickness = 1, Filled = true, Visible = false}),
        HeadDot = createDrawing("Circle", {Radius = 3, Filled = true, Visible = false}),
        NameText = createDrawing("Text", {Size = 10, Center = true, Outline = true, Visible = false}),
        Tracer = createDrawing("Line", {Thickness = 1.2, Visible = false}),

        Skel1 = createDrawing("Line", {Thickness = 1.2, Visible = false}),
        Skel2 = createDrawing("Line", {Thickness = 1.2, Visible = false}),
        Skel3 = createDrawing("Line", {Thickness = 1.2, Visible = false}),
        Skel4 = createDrawing("Line", {Thickness = 1.2, Visible = false}),
        Skel5 = createDrawing("Line", {Thickness = 1.2, Visible = false})
    }
    ESPObjects[plr] = {Player = plr, Drawing = draw}
end

for _, p in ipairs(Players:GetPlayers()) do setupPlayerESP(p) end
table.insert(_G.JelyzxConnections, Players.PlayerAdded:Connect(setupPlayerESP))
table.insert(_G.JelyzxConnections, Players.PlayerRemoving:Connect(removePlayerESP))

local function resetAllDrawings(draw)
    for _, item in pairs(draw) do if item then item.Visible = false end end
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
        
        local activeColor = getCurrentColor()
        if isTargeted then
            activeColor = State.LockColor
        elseif isAdminPlayer(plr) then
            activeColor = ColorGold
        elseif isGodmodePlayer(plr) then
            activeColor = ColorGodmode
        end

        if char and hrp and head and hum and isCharacterAlive(char) and not isTeam and dist <= State.ESP_MaxDistance then
            if State.HitboxExpander then
                pcall(function()
                    hrp.Size = Vector3.new(State.HitboxSize, State.HitboxSize, State.HitboxSize)
                    hrp.Transparency = 0.7
                    hrp.CanCollide = false
                end)
            else
                pcall(function()
                    hrp.Size = Vector3.new(2, 2, 1)
                    hrp.Transparency = 1
                end)
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
                    if draw.C1 then draw.C1.From = Vector2.new(minX, minY); draw.C1.To = Vector2.new(minX + lineLen, minY); draw.C1.Color = activeColor; draw.C1.Visible = true end
                    if draw.C2 then draw.C2.From = Vector2.new(minX, minY); draw.C2.To = Vector2.new(minX, minY + lineLen); draw.C2.Color = activeColor; draw.C2.Visible = true end
                    if draw.C3 then draw.C3.From = Vector2.new(minX + width, minY); draw.C3.To = Vector2.new(minX + width - lineLen, minY); draw.C3.Color = activeColor; draw.C3.Visible = true end
                    if draw.C4 then draw.C4.From = Vector2.new(minX + width, minY); draw.C4.To = Vector2.new(minX + width, minY + lineLen); draw.C4.Color = activeColor; draw.C4.Visible = true end
                    if draw.C5 then draw.C5.From = Vector2.new(minX, minY + height); draw.C5.To = Vector2.new(minX + lineLen, minY + height); draw.C5.Color = activeColor; draw.C5.Visible = true end
                    if draw.C6 then draw.C6.From = Vector2.new(minX, minY + height); draw.C6.To = Vector2.new(minX, minY + height - lineLen); draw.C6.Color = activeColor; draw.C6.Visible = true end
                    if draw.C7 then draw.C7.From = Vector2.new(minX + width, minY + height); draw.C7.To = Vector2.new(minX + width - lineLen, minY + height); draw.C7.Color = activeColor; draw.C7.Visible = true end
                    if draw.C8 then draw.C8.From = Vector2.new(minX + width, minY + height); draw.C8.To = Vector2.new(minX + width, minY + height - lineLen); draw.C8.Color = activeColor; draw.C8.Visible = true end
                else
                    for i = 1, 8 do if draw["C"..i] then draw["C"..i].Visible = false end end
                end

                if State.ESP_HealthBar then
                    local healthPct = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                    local barWidth = 2.5
                    local barX, barY = minX - barWidth - 4, minY
                    if draw.HealthBarOutline then
                        draw.HealthBarOutline.Size = Vector2.new(barWidth, height)
                        draw.HealthBarOutline.Position = Vector2.new(barX, barY)
                        draw.HealthBarOutline.Visible = true
                    end

                    local barHeight = height * healthPct
                    if draw.HealthBar then
                        draw.HealthBar.Size = Vector2.new(barWidth, barHeight)
                        draw.HealthBar.Position = Vector2.new(barX, barY + (height - barHeight))
                        draw.HealthBar.Color = Color3.fromHSV(healthPct * 0.3, 1, 1)
                        draw.HealthBar.Visible = true
                    end
                else
                    if draw.HealthBarOutline then draw.HealthBarOutline.Visible = false end
                    if draw.HealthBar then draw.HealthBar.Visible = false end
                end

                if State.ESP_Tracers and draw.Tracer then
                    local startPos = Vector2.new(viewX / 2, viewY)
                    if State.ESP_TracerPos == "Tengah Tengah" then startPos = Vector2.new(viewX / 2, viewY / 2)
                    elseif State.ESP_TracerPos == "Atas Tengah" then startPos = Vector2.new(viewX / 2, 0) end
                    draw.Tracer.From = startPos
                    draw.Tracer.To = Vector2.new(hrpPos.X, minY + height)
                    draw.Tracer.Color = activeColor; draw.Tracer.Visible = true
                else
                    if draw.Tracer then draw.Tracer.Visible = false end
                end

                if State.ESP_HeadDots and draw.HeadDot then
                    draw.HeadDot.Position = Vector2.new(headPos.X, headPos.Y)
                    draw.HeadDot.Color = activeColor; draw.HeadDot.Visible = true
                else
                    if draw.HeadDot then draw.HeadDot.Visible = false end
                end

                if State.ESP_Names and draw.NameText then
                    draw.NameText.Text = string.format("%s [%dm]", plr.Name, math.floor(dist))
                    draw.NameText.Position = Vector2.new(hrpPos.X, minY - 14)
                    draw.NameText.Color = Color3.fromRGB(255, 255, 255)
                    draw.NameText.Visible = true
                else
                    if draw.NameText then draw.NameText.Visible = false end
                end

                if State.ESP_Skeleton then
                    local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or hrp
                    local leftArm = char:FindFirstChild("LeftHand") or char:FindFirstChild("Left Arm")
                    local rightArm = char:FindFirstChild("RightHand") or char:FindFirstChild("Right Arm")
                    local leftLeg = char:FindFirstChild("LeftFoot") or char:FindFirstChild("Left Leg")
                    local rightLeg = char:FindFirstChild("RightFoot") or char:FindFirstChild("Right Leg")

                    local function connectParts(lineObj, p1, p2)
                        if lineObj and p1 and p2 then
                            local pos1 = Camera:WorldToViewportPoint(p1.Position)
                            local pos2 = Camera:WorldToViewportPoint(p2.Position)
                            if pos1.Z > 0 and pos2.Z > 0 then
                                lineObj.From = Vector2.new(pos1.X, pos1.Y)
                                lineObj.To = Vector2.new(pos2.X, pos2.Y)
                                lineObj.Color = activeColor; lineObj.Visible = true
                                return
                            end
                        end
                        if lineObj then lineObj.Visible = false end
                    end

                    connectParts(draw.Skel1, head, torso)
                    connectParts(draw.Skel2, torso, leftArm)
                    connectParts(draw.Skel3, torso, rightArm)
                    connectParts(draw.Skel4, torso, leftLeg)
                    connectParts(draw.Skel5, torso, rightLeg)
                else
                    if draw.Skel1 then draw.Skel1.Visible = false end
                    if draw.Skel2 then draw.Skel2.Visible = false end
                    if draw.Skel3 then draw.Skel3.Visible = false end
                    if draw.Skel4 then draw.Skel4.Visible = false end
                    if draw.Skel5 then draw.Skel5.Visible = false end
                end
            else
                resetAllDrawings(draw)
            end
        else
            resetAllDrawings(draw)
        end
    end
end

-- RENDER LOOP
local mainRenderConn = RunService.RenderStepped:Connect(function(deltaTime)
    if not State.ScriptActive then return end

    processAntiSpectateProtection()

    if State.InvisibleMode and LocalPlayer.Character then
        pcall(function()
            local myChar = LocalPlayer.Character
            for _, item in ipairs(myChar:GetDescendants()) do
                if item:IsA("BasePart") then
                    item.Transparency = 1
                    item.LocalTransparencyModifier = 1
                elseif item:IsA("Decal") or item:IsA("Texture") then
                    item.Transparency = 1
                elseif item:IsA("BillboardGui") or item:IsA("SurfaceGui") then
                    item.Enabled = false
                end
            end
        end)
    end

    local baseCFrame = Camera.CFrame

    if State.FreecamEnabled then
        local rotCFrame = CFrame.Angles(0, freecamRotY, 0) * CFrame.Angles(freecamRotX, 0, 0)
        local moveVec = Vector3.new()

        if State.FreecamDir.Forward or UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveVec = moveVec + Vector3.new(0, 0, -1)
        end
        if State.FreecamDir.Backward or UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveVec = moveVec + Vector3.new(0, 0, 1)
        end
        if State.FreecamDir.Left or UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveVec = moveVec + Vector3.new(-1, 0, 0)
        end
        if State.FreecamDir.Right or UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveVec = moveVec + Vector3.new(1, 0, 0)
        end
        if State.FreecamDir.Up or UserInputService:IsKeyDown(Enum.KeyCode.E) then
            moveVec = moveVec + Vector3.new(0, 1, 0)
        end
        if State.FreecamDir.Down or UserInputService:IsKeyDown(Enum.KeyCode.Q) then
            moveVec = moveVec + Vector3.new(0, -1, 0)
        end

        local worldMove = rotCFrame:VectorToWorldSpace(moveVec * (State.FreecamSpeed * 0.8))
        freecamCFrame = CFrame.new(freecamCFrame.Position + worldMove) * rotCFrame
        Camera.CFrame = freecamCFrame
    elseif not State.SpectateEnabled then
        if State.AimjlxcEnabled then
            local targetPart = getBestTargetBrutal()
            if targetPart then
                local targetPos = targetPart.Position
                if State.Prediction and targetPart.Parent then
                    local hrp = targetPart.Parent:FindFirstChild("HumanoidRootPart")
                    if hrp then 
                        targetPos = targetPos + (hrp.AssemblyLinearVelocity * State.PredictionMult) 
                    end
                end

                local camPos = Camera.CFrame.Position
                local targetCFrame = CFrame.lookAt(camPos, targetPos)

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
            local fisheyeOffset = CFrame.Angles(0, 0, math.rad(math.sin(tick() * 2) * State.LYRFisheyeDegree))
            baseCFrame = baseCFrame * fisheyeOffset
        end

        if State.RealGepengEnabled then
            baseCFrame = baseCFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, State.GepengRatio, 0, 0, 0, 1)
        end

        Camera.CFrame = baseCFrame
    end

    local viewportCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    if aimPovCircle then
        aimPovCircle.Position = viewportCenter
        aimPovCircle.Radius = State.AimPOVRadius
        aimPovCircle.Color = CurrentActiveTarget and State.LockColor or State.AimPOVColor
        aimPovCircle.Visible = State.ShowAimPOV and State.AimjlxcEnabled and not State.FreecamEnabled
    end

    hideAllCrosshair()
    if State.CustomCrosshair then
        local cColor = State.CrosshairColor
        local cType = State.CrosshairType
        
        if cType == "Silang (+)" then
            local len = 7
            if chLines[1] then chLines[1].From = Vector2.new(viewportCenter.X - len, viewportCenter.Y); chLines[1].To = Vector2.new(viewportCenter.X + len, viewportCenter.Y); chLines[1].Color = cColor; chLines[1].Visible = true end
            if chLines[2] then chLines[2].From = Vector2.new(viewportCenter.X, viewportCenter.Y - len); chLines[2].To = Vector2.new(viewportCenter.X, viewportCenter.Y + len); chLines[2].Color = cColor; chLines[2].Visible = true end
        elseif cType == "Dot (.)" and chCircle then
            chCircle.Position = viewportCenter
            chCircle.Radius = 2.5
            chCircle.Filled = true
            chCircle.Color = cColor
            chCircle.Visible = true
        elseif cType == "Kotak (Square)" then
            local s = 5
            if chLines[1] then chLines[1].From = Vector2.new(viewportCenter.X - s, viewportCenter.Y - s); chLines[1].To = Vector2.new(viewportCenter.X + s, viewportCenter.Y - s); chLines[1].Color = cColor; chLines[1].Visible = true end
            if chLines[2] then chLines[2].From = Vector2.new(viewportCenter.X + s, viewportCenter.Y - s); chLines[2].To = Vector2.new(viewportCenter.X + s, viewportCenter.Y + s); chLines[2].Color = cColor; chLines[2].Visible = true end
            if chLines[3] then chLines[3].From = Vector2.new(viewportCenter.X + s, viewportCenter.Y + s); chLines[3].To = Vector2.new(viewportCenter.X - s, viewportCenter.Y + s); chLines[3].Color = cColor; chLines[3].Visible = true end
            if chLines[4] then chLines[4].From = Vector2.new(viewportCenter.X - s, viewportCenter.Y + s); chLines[4].To = Vector2.new(viewportCenter.X - s, viewportCenter.Y - s); chLines[4].Color = cColor; chLines[4].Visible = true end
        elseif cType == "X-Shape (X)" then
            local d = 5
            if chLines[1] then chLines[1].From = Vector2.new(viewportCenter.X - d, viewportCenter.Y - d); chLines[1].To = Vector2.new(viewportCenter.X + d, viewportCenter.Y + d); chLines[1].Color = cColor; chLines[1].Visible = true end
            if chLines[2] then chLines[2].From = Vector2.new(viewportCenter.X + d, viewportCenter.Y - d); chLines[2].To = Vector2.new(viewportCenter.X - d, viewportCenter.Y + d); chLines[2].Color = cColor; chLines[2].Visible = true end
        elseif cType == "Lingkaran (Circle)" and chCircle then
            chCircle.Position = viewportCenter
            chCircle.Radius = 6
            chCircle.Filled = false
            chCircle.Color = cColor
            chCircle.Visible = true
        end
    end

    updateESPPosition()
end)
table.insert(_G.JelyzxConnections, mainRenderConn)

-- INFINITE JUMP
local function triggerJump()
    if State.InfiniteJump and State.ScriptActive then
        pcall(function()
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hum and hrp then
                    hum:ChangeState(Enum.HumanoidStateType.Jumping)
                    hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, State.JumpPowerVal or 50, hrp.AssemblyLinearVelocity.Z)
                end
            end
        end)
    end
end

table.insert(_G.JelyzxConnections, UserInputService.JumpRequest:Connect(triggerJump))

-- STEPPED PHYSICS WITH ANTI-DETECTIONS
local spinAngle = 0
local flyBodyVelocity = nil
local flyBodyGyro = nil
local desyncTick = 0

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

            if State.SmoothMovement and hrp and hum then
                local moveDir = hum.MoveDirection
                if moveDir.Magnitude > 0 then
                    local targetVel = moveDir * State.WalkSpeedVal
                    hrp.AssemblyLinearVelocity = hrp.AssemblyLinearVelocity:Lerp(Vector3.new(targetVel.X, hrp.AssemblyLinearVelocity.Y, targetVel.Z), State.SmoothFactor)
                end
            end

            if State.FiveMBlink and hrp and hum and not State.FlyEnabled then
                if hum.MoveDirection.Magnitude > 0 then
                    desyncTick = desyncTick + 1
                    local lagDelay = math.clamp(35 - State.BlinkIntensity, 5, 30)
                    
                    if desyncTick % lagDelay ~= 0 then
                        hrp.AssemblyLinearVelocity = hrp.AssemblyLinearVelocity * 0.05
                    end
                else
                    desyncTick = 0
                end
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
                local targetYVelocity = 0

                if State.FlyUp or UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    targetYVelocity = State.FlySpeed
                elseif State.FlyDown or UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    targetYVelocity = -State.FlySpeed
                else
                    targetYVelocity = 0
                end

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
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end
end)

-- CLEANUP & SAFE DESTROY
closeBtn.MouseButton1Click:Connect(function()
    State.ScriptActive = false
    toggleFreecamMode(false)
    if aimPovCircle then aimPovCircle.Visible = false end
    hideAllCrosshair()
    pcall(function() 
        if aimPovCircle then aimPovCircle:Remove() end
        for _, l in ipairs(chLines) do if l then l:Remove() end end
        if chCircle then chCircle:Remove() end
    end)
    if flyBodyVelocity then flyBodyVelocity:Destroy() end
    if flyBodyGyro then flyBodyGyro:Destroy() end
    Camera.CameraType = Enum.CameraType.Custom
    Camera.FieldOfView = 70
    Camera.CameraSubject = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    for _, conn in ipairs(_G.JelyzxConnections) do pcall(function() conn:Disconnect() end) end
    table.clear(_G.JelyzxConnections)
    for plr in pairs(ESPObjects) do removePlayerESP(plr) end
    gui:Destroy()
end)
