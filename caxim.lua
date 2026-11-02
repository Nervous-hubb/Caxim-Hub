-- [[ CAXIM HUB // ULTIMATE AOT REVOLUTION GUI ]]
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- Удаляем старое меню, если оно было запущено
if CoreGui:FindFirstChild("CaximAotHub") then
    CoreGui.CaximAotHub:Destroy()
end

-- Создаем главный контейнер GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CaximAotHub"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Главное окно (OLED / Тёмный минимализм)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainFrame.BorderColor3 = Color3.fromRGB(220, 38, 38)
MainFrame.BorderSizePixel = 1
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.Active = true
MainFrame.Draggable = true -- Окно можно двигать мышкой по экрану

-- Шапка меню
local Header = Instance.new("Frame")
Header.Parent = MainFrame
Header.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Header.Size = UDim2.new(1, 0, 0, 35)

local Title = Instance.new("TextLabel")
Title.Parent = Header
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Size = UDim2.new(1, -15, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "CAXIM HUB // AOT REVOLUTION"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Кнопка закрытия
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = Header
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 38, 38)
CloseBtn.Position = UDim2.new(1, -30, 0, 5)
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 12
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Контейнер для кнопок функций
local Container = Instance.new("ScrollingFrame")
Container.Parent = MainFrame
Container.BackgroundTransparency = 1
Container.Position = UDim2.new(0, 15, 0, 50)
Container.Size = UDim2.new(1, -30, 1, -60)
Container.CanvasSize = UDim2.new(0, 0, 1.5, 0)
Container.ScrollBarThickness = 4

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = Container
UIListLayout.Padding = UDim.new(0, 10)

-- Переменные состояний читов
local godModeEnabled = false
local speedBoostEnabled = false
local autoKillEnabled = false

-- Функция создания красивых кнопок в меню
Funcs = {}
function Funcs:CreateButton(text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Parent = Container
    Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Btn.BorderColor3 = Color3.fromRGB(40, 40, 40)
    Btn.Size = UDim2.new(1, 0, 0, 40)
    Btn.Font = Enum.Font.GothamSemibold
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    Btn.TextSize = 13
    
    Btn.MouseButton1Click:Connect(function()
        callback(Btn)
    end)
end

-- Кнопка 1: Бессмертие (God-Mode)
Funcs:CreateButton("🛡️ Бессмертие (God-Mode): ВЫКЛ", function(btn)
    godModeEnabled = not godModeEnabled
    if godModeEnabled then
        btn.Text = "🛡️ Бессмертие (God-Mode): ВКЛ"
        btn.TextColor3 = Color3.fromRGB(50, 255, 100)
    else
        btn.Text = "🛡️ Бессмертие (God-Mode): ВЫКЛ"
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end)

-- Кнопка 2: Ускорение ODM-гира
Funcs:CreateButton("⚡ Ускорение и Прыжок: ВЫКЛ", function(btn)
    speedBoostEnabled = not speedBoostEnabled
    if speedBoostEnabled then
        btn.Text = "⚡ Ускорение и Прыжок: ВКЛ"
        btn.TextColor3 = Color3.fromRGB(50, 255, 100)
    else
        btn.Text = "⚡ Ускорение и Прыжок: ВЫКЛ"
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end)

-- Кнопка 3: Авто-убийство титанов
Funcs:CreateButton("⚔️ Авто-Фарм Титанов (Instant Nape): ВЫКЛ", function(btn)
    autoKillEnabled = not autoKillEnabled
    if autoKillEnabled then
        btn.Text = "⚔️ Авто-Фарм Титанов (Instant Nape): ВКЛ"
        btn.TextColor3 = Color3.fromRGB(50, 255, 100)
    else
        btn.Text = "⚔️ Авто-Фарм Титанов (Instant Nape): ВЫКЛ"
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end)

-- Фоновый процесс выполнения функций
RunService.RenderStepped:Connect(function()
    if godModeEnabled then
        pcall(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.Health = char.Humanoid.MaxHealth
            end
        end)
    end

    if speedBoostEnabled then
        pcall(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.WalkSpeed = 36
                char.Humanoid.JumpPower = 110
            end
        end)
    end
end)

-- Поток авто-фарма титанов
task.spawn(function()
    while true do
        task.wait(0.3)
        if autoKillEnabled then
            pcall(function()
                for _, titan in ipairs(workspace.Titans:GetChildren()) do
                    local nape = titan:FindFirstChild("Nape") or titan:FindFirstChild("UpperNeck")
                    if nape and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = nape.CFrame * CFrame.new(0, 0, -2)
                    end
                end
            end)
        end
    end
end)

print("[Caxim Hub] Элитное графическое меню успешно загружено!")
