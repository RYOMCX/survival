local function RYOFC_PHOENIX_ENGINE_V2()
    local CoreGui = game:GetService("CoreGui")
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local Workspace = game:GetService("Workspace")
    local Camera = Workspace.CurrentCamera
    local LocalPlayer = Players.LocalPlayer

    if not LocalPlayer then
        Players.LocalPlayerAdded:Wait()
        LocalPlayer = Players.LocalPlayer
    end

    local CORE = {
        Active = true,
        Connections = {},
        Modules = {},
        GUI = {}
    }

    local SETTINGS = {
        Aimbot = {
            Enabled = true,
            TargetPart = "Head",
            FOV = 150,
            Smoothing = 3,
            TeamCheck = true,
            VisibilityCheck = true,
        },
        Combat = {
            MagicBullet = false,
            AutoHeadshot = true,
            Triggerbot = false,
        },
        ESP = {
            Enabled = true,
            TeamCheck = true,
            Boxes = true,
            Names = true,
            Distance = true,
            HealthBars = true,
            HealthText = true,
            Weapon = true,
            Skeleton = true,
            Tracers = true,
            HeadDots = true,
            Chams = true,
            OffscreenArrows = true,
        },
    }

    local function CreateGUIPool(player)
        if CORE.GUI.ESPPool and CORE.GUI.ESPPool[player] then return end
        local pool = {}
        pool.Holder = Instance.new("BillboardGui", CoreGui)
        pool.Holder.AlwaysOnTop = true
        pool.Holder.Size = UDim2.new(0, 0, 0, 0)
        pool.Holder.Enabled = false

        pool.Box = Instance.new("Frame", pool.Holder)
        pool.Box.BackgroundTransparency = 1
        pool.Box.BorderSizePixel = 1
        
        pool.Name = Instance.new("TextLabel", pool.Holder)
        pool.Name.Font = Enum.Font.SourceSans; pool.Name.TextSize = 14; pool.Name.TextColor3 = Color3.new(1,1,1); pool.Name.BackgroundTransparency = 1
        
        pool.HealthBar = Instance.new("Frame", pool.Holder)
        pool.HealthBar.BackgroundColor3 = Color3.fromRGB(20,20,20); pool.HealthBar.BorderSizePixel = 0
        pool.HealthFill = Instance.new("Frame", pool.HealthBar)
        
        pool.HealthText = Instance.new("TextLabel", pool.Holder)
        pool.HealthText.Font = Enum.Font.SourceSans; pool.HealthText.TextSize = 12; pool.HealthText.TextColor3 = Color3.new(1,1,1); pool.HealthText.BackgroundTransparency = 1
        
        pool.Distance = Instance.new("TextLabel", pool.Holder)
        pool.Distance.Font = Enum.Font.SourceSans; pool.Distance.TextSize = 12; pool.Distance.TextColor3 = Color3.new(1,1,1); pool.Distance.BackgroundTransparency = 1
        
        pool.Weapon = Instance.new("TextLabel", pool.Holder)
        pool.Weapon.Font = Enum.Font.SourceSans; pool.Weapon.TextSize = 12; pool.Weapon.TextColor3 = Color3.new(1,1,1); pool.Weapon.BackgroundTransparency = 1
        
        CORE.GUI.ESPPool[player] = pool
    end

    local function BuildGUI()
        CORE.GUI.ESPPool = {}
        CORE.GUI.ScreenGui = Instance.new("ScreenGui", CoreGui)

        local MainFrame = Instance.new("Frame", CORE.GUI.ScreenGui)
        MainFrame.Size = UDim2.new(0, 250, 0, 420)
        MainFrame.Position = UDim2.new(1, -270, 0.5, -210)
        MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        MainFrame.Draggable = true
        Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 4)

        local Header = Instance.new("Frame", MainFrame)
        Header.Size = UDim2.new(1, 0, 0, 30)
        Header.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        local Title = Instance.new("TextLabel", Header)
        Title.Size = UDim2.new(1, -60, 1, 0)
        Title.Text = "RYOFC PHOENIX V2"
        Title.Font = Enum.Font.GothamBold
        Title.TextColor3 = Color3.new(1,1,1)
        
        local CloseButton = Instance.new("TextButton", Header)
        CloseButton.Size = UDim2.new(0,20,0,20); CloseButton.Position = UDim2.new(1,-25,0.5,-10); CloseButton.Text = "X"; CloseButton.BackgroundColor3 = Color3.fromRGB(200,50,50)
        CloseButton.MouseButton1Click:Connect(function() CORE.GUI.ScreenGui:Destroy() CORE.Active = false for _,c in pairs(CORE.Connections) do c:Disconnect() end end)

        local MinimizeButton = Instance.new("TextButton", Header)
        MinimizeButton.Size = UDim2.new(0,20,0,20); MinimizeButton.Position = UDim2.new(1,-50,0.5,-10); MinimizeButton.Text = "-"; MinimizeButton.BackgroundColor3 = Color3.fromRGB(80,80,80)

        local RestoreButton = Instance.new("TextButton", CORE.GUI.ScreenGui)
        RestoreButton.Size = UDim2.new(0,120,0,30); RestoreButton.Position = UDim2.new(1,-130,1,-40); RestoreButton.Text = "RYOFC HACKS"; RestoreButton.Visible = false; RestoreButton.BackgroundColor3 = Color3.fromRGB(40,40,45); RestoreButton.TextColor3 = Color3.new(1,1,1)
        
        MinimizeButton.MouseButton1Click:Connect(function() MainFrame.Visible = false; RestoreButton.Visible = true end)
        RestoreButton.MouseButton1Click:Connect(function() MainFrame.Visible = true; RestoreButton.Visible = false end)
        
        local Content = Instance.new("ScrollingFrame", MainFrame)
        Content.Size = UDim2.new(1, -10, 1, -35); Content.Position = UDim2.new(0, 5, 0, 35); Content.CanvasSize = UDim2.new(0,0,0,0); Content.BackgroundTransparency = 1; Content.BorderSizePixel = 0
        local Layout = Instance.new("UIListLayout", Content)
        Layout.Padding = UDim.new(0, 5)

        local function CreateCategory(text)
            local label = Instance.new("TextLabel", Content)
            label.Size = UDim2.new(1,0,0,25); label.Text = "--- "..text.." ---"; label.Font = Enum.Font.GothamBold; label.TextColor3 = Color3.new(1,1,1); label.BackgroundTransparency = 1
        end

        local function CreateToggle(parent, text, category, key)
            local container = Instance.new("TextButton", parent)
            container.Size = UDim2.new(1, -10, 0, 25); container.Text = ""; container.BackgroundColor3 = Color3.fromRGB(50,50,55)
            local label = Instance.new("TextLabel", container)
            label.Size = UDim2.new(1,0,1,0); label.Text = text; label.TextColor3 = Color3.new(1,1,1); label.BackgroundTransparency = 1
            local indicator = Instance.new("Frame", container)
            indicator.Size = UDim2.new(0,10,0,10); indicator.Position = UDim2.new(1,-15,0.5,-5); indicator.BorderSizePixel = 0
            local function update() indicator.BackgroundColor3 = SETTINGS[category][key] and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0) end
            container.MouseButton1Click:Connect(function() SETTINGS[category][key] = not SETTINGS[category][key]; update() end)
            update()
        end
        
        CreateCategory("COMBAT")
        CreateToggle(Content, "Magic Bullet", "Combat", "MagicBullet")
        CreateToggle(Content, "Auto Headshot", "Combat", "AutoHeadshot")
        
        CreateCategory("AIMBOT")
        CreateToggle(Content, "Aimbot", "Aimbot", "Enabled")
        
        CreateCategory("ESP")
        CreateToggle(Content, "ESP Enabled", "ESP", "Enabled")
        CreateToggle(Content, "Boxes", "ESP", "Boxes")
        CreateToggle(Content, "Names", "ESP", "Names")
        CreateToggle(Content, "Health Bar", "ESP", "HealthBars")
        CreateToggle(Content, "Health Text", "ESP", "HealthText")
        CreateToggle(Content, "Distance", "ESP", "Distance")
        CreateToggle(Content, "Weapon", "ESP", "Weapon")
        CreateToggle(Content, "Tracers", "ESP", "Tracers")
        CreateToggle(Content, "Skeleton", "ESP", "Skeleton")
        CreateToggle(Content, "Head Dots", "ESP", "HeadDots")
        CreateToggle(Content, "Chams", "ESP", "Chams")
        CreateToggle(Content, "Off-screen Arrows", "ESP", "OffscreenArrows")
        CreateToggle(Content, "Team Check", "ESP", "TeamCheck")
        
        Layout.Parent.CanvasSize = UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y)
    end

    function CORE.Modules.Aimbot()
        local currentTarget = nil
        local function GetTarget()
            local bestTarget, minFov = nil, SETTINGS.Aimbot.FOV
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and (not SETTINGS.Aimbot.TeamCheck or player.Team ~= LocalPlayer.Team) then
                    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                    local targetPart = player.Character:FindFirstChild(SETTINGS.Aimbot.TargetPart)
                    if SETTINGS.Combat.MagicBullet and SETTINGS.Combat.AutoHeadshot then targetPart = player.Character:FindFirstChild("Head") end
                    if humanoid and humanoid.Health > 0 and targetPart then
                        local screenPos, onScreen = Camera:WorldToScreenPoint(targetPart.Position)
                        if onScreen then
                            local dist = (Vector2.new(screenPos.X, screenPos.Y) - UserInputService:GetMouseLocation()).Magnitude
                            if dist < minFov then bestTarget = targetPart; minFov = dist end
                        end
                    end
                end
            end
            return bestTarget
        end
        local function Update()
            if SETTINGS.Aimbot.Enabled then
                currentTarget = GetTarget()
                if currentTarget and (UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or UserInputService:IsKeyDown(Enum.KeyCode.E)) then
                    Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, currentTarget.Position), 1 / (SETTINGS.Aimbot.Smoothing + 1))
                end
            end
            if SETTINGS.Combat.MagicBullet and not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then currentTarget = GetTarget() end
        end
        local function OnInputBegan(input)
            if SETTINGS.Combat.MagicBullet and input.UserInputType == Enum.UserInputType.MouseButton1 and currentTarget then
                local originalCFrame = Camera.CFrame
                Camera.CFrame = CFrame.new(originalCFrame.Position, currentTarget.Position)
                RunService.RenderStepped:Wait() 
                Camera.CFrame = originalCFrame
            end
        end
        return { Update = Update, OnInputBegan = OnInputBegan }
    end
    
    function CORE.Modules.ESP()
        local drawings = {}
        local chamsApplied = {}

        local function ClearDrawings() for _,d in pairs(drawings) do d:Remove() end drawings = {} end

        local function Update()
            ClearDrawings()

            for player, original in pairs(chamsApplied) do
                if player.Character then
                    for part, props in pairs(original) do part.Material = props.Material; part.Color = props.Color end
                end
            end
            chamsApplied = {}
            
            if not SETTINGS.ESP.Enabled then 
                for _, pool in pairs(CORE.GUI.ESPPool) do if pool.Holder.Enabled then pool.Holder.Enabled = false end end
                return 
            end

            for player, pool in pairs(CORE.GUI.ESPPool) do
                local char = player.Character
                if char and char.Parent and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid") and player ~= LocalPlayer then
                    local humanoid = char.Humanoid
                    if humanoid.Health <= 0 or (SETTINGS.ESP.TeamCheck and player.Team == LocalPlayer.Team) then pool.Holder.Enabled = false; continue end
                    
                    if SETTINGS.ESP.Chams then
                        chamsApplied[player] = {}
                        for _, part in ipairs(char:GetDescendants()) do
                            if part:IsA("BasePart") then
                                chamsApplied[player][part] = {Material = part.Material, Color = part.Color}
                                part.Material = Enum.Material.ForceField
                                part.Color = player.TeamColor.Color
                            end
                        end
                    end
                    
                    local root = char.HumanoidRootPart
                    local head = char.Head
                    local screenPos, onScreen = Camera:WorldToScreenPoint(root.Position)
                    
                    if onScreen then
                        pool.Holder.Enabled = true
                        local headPos = Camera:WorldToScreenPoint(head.Position)
                        local boxH = math.abs(headPos.Y - screenPos.Y); local boxW = boxH / 1.5; local boxPos = Vector2.new(screenPos.X - boxW/2, headPos.Y)
                        local yOffset = -15
                        
                        pool.Name.Visible = SETTINGS.ESP.Names; pool.Name.Position = UDim2.fromOffset(boxPos.X + boxW/2, boxPos.Y + yOffset); pool.Name.Text = player.Name; yOffset = yOffset - 15
                        pool.Box.Visible = SETTINGS.ESP.Boxes; pool.Box.Position = UDim2.fromOffset(boxPos.X, boxPos.Y); pool.Box.Size = UDim2.fromOffset(boxW, boxH); pool.Box.Color = player.TeamColor.Color

                        pool.HealthBar.Visible = SETTINGS.ESP.HealthBars; pool.HealthBar.Position = UDim2.fromOffset(boxPos.X - 6, boxPos.Y); pool.HealthBar.Size = UDim2.fromOffset(4, boxH)
                        local hp = humanoid.Health / humanoid.MaxHealth; pool.HealthFill.Size = UDim2.new(1, hp, 1, 0); pool.HealthFill.BackgroundColor3 = Color3.fromHSV(hp / 3, 1, 1)

                        yOffset = 2
                        pool.Distance.Visible = SETTINGS.ESP.Distance; pool.Distance.Position = UDim2.fromOffset(boxPos.X + boxW/2, screenPos.Y + yOffset); local dist = math.floor((root.Position - Camera.CFrame.Position).Magnitude); pool.Distance.Text = dist .. "m"; yOffset = yOffset + 12
                        
                        local tool = char:FindFirstChildOfClass("Tool"); pool.Weapon.Visible = SETTINGS.ESP.Weapon; pool.Weapon.Position = UDim2.fromOffset(boxPos.X + boxW/2, screenPos.Y + yOffset); pool.Weapon.Text = tool and tool.Name or ""
                        
                        if SETTINGS.ESP.HeadDots then local dot = Drawing.new("Circle"); dot.Radius=4; dot.Filled=true; dot.Color=Color3.new(1,0,0); dot.Position=headPos; table.insert(drawings, dot) end
                    else
                        pool.Holder.Enabled = false
                    end
                else
                    pool.Holder.Enabled = false
                end
            end
        end
        return { Update = Update }
    end

    function CORE:Init()
        BuildGUI()
        for _, player in ipairs(Players:GetPlayers()) do CreateGUIPool(player) end
        table.insert(self.Connections, Players.PlayerAdded:Connect(CreateGUIPool))

        for name, moduleFunc in pairs(self.Modules) do self.Modules[name] = moduleFunc() end
        
        table.insert(self.Connections, RunService.RenderStepped:Connect(function()
            if not self.Active then return end
            for _, module in pairs(self.Modules) do if module.Update then module.Update() end end
        end))
        
        table.insert(self.Connections, UserInputService.InputBegan:Connect(function(input, gpe)
            if gpe then return end
            for _, module in pairs(self.Modules) do if module.OnInputBegan then module.OnInputBegan(input) end end
        end))
    end
    
    CORE:Init()
end

pcall(RYOFC_PHOENIX_ENGINE_V2)
