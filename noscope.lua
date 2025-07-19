local SkyLib = {}
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local TeleportService = game:GetService("TeleportService")

do
    local function Create(instanceType, data)
        local obj = Instance.new(instanceType)
        for k, v in pairs(data) do
            if type(k) == 'number' then v.Parent = obj else obj[k] = v end
        end
        return obj
    end

    local function makeDraggable(guiObject)
        local dragging, dragInput, dragStart, startPos = false, nil, nil, nil
        guiObject.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging, dragStart, startPos = true, input.Position, guiObject.Parent.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then dragging = false end
                end)
            end
        end)
        guiObject.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                guiObject.Parent.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end

    function SkyLib:CreateWindow(title)
        local screenGui = Create('ScreenGui', {Name = "SkyGui_"..math.random(), Parent = CoreGui, ZIndexBehavior = Enum.ZIndexBehavior.Global, ResetOnSpawn = false})
        local mainFrame = Create('Frame', {Name = "MainFrame", Size = UDim2.new(0, 550, 0, 420), Position = UDim2.new(0.5, -275, 0.5, -210), BackgroundColor3 = Color3.fromRGB(25, 25, 25), BorderSizePixel = 0, Parent = screenGui})
        local header = Create('Frame', {Name = "Header", Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = Color3.fromRGB(15, 15, 15), BorderSizePixel = 0, Parent = mainFrame})
        Create('TextLabel', {Name = "Title", Size = UDim2.new(1, -60, 1, 0), Position = UDim2.new(0,0,0,0), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(220, 220, 220), Text = title or "SkyLib", Font = Enum.Font.SourceSansBold, TextSize = 16, TextXAlignment = Enum.TextXAlignment.Left, Parent = header, {Create('UIPadding', {PaddingLeft = UDim.new(0, 10)})}})
        local closeButton = Create('TextButton', {Name = "Close", Size = UDim2.new(0, 30, 1, 0), Position = UDim2.new(1, -30, 0, 0), BackgroundColor3 = Color3.fromRGB(15,15,15), Text = "X", TextColor3 = Color3.fromRGB(220,220,220), Font = Enum.Font.SourceSansBold, TextSize = 16, Parent = header})
        local minimizeButton = Create('TextButton', {Name = "Minimize", Size = UDim2.new(0, 30, 1, 0), Position = UDim2.new(1, -60, 0, 0), BackgroundColor3 = Color3.fromRGB(15,15,15), Text = "-", TextColor3 = Color3.fromRGB(220,220,220), Font = Enum.Font.SourceSansBold, TextSize = 24, Parent = header})
        local tabContainer = Create('Frame', {Name = "TabContainer", Size = UDim2.new(0, 100, 1, -30), Position = UDim2.new(0, 0, 0, 30), BackgroundColor3 = Color3.fromRGB(20, 20, 20), BorderSizePixel = 0, Parent = mainFrame})
        local contentContainer = Create('Frame', {Name = "ContentContainer", Size = UDim2.new(1, -100, 1, -30), Position = UDim2.new(0, 100, 0, 30), BackgroundColor3 = Color3.fromRGB(25, 25, 25), BorderSizePixel = 0, Parent = mainFrame})
        makeDraggable(header)
        local tabs, window = {}, {}
        function window:MakeTab(tabName)
            local contentFrame = Create('Frame', {Name = tabName.."_Content", Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Parent = contentContainer, Visible = #tabs == 0, {Create('UIPadding', {Padding = UDim.new(0,10)}), Create('UIListLayout', {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5)})}})
            local tabButton = Create('TextButton', {Name = tabName, Size = UDim2.new(1,0,0,35), BackgroundColor3 = #tabs == 0 and Color3.fromRGB(35,35,35) or Color3.fromRGB(20,20,20), Text = tabName, TextColor3 = Color3.fromRGB(200,200,200), Font = Enum.Font.SourceSans, TextSize = 16, Parent = tabContainer})
            table.insert(tabs, {button = tabButton, content = contentFrame})
            tabButton.MouseButton1Click:Connect(function() for _, t in pairs(tabs) do t.content.Visible = false; t.button.BackgroundColor3 = Color3.fromRGB(20,20,20) end; contentFrame.Visible = true; tabButton.BackgroundColor3 = Color3.fromRGB(35,35,35) end)
            local tab = {_layoutOrder = 0, _frame = contentFrame}
            function tab:AddToggle(data)
                self._layoutOrder = self._layoutOrder + 1
                local state, cb = data.Default or false, data.Callback or function() end
                local frame = Create('Frame', {Name = data.Name, LayoutOrder = self._layoutOrder, Size = UDim2.new(1,0,0,20), BackgroundTransparency = 1, Parent = self._frame})
                local button = Create('TextButton', {Name = "Button", Size = UDim2.new(0,20,0,20), BackgroundColor3 = state and Color3.fromRGB(100,180,255) or Color3.fromRGB(50,50,50), Text = "", Parent = frame})
                Create('TextLabel', {Name = "Label", Size = UDim2.new(1,-30,1,0), Position = UDim2.new(0,30,0,0), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(220,220,220), Text = data.Name, Font = Enum.Font.SourceSans, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, Parent = frame})
                button.MouseButton1Click:Connect(function() state = not state; button.BackgroundColor3 = state and Color3.fromRGB(100,180,255) or Color3.fromRGB(50,50,50); cb(state) end); cb(state)
            end
            function tab:AddButton(data)
                self._layoutOrder = self._layoutOrder + 1
                local button = Create('TextButton', {Name = data.Name, LayoutOrder = self._layoutOrder, Size = UDim2.new(1,0,0,30), BackgroundColor3 = Color3.fromRGB(50,50,50), TextColor3 = Color3.fromRGB(220,220,220), Text = data.Name, Font = Enum.Font.SourceSansSemibold, TextSize = 14, Parent = self._frame})
                button.MouseButton1Click:Connect(function() (data.Callback or function() end)(button) end); return button
            end
            function tab:AddSlider(data)
                self._layoutOrder = self._layoutOrder + 1
                local frame = Create('Frame', {Name=data.Name, LayoutOrder = self._layoutOrder, Size=UDim2.new(1,0,0,40), BackgroundTransparency=1, Parent=self._frame})
                local label = Create('TextLabel', {Name="Label", Size=UDim2.new(0.5,0,0,15), Position=UDim2.new(0,0,0,0), BackgroundTransparency=1, TextColor3=Color3.fromRGB(220,220,220), Text=data.Name, Font=Enum.Font.SourceSans, TextSize=14, TextXAlignment=Enum.TextXAlignment.Left, Parent=frame})
                local valueLabel = Create('TextLabel', {Name="ValueLabel", Size=UDim2.new(0.5,0,0,15), Position=UDim2.new(0.5,0,0,0), BackgroundTransparency=1, TextColor3=Color3.fromRGB(200,200,200), Text="", Font=Enum.Font.SourceSans, TextSize=14, TextXAlignment=Enum.TextXAlignment.Right, Parent=frame})
                local track = Create('Frame', {Name="Track", Size=UDim2.new(1,0,0,6), Position=UDim2.new(0,0,0,20), BackgroundColor3=Color3.fromRGB(50,50,50), Parent=frame, {Create('UICorner', {CornerRadius=UDim.new(1,0)})}})
                local fill = Create('Frame', {Name="Fill", Size=UDim2.new(0,0,1,0), BackgroundColor3=Color3.fromRGB(100,180,255), Parent=track, {Create('UICorner', {CornerRadius=UDim.new(1,0)})}})
                local thumb = Create('Frame', {Name="Thumb", Size=UDim2.new(0,14,0,14), Position=UDim2.new(0,0,0.5,-7), BackgroundColor3=Color3.fromRGB(200,200,200), Parent=track, {Create('UICorner', {CornerRadius=UDim.new(1,0)})}})
                local min, max, current = data.Min or 0, data.Max or 100, data.Default or 0
                local cb = data.Callback or function() end
                local function Update(inputPos)
                    local railPos, railWidth = track.AbsolutePosition.X, track.AbsoluteSize.X
                    if railWidth == 0 then return end
                    local percentage = math.clamp((inputPos.X - railPos) / railWidth, 0, 1)
                    current = min + (max - min) * percentage
                    fill.Size, thumb.Position = UDim2.new(percentage, 0, 1, 0), UDim2.new(percentage, -7, 0.5, -7)
                    valueLabel.Text = string.format("%d%s", math.floor(current), data.Suffix or "")
                    cb(current)
                end
                thumb.InputBegan:Connect(function() local mm; mm = UserInputService.InputChanged:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then Update(inp.Position) end end); local mu; mu = UserInputService.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then mm:Disconnect(); mu:Disconnect() end end) end)
                task.wait(); Update(thumb.AbsolutePosition); cb(current)
            end
            return tab
        end
        local isMinimized = false
        minimizeButton.MouseButton1Click:Connect(function() isMinimized = not isMinimized; contentContainer.Visible = not isMinimized; tabContainer.Visible = not isMinimized; mainFrame.Size = isMinimized and UDim2.new(0,550,0,30) or UDim2.new(0,550,0,420) end)
        closeButton.MouseButton1Click:Connect(function() screenGui:Destroy() end)
        return window
    end
end

local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local ESP_Objects = {}
local Config = {
    Aimbot = { Enabled = false, Trigger = false, Part = "Head", Target = nil, FOV = 30, ShowFOV = true },
    ESP = { Enabled = false, Boxes = false, Names = false, Health = false, Distance = false, Tracers = false, Skeletons = false, LookAt = false, HeadDots = false, TeamColor = false, Color = Color3.fromRGB(255, 0, 255) }
}

local Functions = {}

function Functions.CreateDrawing(className, properties) local d = Drawing.new(className); for k,v in pairs(properties or {}) do d[k]=v end; table.insert(ESP_Objects, d) end
function Functions.GetFOVCircleRadius() return (Camera.ViewportSize.Y * (Config.Aimbot.FOV / 100)) / 2 end

function Functions.UpdateAimbotTarget()
    local closestPlayer, shortestDist = nil, Functions.GetFOVCircleRadius()
    local crosshair = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.Humanoid.Health > 0 then
            local head = player.Character:FindFirstChild(Config.Aimbot.Part)
            if head then
                local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - crosshair).Magnitude
                    if dist < shortestDist then shortestDist, closestPlayer = dist, player end
                end
            end
        end
    end
    Config.Aimbot.Target = closestPlayer
end

function Functions.ExecuteCameraAimbot()
    if Config.Aimbot.Enabled and Config.Aimbot.Target and Config.Aimbot.Target.Character then
        local targetPart = Config.Aimbot.Target.Character:FindFirstChild(Config.Aimbot.Part)
        if targetPart then Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position) end
    end
end

function Functions.ExecuteTriggerAimbot()
    if Config.Aimbot.Trigger and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) and Config.Aimbot.Target and Config.Aimbot.Target.Character then
        local targetPart = Config.Aimbot.Target.Character:FindFirstChild(Config.Aimbot.Part)
        if targetPart then Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position) end
    end
end

function Functions.DrawFOVCircle()
    if Config.Aimbot.ShowFOV and (Config.Aimbot.Enabled or Config.Aimbot.Trigger) then Functions.CreateDrawing("Circle", {Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2), Radius = Functions.GetFOVCircleRadius(), Color = Color3.fromRGB(255,255,255), Thickness = 1, Filled = false, Visible = true, NumSides = 64}) end
end

function Functions.DrawESP_Tracers(color, pos) Functions.CreateDrawing("Line", {From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y), To = Vector2.new(pos.X, pos.Y), Color = color, Thickness = 1, Visible = true}) end
function Functions.DrawESP_Boxes(color, boxTopLeft, boxWidth, boxHeight) Functions.CreateDrawing("Quad", {PointA = boxTopLeft, PointB = Vector2.new(boxTopLeft.X+boxWidth, boxTopLeft.Y), PointC = Vector2.new(boxTopLeft.X+boxWidth, boxTopLeft.Y+boxHeight), PointD = Vector2.new(boxTopLeft.X, boxTopLeft.Y+boxHeight), Color = color, Thickness = 2, Filled = false, Visible = true}) end
function Functions.DrawESP_Names(player, color, boxTopLeft) Functions.CreateDrawing("Text", {Text = player.DisplayName, Size = 14, Color = color, Center = true, Position = boxTopLeft - Vector2.new(0, 15), Visible = true}) end
function Functions.DrawESP_Distance(player, color, pos) local dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).magnitude); Functions.CreateDrawing("Text", {Text = dist .. "m", Size = 12, Color = color, Center = true, Position = Vector2.new(pos.X, pos.Y + 5), Visible = true}) end
function Functions.DrawESP_Health(humanoid, boxTopLeft, boxHeight) local health = humanoid.Health / humanoid.MaxHealth; local healthColor = Color3.fromHSV(health * 0.33, 1, 1); local barX, barY = boxTopLeft.X - 6, boxTopLeft.Y; Functions.CreateDrawing("Line", {From=Vector2.new(barX, barY), To=Vector2.new(barX, barY+boxHeight), Color=Color3.new(0,0,0), Thickness=4, Visible=true}); Functions.CreateDrawing("Line", {From=Vector2.new(barX, barY+(boxHeight*(1-health))), To=Vector2.new(barX, barY+boxHeight), Color=healthColor, Thickness=2, Visible=true}) end
function Functions.DrawESP_Skeletons(player, color) local c = {{"Head","UpperTorso"},{"UpperTorso","LowerTorso"},{"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},{"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},{"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},{"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"}}; for _, d in pairs(c) do local p1,p2=player.Character:FindFirstChild(d[1]),player.Character:FindFirstChild(d[2]); if p1 and p2 then local v1,o1=Camera:WorldToViewportPoint(p1.Position); local v2,o2=Camera:WorldToViewportPoint(p2.Position); if o1 and o2 then Functions.CreateDrawing("Line", {From=Vector2.new(v1.X,v1.Y),To=Vector2.new(v2.X,v2.Y),Color=color,Thickness=2,Visible=true}) end end end end
function Functions.DrawESP_HeadDots(color, headPos) Functions.CreateDrawing("Circle", {Position = headPos, Radius = 4, Color = color, Filled = true, Visible = true}) end
function Functions.DrawESP_LookAt(head, color) local s,f = head.Position, head.Position+head.CFrame.LookVector*10; local v1,o1=Camera:WorldToViewportPoint(s); local v2,o2=Camera:WorldToViewportPoint(f); if o1 and o2 then Functions.CreateDrawing("Line",{From=Vector2.new(v1.X,v1.Y),To=Vector2.new(v2.X,v2.Y),Color=color,Thickness=2,Visible=true}) end end
function Functions.HandleRejoin() pcall(TeleportService.Teleport, TeleportService, game.PlaceId, LocalPlayer) end

local Window = SkyLib:CreateWindow("Project: SKYNET V3.2")
local EspTab, AimTab, MiscTab = Window:MakeTab("ESP"), Window:MakeTab("Aim"), Window:MakeTab("Misc")

AimTab:AddToggle({ Name = "Aimbot", Default = false, Callback = function(v) Config.Aimbot.Enabled = v end })
AimTab:AddToggle({ Name = "Trigger Aim on Fire", Default = false, Callback = function(v) Config.Aimbot.Trigger = v end })
AimTab:AddToggle({ Name = "Show FOV Circle", Default = true, Callback = function(v) Config.Aimbot.ShowFOV = v end })
AimTab:AddSlider({ Name = "FOV Size", Min = 1, Max = 100, Default = 30, Suffix = "%", Callback = function(v) Config.Aimbot.FOV = v end })
AimTab:AddButton({ Name = "Cycle Aim Part: Head", Callback = function(btn)
    if Config.Aimbot.Part == "Head" then Config.Aimbot.Part = "HumanoidRootPart"; btn.Text = "Cycle Aim Part: HRP"
    elseif Config.Aimbot.Part == "HumanoidRootPart" then Config.Aimbot.Part = "Torso"; btn.Text = "Cycle Aim Part: Torso"
    else Config.Aimbot.Part = "Head"; btn.Text = "Cycle Aim Part: Head" end
end})

EspTab:AddToggle({ Name = "Enable ESP", Default = false, Callback = function(v) Config.ESP.Enabled = v end })
EspTab:AddToggle({ Name = "Boxes", Default = false, Callback = function(v) Config.ESP.Boxes = v end })
EspTab:AddToggle({ Name = "Names", Default = false, Callback = function(v) Config.ESP.Names = v end })
EspTab:AddToggle({ Name = "Health Bars", Default = false, Callback = function(v) Config.ESP.Health = v end })
EspTab:AddToggle({ Name = "Distance", Default = false, Callback = function(v) Config.ESP.Distance = v end })
EspTab:AddToggle({ Name = "Tracers", Default = false, Callback = function(v) Config.ESP.Tracers = v end })
EspTab:AddToggle({ Name = "Skeletons", Default = false, Callback = function(v) Config.ESP.Skeletons = v end })
EspTab:AddToggle({ Name = "LookAt Lines", Default = false, Callback = function(v) Config.ESP.LookAt = v end })
EspTab:AddToggle({ Name = "Head Dots", Default = false, Callback = function(v) Config.ESP.HeadDots = v end })
EspTab:AddToggle({ Name = "Use Team Color", Default = false, Callback = function(v) Config.ESP.TeamColor = v end })

MiscTab:AddButton({ Name = "Rejoin Server", Callback = Functions.HandleRejoin })

RunService.RenderStepped:Connect(function()
    for _, obj in ipairs(ESP_Objects) do obj:Remove() end; ESP_Objects = {}
    Functions.UpdateAimbotTarget()
    Functions.ExecuteCameraAimbot()
    Functions.ExecuteTriggerAimbot()
    Functions.DrawFOVCircle()
    if not Config.ESP.Enabled then return end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.Humanoid.Health > 0 then
            local rootPart, head, humanoid = player.Character.HumanoidRootPart, player.Character:FindFirstChild("Head"), player.Character.Humanoid
            local pos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
            if onScreen and head then
                local headPos = Camera:WorldToViewportPoint(head.Position)
                local color = Config.ESP.TeamColor and player.TeamColor.Color or Config.ESP.Color
                local boxHeight = math.abs(headPos.Y - pos.Y) * 1.15; local boxWidth = boxHeight / 2
                local boxTopLeft = Vector2.new(pos.X - boxWidth / 2, headPos.Y - boxHeight * 0.1)
                if Config.ESP.Tracers then Functions.DrawESP_Tracers(color, pos) end
                if Config.ESP.Boxes then Functions.DrawESP_Boxes(color, boxTopLeft, boxWidth, boxHeight) end
                if Config.ESP.Names then Functions.DrawESP_Names(player, color, boxTopLeft) end
                if Config.ESP.Distance then Functions.DrawESP_Distance(player, color, pos) end
                if Config.ESP.Health then Functions.DrawESP_Health(humanoid, boxTopLeft, boxHeight) end
                if Config.ESP.Skeletons then Functions.DrawESP_Skeletons(player, color) end
                if Config.ESP.HeadDots then Functions.DrawESP_HeadDots(color, headPos) end
                if Config.ESP.LookAt then Functions.DrawESP_LookAt(head, color) end
            end
        end
    end
end)
