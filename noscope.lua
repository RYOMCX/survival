local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local mouse = LocalPlayer:GetMouse()
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UIS = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

-- GUI Setup
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "RYOFC_GUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 500, 0, 500)
frame.Position = UDim2.new(0.5, -250, 0.5, -250)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Draggable = true
frame.Active = true

local uiList = Instance.new("UIListLayout", frame)
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Padding = UDim.new(0, 4)

-- ESP Variables
local espObjects = {}
local espEnabled = false
local boxEnabled = false
local nameEnabled = false
local healthbarEnabled = false
local lineEnabled = false
local chamsEnabled = false
local xrayEnabled = false

-- Aimbot Variables
local aimbotEnabled = false
local aimbotTarget = nil
local fovCircle
local fovRadius = 100
local triggerBotEnabled = false

-- Movement Hacks
local noclipEnabled = false
local flyEnabled = false
local speedEnabled = false
local infiniteJumpEnabled = false

-- Visual Mods
local fullbrightEnabled = false
local noFogEnabled = false
local dayTimeEnabled = false
local thirdPersonEnabled = false
local viewmodelEnabled = true

-- Other
local antiAfkEnabled = false
local autoCollectEnabled = false
local autoFarmEnabled = false
local gravityEnabled = true

-- UI Creation Functions
local function createCategory(title)
    local cat = Instance.new("Frame", frame)
    cat.Size = UDim2.new(1, -20, 0, 30)
    cat.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    cat.LayoutOrder = #frame:GetChildren()

    local label = Instance.new("TextLabel", cat)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = title
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 16

    return cat
end

local function createButton(text, callback)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Text = text
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.MouseButton1Click:Connect(callback)
    btn.LayoutOrder = #frame:GetChildren()
    return btn
end

-- ESP Functions
local function createESP(player)
    local character = player.Character or player.CharacterAdded:Wait()
    local holder = Instance.new("Folder", CoreGui)
    holder.Name = player.Name.."_ESP"
    
    local box = Instance.new("BoxHandleAdornment", holder)
    box.Name = "Box"
    box.Adornee = character:WaitForChild("HumanoidRootPart")
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Size = Vector3.new(3, 6, 3)
    box.Color3 = player.TeamColor.Color
    box.Transparency = 0.5
    box.Visible = false
    
    local nameTag = Instance.new("BillboardGui", holder)
    nameTag.Name = "NameTag"
    nameTag.Adornee = character:WaitForChild("Head")
    nameTag.Size = UDim2.new(0, 200, 0, 50)
    nameTag.StudsOffset = Vector3.new(0, 2.5, 0)
    nameTag.AlwaysOnTop = true
    
    local tag = Instance.new("TextLabel", nameTag)
    tag.Size = UDim2.new(1, 0, 1, 0)
    tag.BackgroundTransparency = 1
    tag.Text = player.Name
    tag.TextColor3 = Color3.new(1, 1, 1)
    tag.TextStrokeTransparency = 0
    tag.Font = Enum.Font.GothamBold
    tag.TextSize = 18
    tag.Visible = false
    
    local healthBar = Instance.new("Frame", holder)
    healthBar.Name = "HealthBar"
    healthBar.Size = UDim2.new(0, 30, 0, 100)
    healthBar.Position = UDim2.new(0, 0, 0, -120)
    healthBar.BackgroundColor3 = Color3.new(0,0,0)
    healthBar.BorderSizePixel = 2
    
    local healthFill = Instance.new("Frame", healthBar)
    healthFill.Size = UDim2.new(1, 0, 1, 0)
    healthFill.BackgroundColor3 = Color3.new(0,1,0)
    healthFill.BorderSizePixel = 0
    
    local line = Instance.new("Frame", holder)
    line.Name = "Line"
    line.BorderSizePixel = 0
    line.BackgroundColor3 = Color3.new(1,1,1)
    line.Size = UDim2.new(0, 2, 0, 1000)
    line.Visible = false
    
    espObjects[player] = {
        holder = holder,
        box = box,
        nameTag = nameTag,
        healthBar = healthBar,
        healthFill = healthFill,
        line = line
    }
end

local function updateESP()
    for player, esp in pairs(espObjects) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local root = player.Character.HumanoidRootPart
            local head = player.Character:FindFirstChild("Head")
            
            -- Box ESP
            esp.box.Visible = boxEnabled and espEnabled
            esp.box.Adornee = root
            
            -- Name ESP
            esp.nameTag.Enabled = nameEnabled and espEnabled
            if head then
                esp.nameTag.Adornee = head
            end
            
            -- Healthbar
            esp.healthBar.Visible = healthbarEnabled and espEnabled
            if player.Character:FindFirstChild("Humanoid") then
                local health = player.Character.Humanoid.Health
                local maxHealth = player.Character.Humanoid.MaxHealth
                esp.healthFill.Size = UDim2.new(1, 0, health/maxHealth, 0)
                esp.healthFill.Position = UDim2.new(0, 0, 1 - (health/maxHealth), 0)
                esp.healthFill.BackgroundColor3 = Color3.new(1 - (health/maxHealth), health/maxHealth, 0)
            end
            
            -- Line ESP
            esp.line.Visible = lineEnabled and espEnabled
            if lineEnabled then
                esp.line.Position = UDim2.new(0.5, 0, 0.5, 0)
                local angle = math.atan2(root.Position.Z - LocalPlayer.Character.HumanoidRootPart.Position.Z, 
                                        root.Position.X - LocalPlayer.Character.HumanoidRootPart.Position.X)
                esp.line.Rotation = math.deg(angle)
            end
        end
    end
end

-- Aimbot Functions
local function createFOVCircle()
    if fovCircle then fovCircle:Destroy() end
    
    fovCircle = Drawing.new("Circle")
    fovCircle.Visible = false
    fovCircle.Radius = fovRadius
    fovCircle.Color = Color3.new(1,1,1)
    fovCircle.Thickness = 2
    fovCircle.Position = Vector2.new(Workspace.CurrentCamera.ViewportSize.X/2, Workspace.CurrentCamera.ViewportSize.Y/2)
end

local function findTarget()
    local closestPlayer = nil
    local maxDist = fovRadius
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local screenPos, onScreen = Workspace.CurrentCamera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            local distance = (Vector2.new(screenPos.X, screenPos.Y) - fovCircle.Position).Magnitude
            
            if onScreen and distance < maxDist then
                closestPlayer = player
                maxDist = distance
            end
        end
    end
    
    return closestPlayer
end

local function aimAt(target)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local camera = Workspace.CurrentCamera
        camera.CFrame = CFrame.new(camera.CFrame.Position, target.Character.HumanoidRootPart.Position)
    end
end

-- Movement Hacks
local function fly()
    local bodyGyro = Instance.new("BodyGyro")
    local bodyVelocity = Instance.new("BodyVelocity")
    
    bodyGyro.P = 9e4
    bodyGyro.D = 1e3
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
    
    bodyVelocity.Velocity = Vector3.new(0,0,0)
    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    
    bodyGyro.Parent = LocalPlayer.Character.HumanoidRootPart
    bodyVelocity.Parent = LocalPlayer.Character.HumanoidRootPart
    
    while flyEnabled do
        local camDir = Workspace.CurrentCamera.CFrame.LookVector
        local moveVec = Vector3.new()
        
        if UIS:IsKeyDown(Enum.KeyCode.W) then moveVec += camDir end
        if UIS:IsKeyDown(Enum.KeyCode.S) then moveVec -= camDir end
        if UIS:IsKeyDown(Enum.KeyCode.D) then moveVec += Workspace.CurrentCamera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then moveVec -= Workspace.CurrentCamera.CFrame.RightVector end
        
        bodyVelocity.Velocity = moveVec * 100
        bodyGyro.CFrame = Workspace.CurrentCamera.CFrame
        RunService.RenderStepped:Wait()
    end
    
    bodyGyro:Destroy()
    bodyVelocity:Destroy()
end

-- Visual Mods
local function updateLighting()
    Lighting.ClockTime = dayTimeEnabled and 12 or 14
    Lighting.FogEnd = noFogEnabled and 9e9 or 1000
    Lighting.GlobalShadows = not fullbrightEnabled
    Lighting.Ambient = fullbrightEnabled and Color3.new(1,1,1) or Color3.new(0,0,0)
end

-- Auto Collect
local function collectItems()
    while autoCollectEnabled do
        for _, item in ipairs(Workspace:GetChildren()) do
            if item.Name == "Item" and item:IsA("BasePart") then
                local distance = (LocalPlayer.Character.HumanoidRootPart.Position - item.Position).Magnitude
                if distance < 50 then
                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, item, 0)
                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, item, 1)
                end
            end
        end
        wait(1)
    end
end

-- Create UI Elements
createCategory("ESP Features")
createButton("Toggle ESP", function()
    espEnabled = not espEnabled
    updateESP()
end)
createButton("ESP Box", function()
    boxEnabled = not boxEnabled
    updateESP()
end)
createButton("ESP Line", function()
    lineEnabled = not lineEnabled
    updateESP()
end)
createButton("ESP Name", function()
    nameEnabled = not nameEnabled
    updateESP()
end)
createButton("ESP Healthbar", function()
    healthbarEnabled = not healthbarEnabled
    updateESP()
end)
createButton("Chams", function()
    chamsEnabled = not chamsEnabled
    -- Implementation would modify player materials
end)
createButton("X-Ray", function()
    xrayEnabled = not xrayEnabled
    for _, part in ipairs(Workspace:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.LocalTransparencyModifier = xrayEnabled and 0.7 or 0
        end
    end
end)

createCategory("Combat")
createButton("Aimbot", function()
    aimbotEnabled = not aimbotEnabled
    fovCircle.Visible = aimbotEnabled
end)
createButton("Trigger Bot", function()
    triggerBotEnabled = not triggerBotEnabled
end)
createButton("Auto Kill", function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            -- Implementation would depend on game mechanics
        end
    end
end)
createButton("Auto Headshot", function()
    -- Headshot logic would go here
end)

createCategory("Movement")
createButton("Fly", function()
    flyEnabled = not flyEnabled
    if flyEnabled then fly() end
end)
createButton("Noclip", function()
    noclipEnabled = not noclipEnabled
    if noclipEnabled then
        LocalPlayer.Character.Humanoid:ChangeState(11)
    end
end)
createButton("Speed Hack", function()
    speedEnabled = not speedEnabled
    LocalPlayer.Character.Humanoid.WalkSpeed = speedEnabled and 50 or 16
end)
createButton("Infinite Jump", function()
    infiniteJumpEnabled = not infiniteJumpEnabled
end)
createButton("No Gravity", function()
    gravityEnabled = not gravityEnabled
    Workspace.Gravity = gravityEnabled and 196.2 or 0
end)
createButton("Teleport to Spawn", function()
    LocalPlayer.Character:MoveTo(Vector3.new(0,10,0))
end)

createCategory("Visual")
createButton("Fullbright", function()
    fullbrightEnabled = not fullbrightEnabled
    updateLighting()
end)
createButton("No Fog", function()
    noFogEnabled = not noFogEnabled
    updateLighting()
end)
createButton("Day Time", function()
    dayTimeEnabled = not dayTimeEnabled
    updateLighting()
end)
createButton("Third Person", function()
    thirdPersonEnabled = not thirdPersonEnabled
    Workspace.CurrentCamera.CameraType = thirdPersonEnabled and Enum.CameraType.Scriptable or Enum.CameraType.Custom
end)
createButton("Hide Viewmodels", function()
    viewmodelEnabled = not viewmodelEnabled
    LocalPlayer.Character.Humanoid:SetAttribute("ViewmodelVisible", viewmodelEnabled)
end)
createButton("FOV Circle", function()
    createFOVCircle()
    fovCircle.Visible = not fovCircle.Visible
end)
createButton("Increase POV Size", function()
    fovRadius += 10
    if fovCircle then fovCircle.Radius = fovRadius end
end)
createButton("Decrease POV Size", function()
    fovRadius = math.max(10, fovRadius - 10)
    if fovCircle then fovCircle.Radius = fovRadius end
end)

createCategory("Automation")
createButton("Anti-AFK", function()
    antiAfkEnabled = not antiAfkEnabled
    if antiAfkEnabled then
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, nil)
    end
end)
createButton("Auto Collect", function()
    autoCollectEnabled = not autoCollectEnabled
    if autoCollectEnabled then collectItems() end
end)
createButton("Auto Farm", function()
    autoFarmEnabled = not autoFarmEnabled
    -- Farm implementation would be game-specific
end)

createCategory("Gamepass")
local selectedGP = nil
createButton("Choose Gamepass: [Balloon]", function()
    selectedGP = "Balloon"
end)
createButton("Choose Gamepass: [Gravity Coil]", function()
    selectedGP = "GravityCoil"
end)
createButton("OK Get Free Pass", function()
    if selectedGP == "Balloon" then
        game:GetService("ReplicatedStorage").Events.BuyGamepass:FireServer("Balloon")
    elseif selectedGP == "GravityCoil" then
        game:GetService("ReplicatedStorage").Events.BuyGamepass:FireServer("GravityCoil")
    end
end)

createCategory("UI Mode")
createButton("Dark Mode", function()
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
end)
createButton("Bright Mode", function()
    frame.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
end)

-- Close Button
local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0, 50, 0, 25)
close.Position = UDim2.new(1, -55, 0, 5)
close.Text = "X"
close.TextColor3 = Color3.new(1, 0, 0)
close.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Minimize Button
local minimize = Instance.new("TextButton", frame)
minimize.Size = UDim2.new(0, 80, 0, 25)
minimize.Position = UDim2.new(1, -145, 0, 5)
minimize.Text = "-"
minimize.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
minimize.TextColor3 = Color3.new(1, 1, 1)

local minimized = false
local labelRyofc

minimize.MouseButton1Click:Connect(function()
    if not minimized then
        frame.Visible = false
        labelRyofc = Instance.new("TextButton", gui)
        labelRyofc.Text = "RYOFC Hack"
        labelRyofc.Size = UDim2.new(0, 120, 0, 40)
        labelRyofc.Position = UDim2.new(0.5, -60, 1, -60)
        labelRyofc.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
        labelRyofc.TextColor3 = Color3.new(1, 1, 1)
        labelRyofc.MouseButton1Click:Connect(function()
            frame.Visible = true
            labelRyofc:Destroy()
        end)
        minimized = true
    end
end)

-- Initialize ESP
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        createESP(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    createESP(player)
end)

Players.PlayerRemoving:Connect(function(player)
    if espObjects[player] then
        espObjects[player].holder:Destroy()
        espObjects[player] = nil
    end
end)

-- Runtime Loops
RunService.Stepped:Connect(function()
    -- Noclip
    if noclipEnabled and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
    
    -- ESP Update
    updateESP()
    
    -- Aimbot
    if aimbotEnabled then
        aimbotTarget = findTarget()
        if aimbotTarget then
            aimAt(aimbotTarget)
        end
    end
    
    -- Trigger Bot
    if triggerBotEnabled then
        -- Implementation would check if mouse is over enemy
    end
end)

UIS.JumpRequest:Connect(function()
    if infiniteJumpEnabled then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- Initialize FOV Circle
createFOVCircle()
