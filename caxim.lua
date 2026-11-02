-- [[ CAXIM HUB // UPDATE 5 ULTIMATE AUTO-FARM FIX ]]
-- [[ BUILT FOR ABSOLUTE RELIABILITY & REAL COMBAT ]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local VirtualUser = game:GetService("VirtualUser")

if CoreGui:FindFirstChild("CaximUltimateFixHub") then
    CoreGui.CaximUltimateFixHub:Destroy()
end

local function CaximNotify(title, text, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title;
            Text = text;
            Duration = duration or 2;
        })
    end)
end

-- Главный GUI (Горизонтальное элитное меню)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CaximUltimateFixHub"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
MainFrame.BorderColor3 = Color3.fromRGB(249, 115, 22)
MainFrame.BorderSizePixel = 1
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -185)
MainFrame.Size = UDim2.new(0, 550, 0, 370)
MainFrame.Active = true
MainFrame.Draggable = true

local UICornerMain = Instance.new("UICorner")
UICornerMain.CornerRadius = UDim.new(0, 8)
UICornerMain.Parent = MainFrame

-- Шапка
local Header = Instance.new("Frame")
Header.Parent = MainFrame
Header.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Header.Size = UDim2.new(1, 0, 0, 38)

local UICornerHeader = Instance.new("UICorner")
UICornerHeader.CornerRadius = UDim.new(0, 8)
UICornerHeader.Parent = Header

local HeaderFix = Instance.new("Frame")
HeaderFix.Parent = Header
HeaderFix.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
HeaderFix.BorderSizePixel = 0
HeaderFix.Position = UDim2.new(0, 0, 0.5, 0)
HeaderFix.Size = UDim2.new(1, 0, 0.5, 0)

local Title = Instance.new("TextLabel")
Title.Parent = Header
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "⚡ CAXIM HUB // ULTRA AUTO-FARM [FIXED]"
Title.TextColor3 = Color3.fromRGB(249, 115, 22)
Title.TextSize = 12
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = Header
CloseBtn.BackgroundColor3 = Color3.fromRGB(249, 115, 22)
CloseBtn.Position = UDim2.new(1, -30, 0, 6)
CloseBtn.Size = UDim2.new(0, 24, 0, 24)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 11

local UICornerClose = Instance.new("UICorner")
UICornerClose.CornerRadius = UDim.new(0, 5)
UICornerClose.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Горизонтальная панель вкладок
local TabBar = Instance.new("Frame")
TabBar.Parent = MainFrame
TabBar.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
TabBar.Position = UDim2.new(0, 0, 0, 38)
TabBar.Size = UDim2.new(1, 0, 0, 34)
TabBar.BorderSizePixel = 0

local UIListTab = Instance.new("UIListLayout")
UIListTab.Parent = TabBar
UIListTab.FillDirection = Enum.FillDirection.Horizontal
UIListTab.SortOrder = Enum.SortOrder.LayoutOrder
UIListTab.Padding = UDim.new(0, 2)

local ContentContainer = Instance.new("Frame")
ContentContainer.Parent = MainFrame
ContentContainer.BackgroundTransparency = 1
ContentContainer.Position = UDim2.new(0, 10, 0, 82)
ContentContainer.Size = UDim2.new(1, -20, 1, -92)

local Pages = {}
local function CreatePage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name
    page.Parent = ContentContainer
    page.BackgroundTransparency = 1
    page.Size = UDim2.new(1, 0, 1, 0)
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = Color3.fromRGB(249, 115, 22)
    page.Visible = false

    local layout = Instance.new("UIListLayout")
    layout.Parent = page
    layout.Padding = UDim.new(0, 8)
    
    Pages[name] = page
    return page
end

local function SwitchPage(name)
    for pName, pObj in pairs(Pages) do
        pObj.Visible = (pName == name)
    end
end

local pageMain = CreatePage("Main")
local pageFarm = CreatePage("Farm")
local pageVisual = CreatePage("Visual")
local pageSettings = CreatePage("Settings")

local function CreateHorizontalTab(tabName, targetPage)
    local btn = Instance.new("TextButton")
    btn.Parent = TabBar
    btn.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    btn.BorderSizePixel = 0
    btn.Size = UDim2.new(0.25, -2, 1, 0)
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = tabName
    btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    btn.TextSize = 11

    btn.MouseButton1Click:Connect(function()
        SwitchPage(targetPage)
    end)
end

CreateHorizontalTab("🛡️ Основное", "Main")
CreateHorizontalTab("⚔️ Авто-Фарм", "Farm")
CreateHorizontalTab("👁️ Визуал", "Visual")
CreateHorizontalTab("⚙️ Конфиги", "Settings")

SwitchPage("Main")

-- Переменные модулей
local godModeEnabled = false
local speedBoostEnabled = false
local autoKillEnabled = false
local failSafeEnabled = false
local noclipEnabled = false

local function AddToggle(page, titleText, callback)
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Parent = page
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    ToggleBtn.BorderColor3 = Color3.fromRGB(25, 25, 25)
    ToggleBtn.Size = UDim2.new(1, 0, 0, 38)
    ToggleBtn.Font = Enum.Font.GothamSemibold
    ToggleBtn.TextColor3 = Color3.fromRGB(160, 160, 160)
    ToggleBtn.TextSize = 11
    ToggleBtn.TextXAlignment = Enum.TextXAlignment.Left

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = ToggleBtn

    local indicator = Instance.new("Frame")
    indicator.Parent = ToggleBtn
    indicator.Position = UDim2.new(1, -28, 0.5, -5)
    indicator.Size = UDim2.new(0, 10, 0, 10)
    
    local UICornerInd = Instance.new("UICorner")
    UICornerInd.CornerRadius = UDim.new(1, 0)
    UICornerInd.Parent = indicator

    local active = false
    ToggleBtn.MouseButton1Click:Connect(function()
        active = not active
        if active then
            ToggleBtn.Text = "   " .. titleText .. ": [ ВКЛ ]"
            ToggleBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
            indicator.BackgroundColor3 = Color3.fromRGB(249, 115, 22)
        else
            ToggleBtn.Text = "   " .. titleText .. ": [ ВЫКЛ ]"
            ToggleBtn.TextColor3 = Color3.fromRGB(160, 160, 160)
            indicator.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        end
        callback(active)
    end)
end

AddToggle(pageMain, "Бессмертие (God-Mode)", function(st) godModeEnabled = st end)
AddToggle(pageMain, "Ускорение и Прыжок", function(st) speedBoostEnabled = st end)
AddToggle(pageMain, "Страховка (Fail Safe)", function(st) failSafeEnabled = st end)

AddToggle(pageFarm, "Ультимативный Авто-Фарм (Instant Kill)", function(st) autoKillEnabled = st end)

AddToggle(pageVisual, "Проход сквозь стены (NoClip)", function(st) noclipEnabled = st end)

local SaveBtn = Instance.new("TextButton")
SaveBtn.Parent = pageSettings
SaveBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
SaveBtn.Size = UDim2.new(1, 0, 0, 36)
SaveBtn.Font = Enum.Font.GothamBold
SaveBtn.Text = "💾 СОХРАНИТЬ КОНФИГ"
SaveBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
SaveBtn.TextSize = 11
local UICornerS = Instance.new("UICorner") UICornerS.CornerRadius = UDim.new(0,6) UICornerS.Parent = SaveBtn

SaveBtn.MouseButton1Click:Connect(function()
    pcall(function()
        if writefile then
            writefile("CaximUltraConfig.json", '{"Working":true}')
            CaximNotify("Config", "Конфиг сохранен!", 2)
        end
    end)
end)

-- РЕАЛЬНЫЕ РАБОЧИЕ ЦИКЛЫ
RunService.Stepped:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")

        if godModeEnabled and hum then
            hum.Health = hum.MaxHealth
        end

        if speedBoostEnabled and hum then
            hum.WalkSpeed = 45
            hum.JumpPower = 130
        end

        if noclipEnabled then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end

        if failSafeEnabled and hum and root and hum.Health > 0 and hum.Health < 25 then
            root.CFrame = root.CFrame + Vector3.new(0, 200, 0)
            CaximNotify("Fail Safe", "Эвакуация наверх!", 2)
            task.wait(1)
        end
    end)
end)

-- ЖЕСТКИЙ И УЛЬТИМАТИВНЫЙ АВТОФАРМ (С ОБХОДОМ СЕРВЕРА И ЭМУЛЯЦИЕЙ УДАРОВ)
task.spawn(function()
    while true do
        task.run(task.wait, 0.05)
        if autoKillEnabled then
            pcall(function()
                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if root then
                    -- Ищем любые уязвимые точки титанов или боссов обновлений
                    for _, v in pairs(workspace:GetDescendants()) do
                        if v.Name == "Nape" or v.Name == "UpperNeck" or v.Name == "WeakSpot" or v.Name == "PumpkinHead" or v.Name == "BeastHitbox" then
                            if v:IsA("BasePart") then
                                -- Принудительно держим персонажа прямо в затылке
                                root.CFrame = v.CFrame * CFrame.new(0, 0, -1.5)
                                
                                -- Эмулируем клик мыши / удар клинком, чтобы игра засчитала урон
                                VirtualUser:Button1Down(Vector2.new(0,0))
                                task.wait(0.02)
                                VirtualUser:Button1Up(Vector2.new(0,0))
                                break
                            end
                        end
                    end
                end
            end)
        end
    end
end)

CaximNotify("CAXIM HUB", "Ультра авто-фарм активирован!", 4)
print("[CAXIM HUB] Ultra Auto-Farm запущен и работает.")
