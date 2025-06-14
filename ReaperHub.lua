--!strict
-- Nome do seu Script/Hub: ReaperHub
-- Versão: 1.9.4 (Corrigindo HTTP 404 - Fluent URL Original com Cache Buster Reforçado)

-- [INÍCIO] --- CARREGAMENTO DA BIBLIOTECA FLUENT (NÃO REMOVA) ---
local timestamp_fluent = os.time() -- timestamp para forçar cache buster na Fluent
-- Voltando para a URL de releases, mas com o timestamp aplicado
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua?v=" .. timestamp_fluent))()
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

-- [INÍCIO] --- CRIAÇÃO DO ÍCONE FLUTUANTE DE MINIMIZAR (Imagem Arrastável) ---
local MinimizedBox = Instance.new("ImageButton")
MinimizedBox.Name = "ReaperMinimizedIcon"
MinimizedBox.Size = UDim2.new(0, 50, 0, 50)
MinimizedBox.Position = UDim2.new(0.01, 0, 0.5, 0) -- Posição inicial (canto esquerdo-meio)
MinimizedBox.BackgroundTransparency = 1 -- Fundo transparente para mostrar apenas a imagem
MinimizedBox.Image = "rbxassetid://105362230092644" -- SEU ASSET ID AGORA ESTÁ AQUI!
MinimizedBox.ImageTransparency = 0 -- Imagem totalmente visível
MinimizedBox.Visible = false
MinimizedBox.Parent = game.Players.LocalPlayer.PlayerGui

-- Propriedades visuais do ícone (mantidas para consistência, mas podem ser ajustadas para a imagem)
local UICornerMinimize = Instance.new("UICorner")
UICornerMinimize.CornerRadius = UDim.new(0.5, 0)
UICornerMinimize.Parent = MinimizedBox

local UIStrokeMinimize = Instance.new("UIStroke")
UIStrokeMinimize.Color = Color3.fromRGB(0, 120, 212)
UIStrokeMinimize.Thickness = 2
UIStrokeMinimize.Parent = MinimizedBox

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
        input.Handled = true -- Impede que cliques passem para outros elementos
    end
end)

MinimizedBox.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if dragging then
            local delta = input.Position - dragStart
            local newX = initialPosition.X.Offset + delta.X
            local newY = initialPosition.Y.Offset + delta.Y

            -- Limitar o ícone dentro da tela
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
    end
end)

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


-- [INÍCIO] --- CONTEÚDO DA ABA 'CONFIGURAÇÕES' (AGORA VAZIA) ---
do
    -- Todo o conteúdo anterior da aba 'Configurações' foi removido aqui.
    -- Se quiser adicionar algo no futuro, pode fazer aqui.
end
-- [FIM] --- CONTEÚDO DA ABA 'CONFIGURAÇÕES' ---


-- [INÍCIO] --- FUNCIONALIDADE DE MINIMIZAR PARA ÍCONE FLUTUANTE ---
-- Evento de clique para reabrir a janela
MinimizedBox.MouseButton1Click:Connect(function()
    -- Certifica-se de que não estamos arrastando quando o clique é liberado
    if not dragging then
        Window:Show() -- Reabre a janela Fluent
        MinimizedBox.Visible = false -- Esconde o ícone flutuante
    end
end)

-- Sobrescrevendo a função de minimizar padrão da Fluent
Window:OnMinimize(function()
    MinimizedBox.Visible = true -- Torna o ícone flutuante visível
    -- SeuHub.Visible = false
end)

-- Certificar que o ícone é escondido quando a janela está visível (ex: ao carregar ou reabrir)
Window:OnShow(function()
    MinimizedBox.Visible = false
    -- SeuHub.Visible = true
end)
-- [FIM] --- FUNCIONALIDADE DE MINIMIZAR PARA ÍCONE FLUTUANTE ---


-- [INÍCIO] --- CONFIGURAÇÃO E INTEGRAÇÃO DE ADD-ONS ---
-- As chamadas BuildInterfaceSection e BuildConfigSection para a aba Settings foram removidas daqui.
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
