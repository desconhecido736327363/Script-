--!strict
-- Nome do seu Script/Hub: ReaperHub
-- Versão: 1.3 (Cores pré-definidas, Transparência percentual, Hub Visual garantido)

-- [INÍCIO] --- CARREGAMENTO DA BIBLIOTECA FLUENT (NÃO REMOVA) ---
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
-- [FIM] --- CARREGAMENTO DA BIBLIOTECA FLUENT ---

-- [INÍCIO] --- REFERÊNCIA AO SEU HUB (MUITO IMPORTANTE!) ---
-- Este código irá CRIAR um Frame simples para você testar as mudanças de cor/transparência.
-- Se você já tem um Frame/ScreenGui específico que deseja usar, comente este bloco
-- e ajuste a linha de 'WaitForChild' para o nome do seu Frame.
local SeuHub = Instance.new("Frame")
SeuHub.Name = "ReaperVisualHub" -- Nome do Frame que será criado para o seu Hub
SeuHub.Parent = game.Players.LocalPlayer.PlayerGui -- Coloca o Frame na PlayerGui
SeuHub.Size = UDim2.new(0.3, 0, 0.5, 0) -- Tamanho do Frame (30% da largura, 50% da altura da tela)
SeuHub.Position = UDim2.new(0.5, 0, 0.5, 0) -- Posição (centralizado)
SeuHub.BackgroundColor3 = Color3.fromRGB(50, 50, 50) -- Cor inicial padrão
SeuHub.BorderSizePixel = 0 -- Remove a borda padrão
SeuHub.AnchorPoint = Vector2.new(0.5, 0.5) -- Define o ponto de âncora para centralização
SeuHub.Visible = true -- Garante que esteja visível por padrão

-- Adicionar um texto de exemplo ao SeuHub
local HubText = Instance.new("TextLabel")
HubText.Text = "Meu Hub de Teste"
HubText.Size = UDim2.new(1, 0, 1, 0)
HubText.BackgroundTransparency = 1
HubText.TextColor3 = Color3.new(1,1,1)
HubText.Font = Enum.Font.SourceSansBold
HubText.TextSize = 20
HubText.Parent = SeuHub
-- [FIM] --- REFERÊNCIA AO SEU HUB ---


-- [INÍCIO] --- CONFIGURAÇÃO DA JANELA PRINCIPAL ---
local Window = Fluent:CreateWindow({
    Title = "Reaper",
    SubTitle = "",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})
-- [FIM] --- CONFIGURAÇÃO DA JANELA PRINCIPAL ---

-- [INÍCIO] --- CRIAÇÃO DAS ABAS ---
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "" }),
    Settings = Window:AddTab({ Title = "Configurações", Icon = "" })
}
-- [FIM] --- CRIAÇÃO DAS ABAS ---

local Options = Fluent.Options

-- [INÍCIO] --- CONTEÚDO DA ABA 'MAIN' ---
do
    -- Sem conteúdo inicial
end
-- [FIM] --- CONTEÚDO DA ABA 'MAIN' ---


-- [INÍCIO] --- CONTEÚDO DA ABA 'CONFIGURAÇÕES' ---
do
    Tabs.Settings:AddParagraph({
        Title = "Aparência do Hub",
        Content = "Ajuste as configurações visuais do seu Hub Reaper."
    })

    -- Cores pré-definidas (os valores Color3.fromRGB() são as cores RGB)
    local predefinedColors = {
        {"Azul Claro", Color3.fromRGB(96, 205, 255)},    -- Azul
        {"Verde", Color3.fromRGB(100, 200, 100)},       -- Verde
        {"Vermelho", Color3.fromRGB(200, 80, 80)},      -- Vermelho
        {"Amarelo", Color3.fromRGB(255, 255, 100)},     -- Amarelo
        {"Roxo", Color3.fromRGB(150, 100, 200)}         -- Roxo
    }

    -- Mapeia os nomes das cores para os valores Color3
    local colorMap = {}
    local defaultColorName = predefinedColors[1][1] -- Pega o nome da primeira cor como padrão
    for _, colorInfo in ipairs(predefinedColors) do
        colorMap[colorInfo[1]] = colorInfo[2]
    end

    -- Seletor de cor para o hub (agora um Dropdown)
    local HubColorDropdown = Tabs.Settings:AddDropdown("HubColor", {
        Title = "Cor do Hub",
        Default = defaultColorName, -- Usa o nome da cor padrão
        Values = (function() -- Gera a lista de nomes para o dropdown
            local names = {}
            for _, colorInfo in ipairs(predefinedColors) do
                table.insert(names, colorInfo[1])
            end
            return names
        end)(),
        Callback = function(SelectedColorName)
            local selectedColor = colorMap[SelectedColorName]
            if SeuHub and SeuHub:IsA("GuiObject") and selectedColor then
                SeuHub.BackgroundColor3 = selectedColor
            end
            print("Cor do Hub alterada para:", SelectedColorName, selectedColor)
        end
    })

    -- Slider de Transparência (10% a 100%, pulando de 10 em 10%)
    local HubTransparencySlider = Tabs.Settings:AddSlider("HubTransparency", {
        Title = "Transparência do Hub",
        Description = "Ajuste a transparência geral do Hub (100% visível a 10% visível).",
        Default = 100, -- Representa 100% de visibilidade
        Min = 10, -- Mínimo 10% de visibilidade
        Max = 100, -- Máximo 100% de visibilidade
        Rounding = 0, -- Sem casas decimais para pular de 10 em 10
        Compact = false,
        Callback = function(Value)
            -- Converte a porcentagem (10-100) para transparência (0.9 a 0)
            -- Ex: 100% visível (Value=100) -> Transparência = 1 - (100/100) = 0
            -- Ex: 10% visível (Value=10) -> Transparência = 1 - (10/100) = 0.9
            local transparency = 1 - (Value / 100)
            if SeuHub and SeuHub:IsA("GuiObject") then
                SeuHub.BackgroundTransparency = transparency
            end
            print("Transparência do Hub alterada para:", Value .. "% visível")
        end
    })

    -- Adicionar as seções de Interface e Configurações dos Add-ons
    InterfaceManager:BuildInterfaceSection(Tabs.Settings)
    SaveManager:BuildConfigSection(Tabs.Settings)
end
-- [FIM] --- CONTEÚDO DA ABA 'CONFIGURAÇÕES' ---


-- [INÍCIO] --- FUNCIONALIDADE DE MINIMIZAR PARA ÍCONE FLUTUANTE ---
local MinimizedBox = Instance.new("TextButton")
MinimizedBox.Name = "ReaperMinimizedIcon"
MinimizedBox.Size = UDim2.new(0, 50, 0, 50) -- Tamanho do quadrado flutuante
MinimizedBox.Position = UDim2.new(0.01, 0, 0.5, 0) -- Posição inicial (canto esquerdo-meio)
MinimizedBox.BackgroundColor3 = Color3.fromRGB(96, 205, 255) -- Cor inicial do ícone (pode ser ajustada)
MinimizedBox.BackgroundTransparency = 0.2 -- Um pouco transparente
MinimizedBox.Text = "R" -- Texto do ícone (Reaper)
MinimizedBox.TextColor3 = Color3.new(1,1,1)
MinimizedBox.Font = Enum.Font.SourceSansBold
MinimizedBox.TextSize = 24
MinimizedBox.Visible = false -- Começa invisível
MinimizedBox.Parent = game.Players.LocalPlayer.PlayerGui -- Coloca na PlayerGui

-- Adicionar Corners e Strokes para o Fluent Design
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim2.new(0.5, 0) -- Torna-o circular
UICorner.Parent = MinimizedBox

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 120, 212) -- Cor da borda
UIStroke.Thickness = 2
UIStroke.Parent = MinimizedBox

-- Evento de clique para reabrir a janela
MinimizedBox.MouseButton1Click:Connect(function()
    Window:Show() -- Reabre a janela Fluent
    MinimizedBox.Visible = false -- Esconde o ícone flutuante
end)

-- Sobrescrevendo a função de minimizar padrão da Fluent
Window:OnMinimize(function()
    MinimizedBox.Visible = true -- Torna o ícone flutuante visível
end)

-- Certificar que o ícone é escondido quando a janela está visível (ex: ao carregar)
Window:OnShow(function()
    MinimizedBox.Visible = false
end)

-- [FIM] --- FUNCIONALIDADE DE MINIMIZAR PARA ÍCONE FLUTUANTE ---


-- [INÍCIO] --- CONFIGURAÇÃO E INTEGRAÇÃO DE ADD-ONS ---
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()

InterfaceManager:SetFolder("ReaperHubSettings")
SaveManager:SetFolder("ReaperHubSettings/ConfiguracoesReaper")
-- [FIM] --- CONFIGURAÇÃO E INTEGRAÇÃO DE ADD-ONS ---


-- [INÍCIO] --- CONFIGURAÇÕES FINAIS E NOTIFICAÇÃO ---
Window:SelectTab(Tabs.Main)

Fluent:Notify({
    Title = "Reaper Ativo",
    Content = "O Hub Reaper foi carregado com sucesso!",
    Duration = 5
})

SaveManager:LoadAutoloadConfig()
-- [FIM] --- CONFIGURAÇÕES FINAIS E NOTIFICAÇÃO ---
