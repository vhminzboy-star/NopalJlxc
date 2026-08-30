-- ========================================================
-- NOPAL JLXC — CPB JELYZX (FULL SCRIPT FIXED PERFECT AIMBOT)
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
    if old:IsA("ScreenGui") and (old.Name == SECURE_GUI_NAME or old:FindFirstChild("IntroOverlay")) then
        pcall(function() old:Destroy() end)
    end
end

-- STATE MANAJEMEN (ASLI TANPA FITUR TAMBAHAN)
local State = {
    AimjlxcEnabled = false,
    Smoothness = 0.25,
    TargetPart = "Head",
    WallCheck = false,
    AimPOVRadius = 250,
    ShowAimPOV = false,
    AimPOVColor = Color3.fromRGB(0, 240, 255),

    ESP_CornerBox = false,
    ESP_Tracers = false,
    ESP_Names = false,
    ESP_TeamCheck = false,

    HitboxExpander = false,
    HitboxSize = 15,

    WalkSpeedVal = 16,
    JumpPowerVal = 50,
    NoclipEnabled = false,
    InfiniteJump = false,
    FlyEnabled = false,
    FlySpeed = 50,
    FlyUp = false,
    FlyDown = false,

    SpinBotEnabled = false,
    SpinSpeed = 30,

    ScriptActive = true
}

-- Safe Drawing API Engine
local aimPovCircle = nil
pcall(function()
    if Drawing and Drawing.new then
        aimPovCircle = Drawing.new("Circle")
        aimPovCircle.Thickness = 1.5
        aimPovCircle.NumSides = 64
        aimPovCircle.Filled = false
        aimPovCircle.Transparency = 0.85
        aimPovCircle.Color = State.AimPOVColor
        aimPovCircle.Visible = State.ShowAimPOV
    end
end)

local gui = Instance.new("ScreenGui")
gui.Name = SECURE_GUI_NAME
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = parentGui

-- FLY TOUCH UI (MOBILE COMPATIBLE)
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

-- MAIN PANEL UI
local main = Instance.new("Frame")
main.Name = generateRandomName(12)
main.Size = UDim2.new(0, 440, 0, 270)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(11, 13, 20)
main.BackgroundTransparency = 0.25
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = Color3.fromRGB(255, 45, 65)
mainStroke.Thickness = 1.8

-- TOP BAR (JUDUL TIDAK DIUBAH SAMA SEKALI)
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 38)
topBar.BackgroundTransparency = 1
topBar.Parent = main

local titleLbl = Instance.new("TextLabel")
titleLbl.Size = UDim2.new(0, 350, 1, 0)
titleLbl.Position = UDim2.new(0, 12, 0, 0)
titleLbl.BackgroundTransparency = 1
titleLbl.Font = Enum.Font.GothamBlack
titleLbl.Text = "NOPAL <font color=\"#FF2D41\">JLXC</font> <font color=\"#808080\">|</font> <font color=\"#00F0FF\">BETA CPB JELYZX</font>"
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

-- DRAGGABLE SYSTEM
local dragging, dragInput, dragStart, startPos
topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
topBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- SIDEBAR SYSTEM
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
    container.Visible = false
    container.CanvasSize = UDim2.new(0, 0, 0, 0)
    container.Parent = contentArea

    local containerLayout = Instance.new("UIListLayout")
    containerLayout.Padding = UDim.new(0, 5)
    containerLayout.Parent = container

    containerLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        container.CanvasSize = UDim2.new(0, 0, 0, containerLayout.AbsoluteContentSize.Y + 10)
    end)

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

-- HELPER UI BUILDERS
local function createToggle(parent, text, defaultState, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -6, 0, 26)
    frame.BackgroundColor3 = Color3.fromRGB(18, 22, 32)
    frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 5)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.7, 0, 1, 0)
    lbl.Position = UDim2.new(0, 8, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(210, 220, 240)
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 8
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 36, 0, 16)
    btn.Position = UDim2.new(1, -42, 0.5, -8)
    btn.BackgroundColor3 = defaultState and Color3.fromRGB(0, 240, 255) or Color3.fromRGB(35, 40, 55)
    btn.Text = defaultState and "ON" or "OFF"
    btn.TextColor3 = defaultState and Color3.fromRGB(10, 10, 15) or Color3.fromRGB(150, 150, 150)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 7.5
    btn.Parent = frame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

    local state = defaultState
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 240, 255) or Color3.fromRGB(35, 40, 55)
        btn.Text = state and "ON" or "OFF"
        btn.TextColor3 = state and Color3.fromRGB(10, 10, 15) or Color3.fromRGB(150, 150, 150)
        callback(state)
    end)
    return frame
end

local function createSlider(parent, text, min, max, defaultVal, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -6, 0, 34)
    frame.BackgroundColor3 = Color3.fromRGB(18, 22, 32)
    frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 5)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.6, 0, 0, 16)
    lbl.Position = UDim2.new(0, 8, 0, 2)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(210, 220, 240)
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 8
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame

    local valLbl = Instance.new("TextLabel")
    valLbl.Size = UDim2.new(0.3, 0, 0, 16)
    valLbl.Position = UDim2.new(0.7, -8, 0, 2)
    valLbl.BackgroundTransparency = 1
    valLbl.Text = tostring(defaultVal)
    valLbl.TextColor3 = Color3.fromRGB(0, 240, 255)
    valLbl.Font = Enum.Font.GothamBold
    valLbl.TextSize = 8
    valLbl.TextXAlignment = Enum.TextXAlignment.Right
    valLbl.Parent = frame

    local barBg = Instance.new("Frame")
    barBg.Size = UDim2.new(1, -16, 0, 6)
    barBg.Position = UDim2.new(0, 8, 0, 22)
    barBg.BackgroundColor3 = Color3.fromRGB(35, 40, 55)
    barBg.Parent = frame
    Instance.new("UICorner", barBg).CornerRadius = UDim.new(0, 3)

    local barFill = Instance.new("Frame")
    local initRatio = math.clamp((defaultVal - min) / (max - min), 0, 1)
    barFill.Size = UDim2.new(initRatio, 0, 1, 0)
    barFill.BackgroundColor3 = Color3.fromRGB(0, 240, 255)
    barFill.Parent = barBg
    Instance.new("UICorner", barFill).CornerRadius = UDim.new(0, 3)

    local isSliding = false
    local function updateSlider(input)
        local posX = input.Position.X - barBg.AbsolutePosition.X
        local ratio = math.clamp(posX / barBg.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * ratio)
        barFill.Size = UDim2.new(ratio, 0, 1, 0)
        valLbl.Text = tostring(val)
        callback(val)
    end

    barBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isSliding = true
            updateSlider(input)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if isSliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isSliding = false
        end
    end)
    return frame
end

-- TAB CREATION
local combatTab = createTab("Combat")
local espTab = createTab("ESP Config")
local moveTab = createTab("Movement")
local miscTab = createTab("Misc / Visual")

-- COMBAT CONTROLS
createToggle(combatTab, "Aimbot JLXC", State.AimjlxcEnabled, function(v) State.AimjlxcEnabled = v end)
createToggle(combatTab, "Show FOV Circle", State.ShowAimPOV, function(v) 
    State.ShowAimPOV = v 
    if aimPovCircle then aimPovCircle.Visible = v end
end)
createSlider(combatTab, "FOV Radius", 50, 500, State.AimPOVRadius, function(v) 
    State.AimPOVRadius = v 
    if aimPovCircle then aimPovCircle.Radius = v end
end)
createToggle(combatTab, "Hitbox Expander", State.HitboxExpander, function(v) State.HitboxExpander = v end)
createSlider(combatTab, "Hitbox Size", 2, 50, State.HitboxSize, function(v) State.HitboxSize = v end)

-- ESP CONTROLS
createToggle(espTab, "ESP Corner Box", State.ESP_CornerBox, function(v) State.ESP_CornerBox = v end)
createToggle(espTab, "ESP Tracers", State.ESP_Tracers, function(v) State.ESP_Tracers = v end)
createToggle(espTab, "ESP Names", State.ESP_Names, function(v) State.ESP_Names = v end)
createToggle(espTab, "ESP Team Check", State.ESP_TeamCheck, function(v) State.ESP_TeamCheck = v end)

-- MOVEMENT CONTROLS
createSlider(moveTab, "WalkSpeed", 16, 250, State.WalkSpeedVal, function(v) State.WalkSpeedVal = v end)
createSlider(moveTab, "JumpPower", 50, 300, State.JumpPowerVal, function(v) 
    State.JumpPowerVal = v 
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = v
    end
end)
createToggle(moveTab, "Fly Mode", State.FlyEnabled, function(v) 
    State.FlyEnabled = v 
    flyControls.Visible = v
end)
createSlider(moveTab, "Fly Speed", 10, 200, State.FlySpeed, function(v) State.FlySpeed = v end)
createToggle(moveTab, "Noclip", State.NoclipEnabled, function(v) State.NoclipEnabled = v end)
createToggle(moveTab, "Infinite Jump", State.InfiniteJump, function(v) State.InfiniteJump = v end)

-- MISC CONTROLS
createToggle(miscTab, "SpinBot", State.SpinBotEnabled, function(v) State.SpinBotEnabled = v end)
createSlider(miscTab, "Spin Speed", 5, 100, State.SpinSpeed, function(v) State.SpinSpeed = v end)

-- PENCARIAN TARGET AIMBOT TERDEKAT DARI CURSOR
local function getClosestTarget()
    local targetPart = nil
    local shortestDistance = State.AimPOVRadius
    local mousePos = UserInputService:GetMouseLocation()

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            if not State.ESP_TeamCheck or player.Team ~= LocalPlayer.Team then
                local part = player.Character:FindFirstChild(State.TargetPart) or player.Character:FindFirstChild("HumanoidRootPart")
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")

                if part and humanoid and humanoid.Health > 0 then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                    if onScreen then
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                        if dist < shortestDistance then
                            shortestDistance = dist
                            targetPart = part
                        end
                    end
                end
            end
        end
    end
    return targetPart
end

-- RENDER LOOP (PERBAIKAN AIMBOT MATIKAN OFFSET RECOIL)
local renderConn = RunService.RenderStepped:Connect(function()
    if not State.ScriptActive then return end

    pcall(function()
        -- FIX AIMBOT (KUNCI BEBAS DARI RECOIL SENJATA)
        if State.AimjlxcEnabled then
            local targetPart = getClosestTarget()
            if targetPart then
                local camPosition = Camera.CFrame.Position
                local targetPosition = targetPart.Position
                -- Interpolasi rotasi kamera murni tanpa recoil senjata yang menaikkan arah tembakan
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(camPosition, targetPosition), State.Smoothness)
            end
        end

        -- MOVEMENT & OTHER LOGIC
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")

            if hum and hrp then
                hum.WalkSpeed = State.WalkSpeedVal

                if State.FlyEnabled then
                    local targetY = 0
                    if State.FlyUp then targetY = State.FlySpeed
                    elseif State.FlyDown then targetY = -State.FlySpeed end
                    hrp.AssemblyLinearVelocity = Vector3.new(hum.MoveDirection.X * State.FlySpeed, targetY, hum.MoveDirection.Z * State.FlySpeed)
                end

                if State.SpinBotEnabled then
                    hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(State.SpinSpeed), 0)
                end

                if State.NoclipEnabled then
                    for _, part in ipairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end
        end

        if aimPovCircle then
            aimPovCircle.Position = UserInputService:GetMouseLocation()
        end

        if State.HitboxExpander then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    local targetHrp = p.Character:FindFirstChild("HumanoidRootPart")
                    if targetHrp then
                        targetHrp.Size = Vector3.new(State.HitboxSize, State.HitboxSize, State.HitboxSize)
                        targetHrp.Transparency = 0.7
                        targetHrp.CanCollide = false
                    end
                end
            end
        end
    end)
end)
table.insert(_G.JelyzxConnections, renderConn)

-- INFINITE JUMP HANDLER
local jumpConn = UserInputService.JumpRequest:Connect(function()
    if State.InfiniteJump and State.ScriptActive then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
end)
table.insert(_G.JelyzxConnections, jumpConn)

-- CLOSE BUTTON HANDLER
closeBtn.MouseButton1Click:Connect(function()
    State.ScriptActive = false
    if aimPovCircle then pcall(function() aimPovCircle:Remove() end) end
    gui:Destroy()
end)
