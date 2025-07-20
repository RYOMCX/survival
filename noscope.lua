local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NoScopeArcadeHackGUI"
ScreenGui.Parent = PlayerGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0.3, 0, 0.6, 0)
MainFrame.Position = UDim2.new(0.35, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0.1, 0)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, 0, 1, 0)
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 18
TitleLabel.Text = "No Scope Arcade Cheats"
TitleLabel.Parent = TitleBar

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0.1, 0, 0.8, 0)
MinimizeButton.Position = UDim2.new(0.76, 0, 0.1, 0)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(50, 150, 200)
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.Font = Enum.Font.SourceSansBold
MinimizeButton.TextSize = 14
MinimizeButton.Text = "-"
MinimizeButton.Parent = TitleBar

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0.1, 0, 0.8, 0)
CloseButton.Position = UDim2.new(0.88, 0, 0.1, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 14
CloseButton.Text = "X"
CloseButton.Parent = TitleBar

local TabBar = Instance.new("Frame")
TabBar.Name = "TabBar"
TabBar.Size = UDim2.new(1, 0, 0.08, 0)
TabBar.Position = UDim2.new(0, 0.0, 0.1, 0)
TabBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TabBar.BorderSizePixel = 0
TabBar.Parent = MainFrame

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.FillDirection = Enum.FillDirection.Horizontal
TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
TabListLayout.Padding = UDim.new(0, 5)
TabListLayout.Parent = TabBar

local AimbotTabButton = Instance.new("TextButton")
AimbotTabButton.Name = "AimbotTab"
AimbotTabButton.Size = UDim2.new(0.3, 0, 0.8, 0)
AimbotTabButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
AimbotTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AimbotTabButton.Font = Enum.Font.SourceSansSemibold
AimbotTabButton.TextSize = 14
AimbotTabButton.Text = "Aimbot"
AimbotTabButton.Parent = TabBar

local ESPTabButton = Instance.new("TextButton")
ESPTabButton.Name = "ESPTab"
ESPTabButton.Size = UDim2.new(0.3, 0, 0.8, 0)
ESPTabButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
ESPTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPTabButton.Font = Enum.Font.SourceSansSemibold
ESPTabButton.TextSize = 14
ESPTabButton.Text = "ESP"
ESPTabButton.Parent = TabBar

local VisualsTabButton = Instance.new("TextButton")
VisualsTabButton.Name = "VisualsTab"
VisualsTabButton.Size = UDim2.new(0.3, 0, 0.8, 0)
VisualsTabButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
VisualsTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
VisualsTabButton.Font = Enum.Font.SourceSansSemibold
VisualsTabButton.TextSize = 14
VisualsTabButton.Text = "Visuals"
VisualsTabButton.Parent = TabBar

local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, 0, 0.82, 0)
ContentFrame.Position = UDim2.new(0, 0, 0.18, 0)
ContentFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ContentFrame.BorderSizePixel = 0
ContentFrame.ClipsDescendants = true
ContentFrame.Parent = MainFrame

local PageContainer = Instance.new("Frame")
PageContainer.Name = "PageContainer"
PageContainer.Size = UDim2.new(3, 0, 1, 0)
PageContainer.Position = UDim2.new(0, 0, 0, 0)
PageContainer.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
PageContainer.BackgroundTransparency = 1
PageContainer.Parent = ContentFrame

-- Aimbot Page
local AimbotPage = Instance.new("ScrollingFrame")
AimbotPage.Name = "AimbotPage"
AimbotPage.Size = UDim2.new(0.333, 0, 1, 0)
AimbotPage.Position = UDim2.new(0, 0, 0, 0)
AimbotPage.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
AimbotPage.BorderSizePixel = 0
AimbotPage.CanvasSize = UDim2.new(0, 0, 1.5, 0)
AimbotPage.ScrollBarThickness = 6
AimbotPage.Parent = PageContainer

local AimbotLayout = Instance.new("UIListLayout")
AimbotLayout.Padding = UDim.new(0, 5)
AimbotLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
AimbotLayout.Parent = AimbotPage

local AimbotToggle = Instance.new("TextButton")
AimbotToggle.Name = "AimbotToggle"
AimbotToggle.Size = UDim2.new(0.9, 0, 0.08, 0)
AimbotToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
AimbotToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
AimbotToggle.Font = Enum.Font.SourceSansSemibold
AimbotToggle.TextSize = 16
AimbotToggle.Text = "Aimbot: OFF"
AimbotToggle.Parent = AimbotPage

local SilentAimToggle = Instance.new("TextButton")
SilentAimToggle.Name = "SilentAimToggle"
SilentAimToggle.Size = UDim2.new(0.9, 0, 0.08, 0)
SilentAimToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
SilentAimToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
SilentAimToggle.Font = Enum.Font.SourceSansSemibold
SilentAimToggle.TextSize = 16
SilentAimToggle.Text = "Silent Aim: OFF"
SilentAimToggle.Parent = AimbotPage

local MagicBulletToggle = Instance.new("TextButton")
MagicBulletToggle.Name = "MagicBulletToggle"
MagicBulletToggle.Size = UDim2.new(0.9, 0, 0.08, 0)
MagicBulletToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
MagicBulletToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
MagicBulletToggle.Font = Enum.Font.SourceSansSemibold
MagicBulletToggle.TextSize = 16
MagicBulletToggle.Text = "Magic Bullet: OFF"
MagicBulletToggle.Parent = AimbotPage

local AutoTriggerAimToggle = Instance.new("TextButton")
AutoTriggerAimToggle.Name = "AutoTriggerAimToggle"
AutoTriggerAimToggle.Size = UDim2.new(0.9, 0, 0.08, 0)
AutoTriggerAimToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
AutoTriggerAimToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoTriggerAimToggle.Font = Enum.Font.SourceSansSemibold
AutoTriggerAimToggle.TextSize = 16
AutoTriggerAimToggle.Text = "Auto Trigger Aim: OFF"
AutoTriggerAimToggle.Parent = AimbotPage

local AimPartDropdownLabel = Instance.new("TextLabel")
AimPartDropdownLabel.Name = "AimPartDropdownLabel"
AimPartDropdownLabel.Size = UDim2.new(0.9, 0, 0.08, 0)
AimPartDropdownLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
AimPartDropdownLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
AimPartDropdownLabel.Font = Enum.Font.SourceSansSemibold
AimPartDropdownLabel.TextSize = 14
AimPartDropdownLabel.Text = "Aim Part: Head"
AimPartDropdownLabel.Parent = AimbotPage

local AimPartDropdown = Instance.new("Frame")
AimPartDropdown.Name = "AimPartDropdown"
AimPartDropdown.Size = UDim2.new(0.9, 0, 0.01, 0)
AimPartDropdown.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
AimPartDropdown.BorderSizePixel = 0
AimPartDropdown.ClipsDescendants = true
AimPartDropdown.Visible = false
AimPartDropdown.Parent = AimbotPage

local AimPartListLayout = Instance.new("UIListLayout")
AimPartListLayout.Padding = UDim.new(0, 2)
AimPartListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
AimPartListLayout.Parent = AimPartDropdown

local AimParts = {"Head", "HumanoidRootPart", "Torso"}
for _, partName in ipairs(AimParts) do
    local PartButton = Instance.new("TextButton")
    PartButton.Name = partName
    PartButton.Size = UDim2.new(1, 0, 0.15, 0)
    PartButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    PartButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    PartButton.Font = Enum.Font.SourceSansSemibold
    PartButton.TextSize = 14
    PartButton.Text = partName
    PartButton.Parent = AimPartDropdown
    PartButton.MouseButton1Click:Connect(function()
        AimPartDropdownLabel.Text = "Aim Part: " .. partName
        AimPartDropdown.Visible = false
        AimPartDropdown.Size = UDim2.new(0.9, 0, 0.01, 0)
        _G.AimPart = partName
    end)
end

AimPartDropdownLabel.MouseButton1Click:Connect(function()
    AimPartDropdown.Visible = not AimPartDropdown.Visible
    if AimPartDropdown.Visible then
        AimPartDropdown.Size = UDim2.new(0.9, 0, 0.15 * #AimParts, 0)
    else
        AimPartDropdown.Size = UDim2.new(0.9, 0, 0.01, 0)
    end
end)

-- ESP Page
local ESPPage = Instance.new("ScrollingFrame")
ESPPage.Name = "ESPPage"
ESPPage.Size = UDim2.new(0.333, 0, 1, 0)
ESPPage.Position = UDim2.new(0.333, 0, 0, 0)
ESPPage.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ESPPage.BorderSizePixel = 0
ESPPage.CanvasSize = UDim2.new(0, 0, 1.5, 0)
ESPPage.ScrollBarThickness = 6
ESPPage.Visible = false
ESPPage.Parent = PageContainer

local ESPLayout = Instance.new("UIListLayout")
ESPLayout.Padding = UDim.new(0, 5)
ESPLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ESPLayout.Parent = ESPPage

local ESPBoxToggle = Instance.new("TextButton")
ESPBoxToggle.Name = "ESPBoxToggle"
ESPBoxToggle.Size = UDim2.new(0.9, 0, 0.08, 0)
ESPBoxToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
ESPBoxToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPBoxToggle.Font = Enum.Font.SourceSansSemibold
ESPBoxToggle.TextSize = 16
ESPBoxToggle.Text = "ESP Box: OFF"
ESPBoxToggle.Parent = ESPPage

local ESPLineToggle = Instance.new("TextButton")
ESPLineToggle.Name = "ESPLineToggle"
ESPLineToggle.Size = UDim2.new(0.9, 0, 0.08, 0)
ESPLineToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
ESPLineToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPLineToggle.Font = Enum.Font.SourceSansSemibold
ESPLineToggle.TextSize = 16
ESPLineToggle.Text = "ESP Line: OFF"
ESPLineToggle.Parent = ESPPage

local ESPPlayerBotToggle = Instance.new("TextButton")
ESPPlayerBotToggle.Name = "ESPPlayerBotToggle"
ESPPlayerBotToggle.Size = UDim2.new(0.9, 0, 0.08, 0)
ESPPlayerBotToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
ESPPlayerBotToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPPlayerBotToggle.Font = Enum.Font.SourceSansSemibold
ESPPlayerBotToggle.TextSize = 16
ESPPlayerBotToggle.Text = "ESP Player/Bot: OFF"
ESPPlayerBotToggle.Parent = ESPPage

local ESPNameToggle = Instance.new("TextButton")
ESPNameToggle.Name = "ESPNameToggle"
ESPNameToggle.Size = UDim2.new(0.9, 0, 0.08, 0)
ESPNameToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
ESPNameToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPNameToggle.Font = Enum.Font.SourceSansSemibold
ESPNameToggle.TextSize = 16
ESPNameToggle.Text = "ESP Name: OFF"
ESPNameToggle.Parent = ESPPage

local ESPSkeletonToggle = Instance.new("TextButton")
ESPSkeletonToggle.Name = "ESPSkeletonToggle"
ESPSkeletonToggle.Size = UDim2.new(0.9, 0, 0.08, 0)
ESPSkeletonToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
ESPSkeletonToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPSkeletonToggle.Font = Enum.Font.SourceSansSemibold
ESPSkeletonToggle.TextSize = 16
ESPSkeletonToggle.Text = "ESP Skeleton: OFF"
ESPSkeletonToggle.Parent = ESPPage

local ESP360Toggle = Instance.new("TextButton")
ESP360Toggle.Name = "ESP360Toggle"
ESP360Toggle.Size = UDim2.new(0.9, 0, 0.08, 0)
ESP360Toggle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
ESP360Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
ESP360Toggle.Font = Enum.Font.SourceSansSemibold
ESP360Toggle.TextSize = 16
ESP360Toggle.Text = "ESP 360°: OFF"
ESP360Toggle.Parent = ESPPage

-- Visuals Page
local VisualsPage = Instance.new("ScrollingFrame")
VisualsPage.Name = "VisualsPage"
VisualsPage.Size = UDim2.new(0.333, 0, 1, 0)
VisualsPage.Position = UDim2.new(0.666, 0, 0, 0)
VisualsPage.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
VisualsPage.BorderSizePixel = 0
VisualsPage.CanvasSize = UDim2.new(0, 0, 1.5, 0)
VisualsPage.ScrollBarThickness = 6
VisualsPage.Visible = false
VisualsPage.Parent = PageContainer

local VisualsLayout = Instance.new("UIListLayout")
VisualsLayout.Padding = UDim.new(0, 5)
VisualsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
VisualsLayout.Parent = VisualsPage

local ChamsToggle = Instance.new("TextButton")
ChamsToggle.Name = "ChamsToggle"
ChamsToggle.Size = UDim2.new(0.9, 0, 0.08, 0)
ChamsToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
ChamsToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
ChamsToggle.Font = Enum.Font.SourceSansSemibold
ChamsToggle.TextSize = 16
ChamsToggle.Text = "Chams: OFF"
ChamsToggle.Parent = VisualsPage

local ChamsColorPicker = Instance.new("Frame")
ChamsColorPicker.Name = "ChamsColorPicker"
ChamsColorPicker.Size = UDim2.new(0.9, 0, 0.15, 0)
ChamsColorPicker.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ChamsColorPicker.Parent = VisualsPage
ChamsColorPicker.Visible = false

local ColorPickerLabel = Instance.new("TextLabel")
ColorPickerLabel.Size = UDim2.new(1, 0, 0.3, 0)
ColorPickerLabel.Text = "Chams Color"
ColorPickerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ColorPickerLabel.BackgroundTransparency = 1
ColorPickerLabel.Font = Enum.Font.SourceSansSemibold
ColorPickerLabel.TextSize = 14
ColorPickerLabel.Parent = ChamsColorPicker

local ColorButtonRed = Instance.new("TextButton")
ColorButtonRed.Size = UDim2.new(0.3, 0, 0.5, 0)
ColorButtonRed.Position = UDim2.new(0.05, 0, 0.4, 0)
ColorButtonRed.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
ColorButtonRed.Parent = ChamsColorPicker
ColorButtonRed.MouseButton1Click:Connect(function()
    _G.ChamsColor = Color3.fromRGB(255, 0, 0)
end)

local ColorButtonGreen = Instance.new("TextButton")
ColorButtonGreen.Size = UDim2.new(0.3, 0, 0.5, 0)
ColorButtonGreen.Position = UDim2.new(0.35, 0, 0.4, 0)
ColorButtonGreen.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
ColorButtonGreen.Parent = ChamsColorPicker
ColorButtonGreen.MouseButton1Click:Connect(function()
    _G.ChamsColor = Color3.fromRGB(0, 255, 0)
end)

local ColorButtonBlue = Instance.new("TextButton")
ColorButtonBlue.Size = UDim2.new(0.3, 0, 0.5, 0)
ColorButtonBlue.Position = UDim2.new(0.65, 0, 0.4, 0)
ColorButtonBlue.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
ColorButtonBlue.Parent = ChamsColorPicker
ColorButtonBlue.MouseButton1Click:Connect(function()
    _G.ChamsColor = Color3.fromRGB(0, 0, 255)
end)

-- Global Variables for features
_G.Aimbot = false
_G.SilentAim = false
_G.MagicBullet = false
_G.AutoTriggerAim = false
_G.AimPart = "Head"

_G.ESPBox = false
_G.ESPLine = false
_G.ESPPlayerBot = false
_G.ESPName = false
_G.ESPSkeleton = false
_G.ESP360 = false

_G.Chams = false
_G.ChamsColor = Color3.fromRGB(255, 0, 0)

local CurrentPage = 1
local NumberOfPages = 3

local IsMinimized = false
local OriginalSize = MainFrame.Size
local MinimizedSize = UDim2.new(0.3, 0, 0.1, 0)

-- Functions to update button states
local function UpdateButtonState(button, setting)
    if _G[setting] then
        button.Text = string.gsub(button.Text, "OFF", "ON")
        button.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    else
        button.Text = string.gsub(button.Text, "ON", "OFF")
        button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    end
end

-- UI Logic
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

MinimizeButton.MouseButton1Click:Connect(function()
    IsMinimized = not IsMinimized
    if IsMinimized then
        MainFrame:TweenSize(MinimizedSize, "Out", "Quad", 0.3, true)
        ContentFrame.Visible = false
        TabBar.Visible = false
        MinimizeButton.Text = "+"
    else
        MainFrame:TweenSize(OriginalSize, "Out", "Quad", 0.3, true)
        ContentFrame.Visible = true
        TabBar.Visible = true
        MinimizeButton.Text = "-"
    end
end)

local function SetActiveTab(tabName)
    local tabs = {AimbotPage, ESPPage, VisualsPage}
    local tabButtons = {AimbotTabButton, ESPTabButton, VisualsTabButton}

    for i, tab in ipairs(tabs) do
        if tab.Name == tabName .. "Page" then
            tab.Visible = true
            tabButtons[i].BackgroundColor3 = Color3.fromRGB(90, 90, 90)
            CurrentPage = i
        else
            tab.Visible = false
            tabButtons[i].BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        end
    end
    PageContainer:TweenPosition(UDim2.new(-(CurrentPage - 1) * 0.333, 0, 0, 0), "Out", "Quad", 0.3, true)
end

AimbotTabButton.MouseButton1Click:Connect(function()
    SetActiveTab("Aimbot")
end)

ESPTabButton.MouseButton1Click:Connect(function()
    SetActiveTab("ESP")
end)

VisualsTabButton.MouseButton1Click:Connect(function()
    SetActiveTab("Visuals")
end)

AimbotToggle.MouseButton1Click:Connect(function()
    _G.Aimbot = not _G.Aimbot
    UpdateButtonState(AimbotToggle, "Aimbot")
end)

SilentAimToggle.MouseButton1Click:Connect(function()
    _G.SilentAim = not _G.SilentAim
    UpdateButtonState(SilentAimToggle, "SilentAim")
end)

MagicBulletToggle.MouseButton1Click:Connect(function()
    _G.MagicBullet = not _G.MagicBullet
    UpdateButtonState(MagicBulletToggle, "MagicBullet")
end)

AutoTriggerAimToggle.MouseButton1Click:Connect(function()
    _G.AutoTriggerAim = not _G.AutoTriggerAim
    UpdateButtonState(AutoTriggerAimToggle, "AutoTriggerAim")
end)

ESPBoxToggle.MouseButton1Click:Connect(function()
    _G.ESPBox = not _G.ESPBox
    UpdateButtonState(ESPBoxToggle, "ESPBox")
end)

ESPLineToggle.MouseButton1Click:Connect(function()
    _G.ESPLine = not _G.ESPLine
    UpdateButtonState(ESPLineToggle, "ESPLine")
end)

ESPPlayerBotToggle.MouseButton1Click:Connect(function()
    _G.ESPPlayerBot = not _G.ESPPlayerBot
    UpdateButtonState(ESPPlayerBotToggle, "ESPPlayerBot")
end)

ESPNameToggle.MouseButton1Click:Connect(function()
    _G.ESPName = not _G.ESPName
    UpdateButtonState(ESPNameToggle, "ESPName")
end)

ESPSkeletonToggle.MouseButton1Click:Connect(function()
    _G.ESPSkeleton = not _G.ESPSkeleton
    UpdateButtonState(ESPSkeletonToggle, "ESPSkeleton")
end)

ESP360Toggle.MouseButton1Click:Connect(function()
    _G.ESP360 = not _G.ESP360
    UpdateButtonState(ESP360Toggle, "ESP360")
end)

ChamsToggle.MouseButton1Click:Connect(function()
    _G.Chams = not _G.Chams
    UpdateButtonState(ChamsToggle, "Chams")
    ChamsColorPicker.Visible = _G.Chams
end)

-- Core Aimbot, ESP, Chams Logic
local function GetClosestTarget()
    local closestTarget = nil
    local shortestDistance = math.huge
    for i, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                local distance = (LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestTarget = player.Character
                end
            end
        end
    end
    -- Check for bots in No Scope Arcade if they are not Player type
    for i, child in ipairs(Workspace:GetChildren()) do
        if child:FindFirstChild("Humanoid") and child.Humanoid.Health > 0 and child.Name:find("Bot") then 
            local rootPart = child:FindFirstChild("HumanoidRootPart")
            if rootPart then
                local distance = (LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestTarget = child
                end
            end
        end
    end
    return closestTarget
end

local function GetAimPart(targetCharacter)
    if targetCharacter then
        if _G.AimPart == "Head" and targetCharacter:FindFirstChild("Head") then
            return targetCharacter.Head
        elseif _G.AimPart == "HumanoidRootPart" and targetCharacter:FindFirstChild("HumanoidRootPart") then
            return targetCharacter.HumanoidRootPart
        elseif _G.AimPart == "Torso" and targetCharacter:FindFirstChild("Torso") then
            return targetCharacter.Torso
        end
    end
    return nil
end

local function WorldToScreen(position)
    local cam = Workspace.CurrentCamera
    local vec, inViewport = cam:WorldToScreenPoint(position)
    return Vector2.new(vec.X, vec.Y), inViewport
end

local ChamsParts = {}
local ESPDrawings = {}

local function ClearESPDrawings()
    for _, drawing in pairs(ESPDrawings) do
        drawing:Remove()
    end
    ESPDrawings = {}
end

local function ApplyChams(character, color)
    if ChamsParts[character] then return end
    for _, part in ipairs(character:GetChildren()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" and part.Name ~= "Head" then
            local material = Instance.new("MaterialProperties")
            material.Color = color
            material.Transparency = 0.5
            part.Material = Enum.Material.ForceField
            part.Color = color
            ChamsParts[character] = ChamsParts[character] or {}
            table.insert(ChamsParts[character], part)
        elseif part:IsA("MeshPart") then
            local ov = Instance.new("OverlayTexture")
            ov.Color = color
            ov.Parent = part
            ChamsParts[character] = ChamsParts[character] or {}
            table.insert(ChamsParts[character], ov)
        end
    end
end

local function RemoveChams(character)
    if ChamsParts[character] then
        for _, partOrOverlay in ipairs(ChamsParts[character]) do
            if partOrOverlay:IsA("BasePart") then
                partOrOverlay.Material = Enum.Material.Plastic
                partOrOverlay.Color = Color3.fromRGB(105, 105, 105) -- Default Roblox color
            elseif partOrOverlay:IsA("OverlayTexture") then
                partOrOverlay:Destroy()
            end
        end
        ChamsParts[character] = nil
    end
end

RunService.RenderStepped:Connect(function()
    local target = GetClosestTarget()
    local localCharacter = LocalPlayer.Character

    if not localCharacter or not localCharacter:FindFirstChild("HumanoidRootPart") then return end

    -- Aimbot Logic
    if _G.Aimbot and target and LocalPlayer.Character.Humanoid.Health > 0 then
        local targetPart = GetAimPart(target)
        if targetPart then
            if not _G.SilentAim then
                local cam = Workspace.CurrentCamera
                cam.CFrame = CFrame.lookAt(cam.CFrame.Position, targetPart.Position)
            end
            -- Auto Trigger Aim (simulates firing when target is in sight)
            if _G.AutoTriggerAim and localCharacter:FindFirstChildOfClass("Tool") then
                local tool = localCharacter:FindFirstChildOfClass("Tool")
                if tool and tool:FindFirstChild("Handle") then
                    local raycastParams = RaycastParams.new()
                    raycastParams.FilterDescendantsInstances = {localCharacter}
                    raycastParams.FilterType = Enum.RaycastFilterType.Exclude

                    local ray = Workspace:Raycast(tool.Handle.Position, (targetPart.Position - tool.Handle.Position).unit * 500, raycastParams)

                    if ray and ray.Instance then
                        local hitPlayer = Players:GetPlayerFromCharacter(ray.Instance.Parent)
                        if hitPlayer and hitPlayer == Players:GetPlayerFromCharacter(target) then
                            tool:Activate()
                        end
                    end
                end
            end
        end
    end

    -- ESP Logic
    ClearESPDrawings()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local char = player.Character
            local root = char:FindFirstChild("HumanoidRootPart")
            local head = char:FindFirstChild("Head")
            if root and head then
                local screenPosRoot, inViewportRoot = WorldToScreen(root.Position)
                local screenPosHead, inViewportHead = WorldToScreen(head.Position)

                if inViewportRoot or inViewportHead then
                    local color = Color3.fromRGB(255, 255, 0) -- Default color for players

                    -- ESP Player/Bot
                    if _G.ESPPlayerBot then
                        local playerBotText = Instance.new("Drawing")
                        playerBotText.Visible = true
                        playerBotText.Color = Color3.fromRGB(0, 255, 255)
                        playerBotText.Outline = true
                        playerBotText.Text = "Player"
                        playerBotText.Font = 2
                        playerBotText.Size = 14
                        playerBotText.Position = Vector2.new(screenPosRoot.X - 20, screenPosRoot.Y + 20)
                        table.insert(ESPDrawings, playerBotText)
                    end

                    -- ESP Box
                    if _G.ESPBox then
                        local neckPos = char:FindFirstChild("Torso") and char.Torso.Position or head.Position
                        local footPos = root.Position - Vector3.new(0, root.Size.Y / 2, 0)
                        local headSizeY = head.Size.Y
                        local boxHeight = (neckPos.Y - footPos.Y) + headSizeY
                        local boxWidth = boxHeight / 2

                        local boxTopScreen, _ = WorldToScreen(neckPos + Vector3.new(0, headSizeY / 2, 0))
                        local boxBottomScreen, _ = WorldToScreen(footPos)

                        local boxHeightScreen = math.abs(boxTopScreen.Y - boxBottomScreen.Y)
                        local boxWidthScreen = boxHeightScreen / 2

                        local boxDrawing = Drawing.new("Square")
                        boxDrawing.Visible = true
                        boxDrawing.Color = color
                        boxDrawing.Thickness = 1
                        boxDrawing.Size = Vector2.new(boxWidthScreen, boxHeightScreen)
                        boxDrawing.Position = Vector2.new(screenPosRoot.X - boxWidthScreen / 2, screenPosHead.Y)
                        table.insert(ESPDrawings, boxDrawing)
                    end

                    -- ESP Line
                    if _G.ESPLine then
                        local lineDrawing = Drawing.new("Line")
                        lineDrawing.Visible = true
                        lineDrawing.Color = color
                        lineDrawing.Thickness = 1
                        lineDrawing.From = Vector2.new(Workspace.CurrentCamera.ViewportSize.X / 2, Workspace.CurrentCamera.ViewportSize.Y)
                        lineDrawing.To = screenPosRoot
                        table.insert(ESPDrawings, lineDrawing)
                    end

                    -- ESP Name
                    if _G.ESPName then
                        local nameText = Drawing.new("Text")
                        nameText.Visible = true
                        nameText.Color = Color3.fromRGB(255, 255, 255)
                        nameText.Outline = true
                        nameText.Text = player.Name
                        nameText.Font = 2
                        nameText.Size = 14
                        nameText.Position = Vector2.new(screenPosHead.X - (nameText.TextBounds.X / 2), screenPosHead.Y - 20)
                        table.insert(ESPDrawings, nameText)
                    end

                    -- ESP Skeleton
                    if _G.ESPSkeleton then
                        local function DrawBone(part1, part2)
                            if part1 and part2 then
                                local p1, in1 = WorldToScreen(part1.Position)
                                local p2, in2 = WorldToScreen(part2.Position)
                                if in1 and in2 then
                                    local boneLine = Drawing.new("Line")
                                    boneLine.Visible = true
                                    boneLine.Color = Color3.fromRGB(0, 255, 0)
                                    boneLine.Thickness = 1
                                    boneLine.From = p1
                                    boneLine.To = p2
                                    table.insert(ESPDrawings, boneLine)
                                end
                            end
                        end

                        DrawBone(char:FindFirstChild("Head"), char:FindFirstChild("Torso"))
                        DrawBone(char:FindFirstChild("Torso"), char:FindFirstChild("Left Arm"))
                        DrawBone(char:FindFirstChild("Torso"), char:FindFirstChild("Right Arm"))
                        DrawBone(char:FindFirstChild("Torso"), char:FindFirstChild("Left Leg"))
                        DrawBone(char:FindFirstChild("Torso"), char:FindFirstChild("Right Leg"))
                        DrawBone(char:FindFirstChild("Left Arm"), char:FindFirstChild("Left Hand"))
                        DrawBone(char:FindFirstChild("Right Arm"), char:FindFirstChild("Right Hand"))
                        DrawBone(char:FindFirstChild("Left Leg"), char:FindFirstChild("Left Foot"))
                        DrawBone(char:FindFirstChild("Right Leg"), char:FindFirstChild("Right Foot"))
                    end

                    -- ESP 360° (Directional indicator if out of view)
                    if _G.ESP360 and not inViewportRoot then
                        local screenCenter = Vector2.new(Workspace.CurrentCamera.ViewportSize.X / 2, Workspace.CurrentCamera.ViewportSize.Y / 2)
                        local charPos = root.Position
                        local camPos = Workspace.CurrentCamera.CFrame.Position
                        local dir = (charPos - camPos).unit
                        local angle = math.atan2(-dir.X, -dir.Z)

                        local indicatorRadius = 100
                        local indicatorPos = screenCenter + Vector2.new(math.sin(angle) * indicatorRadius, math.cos(angle) * indicatorRadius)

                        local indicator = Drawing.new("Text")
                        indicator.Visible = true
                        indicator.Color = Color3.fromRGB(255, 0, 0)
                        indicator.Outline = true
                        indicator.Text = "!"
                        indicator.Font = 2
                        indicator.Size = 20
                        indicator.Position = indicatorPos
                        table.insert(ESPDrawings, indicator)
                    end
                end
            end
        end
    end

    -- Chams Logic
    if _G.Chams then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                ApplyChams(player.Character, _G.ChamsColor)
            else
                RemoveChams(player.Character)
            end
        end
        -- Also apply to bots if they are in Workspace
        for _, child in ipairs(Workspace:GetChildren()) do
            if child:FindFirstChild("Humanoid") and child.Humanoid.Health > 0 and child.Name:find("Bot") then
                ApplyChams(child, _G.ChamsColor)
            else
                RemoveChams(child)
            end
        end
    else
        for char, _ in pairs(ChamsParts) do
            RemoveChams(char)
        end
    end
end)

-- Magic Bullet (Experimental - requires more advanced bypassing depending on game's anti-cheat)
if _G.MagicBullet then
    local oldFire = nil
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool") then
        local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if tool:FindFirstChild("FireRemote") and tool.FireRemote:IsA("RemoteEvent") then
            oldFire = hookmetamethod(game, "__namecall", function(self, ...)
                local method = getnamecallmethod()
                if method == "FireServer" and self == tool.FireRemote and _G.MagicBullet then
                    local target = GetClosestTarget()
                    if target and GetAimPart(target) then
                        local targetPosition = GetAimPart(target).Position
                        return self:FireServer(targetPosition)
                    end
                end
                return oldFire(self, ...)
            end)
        end
    end
end

-- Initialize the GUI to Aimbot tab
SetActiveTab("Aimbot")