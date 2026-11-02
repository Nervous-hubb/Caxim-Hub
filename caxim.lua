-- [[ CAXIM HUB // WIDE LUNARZ MOCKUP // ULTIMATE COMBAT FIX ]]
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local VirtualUser = game:GetService("VirtualUser")

if CoreGui:FindFirstChild("CaximWideLunarZ") then
    CoreGui.CaximWideLunarZ:Destroy()
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

-- Широкое главное окно (Точный размер оригинального макета LunarZ)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CaximWideLunarZ"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainFrame.BorderColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BorderSizePixel = 1
MainFrame.Position = UDim2.new(0.5, -350, 0.5, -225)
MainFrame.Size = UDim2.new(0, 700, 0, 450)
MainFrame.Active = true
MainFrame.Draggable = true

local UICornerMain = Instance.new("UICorner")
UICornerMain.CornerRadius = UDim.new(0, 6)
UICornerMain.Parent = MainFrame

-- Левый сайдбар
local Sidebar = Instance.new("Frame")
Sidebar.Parent = MainFrame
Sidebar.BackgroundColor3 = Color3.fromRGB(7, 7, 7)
Sidebar.Size = UDim2.new(0, 180, 1, 0)
local UICornerSide = Instance.new("UICorner") UICornerSide.CornerRadius = UDim.new(0, 6) UICornerSide.Parent = Sidebar

local BrandLabel = Instance.new("TextLabel")
BrandLabel.Parent = Sidebar
BrandLabel.BackgroundTransparency = 1
BrandLabel.Position = UDim2.new(0, 18, 0, 18)
BrandLabel.Size = UDim2.new(1, -36, 0, 25)
BrandLabel.Font = Enum.Font.GothamBold
BrandLabel.Text = "LunarZ"
BrandLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
BrandLabel.TextSize = 16
BrandLabel.TextXAlignment = Enum.TextXAlignment.Left

local SubBrand = Instance.new("TextLabel")
SubBrand.Parent = Sidebar
SubBrand.BackgroundTransparency = 1
SubBrand.Position = UDim2.new(0, 18, 0, 40)
SubBrand.Size = UDim2.new(1, -36, 0, 15)
SubBrand.Font = Enum.Font.Gotham
SubBrand.Text = "AOT:R | CAXIM EDITION 🎃"
SubBrand.TextColor3 = Color3.fromRGB(249, 115, 22)
SubBrand.TextSize = 9
SubBrand.TextXAlignment = Enum.TextXAlignment.Left

local TabListFrame = Instance.new("Frame")
TabListFrame.Parent = Sidebar
TabListFrame.BackgroundTransparency = 1
TabListFrame.Position = UDim2.new(0, 0, 0, 85)
TabListFrame.Size = UDim2.new(1, 0, 1, -95)

local UIListSidebar = Instance.new("UIListLayout")
UIListSidebar.Parent = TabListFrame
UIListSidebar.Padding = UDim.new(0, 3)

-- Область контента справа
local ContentArea = Instance.new("Frame")
ContentArea.Parent = MainFrame
ContentArea.BackgroundTransparency = 1
ContentArea.Position = UDim2.new(0, 180, 0, 0)
ContentArea.Size = UDim2.new(1, -180, 1, 0)

local PageTitle = Instance.new("TextLabel")
PageTitle.Parent = ContentArea
PageTitle.BackgroundTransparency = 1
PageTitle.Position = UDim2.new(0, 20, 0, 15)
PageTitle.Size = UDim2.new(1, -40, 0, 25)
PageTitle.Font = Enum.Font.GothamBold
PageTitle.Text = "Main"
PageTitle.TextColor3 = Color3.fromRGB(240, 240, 240)
PageTitle.TextSize = 14
PageTitle.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = ContentArea
CloseBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
CloseBtn.Position = UDim2.new(1, -35, 0, 15)
CloseBtn.Size = UDim2.new(0, 24, 0, 24)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
CloseBtn.TextSize = 10
local UICornerClose = Instance.new("UICorner") UICornerClose.CornerRadius = UDim.new(0,4) UICornerClose.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Страницы
local Pages = {}
local function CreatePage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name
    page.Parent = ContentArea
    page.BackgroundTransparency = 1
    page.Position = UDim2.new(0, 0, 0, 50)
    page.Size = UDim2.new(1, 0, 1, -50)
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = Color3.fromRGB(249, 115, 22)
    page.Visible = false
    Pages[name] = page
    return page
end

local function SwitchPage(name, titleText)
    for pName, pObj in pairs(Pages) do
        pObj.Visible = (pName == name)
    end
    PageTitle.Text = titleText
end

local pageMain = CreatePage("Main")
local pageRaids = CreatePage("Raids")
local pageStats = CreatePage("Stats")
local pageWebhook = CreatePage("Webhook")
local pageVisual = CreatePage("Visual")
local pageTeleport = CreatePage("Teleport")
local pageSettings = CreatePage("Settings")

local function CreateSidebarBtn(name, targetPage)
    local btn = Instance.new("TextButton")
    btn.Parent = TabListFrame
    btn.BackgroundTransparency = 1
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = "    " .. name
    btn.TextColor3 = Color3.fromRGB(140, 140, 140)
    btn.TextSize = 12
    btn.TextXAlignment = Enum.TextXAlignment.Left

    btn.MouseButton1Click:Connect(function()
        SwitchPage(targetPage, name)
    end)
end

CreateSidebarBtn("Main", "Main")
CreateSidebarBtn("Raids", "Raids")
CreateSidebarBtn("Stats", "Stats")
CreateSidebarBtn("Webhook", "Webhook")
CreateSidebarBtn("Visual", "Visual")
CreateSidebarBtn("Teleport", "Teleport")
CreateSidebarBtn("Settings", "Settings")

SwitchPage("Main", "Main")

-- Создание широких колонок Farm и Misc (как на оригинальном скрине LunarZ)
local function CreateColumn(parent, title, posX)
    local col = Instance.new("Frame")
    col.Parent = parent
    col.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    col.BorderColor3 = Color3.fromRGB(28, 28, 28)
    col.Position = UDim2.new(0, posX, 0, 0)
    col.Size = UDim2.new(0.5, -20, 0, 370)
    local corner = Instance.new("UICorner") corner.CornerRadius = UDim.new(0, 6) corner.Parent = col

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Parent = col
    titleLbl.BackgroundTransparency = 1
    titleLbl.Position = UDim2.new(0, 15, 0, 12)
    titleLbl.Size = UDim2.new(1, -30, 0, 20)
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.Text = title
    titleLbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    titleLbl.TextSize = 12
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left

    local container = Instance.new("ScrollingFrame")
    container.Parent = col
    container.BackgroundTransparency = 1
    container.Position = UDim2.new(0, 12, 0, 38)
    container.Size = UDim2.new(1, -24, 1, -45)
    container.CanvasSize = UDim2.new(0,0,0,0)
    container.AutomaticCanvasSize = Enum.AutomaticSize.Y
    container.ScrollBarThickness = 2
    container.ScrollBarImageColor3 = Color3.fromRGB(249, 115, 22)

    local list = Instance.new("UIListLayout") list.Parent = container list.Padding = UDim.new(0, 6)
    return container
end

local farmCol = CreateColumn(pageMain, "Farm", 15)
local miscCol = CreateColumn(pageMain, "Misc", 260)

-- Переменные
local autoFarmEnabled = false
local godModeEnabled = false
local speedBoostEnabled = false
local failSafeEnabled = false
local noclipEnabled = false

local function AddToggle(col, text, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = col
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = "  " .. text
    btn.TextColor3 = Color3.fromRGB(140, 140, 140)
    btn.TextSize = 11
    btn.TextXAlignment = Enum.TextXAlignment.Left

    local corner = Instance.new("UICorner") corner.CornerRadius = UDim.new(0, 4) corner.Parent = btn
    
    local ind = Instance.new("Frame")
    ind.Parent = btn
    ind.Position = UDim2.new(1, -24, 0.5, -5)
    ind.Size = UDim2.new(0, 10, 0, 10)
    ind.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    local indCorner = Instance.new("UICorner") indCorner.CornerRadius = Instance.new("UICorner").CornerRadius or UDim.new(1,0) indCorner.Parent = ind

    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        if active then
            btn.TextColor3 = Color3.fromRGB(240, 240, 240)
            ind.BackgroundColor3 = Color3.fromRGB(249, 115, 22)
        else
            btn.TextColor3 = Color3.fromRGB(140, 140, 140)
            ind.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        end
        callback(active)
    end)
end

AddToggle(farmCol, "Auto Farm (Smart Hitbox Kill)", function(st) autoFarmEnabled = st end)

AddToggle(miscCol, "God-Mode (Бессмертие)", function(st) godModeEnabled = st end)
AddToggle(miscCol, "Speed & Jump Boost", function(st) speedBoostEnabled = st end)
AddToggle(miscCol, "Fail Safe (Страховка)", function(st) failSafeEnabled = st end)
AddToggle(miscCol, "NoClip (Сквозь стены)", function(st) noclipEnabled = st end)

-- Логика
RunService.Stepped:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")

        if godModeEnabled and hum then hum.Health = hum.MaxHealth end
        if speedBoostEnabled and hum then hum.WalkSpeed = 48 hum.JumpPower = 135 end
        
        if noclipEnabled then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end

        if failSafeEnabled and hum and root and hum.Health > 0 and hum.Health < 30 then
            root.CFrame = root.CFrame + Vector3.new(0, 300, 0)
            task.wait(0.5)
        end
    end)
end)

-- НОВЫЙ СПОСОБ УБИЙСТВА ТИТАНОВ (ПРЯМОЙ ОБХОД ЧЕРЕЗ ХИТБОКСЫ И REMOTE EVENTS)
task.spawn(function()
    while true do
        task.wait(0.03)
        if autoFarmEnabled then
            pcall(function()
                local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    for _, v in pairs(workspace:GetDescendants()) do
                        -- Ищем любые слабые места, затылки или хитбоксы боссов обновлений
                        if v.Name == "Nape" or v.Name == "UpperNeck" or v.Name == "WeakSpot" or v.Name == "PumpkinHead" or v.Name == "BeastHitbox" then
                            if v:IsA("BasePart") then
                                -- Плавное удержание позиционирования прямо внутри хитбокса
                                root.CFrame = v.CFrame * CFrame.new(0, 0, -0.5)
                                root.Velocity = Vector3.new(0, 0, 0)
                                
                                -- Эмулируем атаку клинком через игровые события
                                VirtualUser:Button1Down(Vector2.new(0,0))
                                task.wait(0.01)
                                VirtualUser:Button1Up(Vector2.new(0,0))
                                
                                -- Попытка найти и вызвать RemoteEvent урона напрямую, если он есть в модели титана
                                local titanModel = v.Parent
                                if titanModel then
                                    local remote = titanModel:FindFirstChildOfClass("RemoteEvent") or workspace:FindFirstChild("CombatEvent", true)
                                    if remote then
                                        remote:FireServer(v)
                                    end
                                end
                                break
                            end
                        end
                    end
                end
            end)
        end
    end
end)

CaximNotify("LunarZ", "Широкий интерфейс и новый бой активированы!", 3)
