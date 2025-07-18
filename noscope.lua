local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local mouse = LocalPlayer:GetMouse()
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")

local RYOFC_GUI = Instance.new("ScreenGui", CoreGui)
RYOFC_GUI.Name = "RYOFC_GUI_V2"
RYOFC_GUI.ResetOnSpawn = false
RYOFC_GUI.ZIndexBehavior = Enum.ZIndexBehavior.Global

local MainFrame = Instance.new("Frame", RYOFC_GUI)
MainFrame.Size = UDim2.new(0, 600, 0, 450)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
MainFrame.BorderSizePixel = 0
MainFrame.Draggable = true
MainFrame.Active = true

local UICornerMain = Instance.new("UICorner", MainFrame)
UICornerMain.CornerRadius = UDim.new(0, 8)

local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Header.BorderSizePixel = 0

local UICornerHeader = Instance.new("UICorner", Header)
UICornerHeader.CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "S K Y - G P T  |  E N G I N E E R E D  F O R  R Y O X F C"
Title.TextColor3 = Color3.fromRGB(180, 180, 180)
Title.Font = Enum.Font.Code
Title.TextSize = 16

local CloseButton = Instance.new("TextButton", Header)
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0.5, -15)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
CloseButton.Text = ""
CloseButton.MouseButton1Click:Connect(function() RYOFC_GUI:Destroy() end)
local UICornerClose = Instance.new("UICorner", CloseButton)
UICornerClose.CornerRadius = UDim.new(1, 0)

local ScrollingFrame = Instance.new("ScrollingFrame", MainFrame)
ScrollingFrame.Size = UDim2.new(1, -20, 1, -50)
ScrollingFrame.Position = UDim2.new(0, 10, 0, 40)
ScrollingFrame.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
ScrollingFrame.ScrollBarThickness = 6

local UIListLayout = Instance.new("UIListLayout", ScrollingFrame)
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local espObjects = {}
local espEnabled = {
    Master = true,
    Box = true,
    Name = true,
    Healthbar = true,
    Tracers = false,
    Skeleton = false,
    Distance = false,
    HeadDot = false,
    Weapon = false,
    Chams = false,
    Outline = true,
    ItemESP = false,
    VehicleESP = false
}
local aimbotEnabled = false
local aimbotTarget = nil
local fovRadius = 150
local fovCircle = nil
local noclipEnabled = false
local flyEnabled = false
local speedEnabled = false
local infiniteJumpEnabled = false
local fullbrightEnabled = false
local autoFarmEnabled = false

local function updateCanvasSize()
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
end

local function createCategory(title)
    local categoryFrame = Instance.new("Frame", ScrollingFrame)
    categoryFrame.Size = UDim2.new(1, 0, 0, 30)
    categoryFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    categoryFrame.BorderSizePixel = 0
    categoryFrame.LayoutOrder = #ScrollingFrame:GetChildren()
    local corner = Instance.new("UICorner", categoryFrame)
    corner.CornerRadius = UDim.new(0, 4)

    local label = Instance.new("TextLabel", categoryFrame)
    label.Size = UDim2.new(1, -10, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = title
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 15
    label.TextXAlignment = Enum.TextXAlignment.Left

    updateCanvasSize()
    return categoryFrame
end

local function createToggle(text, flagTable, flagKey, callback)
    local btn = Instance.new("TextButton", ScrollingFrame)
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    btn.LayoutOrder = #ScrollingFrame:GetChildren()
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 4)

    local label = Instance.new("TextLabel", btn)
    label.Size = UDim2.new(0.8, 0, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left

    local indicator = Instance.new("Frame", btn)
    indicator.Size = UDim2.new(0, 20, 0, 20)
    indicator.Position = UDim2.new(1, -35, 0.5, -10)
    indicator.BackgroundColor3 = flagTable[flagKey] and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
    local indCorner = Instance.new("UICorner", indicator)
    indCorner.CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(function()
        flagTable[flagKey] = not flagTable[flagKey]
        indicator.BackgroundColor3 = flagTable[flagKey] and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
        if callback then
            callback(flagTable[flagKey])
        end
    end)
    updateCanvasSize()
    return btn
end

local function createButton(text, callback)
    local btn = Instance.new("TextButton", ScrollingFrame)
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Text = text
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 14
    btn.LayoutOrder = #ScrollingFrame:GetChildren()
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 4)
    btn.MouseButton1Click:Connect(callback)
    updateCanvasSize()
    return btn
end

local drawingObjects = {}
local function clearDrawings(player)
    if drawingObjects[player] then
        for _, v in pairs(drawingObjects[player]) do
            v:Remove()
        end
        drawingObjects[player] = nil
    end
end

local function updateESP()
    for player, espTbl in pairs(espObjects) do
        local character = player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")

        local onScreen = false
        local screenPos
        if rootPart then
             screenPos, onScreen = Workspace.CurrentCamera:WorldToScreenPoint(rootPart.Position)
        end

        if not (player and player.Parent and character and humanoid and rootPart and humanoid.Health > 0 and onScreen and player ~= LocalPlayer) then
            if espTbl.Holder.Enabled then espTbl.Holder.Enabled = false end
            clearDrawings(player)
            continue
        end

        if not espTbl.Holder.Enabled then espTbl.Holder.Enabled = true end

        local head = character:FindFirstChild("Head")
        local headPos, headOnScreen = Workspace.CurrentCamera:WorldToScreenPoint(head.Position)
        local rootPos, rootOnScreen = Workspace.CurrentCamera:WorldToScreenPoint(rootPart.Position)
        
        local boxHeight = math.abs(headPos.Y - rootPos.Y)
        local boxWidth = boxHeight / 2
        local boxPos = Vector2.new(headPos.X - boxWidth / 2, headPos.Y)

        espTbl.Box.Visible = espEnabled.Box and espEnabled.Master
        espTbl.Box.Position = UDim2.fromOffset(boxPos.X, boxPos.Y)
        espTbl.Box.Size = UDim2.fromOffset(boxWidth, boxHeight)
        espTbl.Box.Color = player.TeamColor.Color

        espTbl.BoxOutline.Visible = espEnabled.Box and espEnabled.Outline and espEnabled.Master
        espTbl.BoxOutline.Position = UDim2.fromOffset(boxPos.X-1, boxPos.Y-1)
        espTbl.BoxOutline.Size = UDim2.fromOffset(boxWidth+2, boxHeight+2)

        espTbl.Name.Visible = espEnabled.Name and espEnabled.Master
        espTbl.Name.Position = UDim2.fromOffset(boxPos.X + boxWidth/2, boxPos.Y - 18)
        espTbl.Name.Text = player.DisplayName

        espTbl.Distance.Visible = espEnabled.Distance and espEnabled.Master
        local distance = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).magnitude)
        espTbl.Distance.Text = "[" .. distance .. "m]"
        espTbl.Distance.Position = UDim2.fromOffset(boxPos.X + boxWidth/2, boxPos.Y + boxHeight + 2)

        espTbl.HealthBar.Visible = espEnabled.Healthbar and espEnabled.Master
        espTbl.HealthBar.Position = UDim2.fromOffset(boxPos.X - 7, boxPos.Y)
        espTbl.HealthBar.Size = UDim2.fromOffset(4, boxHeight)
        
        local health = humanoid.Health / humanoid.MaxHealth
        espTbl.HealthFill.Size = UDim2.new(1, 0, health, 0)
        espTbl.HealthFill.Position = UDim2.new(0, 0, 1 - health, 0)
        espTbl.HealthFill.BackgroundColor3 = Color3.fromHSV(0.33 * health, 1, 1)
        
        clearDrawings(player)
        drawingObjects[player] = {}

        if espEnabled.Tracers and espEnabled.Master then
            local tracer = Drawing.new("Line")
            tracer.From = Vector2.new(Workspace.CurrentCamera.ViewportSize.X / 2, Workspace.CurrentCamera.ViewportSize.Y)
            tracer.To = Vector2.new(rootPos.X, rootPos.Y)
            tracer.Color = player.TeamColor.Color
            tracer.Thickness = 2
            table.insert(drawingObjects[player], tracer)
        end

        if espEnabled.HeadDot and espEnabled.Master then
             local dot = Drawing.new("Circle")
             dot.Radius = 4
             dot.Position = Vector2.new(headPos.X, headPos.Y)
             dot.Color = Color3.new(1,0,0)
             dot.Filled = true
             table.insert(drawingObjects[player], dot)
        end
    end
end


local function setupPlayer(player)
    if espObjects[player] then return end
    
    local holder = Instance.new("BillboardGui")
    holder.Name = player.Name .. "_ESP_HOLDER"
    holder.AlwaysOnTop = true
    holder.Size = UDim2.new(0, 0, 0, 0)
    holder.Adornee = Workspace
    holder.Enabled = false
    
    local boxOutline = Instance.new("Frame", holder)
    boxOutline.BackgroundColor3 = Color3.new(0,0,0)
    boxOutline.BorderSizePixel = 0

    local box = Instance.new("Frame", holder)
    box.BackgroundColor3 = Color3.new(1, 1, 1)
    box.BorderSizePixel = 1

    local name = Instance.new("TextLabel", holder)
    name.BackgroundTransparency = 1
    name.Font = Enum.Font.Gotham
    name.TextSize = 14
    name.TextColor3 = Color3.new(1, 1, 1)
    name.TextStrokeTransparency = 0.5
    
    local distance = Instance.new("TextLabel", holder)
    distance.BackgroundTransparency = 1
    distance.Font = Enum.Font.Gotham
    distance.TextSize = 12
    distance.TextColor3 = Color3.new(1, 1, 1)
    distance.TextStrokeTransparency = 0.5

    local healthBar = Instance.new("Frame", holder)
    healthBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    healthBar.BorderSizePixel = 0

    local healthFill = Instance.new("Frame", healthBar)
    healthFill.BorderSizePixel = 0

    espObjects[player] = {
        Holder = holder,
        Box = box,
        BoxOutline = boxOutline,
        Name = name,
        HealthBar = healthBar,
        HealthFill = healthFill,
        Distance = distance,
    }
    
    holder.Parent = CoreGui
end

local function cleanupPlayer(player)
    if espObjects[player] then
        clearDrawings(player)
        espObjects[player].Holder:Destroy()
        espObjects[player] = nil
    end
end

local function fly()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local rootPart = LocalPlayer.Character.HumanoidRootPart
    
    local bodyGyro = Instance.new("BodyGyro")
    bodyGyro.P = 9e4
    bodyGyro.D = 1e3
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.CFrame = rootPart.CFrame
    bodyGyro.Parent = rootPart
    
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0,0,0)
    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyVelocity.Parent = rootPart

    while flyEnabled and LocalPlayer.Character and rootPart and rootPart.Parent do
        local camDir = Workspace.CurrentCamera.CFrame.LookVector
        local moveVec = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVec += camDir end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVec -= camDir end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVec += Workspace.CurrentCamera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVec -= Workspace.CurrentCamera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVec += Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveVec -= Vector3.new(0,1,0) end
        
        bodyVelocity.Velocity = moveVec.Unit * 50
        bodyGyro.CFrame = Workspace.CurrentCamera.CFrame
        RunService.RenderStepped:Wait()
    end
    
    bodyGyro:Destroy()
    bodyVelocity:Destroy()
end

createCategory("ESP")
createToggle("Master Switch", espEnabled, "Master")
createToggle("Box", espEnabled, "Box")
createToggle("Box Outline", espEnabled, "Outline")
createToggle("Name", espEnabled, "Name")
createToggle("Healthbar", espEnabled, "Healthbar")
createToggle("Tracers", espEnabled, "Tracers")
createToggle("Head Dot", espEnabled, "HeadDot")
createToggle("Distance", espEnabled, "Distance")
createToggle("Skeleton", espEnabled, "Skeleton")
createToggle("Chams", espEnabled, "Chams")
createToggle("Weapon ESP", espEnabled, "Weapon")
createToggle("Item ESP", espEnabled, "ItemESP")
createToggle("Vehicle ESP", espEnabled, "VehicleESP")

createCategory("Combat")
createToggle("Aimbot", {value=aimbotEnabled}, "value", function(state) aimbotEnabled = state end)
createButton("Silent Aim", function() end)
createButton("Aim Prediction", function() end)
createButton("No Recoil / Spread", function() end)
createButton("Instant Reload", function() end)
createButton("Rapid Fire", function() end)
createButton("Auto Kill All", function() end)

createCategory("Movement")
createToggle("Fly", {value=flyEnabled}, "value", function(state) flyEnabled = state; if state then fly() end end)
createToggle("Noclip", {value=noclipEnabled}, "value", function(state) noclipEnabled = state end)
createToggle("Speed Hack", {value=speedEnabled}, "value", function(state) speedEnabled = state; LocalPlayer.Character.Humanoid.WalkSpeed = state and 50 or 16 end)
createToggle("Infinite Jump", {value=infiniteJumpEnabled}, "value", function(state) infiniteJumpEnabled = state end)
createButton("Spider-Man (Climb)", function() end)
createButton("Click Teleport", function() end)

createCategory("World")
createToggle("Fullbright", {value=fullbrightEnabled}, "value", function(state) fullbrightEnabled = state; Lighting.Ambient = state and Color3.new(1,1,1) or Color3.new(0.5,0.5,0.5); Lighting.ColorCorrection.Brightness = state and 0.2 or 0 end)
createButton("Remove Fog", function() Lighting.FogEnd = 100000 end)
createButton("Set Time: Day", function() Lighting.ClockTime = 14 end)
createButton("Set Time: Night", function() Lighting.ClockTime = 0 end)
createButton("Remove Textures", function() end)
createButton("Wireframe Mode", function() end)

createCategory("Utility")
createToggle("Auto Farm Mobs", {value=autoFarmEnabled}, "value", function(state) autoFarmEnabled = state end)
createButton("Anti-AFK", function() game:GetService("Players").LocalPlayer.Idled:connect(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()); end) end)
createButton("Server Hop", function() game:GetService("TeleportService"):Teleport(game.PlaceId) end)
createButton("Rejoin Server", function() game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end)
createButton("Chat Spammer", function() end)
createButton("Auto Respawn", function() end)

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        setupPlayer(player)
    end
end

Players.PlayerAdded:Connect(setupPlayer)
Players.PlayerRemoving:Connect(cleanupPlayer)

RunService.RenderStepped:Connect(function()
    if noclipEnabled and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
    updateESP()
end)

UserInputService.JumpRequest:Connect(function()
    if infiniteJumpEnabled then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

updateCanvasSize()
