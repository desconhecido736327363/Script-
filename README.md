local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Reaper", -- Título da janela alterado para "Reaper"
    SubTitle = "",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Scripts = Window:AddTab({ Title = "scripts", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

-- Conteúdo da aba 'scripts'
do
    Tabs.Scripts:AddParagraph({
        Title = "scripts",
        Content = ""
    })

    -- Elemento "???" com subtítulo "scripts aqui"
    Tabs.Scripts:AddParagraph({
        Title = "???", -- Texto alterado para "???"
        Content = "scripts aqui"
    })

    -- Botão "infinite jump"
    Tabs.Scripts:AddButton({
        Title = "infinite jump",
        Callback = function()
            print("Botão 'infinite jump' clicado!")
            Fluent:Notify({
                Title = "Infinite Jump",
                Content = "A funcionalidade Infinite Jump foi ativada/desativada!",
                Duration = 3
            })
        end
    })

end


-- Addons:
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})

InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)


Window:SelectTab(Tabs.Scripts)

Fluent:Notify({
    Title = "Fluent",
    Content = "The script has been loaded.",
    Duration = 8
})

SaveManager:LoadAutoloadConfig()
# Script-
