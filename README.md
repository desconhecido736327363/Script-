--!strict
-- Nome do seu Script/Hub: ReaperHub
-- Versão: 1.4 (Ícone e tema de fundo personalizados, cores pré-definidas, transparência percentual)

-- [INÍCIO] --- CARREGAMENTO DA BIBLIOTECA FLUENT (NÃO REMOVA) ---
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
-- [FIM] --- CARREGAMENTO DA BIBLIOTECA FLUENT ---

-- ====================================================================================================
-- === CONFIGURAÇÃO DO SEU HUB VISUAL (O FRAME QUE AS OPÇÕES VÃO AFETAR) E IMAGENS ===
-- ====================================================================================================

-- !!! ATENÇÃO: SUBSTITUA 'YOUR_IMAGE_ASSET_ID_HERE' PELO ID DA SUA IMAGEM NO ROBLOX !!!
local REAPER_IMAGE_ASSET_ID = "YOUR_IMAGE_ASSET_ID_HERE" -- Ex: "rbxassetid://123456789" (Sem aspas se for só número)

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

-- [INÍCIO] --- CRIAÇÃO DO ÍCONE FLUTUANTE DE MINIMIZAR ---
local MinimizedBox = Instance.new("ImageButton") -- Usamos ImageButton agora
MinimizedBox.Name = "ReaperMinimizedIcon"
MinimizedBox.Size = UDim2.new(0, 70, 0, 70) -- Tamanho do ícone flutuante (ajustado para melhor visualização)
MinimizedBox.Position = UDim2.new(0.01, 0, 0.5, 0) -- Posição inicial (canto esquerdo-meio)
MinimizedBox.BackgroundTransparency = 1 -- Tornar o fundo transparente para ver só a imagem
MinimizedBox.Image = "rbxassetid://" .. REAPER_IMAGE_ASSET_ID -- Sua imagem como ícone
MinimizedBox.Visible = false -- Começa invisível
MinimizedBox.Parent = game.Players.LocalPlayer.PlayerGui -- Coloca na PlayerGui

-- Adicionar Corners para torná-lo circular se a imagem for quadrada
local UICornerMinimize = Instance.new("UICorner")
UICornerMinimize.CornerRadius = UDim2.new(0.5, 0) -- Torna-o circular
UICornerMinimize.Parent = MinimizedBox

-- Não precisamos de UIStroke se a imagem já tiver a borda que você quer
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

-- Adicionando a imagem como tema de fundo da janela Fluent UI
local BackgroundImage = Instance.new("ImageLabel")
BackgroundImage.Name = "ReaperHubBackground"
BackgroundImage.Size = UDim2.new(1, 0, 1, 0) -- Preenche toda a janela
BackgroundImage.BackgroundTransparency = 1 -- Fundo transparente para ver a imagem
BackgroundImage.Image = "rbxassetid://" .. REAPER_IMAGE_ASSET_ID -- Sua imagem como fundo
BackgroundImage.ScaleType = Enum.ScaleType.Fit -- Ajusta a imagem sem distorcer
BackgroundImage.ZIndex = 0 -- Garante que fique atrás de outros elementos
BackgroundImage.Parent = Window.MainFrame:WaitForChild("Container") -- Coloca na parte principal da janela Fluent

-- Garantir que o texto do Fluent fique visível sobre a imagem
for _, child in ipairs(BackgroundImage.Parent:GetChildren()) do
    if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("Frame") then
        child.ZIndex = child.ZIndex + 1 -- Aumenta o ZIndex dos elementos existentes
    end
end
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

    InterfaceManager:BuildInterfaceSection(Tabs.Settings)
    SaveManager:BuildConfigSection(Tabs.Settings)
end
-- [FIM] --- CONTEÚDO DA ABA 'CONFIGURAÇÕES' ---


-- [INÍCIO] --- FUNCIONALIDADE DE MINIMIZAR PARA ÍCONE FLUTUANTE ---
-- Evento de clique para reabrir a janela
MinimizedBox.MouseButton1Click:Connect(function()
    Window:Show() -- Reabre a janela Fluent
    MinimizedBox.Visible = false -- Esconde o ícone flutuante
end)

-- Sobrescrevendo a função de minimizar padrão da Fluent
Window:OnMinimize(function()
    MinimizedBox.Visible = true -- Torna o ícone flutuante visível
    -- Opcional: Se o ReaperVisualHub (o frame cinza) também precisar sumir ao minimizar
    -- SeuHub.Visible = false
end)

-- Certificar que o ícone é escondido quando a janela está visível (ex: ao carregar ou reabrir)
Window:OnShow(function()
    MinimizedBox.Visible = false
    -- Opcional: Se o ReaperVisualHub (o frame cinza) precisar reaparecer ao reabrir
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
