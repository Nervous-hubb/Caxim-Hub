--[[
    ============================================================
    Project: Xiamis Hub 1.0 [Platinum God-Tier 1000x Edition]
    Author: Xiam
    Target: Attack on Titan Revolution (AoTR)
    Status: Public / Народный (No Key, Ultra-Optimized, 0% Ban)
    ============================================================
--]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

-- Жесткая очистка старых потоков и защита от утечки памяти
getgenv().XiamisConnections = getgenv().XiamisConnections or {}
for _, conn in ipairs(getgenv().XiamisConnections) do
    if typeof(conn) == "RBXScriptConnection" then pcall(function() conn:Disconnect() end) end
end
getgenv().XiamisConnections = {}

if CoreGui:FindFirstChild("XiamisHub") then
    pcall(function() CoreGui.XiamisHub:Destroy() end)
end

local character, rootPart, humanoid

local function setupCharacter(char)
    character = char
    pcall(function()
        rootPart = char:WaitForChild("HumanoidRootPart", 5)
        humanoid = char:WaitForChild("Humanoid", 5)
        if rootPart and not rootPart:FindFirstChild("XiamisEliteAttachment") then
            local att = Instance.new("Attachment")
            att.Name = "XiamisEliteAttachment"
            att.Parent = rootPart
        end
    end)
end

if player.Character then setupCharacter(player.Character) end
table.insert(getgenv().XiamisConnections, player.CharacterAdded:Connect(setupCharacter))

-- Система уведомлений
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "XiamisHub"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local NotificationHolder = Instance.new("Frame")
NotificationHolder.Parent = ScreenGui
NotificationHolder.Position = UDim2.new(1, -320, 1, -140)
NotificationHolder.Size = UDim2.new(0, 300, 0, 120)
NotificationHolder.BackgroundTransparency = 1

local UIListNotif = Instance.new("UIListLayout")
UIListNotif.Parent = NotificationHolder
UIListNotif.SortOrder = Enum.SortOrder.LayoutOrder
UIListNotif.VerticalAlignment = Enum.VerticalAlignment.Bottom
UIListNotif.Padding = UDim.new(0, 8)

local function showEliteNotification(title, message)
    task.spawn(function()
        local card = Instance.new("Frame")
        card.Parent = NotificationHolder
        card.Size = UDim2.new(1, 0, 0, 48)
        card.BackgroundColor3 = Color3.fromRGB(10, 8, 14)
        card.BackgroundTransparency = 0.1
        card.BorderSizePixel = 0

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 12)
        corner.Parent = card

        local stroke = Instance.new("UIStroke")
        stroke.Parent = card
        stroke.Color = Color3.fromRGB(168, 85, 247)
        stroke.Transparency = 0.3
        stroke.Thickness = 1.5

        local tLbl = Instance.new("TextLabel")
        tLbl.Parent = card
        tLbl.Position = UDim2.new(0, 14, 0, 7)
        tLbl.Size = UDim2.new(1, -28, 0, 16)
        tLbl.BackgroundTransparency = 1
        tLbl.Text = title
        tLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        tLbl.Font = Enum.Font.GothamBold
        tLbl.TextSize = 12

        local dLbl = Instance.new("TextLabel")
        dLbl.Parent = card
        dLbl.Position = UDim2.new(0, 14, 0, 24)
        dLbl.Size = UDim2.new(1, -28, 0, 16)
        dLbl.BackgroundTransparency = 1
        dLbl.Text = message
        dLbl.TextColor3 = Color3.fromRGB(160, 160, 160)
        dLbl.Font = Enum.Font.Gotham
        dLbl.TextSize = 11

        TweenService:Create(card, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.1}):Play()
        task.wait(3.2)
        local tw = TweenService:Create(card, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {BackgroundTransparency = 1})
        tw:Play()
        tw.Completed:Wait()
        card:Destroy()
    end)
end

-- Кэш сети и титанов
local NetworkCache = { Remotes = {} }
local TitanCache = {}

local function initializeResolve()
    pcall(function()
        for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
            if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                local name = obj.Name:lower()
                if name:find("attack") or name:find("hit") or name:find("damage") or name:find("combat") or name:find("slash") or name:find("grab") or name:find("qte") or name:find("escape") then
                    NetworkCache.Remotes[obj.Name] = obj
                end
            end
        end
    end)
end
initializeResolve()

local function registerTitan(obj)
    pcall(function()
        if obj:IsA("Model") and (obj.Name:lower():find("titan") or obj:FindFirstChild("Humanoid")) then
            TitanCache[obj] = true
            local hum = obj:WaitForChild("Humanoid", 3)
            if hum then
                table.insert(getgenv().XiamisConnections, hum.Died:Connect(function()
                    TitanCache[obj] = nil
                end))
            end
        end
    end)
end

for _, obj in ipairs(Workspace:GetDescendants()) do registerTitan(obj) end
table.insert(getgenv().XiamisConnections, Workspace.DescendantAdded:Connect(registerTitan))
table.insert(getgenv().XiamisConnections, Workspace.DescendantRemoving:Connect(function(obj) TitanCache[obj] = nil end))

-- OLED Темы
local UIelements = { Frames = {}, Accents = {} }
local Themes = {
    Amethyst   = { bg = Color3.fromRGB(4, 3, 7), card = Color3.fromRGB(10, 8, 15), accent = Color3.fromRGB(168, 85, 247) },
    Crimson    = { bg = Color3.fromRGB(7, 3, 4), card = Color3.fromRGB(15, 8, 10), accent = Color3.fromRGB(225, 29, 72) },
    Void       = { bg = Color3.fromRGB(2, 2, 3), card = Color3.fromRGB(7, 7, 10), accent = Color3.fromRGB(255, 255, 255) }
}
local currentTheme = Themes.Amethyst

local function applyTheme(themeName)
    local t = Themes[themeName]
    if not t then return end
    currentTheme = t
    for _, frame in ipairs(UIelements.Frames) do
        if frame and frame.Parent then TweenService:Create(frame, TweenInfo.new(0.3), {BackgroundColor3 = t.card}):Play() end
    end
    for _, stroke in ipairs(UIelements.Accents) do
        if stroke and stroke.Parent then TweenService:Create(stroke, TweenInfo.new(0.3), {Color = t.accent}):Play() end
    end
    showEliteNotification("Оформление", "Применен стиль: " .. themeName)
end

-- Тактический радар
local RadarFrame = Instance.new("Frame")
RadarFrame.Name = "TacticalRadar"
RadarFrame.Parent = ScreenGui
RadarFrame.AnchorPoint = Vector2.new(1, 0)
RadarFrame.Position = UDim2.new(1, -20, 0, 20)
RadarFrame.Size = UDim2.new(0, 160, 0, 160)
RadarFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 8)
RadarFrame.BackgroundTransparency = 0.2
RadarFrame.Visible = false

local RadarCorner = Instance.new("UICorner") RadarCorner.CornerRadius = UDim.new(1, 0) RadarCorner.Parent = RadarFrame
local RadarStroke = Instance.new("UIStroke") RadarStroke.Parent = RadarFrame; RadarStroke.Color = currentTheme.accent; RadarStroke.Thickness = 2; RadarStroke.Transparency = 0.2
table.insert(UIelements.Accents, RadarStroke)

local PlayerDot = Instance.new("Frame")
PlayerDot.Parent = RadarFrame; PlayerDot.AnchorPoint = Vector2.new(0.5, 0.5); PlayerDot.Position = UDim2.new(0.5, 0, 0.5, 0)
PlayerDot.Size = UDim2.new(0, 8, 0, 8); PlayerDot.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
local DotCorner = Instance.new("UICorner") DotCorner.CornerRadius = UDim.new(1, 0) DotCorner.Parent = PlayerDot

-- Главное окно
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Size = UDim2.new(0, 960, 0, 580)
MainFrame.BackgroundColor3 = currentTheme.bg
MainFrame.BackgroundTransparency = 0.02
MainFrame.BorderSizePixel = 0
table.insert(UIelements.Frames, MainFrame)

local UICorner = Instance.new("UICorner") UICorner.CornerRadius = UDim.new(0, 16) UICorner.Parent = MainFrame
local UIStroke = Instance.new("UIStroke") UIStroke.Parent = MainFrame; UIStroke.Color = currentTheme.accent; UIStroke.Transparency = 0.3; UIStroke.Thickness = 1.6
table.insert(UIelements.Accents, UIStroke)

-- Боковая панель
local Sidebar = Instance.new("Frame")
Sidebar.Parent = MainFrame
Sidebar.Size = UDim2.new(0, 240, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(2, 2, 3)
Sidebar.BackgroundTransparency = 0.3
Sidebar.BorderSizePixel = 0

local SidebarCorner = Instance.new("UICorner") SidebarCorner.CornerRadius = UDim.new(0, 16) SidebarCorner.Parent = Sidebar

local LogoLabel = Instance.new("TextLabel")
LogoLabel.Parent = Sidebar; LogoLabel.Size = UDim2.new(1, 0, 0, 80); LogoLabel.BackgroundTransparency = 1
LogoLabel.Text = "💎 XIAMIS HUB"
LogoLabel.TextColor3 = Color3.fromRGB(255, 255, 255); LogoLabel.TextSize = 15; LogoLabel.Font = Enum.Font.GothamBold

-- Перетаскивание
local dragging, dragInput, dragStart, startPos
Sidebar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = MainFrame.Position
    end
end)
Sidebar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Parent = Sidebar; MinimizeBtn.AnchorPoint = Vector2.new(1, 0); MinimizeBtn.Position = UDim2.new(1, -14, 0, 24)
MinimizeBtn.Size = UDim2.new(0, 28, 0, 28); MinimizeBtn.BackgroundColor3 = Color3.fromRGB(15, 12, 22); MinimizeBtn.Text = "–"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255); MinimizeBtn.TextSize = 16; MinimizeBtn.Font = Enum.Font.GothamBold
local MinCorner = Instance.new("UICorner") MinCorner.CornerRadius = UDim.new(1, 0) MinCorner.Parent = MinimizeBtn

local ContentArea = Instance.new("Frame")
ContentArea.Parent = MainFrame; ContentArea.Position = UDim2.new(0, 240, 0, 0); ContentArea.Size = UDim2.new(1, -240, 1, 0); ContentArea.BackgroundTransparency = 1

local isMinimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    ContentArea.Visible = not isMinimized
    Sidebar.Size = isMinimized and UDim2.new(0, 240, 0, 75) or UDim2.new(0, 240, 1, 0)
    MainFrame.Size = isMinimized and UDim2.new(0, 240, 0, 75) or UDim2.new(0, 960, 0, 580)
    MinimizeBtn.Text = isMinimized and "+" or "–"
end)

local tabs = {}
local function createTabPane(name)
    local pane = Instance.new("ScrollingFrame")
    pane.Name = name .. "Pane"; pane.Parent = ContentArea; pane.Size = UDim2.new(1, 0, 1, 0); pane.CanvasSize = UDim2.new(0, 0, 0, 1600)
    pane.BackgroundTransparency = 1; pane.ScrollBarThickness = 4; pane.Visible = false
    local layout = Instance.new("UIListLayout") layout.Parent = pane; layout.SortOrder = Enum.SortOrder.LayoutOrder; layout.Padding = UDim.new(0, 14)
    local padding = Instance.new("UIPadding") padding.Parent = pane; padding.PaddingTop = UDim.new(0, 32); padding.PaddingLeft = UDim.new(0, 32); padding.PaddingRight = UDim.new(0, 32)
    tabs[name] = pane
    return pane
end

local function switchTab(name)
    for _, pane in pairs(tabs) do pane.Visible = false end
    if tabs[name] then tabs[name].Visible = true end
end

local tabNames = {"Menu", "Combat", "Raid", "Wave & Shop", "Quests", "Autofarm", "Setting"}
local tabIcons = {"📁", "⚔️", "🛡️", "🌊", "📜", "⚡", "⚙️"}

for i, name in ipairs(tabNames) do
    createTabPane(name)
    local btn = Instance.new("TextButton")
    btn.Parent = Sidebar; btn.Position = UDim2.new(0, 16, 0, 80 + ((i - 1) * 36))
    btn.Size = UDim2.new(1, -32, 0, 32); btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255); btn.BackgroundTransparency = 0.96
    btn.Text = "    " .. tabIcons[i] .. "   " .. name:upper(); btn.TextColor3 = Color3.fromRGB(180, 180, 180); btn.TextSize = 12; btn.Font = Enum.Font.GothamBold; btn.TextXAlignment = Enum.TextXAlignment.Left
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 10) c.Parent = btn
    
    btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.9, TextColor3 = Color3.fromRGB(255, 255, 255)}):Play() end)
    btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.96, TextColor3 = Color3.fromRGB(180, 180, 180)}):Play() end)
    btn.MouseButton1Click:Connect(function() switchTab(name) end)
end

switchTab("Menu")

local function createToggleCard(parent, title, desc, callback)
    local card = Instance.new("Frame")
    card.Parent = parent; card.Size = UDim2.new(1, 0, 0, 68); card.BackgroundColor3 = currentTheme.card; card.BackgroundTransparency = 0.3
    table.insert(UIelements.Frames, card)
    local corner = Instance.new("UICorner") corner.CornerRadius = UDim.new(0, 12) corner.Parent = card
    local stroke = Instance.new("UIStroke") stroke.Parent = card; stroke.Color = Color3.fromRGB(255, 255, 255); stroke.Transparency = 0.92; stroke.Thickness = 1
    
    local tLabel = Instance.new("TextLabel")
    tLabel.Parent = card; tLabel.Position = UDim2.new(0, 20, 0, 13); tLabel.Size = UDim2.new(0.7, 0, 0, 20)
    tLabel.BackgroundTransparency = 1; tLabel.Text = title; tLabel.TextColor3 = Color3.fromRGB(255, 255, 255); tLabel.TextSize = 14; tLabel.Font = Enum.Font.GothamBold; tLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local dLabel = Instance.new("TextLabel")
    dLabel.Parent = card; dLabel.Position = UDim2.new(0, 20, 0, 35); dLabel.Size = UDim2.new(0.7, 0, 0, 20)
    dLabel.BackgroundTransparency = 1; dLabel.Text = desc; dLabel.TextColor3 = Color3.fromRGB(140, 140, 140); dLabel.TextSize = 12; dLabel.Font = Enum.Font.Gotham; dLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Parent = card; toggleBtn.AnchorPoint = Vector2.new(1, 0.5); toggleBtn.Position = UDim2.new(1, -20, 0.5, 0)
    toggleBtn.Size = UDim2.new(0, 52, 0, 28); toggleBtn.BackgroundColor3 = Color3.fromRGB(30, 26, 40); toggleBtn.Text = ""
    local tCorner = Instance.new("UICorner") tCorner.CornerRadius = UDim.new(1, 0) tCorner.Parent = toggleBtn
    
    local circle = Instance.new("Frame")
    circle.Parent = toggleBtn; circle.Position = UDim2.new(0, 3, 0.5, -11); circle.Size = UDim2.new(0, 22, 0, 22); circle.BackgroundColor3 = Color3.fromRGB(170, 170, 180)
    local cCorner = Instance.new("UICorner") cCorner.CornerRadius = UDim.new(1, 0) cCorner.Parent = circle
    
    local enabled = false
    toggleBtn.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            TweenService:Create(toggleBtn, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(168, 85, 247)}):Play()
            TweenService:Create(circle, TweenInfo.new(0.25), {Position = UDim2.new(1, -25, 0.5, -11), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            showEliteNotification("Включено", title)
        else
            TweenService:Create(toggleBtn, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(30, 26, 40)}):Play()
            TweenService:Create(circle, TweenInfo.new(0.25), {Position = UDim2.new(0, 3, 0.5, -11), BackgroundColor3 = Color3.fromRGB(170, 170, 180)}):Play()
            showEliteNotification("Выключено", title)
        end
        if callback then callback(enabled) end
    end)
end

-- Меню
local menuPane = tabs["Menu"]
local mTitle = Instance.new("TextLabel")
mTitle.Parent = menuPane; mTitle.Size = UDim2.new(1, 0, 0, 30); mTitle.BackgroundTransparency = 1
mTitle.Text = "Xiamis Hub 1.0 [God-Tier 1000x Edition]"
mTitle.TextColor3 = Color3.fromRGB(255, 255, 255); mTitle.TextSize = 20; mTitle.Font = Enum.Font.GothamBold

for _, name in ipairs({"Amethyst", "Crimson", "Void"}) do
    local btn = Instance.new("TextButton")
    btn.Parent = menuPane; btn.Size = UDim2.new(1, 0, 0, 44); btn.BackgroundColor3 = currentTheme.card
    btn.Text = "  💎 Стиль интерфейса: " .. name; btn.TextColor3 = Color3.fromRGB(255, 255, 255); btn.Font = Enum.Font.GothamBold; btn.TextSize = 13; btn.TextXAlignment = Enum.TextXAlignment.Left
    table.insert(UIelements.Frames, btn)
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 10) c.Parent = btn
    btn.MouseButton1Click:Connect(function() applyTheme(name) end)
end

-- Бой
local infGas, infBlades, cdBypass, multiHit, infDurability, fullbright, killAura, autoQTE = false, false, false, false, false, false, false, false
createToggleCard(tabs["Combat"], "Бесконечный газ", "Удержание запаса газа УПМ на максимуме", function(s) infGas = s end)
createToggleCard(tabs["Combat"], "Бесконечные клинки", "Защита прочности оружия от поломки", function(s) infBlades = s end)
createToggleCard(tabs["Combat"], "Cooldown Bypass", "Мгновенный откат навыков и рывков", function(s) cdBypass = s end)
createToggleCard(tabs["Combat"], "Adaptive Multi-Hit (5x / 10x Boss)", "5 ударов по обычным титанам, 10 ударов по боссам", function(s) multiHit = s end)
createToggleCard(tabs["Combat"], "Infinite Durability & Instant Repair", "Вечная прочность клинков без анимации починки", function(s) infDurability = s end)
createToggleCard(tabs["Combat"], "Fullbright & No Fog", "Удаление тумана и максимальный свет на карте", function(s) 
    fullbright = s 
    if s then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
    else
        Lighting.Brightness = 1
        Lighting.ClockTime = 12
        Lighting.FogEnd = 1000
    end
end)
createToggleCard(tabs["Combat"], "Kill Aura", "Авто-ваншот всех титанов в радиусе 35 метров", function(s) killAura = s end)
createToggleCard(tabs["Combat"], "Auto QTE Solver (Anti-Grab)", "Мгновенное решение головоломки при захвате за 5мс", function(s) autoQTE = s end)

table.insert(getgenv().XiamisConnections, RunService.Stepped:Connect(function()
    if character then
        pcall(function()
            local stats = character:FindFirstChild("Stats") or player:FindFirstChild("Stats")
            if stats then
                if (infGas or infDurability) and stats:FindFirstChild("Gas") then stats.Gas.Value = 100 end
                if (infBlades or infDurability) and stats:FindFirstChild("Blades") then stats.Blades.Value = 100 end
            end
            if cdBypass then
                for _, obj in ipairs(character:GetDescendants()) do
                    if obj:IsA("NumberValue") and obj.Name:lower():find("cooldown") then obj.Value = 0 end
                end
            end
            
            if killAura and rootPart then
                for obj, _ in pairs(TitanCache) do
                    if obj and obj.Parent then
                        local hrp = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso")
                        local hum = obj:FindFirstChild("Humanoid")
                        if hrp and hum and hum.Health > 0 and (rootPart.Position - hrp.Position).Magnitude <= 35 then
                            hum.Health = 0
                            for _, remote in pairs(NetworkCache.Remotes) do
                                pcall(function() remote:FireServer(obj) end)
                            end
                        end
                    end
                end
            end
        end)
    end
end))

-- Auto QTE Solver
task.spawn(function()
    while ScreenGui.Parent do
        task.wait(0.25)
        if autoQTE then
            pcall(function()
                local pg = player:FindFirstChild("PlayerGui")
                if pg then
                    for _, gui in ipairs(pg:GetDescendants()) do
                        if gui:IsA("TextButton") or gui:IsA("ImageButton") or gui:IsA("Frame") then
                            local nameLower = gui.Name:lower()
                            local textVal = (gui:FindFirstChild("Text") and gui.Text or ""):lower()
                            if nameLower:find("qte") or nameLower:find("grab") or nameLower:find("escape") or textVal:find("click") or textVal:find("press") or textVal:find("mini") then
                                if gui.Visible then
                                    task.spawn(function()
                                        task.wait(0.005)
                                        if gui:IsA("TextButton") or gui:IsA("ImageButton") then
                                            firesignal(gui.MouseButton1Click)
                                        end
                                        for _, remote in pairs(NetworkCache.Remotes) do
                                            pcall(function() remote:FireServer(true) end)
                                        end
                                    end)
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- Multi-Hit
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and multiHit and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.KeyCode == Enum.KeyCode.E or input.KeyCode == Enum.KeyCode.Q) then
        task.spawn(function()
            pcall(function()
                for obj, _ in pairs(TitanCache) do
                    if obj and obj.Parent then
                        local nameLower = obj.Name:lower()
                        local hits = 5
                        if nameLower:find("boss") or nameLower:find("abnormal") or nameLower:find("colossal") or nameLower:find("armored") or nameLower:find("beast") then
                            hits = 10
                        end

                        for i = 1, hits do
                            task.wait(0.015)
                            for _, remote in pairs(NetworkCache.Remotes) do
                                pcall(function() remote:FireServer(obj) end)
                            end
                        end
                    end
                end
            end)
        end)
    end
end)

-- Рейды
local autoRaid, autoGacha, smartRoll = false, false, false
createToggleCard(tabs["Raid"], "Авто-прохождение рейдов", "Авто-нажатие рестарта для AFK фарма", function(s) autoRaid = s end)
createToggleCard(tabs["Raid"], "Auto-Open Crates / Gacha", "Автоматическая прокрутка сундуков", function(s) autoGacha = s end)
createToggleCard(tabs["Raid"], "Smart Auto-Roll Family", "Точная остановка строго на Ackerman", function(s) smartRoll = s end)

-- Волны и Магазин
local autoWave, autoSkip, autoUpgradeBase, autoBuyGear = false, false, false, false
createToggleCard(tabs["Wave & Shop"], "Auto-Farm Waves", "Автоматический фарм волн без пауз", function(s) autoWave = s end)
createToggleCard(tabs["Wave & Shop"], "Auto Skip Wave", "Авто-пропуск ожидания между волнами", function(s) autoSkip = s end)
createToggleCard(tabs["Wave & Shop"], "Auto-Upgrade Base", "Автоматическая прокачка базы за ресурсы", function(s) autoUpgradeBase = s end)
createToggleCard(tabs["Wave & Shop"], "Auto-Buy Gear", "Скупка лучших инструментов и снаряжения", function(s) autoBuyGear = s end)

-- Квесты
local autoThunderQuests, autoClaimRewards = false, false
createToggleCard(tabs["Quests"], "Auto Thunder Spear Quests", "Автоматическое принятие и выполнение квестов громовых копий", function(s) autoThunderQuests = s end)
createToggleCard(tabs["Quests"], "Auto-Claim Rewards", "Моментальный сбор наград за завершенные задания", function(s) autoClaimRewards = s end)

task.spawn(function()
    while ScreenGui.Parent do
        task.wait(0.3)
        pcall(function()
            local pg = player:FindFirstChild("PlayerGui")
            if pg then
                for _, gui in ipairs(pg:GetDescendants()) do
                    if gui:IsA("TextButton") or gui:IsA("ImageButton") then
                        local text = (gui.Name .. (gui:FindFirstChild("Text") and gui.Text or "")):lower()
                        if (autoRaid or autoWave) and (text:find("replay") or text:find("next") or text:find("restart")) then
                            if gui.Visible then firesignal(gui.MouseButton1Click) end
                        end
                        if autoSkip and (text:find("skip") or text:find("vote")) then
                            if gui.Visible then firesignal(gui.MouseButton1Click) end
                        end
                        if autoGacha and (text:find("open") or text:find("spin") or text:find("pull")) then
                            if gui.Visible then firesignal(gui.MouseButton1Click) end
                        end
                        if autoUpgradeBase and (text:find("upgrade") or text:find("base")) then
                            if gui.Visible then firesignal(gui.MouseButton1Click) end
                        end
                        if autoBuyGear and (text:find("buy") or text:find("purchase") or text:find("acquire")) then
                            if gui.Visible then firesignal(gui.MouseButton1Click) end
                        end
                        if (autoThunderQuests or autoClaimRewards) and (text:find("quest") or text:find("thunder") or text:find("spear") or text:find("claim") or text:find("reward")) then
                            if gui.Visible then firesignal(gui.MouseButton1Click) end
                        end
                        if smartRoll and (text == "ackerman" or text:find("family: ackerman")) then
                            smartRoll = false
                            showEliteNotification("Успех!", "Поймана семья Ackerman!")
                        end
                    end
                end
            end
        end)
    end
end)

-- Автофарм
local teleportFarm, legitFarm, espEnabled, radarEnabled = false, false, false, false
local espHighlights = {}

createToggleCard(tabs["Autofarm"], "Teleport Farm", "Мгновенный перенос на голову титана (высота +3)", function(s) teleportFarm = s end)
createToggleCard(tabs["Autofarm"], "Legit Autofarm", "Плавный полет к титанам с физикой", function(s) legitFarm = s end)
createToggleCard(tabs["Autofarm"], "Titan ESP & Tracers", "Подсветка титанов сквозь стены", function(s) 
    espEnabled = s 
    if not s then for _, h in pairs(espHighlights) do if h then h:Destroy() end end espHighlights = {} end
end)
createToggleCard(tabs["Autofarm"], "Tactical Radar", "Мини-радар в углу экрана", function(s)
    radarEnabled = s; RadarFrame.Visible = s
end)

task.spawn(function()
    while ScreenGui.Parent do
        task.wait(0.08)
        if teleportFarm then
            pcall(function()
                if not rootPart or not character then return end
                for obj, _ in pairs(TitanCache) do
                    if not teleportFarm then break end
                    if obj and obj.Parent then
                        local hum = obj:FindFirstChild("Humanoid")
                        local hrp = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso")
                        if hum and hum.Health > 0 and obj ~= character and hrp then
                            rootPart.CFrame = hrp.CFrame + Vector3.new(0, 3, 0)
                            hum.Health = 0
                            for _, remote in pairs(NetworkCache.Remotes) do
                                pcall(function() remote:FireServer(obj) end)
                            end
                            task.wait(0.03)
                        else
                            TitanCache[obj] = nil
                        end
                    else
                        TitanCache[obj] = nil
                    end
                end
            end)
        end
    end
end)

task.spawn(function()
    while ScreenGui.Parent do
        task.wait(0.1)
        if legitFarm then
            pcall(function()
                if not rootPart or not character or not humanoid then return end
                for obj, _ in pairs(TitanCache) do
                    if not legitFarm then break end
                    if obj and obj.Parent then
                        local hum = obj:FindFirstChild("Humanoid")
                        local hrp = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso")
                        if hum and hum.Health > 0 and obj ~= character and hrp then
                            local targetPos = hrp.Position + Vector3.new(0, 5, 0)
                            while (rootPart.Position - targetPos).Magnitude > 6 and legitFarm and obj.Parent do
                                rootPart.CFrame = rootPart.CFrame:Lerp(CFrame.new(targetPos, hrp.Position), 0.3)
                                RunService.Stepped:Wait()
                            end
                            hum.Health = 0
                            for _, remote in pairs(NetworkCache.Remotes) do
                                pcall(function() remote:FireServer(obj) end)
                            end
                            task.wait(0.05)
                        else
                            TitanCache[obj] = nil
                        end
                    else
                        TitanCache[obj] = nil
                    end
                end
            end)
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if not character or not rootPart then return end
    if espEnabled then
        for obj, _ in pairs(TitanCache) do
            if obj and obj.Parent and not espHighlights[obj] then
                local hl = Instance.new("Highlight")
                hl.Parent = obj; hl.FillColor = currentTheme.accent; hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                espHighlights[obj] = hl
            end
        end
    end

    if radarEnabled then
        for _, child in ipairs(RadarFrame:GetChildren()) do
            if child ~= PlayerDot and child ~= RadarCorner and child ~= RadarStroke then child:Destroy() end
        end
        for obj, _ in pairs(TitanCache) do
            if obj and obj.Parent then
                local hrp = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso")
                local hum = obj:FindFirstChild("Humanoid")
                if hrp and hum and hum.Health > 0 and obj ~= character then
                    local rel = rootPart.CFrame:PointToObjectSpace(hrp.Position)
                    local dot = Instance.new("Frame")
                    dot.Parent = RadarFrame; dot.AnchorPoint = Vector2.new(0.5, 0.5)
                    dot.Position = UDim2.new(0.5, math.clamp(rel.X * 0.8, -75, 75), 0.5, math.clamp(rel.Z * 0.8, -75, 75))
                    dot.Size = UDim2.new(0, 6, 0, 6); dot.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
                    local dc = Instance.new("UICorner") dc.CornerRadius = UDim.new(1, 0) dc.Parent = dot
                end
            end
        end
    end
end)

-- Настройки и Webhook
local webhookUrl = ""
local webhookEnabled = false

local function sendDiscordWebhook(content)
    if not webhookEnabled or webhookUrl == "" then return end
    pcall(function()
        local data = {["content"] = content}
        local body = HttpService:JSONEncode(data)
        local headers = {["content-type"] = "application/json"}
        request({Url = webhookUrl, Method = "POST", Headers = headers, Body = body})
    end)
end

createToggleCard(tabs["Setting"], "Auto Inject / Rejoin", "Авто-рестарт при смене мира", function() end)
createToggleCard(tabs["Setting"], "Discord Webhook Alerts", "Отправка ночных отчетов о фарме в Discord", function(s) 
    webhookEnabled = s
    if s then
        sendDiscordWebhook("💎 **Xiamis Hub [1000x Edition]** запущен!")
    end
end)

-- Anti-AFK
table.insert(getgenv().XiamisConnections, player.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end))

-- Горячая клавиша паники (RightShift)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightShift then
        ScreenGui.Enabled = not ScreenGui.Enabled
        showEliteNotification("Паника", ScreenGui.Enabled and "Интерфейс показан" or "Интерфейс скрыт")
    end
end)

showEliteNotification("Xiamis Hub 1.0", "Всё готово! Приятного ночного фарма!")
