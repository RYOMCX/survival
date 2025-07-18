local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer

local CORE = {
    GUI = {},
    Modules = {},
    Connections = {},
    Active = true,
}

local SETTINGS = {
    Aimbot = {
        Enabled = false,
        Silent = false,
        AimKey = Enum.KeyCode.E,
        TargetPart = "Head",
        FOV = 120,
        Smoothing = 5,
        TeamCheck = true,
        VisibilityCheck = true,
    },
    Combat = {
        Triggerbot = false,
        TriggerKey = Enum.KeyCode.LeftAlt,
    },
    ESP = {
        Enabled = true,
        TeamCheck = true,
        Boxes = true,
        Names = true,
        Distance = true,
        HealthBars = true,
        Skeleton = true,
        Tracers = true,
        Chams = false,
    },
    Misc = {
        PanicKey = Enum.KeyCode.Delete
    }
}

local function CreateGUILibrary()
    local library = {}
    local mainFrame, header, contentFrame, tabContainer
    local tabs = {}
    local activeTab = nil
    
    function library:CreateWindow(title)
        mainFrame = Instance.new("Frame")
        mainFrame.Size = UDim2.new(0, 550, 0, 350)
        mainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
        mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        mainFrame.Draggable = true
        mainFrame.Active = true
        Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 5)

        header = Instance.new("Frame", mainFrame)
        header.Size = UDim2.new(1, 0, 0, 35)
        header.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
        
        local titleLabel = Instance.new("TextLabel", header)
        titleLabel.Size = UDim2.new(1, -80, 1, 0)
        titleLabel.Position = UDim2.new(0, 10, 0, 0)
        titleLabel.Text = title
        titleLabel.Font = Enum.Font.GothamSemibold
        titleLabel.TextColor3 = Color3.new(1, 1, 1)
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left

        local closeButton = Instance.new("TextButton", header)
        closeButton.Size = UDim2.new(0, 20, 0, 20)
        closeButton.Position = UDim2.new(1, -28, 0.5, -10)
        closeButton.Text = "X"
        closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        closeButton.MouseButton1Click:Connect(function() CORE.GUI:Destroy() end)

        local minimizeButton = Instance.new("TextButton", header)
        minimizeButton.Size = UDim2.new(0, 20, 0, 20)
        minimizeButton.Position = UDim2.new(1, -53, 0.5, -10)
        minimizeButton.Text = "-"
        minimizeButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        
        local restoreButton = Instance.new("TextButton", mainFrame.Parent)
        restoreButton.Size = UDim2.new(0, 150, 0, 30)
        restoreButton.Position = UDim2.new(0.5, -75, 1, -40)
        restoreButton.Text = "RYOFC HACKS"
        restoreButton.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
        restoreButton.TextColor3 = Color3.new(1,1,1)
        restoreButton.Visible = false
        
        minimizeButton.MouseButton1Click:Connect(function()
            mainFrame.Visible = false
            restoreButton.Visible = true
        end)
        
        restoreButton.MouseButton1Click:Connect(function()
            mainFrame.Visible = true
            restoreButton.Visible = false
        end)

        tabContainer = Instance.new("Frame", mainFrame)
        tabContainer.Position = UDim2.new(0, 0, 0, 35)
        tabContainer.Size = UDim2.new(0, 130, 1, -35)
        tabContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        Instance.new("UIListLayout", tabContainer).Padding = UDim.new(0, 5)
        
        contentFrame = Instance.new("Frame", mainFrame)
        contentFrame.Position = UDim2.new(0, 130, 0, 35)
        contentFrame.Size = UDim2.new(1, -130, 1, -35)
        contentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)

        mainFrame.Parent = CoreGui
        return mainFrame
    end
    
    function library:CreateTab(name)
        local page = Instance.new("ScrollingFrame", contentFrame)
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        page.BorderSizePixel = 0
        page.Visible = false
        Instance.new("UIListLayout", page).Padding = UDim.new(0, 10)

        local button = Instance.new("TextButton", tabContainer)
        button.Size = UDim2.new(1, -10, 0, 30)
        button.Position = UDim2.new(0.5, -button.Size.X.Offset/2, 0, 0)
        button.Text = name
        button.BackgroundColor3 = Color3.fromRGB(40,40,45)
        button.TextColor3 = Color3.new(1,1,1)
        button.MouseButton1Click:Connect(function()
            if activeTab then
                activeTab.Page.Visible = false
                activeTab.Button.BackgroundColor3 = Color3.fromRGB(40,40,45)
            end
            page.Visible = true
            button.BackgroundColor3 = Color3.fromRGB(80,80,90)
            activeTab = { Page = page, Button = button }
        end)
        
        table.insert(tabs, { Page = page, Button = button })
        if not activeTab then button.MouseButton1Click:Invoke() end
        return page
    end
    
    function library:CreateToggle(parent, text, category, key)
        local container = Instance.new("Frame", parent)
        container.Size = UDim2.new(0.9, 0, 0, 25)
        container.BackgroundTransparency = 1
        local label = Instance.new("TextLabel", container)
        label.Size = UDim2.new(0.7, -5, 1, 0)
        label.Text = text
        label.TextColor3 = Color3.new(1,1,1)
        label.BackgroundTransparency = 1
        label.TextXAlignment = Enum.TextXAlignment.Left
        
        local toggleButton = Instance.new("TextButton", container)
        toggleButton.Size = UDim2.new(0.3, 0, 1, 0)
        toggleButton.Position = UDim2.new(0.7, 0, 0, 0)
        toggleButton.Text = ""
        local function update() toggleButton.BackgroundColor3 = SETTINGS[category][key] and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0) end
        toggleButton.MouseButton1Click:Connect(function() SETTINGS[category][key] = not SETTINGS[category][key]; update() end)
        update()
    end
    
    return library
end

local function BuildGUI()
    CORE.GUI = CreateGUILibrary()
    CORE.GUI:CreateWindow("RYOFC DOMINION ENGINE")
    
    local aimbotTab = CORE.GUI:CreateTab("Aimbot")
    CORE.GUI:CreateToggle(aimbotTab, "Enable Aimbot", "Aimbot", "Enabled")
    CORE.GUI:CreateToggle(aimbotTab, "Silent Aim", "Aimbot", "Silent")
    CORE.GUI:CreateToggle(aimbotTab, "Team Check", "Aimbot", "TeamCheck")
    
    local combatTab = CORE.GUI:CreateTab("Combat")
    CORE.GUI:CreateToggle(combatTab, "Triggerbot", "Combat", "Triggerbot")

    local espTab = CORE.GUI:CreateTab("ESP")
    CORE.GUI:CreateToggle(espTab, "Enable ESP", "ESP", "Enabled")
    CORE.GUI:CreateToggle(espTab, "Boxes", "ESP", "Boxes")
    CORE.GUI:CreateToggle(espTab, "Names", "ESP", "Names")
    CORE.GUI:CreateToggle(espTab, "Distance", "ESP", "Distance")
    CORE.GUI:CreateToggle(espTab, "Health Bars", "ESP", "HealthBars")
    CORE.GUI:CreateToggle(espTab, "Skeleton", "ESP", "Skeleton")
    CORE.GUI:CreateToggle(espTab, "Tracers", "ESP", "Tracers")
    CORE.GUI:CreateToggle(espTab, "Chams", "ESP", "Chams")

    return CORE.GUI
end

function CORE.Modules.ESP()
    local drawings = {}
    local function Clear()
        for _,d in pairs(drawings) do d:Remove() end
        drawings = {}
    end
    
    local function Update()
        Clear()
        if not SETTINGS.ESP.Enabled then return end
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and (not SETTINGS.ESP.TeamCheck or player.Team ~= LocalPlayer.Team) then
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    local root = player.Character.HumanoidRootPart
                    local head = player.Character.Head
                    local screenPos, onScreen = Camera:WorldToScreenPoint(root.Position)
                    if onScreen then
                        local headPos = Camera:WorldToScreenPoint(head.Position)
                        local boxH = math.abs(headPos.Y - screenPos.Y)
                        local boxW = boxH / 1.5
                        
                        if SETTINGS.ESP.Boxes then
                            local box = Drawing.new("Quad")
                            box.PointA = Vector2.new(screenPos.X - boxW/2, headPos.Y)
                            box.PointB = Vector2.new(screenPos.X + boxW/2, headPos.Y)
                            box.PointC = Vector2.new(screenPos.X + boxW/2, screenPos.Y)
                            box.PointD = Vector2.new(screenPos.X - boxW/2, screenPos.Y)
                            box.Color = player.TeamColor.Color
                            table.insert(drawings, box)
                        end
                        if SETTINGS.ESP.Tracers then
                            local tracer = Drawing.new("Line")
                            tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                            tracer.To = Vector2.new(screenPos.X, screenPos.Y)
                            tracer.Color = player.TeamColor.Color
                            table.insert(drawings, tracer)
                        end
                    end
                end
            end
        end
    end
    
    return { Update = Update }
end

function CORE.Modules.Aimbot()
    local target = nil
    
    local function GetTarget()
        local bestTarget, minFov = nil, SETTINGS.Aimbot.FOV
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and (not SETTINGS.Aimbot.TeamCheck or player.Team ~= LocalPlayer.Team) then
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                local targetPart = player.Character:FindFirstChild(SETTINGS.Aimbot.TargetPart)
                if humanoid and humanoid.Health > 0 and targetPart then
                    local screenPos, onScreen = Camera:WorldToScreenPoint(targetPart.Position)
                    if onScreen then
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - UserInputService:GetMouseLocation()).Magnitude
                        if dist < minFov then
                            bestTarget = targetPart
                            minFov = dist
                        end
                    end
                end
            end
        end
        return bestTarget
    end
    
    local function Update()
        if SETTINGS.Aimbot.Enabled and UserInputService:IsKeyDown(SETTINGS.Aimbot.AimKey) then
            target = GetTarget()
            if target then
                if SETTINGS.Aimbot.Silent then
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
                else
                    local newCFrame = CFrame.new(Camera.CFrame.Position, target.Position)
                    Camera.CFrame = Camera.CFrame:Lerp(newCFrame, 1 / (SETTINGS.Aimbot.Smoothing + 1))
                end
            end
        end
    end
    
    return { Update = Update }
end

function CORE.Modules.Combat()
    local function Update()
        if SETTINGS.Combat.Triggerbot and UserInputService:IsKeyDown(SETTINGS.Combat.TriggerKey) then
            local mouseRay = Camera:ScreenPointToRay(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
            local result = Workspace:Raycast(mouseRay.Origin, mouseRay.Direction * 1000)
            if result and result.Instance then
                local player = Players:GetPlayerFromCharacter(result.Instance.Parent)
                if player and player ~= LocalPlayer and (not SETTINGS.Aimbot.TeamCheck or player.Team ~= LocalPlayer.Team) then
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, nil, 1)
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, nil, 1)
                end
            end
        end
    end
    
    return { Update = Update }
end


function CORE:Init()
    BuildGUI()
    
    for name, moduleFunc in pairs(self.Modules) do
        self.Modules[name] = moduleFunc()
    end
    
    table.insert(self.Connections, RunService.RenderStepped:Connect(function()
        if not self.Active then return end
        for _, module in pairs(self.Modules) do
            if module.Update then module.Update() end
        end
    end))
end

CORE:Init()
