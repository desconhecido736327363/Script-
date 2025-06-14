--!strict
-- Nome do seu Script/Hub: ReaperHub
-- Versão: 1.0 (ou a que você preferir)

-- [INÍCIO] --- CARREGAMENTO DA BIBLIOTECA FLUENT (NÃO REMOVA) ---
-- Esta linha baixa e carrega a biblioteca Fluent de seu repositório oficial.
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
-- [FIM] --- CARREGAMENTO DA BIBLIOTECA FLUENT ---

-- [INÍCIO] --- CONFIGURAÇÃO DA JANELA PRINCIPAL ---
local Window = Fluent:CreateWindow({
    Title = "Reaper", -- Título da janela
    SubTitle = "", -- Sem subtítulo para um visual mais limpo
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460), -- Tamanho da janela
    Acrylic = true, -- Efeito de desfoque
    Theme = "Dark", -- Tema escuro
    MinimizeKey = Enum.KeyCode.LeftControl -- Exemplo de tecla para minimizar (pode ser ajustado)
})
-- [FIM] --- CONFIGURAÇÃO DA JANELA PRINCIPAL ---

-- [INÍCIO] --- CRIAÇÃO DAS ABAS ---
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "" }), -- Aba "Main"
    Settings = Window:AddTab({ Title = "Configurações", Icon = "" }) -- Aba "Configurações"
}
-- [FIM] --- CRIAÇÃO DAS ABAS ---

local Options = Fluent.Options -- Acesso às opções do Fluent, que podem ser salvas

-- [INÍCIO] --- CONTEÚDO DA ABA 'MAIN' ---
do
    -- Por enquanto, esta aba está vazia.
    -- Você pode adicionar seus scripts ou funcionalidades principais aqui no futuro.
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
        Default = Color3.fromRGB(96, 205, 255), -- Cor padrão (azul claro)
        Callback = function(Value)
            -- Lógica para aplicar a cor ao seu hub aqui
            print("Cor do Hub alterada para:", Value)
        end
    })

    HubColorpicker:OnChanged(function()
        print("Cor do Hub atualizada para:", HubColorpicker.Value)
    end)

    -- Seletor de cor com transparência para o hub
    local HubTransparencyColorpicker = Tabs.Settings:AddColorpicker("HubTransparency", {
        Title = "Transparência do Hub",
        Description = "Ajuste a transparência geral do Hub.",
        Transparency = 0, -- Transparência padrão (0 = totalmente visível)
        Default = Color3.fromRGB(96, 205, 255), -- A cor base pode ser a mesma ou diferente
        Callback = function(Value, Transparency)
            -- Lógica para aplicar a transparência ao seu hub aqui
            print("Transparência do Hub alterada para:", Transparency)
        end
    })

    HubTransparencyColorpicker:OnChanged(function()
        print(
            "Transparência do Hub atualizada para:", HubTransparencyColorpicker.Value,
            "Transparência:", HubTransparencyColorpicker.Transparency
        )
    end)

    -- Adicionar as seções de Interface e Configurações dos Add-ons aqui
    -- Isso permitirá que o usuário salve/carregue configurações e gerencie a interface
    InterfaceManager:BuildInterfaceSection(Tabs.Settings)
    SaveManager:BuildConfigSection(Tabs.Settings)
end
-- [FIM] --- CONTEÚDO DA ABA 'CONFIGURAÇÕES' ---


-- [INÍCIO] --- CONFIGURAÇÃO E INTEGRAÇÃO DE ADD-ONS ---
-- Conecta os gerenciadores à instância da biblioteca Fluent
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

-- Ignora as configurações de tema para que o SaveManager não as salve
SaveManager:IgnoreThemeSettings()

-- Define as pastas para salvar as configurações no sistema de arquivos do Roblox
InterfaceManager:SetFolder("ReaperHubSettings")
SaveManager:SetFolder("ReaperHubSettings/ConfiguracoesReaper")
-- [FIM] --- CONFIGURAÇÃO E INTEGRAÇÃO DE ADD-ONS ---


-- [INÍCIO] --- CONFIGURAÇÕES FINAIS E NOTIFICAÇÃO ---
-- Seleciona a aba "Main" ao iniciar a interface
Window:SelectTab(Tabs.Main)

-- Notificação de ativação do Hub
Fluent:Notify({
    Title = "Reaper Ativo",
    Content = "O Hub Reaper foi carregado com sucesso!",
    Duration = 5 -- Notificação some após 5 segundos
})

-- Carrega a configuração automática, se houver, ao iniciar o script
SaveManager:LoadAutoloadConfig()
-- [FIM] --- CONFIGURAÇÕES FINAIS E NOTIFICAÇÃO ---
