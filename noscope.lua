local Players, RunService, UserInputService, Workspace = game:GetService("Players"), game:GetService("RunService"), game:GetService("UserInputService"), game:GetService("Workspace")
local LocalPlayer, Camera = Players.LocalPlayer, Workspace.CurrentCamera
local DrawingObjects = {}

getgenv().Settings = {
    Aimbot = { Enabled = false, TeamCheck = true, VisibleOnly = true, FOV = 100, Part = "Head" },
    ESP = { Enabled = true, Names = true, Distance = true, Health = true, Boxes = true, Tracers = true, Skeleton = true, TeamCheck = true, VisibleColor = Color3.fromRGB(255, 0, 80), InvisibleColor = Color3.fromRGB(255, 150, 0) },
    SilentAim = { Enabled = false },
    MagicBullet = { Enabled = false }
}
local Settings = getgenv().Settings

-- SECTION 2: CUSTOM UI FRAMEWORK
-- ==============================================================================================

-- Main GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SkyDominatorGUI"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ScreenGui.ResetOnSpawn = false

-- Main Window
local MainWindow = Instance.new("Frame")
MainWindow.Name = "MainWindow"
MainWindow.Parent = ScreenGui
MainWindow.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainWindow.BorderColor3 = Color3.fromRGB(255, 0, 80)
MainWindow.BorderSizePixel = 1
MainWindow.Position = UDim2.new(0.5, -225, 0.5, -175)
MainWindow.Size = UDim2.new(0, 450, 0, 350)
MainWindow.Active = true
MainWindow.Draggable = true

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainWindow
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BorderColor3 = Color3.fromRGB(255, 0, 80)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Parent = TitleBar
TitleLabel.BackgroundColor3 = Color3.new(1, 1, 1)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0.02, 0, 0, 0)
TitleLabel.Size = UDim2.new(0.8, 0, 1, 0)
TitleLabel.Font = Enum.Font.SourceSansSemibold
TitleLabel.Text = "SkyDominator V3 // RYOXFC"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Parent = TitleBar
CloseButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.Size = UDim2.new(0, 30, 1, 0)
CloseButton.Font = Enum.Font.SourceSans
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- Feature Container
local Container = Instance.new("Frame")
Container.Name = "Container"
Container.Parent = MainWindow
Container.BackgroundColor3 = Color3.new(1, 1, 1)
Container.BackgroundTransparency = 1
Container.Position = UDim2.new(0, 0, 0, 30)
Container.Size = UDim2.new(1, 0, 1, -30)

-- Function to create toggles
local function CreateToggle(parent, text, flagTable, flagKey)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Parent = parent
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    ToggleFrame.Size = UDim2.new(1, -20, 0, 25)
    ToggleFrame.Position = UDim2.new(0, 10, 0, #parent:GetChildren() * 30)

    local Label = Instance.new("TextLabel")
    Label.Parent = ToggleFrame
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.BackgroundColor3 = Color3.new(1, 1, 1)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.SourceSans
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Text = text
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Position = UDim2.new(0, 10, 0, 0)

    local Button = Instance.new("TextButton")
    Button.Parent = ToggleFrame
    Button.Size = UDim2.new(0.25, 0, 0.8, 0)
    Button.Position = UDim2.new(0.725, 0, 0.1, 0)
    Button.BackgroundColor3 = flagTable[flagKey] and Color3.fromRGB(255, 0, 80) or Color3.fromRGB(80, 80, 80)
    Button.Font = Enum.Font.SourceSansBold
    Button.Text = flagTable[flagKey] and "ON" or "OFF"
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    
    Button.MouseButton1Click:Connect(function()
        flagTable[flagKey] = not flagTable[flagKey]
        Button.BackgroundColor3 = flagTable[flagKey] and Color3.fromRGB(255, 0, 80) or Color3.fromRGB(80, 80, 80)
        Button.Text = flagTable[flagKey] and "ON" or "OFF"
    end)
end

-- Populate UI
CreateToggle(Container, "Aimbot", Settings.Aimbot, "Enabled")
CreateToggle(Container, "Silent Aim", Settings.SilentAim, "Enabled")
CreateToggle(Container, "Magic Bullet", Settings.MagicBullet, "Enabled")
CreateToggle(Container, "Full ESP", Settings.ESP, "Enabled")
CreateToggle(Container, "ESP: Names", Settings.ESP, "Names")
CreateToggle(Container, "ESP: Distance", Settings.ESP, "Distance")
CreateToggle(Container, "ESP: Boxes", Settings.ESP, "Boxes")
CreateToggle(Container, "ESP: Health", Settings.ESP, "Health")
CreateToggle(Container, "ESP: Tracers", Settings.ESP, "Tracers")
CreateToggle(Container, "ESP: Skeleton", Settings.ESP, "Skeleton")
CreateToggle(Container, "ESP: Team Check", Settings.ESP, "TeamCheck")

-- Make window draggable
local dragging
local dragInput
local dragStart
local startPos
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainWindow.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainWindow.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Parent the GUI to CoreGui
ScreenGui.Parent = game:GetService("CoreGui")

-- SECTION 3: FEATURE FUNCTIONS
-- ==============================================================================================

local function IsVisible(part)
    local _, onScreen = Camera:WorldToScreenPoint(part.Position)
    if onScreen then
        local ray = Ray.new(Camera.CFrame.Position, part.Position - Camera.CFrame.Position)
        local hit = Workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character})
        return hit and hit:IsDescendantOf(part.Parent)
    end
    return false
end

local function ClearDrawings()
    for _, v in ipairs(DrawingObjects) do v:Remove() end
    DrawingObjects = {}
end

local function Draw(obj) table.insert(DrawingObjects, obj) end

-- ESP Handler
local function ESP_Handler(player)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Humanoid") or char.Humanoid.Health <= 0 then return end

    local root, head, humanoid = char.HumanoidRootPart, char:FindFirstChild("Head"), char.Humanoid
    if not root or not head then return end
    
    local isVisible = IsVisible(head)
    local color = (isVisible and Settings.ESP.VisibleColor) or Settings.ESP.InvisibleColor

    local pos, onScreen = Camera:WorldToScreenPoint(root.Position)
    if onScreen then
        local info = {}
        if Settings.ESP.Names then table.insert(info, player.Name) end
        if Settings.ESP.Distance then table.insert(info, string.format("[%dm]", (root.Position - Camera.CFrame.Position).Magnitude)) end
        
        local text = Drawing.new("Text")
        text.Text = table.concat(info, " ")
        text.Size = 14; text.Color = color; text.Center = true; text.Outline = true
        text.Position = Vector2.new(pos.X, pos.Y - 40)
        Draw(text)
        
        if Settings.ESP.Health then
            local hp = humanoid.Health / humanoid.MaxHealth
            local hpColor = Color3.fromHSV(hp * 0.33, 1, 1)
            local hpY = pos.Y - 35
            
            local back = Drawing.new("Line")
            back.From = Vector2.new(pos.X - 25, hpY); back.To = Vector2.new(pos.X + 25, hpY)
            back.Color = Color3.new(0,0,0); back.Thickness = 4; Draw(back)

            local front = Drawing.new("Line")
            front.From = Vector2.new(pos.X - 25, hpY); front.To = Vector2.new(pos.X - 25 + (50 * hp), hpY)
            front.Color = hpColor; front.Thickness = 4; Draw(front)
        end
        
        if Settings.ESP.Tracers then
            local tracer = Drawing.new("Line")
            tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
            tracer.To = Vector2.new(pos.X, pos.Y + 25); tracer.Color = color; tracer.Thickness = 1
            Draw(tracer)
        end
    end
    
    if Settings.ESP.Boxes then
        local cf, size = root.CFrame, Vector3.new(4, 6, 2)
        local points = {
            cf * CFrame.new(size.X/2, size.Y/2, 0).Position, cf * CFrame.new(-size.X/2, size.Y/2, 0).Position,
            cf * CFrame.new(-size.X/2, -size.Y/2, 0).Position, cf * CFrame.new(size.X/2, -size.Y/2, 0).Position
        }
        local screenPoints = {}
        local valid = true
        for _, p in ipairs(points) do
            local sp, onScreen = Camera:WorldToScreenPoint(p)
            if not onScreen then valid = false; break end
            table.insert(screenPoints, Vector2.new(sp.X, sp.Y))
        end
        if valid then
            for i = 1, #screenPoints do
                local line = Drawing.new("Line")
                line.From = screenPoints[i]; line.To = screenPoints[i % #screenPoints + 1]
                line.Color = color; line.Thickness = 1; Draw(line)
            end
        end
    end

    if Settings.ESP.Skeleton then
        local bones = {
            Head = "UpperTorso", UpperTorso = "LowerTorso",
            LowerTorso = "RightUpperLeg", RightUpperLeg = "RightLowerLeg", RightLowerLeg = "RightFoot",
            LowerTorso = "LeftUpperLeg", LeftUpperLeg = "LeftLowerLeg", LeftLowerLeg = "LeftFoot",
            UpperTorso = "RightUpperArm", RightUpperArm = "RightLowerArm", RightLowerArm = "RightHand",
            UpperTorso = "LeftUpperArm", LeftUpperArm = "LeftLowerArm", LeftLowerArm = "LeftHand"
        }
        for from, to in pairs(bones) do
            local p1, p2 = char:FindFirstChild(from), char:FindFirstChild(to)
            if p1 and p2 then
                local sp1, os1 = Camera:WorldToScreenPoint(p1.Position)
                local sp2, os2 = Camera:WorldToScreenPoint(p2.Position)
                if os1 and os2 then
                    local line = Drawing.new("Line"); line.From = Vector2.new(sp1.X, sp1.Y); line.To = Vector2.new(sp2.X, sp2.Y)
                    line.Color = color; line.Thickness = 1; Draw(line)
                end
            end
        end
    end
end

-- Aimbot Handler
local function Aimbot_Handler()
    if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local bestTarget, smallestDist = nil, Settings.Aimbot.FOV
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(Settings.Aimbot.Part) and player.Character.Humanoid.Health > 0 then
                if Settings.Aimbot.TeamCheck and player.TeamColor == LocalPlayer.TeamColor then continue end
                local targetPart = player.Character[Settings.Aimbot.Part]
                if Settings.Aimbot.VisibleOnly and not IsVisible(targetPart) then continue end
                local pos, onScreen = Camera:WorldToScreenPoint(targetPart.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                    if dist < smallestDist then smallestDist, bestTarget = dist, targetPart end
                end
            end
        end
        if bestTarget then Camera.CFrame = CFrame.new(Camera.CFrame.Position, bestTarget.Position) end
    end
end

-- Namecall hook for Silent Aim / Magic Bullet (Game-Dependent)
-- This is the required architecture. The actual remote name will vary by game.
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(...)
    local method = getnamecallmethod()
    local args = {...}
    
    if Settings.SilentAim.Enabled and (method == "Fire" or method == "fire") and typeof(args[1]) == "Instance" and args[1]:IsA("Player") then
        -- Find best target and replace args[2] (direction) or args[1] (target player)
    end
    
    if Settings.MagicBullet.Enabled and (method == "FireServer" or method == "fireServer") and args[2] == "BulletData" then
        -- Modify bullet trajectory data in args[3] to hit nearest enemy
    end

    return oldNamecall(...)
end)


-- SECTION 4: MAIN RENDER LOOP
-- ==============================================================================================

RunService.RenderStepped:Connect(function()
    ClearDrawings()

    if Settings.ESP.Enabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and (not Settings.ESP.TeamCheck or player.TeamColor ~= LocalPlayer.TeamColor) then
                pcall(ESP_Handler, player)
            end
        end
    end

    if Settings.Aimbot.Enabled then
        pcall(Aimbot_Handler)
    end
end)
