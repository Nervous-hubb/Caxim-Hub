-- [[ CAXIM HUB // ULTIMATE NEPTUNE COMPINE // UPDATE 5 FULL PACK ]]
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local VirtualUser = game:GetService("VirtualUser")

if CoreGui:FindFirstChild("CaximUltimateCompine") then
    CoreGui.CaximUltimateCompine:Destroy()
end

local function CaximNotify(title, text, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title;
            Text = text;
            Duration = duration or 2.5;
        })
    end)
end

-- Главное окно в стиле Neptune Hub (Wide Layout)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CaximUltimateCompine"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(13, 17, 23)
MainFrame.BorderColor3 = Color3.fromRGB(33, 38, 45)
MainFrame.BorderSizePixel = 1
MainFrame.Position = UDim2.new(0.5, -360, 0.5, -235)
MainFrame.Size = UDim2.new(0, 720, 0, 470)
MainFrame.Active = true
MainFrame.Draggable = true

local UICornerMain = Instance.new("UICorner")
UICornerMain.CornerRadius = UDim.new(0, 8)
UICornerMain.Parent = MainFrame

-- Верхняя панель
local TopBar = Instance.new("Frame")
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(9, 11, 15)
TopBar.Size = UDim2.new(1, 0, 0, 32)
local UICornerTop = Instance.new("UICorner") UICornerTop.CornerRadius = UDim.new(0, 8) UICornerTop.Parent = TopBar
local TopFix = Instance.new("Frame") TopFix.Parent = TopBar TopFix.BackgroundColor3 = Color3.fromRGB(9, 11, 15) TopFix.BorderSizePixel = 0 TopFix.Position = UDim2.new(0,0,0.5,0) TopFix.Size = UDim2.new(1,0,0.5,0)

local BrandTitle = Instance.new("TextLabel")
BrandTitle.Parent = TopBar
BrandTitle.BackgroundTransparency = 1
BrandTitle.Position = UDim2.new(0, 15, 0, 0)
BrandTitle.Size = UDim2.new(0, 300, 1, 0)
BrandTitle.Font = Enum.Font.GothamBold
BrandTitle.Text = "⚡ Caxim Hub // Ultimate Compine [Update 5]"
BrandTitle.TextColor3 = Color3.fromRGB(56, 189, 248)
BrandTitle.TextSize = 11
BrandTitle.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TopBar
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 38, 38)
CloseBtn.Position = UDim2.new(1, -26, 0, 6)
CloseBtn.Size = UDim2.new(0, 20, 0, 20)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 10
local UICornerClose = Instance.new("UICorner") UICornerClose.CornerRadius = UDim.new(0,4) UICornerClose.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Левый сайдбар
local Sidebar = Instance.new("Frame")
Sidebar.Parent = MainFrame
Sidebar.BackgroundColor3 = Color3.fromRGB(10, 13, 18)
Sidebar.Position = UDim2.new(0, 0, 0, 32)
Sidebar.Size = UDim2.new(0, 140, 1, -32)

local UIListSidebar = Instance.new("UIListLayout")
UIListSidebar.Parent = Sidebar
UIListSidebar.Padding = UDim.new(0, 4)

-- Область контента
local ContentArea = Instance.new("Frame")
ContentArea.Parent = MainFrame
ContentArea.BackgroundTransparency = 1
ContentArea.Position = UDim2.new(0, 145, 0, 32)
ContentArea.Size = UDim2.new(1, -145, 1, -32)

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
    page.ScrollBarImageColor3 = Color3.fromRGB(56, 189, 248)
    page.Visible = false
    Pages[name] = page
    return page
end

local function SwitchPage(name)
    for pName, pObj in pairs(Pages) do
        pObj.Visible = (pName == name)
    end
end

local pageHome = CreatePage("Home")
local pageMain = CreatePage("Main")
local pageMisc = CreatePage("Misc")
local pageVisuals = CreatePage("Visuals")
local pageSettings = CreatePage("Settings")

local function CreateSidebarBtn(name, targetPage)
    local btn = Instance.new("TextButton")
    btn.Parent = Sidebar
    btn.BackgroundTransparency = 1
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = "    " .. name
    btn.TextColor3 = Color3.fromRGB(140, 145, 155)
    btn.TextSize = 12
    btn.TextXAlignment = Enum.TextXAlignment.Left

    btn.MouseButton1Click:Connect(function()
        SwitchPage(targetPage)
    end)
end

CreateSidebarBtn("🏠 Home", "Home")
CreateSidebarBtn("⚙️ Main", "Main")
CreateSidebarBtn("⚡ Misc", "Misc")
CreateSidebarBtn("👁️ Visuals", "Visuals")
CreateSidebarBtn("🔧 Settings", "Settings")

SwitchPage("Main")

-- Вкладка Home
local HomeFrame = Instance.new("Frame")
HomeFrame.Parent = pageHome
HomeFrame.BackgroundColor3 = Color3.fromRGB(18, 22, 30)
HomeFrame.Position = UDim2.new(0, 15, 0, 15)
HomeFrame.Size = UDim2.new(1, -30, 0, 130)
local UICornerHome = Instance.new("UICorner") UICornerHome.CornerRadius = UDim.new(0, 6) UICornerHome.Parent = HomeFrame

local WelcomeLbl = Instance.new("TextLabel")
WelcomeLbl.Parent = HomeFrame
WelcomeLbl.BackgroundTransparency = 1
WelcomeLbl.Position = UDim2.new(0, 20, 0, 20)
WelcomeLbl.Size = UDim2.new(1, -40, 0, 25)
WelcomeLbl.Font = Enum.Font.GothamBold
WelcomeLbl.Text = "Operator: " .. LocalPlayer.Name
WelcomeLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
WelcomeLbl.TextSize = 14
WelcomeLbl.TextXAlignment = Enum.TextXAlignment.Left

local StatusLbl = Instance.new("TextLabel")
StatusLbl.Parent = HomeFrame
StatusLbl.BackgroundTransparency = 1
StatusLbl.Position = UDim2.new(0, 20, 0, 50)
StatusLbl.Size = UDim2.new(1, -40, 0, 20)
StatusLbl.Font = Enum.Font.Gotham
StatusLbl.Text = "Status: Elite Compine Loaded [Update 5 🎃]"
StatusLbl.TextColor3 = Color3.fromRGB(56, 189, 248)
StatusLbl.TextSize = 11
StatusLbl.TextXAlignment = Enum.TextXAlignment.Left

-- Колонки для Main
local function CreateColumn(parent, title, posX)
    local col = Instance.new("Frame")
    col.Parent = parent
    col.BackgroundColor3 = Color3.fromRGB(16, 20, 27)
    col.BorderColor3 = Color3.fromRGB(28, 34, 45)
    col.Position = UDim2.new(0, posX, 0, 15)
    col.Size = UDim2.new(0.5, -20, 0, 400)
    local corner = Instance.new("UICorner") corner.CornerRadius = UDim.new(0, 6) corner.Parent = col

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Parent = col
    titleLbl.BackgroundTransparency = 1
    titleLbl.Position = UDim2.new(0, 15, 0, 12)
    titleLbl.Size = UDim2.new(1, -30, 0, 20)
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.Text = title
    titleLbl.TextColor3 = Color3.fromRGB(210, 215, 225)
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
    container.ScrollBarImageColor3 = Color3.fromRGB(56, 189, 248)

    local list = Instance.new("UIListLayout") list.Parent = container list.Padding = UDim.new(0, 6)
    return container
end

local farmCol = CreateColumn(pageMain, "Auto Farm & Missions", 15)
local extrasCol = CreateColumn(pageMain, "Player & Combat Boosts", 285)

-- Состояния (все выключены при старте)
local autoFarmEnabled = false
local autoMissionEnabled = false
local godModeEnabled = false
local speedBoostEnabled = false
local failSafeEnabled = false
local noclipEnabled = false
local farmSpeed = 0.015 -- Настраиваемая задержка

local function AddToggle(col, text, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = col
    btn.BackgroundColor3 = Color3.fromRGB(22, 27, 36)
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = "  " .. text
    btn.TextColor3 = Color3.fromRGB(150, 155, 165)
    btn.TextSize = 11
    btn.TextXAlignment = Enum.TextXAlignment.Left

    local corner = Instance.new("UICorner") corner.CornerRadius = UDim.new(0, 4) corner.Parent = btn
    
    local ind = Instance.new("Frame")
    ind.Parent = btn
    ind.Position = UDim2.new(1, -24, 0.5, -5)
    ind.Size = UDim2.new(0, 10, 0, 10)
    ind.BackgroundColor3 = Color3.fromRGB(70, 75, 85)
    local indCorner = Instance.new("UICorner") indCorner.CornerRadius = UDim.new(1,0) indCorner.Parent = ind

    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        if active then
            btn.TextColor3 = Color3.fromRGB(240, 245, 250)
            ind.BackgroundColor3 = Color3.fromRGB(56, 189, 248)
        else
            btn.TextColor3 = Color3.fromRGB(150, 155, 165)
            ind.BackgroundColor3 = Color3.fromRGB(70, 75, 85)
        end
        callback(active)
    end)
end

-- Функция добавления интерактивного ползунка (Slider)
local function AddSlider(col, text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Parent = col
    frame.BackgroundColor3 = Color3.fromRGB(22, 27, 36)
    frame.Size = UDim2.new(1, 0, 0, 50)
    local corner = Instance.new("UICorner") corner.CornerRadius = UDim.new(0, 4) corner.Parent = frame

    local lbl = Instance.new("TextLabel")
    lbl.Parent = frame
    lbl.BackgroundTransparency = 1
    lbl.Position = UDim2.new(0, 10, 0, 6)
    lbl.Size = UDim2.new(1, -20, 0, 20)
    lbl.Font = Enum.Font.GothamSemibold
    lbl.Text = text .. ": " .. default
    lbl.TextColor3 = Color3.fromRGB(180, 185, 195)
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local sliderBg = Instance.new("Frame")
    sliderBg.Parent = frame
    sliderBg.BackgroundColor3 = Color3.fromRGB(12, 15, 20)
    sliderBg.Position = UDim2.new(0, 10, 0, 32)
    sliderBg.Size = UDim2.new(1, -20, 0, 6)
    local sc = Instance.new("UICorner") sc.CornerRadius = UDim.new(1,0) sc.Parent = sliderBg

    local sliderFill = Instance.new("Frame")
    sliderFill.Parent = sliderBg
    sliderFill.BackgroundColor3 = Color3.fromRGB(56, 189, 248)
    sliderFill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
    local sfc = Instance.new("UICorner") sfc.CornerRadius = UDim.new(1,0) sfc.Parent = sliderFill

    local btn = Instance.new("TextButton")
    btn.Parent = sliderBg
    btn.BackgroundTransparency = 1
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.Text = ""

    local dragging = false
    btn.MouseButton1Down:Connect(function() dragging = true end)
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = game:GetService("UserInputService"):GetMouseLocation().X
            local absPos = sliderBg.AbsolutePosition.X
            local absSize = sliderBg.AbsoluteSize.X
            local pos = math.clamp((mousePos - absPos) / absSize, 0, 1)
            sliderFill.Size = UDim2.new(pos, 0, 1, 0)
            local val = math.floor(min + (max - min) * pos)
            lbl.Text = text .. ": " .. val
            callback(val)
        end
    end)
end

-- Наполнение вкладок компайна
AddToggle(farmCol, "Ultimate Auto-Farm (Instant Kill)", function(st) autoFarmEnabled = st end)
AddToggle(farmCol, "Auto Start & Retry Mission", function(st) autoMissionEnabled = st end)

AddSlider(farmCol, "Farm Speed / Delay (ms)", 5, 50, 15, function(val)
    farmSpeed = val / 1000
end)

AddToggle(extrasCol, "God-Mode (Бессмертие)", function(st) godModeEnabled = st end)
AddToggle(extrasCol, "Speed & Jump Boost", function(st) speedBoostEnabled = st end)
AddToggle(extrasCol, "Fail Safe (Страховка от смерти)", function(st) failSafeEnabled = st end)
AddToggle(extrasCol, "NoClip (Сквозь стены)", function(st) noclipEnabled = st end)

local function AddPlaceholder(page, text)
    local lbl = Instance.new("TextLabel")
    lbl.Parent = page
    lbl.BackgroundTransparency = 1
    lbl.Position = UDim2.new(0, 20, 0, 20)
    lbl.Size = UDim2.new(1, -40, 0, 30)
    lbl.Font = Enum.Font.GothamBold
    lbl.Text = text .. " Module Active"
    lbl.TextColor3 = Color3.fromRGB(160, 165, 175)
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
end

AddPlaceholder(pageMisc, "Misc & Teleports")
AddPlaceholder(pageVisuals, "ESP & Visuals")
AddPlaceholder(pageSettings, "Hub Configuration")

-- Логика игрока и бессмертия
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

-- РАСШИРЕННЫЙ АВТОФАРМ КОМБАЙНА С КАСТОМНЫМ ПОЛЗУНКОМ СКОРОСТИ
task.spawn(function()
    while true do
        task.wait(farmSpeed)
        if autoFarmEnabled then
            pcall(function()
                local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    for _, v in pairs(workspace:GetDescendants()) do
                        if v.Name == "Nape" or v.Name == "UpperNeck" or v.Name == "WeakSpot" or v.Name == "PumpkinHead" or v.Name == "BeastHitbox" then
                            if v:IsA("BasePart") then
                                root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                                root.CFrame = v.CFrame * CFrame.new(0, 0, -0.8)
                                
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

CaximNotify("CAXIM HUB", "Ultimate Compine успешно загружен!", 3)
