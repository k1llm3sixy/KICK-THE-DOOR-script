local windUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local player = game:GetService("Players").LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local pg = player:WaitForChild("PlayerGui")

local stuff = {
    remotes = {
        ["Escape"] = rs.Packages._Index["sleitnick_knit@1.5.1"].knit.Services.EscapeService.RF:FindFirstChild("Escape"),
        ["KickDoor"] = {},
        ["SkipIntro"] = rs:FindFirstChild("Remotes"):FindFirstChild("SkipIntro")
    },
    map = {
        ["ExitHighlight"] = workspace:FindFirstChild("Exit"):FindFirstChild("Highlight"),
        ["EscapeDoor"] = workspace:FindFirstChild("MainDoor"):FindFirstChild("Main"),
        ["HideSpots"] = workspace:FindFirstChild("Hide"),
        ["HidePrompts"] = {}
    },
    gui = {
        ["KickText"] = pg:FindFirstChild("Main"):FindFirstChild("Kick"),
        ["SkipIntroBtn"] = pg:FindFirstChild("Main"):FindFirstChild("SkipIntro")
    },
    cfg = {
        autoEscape = false,
        autoSkip = false,
        autoKick = false
    }
}

local window = windUI:CreateWindow({
    Title = "🚪KICK THE DOOR [⚡] script",
    Icon = "cat",
    Author = "by k1llm3sixy",
    Folder = "tli",
})

window:OnDestroy(function()
    stuff.cfg.autoEscape = false
    stuff.cfg.autoSkip = false
    stuff.cfg.autoKick = false
end)

window:EditOpenButton({
    Title = "Open",
    Icon = "chevrons-left-right-ellipsis",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 2,
    Color = ColorSequence.new(
        Color3.fromHex("FF0F7B"),
        Color3.fromHex("F89B29")
    ),
    OnlyMobile = false,
    Enabled = true,
    Draggable = true,
})

function addToggle(tab, title, desc, def, cb)
    tab:Toggle({
        Title = title,
        Desc = desc,
        Icon = "check",
        Default = def,
        Callback = cb
    })
end

local mainTab = window:Tab({ Title = "Main" })

addToggle(mainTab, "Auto kick door", nil, false, function(state)
    stuff.cfg.autoKick = state
    kickDoor()
end)
addToggle(mainTab, "Auto skip intro", nil, false, function(state)
    stuff.cfg.autoSkip = state
    skipIntro()
end)
addToggle(mainTab, "Auto escape", nil, false, function(state)
    stuff.cfg.autoEscape = state
    escape()
end)

function kickDoor()
    local tool = player.Backpack:FindFirstChild("Kick") or player.Character:FindFirstChild("Kick")
    stuff.remotes.KickDoor = tool and tool:FindFirstChild("Hitbox")

    if stuff.gui.KickText.Text ~= "KICKS: 40/40" and stuff.cfg.autoKick then
        task.wait(2.1)
        stuff.remotes.KickDoor:FireServer(stuff.map.EscapeDoor)
    end
end

function escape()
    if stuff.map.ExitHighlight.Enabled and stuff.cfg.autoEscape then
        stuff.remotes.Escape:InvokeServer("Exit")
    end
end

function skipIntro()
    if stuff.gui.SkipIntroBtn.Visible and stuff.cfg.autoSkip then
        stuff.remotes.SkipIntro:FireServer()
    end
end

function fastHide()
    for _, spot in pairs(stuff.map.HideSpots:GetChildren()) do
        local prompt = spot:FindFirstChild("Prompt")
        if prompt then
            prompt.HoldDuration = 0
            prompt:GetPropertyChangedSignal("HoldDuration"):Connect(function()
                prompt.HoldDuration = 0
            end)
        end
    end
end

task.spawn(fastHide)

stuff.map.ExitHighlight:GetPropertyChangedSignal("Enabled"):Connect(escape)
stuff.gui.KickText:GetPropertyChangedSignal("Text"):Connect(kickDoor)
stuff.gui.SkipIntroBtn:GetPropertyChangedSignal("Visible"):Connect(skipIntro)
