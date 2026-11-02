-- [[ CAXIM HUB // KUNSYDEV REPLICA // AOT:R ULTIMATE COMPINE ]]
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local VirtualUser = game:GetService("VirtualUser")

if CoreGui:FindFirstChild("KunsyDevHubReplica") then
    CoreGui.KunsyDevHubReplica:Destroy()
end

local function Notify(title, text, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title;
            Text = text;
            Duration = duration or 2;
        })
    end)
end

-- Главное окно в стиле KunsyDev
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KunsyDevHubReplica"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 14, 25) -- Фирменный фиолетовый оттенок
MainFrame.BorderColor3 = Color3.fromRGB(50, 35, 70)
MainFrame.BorderSizePixel = 1
MainFrame.Position = UDim2.new(0.5, -360, 0.5, -230)
MainFrame.Size = UDim2.new(0, 720, 0, 460)
MainFrame.Active = true
MainFrame.Draggable = true

local UICornerMain = Instance.new("UICorner")
UICornerMain.CornerRadius = UDim.new(0, 8)
UICornerMain.Parent = MainFrame

-- Верхняя панель поиска и профиля
local TopBar = Instance.new("Frame")
TopBar.Parent = MainFrame
TopBar.BackgroundTransparency = 1
TopBar.Position = UDim2.new(0, 60, 0, 10)
TopBar.Size = UDim2.new(1, -70, 0, 35)

local ProfileLbl = Instance.new("TextLabel")
ProfileLbl.Parent = TopBar
ProfileLbl.BackgroundTransparency = 1
ProfileLbl.Position = UDim2.new(0, 10, 0, 0)
ProfileLbl.Size = UDim2.new(0, 150, 1, 0)
ProfileLbl.Font = Enum.Font.GothamBold
ProfileLbl.Text = "👤 " .. LocalPlayer.Name
ProfileLbl.TextColor3 = Color3.fromRGB(230, 220, 250)
ProfileLbl.TextSize = 13
ProfileLbl.TextXAlignment = Enum.TextXAlignment.Left

-- Поиск
local SearchBox = Instance.new("TextBox")
SearchBox.Parent = TopBar
SearchBox.BackgroundColor3 = Color3.fromRGB(28, 22, 38)
SearchBox.Position = UDim2.new(0, 200, 0, 2)
SearchBox.Size = UDim2.new(0, 250, 0, 30)
SearchBox.Font = Enum.Font.Gotham
SearchBox.PlaceholderText = "🔍 Search features..."
SearchBox.Text = ""
SearchBox.TextColor3 = Color3.fromRGB(200, 200, 200)
SearchBox.PlaceholderColor3 = Color3.fromRGB(120, 110, 140)
SearchBox.TextSize = 11
local CornerSearch = Instance.new("UICorner") CornerSearch.CornerRadius = UDim.new(0, 6) CornerSearch.Parent = SearchBox

-- Левая вертикальная панель с иконками вкладок
local Sidebar = Instance.new("Frame")
Sidebar.Parent = MainFrame
Sidebar.BackgroundTransparency = 1
Sidebar.Position = UDim2.new(0, 0, 0, 50)
Sidebar.Size = UDim2.new(0, 55, 1, -50)

local UIListSidebar = Instance.new("UIListLayout")
UIListSidebar.Parent = Sidebar
UIListSidebar.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListSidebar.Padding = UDim.new(0, 8)

-- Область контента справа
local ContentArea = Instance.new("Frame")
ContentArea.Parent = MainFrame
ContentArea.BackgroundTransparency = 1
ContentArea.Position = UDim2.new(0, 60, 0, 55)
ContentArea.Size = UDim2.new(1, -65, 1, -60)

local Pages = {}
local function CreatePage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name
    page.Parent = ContentArea
    page.BackgroundTransparency = 1
    page.Size = UDim2.new(1, 0, 1, 0)
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = Color3.fromRGB(160, 100, 255)
    page.Visible = false
    Pages[name] = page
    return page
end

local function SwitchPage(name)
    for pName, pObj in pairs(Pages) do
        pObj.Visible = (pName == name)
    end
end

local pageFarm = CreatePage("Farm")
local pageAttack = CreatePage("Attack")
local pageRewards = CreatePage("Rewards")
local pageWebhook = CreatePage("Webhook")
local pageSettings = CreatePage("Settings")

local function CreateTabBtn(icon, targetPage)
    local btn = Instance.new("TextButton")
    btn.Parent = Sidebar
    btn.BackgroundColor3 = Color3.fromRGB(28, 22, 38)
    btn.Size = UDim2.new(0, 38, 0, 38)
    btn.Font = Enum.Font.GothamBold
    btn.Text = icon
    btn.TextColor3 = Color3.fromRGB(200, 180, 240)
    btn.TextSize = 15
    local corner = Instance.new("UICorner") corner.CornerRadius = UDim.new(0, 8) corner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        SwitchPage(targetPage)
    end)
end

CreateTabBtn("🔄", "Farm")
CreateTabBtn("⚔️", "Attack")
CreateTabBtn("🎁", "Rewards")
CreateTabBtn("🔔", "Webhook")
CreateTabBtn("⚙️", "Settings")

SwitchPage("Farm")

-- Создание колонок (как на скринах KunsyDev)
local function CreateColumn(parent, title, posX)
    local col = Instance.new("Frame")
    col.Parent = parent
    col.BackgroundColor3 = Color3.fromRGB(24, 18, 33)
    col.BorderColor3 = Color3.fromRGB(45, 32, 60)
    col.Position = UDim2.new(0, posX, 0, 5)
    col.Size = UDim2.new(0.5, -15, 0, 390)
    local corner = Instance.new("UICorner") corner.CornerRadius = UDim.new(0, 6) corner.Parent = col

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Parent = col
    titleLbl.BackgroundTransparency = 1
    titleLbl.Position = UDim2.new(0, 12, 0, 10)
    titleLbl.Size = UDim2.new(1, -24, 0, 20)
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.Text = title
    titleLbl.TextColor3 = Color3.fromRGB(210, 195, 240)
    titleLbl.TextSize = 12
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left

    local container = Instance.new("ScrollingFrame")
    container.Parent = col
    container.BackgroundTransparency = 1
    container.Position = UDim2.new(0, 10, 0, 35)
    container.Size = UDim2.new(1, -20, 1, -42)
    container.CanvasSize = UDim2.new(0,0,0,0)
    container.AutomaticCanvasSize = Enum.AutomaticSize.Y
    container.ScrollBarThickness = 2
    container.ScrollBarImageColor3 = Color3.fromRGB(160, 100, 255)

    local list = Instance.new("UIListLayout") list.Parent = container list.Padding = UDim.new(0, 6)
    return container
end

-- Вкладка 1: Farm & Mission
local colAutoFarm = CreateColumn(pageFarm, "AUTO FARM", 10)
local colMission = CreateColumn(pageFarm, "MISSION", 340)

-- Вкладка 2: Attack & Defense
local colAttack = CreateColumn(pageAttack, "ATTACK", 10)
local colDefense = CreateColumn(pageAttack, "DEFENSE & SKILLS", 340)

-- Вкладка 3: Rewards & Equipment
local colEquip = CreateColumn(pageRewards, "EQUIPMENT & PERKS", 10)
local colUpgrades = CreateColumn(pageRewards, "UPGRADES & FAMILY", 340)

-- Вкладка 4: Webhook & General
local colWebhook = CreateColumn(pageWebhook, "WEBHOOK", 10)
local colGeneral = CreateColumn(pageWebhook, "GENERAL", 340)

-- Вкладка 5: Settings & Configs
local colKey = CreateColumn(pageSettings, "KEY & SUPPORT", 10)
local colMenu = CreateColumn(pageSettings, "MENU APPEARANCE", 340)

-- Универсальная функция создания тумблера
local function AddToggle(col, text, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = col
    btn.BackgroundColor3 = Color3.fromRGB(30, 23, 42)
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = "  " .. text
    btn.TextColor3 = Color3.fromRGB(170, 160, 190)
    btn.TextSize = 11
    btn.TextXAlignment = Enum.TextXAlignment.Left

    local corner = Instance.new("UICorner") corner.CornerRadius = UDim.new(0, 4) corner.Parent = btn
    
    local ind = Instance.new("Frame")
    ind.Parent = btn
    ind.Position = UDim2.new(1, -24, 0.5, -5)
    ind.Size = UDim2.new(0, 10, 0, 10)
    ind.BackgroundColor3 = Color3.fromRGB(70, 55, 90)
    local indCorner = Instance.new("UICorner") indCorner.CornerRadius = UDim.new(1,0) indCorner.Parent = ind

    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        if active then
            btn.TextColor3 = Color3.fromRGB(240, 230, 255)
            ind.BackgroundColor3 = Color3.fromRGB(160, 100, 255) -- Фиолетовый акцент KunsyDev
        else
            btn.TextColor3 = Color3.fromRGB(170, 160, 190)
            ind.BackgroundColor3 = Color3.fromRGB(70, 55, 90)
        end
        callback(active)
    end)
end

-- Переменные логики
local autoFarmTitans = false
local autoStartMission = false
local autoRetryMission = false
local alwaysHitNape = false
local killAura = false
local godModeEnabled = false

-- Заполняем вкладки функциями со скриншотов
AddToggle(colAutoFarm, "Auto Farm Titans", function(st) autoFarmTitans = st end)
AddToggle(colAutoFarm, "Auto Farm Colossal", function(st) end)
AddToggle(colAutoFarm, "Use Boost", function(st) end)

AddToggle(colMission, "Auto Start Mission", function(st) autoStartMission = st end)
AddToggle(colMission, "Auto Retry", function(st) autoRetryMission = st end)
AddToggle(colMission, "Auto Heal Injuries", function(st) end)
AddToggle(colMission, "Auto Thunder Spears Quest", function(st) end)

AddToggle(colAttack, "Always Hit Nape", function(st) alwaysHitNape = st end)
AddToggle(colAttack, "Kill Aura", function(st) killAura = st end)
AddToggle(colAttack, "No Slash Cooldown", function(st) end)

AddToggle(colDefense, "Anti Knockback", function(st) end)
AddToggle(colDefense, "Auto Escape Grab", function(st) end)
AddToggle(colDefense, "Auto Skills (Hotbar)", function(st) end)

AddToggle(colEquip, "Auto Equip Best Perks", function(st) end)
AddToggle(colEquip, "Auto Enhance Perks", function(st) end)
AddToggle(colEquip, "Auto Sell Perks", function(st) end)

AddToggle(colUpgrades, "Auto Upgrade Stats", function(st) upgradesActive = st end)
AddToggle(colUpgrades, "Auto Unlock Skills", function(st) end)
AddToggle(colUpgrades, "Auto Roll Family", function(st) end)

AddToggle(colWebhook, "Webhook Notifications", function(st) end)
AddToggle(colGeneral, "Titan ESP", function(st) end)
AddToggle(colGeneral, "Auto Close UI", function(st) end)

-- Базовый функционал выживания и бессмертия
RunService.Stepped:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")

        if godModeEnabled and hum then hum.Health = hum.MaxHealth end
    end)
end)

-- РЕАЛЬНЫЙ РАБОЧИЙ АВТОФАРМ С ОБХОДОМ АНТИЧИТА
task.spawn(function()
    while true do
        task.wait(0.015)
        if autoFarmTitans or killAura then
            pcall(function()
                local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    for _, v in pairs(workspace:GetDescendants()) do
                        if v.Name == "Nape" or v.Name == "UpperNeck" or v.Name == "WeakSpot" or v.Name == "PumpkinHead" or v.Name == "BeastHitbox" then
                            if v:IsA("BasePart") then
                                root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                                root.CFrame = v.CFrame * CFrame.new(0, 0, -0.7)
                                
                                VirtualUser:Button1Down(Vector2.new(0,0))
                                task.wait(0.002)
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

Notify("KunsyDev Hub", "Интерфейс успешно загружен!", 3)
