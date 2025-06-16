--[[
Aimbot + ESP para Roblox Mobile (KRNL)
- HUB compacto, arrastável e arredondado
- Botões ficam um em cima do outro
- Nome do criador ("ReaperHub") no topo do hub
- Botão "Fechar" PEQUENO (X) para esconder o HUB e desativar tudo
- Botão "Minimizar" para reduzir o HUB (mostra só barra do topo, pode reabrir/maximizar)
- HUB pode ser arrastado pela tela (drag & drop)
- ESP é vermelho e mais transparente (transparency 0.8)
- NÃO possui círculo preto central nem círculo de lock
- Botões ON/OFF separados
- SEM team check (aimbot mira em todos)
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local AimPart = "Head"
local AimbotEnabled = false
local ESPEnabled = false
local FIELD_RADIUS = 40 -- FOV do aimbot

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("CoreGui") or LocalPlayer.PlayerGui

-- HUB Frame (compacto, arrastável)
local hubFrame = Instance.new("Frame")
hubFrame.Size = UDim2.new(0, 170, 0, 140)
hubFrame.Position = UDim2.new(0.7, 0, 0.7, 0)
hubFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
hubFrame.BackgroundTransparency = 0.25
hubFrame.BorderSizePixel = 0
hubFrame.Active = true
hubFrame.Draggable = false
hubFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0.2, 0)
corner.Parent = hubFrame

-- Nome do criador (ReaperHub)
local credit = Instance.new("TextLabel")
credit.Size = UDim2.new(1, -58, 0, 24)
credit.Position = UDim2.new(0, 10, 0, 0)
credit.BackgroundTransparency = 1
credit.Text = "ReaperHub"
credit.TextColor3 = Color3.fromRGB(0,255,127)
credit.TextScaled = true
credit.Font = Enum.Font.SourceSansBold
credit.TextXAlignment = Enum.TextXAlignment.Left
credit.Parent = hubFrame

-- Botão Minimizar
local minButton = Instance.new("TextButton")
minButton.Size = UDim2.new(0, 18, 0, 18)
minButton.Position = UDim2.new(1, -42, 0, 3)
minButton.BackgroundColor3 = Color3.fromRGB(60, 60, 180)
minButton.TextColor3 = Color3.new(1,1,1)
minButton.TextScaled = true
minButton.Font = Enum.Font.SourceSansBold
minButton.Text = "-"
minButton.Parent = hubFrame

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(1, 0)
minCorner.Parent = minButton

-- Botão Fechar (menor)
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 18, 0, 18)
closeButton.Position = UDim2.new(1, -22, 0, 3)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.TextColor3 = Color3.new(1,1,1)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.SourceSansBold
closeButton.Text = "X"
closeButton.Parent = hubFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = closeButton

-- Botão AIMBOT (primeiro)
local buttonAimbot = Instance.new("TextButton")
buttonAimbot.Size = UDim2.new(1, -20, 0, 44)
buttonAimbot.Position = UDim2.new(0, 10, 0, 34)
buttonAimbot.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
buttonAimbot.TextColor3 = Color3.new(1,1,1)
buttonAimbot.TextScaled = true
buttonAimbot.Font = Enum.Font.SourceSansBold
buttonAimbot.Text = "AIMBOT: OFF"
buttonAimbot.Parent = hubFrame

local cornerAimbot = Instance.new("UICorner")
cornerAimbot.CornerRadius = UDim.new(0.2, 0)
cornerAimbot.Parent = buttonAimbot

-- Botão ESP (abaixo)
local buttonESP = Instance.new("TextButton")
buttonESP.Size = UDim2.new(1, -20, 0, 44)
buttonESP.Position = UDim2.new(0, 10, 0, 86)
buttonESP.BackgroundColor3 = Color3.fromRGB(204, 0, 0)
buttonESP.TextColor3 = Color3.new(1,1,1)
buttonESP.TextScaled = true
buttonESP.Font = Enum.Font.SourceSansBold
buttonESP.Text = "ESP: OFF"
buttonESP.Parent = hubFrame

local cornerESP = Instance.new("UICorner")
cornerESP.CornerRadius = UDim.new(0.2, 0)
cornerESP.Parent = buttonESP

-- Minimizado? (estado)
local minimized = false

-- Minimizar/maximizar lógica
local function setMinimized(state)
    minimized = state
    if minimized then
        hubFrame.Size = UDim2.new(0, 170, 0, 28)
        buttonAimbot.Visible = false
        buttonESP.Visible = false
        minButton.Text = "+"
    else
        hubFrame.Size = UDim2.new(0, 170, 0, 140)
        buttonAimbot.Visible = true
        buttonESP.Visible = true
        minButton.Text = "-"
    end
end

minButton.MouseButton1Click:Connect(function()
    setMinimized(not minimized)
end)

-- Drag & Drop (Mobile e PC)
local dragging = false
local dragInput, dragStart, startPos

hubFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if input.Position.X > hubFrame.AbsolutePosition.X and input.Position.X < hubFrame.AbsolutePosition.X + hubFrame.AbsoluteSize.X
        and input.Position.Y > hubFrame.AbsolutePosition.Y and input.Position.Y < hubFrame.AbsolutePosition.Y + 28 then -- só drag no topo
            dragging = true
            dragStart = input.Position
            startPos = hubFrame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end
end)

hubFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        local newPos = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
        hubFrame.Position = newPos
    end
end)

-- === ESP BÁSICO INTEGRADO (mais transparente, SEM team check) ===
local function createESP(part, color)
    if not part:FindFirstChild("ESPBox") then
        local box = Instance.new("BoxHandleAdornment")
        box.Adornee = part
        box.AlwaysOnTop = true
        box.ZIndex = 5
        box.Size = part.Size
        box.Transparency = 0.8 -- Mais transparente!
        box.Color3 = color
        box.Name = "ESPBox"
        box.Parent = part
    end
end

local function addESPToCharacter(character)
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            createESP(part, Color3.new(1, 0, 0)) -- vermelho
        end
    end
end

local function removeESPFromCharacter(character)
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            local esp = part:FindFirstChild("ESPBox")
            if esp then
                esp:Destroy()
            end
        end
    end
end

local function applyESPToPlayers()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            addESPToCharacter(player.Character)
        end
    end
end

local function removeESPFromPlayers()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            removeESPFromCharacter(player.Character)
        end
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        if ESPEnabled then
            wait(1)
            addESPToCharacter(character)
        end
    end)
end)

-- AIMBOT SEM TEAM CHECK (mira em todos)
local function getClosestPlayer()
    local closest = nil
    local shortest = FIELD_RADIUS
    local center = Vector2.new(Camera.ViewportSize.X * 0.5, Camera.ViewportSize.Y * 0.5)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer
        and player.Character and player.Character:FindFirstChild(AimPart)
        and player.Character:FindFirstChild("Humanoid")
        and player.Character.Humanoid.Health > 0 then
            local pos, onScreen = Camera:WorldToViewportPoint(player.Character[AimPart].Position)
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                if dist < shortest then
                    shortest = dist
                    closest = player
                end
            end
        end
    end
    return closest
end

RunService.Heartbeat:Connect(function()
    local center = Vector2.new(Camera.ViewportSize.X * 0.5, Camera.ViewportSize.Y * 0.5)
    -- AIMBOT (SEM team check)
    if AimbotEnabled then
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild(AimPart) then
            local pos, onScreen = Camera:WorldToViewportPoint(target.Character[AimPart].Position)
            local delta = Vector2.new(pos.X, pos.Y) - center
            if delta.Magnitude < FIELD_RADIUS then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character[AimPart].Position)
            end
        end
    end
end)

buttonAimbot.MouseButton1Click:Connect(function()
    AimbotEnabled = not AimbotEnabled
    buttonAimbot.Text = AimbotEnabled and "AIMBOT: ON" or "AIMBOT: OFF"
    buttonAimbot.BackgroundColor3 = AimbotEnabled and Color3.fromRGB(0, 222, 0) or Color3.fromRGB(0, 122, 255)
end)

buttonESP.MouseButton1Click:Connect(function()
    ESPEnabled = not ESPEnabled
    buttonESP.Text = ESPEnabled and "ESP: ON" or "ESP: OFF"
    buttonESP.BackgroundColor3 = ESPEnabled and Color3.fromRGB(0, 204, 0) or Color3.fromRGB(204, 0, 0)
    if ESPEnabled then
        applyESPToPlayers()
    else
        removeESPFromPlayers()
    end
end)

closeButton.MouseButton1Click:Connect(function()
    -- Desabilita funcionalidades e esconde o HUB
    AimbotEnabled = false
    ESPEnabled = false
    buttonAimbot.Text = "AIMBOT: OFF"
    buttonAimbot.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
    buttonESP.Text = "ESP: OFF"
    buttonESP.BackgroundColor3 = Color3.fromRGB(204, 0, 0)
    removeESPFromPlayers()
    hubFrame.Visible = false
end)

-- Loop de manutenção ESP
RunService.Stepped:Connect(function()
    if ESPEnabled then
        applyESPToPlayers()
    end
end)

-- Inicialmente não minimizado
setMinimized(false)
