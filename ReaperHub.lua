--!strict
-- Nome do seu Script/Hub: ReaperHub
-- Versão: 1.1 (Atualização para cor, transparência e minimização)

-- [INÍCIO] --- CARREGAMENTO DA BIBLIOTECA FLUENT (NÃO REMOVA) ---
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
-- [FIM] --- CARREGAMENTO DA BIBLIOTECA FLUENT ---

-- [INÍCIO] --- REFERÊNCIA AO SEU HUB (MUITO IMPORTANTE!) ---
-- VOCÊ PRECISA DEFINIR AQUI A REFERÊNCIA AO SEU OBJETO DO HUB NO JOGO.
-- EXEMPLO:
local SeuHub = game.Players.LocalPlayer.PlayerGui:WaitForChild("SeuHubFrame") -- Substitua "SeuHubFrame" pelo nome real do seu Frame/ScreenGui/etc.
-- OU, se for algo criado pelo script:
-- local SeuHub = Instance.new("Frame")
-- SeuHub.Name = "MeuHubVisual"
-- SeuHub.Parent = game.Players.LocalPlayer.PlayerGui
-- SeuHub.Size = UDim2.new(0.3, 0, 0.5, 0)
-- SeuHub.Position = UDim2.new(0.35, 0, 0.25, 0)
-- SeuHub.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
-- SeuHub.BorderSizePixel = 0
-- (Adicione o SeuHub que você já tem no seu jogo, ou um placeholder simples para teste)
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

    -- Seletor de cor para o hub
    local HubColorpicker = Tabs.Settings:AddColorpicker("HubColor", {
        Title = "Cor do Hub",
        Default = Color3.fromRGB(96, 205, 255),
        Callback = function(Value)
            -- APLICA A COR AO SEU HUB AQUI
            if SeuHub and SeuHub:IsA("GuiObject") then -- Verifica se SeuHub existe e é um objeto GUI
                SeuHub.BackgroundColor3 = Value
            end
            print("Cor do Hub alterada para:", Value)
        end
    })

    -- HubColorpicker:OnChanged(function() -- O Callback já faz a função, este OnChanged é redundante para o propósito.
    --     print("Cor do Hub atualizada para:", HubColorpicker.Value)
    -- end)

    -- SUBSTITUINDO O COLORPICKER DE TRANSPARÊNCIA POR UM SLIDER
    local HubTransparencySlider = Tabs.Settings:AddSlider("HubTransparency", {
        Title = "Transparência do Hub",
        Description = "Ajuste a transparência geral do Hub (100% visível a 10% visível).",
        Default = 1, -- Representa 100% de visibilidade (0 = totalmente transparente)
        Min = 0.1, -- 10% de visibilidade (0.1)
        Max = 1, -- 100% de visibilidade (1)
        Rounding = 2, -- Duas casas decimais
        Compact = false, -- Modo de exibição do slider
        Callback = function(Value)
            -- APLICA A TRANSPARÊNCIA AO SEU HUB AQUI
            if SeuHub and SeuHub:IsA("GuiObject") then
                SeuHub.BackgroundTransparency = 1 - Value -- Converte valor do slider (0.1 a 1) para transparência (0.9 a 0)
            end
            print("Transparência do Hub alterada para:", Value * 100 .. "% visível")
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
MinimizedBox.BackgroundColor3 = Color3.fromRGB(96, 205, 255) -- Cor do ícone
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
