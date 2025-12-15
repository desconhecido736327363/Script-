Local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

local RANOX = loadstring(game:HttpGet("https://raw.githubusercontent.com/SAMUCARARONOB/0-/refs/heads/main/RANOX_INTEFARCE"))()

local Window = RANOX:CreateWindow({
    Title = "Reaper_Hub",
    Subtitle = "v1.0"
})

-- Estado global
local State = {
    AimbotEnabled = false,
    ESPEnabled = false,
    TeamCheckEnabled = true,
    AimPart = "Head",
    FOV = 40,
    ESPColor = Color3.fromRGB(255,0,0)
}
local AimParts = {"Head", "Torso", "HumanoidRootPart"}
local ESPColors = {
    {Color3.fromRGB(255,0,0), "Vermelho"},
    {Color3.fromRGB(0,255,0), "Verde"},
    {Color3.fromRGB(0,170,255), "Azul"},
    {Color3.fromRGB(255,255,0), "Amarelo"},
    {Color3.fromRGB(255,127,0), "Laranja"},
    {Color3.fromRGB(255,255,255), "Branco"},
}

-- Funções separadas (Aimbot, ESP, etc) — igual ao script anterior

local function isEnemy(player)
    if not State.TeamCheckEnabled then return true end
    if LocalPlayer.Team and player.Team and player.Team == LocalPlayer.Team then return false end
    if LocalPlayer.TeamColor and player.TeamColor and player.TeamColor == LocalPlayer.TeamColor then return false end
    return true
end

local function getClosestPlayer()
    local closest = nil
    local shortest = State.FOV
    local center = Vector2.new(Camera.ViewportSize.X * 0.5, Camera.ViewportSize.Y * 0.5)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and isEnemy(player) and player.Character and player.Character:FindFirstChild(State.AimPart)
            and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local pos, onScreen = Camera:WorldToViewportPoint(player.Character[State.AimPart].Position)
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

local function removeAllESP()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            for _, part in ipairs(p.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    local esp = part:FindFirstChild("ESPBox")
                    if esp then esp:Destroy() end
                end
            end
        end
    end
end

local function updateESP()
    if State.ESPEnabled then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                for _, part in ipairs(p.Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        local old = part:FindFirstChild("ESPBox")
                        if not old then
                            local box = Instance.new("BoxHandleAdornment")
                            box.Adornee = part
                            box.AlwaysOnTop = true
                            box.ZIndex = 5
                            box.Size = part.Size
                            box.Transparency = 0.8
                            box.Color3 = State.ESPColor
                            box.Name = "ESPBox"
                            box.Parent = part
                        else
                            old.Color3 = State.ESPColor
                        end
                    end
                end
            end
        end
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        if State.ESPEnabled then
            task.wait(1)
            for _, part in ipairs(character:GetChildren()) do
                if part:IsA("BasePart") and not part:FindFirstChild("ESPBox") then
                    local box = Instance.new("BoxHandleAdornment")
                    box.Adornee = part
                    box.AlwaysOnTop = true
                    box.ZIndex = 5
                    box.Size = part.Size
                    box.Transparency = 0.8
                    box.Color3 = State.ESPColor
                    box.Name = "ESPBox"
                    box.Parent = part
                end
            end
        end
    end)
end)

RunService.Heartbeat:Connect(function()
    if State.AimbotEnabled then
        local center = Vector2.new(Camera.ViewportSize.X * 0.5, Camera.ViewportSize.Y * 0.5)
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild(State.AimPart) then
            local pos, onScreen = Camera:WorldToViewportPoint(target.Character[State.AimPart].Position)
            local delta = Vector2.new(pos.X, pos.Y) - center
            if delta.Magnitude < State.FOV then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character[State.AimPart].Position)
            end
        end
    end
end)

RunService.Stepped:Connect(function()
    if State.ESPEnabled then
        updateESP()
    end
end)

-- Interface RANOX
Window:CreateTab("PRINCIPAL", 4483362458)
Window:CreateTab("SETTING", 4483362458)
Window:CreateTab("CRÉDITOS", 4483362458)

Window:CreateToggle("PRINCIPAL", {
    Text = "AIMBOT",
    Description = "Ativa/desativa o Aimbot.",
    Default = false,
    Callback = function(isOn)
        State.AimbotEnabled = isOn
        Window:NotifyCustom("AIMBOT", isOn and "ATIVADO" or "DESATIVADO", "4483362458")
    end
})

Window:CreateToggle("PRINCIPAL", {
    Text = "ESP",
    Description = "Ativa/desativa ESP (caixas nos jogadores).",
    Default = false,
    Callback = function(isOn)
        State.ESPEnabled = isOn
        Window:NotifyCustom("ESP", isOn and "ATIVADO" or "DESATIVADO", "4483362458")
        if not isOn then removeAllESP() end
    end
})

Window:CreateToggle("PRINCIPAL", {
    Text = "TEAM CHECK",
    Description = "Só mira em inimigos.",
    Default = true,
    Callback = function(isOn)
        State.TeamCheckEnabled = isOn
    end
})

Window:CreateDropdown("PRINCIPAL", {
    Text = "Cor do ESP",
    Options = {"Vermelho", "Verde", "Azul", "Amarelo", "Laranja", "Branco"},
    Description = "Escolha a cor das caixas ESP.",
    Callback = function(selected)
        for i,v in ipairs(ESPColors) do
            if v[2] == selected then
                State.ESPColor = v[1]
            end
        end
    end
})

Window:CreateDropdown("SETTING", {
    Text = "AimPart",
    Options = AimParts,
    Description = "Escolha onde o Aimbot vai mirar.",
    Callback = function(selected)
        State.AimPart = selected
    end
})

Window:CreateDropdown("SETTING", {
    Text = "FOV",
    Options = {"20", "40", "60", "80", "100"},
    Description = "Ajuste o FOV do Aimbot.",
    Callback = function(selected)
        State.FOV = tonumber(selected)
    end
})

Window:CreateLabel("SETTING", "Altere as configurações abaixo:")

Window:CreateInfoBox("CRÉDITOS", "INFORMAÇÃO", {
    "Reaper_Hub adaptado para interface RANOX.",
    "Funções: Aimbot, ESP, TeamCheck, AimPart, FOV, Cor ESP.",
    "Personalize à vontade!"
})

-- AJUSTE DE TAMANHO GARANTIDO e Minimizar
task.wait(1)
local mainGui = nil
for _,v in ipairs(game:GetService("CoreGui"):GetChildren()) do
    if v:FindFirstChild("Top") and v.Name:lower():find("ranox") then
        mainGui = v
        break
    end
end
if mainGui and mainGui:FindFirstChild("Content") then
    mainGui.Content.Size = UDim2.new(0, 350, 0, 300)
    local topBar = mainGui:FindFirstChild("Top") or mainGui:FindFirstChildOfClass("Frame")
    if topBar then
        local minimizeBtn = Instance.new("TextButton")
        minimizeBtn.Name = "MinimizeBtn"
        minimizeBtn.Parent = topBar
        minimizeBtn.Size = UDim2.new(0, 32, 0, 23)
        minimizeBtn.Position = UDim2.new(1, -40, 0, 5)
        minimizeBtn.BackgroundColor3 = Color3.fromRGB(40,40,60)
        minimizeBtn.Text = "-"
        minimizeBtn.Font = Enum.Font.GothamBold
        minimizeBtn.TextScaled = true
        minimizeBtn.TextColor3 = Color3.new(1,1,1)
        minimizeBtn.BorderSizePixel = 0
        minimizeBtn.AutoButtonColor = true
        Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0.3,0)

        local minimized = false
        local content = mainGui:FindFirstChild("Content") or mainGui:FindFirstChildWhichIsA("Frame")
        minimizeBtn.MouseButton1Click:Connect(function()
            minimized = not minimized
            if content then
                content.Visible = not minimized
            end
            minimizeBtn.Text = minimized and "+" or "-"
        end)
    end
end
