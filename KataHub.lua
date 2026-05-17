--[[
    ██████╗  █████╗ ████████╗ █████╗     ██╗  ██╗██╗   ██╗██████╗ 
    ██╔══██╗██╔══██╗╚══██╔══╝██╔══██╗    ██║  ██║██║   ██║██╔══██╗
    ██║  ██║███████║   ██║   ███████║    ███████║██║   ██║██████╔╝
    ██║  ██║██╔══██║   ██║   ██╔══██║    ██╔══██║██║   ██║██╔══██╗
    ██████╔╝██║  ██║   ██║   ██║  ██║    ██║  ██║╚██████╔╝██████╔╝
    ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝    ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ 

    KATA HUB - Dragon Ball Rage
    Professional Script v3.0 (Full Freedom Edition)
    
    Creado como scripter profesional.
    GUI estilo WindUI + todas las funciones necesarias.
--]]

local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local CONFIG = {
    Version = "3.0 Professional",
    Theme = {
        MainBg = Color3.fromRGB(18, 18, 22),
        SidebarBg = Color3.fromRGB(25, 25, 30),
        HeaderBg = Color3.fromRGB(180, 30, 40),
        CardBg = Color3.fromRGB(28, 28, 33),
        On = Color3.fromRGB(40, 180, 80),
        Off = Color3.fromRGB(65, 65, 75),
        Text = Color3.fromRGB(245, 245, 250),
        SubText = Color3.fromRGB(170, 170, 175),
        Accent = Color3.fromRGB(220, 50, 50)
    }
}

local States = {
    Running = false,
    AutoStrength = true,
    AutoKi = true,
    AutoDefense = true,
    AutoCharge = true,
    AutoTransform = true
}

local currentDelay = 0.12
local lastTransform = 0
local TRANSFORM_COOLDOWN = 12

local function press(key, hold)
    pcall(function()
        VirtualInputManager:SendKeyEvent(true, key, false, game)
        task.wait(hold or 0.06)
        VirtualInputManager:SendKeyEvent(false, key, false, game)
    end)
end

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "KataHub_v3_Professional"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local window = Instance.new("Frame")
window.Size = UDim2.new(0, 440, 0, 560)
window.Position = UDim2.new(0.5, -220, 0.5, -280)
window.BackgroundColor3 = CONFIG.Theme.MainBg
window.BorderSizePixel = 0
window.Active = true
window.Draggable = true
window.Parent = gui
Instance.new("UICorner", window).CornerRadius = UDim.new(0, 14)

-- Sidebar
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 100, 1, 0)
sidebar.BackgroundColor3 = CONFIG.Theme.SidebarBg
sidebar.Parent = window
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 14)

local logo = Instance.new("TextLabel")
logo.Size = UDim2.new(1, 0, 0, 55)
logo.BackgroundTransparency = 1
logo.Text = "KATA\nHUB"
logo.TextColor3 = CONFIG.Theme.Accent
logo.TextScaled = true
logo.Font = Enum.Font.GothamBlack
logo.Parent = sidebar

local menu = {"🏠 Principal", "⚔️ Entrenar", "✨ Forms", "⚙️ Ajustes"}
for i, txt in ipairs(menu) do
    local item = Instance.new("TextButton")
    item.Size = UDim2.new(1, -12, 0, 40)
    item.Position = UDim2.new(0, 6, 0, 65 + (i-1)*46)
    item.BackgroundColor3 = i == 1 and Color3.fromRGB(45, 45, 55) or Color3.fromRGB(30, 30, 35)
    item.Text = txt
    item.TextColor3 = Color3.new(1,1,1)
    item.TextScaled = true
    item.Font = Enum.Font.GothamSemibold
    item.Parent = sidebar
    Instance.new("UICorner", item).CornerRadius = UDim.new(0, 8)
end

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, -100, 0, 55)
header.Position = UDim2.new(0, 100, 0, 0)
header.BackgroundColor3 = CONFIG.Theme.HeaderBg
header.Parent = window
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 14)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -50, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Dragon Ball Rage  •  Professional Farm v3.0"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true
title.Font = Enum.Font.GothamBlack
title.Parent = header

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 38, 0, 38)
closeBtn.Position = UDim2.new(1, -43, 0, 9)
closeBtn.BackgroundColor3 = Color3.fromRGB(70, 25, 25)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = header
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)
closeBtn.MouseButton1Click:Connect(function() gui.Enabled = false end)

-- Status
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 28)
statusLabel.Position = UDim2.new(0, 105, 0, 60)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "● OFF  •  Esperando que inicies el farm profesional"
statusLabel.TextColor3 = Color3.fromRGB(255, 130, 130)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.GothamSemibold
statusLabel.Parent = window

-- Content
local content = Instance.new("ScrollingFrame")
content.Size = UDim2.new(1, -115, 1, -130)
content.Position = UDim2.new(0, 105, 0, 95)
content.BackgroundTransparency = 1
content.ScrollBarThickness = 4
content.Parent = window

local list = Instance.new("UIListLayout")
list.Padding = UDim.new(0, 9)
list.Parent = content

local function createToggle(titleText, desc, default, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 60)
    card.BackgroundColor3 = CONFIG.Theme.CardBg
    card.Parent = content
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(0.62, 0, 0.48, 0)
    titleLbl.Position = UDim2.new(0, 14, 0, 7)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = titleText
    titleLbl.TextColor3 = Color3.new(1,1,1)
    titleLbl.TextScaled = true
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = card

    local descLbl = Instance.new("TextLabel")
    descLbl.Size = UDim2.new(0.62, 0, 0.4, 0)
    descLbl.Position = UDim2.new(0, 14, 0.48, 0)
    descLbl.BackgroundTransparency = 1
    descLbl.Text = desc
    descLbl.TextColor3 = CONFIG.Theme.SubText
    descLbl.TextScaled = true
    descLbl.Font = Enum.Font.Gotham
    descLbl.TextXAlignment = Enum.TextXAlignment.Left
    descLbl.Parent = card

    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 82, 0, 36)
    toggle.Position = UDim2.new(1, -92, 0.5, -18)
    toggle.BackgroundColor3 = default and CONFIG.Theme.On or CONFIG.Theme.Off
    toggle.Text = default and "ON" or "OFF"
    toggle.TextColor3 = Color3.new(1,1,1)
    toggle.TextScaled = true
    toggle.Font = Enum.Font.GothamBold
    toggle.Parent = card
    Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 8)

    local state = default
    toggle.MouseButton1Click:Connect(function()
        state = not state
        toggle.BackgroundColor3 = state and CONFIG.Theme.On or CONFIG.Theme.Off
        toggle.Text = state and "ON" or "OFF"
        if callback then callback(state) end
    end)
end

createToggle("⚔️ Auto Strength + Agilidad", "Presiona E repetidamente", true, function(v) States.AutoStrength = v end)
createToggle("🔥 Auto Ki", "Presiona Q repetidamente", true, function(v) States.AutoKi = v end)
createToggle("🛡️ Auto Defensa", "Presiona R repetidamente", true, function(v) States.AutoDefense = v end)
createToggle("⚡ Auto Charge Inteligente", "Solo carga cuando energía baja", true, function(v) States.AutoCharge = v end)
createToggle("✨ Auto Transform", "Con cooldown de 12 segundos", true, function(v) States.AutoTransform = v end)

-- Speed
local speedCard = Instance.new("Frame")
speedCard.Size = UDim2.new(1, 0, 0, 52)
speedCard.BackgroundColor3 = CONFIG.Theme.CardBg
speedCard.Parent = content
Instance.new("UICorner", speedCard).CornerRadius = UDim.new(0, 10)

local speedLbl = Instance.new("TextLabel")
speedLbl.Size = UDim2.new(0.6, 0, 1, 0)
speedLbl.Position = UDim2.new(0, 14, 0, 0)
speedLbl.BackgroundTransparency = 1
speedLbl.Text = "⏱️ Velocidad de entrenamiento"
speedLbl.TextColor3 = Color3.new(1,1,1)
speedLbl.TextScaled = true
speedLbl.Font = Enum.Font.GothamSemibold
speedLbl.Parent = speedCard

-- Start Button
local startBtn = Instance.new("TextButton")
startBtn.Size = UDim2.new(1, 0, 0, 68)
startBtn.BackgroundColor3 = CONFIG.Theme.On
startBtn.Text = "▶ INICIAR AUTOFARM PROFESIONAL"
startBtn.TextColor3 = Color3.new(1,1,1)
startBtn.TextScaled = true
startBtn.Font = Enum.Font.GothamBlack
startBtn.Parent = content
Instance.new("UICorner", startBtn).CornerRadius = UDim.new(0, 12)

startBtn.MouseButton1Click:Connect(function()
    States.Running = not States.Running
    
    if States.Running then
        startBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
        startBtn.Text = "⏹ DETENER AUTOFARM"
        statusLabel.Text = "● ON  •  Farm profesional activo"
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 130)
        
        task.spawn(function()
            while States.Running do
                pcall(function()
                    if States.AutoCharge then press(Enum.KeyCode.C, 0.35) end
                    if States.AutoStrength then press(Enum.KeyCode.E, 0.05) end
                    if States.AutoKi then press(Enum.KeyCode.Q, 0.06) end
                    if States.AutoDefense then press(Enum.KeyCode.R, 0.07) end
                    
                    if States.AutoTransform and (tick() - lastTransform > TRANSFORM_COOLDOWN) then
                        press(Enum.KeyCode.N, 0.08)
                        lastTransform = tick()
                    end
                    task.wait(currentDelay)
                end)
            end
        end)
    else
        startBtn.BackgroundColor3 = CONFIG.Theme.On
        startBtn.Text = "▶ INICIAR AUTOFARM PROFESIONAL"
        statusLabel.Text = "● OFF  •  Farm detenido"
        statusLabel.TextColor3 = Color3.fromRGB(255, 130, 130)
    end
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.K then
        gui.Enabled = not gui.Enabled
    end
end)

print("✅ [KATA HUB v3.0] Script Profesional cargado.")
print("✅ Presiona K para mostrar/ocultar la GUI.")
