--!strict
-- Nome do seu Script/Hub: ReaperHub
-- Versão: 2.14 (Última tentativa de forçar atualização e compatibilidade)

-- [INÍCIO] --- CARREGAMENTO DA BIBLIOTECA FLUENT (NÃO REMOVA) ---
local timestamp_fluent = os.time() -- timestamp para forçar cache buster na Fluent
-- Usando a URL do branch 'master' para garantir a versão mais recente
local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/main.lua?v=" .. timestamp_fluent))()

-- Debugging: Verificar se Fluent carregou corretamente
print("--- Fluent v2.14: Carregamento verificado ---") -- Marcador de versão 2.14
print("Fluent loaded status: type=", type(Fluent), "is table=", (type(Fluent) == "table"), "has CreateWindow=", (type(Fluent).CreateWindow ~= nil and type(Fluent.CreateWindow) == "function"))
if not (type(Fluent) == "table" and type(Fluent.CreateWindow) == "function") then
    warn("Fluent UI library failed to load or is incomplete. Minimizing functionality may not be expected.")
    warn("Erro: A biblioteca Fluent n\227o carregou corretamente. Fun\231\245es de UI podem estar ausentes.")
    return -- Interrompe o script se a Fluent não carregar, para evitar mais erros
end
print("Fluent carregado com sucesso, prosseguindo com SaveManager e InterfaceManager.")

-- Os SaveManager e InterfaceManager também dependem da Fluent, vamos garantir que eles também carreguem via HTTPS
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua?v=" .. timestamp_fluent))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua?v=" .. timestamp_fluent))()
print("SaveManager e InterfaceManager carregados.")
-- [FIM] --- CARREGAMENTO DA BIBLIOTECA FLUENT ---

-- ====================================================================================================
-- === CONFIGURAÇÃO DO SEU HUB VISUAL (O FRAME QUE AS OPÇÕES VÃO AFETAR) ===
-- ====================================================================================================

-- [INÍCIO] --- REFERÊNCIA AO SEU HUB VISUAL (MUITO IMPORTANTE!) ---
local SeuHub = Instance.new("Frame")
SeuHub.Name = "ReaperVisualHub"
SeuHub.Parent = game.Players.LocalPlayer.PlayerGui
SeuHub.Size = UDim2.new(0.3, 0, 0.5, 0)
SeuHub.Position = UDim2.new(0.5, 0, 0.5, 0)
SeuHub.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SeuHub.BorderSizePixel = 0
SeuHub.AnchorPoint = Vector2.new(0.5, 0.5)
SeuHub.Visible = true
print("SeuHub (Frame visual) criado. Visibilidade inicial:", SeuHub.Visible)

local HubText = Instance.new("TextLabel")
HubText.Text = "Meu Hub de Teste"
HubText.Size = UDim2.new(1, 0, 1, 0)
HubText.BackgroundTransparency = 1
HubText.TextColor3 = Color3.new(1,1,1)
HubText.Font = Enum.Font.SourceSansBold
HubText.TextSize = 20
HubText.Parent = SeuHub

-- Novo botão para minimizar/restaurar no SeuHub
local MinimizeButtonInHub = Instance.new("TextButton")
MinimizeButtonInHub.Name = "MinimizeRestoreButton"
MinimizeButtonInHub.Text = "Minimizar/Restaurar"
MinimizeButtonInHub.Size = UDim2.new(0.8, 0, 0.1, 0)
MinimizeButtonInHub.Position = UDim2.new(0.1, 0, 0.9, 0) -- Posição na parte inferior do SeuHub
MinimizeButtonInHub.BackgroundColor3 = Color3.fromRGB(0, 120, 212)
MinimizeButtonInHub.TextColor3 = Color3.new(1, 1, 1)
MinimizeButtonInHub.Font = Enum.Font.SourceSansBold
MinimizeButtonInHub.TextSize = 18
MinimizeButtonInHub.Parent = SeuHub
print("Botão 'Minimizar/Restaurar' adicionado ao SeuHub.")
-- [FIM] --- REFERÊNCIA AO SEU HUB VISUAL ---

-- [INÍCIO] --- CRIAÇÃO DO ÍCONE FLUTUANTE DE MINIMIZAR (Imagem Arrastável) ---
local MinimizedBox = Instance.new("ImageButton")
MinimizedBox.Name = "ReaperMinimizedIcon"
MinimizedBox.Size = UDim2.new(0, 50, 0, 50)
MinimizedBox.Position = UDim2.new(0.01, 0, 0.5, 0) -- Posição inicial (canto esquerdo-meio)
MinimizedBox.BackgroundTransparency = 1 -- Fundo transparente para mostrar apenas a imagem
MinimizedBox.Image = "rbxassetid://105362230092644" -- SEU ASSET ID
MinimizedBox.ImageTransparency = 0 -- Imagem totalmente visível
MinimizedBox.Visible = false -- Inicia invisível
MinimizedBox.Parent = game.Players.LocalPlayer.PlayerGui
print("MinimizedBox (ícone de minimizar) criado. Visibilidade inicial:", MinimizedBox.Visible)

local UICornerMinimize = Instance.new("UICorner")
UICornerMinimize.CornerRadius = UDim.new(0.5, 0)
UICornerMinimize.Parent = MinimizedBox
print("UICorner para MinimizedBox criado.")

local UIStrokeMinimize = Instance.new("UIStroke")
UIStrokeMinimize.Color = Color3.fromRGB(0, 120, 212)
UIStrokeMinimize.Thickness = 2
UIStrokeMinimize.Parent = MinimizedBox
print("UIStroke para MinimizedBox criado.")

-- Lógica para arrastar o ícone
local UserInputService = game:GetService("UserInputService")
local dragging = false
local dragStart = Vector2.new(0, 0)
local initialPosition = UDim2.new(0, 0, 0, 0)

MinimizedBox.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        initialPosition = MinimizedBox.Position
        input.Handled = true
        print("MinimizedBox InputBegan: Arrastando INICIADO. dragging =", dragging)
    end
end)

MinimizedBox.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if dragging then
            local delta = input.Position - dragStart
            local newX = initialPosition.X.Offset + delta.X
            local newY = initialPosition.Y.Offset + delta.Y

            local screenX = game.Players.LocalPlayer.PlayerGui.AbsoluteSize.X
            local screenY = game.Players.LocalPlayer.PlayerGui.AbsoluteSize.Y
            local iconSizeX = MinimizedBox.AbsoluteSize.X
            local iconSizeY = MinimizedBox.AbsoluteSize.Y

            newX = math.max(0, math.min(newX, screenX - iconSizeX))
            newY = math.max(0, math.min(newY, screenY - iconSizeY))

            MinimizedBox.Position = UDim2.new(0, newX, 0, newY)
        end
    end
end)

MinimizedBox.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
        print("MinimizedBox InputEnded: Arrastando ENCERRADO. dragging =", dragging)
    end
end)

-- [FIM] --- CRIAÇÃO DO ÍCONE FLUTUANTE DE MINIMIZAR ---

-- ====================================================================================================
-- === CONFIGURAÇÃO DA JANELA PRINCIPAL FLUENT UI ===
-- ====================================================================================================

-- [INÍCIO] --- CONFIGURAÇÃO DA JANELA PRINCIPAL ---
local Window
if Fluent and type(Fluent.CreateWindow) == "function" then
    Window = Fluent:CreateWindow({
        Title = "Reaper",
        SubTitle = "",
        TabWidth = 160,
        Size = UDim2.fromOffset(580, 460),
        Acrylic = true,
        Theme = "Dark",
    })
    print("Janela Fluent UI (Window) criada.")
else
    warn("Fluent.CreateWindow is not available. UI Window will not be created.")
    return
end
-- [FIM] --- CONFIGURAÇÃO DA JANELA PRINCIPAL ---

-- [INÍCIO] --- CRIAÇÃO DAS ABAS ---
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "" }),
    Settings = Window:AddTab({ Title = "Configurações", Icon = "" })
}
print("Abas Main e Configurações criadas.")
-- [FIM] --- CRIAÇÃO DAS ABAS ---

local Options = Fluent.Options
print("Fluent.Options referenciado.")

-- [INÍCIO] --- CONTEÚDO DA ABA 'MAIN' ---
do
    -- Usando AddTextBox para garantir compatibilidade com versões mais antigas da Fluent
    Tabs.Main:AddTextBox("Criado por:", "ReaperHub")
    print("Texto 'Criado: ReaperHub' adicionado à aba Main usando AddTextBox.")
end
-- [FIM] --- CONTEÚDO DA ABA 'MAIN' ---


-- [INÍCIO] --- CONTEÚDO DA ABA 'CONFIGURAÇÕES' (AGORA VAZIA) ---
do
    -- Sem conteúdo
end
-- [FIM] --- CONTEÚDO DA ABA 'CONFIGURAÇÕES' ---


-- [INÍCIO] --- FUNCIONALIDADE DE MINIMIZAR/RESTAURAR MANUALMENTE ---
local isUIVisible = true

-- Função para alternar a visibilidade do Hub e do ícone
local function toggleUI()
    print("----------------------------------------")
    print("toggleUI: FUNÇÃO INICIADA. isUIVisible =", isUIVisible)
    if isUIVisible then
        print("toggleUI: Minimizando...")
        Window:Hide() -- Esconde a janela Fluent
        print("Window.Visible após Hide():", Window.Visible)
        MinimizedBox.Visible = true -- Torna o ícone flutuante visível
        print("MinimizedBox.Visible após tornar visível:", MinimizedBox.Visible)
        SeuHub.Visible = false -- Esconde o Hub visual de teste
        print("SeuHub.Visible após esconder:", SeuHub.Visible)
        isUIVisible = false
        print("toggleUI: UI minimizada. MinimizedBox.Visible final =", MinimizedBox.Visible)
    else
        print("toggleUI: Restaurando...")
        Window:Show() -- Reabre a janela Fluent
        print("Window.Visible após Show():", Window.Visible)
        MinimizedBox.Visible = false -- Esconde o ícone flutuante
        print("MinimizedBox.Visible após esconder:", MinimizedBox.Visible)
        SeuHub.Visible = true -- Torna o Hub visual de teste visível
        print("SeuHub.Visible após tornar visível:", SeuHub.Visible)
        isUIVisible = true
        print("toggleUI: UI restaurada. MinimizedBox.Visible final =", MinimizedBox.Visible)
    end
    print("----------------------------------------")
end

-- Conectar a função toggleUI ao novo botão dentro do SeuHub
MinimizeButtonInHub.MouseButton1Click:Connect(function()
    print("Botão 'Minimizar/Restaurar' no SeuHub clicado! Chamando toggleUI().")
    toggleUI()
end)

-- Evento de clique no ícone para restaurar a janela
MinimizedBox.MouseButton1Click:Connect(function()
    print("MinimizedBox MouseButton1Click disparado. dragging =", dragging)
    if not dragging then
        print("MinimizedBox clicado: Restaurando UI. Chamando toggleUI().")
        toggleUI() -- Usa a mesma função para restaurar
    else
        print("MinimizedBox clicado, mas dragging ainda é TRUE. Não restaurando.")
    end
end)
-- [FIM] --- FUNCIONALIDADE DE MINIMIZAR/RESTAURAR MANUALMENTE ---


-- [INÍCIO] --- CONFIGURAÇÃO E INTEGRAÇÃO DE ADD-ONS ---
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
print("SaveManager e InterfaceManager configurados com a biblioteca Fluent.")

SaveManager:IgnoreThemeSettings()
print("SaveManager configurado para ignorar temas.")

InterfaceManager:SetFolder("ReaperHubSettings")
SaveManager:SetFolder("ReaperHubSettings/ConfiguracoesReaper")
print("Pastas de configura\231\245es definidas.")
-- [FIM] --- CONFIGURAÇÃO E INTEGRAÇÃO DE ADD-ONS ---


-- [INÍCIO] --- CONFIGURAÇÕES FINAIS E NOTIFICAÇÃO ---
Window:SelectTab(Tabs.Main)
print("Aba Main selecionada.")

Fluent:Notify({
    Title = "Reaper Ativo",
    Content = "O Hub Reaper foi carregado com sucesso!",
    Duration = 5
})
print("Notifica\231\227o 'Reaper Ativo' enviada.")

SaveManager:LoadAutoloadConfig()
print("Configura\231\245es de autoload carregadas.")
-- [FIM] --- CONFIGURAÇÕES FINAIS E NOTIFICAÇÃO ---
