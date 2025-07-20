local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local Settings = {
    Aimbot = {
        Enabled = false,
        SilentAim = false,
        MagicBullet = false,
        AutoTrigger = false,
        FieldOfView = 120,
        TargetPart = "Head"
    },
    ESP = {
        Enabled = false,
        Boxes = false,
        Lines = false,
        Names = false,
        Skeletons = false,
        PlayerOrBot = false,
        Chams = false,
        ESP_360 = false
    },
    Colors = {
        Box = Color3.fromRGB(255, 0, 0),
        Line = Color3.fromRGB(255, 255, 0),
        Name = Color3.fromRGB(255, 255, 255),
        Skeleton = Color3.fromRGB(0, 255, 255),
        Chams = Color3.fromRGB(255, 0, 255)
    }
}

local GUI = {}
do
    GUI.ScreenGui = Instance.new("ScreenGui")
    GUI.ScreenGui.Name = "ScriptAI_GUI_Full"
    GUI.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    GUI.ScreenGui.ResetOnSpawn = false
    GUI.ScreenGui.Parent = CoreGui

    GUI.MainFrame = Instance.new("Frame")
    GUI.MainFrame.Size = UDim2.new(0, 450, 0, 350)
    GUI.MainFrame.Position = UDim2.new(0.5, -225, 0.5, -175)
    GUI.MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    GUI.MainFrame.BorderColor3 = Color3.fromRGB(80, 80, 80)
    GUI.MainFrame.BorderSizePixel = 2
    GUI.MainFrame.Active = true
    GUI.MainFrame.Draggable = true
    GUI.MainFrame.Parent = GUI.ScreenGui

    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 30)
    Header.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Header.BorderColor3 = Color3.fromRGB(80, 80, 80)
    Header.Parent = GUI.MainFrame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -60, 1, 0)
    Title.Text = "No Scope Arcade | Full Build by Script AI"
    Title.Font = Enum.Font.SourceSansBold
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 16
    Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Title.Parent = Header

    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 30, 1, 0)
    CloseButton.Position = UDim2.new(1, -30, 0, 0)
    CloseButton.Text = "X"
    CloseButton.Font = Enum.Font.SourceSansBold
    CloseButton.TextColor3 = Color3.new(1,1,1)
    CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    CloseButton.Parent = Header
    CloseButton.MouseButton1Click:Connect(function()
        GUI.ScreenGui:Destroy()
    end)

    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Size = UDim2.new(0, 30, 1, 0)
    MinimizeButton.Position = UDim2.new(1, -60, 0, 0)
    MinimizeButton.Text = "_"
    MinimizeButton.Font = Enum.Font.SourceSansBold
    MinimizeButton.TextColor3 = Color3.new(1,1,1)
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    MinimizeButton.Parent = Header

    local ContentFrame = Instance.new("Frame")
    ContentFrame.Size = UDim2.new(1, 0, 1, -30)
    ContentFrame.Position = UDim2.new(0, 0, 0, 30)
    ContentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    ContentFrame.BorderSizePixel = 0
    ContentFrame.Parent = GUI.MainFrame
    
    MinimizeButton.MouseButton1Click:Connect(function()
        ContentFrame.Visible = not ContentFrame.Visible
        if ContentFrame.Visible then
            GUI.MainFrame.Size = UDim2.new(0, 450, 0, 350)
        else
            GUI.MainFrame.Size = UDim2.new(0, 450, 0, 30)
        end
    end)

    local TabFrame = Instance.new("Frame")
    TabFrame.Size = UDim2.new(1, 0, 0, 30)
    TabFrame.Position = UDim2.new(0,0,0,0)
    TabFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    TabFrame.Parent = ContentFrame

    local AimbotPage = Instance.new("Frame")
    AimbotPage.Size = UDim2.new(1, 0, 1, -30)
    AimbotPage.Position = UDim2.new(0,0,0,30)
    AimbotPage.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    AimbotPage.BorderSizePixel = 0
    AimbotPage.Parent = ContentFrame

    local ESPPage = Instance.new("Frame")
    ESPPage.Size = UDim2.new(1, 0, 1, -30)
    ESPPage.Position = UDim2.new(0,0,0,30)
    ESPPage.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    ESPPage.BorderSizePixel = 0
    ESPPage.Visible = false
    ESPPage.Parent = ContentFrame
    
    local AimbotTabButton = Instance.new("TextButton")
    AimbotTabButton.Size = UDim2.new(0.5, 0, 1, 0)
    AimbotTabButton.Text = "Aimbot"
    AimbotTabButton.Font = Enum.Font.SourceSans
    AimbotTabButton.TextColor3 = Color3.new(1,1,1)
    AimbotTabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    AimbotTabButton.Parent = TabFrame
    
    local ESPTabButton = Instance.new("TextButton")
    ESPTabButton.Size = UDim2.new(0.5, 0, 1, 0)
    ESPTabButton.Position = UDim2.new(0.5, 0, 0, 0)
    ESPTabButton.Text = "Visuals"
    ESPTabButton.Font = Enum.Font.SourceSans
    ESPTabButton.TextColor3 = Color3.new(1,1,1)
    ESPTabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    ESPTabButton.Parent = TabFrame

    AimbotTabButton.MouseButton1Click:Connect(function()
        AimbotPage.Visible = true
        ESPPage.Visible = false
        AimbotTabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        ESPTabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    end)
    
    ESPTabButton.MouseButton1Click:Connect(function()
        AimbotPage.Visible = false
        ESPPage.Visible = true
        AimbotTabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        ESPTabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    end)

    local function CreateToggle(parent, text, settingTable, settingName)
        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Size = UDim2.new(0, 120, 0, 20)
        ToggleButton.Text = "  " .. text
        ToggleButton.TextXAlignment = Enum.TextXAlignment.Left
        ToggleButton.Font = Enum.Font.SourceSans
        ToggleButton.TextColor3 = Color3.new(1,1,1)
        ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        ToggleButton.Parent = parent
        
        local Indicator = Instance.new("Frame")
        Indicator.Size = UDim2.new(0, 10, 0, 10)
        Indicator.Position = UDim2.new(0, 5, 0.5, -5)
        Indicator.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        Indicator.Parent = ToggleButton

        local function updateVisual()
            if settingTable[settingName] then
                Indicator.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            else
                Indicator.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            end
        end
        updateVisual()

        ToggleButton.MouseButton1Click:Connect(function()
            settingTable[settingName] = not settingTable[settingName]
            updateVisual()
        end)
        return ToggleButton
    end
    
    local listLayoutAimbot = Instance.new("UIListLayout")
    listLayoutAimbot.Padding = UDim.new(0, 5)
    listLayoutAimbot.HorizontalAlignment = Enum.HorizontalAlignment.Center
    listLayoutAimbot.Parent = AimbotPage
    
    local listLayoutESP = Instance.new("UIListLayout")
    listLayoutESP.Padding = UDim.new(0, 5)
    listLayoutESP.HorizontalAlignment = Enum.HorizontalAlignment.Center
    listLayoutESP.Parent = ESPPage

    CreateToggle(AimbotPage, "Aimbot", Settings.Aimbot, "Enabled")
    CreateToggle(AimbotPage, "Silent Aim", Settings.Aimbot, "SilentAim")
    CreateToggle(AimbotPage, "Magic Bullet", Settings.Aimbot, "MagicBullet")
    CreateToggle(AimbotPage, "Auto Trigger", Settings.Aimbot, "AutoTrigger")
    
    CreateToggle(ESPPage, "ESP", Settings.ESP, "Enabled")
    CreateToggle(ESPPage, "Boxes", Settings.ESP, "Boxes")
    CreateToggle(ESPPage, "Lines", Settings.ESP, "Lines")
    CreateToggle(ESPPage, "Names", Settings.ESP, "Names")
    CreateToggle(ESPPage, "Skeletons", Settings.ESP, "Skeletons")
    CreateToggle(ESPPage, "Player/Bot", Settings.ESP, "PlayerOrBot")
    CreateToggle(ESPPage, "Chams", Settings.ESP, "Chams")
    CreateToggle(ESPPage, "360 ESP", Settings.ESP, "ESP_360")
end

local function getBestTarget(checkFOV)
    local bestTarget = nil
    local shortestDist = math.huge
    
    for i, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            local rootPart = v.Character.HumanoidRootPart
            local screenPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
            if onScreen or not checkFOV then
                local dist
                if checkFOV then
                    dist = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                else
                    dist = (LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
                end

                if dist < shortestDist then
                    if checkFOV and dist > Settings.Aimbot.FieldOfView then continue end
                    shortestDist = dist
                    bestTarget = v
                end
            end
        end
    end
    return bestTarget
end

local DrawingAPI = {}
do
    local drawings = {}
    function DrawingAPI.Clear()
        for i, v in pairs(drawings) do
            v:Remove()
        end
        drawings = {}
    end
    function DrawingAPI.Add(obj)
        obj.Visible = true
        table.insert(drawings, obj)
    end
end

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(...)
    local method = getnamecallmethod()
    if Settings.Aimbot.SilentAim and (method == "Fire" or method == "fire" or method == "shoot") then
        local target = getBestTarget(true)
        if target and target.Character and target.Character:FindFirstChild(Settings.Aimbot.TargetPart) then
            local args = {...}
            args[2] = target.Character[Settings.Aimbot.TargetPart].Position
            return oldNamecall(unpack(args))
        end
    end
    return oldNamecall(...)
end)

RunService.RenderStepped:Connect(function()
    DrawingAPI.Clear()
    
    local aimbotTarget = getBestTarget(true)

    if Settings.Aimbot.Enabled and aimbotTarget then
        local targetPart = aimbotTarget.Character and aimbotTarget.Character:FindFirstChild(Settings.Aimbot.TargetPart)
        if targetPart then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
        end
    end

    if Settings.Aimbot.AutoTrigger then
        local mouseTarget = Mouse.Target
        if mouseTarget and mouseTarget.Parent and mouseTarget.Parent:FindFirstChildWhichIsA("Humanoid") then
            local player = Players:GetPlayerFromCharacter(mouseTarget.Parent)
            if player and player ~= LocalPlayer then
                game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 1)
                game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, false, game, 1)
            end
        end
    end

    if Settings.ESP.Enabled then
        for i, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                local rootPart = v.Character.HumanoidRootPart
                local head = v.Character:FindFirstChild("Head")
                if not head then continue end
                
                local screenPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)

                if onScreen then
                    if Settings.ESP.Boxes then
                        local scale = (head.Position - rootPart.Position).Magnitude
                        local w, h = 2 * scale, 3 * scale
                        local box = Drawing.new("Quad")
                        box.Color = Settings.Colors.Box
                        box.Thickness = 1
                        box.PointA = Vector2.new(screenPos.X - w/2, screenPos.Y - h)
                        box.PointB = Vector2.new(screenPos.X + w/2, screenPos.Y - h)
                        box.PointC = Vector2.new(screenPos.X + w/2, screenPos.Y)
                        box.PointD = Vector2.new(screenPos.X - w/2, screenPos.Y)
                        DrawingAPI.Add(box)
                    end
                    if Settings.ESP.Lines then
                        local line = Drawing.new("Line")
                        line.Color = Settings.Colors.Line
                        line.Thickness = 1
                        line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                        line.To = Vector2.new(screenPos.X, screenPos.Y)
                        DrawingAPI.Add(line)
                    end
                    if Settings.ESP.Names then
                        local name = Drawing.new("Text")
                        name.Text = v.Name
                        name.Size = 14
                        name.Center = true
                        name.Color = Settings.Colors.Name
                        name.Position = Vector2.new(screenPos.X, screenPos.Y - (head.Position - rootPart.Position).Magnitude * 2 - 20)
                        DrawingAPI.Add(name)
                    end
                    if Settings.ESP.PlayerOrBot then
                        local text = string.find(v.Name, "Bot") and "[BOT]" or "[PLAYER]"
                        local isBot = Drawing.new("Text")
                        isBot.Text = text
                        isBot.Size = 12
                        isBot.Center = true
                        isBot.Color = string.find(v.Name, "Bot") and Color3.fromRGB(255,200,0) or Color3.fromRGB(0,200,255)
                        isBot.Position = Vector2.new(screenPos.X, screenPos.Y + 10)
                        DrawingAPI.Add(isBot)
                    end
                    if Settings.ESP.Skeletons then
                        local parts = {
                            Head = "UpperTorso", UpperTorso = "LowerTorso",
                            UpperTorso = "LeftUpperArm", LeftUpperArm = "LeftLowerArm", LeftLowerArm = "LeftHand",
                            UpperTorso = "RightUpperArm", RightUpperArm = "RightLowerArm", RightLowerArm = "RightHand",
                            LowerTorso = "LeftUpperLeg", LeftUpperLeg = "LeftLowerLeg", LeftLowerLeg = "LeftFoot",
                            LowerTorso = "RightUpperLeg", RightUpperLeg = "RightLowerLeg", RightLowerLeg = "RightFoot"
                        }
                        for p1n, p2n in pairs(parts) do
                            local p1, p2 = v.Character:FindFirstChild(p1n), v.Character:FindFirstChild(p2n)
                            if p1 and p2 then
                                local pos1, vis1 = Camera:WorldToViewportPoint(p1.Position)
                                local pos2, vis2 = Camera:WorldToViewportPoint(p2.Position)
                                if vis1 and vis2 then
                                    local skeleLine = Drawing.new("Line")
                                    skeleLine.Color = Settings.Colors.Skeleton
                                    skeleLine.Thickness = 1
                                    skeleLine.From = Vector2.new(pos1.X, pos1.Y)
                                    skeleLine.To = Vector2.new(pos2.X, pos2.Y)
                                    DrawingAPI.Add(skeleLine)
                                end
                            end
                        end
                    end
                elseif Settings.ESP.ESP_360 then
                    local cframe = Camera.CFrame
                    local forward = Vector3.new(cframe.LookVector.X, 0, cframe.LookVector.Z).Unit
                    local toTarget = Vector3.new(rootPart.Position.X - cframe.Position.X, 0, rootPart.Position.Z - cframe.Position.Z).Unit
                    local angle = math.acos(forward:Dot(toTarget))
                    local cross = forward:Cross(toTarget)
                    if cross.Y < 0 then angle = -angle end
                    local x = Camera.ViewportSize.X / 2 + (Camera.ViewportSize.X/3 * math.sin(angle))
                    local y = Camera.ViewportSize.Y / 2 - (Camera.ViewportSize.Y/3 * math.cos(angle))
                    local indicator = Drawing.new("Triangle")
                    indicator.Color = Settings.Colors.Box
                    indicator.Thickness = 2
                    indicator.PointA = Vector2.new(x,y)
                    indicator.PointB = Vector2.new(x-10, y-10)
                    indicator.PointC = Vector2.new(x+10, y-10)
                    DrawingAPI.Add(indicator)
                end
            end
        end
    end
end)

Workspace.ChildAdded:Connect(function(child)
    if Settings.Aimbot.MagicBullet and (child.Name == "Bullet" or child:FindFirstChild("Trail")) then
        coroutine.wrap(function()
            while Settings.Aimbot.MagicBullet and child.Parent do
                local target = getBestTarget(false)
                if target and target.Character and target.Character.PrimaryPart then
                    child.CFrame = CFrame.new(child.Position, target.Character.PrimaryPart.Position) * CFrame.new(0, 0, -5)
                end
                RunService.Heartbeat:Wait()
            end
        end)()
    end
end)

local function applyChams(character)
    if not character then return end
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Material = Enum.Material.ForceField
            part.Color = Settings.Colors.Chams
        end
    end
end

local function removeChams(character)
    if not character then return end
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") and part.Material == Enum.Material.ForceField then
            part.Material = Enum.Material.Plastic
            part.Color = Color3.new(1,1,1)
        end
    end
end

local chamsConnection
chamsConnection = UserInputService.InputBegan:Connect(function()
    if Settings.ESP.Chams then
        for _, player in pairs(Players:GetPlayers()) do
            applyChams(player.Character)
        end
    else
        for _, player in pairs(Players:GetPlayers()) do
            removeChams(player.Character)
        end
    end
end)

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        if Settings.ESP.Chams then
            task.wait(0.5)
            applyChams(character)
        end
    end)
end