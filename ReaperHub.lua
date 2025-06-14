--!strict
-- Nome do seu Script/Hub: ReaperHub
-- Versão: 1.6 (Correção do erro CornerRadius)

-- [INÍCIO] --- CARREGAMENTO DA BIBLIOTECA FLUENT (NÃO REMOVA) ---
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
-- [FIM] --- CARREGAMENTO DA BIBLIOTECA FLUENT ---

-- ====================================================================================================
-- === CONFIGURAÇÃO DO SEU HUB VISUAL (O FRAME QUE AS OPÇÕES VÃO AFETAR) ===
-- ====================================================================================================

-- [INÍCIO] --- REFERÊNCIA AO SEU HUB VISUAL (MUITO IMPORTANTE!) ---
-- Este código irá CRIAR um Frame simples para você testar as mudanças de cor/transparência.
local SeuHub = Instance.new("Frame")
SeuHub.Name = "ReaperVisualHub" -- Nome do Frame que será criado para o seu Hub
SeuHub.Parent = game.Players.LocalPlayer.PlayerGui -- Coloca o Frame na PlayerGui
SeuHub.Size = UDim2.new(0.3, 0, 0.5, 0) -- Tamanho do Frame (30% da largura, 50% da altura da tela)
SeuHub.Position = UDim2.new(0.5, 0, 0.5, 0) -- Posição (centralizado)
SeuHub.BackgroundColor3 = Color3.fromRGB(50, 50, 50) -- Cor inicial padrão (será alterada pelas opções)
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
-- [FIM] --- REFERÊNCIA AO SEU HUB VISUAL ---

-- [INÍCIO] --- CRIAÇÃO DO ÍCONE FLUTUANTE DE MINIMIZAR (Texto) ---
local MinimizedBox = Instance.new("TextButton")
MinimizedBox.Name = "ReaperMinimizedIcon"
MinimizedBox.Size = UDim2.new(0, 50, 0, 50)
MinimizedBox.Position = UDim2.new(0.01, 0, 0.5, 0)
MinimizedBox.BackgroundColor3 = Color3.fromRGB(96, 205, 255)
MinimizedBox.BackgroundTransparency = 0.2
MinimizedBox.Text = "R"
MinimizedBox.TextColor3 = Color3.new(1,1,1)
MinimizedBox.Font = Enum.Font.SourceSansBold
MinimizedBox.TextSize = 24
MinimizedBox.Visible = false
MinimizedBox.Parent = game.Players.LocalPlayer.PlayerGui

-- Corrigido: CornerRadius agora usa UDim em vez de UDim2
local UICornerMinimize = Instance.new("UICorner")
UICornerMinimize.CornerRadius = UDim.new(0.5, 0) -- CORREÇÃO AQUI: UDim.new(scale, offset)
UICornerMinimize.Parent = MinimizedBox

local UIStrokeMinimize = Instance.new("UIStroke")
UIStrokeMinimize.Color = Color3.fromRGB(0, 120, 212)
UIStrokeMinimize.Thickness = 2
UIStrokeMinimize.Parent = MinimizedBox
-- [FIM] --- CRIAÇÃO DO ÍCONE FLUTUANTE DE MINIMIZAR ---

-- ====================================================================================================
-- === CONFIGURAÇÃO DA JANELA PRINCIPAL FLUENT UI ===
-- ====================================================================================================

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
        {"Azul Claro", Color3.fromRGB(96, 205, 255)},
        {"Verde", Color3.fromRGB(100, 200, 100)},
        {"Vermelho", Color3.fromRGB(200, 80, 80)},
        {"Amarelo", Color3.fromRGB(255, 255, 100)},
        {"Roxo", Color3.fromRGB(150, 100, 200)}
    }

    -- Mapeia os nomes das cores para os valores Color3
    local colorMap = {}
    local defaultColorName = predefinedColors[1][1]
    for _, colorInfo in ipairs(predefinedColors) do
        colorMap[colorInfo[1]] = colorInfo[2]
    end

    -- Seletor de cor para o hub (Dropdown)
    local HubColorDropdown = Tabs.Settings:AddDropdown("HubColor", {
        Title = "Cor do Hub",
        Default = defaultColorName,
        Values = (function()
            local names = {}
            for _, colorInfo in ipairs(predefinedColors) do
                table.insert(names, colorInfo[1])
            end
            return names
        end)(),
        Callback = function(SelectedColorName)
            local selectedColor = colorMap[SelectedColorName]
            if SeuHub and SeuHub:IsA("GuiObject") then
                SeuHub.BackgroundColor3 = selectedColor
            end
            print("Cor do Hub alterada para:", SelectedColorName, selectedColor)
        end
    })

    -- Slider de Transparência (10% a 100%, pulando de 10 em 10%)
    local HubTransparencySlider = Tabs.Settings:AddSlider("HubTransparency", {
        Title = "Transparência do Hub",
        Description = "Ajuste a transparência geral do Hub (100% visível a 10% visível).",
        Default = 100,
        Min = 10,
        Max = 100,
        Rounding = 0,
        Compact = false,
        Callback = function(Value)
            local transparency = 1 - (Value / 100)
            if SeuHub and SeuHub:IsA("GuiObject") then
                SeuHub.BackgroundTransparency = transparency
            end
            print("Transparência do Hub alterada para:", Value .. "% visível")
        end
    })

    InterfaceManager:BuildInterfaceSection(Tabs.Settings)
    SaveManager:BuildConfigSection(Tabs.Settings)
end
-- [FIM] --- CONTEÚDO DA ABA 'CONFIGURAÇÕES' ---


-- [INÍCIO] --- FUNCIONALIDADE DE MINIMIZAR PARA ÍCONE FLUTUANTE ---
-- Evento de clique para reabrir a janela
MinimizedBox.MouseButton1Click:Connect(function()
    Window:Show()
    MinimizedBox.Visible = false
end)

-- Sobrescrevendo a função de minimizar padrão da Fluent
Window:OnMinimize(function()
    MinimizedBox.Visible = true
    -- SeuHub.Visible = false
end)

-- Certificar que o ícone é escondido quando a janela está visível (ex: ao carregar ou reabrir)
Window:OnShow(function()
    MinimizedBox.Visible = false
    -- SeuHub.Visible = true
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
