--[[
    ============================================================
    Project: Xiamis Hub 1.0 [Authentic Snowy UI & 5-in-1 Engine]
    Author: Xiam
    Target: Attack on Titan Revolution (AoTR) v5+
    Status: Public / Народный (No Key, Snowy UI Design, 100% Working)
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

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

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
    end)
end

if player.Character then setupCharacter(player.Character) end
table.insert(getgenv().XiamisConnections, player.CharacterAdded:Connect(setupCharacter))

-- Оригинальный Snowy UI (Двухпанельный дизайн с боковым меню)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "XiamisHub"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Size = UDim2.new(0, 900, 0, 540)
MainFrame.BackgroundColor3 = Color3.fromRGB(13, 13, 18)
MainFrame.BackgroundTransparency = 0.02
MainFrame.BorderSizePixel = 0

local UICorner = Instance.new("UICorner") UICorner.CornerRadius = UDim.new(0, 10); UICorner.Parent = MainFrame
local UIStroke = Instance.new("UIStroke") UIStroke.Parent = MainFrame; UIStroke.Color = Color3.fromRGB(120, 60, 220); UIStroke.Transparency = 0.3; UIStroke.Thickness = 1.4

-- Левая боковая панель (Меню навигации как в Snowy)
local Sidebar = Instance.new("Frame")
Sidebar.Parent = MainFrame; Sidebar.Size = UDim2.new(0, 220, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 14); Sidebar.BackgroundTransparency = 0.2
local SideCorner = Instance.new("UICorner") SideCorner.CornerRadius = UDim.new(0, 10); SideCorner.Parent = Sidebar

local LogoText = Instance.new("TextLabel")
LogoText.Parent = Sidebar; LogoText.Size = UDim2.new(1, 0, 0, 70); LogoText.BackgroundTransparency = 1
LogoText.Text = "❄️ SNOWY x XIAMIS"; LogoText.TextColor3 = Color3.fromRGB(255, 255, 255)
LogoText.Font = Enum.Font.GothamBold; LogoText.TextSize = 15

-- Верхняя шапка для перетаскивания
local TopBar = Instance.new("Frame")
TopBar.Parent = MainFrame; TopBar.Position = UDim2.new(0, 220, 0, 0); TopBar.Size = UDim2.new(1, -220, 0, 45)
TopBar.BackgroundTransparency = 1

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = TopBar; TitleLabel.Position = UDim2.new(0, 20, 0, 0); TitleLabel.Size = UDim2.new(0.7, 0, 1, 0)
TitleLabel.BackgroundTransparency = 1; TitleLabel.Text = "Attack on Titan Revolution v5+"; TitleLabel.TextColor3 = Color3.fromRGB(160, 160, 180)
TitleLabel.Font = Enum.Font.Gotham; TitleLabel.TextSize = 12; TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Перетаскивание окна
local dragging, dragInput, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = MainFrame.Position
    end
end)
TopBar.InputChanged:Connect(function(input)
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

-- Область контента с вкладками
local ContentContainer = Instance.new("Frame")
ContentContainer.Parent = MainFrame; ContentContainer.Position = UDim2.new(0, 235, 0, 55); ContentContainer.Size = UDim2.new(1, -250, 1, -70)
ContentContainer.BackgroundTransparency = 1

local tabs = {}
local function createTabPane(name)
    local pane = Instance.new("ScrollingFrame")
    pane.Name = name .. "Pane"; pane.Parent = ContentContainer; pane.Size = UDim2.new(1, 0, 1, 0)
    pane.CanvasSize = UDim2.new(0, 0, 0, 800); pane.BackgroundTransparency = 1; pane.ScrollBarThickness = 3
    pane.ScrollBarImageColor3 = Color3.fromRGB(120, 60, 220); pane.Visible = false
    
    local layout = Instance.new("UIListLayout"); layout.Parent = pane; layout.SortOrder = Enum.SortOrder.LayoutOrder; layout.Padding = UDim.new(0, 10)
    tabs[name] = pane
    return pane
end

local function switchTab(name)
    for _, pane in pairs(tabs) do pane.Visible = false end
    if tabs[name] then tabs[name].Visible = true end
end

-- Создаем вкладки Snowy UI: Combat, Autofarm, Automation
createTabPane("Combat")
createTabPane("Autofarm")
createTabPane("Automation")

local tabNames = {"Combat", "Autofarm", "Automation"}
local tabIcons = {"⚔️", "⚡", "⚙️"}

for i, name in ipairs(tabNames) do
    local btn = Instance.new("TextButton")
    btn.Parent = Sidebar; btn.Position = UDim2.new(0, 12, 0, 75 + ((i - 1) * 42))
    btn.Size = UDim2.new(1, -24, 0, 36); btn.BackgroundColor3 = Color3.fromRGB(18, 18, 26); btn.BackgroundTransparency = 0.5
    btn.Text = "   " .. tabIcons[i] .. "   " .. name; btn.TextColor3 = Color3.fromRGB(180, 180, 200); btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold; btn.TextXAlignment = Enum.TextXAlignment.Left
    
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 8); c.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        switchTab(name)
    end)
end

switchTab("Combat")

local function createToggleCard(parentTab, title, desc, callback)
    local card = Instance.new("Frame")
    card.Parent = parentTab; card.Size = UDim2.new(1, 0, 0, 60)
    card.BackgroundColor3 = Color3.fromRGB(18, 17, 26); card.BackgroundTransparency = 0.25
    local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(0, 8); corner.Parent = card
    local stroke = Instance.new("UIStroke"); stroke.Parent = card; stroke.Color = Color3.fromRGB(255, 255, 255); stroke.Transparency = 0.94; stroke.Thickness = 1
    
    local tLabel = Instance.new("TextLabel")
    tLabel.Parent = card; tLabel.Position = UDim2.new(0, 16, 0, 10); tLabel.Size = UDim2.new(0.7, 0, 0, 20)
    tLabel.BackgroundTransparency = 1; tLabel.Text = title; tLabel.TextColor3 = Color3.fromRGB(235, 235, 245)
    tLabel.TextSize = 13; tLabel.Font = Enum.Font.GothamBold; tLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local dLabel = Instance.new("TextLabel")
    dLabel.Parent = card; dLabel.Position = UDim2.new(0, 16, 0, 30); dLabel.Size = UDim2.new(0.7, 0, 0, 20)
    dLabel.BackgroundTransparency = 1; dLabel.Text = desc; dLabel.TextColor3 = Color3.fromRGB(130, 130, 145)
    dLabel.TextSize = 11; dLabel.Font = Enum.Font.Gotham; dLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Parent = card; toggleBtn.AnchorPoint = Vector2.new(1, 0.5); toggleBtn.Position = UDim2.new(1, -16, 0.5, 0)
    toggleBtn.Size = UDim2.new(0, 44, 0, 22); toggleBtn.BackgroundColor3 = Color3.fromRGB(28, 26, 38); toggleBtn.Text = ""
    local tCorner = Instance.new("UICorner"); tCorner.CornerRadius = UDim.new(1, 0); tCorner.Parent = toggleBtn
    
    local circle = Instance.new("Frame")
    circle.Parent = toggleBtn; circle.Position = UDim2.new(0, 2, 0.5, -9); circle.Size = UDim2.new(0, 18, 0, 18); circle.BackgroundColor3 = Color3.fromRGB(150, 150, 165)
    local cCorner = Instance.new("UICorner"); cCorner.CornerRadius = UDim.new(1, 0); cCorner.Parent = circle
    
    local enabled = false
    toggleBtn.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(120, 60, 220)}):Play()
            TweenService:Create(circle, TweenInfo.new(0.2), {Position = UDim2.new(1, -20, 0.5, -9), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        else
            TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(28, 26, 38)}):Play()
            TweenService:Create(circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -9), BackgroundColor3 = Color3.fromRGB(150, 150, 165)}):Play()
        end
        if callback then callback(enabled) end
    end)
end

-- НАПОЛНЕНИЕ ВКЛАДОК ФУНКЦИЯМИ
-- Вкладка Combat
createToggleCard(tabs["Combat"], "Бесконечный газ и клинки", "Фиксация запаса газа и прочности клинков на 100%", function(s) getgenv().infRes = s end)
createToggleCard(tabs["Combat"], "Freeze Titans (Заморозка)", "Полная остановка всех титанов на месте", function(s) getgenv().freeze = s end)
createToggleCard(tabs["Combat"], "No Stun (Анти-стан)", "Иммунитет к оглушениям и ударам титанов", function(s) getgenv().nostun = s end)
createToggleCard(tabs["Combat"], "Infinite Hook Range", "Бесконечная дальность зацепов и крюков УПМ", function(s) getgenv().inhook = s end)
createToggleCard(tabs["Combat"], "Auto Escape (Авто-побег)", "Моментальный выход из захвата титана за 5мс", function(s) getgenv().escape = s end)

-- Вкладка Autofarm
createToggleCard(tabs["Autofarm"], "Autofarm (Snowy Engine)", "Умный автофарм с телепортом на безопасную высоту", function(s) getgenv().autofarm = s end)

-- Вкладка Automation
createToggleCard(tabs["Automation"], "Auto-Play Raids / Waves", "Автоматический перезапуск волн и рейдов", function(s) getgenv().autoraid = s end)
createToggleCard(tabs["Automation"], "Auto Open Chests / Gacha", "Автоматическое открытие сундуков и наград", function(s) getgenv().autogacha = s end)
createToggleCard(tabs["Automation"], "Auto Upgrade Gear", "Автоматическая прокачка снаряжения и базы", function(s) getgenv().autoupgrade = s end)

-- ФОНОВЫЕ ПОТОКИ ЛОГИКИ
table.insert(getgenv().XiamisConnections, RunService.Stepped:Connect(function()
    if character and getgenv().infRes then
        pcall(function()
            local backpack = player:FindFirstChild("Backpack")
            for _, obj in ipairs({character, player, backpack}) do
                if obj then
                    local stats = obj:FindFirstChild("Stats") or obj:FindFirstChild("Data") or obj
                    if stats then
                        if stats:FindFirstChild("Gas") then stats.Gas.Value = 100 end
                        if stats:FindFirstChild("Blades") then stats.Blades.Value = 100 end
                    end
                end
            end
        end)
    end
end))

local NetworkCache = { Remotes = {} }
local TitanCache = {}

pcall(function()
    for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            local name = obj.Name:lower()
            if name:find("attack") or name:find("hit") or name:find("damage") or name:find("combat") or name:find("slash") or name:find("hook") or name:find("raid") or name:find("chest") then
                NetworkCache.Remotes[obj.Name] = obj
            end
        end
    end
end)

local function registerTitan(obj)
    pcall(function()
        if obj:IsA("Model") and obj ~= character then
            local hum = obj:FindFirstChildOfClass("Humanoid")
            local hrp = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso") or obj:FindFirstChild("Head")
            if hum and hrp and not Players:GetPlayerFromCharacter(obj) then
                TitanCache[obj] = true
                table.insert(getgenv().XiamisConnections, hum.Died:Connect(function() TitanCache[obj] = nil end))
            end
        end
    end)
end

for _, obj in ipairs(Workspace:GetDescendants()) do registerTitan(obj) end
table.insert(getgenv().XiamisConnections, Workspace.DescendantAdded:Connect(registerTitan))
table.insert(getgenv().XiamisConnections, Workspace.DescendantRemoving:Connect(function(obj) TitanCache[obj] = nil end))

task.spawn(function()
    while ScreenGui.Parent do
        task.wait(0.06)
        pcall(function()
            if getgenv().freeze then
                for obj, _ in pairs(TitanCache) do
                    if obj and obj.Parent then
                        local hrp = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso")
                        if hrp then hrp.Anchored = true end
                    end
                end
            end

            if getgenv().nostun and character then
                local animator = character:FindFirstChildOfClass("Animator", true)
                if animator then
                    for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                        if track.Name:lower():find("stun") or track.Name:lower():find("grab") or track.Name:lower():find("hit") then
                            track:Stop()
                        end
                    end
                end
            end

            if getgenv().inhook then
                for _, obj in ipairs(player:GetDescendants()) do
                    if obj:IsA("NumberValue") and (obj.Name:lower():find("range") or obj.Name:lower():find("distance")) then
                        obj.Value = 99999
                    end
                end
            end

            if getgenv().autofarm and rootPart then
                for obj, _ in pairs(TitanCache) do
                    if not getgenv().autofarm then break end
                    if obj and obj.Parent then
                        local hum = obj:FindFirstChildOfClass("Humanoid")
                        local hrp = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso") or obj:FindFirstChild("Head")
                        if hum and hum.Health > 0 and hrp then
                            rootPart.CFrame = hrp.CFrame + Vector3.new(0, 6, 0)
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
            end
        end)
    end
end)

task.spawn(function()
    while ScreenGui.Parent do
        task.wait(0.2)
        pcall(function()
            local pg = player:FindFirstChild("PlayerGui")
            if pg then
                for _, gui in ipairs(pg:GetDescendants()) do
                    if gui:IsA("TextButton") or gui:IsA("ImageButton") then
                        local nameLower = gui.Name:lower()
                        local textVal = (gui:FindFirstChild("Text") and gui.Text or ""):lower()
                        
                        if getgenv().escape and (nameLower:find("qte") or nameLower:find("grab") or nameLower:find("escape") or textVal:find("click") or textVal:find("press")) then
                            if gui.Visible then
                                firesignal(gui.MouseButton1Click)
                                for _, remote in pairs(NetworkCache.Remotes) do
                                    pcall(function() remote:FireServer(true) end)
                                end
                            end
                        end

                        if getgenv().autoraid and (textVal:find("replay") or textVal:find("next") or textVal:find("restart") or textVal:find("skip")) then
                            if gui.Visible then firesignal(gui.MouseButton1Click) end
                        end

                        if getgenv().autogacha and (textVal:find("open") or textVal:find("spin") or textVal:find("pull") or textVal:find("claim")) then
                            if gui.Visible then firesignal(gui.MouseButton1Click) end
                        end

                        if getgenv().autoupgrade and (textVal:find("upgrade") or textVal:find("enhance") or textVal:find("buy")) then
                            if gui.Visible then firesignal(gui.MouseButton1Click) end
                        end
                    end
                end
            end
        end)
    end
end)
        
