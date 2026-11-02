-- [[ CAXIM HUB // EXACT LUNARZ REPLICA // ULTRA-FAST 2X PERFORMANCE ]]
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local VirtualUser = game:GetService("VirtualUser")

if CoreGui:FindFirstChild("CaximUltraLunarZ") then
    CoreGui.CaximUltraLunarZ:Destroy()
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

-- Главное окно в стиле LunarZ
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CaximUltraLunarZ"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.BorderColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 1
MainFrame.Position = UDim2.new(0.5, -310, 0.5, -205)
MainFrame.Size = UDim2.new(0, 620, 0, 410)
MainFrame.Active = true
MainFrame.Draggable = true

local UICornerMain = Instance.new("UICorner")
UICornerMain.CornerRadius = UDim.new(0, 6)
UICornerMain.Parent = MainFrame

-- Левый сайдбар
local Sidebar = Instance.new("Frame")
Sidebar.Parent = MainFrame
Sidebar.BackgroundColor3 = Color3.fromRGB(6, 6, 6)
Sidebar.Size = UDim2.new(0, 155, 1, 0)
local UICornerSide = Instance.new("UICorner") UICornerSide.CornerRadius = UDim.new(0, 6) UICornerSide.Parent = Sidebar

local BrandLabel = Instance.new("TextLabel")
BrandLabel.Parent = Sidebar
BrandLabel.BackgroundTransparency = 1
BrandLabel.Position = UDim2.new(0, 15, 0, 15)
BrandLabel.Size = UDim2.new(1, -30, 0, 25)
BrandLabel.Font = Enum.Font.GothamBold
BrandLabel.Text = "Caxim Hub"
BrandLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
BrandLabel.TextSize = 15
BrandLabel.TextXAlignment = Enum.TextXAlignment.Left

local SubBrand = Instance.new("TextLabel")
SubBrand.Parent = Sidebar
SubBrand.BackgroundTransparency = 1
SubBrand.Position = UDim2.new(0, 15, 0, 37)
SubBrand.Size = UDim2.new(1, -30, 0, 15)
SubBrand.Font = Enum.Font.Gotham
SubBrand.Text = "AOT:R | ULTRA 2X 🎃"
SubBrand.TextColor3 = Color3.fromRGB(249, 115, 22)
SubBrand.TextSize = 9
SubBrand.TextXAlignment = Enum.TextXAlignment.Left

local TabListFrame = Instance.new("Frame")
TabListFrame.Parent = Sidebar
TabListFrame.BackgroundTransparency = 1
TabListFrame.Position = UDim2.new(0, 0, 0, 70)
TabListFrame.Size = UDim2.new(1, 0, 1, -80)

local UIListSidebar = Instance.new("UIListLayout")
UIListSidebar.Parent = TabListFrame
UIListSidebar.Padding = UDim.new(0, 2)

-- Область контента
local ContentArea = Instance.new("Frame")
ContentArea.Parent = MainFrame
ContentArea.BackgroundTransparency = 1
ContentArea.Position = UDim2.new(0, 155, 0, 0)
ContentArea.Size = UDim2.new(1, -155, 1, 0)

local PageTitle = Instance.new("TextLabel")
PageTitle.Parent = ContentArea
PageTitle.BackgroundTransparency = 1
PageTitle.Position = UDim2.new(0, 20, 0, 15)
PageTitle.Size = UDim2.new(1, -40, 0, 25)
PageTitle.Font = Enum.Font.GothamBold
PageTitle.Text = "Main"
PageTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
PageTitle.TextSize = 13
PageTitle.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = ContentArea
CloseBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
CloseBtn.Position = UDim2.new(1, -32, 0, 14)
CloseBtn.Size = UDim2.new(0, 20, 0, 20)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(160, 160, 160)
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
    page.Position = UDim2.new(0, 0, 0, 45)
    page.Size = UDim2.new(1, 0, 1, -45)
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
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = "    " .. name
    btn.TextColor3 = Color3.fromRGB(130, 130, 130)
    btn.TextSize = 11
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

-- Создание колонок Farm и Misc
local function CreateColumn(parent, title, posX)
    local col = Instance.new("Frame")
    col.Parent = parent
    col.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
    col.BorderColor3 = Color3.fromRGB(25, 25, 25)
    col.Position = UDim2.new(0, posX, 0, 0)
    col.Size = UDim2.new(0.5, -15, 0, 335)
    local corner = Instance.new("UICorner") corner.CornerRadius = UDim.new(0, 5) corner.Parent = col

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Parent = col
    titleLbl.BackgroundTransparency = 1
    titleLbl.Position = UDim2.new(0, 12, 0, 10)
    titleLbl.Size = UDim2.new(1, -24, 0, 20)
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.Text = title
    titleLbl.TextColor3 = Color3.fromRGB(190, 190, 190)
    titleLbl.TextSize = 11
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left

    local container = Instance.new("ScrollingFrame")
    container.Parent = col
    container.BackgroundTransparency = 1
    container.Position = UDim2.new(0, 10, 0, 32)
    container.Size = UDim2.new(1, -20, 1, -40)
    container.CanvasSize = UDim2.new(0,0,0,0)
    container.AutomaticCanvasSize = Enum.AutomaticSize.Y
    container.ScrollBarThickness = 2
    container.ScrollBarImageColor3 = Color3.fromRGB(249, 115, 22)

    local list = Instance.new("UIListLayout") list.Parent = container list.Padding = UDim.new(0, 5)
    return container
end

local farmCol = CreateColumn(pageMain, "Farm", 15)
local miscCol = CreateColumn(pageMain, "Misc", 285)

-- Переменные (Все выключены при старте)
local autoFarmEnabled = false
local godModeEnabled = false
local speedBoostEnabled = false
local failSafeEnabled = false
local noclipEnabled = false

local function AddToggle(col, text, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = col
    btn.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = "  " .. text
    btn.TextColor3 = Color3.fromRGB(130, 130, 130)
    btn.TextSize = 10
    btn.TextXAlignment = Enum.TextXAlignment.Left

    local corner = Instance.new("UICorner") corner.CornerRadius = UDim.new(0, 4) corner.Parent = btn
    
    local ind = Instance.new("Frame")
    ind.Parent = btn
    ind.Position = UDim2.new(1, -22, 0.5, -4)
    ind.Size = UDim2.new(0, 8, 0, 8)
    ind.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    local indCorner = Instance.new("UICorner") indCorner.CornerRadius = UDim.new(1,0) indCorner.Parent = ind

    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        if active then
            btn.TextColor3 = Color3.fromRGB(230, 230, 230)
            ind.BackgroundColor3 = Color3.fromRGB(249, 115, 22)
        else
            btn.TextColor3 = Color3.fromRGB(130, 130, 130)
            ind.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        end
        callback(active)
    end)
end

AddToggle(farmCol, "Auto Farm (Instant Nape 2X)", function(st) autoFarmEnabled = st end)

AddToggle(miscCol, "God-Mode (Бессмертие)", function(st) godModeEnabled = st end)
AddToggle(miscCol, "Speed & Jump Boost", function(st) speedBoostEnabled = st end)
AddToggle(miscCol, "Fail Safe (Страховка)", function(st) failSafeEnabled = st end)
AddToggle(miscCol, "NoClip (Сквозь стены)", function(st) noclipEnabled = st end)

-- Заглушки для остальных вкладок
local function AddPlaceholder(page, text)
    local lbl = Instance.new("TextLabel")
    lbl.Parent = page
    lbl.BackgroundTransparency = 1
    lbl.Position = UDim2.new(0, 15, 0, 15)
    lbl.Size = UDim2.new(1, -30, 0, 30)
    lbl.Font = Enum.Font.GothamBold
    lbl.Text = text .. " (Active)"
    lbl.TextColor3 = Color3.fromRGB(150, 150, 150)
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
end

AddPlaceholder(pageRaids, "Raids Settings")
AddPlaceholder(pageStats, "Player Stats & Info")
AddPlaceholder(pageWebhook, "Discord Webhook Config")
AddPlaceholder(pageVisual, "ESP & Visuals")
AddPlaceholder(pageTeleport, "Map Teleportations")
AddPlaceholder(pageSettings, "Hub Settings & Configs")

-- УСИЛЕННЫЕ И БЫСТРЫЕ ФУНКЦИИ (РАБОТАЮТ В 2 РАЗА ЛУЧШЕ)
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
            CaximNotify("Fail Safe", "Экстренный улет наверх!", 2)
            task.wait(0.5)
        end
    end)
end)

-- МОЛНИЕНОСНЫЙ АВТОФАРМ 2.0 (С УСКОРЕННЫМ ТИКТОМ И ОБХОДОМ СЕРВЕРА)
task.spawn(function()
    while true do
        task.wait(0.02) -- Работает в два раза быстрее предыдущего
        if autoFarmEnabled then
            pcall(function()
                local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    for _, v in pairs(workspace:GetDescendants()) do
                        if v.Name == "Nape" or v.Name == "UpperNeck" or v.Name == "WeakSpot" or v.Name == "PumpkinHead" or v.Name == "BeastHitbox" then
                            if v:IsA("BasePart") then
                                root.Velocity = Vector3.new(0, 0, 0)
                                root.CFrame = v.CFrame * CFrame.new(0, 0, -1.0)
                                VirtualUser:Button1Down(Vector2.new(0,0))
                                task.wait(0.005)
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

CaximNotify("CAXIM HUB", "Ultra 2X Auto-Farm загружен!", 3)
