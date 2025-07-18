local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local Lighting = game:GetService("Lighting")

local CORE = {
    Connections = {},
    Modules = {},
    Active = true,
    Visible = true
}

local SETTINGS = {
    ESP = {
        Enabled = true,
        Boxes = true,
        Names = true,
        HealthBars = true,
        Distance = true,
        Skeleton = true,
        Weapon = true,
        Tracers = true,
        HeadDots = true,
        Chams = true,
        TeamCheck = true,
        OffscreenArrows = true,
        VisibilityCheck = true,
        ItemESP = false,
        VehicleESP = false,
    },
    Aimbot = {
        Enabled = false,
        TargetPart = "Head",
        AimKey = Enum.KeyCode.E,
        FOV = 100,
        Smoothing = 4,
        TeamCheck = true,
        VisibilityCheck = true,
    },
    Blatant = {
        KillAura = false,
        KillAuraRange = 25,
        InfiniteAmmo = false,
        NoRecoil = false,
        RapidFire = false,
        AntiAim = false,
        BHop = false,
        Fly = false,
        Noclip = false,
        Speed = 25,
        JumpPower = 50,
    },
    World = {
        Fullbright = false,
        Time = 14,
        FOV = 90,
        NoFog = false,
        SkyboxChanger = false,
    },
    Misc = {
        AntiAFK = true,
        AutoRespawn = true,
        PanicKey = Enum.KeyCode.Delete,
        ChatSpammer = false,
        SpamMessage = "RYOXFC ON TOP",
    }
}

local function CreateGUI()
    local ScreenGui = Instance.new("ScreenGui", CoreGui)
    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = UDim2.new(0, 580, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -290, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    MainFrame.BorderSizePixel = 1
    MainFrame.BorderColor3 = Color3.fromRGB(50, 50, 50)
    MainFrame.Draggable = true
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 6)
    
    local ClickSound = Instance.new("Sound", MainFrame)
    ClickSound.SoundId = "rbxassetid://2456494924"
    ClickSound.Volume = 0.8

    local TabFrame = Instance.new("Frame", MainFrame)
    TabFrame.Size = UDim2.new(0, 120, 1, 0)
    TabFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)

    local ContentFrame = Instance.new("Frame", MainFrame)
    ContentFrame.Size = UDim2.new(1, -120, 1, 0)
    ContentFrame.Position = UDim2.new(0, 120, 0, 0)
    ContentFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)

    local Tabs = {}
    local function CreateTab(name)
        local page = Instance.new("ScrollingFrame", ContentFrame)
        page.Size = UDim2.new(1, 0, 1, 0)
        page.Visible = false
        page.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        page.BorderSizePixel = 0
        page.ScrollBarImageColor3 = Color3.fromRGB(120, 120, 120)
        page.ScrollBarThickness = 4
        
        local layout = Instance.new("UIListLayout", page)
        layout.Padding = UDim.new(0, 8)
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        layout.SortOrder = Enum.SortOrder.LayoutOrder

        local button = Instance.new("TextButton", TabFrame)
        button.Size = UDim2.new(1, 0, 0, 40)
        button.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
        button.Text = name
        button.TextColor3 = Color3.new(1,1,1)
        button.Font = Enum.Font.GothamSemibold
        button.MouseButton1Click:Connect(function()
            for _, t in pairs(Tabs) do
                t.Page.Visible = false
                t.Button.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
            end
            page.Visible = true
            button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        end)
        
        Tabs[name] = {Page = page, Button = button}
        return page
    end
    
    local function CreateSwitchToggle(parent, text, category, key)
        local container = Instance.new("Frame", parent)
        container.Size = UDim2.new(0.9, 0, 0, 25)
        container.BackgroundTransparency = 1
        container.LayoutOrder = 1

        local label = Instance.new("TextLabel", container)
        label.Size = UDim2.new(0.7, -5, 1, 0)
        label.Text = text
        label.TextColor3 = Color3.fromRGB(200, 200, 200)
        label.Font = Enum.Font.Gotham
        label.BackgroundTransparency = 1
        label.TextXAlignment = Enum.TextXAlignment.Left
        
        local switchTrack = Instance.new("TextButton", container)
        switchTrack.Size = UDim2.new(0.3, 0, 0.8, 0)
        switchTrack.Position = UDim2.new(0.7, 0, 0.1, 0)
        switchTrack.Text = ""
        Instance.new("UICorner", switchTrack).CornerRadius = UDim.new(1, 0)
        
        local switchNub = Instance.new("Frame", switchTrack)
        switchNub.Size = UDim2.new(0.5, -4, 1, -4)
        switchNub.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        switchNub.BorderSizePixel = 0
        Instance.new("UICorner", switchNub).CornerRadius = UDim.new(1, 0)

        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        
        local function update(isInstant)
            local enabled = SETTINGS[category][key]
            local trackGoal = { BackgroundColor3 = enabled and Color3.fromRGB(76, 175, 80) or Color3.fromRGB(80, 80, 80) }
            local nubGoal = { Position = enabled and UDim2.new(0.5, 2, 0, 2) or UDim2.new(0, 2, 0, 2) }

            if isInstant then
                switchTrack.BackgroundColor3 = trackGoal.BackgroundColor3
                switchNub.Position = nubGoal.Position
            else
                TweenService:Create(switchTrack, tweenInfo, trackGoal):Play()
                TweenService:Create(switchNub, tweenInfo, nubGoal):Play()
            end
        end
        
        switchTrack.MouseButton1Click:Connect(function()
            SETTINGS[category][key] = not SETTINGS[category][key]
            ClickSound:Play()
            update(false)
        end)
        
        update(true)
        return container
    end

    local espTab = CreateTab("ESP")
    CreateSwitchToggle(espTab, "Enable ESP", "ESP", "Enabled")
    CreateSwitchToggle(espTab, "Boxes", "ESP", "Boxes")
    CreateSwitchToggle(espTab, "Names", "ESP", "Names")
    CreateSwitchToggle(espTab, "Health Bars", "ESP", "HealthBars")
    CreateSwitchToggle(espTab, "Distance", "ESP", "Distance")
    CreateSwitchToggle(espTab, "Skeleton", "ESP", "Skeleton")
    CreateSwitchToggle(espTab, "Weapon", "ESP", "Weapon")
    CreateSwitchToggle(espTab, "Tracers", "ESP", "Tracers")
    CreateSwitchToggle(espTab, "Head Dots", "ESP", "HeadDots")
    CreateSwitchToggle(espTab, "Chams", "ESP", "Chams")
    CreateSwitchToggle(espTab, "Team Check", "ESP", "TeamCheck")
    
    local aimbotTab = CreateTab("Aimbot")
    CreateSwitchToggle(aimbotTab, "Enable Aimbot", "Aimbot", "Enabled")
    CreateSwitchToggle(aimbotTab, "Team Check", "Aimbot", "TeamCheck")
    
    local blatantTab = CreateTab("Blatant")
    CreateSwitchToggle(blatantTab, "Kill Aura", "Blatant", "KillAura")
    CreateSwitchToggle(blatantTab, "Infinite Ammo", "Blatant", "InfiniteAmmo")
    CreateSwitchToggle(blatantTab, "No Recoil", "Blatant", "NoRecoil")
    CreateSwitchToggle(blatantTab, "Fly", "Blatant", "Fly")
    CreateSwitchToggle(blatantTab, "Noclip", "Blatant", "Noclip")

    local tabLayout = Instance.new("UIListLayout", TabFrame)
    tabLayout.Padding = UDim.new(0, 5)

    Tabs["ESP"].Button.MouseButton1Click:Invoke()
    return ScreenGui
end

function CORE.Modules.ESP()
    local drawings = {}
    local function ClearDrawings()
        for _,d in pairs(drawings) do d:Remove() end
        drawings = {}
    end
    
    local function Update()
        ClearDrawings()
        if not SETTINGS.ESP.Enabled then return end
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local character = player.Character
                if SETTINGS.ESP.TeamCheck and player.Team == LocalPlayer.Team then continue end
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if not humanoid or humanoid.Health <= 0 then continue end
                
                local root = character.HumanoidRootPart
                local head = character.Head
                local screenPos, onScreen = Camera:WorldToScreenPoint(root.Position)
                
                if onScreen then
                    local headPos = Camera:WorldToScreenPoint(head.Position)
                    local boxH = math.abs(headPos.Y - screenPos.Y)
                    local boxW = boxH / 2
                    
                    if SETTINGS.ESP.Boxes then
                        local box = Drawing.new("Quad")
                        box.PointA = Vector2.new(screenPos.X - boxW/2, headPos.Y)
                        box.PointB = Vector2.new(screenPos.X + boxW/2, headPos.Y)
                        box.PointC = Vector2.new(screenPos.X + boxW/2, screenPos.Y)
                        box.PointD = Vector2.new(screenPos.X - boxW/2, screenPos.Y)
                        box.Color = player.TeamColor.Color
                        box.Thickness = 1
                        table.insert(drawings, box)
                    end
                    
                    if SETTINGS.ESP.Tracers then
                        local tracer = Drawing.new("Line")
                        tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                        tracer.To = Vector2.new(screenPos.X, screenPos.Y)
                        tracer.Color = player.TeamColor.Color
                        table.insert(drawings, tracer)
                    end

                    if SETTINGS.ESP.Skeleton then
                        local parts = {
                            Head = "UpperTorso", UpperTorso = "LowerTorso", LowerTorso = "HumanoidRootPart",
                            RightUpperArm = "RightLowerArm", RightLowerArm = "RightHand",
                            LeftUpperArm = "LeftLowerArm", LeftLowerArm = "LeftHand",
                            RightUpperLeg = "RightLowerLeg", RightLowerLeg = "RightFoot",
                            LeftUpperLeg = "LeftLowerLeg", LeftLowerLeg = "LeftFoot",
                        }
                        for p1, p2 in pairs(parts) do
                            local part1, part2 = character:FindFirstChild(p1), character:FindFirstChild(p2)
                            if part1 and part2 then
                                local pos1, on1 = Camera:WorldToScreenPoint(part1.Position)
                                local pos2, on2 = Camera:WorldToScreenPoint(part2.Position)
                                if on1 and on2 then
                                    local line = Drawing.new("Line")
                                    line.From = Vector2.new(pos1.X, pos1.Y)
                                    line.To = Vector2.new(pos2.X, pos2.Y)
                                    line.Color = Color3.new(1,1,1)
                                    table.insert(drawings, line)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    
    return { Update = Update }
end

function CORE.Modules.Aimbot()
    local function GetTarget()
        local bestTarget, maxDist = nil, SETTINGS.Aimbot.FOV
        for _, player in ipairs(Players:GetPlayers()) do
             if player ~= LocalPlayer and player.Character and (not SETTINGS.Aimbot.TeamCheck or player.Team ~= LocalPlayer.Team) then
                 local targetPart = player.Character:FindFirstChild(SETTINGS.Aimbot.TargetPart)
                 local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                 if targetPart and humanoid and humanoid.Health > 0 then
                     local screenPos, onScreen = Camera:WorldToScreenPoint(targetPart.Position)
                     if onScreen then
                         local dist = (Vector2.new(screenPos.X, screenPos.Y) - UserInputService:GetMouseLocation()).Magnitude
                         if dist < maxDist then
                             bestTarget = targetPart
                             maxDist = dist
                         end
                     end
                 end
             end
        end
        return bestTarget
    end
    
    local function Update()
        if SETTINGS.Aimbot.Enabled and UserInputService:IsKeyDown(SETTINGS.Aimbot.AimKey) then
            local target = GetTarget()
            if target then
                local newCFrame = CFrame.new(Camera.CFrame.Position, target.Position)
                Camera.CFrame = Camera.CFrame:Lerp(newCFrame, 1 / (SETTINGS.Aimbot.Smoothing + 1))
            end
        end
    end
    
    return { Update = Update }
end

function CORE.Modules.Blatant()
    local noclipState = false
    local flyState = {bv = nil, bg = nil}

    local function Update()
        if SETTINGS.Blatant.Fly then
            if not flyState.bv and LocalPlayer.Character and LocalPlayer.Character.HumanoidRootPart then
                local root = LocalPlayer.Character.HumanoidRootPart
                flyState.bv = Instance.new("BodyVelocity", root)
                flyState.bg = Instance.new("BodyGyro", root)
                flyState.bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                flyState.bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                flyState.bg.P = 50000
            end
            if flyState.bv then
                local moveVec = Vector3.new()
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVec = moveVec + Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVec = moveVec - Camera.CFrame.LookVector end
                flyState.bv.Velocity = moveVec * 50
                flyState.bg.CFrame = Camera.CFrame
            end
        elseif flyState.bv then
            flyState.bv:Destroy()
            flyState.bg:Destroy()
            flyState.bv = nil
        end
        
        if SETTINGS.Blatant.Noclip ~= noclipState then
             noclipState = SETTINGS.Blatant.Noclip
             if LocalPlayer.Character then
                for _,part in ipairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = not noclipState end
                end
             end
        end
    end

    return { Update = Update }
end

function CORE:Init()
    self.GUI = CreateGUI()
    for name, moduleFunc in pairs(self.Modules) do
        self.Modules[name] = moduleFunc()
    end
    
    table.insert(self.Connections, RunService.RenderStepped:Connect(function()
        for _, module in pairs(self.Modules) do
            if module.Update then module.Update() end
        end
    end))
    
    table.insert(self.Connections, UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == SETTINGS.Misc.PanicKey then
            self.Active = false
            self.GUI:Destroy()
            for _,c in pairs(self.Connections) do c:Disconnect() end
        end
    end))
end

CORE:Init()
