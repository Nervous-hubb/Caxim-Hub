-- [[ CAXIM HUB // ULTIMATE AOT REVOLUTION v11.0 GOD-TIER EDITION ]]
-- [[ OUTPERFORMING LUNARZ // DESIGNED FOR ELITE EXECUTION ]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

if CoreGui:FindFirstChild("CaximGodTierHub") then
    CoreGui.CaximGodTierHub:Destroy()
end

local function CaximNotify(title, text, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title;
            Text = text;
            Duration = duration or 3;
        })
    end)
end

-- Главное окно
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CaximGodTierHub"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(6, 6, 6)
MainFrame.BorderColor3 = Color3.fromRGB(220, 38, 38)
MainFrame.BorderSizePixel = 1
MainFrame.Position = UDim2.new(0.5, -230, 0.5, -210)
MainFrame.Size = UDim2.new(0, 460, 0, 420)
MainFrame.Active = true
MainFrame.Draggable = true

local UICornerMain = Instance.new("UICorner")
UICornerMain.CornerRadius = UDim.new(0, 8)
UICornerMain.Parent = MainFrame

-- Шапка
local Header = Instance.new("Frame")
Header.Parent = MainFrame
Header.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Header.Size = UDim2.new(1, 0, 0, 45)

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
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "⚡ CAXIM HUB v11.0 [ULTIMATE]"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = Header
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 38, 38)
CloseBtn.Position = UDim2.new(1, -35, 0, 10)
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 12

local UICornerClose = Instance.new("UICorner")
UICornerClose.CornerRadius = UDim.new(0, 5)
UICornerClose.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    local tween = TweenService:Create(MainFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0, 0), Transparency = 1})
    tween:Play()
    tween.Completed:Wait()
    ScreenGui:Destroy()
end)

-- Контейнер прокрутки
local Container = Instance.new("ScrollingFrame")
Container.Parent = MainFrame
Container.BackgroundTransparency = 1
Container.Position = UDim2.new(0, 15, 0, 58)
Container.Size = UDim2.new(1, -30, 1, -145)
Container.CanvasSize = UDim2.new(0, 0, 0, 0)
Container.AutomaticCanvasSize = Enum.AutomaticSize.Y
Container.ScrollBarThickness = 3
Container.ScrollBarImageColor3 = Color3.fromRGB(220, 38, 38)

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = Container
UIListLayout.Padding = UDim.new(0, 10)

-- Состояния читов
local godModeEnabled = false
local speedBoostEnabled = false
local autoKillEnabled = false
local autoReloadEnabled = false
local failSafeEnabled = false

-- Конструктор переключателей
local function CreateToggleOption(titleText, initialState, callback)
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Parent = Container
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    ToggleBtn.BorderColor3 = Color3.fromRGB(25, 25, 25)
    ToggleBtn.Size = UDim2.new(1, 0, 0, 40)
    ToggleBtn.Font = Enum.Font.GothamSemibold
    ToggleBtn.TextColor3 = Color3.fromRGB(160, 160, 160)
    ToggleBtn.TextSize = 12
    ToggleBtn.TextXAlignment = Enum.TextXAlignment.Left

    local UICornerBtn = Instance.new("UICorner")
    UICornerBtn.CornerRadius = UDim.new(0, 6)
    UICornerBtn.Parent = ToggleBtn

    local indicator = Instance.new("Frame")
    indicator.Parent = ToggleBtn
    indicator.Position = UDim2.new(1, -32, 0.5, -6)
    indicator.Size = UDim2.new(0, 12, 0, 12)
    
    local UICornerInd = Instance.new("UICorner")
    UICornerInd.CornerRadius = UDim.new(1, 0)
    UICornerInd.Parent = indicator

    local active = initialState

    local function updateVisual(notify)
        if active then
            ToggleBtn.Text = "   " .. titleText .. ": [ ВКЛ ]"
            ToggleBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
            indicator.BackgroundColor3 = Color3.fromRGB(50, 255, 100)
            if notify then CaximNotify("Caxim Hub", titleText .. " активирован!", 2) end
        else
            ToggleBtn.Text = "   " .. titleText .. ": [ ВЫКЛ ]"
            ToggleBtn.TextColor3 = Color3.fromRGB(160, 160, 160)
            indicator.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            if notify then CaximNotify("Caxim Hub", titleText .. " отключен.", 2) end
        end
        callback(active)
    end

    updateVisual(false)

    ToggleBtn.MouseButton1Click:Connect(function()
        active = not active
        updateVisual(true)
    end)

    return {
        Set = function(val) active = val updateVisual(false) end,
        Get = function() return active end
    }
end

-- Добавляем функционал
local godToggle = CreateToggleOption("🛡️ Бессмертие (God-Mode)", false, function(state) godModeEnabled = state end)
local speedToggle = CreateToggleOption("⚡ Ускорение ODM и Прыжок", false, function(state) speedBoostEnabled = state end)
local autoKillToggle = CreateToggleOption("⚔️ Авто-Фарм Титанов (Instant Nape)", false, function(state) autoKillEnabled = state end)
local autoReloadToggle = CreateToggleOption("🔄 Авто-перезарядка клинков (Auto Reload)", false, function(state) autoReloadEnabled = state end)
local failSafeToggle = CreateToggleOption("🛡️ Страховка от смерти (Fail Safe)", false, function(state) failSafeEnabled = state end)

-- Нижняя панель конфигов
local ConfigFrame = Instance.new("Frame")
ConfigFrame.Parent = MainFrame
ConfigFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
ConfigFrame.BorderColor3 = Color3.fromRGB(25, 25, 25)
ConfigFrame.Position = UDim2.new(0, 15, 1, -65)
ConfigFrame.Size = UDim2.new(1, -30, 0, 50)

local UICornerConfig = Instance.new("UICorner")
UICornerConfig.CornerRadius = UDim.new(0, 6)
UICornerConfig.Parent = ConfigFrame

local SaveConfigBtn = Instance.new("TextButton")
SaveConfigBtn.Parent = ConfigFrame
SaveConfigBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
SaveConfigBtn.Size = UDim2.new(0.48, 0, 0, 34)
SaveConfigBtn.Position = UDim2.new(0, 8, 0.5, -17)
SaveConfigBtn.Font = Enum.Font.GothamBold
SaveConfigBtn.Text = "💾 СОХРАНИТЬ КОНФИГ"
SaveConfigBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
SaveConfigBtn.TextSize = 11

local UICornerSave = Instance.new("UICorner")
UICornerSave.CornerRadius = UDim.new(0, 4)
UICornerSave.Parent = SaveConfigBtn

local LoadConfigBtn = Instance.new("TextButton")
LoadConfigBtn.Parent = ConfigFrame
LoadConfigBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
LoadConfigBtn.Size = UDim2.new(0.48, 0, 0, 34)
LoadConfigBtn.Position = UDim2.new(0.52, -4, 0.5, -17)
LoadConfigBtn.Font = Enum.Font.GothamBold
LoadConfigBtn.Text = "📁 ЗАГРУЗИТЬ КОНФИГ"
LoadConfigBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
LoadConfigBtn.TextSize = 11

local UICornerLoad = Instance.new("UICorner")
UICornerLoad.CornerRadius = UDim.new(0, 4)
UICornerLoad.Parent = LoadConfigBtn

local configFileName = "CaximAotV11Config.json"

SaveConfigBtn.MouseButton1Click:Connect(function()
    pcall(function()
        if writefile then
            local jsonString = string.format('{"GodMode":%s,"SpeedBoost":%s,"AutoKill":%s,"AutoReload":%s,"FailSafe":%s}', 
                tostring(godToggle.Get()), tostring(speedToggle.Get()), tostring(autoKillToggle.Get()), tostring(autoReloadToggle.Get()), tostring(failSafeToggle.Get()))
            writefile(configFileName, jsonString)
            CaximNotify("Config", "Конфигурация успешно сохранена!", 2)
        end
    end)
end)

LoadConfigBtn.MouseButton1Click:Connect(function()
    pcall(function()
        if readfile and isfile and isfile(configFileName) then
            local content = readfile(configFileName)
            if string.find(content, '"GodMode":true') then godToggle.Set(true) else godToggle.Set(false) end
            if string.find(content, '"SpeedBoost":true') then speedToggle.Set(true) else speedToggle.Set(false) end
            if string.find(content, '"AutoKill":true') then autoKillToggle.Set(true) else autoKillToggle.Set(false) end
            if string.find(content, '"AutoReload":true') then autoReloadToggle.Set(true) else autoReloadToggle.Set(false) end
            if string.find(content, '"FailSafe":true') then failSafeToggle.Set(true) else failSafeToggle.Set(false) end
            CaximNotify("Config", "Конфигурация загружена!", 2)
        end
    end)
end)

-- Фоновые процессы выполнения
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
                char.Humanoid.WalkSpeed = 40
                char.Humanoid.JumpPower = 130
            end
        end)
    end

    if failSafeEnabled then
        pcall(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") and char:FindFirstChild("HumanoidRootPart") then
                if char.Humanoid.Health > 0 and char.Humanoid.Health < 20 then
                    char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + Vector3.new(0, 150, 0)
                    CaximNotify("Fail Safe", "Активирована страховка! Эвакуация вверх.", 2)
                    task.wait(1)
                end
            end
        end)
    end
end)

task.spawn(function()
    while true do
        task.wait(0.2)
        if autoKillEnabled then
            pcall(function()
                if workspace:FindFirstChild("Titans") then
                    for _, titan in ipairs(workspace.Titans:GetChildren()) do
                        local nape = titan:FindFirstChild("Nape") or titan:FindFirstChild("UpperNeck")
                        if nape and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = nape.CFrame * CFrame.new(0, 0, -2.5)
                        end
                    end
                end
            end)
        end

        if autoReloadEnabled then
            pcall(function()
                local vim = game:GetService("VirtualInputManager")
                vim:SendKeyEvent(true, Enum.KeyCode.R, false, game)
                vim:SendKeyEvent(false, Enum.KeyCode.R, false, game)
            end)
        end
    end
end)

CaximNotify("CAXIM HUB v11.0", "Элитный софт успешно запущен!", 4)
print("[CAXIM HUB] Версия v11.0 успешно активирована.")
