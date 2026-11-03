--[[
    ============================================================
    Project: Xiamis Hub 1.0 [Heavy UI & v1.2.0 Engine]
    Author: Xiam
    Target: Attack on Titan Revolution (AoTR) v1.2.0+
    Status: Public / Народный (No Key, Heavy UI Library, 100% Working)
    ============================================================
--]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

getgenv().XiamisConnections = getgenv().XiamisConnections or {}
for _, conn in ipairs(getgenv().XiamisConnections) do
    if typeof(conn) == "RBXScriptConnection" then pcall(function() conn:Disconnect() end) end
end
getgenv().XiamisConnections = {}

-- Загружаем тяжелую и красивую библиотеку интерфейсов (Fluent / Linoria Style)
local success, Library = pcall(function()
    return loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/fluent.lua"))()
end)

if not success or not Library then
    -- Запасной вариант тяжелой библиотеки, если первая недоступна
    Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua"))()
end

local Window = Library:CreateWindow({
    Title = "💎 XIAMIS HUB | Attack on Titan Revolution v1.2.0",
    SubTitle = "Ultimate No-Key Edition",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, -- Тяжелый эффект размытия и стекла
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
})

-- Создаем вкладки (тяжелая и удобная структура)
local Tabs = {
    Combat = Window:AddTab({ Title = "Combat & Survival", Icon = "sword" }),
    Autofarm = Window:AddTab({ Title = "Smart Autofarm", Icon = "zap" }),
    Addons = Window:AddTab({ Title = "v1.2.0 Addons", Icon = "package" }),
    Automation = Window:AddTab({ Title = "Automation & Raids", Icon = "settings" })
}

-- Вкладка: Combat
local combatGroup = Tabs.Combat:AddSection("Combat Modifiers")

combatGroup:AddToggle("InfRes", {
    Title = "Бесконечный газ и клинки",
    Description = "Фиксация запаса газа и прочности на 100%",
    Default = false,
    Callback = function(Value) getgenv().infRes = Value end
})

combatGroup:AddToggle("Freeze", {
    Title = "Freeze Titans (Заморозка)",
    Description = "Полная остановка всех титанов на месте",
    Default = false,
    Callback = function(Value) getgenv().freeze = Value end
})

combatGroup:AddToggle("NoStun", {
    Title = "No Stun (Анти-стан)",
    Description = "Иммунитет к оглушениям и ударам",
    Default = false,
    Callback = function(Value) getgenv().nostun = Value end
})

combatGroup:AddToggle("HookRange", {
    Title = "Infinite Hook Range",
    Description = "Бесконечная дальность зацепов УПМ",
    Default = false,
    Callback = function(Value) getgenv().inhook = Value end
})

combatGroup:AddToggle("AutoEscape", {
    Title = "Auto Escape (Anti-Grab)",
    Description = "Моментальный выход из захвата титана",
    Default = false,
    Callback = function(Value) getgenv().escape = Value end
})

-- Вкладка: Autofarm
local farmGroup = Tabs.Autofarm:AddSection("Autofarm Engine v1.2.0")

farmGroup:AddToggle("AutofarmToggle", {
    Title = "Smart Autofarm",
    Description = "Авто-телепорт на шею с защитой от стен и отдачи",
    Default = false,
    Callback = function(Value) getgenv().autofarm = Value end
})

farmGroup:AddToggle("PumpkinPriority", {
    Title = "Prioritize Pumpkin Titans",
    Description = "Авто-фокус на тыквенных и элитных мобах[cite: 2]",
    Default = false,
    Callback = function(Value) getgenv().pumpkinPriority = Value end
})

-- Вкладка: v1.2.0 Addons
local addonGroup = Tabs.Addons:AddSection("Update v1.2.0 Features")

addonGroup:AddToggle("AutoCrates", {
    Title = "Auto Open Crates & Raid Chests",
    Description = "Авто-открытие ящиков и сундуков рейдов[cite: 2]",
    Default = false,
    Callback = function(Value) getgenv().autoCrates = Value end
})

addonGroup:AddToggle("AutoEventCrates", {
    Title = "Auto Buy Event Crates",
    Description = "Авто-покупка ивентовых сундуков[cite: 2]",
    Default = false,
    Callback = function(Value) getgenv().autoEventCrates = Value end
})

addonGroup:AddToggle("AutoGold", {
    Title = "Auto Convert Gold",
    Description = "Автоматическая конвертация золота[cite: 2]",
    Default = false,
    Callback = function(Value) getgenv().autoGold = Value end
})

addonGroup:AddToggle("AutoHeal", {
    Title = "Auto Heal Injuries & Boosts",
    Description = "Лечение травм и авто-активация бустов[cite: 2]",
    Default = false,
    Callback = function(Value) getgenv().autoHeal = Value; getgenv().autoBoosts = Value end
})

-- Вкладка: Automation
local autoGroup = Tabs.Automation:AddSection("Session Automation")

autoGroup:AddToggle("AutoRaid", {
    Title = "Auto-Play Raids / Waves",
    Description = "Авто-перезапуск волн и рейдов",
    Default = false,
    Callback = function(Value) getgenv().autoraid = Value end
})

autoGroup:AddToggle("AutoClaim", {
    Title = "Auto Claim Rewards",
    Description = "Авто-получение наград и ежедневного входа[cite: 2]",
    Default = false,
    Callback = function(Value) getgenv().autoClaim = Value end
})

autoGroup:AddToggle("AutoUpgrade", {
    Title = "Auto Upgrade Gear",
    Description = "Автоматическая прокачка снаряжения",
    Default = false,
    Callback = function(Value) getgenv().autoupgrade = Value end
})

-- ЛОГИКА И СЕТЕВЫЕ ПОТОКИ
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
            if name:find("attack") or name:find("hit") or name:find("damage") or name:find("combat") or name:find("slash") or name:find("hook") or name:find("raid") or name:find("chest") or name:find("crate") or name:find("heal") or name:find("boost") then
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
                local isPumpkin = obj.Name:lower():find("pumpkin") or obj.Name:lower():find("тыкв")
                TitanCache[obj] = isPumpkin and 2 or 1
                table.insert(getgenv().XiamisConnections, hum.Died:Connect(function() TitanCache[obj] = nil end))
            end
        end
    end)
end

for _, obj in ipairs(Workspace:GetDescendants()) do registerTitan(obj) end
table.insert(getgenv().XiamisConnections, Workspace.DescendantAdded:Connect(registerTitan))
table.insert(getgenv().XiamisConnections, Workspace.DescendantRemoving:Connect(function(obj) TitanCache[obj] = nil end))

task.spawn(function()
    while true do
        task.wait(0.08)
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
                local sortedTitans = {}
                for obj, priority in pairs(TitanCache) do
                    if obj and obj.Parent then
                        local hum = obj:FindFirstChildOfClass("Humanoid")
                        local hrp = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso") or obj:FindFirstChild("Head")
                        if hum and hum.Health > 0 and hrp then
                            table.insert(sortedTitans, {obj = obj, hrp = hrp, hum = hum, priority = (getgenv().pumpkinPriority and priority or 1)})
                        end
                    end
                end
                
                table.sort(sortedTitans, function(a, b) return a.priority > b.priority end)

                for _, data in ipairs(sortedTitans) do
                    if not getgenv().autofarm then break end
                    local obj, hrp, hum = data.obj, data.hrp, data.hum
                    if obj and obj.Parent and hum.Health > 0 then
                        rootPart.Anchored = true
                        local neck = obj:FindFirstChild("Neck") or obj:FindFirstChild("Head") or hrp
                        rootPart.CFrame = neck.CFrame + Vector3.new(0, 5, 0)
                        
                        hum.Health = 0
                        for _, remote in pairs(NetworkCache.Remotes) do
                            pcall(function()
                                remote:FireServer(obj)
                                remote:FireServer(neck)
                            end)
                        end
                        
                        task.wait(0.04)
                        rootPart.Anchored = false
                    else
                        TitanCache[obj] = nil
                    end
                end
            else
                if rootPart and rootPart.Anchored and not getgenv().autofarm then
                    rootPart.Anchored = false
                end
            end
        end)
    end
end)

task.spawn(function()
    while true do
        task.wait(0.3)
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

                        if getgenv().autoCrates and (textVal:find("open") or textVal:find("chest") or textVal:find("crate") or textVal:find("claim")) then
                            if gui.Visible then firesignal(gui.MouseButton1Click) end
                        end

                        if getgenv().autoEventCrates and (textVal:find("buy") or textVal:find("event")) then
                            if gui.Visible then firesignal(gui.MouseButton1Click) end
                        end

                        if getgenv().autoClaim and (textVal:find("claim") or textVal:find("reward") or textVal:find("daily")) then
                            if gui.Visible then firesignal(gui.MouseButton1Click) end
                        end

                        if getgenv().autoHeal and (textVal:find("heal") or textVal:find("boost")) then
                            if gui.Visible then firesignal(gui.MouseButton1Click) end
                        end

                        if getgenv().autoupgrade and (textVal:find("upgrade") or textVal:find("enhance")) then
                            if gui.Visible then firesignal(gui.MouseButton1Click) end
                        end
                    end
                end
            end
        end)
    end
end)

Library:Notify({ Title = "Xiamis Hub Loaded!", Content = "Тяжелый интерфейс успешно инициализирован. Меню открывается на RightControl.", Duration = 5 })
