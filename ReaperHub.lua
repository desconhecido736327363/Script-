--!strict
-- Nome do seu Script/Hub: ReaperHub
-- Versão: 3.0 (Migração para DarkLua/VynixUI)

-- [INÍCIO] --- CARREGAMENTO DA BIBLIOTECA DARKLUAI (NÃO REMOVA) ---
local VynixUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Vynixx/VynixUI/main/Source.lua"))()

-- Debugging: Verificar se VynixUI carregou corretamente
print("--- ReaperHub v3.0: Carregamento VynixUI verificado ---") -- Marcador de versão 3.0
if not VynixUI or type(VynixUI.Create) ~= "function" then
    warn("VynixUI library failed to load or is incomplete. UI may not function as expected.")
    warn("Erro: A biblioteca VynixUI n\227o carregou corretamente. Fun\231\245es de UI podem estar ausentes.")
    return -- Interrompe o script se a VynixUI não carregar
end
print("VynixUI carregado com sucesso.")
-- [FIM] --- CARREGAMENTO DA BIBLIOTECA DARKLUAI ---

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
-- === CONFIGURAÇÃO DA JANELA PRINCIPAL DARKLUAI (NOVA UI) ===
-- ====================================================================================================

-- [INÍCIO] --- CRIAÇÃO DA JANELA PRINCIPAL DARKLUAI ---
local Window = VynixUI:Create("Reaper Hub", {
    Theme = "Dark", -- Ou "Light"
    WindowSize = UDim2.new(0, 580, 0, 460) -- Tamanho da janela
})
print("Janela DarkLua (Window) criada.")
-- [FIM] --- CRIAÇÃO DA JANELA PRINCIPAL DARKLUAI ---

-- [INÍCIO] --- CRIAÇÃO DAS ABAS DARKLUAI ---
local Tabs = {
    Main = Window:Tab("Main"),
    Settings = Window:Tab("Configurações")
}
print("Abas Main e Configurações criadas (DarkLua).")
-- [FIM] --- CRIAÇÃO DAS ABAS DARKLUAI ---

-- [INÍCIO] --- CONTEÚDO DA ABA 'MAIN' DARKLUAI ---
do
    -- Adicionando o texto fixo "Criado: ReaperHub"
    -- DarkLua usa TextLabel ou Label para isso
    Tabs.Main:Label("Criado: ReaperHub")
    print("Texto 'Criado: ReaperHub' adicionado à aba Main (DarkLua).")
end
-- [FIM] --- CONTEÚDO DA ABA 'MAIN' DARKLUAI ---

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
        Window:Hide() -- Esconde a janela VynixUI
        print("Window.Visible após Hide():", Window.Visible)
        MinimizedBox.Visible = true -- Torna o ícone flutuante visível
        print("MinimizedBox.Visible após tornar visível:", MinimizedBox.Visible)
        SeuHub.Visible = false -- Esconde o Hub visual de teste
        print("SeuHub.Visible após esconder:", SeuHub.Visible)
        isUIVisible = false
        print("toggleUI: UI minimizada. MinimizedBox.Visible final =", MinimizedBox.Visible)
    else
        print("toggleUI: Restaurando...")
        Window:Show() -- Reabre a janela VynixUI
        print("Window.Visible após Show():", Window.Visible)
        MinimizedBox.Visible = false -- Esconde o ícone flutuante
        print("MinimizedBox.Visible após esconder:", MinimizedBox.Visible)
        SeuHub.Visible = true -- Torna o Hub visual de teste visível
        print("SeuHub.Visible após tornar visível:", SeuHub.Visible)
        isUIVisible = true
        print("toggleUI: UI restaurada. MinimizedBox.Visible final =", MinimizedBox.Box.Visible) -- Correção aqui (MinimizedBox.Visible)
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

-- DarkLua não tem SaveManager e InterfaceManager próprios como a Fluent.
-- Você precisaria implementar o salvamento de configurações manualmente
-- se houver sliders, checkboxes, etc., ou usar um SaveManager genérico se quiser persistência.
-- Por enquanto, estou removendo as linhas de SaveManager/InterfaceManager que eram da Fluent.
-- Se precisar de salvamento, me diga e podemos adicionar um sistema básico.

-- [INÍCIO] --- CONFIGURAÇÕES FINAIS E NOTIFICAÇÃO ---
-- DarkLua não tem uma função nativa para "selecionar aba" ao iniciar.
-- A primeira aba criada é geralmente a ativa por padrão.

-- Notificação (DarkLua pode ter um sistema diferente ou nenhum nativo)
-- Não há um VynixUI:Notify direto. Se precisar de notificações, teríamos que criar.
print("Notifica\231\227o de carregamento 'Reaper Ativo' (VynixUI) - A notifica\231\227o visual n\227o \233 nativa para VynixUI.")
-- [FIM] --- CONFIGURAÇÕES FINAIS E NOTIFICAÇÃO ---
