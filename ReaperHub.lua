--[[
Aimbot + ESP para Roblox Mobile (KRNL)
- Quando tem player dentro do FOV (40 px), desenha um círculo vermelho exatamente em cima do player (lock)
- ESP básico em vermelho ativado junto do botão ON/OFF
- NÃO possui círculo preto central
- Botão ON/OFF no canto inferior direito
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

local AimPart = "Head"
local AimbotEnabled = false
local ESPEnabled = false
local FIELD_RADIUS = 40 -- FOV do aimbot

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("CoreGui") or LocalPlayer.PlayerGui

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 170, 0, 54)
button.Position = UDim2.new(0.83, 0, 0.90, 0)
button.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
button.TextColor3 = Color3.new(1,1,1)
button.TextScaled = true
button.Font = Enum.Font.SourceSansBold
button.Text = "AIMBOT: OFF"
button.Parent = screenGui

-- Círculo vermelho sobre o player lockado
local targetCircle = Drawing and Drawing.new("Circle") or nil
if targetCircle then
    targetCircle.Color = Color3.fromRGB(255, 0, 0)
    targetCircle.Filled = false
    targetCircle.Thickness = 2.5
    targetCircle.NumSides = 90
    targetCircle.Radius = 18
    targetCircle.Visible = false
end

-- === ESP BÁSICO INTEGRADO ===
local function createESP(part, color)
    if not part:FindFirstChild("ESPBox") then
        local box = Instance.new("BoxHandleAdornment")
        box.Adornee = part
        box.AlwaysOnTop = true
        box.ZIndex = 5
        box.Size = part.Size
        box.Transparency = 0.5
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

local function getClosestPlayer()
    local closest = nil
    local shortest = FIELD_RADIUS
    local center = Vector2.new(Camera.ViewportSize.X * 0.5, Camera.ViewportSize.Y * 0.5)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(AimPart) and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
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

    if AimbotEnabled then
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild(AimPart) then
            local pos, onScreen = Camera:WorldToViewportPoint(target.Character[AimPart].Position)
            if onScreen and targetCircle then
                targetCircle.Position = Vector2.new(pos.X, pos.Y)
                targetCircle.Visible = true
            end
            local delta = Vector2.new(pos.X, pos.Y) - center
            if delta.Magnitude < FIELD_RADIUS then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character[AimPart].Position)
            end
        else
            if targetCircle then targetCircle.Visible = false end
        end
    else
        if targetCircle then targetCircle.Visible = false end
    end
end)

button.MouseButton1Click:Connect(function()
    AimbotEnabled = not AimbotEnabled
    ESPEnabled = AimbotEnabled

    button.Text = AimbotEnabled and "AIMBOT: ON" or "AIMBOT: OFF"
    button.BackgroundColor3 = AimbotEnabled and Color3.fromRGB(0, 222, 0) or Color3.fromRGB(0, 122, 255)
    if not AimbotEnabled and targetCircle then targetCircle.Visible = false end

    -- ESP sincronizado com o botão
    if ESPEnabled then
        applyESPToPlayers()
    else
        removeESPFromPlayers()
    end
end)

-- Loop de manutenção ESP
RunService.Stepped:Connect(function()
    if ESPEnabled then
        applyESPToPlayers()
    end
end)
