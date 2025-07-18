local Players, RunService, CoreGui, UserInputService, TweenService = game:GetService("Players"), game:GetService("RunService"), game:GetService("CoreGui"), game:GetService("UserInputService"), game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local mouse = LocalPlayer:GetMouse()

local env = getgenv()
env.Settings = {
    ESP_Enabled = false,
    SilentAim_Enabled = false,
    MagicBullet_Enabled = false,
    Accuracy = 100,
    WalkSpeed = 16,
    JumpPower = 50,
    FieldOfView = 70,
    Fly_Enabled = false,
    Chams_Enabled = false,
    ESP_ShowBox = true,
    ESP_ShowName = true,
    ESP_ShowHealth = true,
    ESP_ShowDistance = true,
    ESP_ShowTracer = false,
    ThirdPerson_Enabled = false,
    InfAmmo_Enabled = false,
    NoRecoil_Enabled = false,
    FOVCircle_Visible = true,
    FOVCircle_Size = 80,
    SpeedHack_Enabled = false,
    JumpHack_Enabled = false
}
env.ESP_Players = {}
env.Connections = {}

-- Badge System
local badge = Instance.new("ScreenGui", CoreGui)
badge.Name = "RyofcBadge"
badge.ResetOnSpawn = false
badge.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
badge.Enabled = true

local badgeFrame = Instance.new("Frame", badge)
badgeFrame.Size = UDim2.new(0, 150, 0, 40)
badgeFrame.Position = UDim2.new(1, -160, 1, -50)
badgeFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
badgeFrame.BorderSizePixel = 0
Instance.new("UICorner", badgeFrame).CornerRadius = UDim.new(0, 8)

local badgeText = Instance.new("TextLabel", badgeFrame)
badgeText.Size = UDim2.new(1, 0, 1, 0)
badgeText.Text = "ryofc hack: ON"
badgeText.Font = Enum.Font.GothamBold
badgeText.TextSize = 14
badgeText.TextColor3 = Color3.fromRGB(0, 255, 127)
badgeText.BackgroundTransparency = 1

-- Loading Screen
local loadingGui = Instance.new("ScreenGui", CoreGui)
loadingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
local loadingFrame = Instance.new("Frame", loadingGui)
loadingFrame.Size = UDim2.new(0, 250, 0, 80)
loadingFrame.Position = UDim2.new(0.5, -125, 0.5, -40)
loadingFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
loadingFrame.BorderSizePixel = 0
local loadingCorner = Instance.new("UICorner", loadingFrame)
loadingCorner.CornerRadius = UDim.new(0, 12)
local loadingLabel = Instance.new("TextLabel", loadingFrame)
loadingLabel.Size = UDim2.new(1, 0, 1, 0)
loadingLabel.Text = "ryofc script loaded!"
loadingLabel.Font = Enum.Font.GothamBold
loadingLabel.TextSize = 18
loadingLabel.TextColor3 = Color3.fromRGB(0, 255, 127)
loadingLabel.BackgroundTransparency = 1
task.wait(2.5)
loadingGui:Destroy()

-- Main GUI
local mainGui = Instance.new("ScreenGui", CoreGui)
mainGui.Name = "RyofcMainGUI"
mainGui.ResetOnSpawn = false
mainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local mainFrame = Instance.new("Frame", mainGui)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
local aspectRatio = Instance.new("UIAspectRatioConstraint", mainFrame)
aspectRatio.AspectRatio = 1.5

local header = Instance.new("Frame", mainFrame)
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1, -80, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.Text = "ryofc arcade hack"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(0, 255, 127)
title.TextXAlignment = Enum.TextXAlignment.Left
title.BackgroundTransparency = 1

-- Minimize Button
local minimize = Instance.new("TextButton", header)
minimize.Text = "─"
minimize.Size = UDim2.new(0, 30, 0, 30)
minimize.Position = UDim2.new(1, -70, 0, 5)
minimize.Font = Enum.Font.GothamBold
minimize.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
Instance.new("UICorner", minimize).CornerRadius = UDim.new(0, 6)
minimize.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

-- Close Button
local close = Instance.new("TextButton", header)
close.Text = "❌"
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -35, 0, 5)
close.Font = Enum.Font.GothamBold
close.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 6)
close.MouseButton1Click:Connect(function() 
    mainGui:Destroy()
    badge:Destroy()
    fovCircle:Remove()
    for _, conn in pairs(env.Connections) do
        conn:Disconnect()
    end
end)

local contentContainer = Instance.new("Frame", mainFrame)
contentContainer.Position = UDim2.new(0, 0, 0, 40)
contentContainer.BackgroundTransparency = 1
local contentLayout = Instance.new("UIListLayout", contentContainer)
contentLayout.Padding = UDim.new(0, 10)
contentLayout.FillDirection = Enum.FillDirection.Horizontal
contentLayout.VerticalAlignment = Enum.VerticalAlignment.Top

local leftColumn = Instance.new("ScrollingFrame", contentContainer)
leftColumn.BackgroundTransparency = 1
leftColumn.BorderSizePixel = 0
leftColumn.ScrollBarThickness = 5
leftColumn.AutomaticCanvasSize = Enum.AutomaticSize.Y
local leftLayout = Instance.new("UIListLayout", leftColumn)
leftLayout.Padding = UDim.new(0, 5)
leftLayout.SortOrder = Enum.SortOrder.LayoutOrder

local rightColumn = Instance.new("ScrollingFrame", contentContainer)
rightColumn.BackgroundTransparency = 1
rightColumn.BorderSizePixel = 0
rightColumn.ScrollBarThickness = 5
rightColumn.AutomaticCanvasSize = Enum.AutomaticSize.Y
local rightLayout = Instance.new("UIListLayout", rightColumn)
rightLayout.Padding = UDim.new(0, 5)
rightLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- FOV Circle Visualization
local fovCircle = Drawing.new("Circle")
fovCircle.Visible = env.Settings.FOVCircle_Visible
fovCircle.Radius = env.Settings.FOVCircle_Size
fovCircle.Thickness = 2
fovCircle.Color = Color3.fromRGB(0, 255, 127)
fovCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
fovCircle.Filled = false -- Only outline, no fill

-- ESP Window
local espWindow = Instance.new("Frame", mainGui)
espWindow.Size = UDim2.new(0, 300, 0, 400)
espWindow.Position = UDim2.new(0.5, -150, 0.5, -200)
espWindow.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
espWindow.Visible = false
espWindow.Draggable = true
espWindow.Active = true
Instance.new("UICorner", espWindow).CornerRadius = UDim.new(0, 12)
local espHeader = Instance.new("TextLabel", espWindow)
espHeader.Size = UDim2.new(1, 0, 0, 30)
espHeader.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
espHeader.Text = "ESP Player List"
espHeader.Font = Enum.Font.GothamBold
espHeader.TextColor3 = Color3.fromRGB(0, 255, 127)
Instance.new("UICorner", espHeader).CornerRadius = UDim.new(0, 6)
local espClose = Instance.new("TextButton", espHeader)
espClose.Size = UDim2.fromOffset(20, 20)
espClose.Position = UDim2.new(1, -25, 0.5, -10)
espClose.Text = "X"
espClose.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
espClose.MouseButton1Click:Connect(function() espWindow.Visible = false end)

local espOptions = Instance.new("Frame", espWindow)
espOptions.Size = UDim2.new(1, -10, 0, 100)
espOptions.Position = UDim2.new(0, 5, 0, 35)
espOptions.BackgroundTransparency = 1
local espOptionsLayout = Instance.new("UIGridLayout", espOptions)
espOptionsLayout.CellPadding = UDim2.fromOffset(5, 5)
espOptionsLayout.CellSize = UDim2.new(0.3, 0, 0.3, 0)

local playerList = Instance.new("ScrollingFrame", espWindow)
playerList.Size = UDim2.new(1, -10, 1, -145)
playerList.Position = UDim2.new(0, 5, 0, 140)
playerList.BackgroundColor3 = Color3.fromRGB(40,40,40)
playerList.BorderSizePixel = 0
Instance.new("UICorner", playerList)
local playerListLayout = Instance.new("UIListLayout", playerList)
playerListLayout.Padding = UDim.new(0, 2)
playerListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Improved Layout System
local function updateLayout()
    local vp = Camera.ViewportSize
    local isMobile = vp.X < 600
    
    mainFrame.Size = isMobile and UDim2.new(0.9, 0, 0.6, 0) or UDim2.new(0.5, 0, 0.6, 0)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    
    contentContainer.Size = UDim2.new(1, -20, 1, -50)
    contentContainer.Position = UDim2.new(0, 10, 0, 45)
    
    contentLayout.FillDirection = isMobile and Enum.FillDirection.Vertical or Enum.FillDirection.Horizontal
    
    leftColumn.Size = isMobile and UDim2.new(1, 0, 0.5, -5) or UDim2.new(0.5, -5, 1, 0)
    rightColumn.Size = isMobile and UDim2.new(1, 0, 0.5, -5) or UDim2.new(0.5, -5, 1, 0)
    
    leftColumn.CanvasSize = UDim2.new(0, 0, 0, leftLayout.AbsoluteContentSize.Y)
    rightColumn.CanvasSize = UDim2.new(0, 0, 0, rightLayout.AbsoluteContentSize.Y)
end

-- Enhanced Toggle Button
local function createToggleButton(text, parent, callback)
    local state = false
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Text = text .. ": OFF"
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 15
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    local highlight = Instance.new("Frame", btn)
    highlight.Size = UDim2.new(1, 0, 1, 0)
    highlight.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
    highlight.BorderSizePixel = 0
    Instance.new("UICorner", highlight).CornerRadius = UDim.new(0, 8)
    highlight.ZIndex = -1
    
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = state and (text .. ": ON") or (text .. ": OFF")
        highlight.BackgroundColor3 = state and Color3.fromRGB(0, 180, 80) or Color3.fromRGB(200, 30, 30)
        if callback then callback(state) end
    end)
    
    return btn
end

-- Fixed Slider System
local function createSlider(parent, labelText, minVal, maxVal, defaultVal, callback, enabledCallback)
    local sliderFrame = Instance.new("Frame", parent)
    sliderFrame.Size = UDim2.new(1, -10, 0, 50)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Name = labelText .. "SliderFrame"
    
    local label = Instance.new("TextLabel", sliderFrame)
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Font = Enum.Font.Gotham
    label.TextSize = 15
    label.TextColor3 = Color3.new(1,1,1)
    label.Text = labelText
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    
    local valueLabel = Instance.new("TextLabel", sliderFrame)
    valueLabel.Size = UDim2.new(0, 60, 0, 20)
    valueLabel.Position = UDim2.new(1, -60, 0, 0)
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.TextSize = 15
    valueLabel.TextColor3 = Color3.fromRGB(0, 255, 127)
    valueLabel.Text = tostring(defaultVal)
    valueLabel.BackgroundTransparency = 1
    
    local sliderBar = Instance.new("Frame", sliderFrame)
    sliderBar.Size = UDim2.new(1, 0, 0, 6)
    sliderBar.Position = UDim2.new(0, 0, 0, 30)
    sliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Instance.new("UICorner", sliderBar).CornerRadius = UDim.new(0, 3)
    
    local sliderFill = Instance.new("Frame", sliderBar)
    sliderFill.Size = UDim2.new(0.5, 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 255, 127)
    sliderFill.BorderSizePixel = 0
    Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(0, 3)
    
    local sliderHandle = Instance.new("TextButton", sliderBar)
    sliderHandle.Size = UDim2.new(0, 16, 0, 16)
    sliderHandle.Position = UDim2.new(0.5, -8, 0.5, -8)
    sliderHandle.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    sliderHandle.Text = ""
    Instance.new("UICorner", sliderHandle).CornerRadius = UDim.new(1, 0)
    
    local function updateSlider(value)
        local percentage = (value - minVal) / (maxVal - minVal)
        valueLabel.Text = tostring(math.floor(value))
        sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
        sliderHandle.Position = UDim2.new(percentage, -8, 0.5, -8)
        callback(value)
    end
    
    updateSlider(defaultVal)
    
    local dragging = false
    local function updateSliderFromInput(input)
        local pos = Vector2.new(input.Position.X, input.Position.Y)
        local relativeX = (pos.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X
        local newValue = minVal + math.clamp(relativeX, 0, 1) * (maxVal - minVal)
        updateSlider(newValue)
    end
    
    sliderHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    sliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            updateSliderFromInput(input)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSliderFromInput(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    -- Enable/disable based on toggle state
    if enabledCallback then
        local function updateSliderState(enabled)
            sliderHandle.Active = enabled
            sliderBar.Active = enabled
            sliderFill.BackgroundColor3 = enabled and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(100, 100, 100)
            sliderHandle.BackgroundColor3 = enabled and Color3.fromRGB(200, 200, 200) or Color3.fromRGB(150, 150, 150)
        end
        
        updateSliderState(enabledCallback())
    end
    
    return sliderFrame
end

-- Speed Hack Toggle
local speedToggle = createToggleButton("Speed Hack", leftColumn, function(s) 
    env.Settings.SpeedHack_Enabled = s 
    -- Update slider state
    local speedSlider = leftColumn:FindFirstChild("SpeedSliderFrame")
    if speedSlider then
        local sliderBar = speedSlider:FindFirstChild("Frame")
        local sliderFill = sliderBar and sliderBar:FindFirstChild("Frame")
        local sliderHandle = sliderBar and sliderBar:FindFirstChild("TextButton")
        
        if sliderFill and sliderHandle then
            sliderFill.BackgroundColor3 = s and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(100, 100, 100)
            sliderHandle.BackgroundColor3 = s and Color3.fromRGB(200, 200, 200) or Color3.fromRGB(150, 150, 150)
        end
    end
end)

-- Jump Hack Toggle
local jumpToggle = createToggleButton("Jump Hack", leftColumn, function(s) 
    env.Settings.JumpHack_Enabled = s 
    -- Update slider state
    local jumpSlider = leftColumn:FindFirstChild("JumpSliderFrame")
    if jumpSlider then
        local sliderBar = jumpSlider:FindFirstChild("Frame")
        local sliderFill = sliderBar and sliderBar:FindFirstChild("Frame")
        local sliderHandle = sliderBar and sliderBar:FindFirstChild("TextButton")
        
        if sliderFill and sliderHandle then
            sliderFill.BackgroundColor3 = s and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(100, 100, 100)
            sliderHandle.BackgroundColor3 = s and Color3.fromRGB(200, 200, 200) or Color3.fromRGB(150, 150, 150)
        end
    end
end)

-- FOV Circle Slider
createSlider(leftColumn, "FOV Size", 10, 200, env.Settings.FOVCircle_Size, function(v) 
    env.Settings.FOVCircle_Size = v
    fovCircle.Radius = v
end)

-- Other Sliders
createSlider(leftColumn, "Speed", 16, 200, 16, function(v) env.Settings.WalkSpeed = v end, function() 
    return env.Settings.SpeedHack_Enabled 
end)
createSlider(leftColumn, "Jump", 50, 300, 50, function(v) env.Settings.JumpPower = v end, function() 
    return env.Settings.JumpHack_Enabled 
end)
createSlider(leftColumn, "POV", 30, 120, 70, function(v) 
    env.Settings.FieldOfView = v
    Camera.FieldOfView = v
end)
createSlider(leftColumn, "Accuracy", 1, 100, 100, function(v) env.Settings.Accuracy = v end)

-- Toggles
createToggleButton("Silent Aim", leftColumn, function(s) env.Settings.SilentAim_Enabled = s end)
createToggleButton("Magic Bullet", leftColumn, function(s) env.Settings.MagicBullet_Enabled = s end)
createToggleButton("FOV Circle", leftColumn, function(s) 
    env.Settings.FOVCircle_Visible = s
    fovCircle.Visible = s
end)

createToggleButton("Toggle ESP", rightColumn, function(s) 
    espWindow.Visible = s 
    if s then updatePlayerList() end
end)
createToggleButton("Fly", rightColumn, function(s) env.Settings.Fly_Enabled = s end)
createToggleButton("Third Person", rightColumn, function(s) 
    env.Settings.ThirdPerson_Enabled = s
    LocalPlayer.CameraMode = s and Enum.CameraMode.Classic or Enum.CameraMode.LockFirstPerson
end)
createToggleButton("Infinite Ammo", rightColumn, function(s) env.Settings.InfAmmo_Enabled = s end)
createToggleButton("No Recoil", rightColumn, function(s) env.Settings.NoRecoil_Enabled = s end)

-- Unlock All Skins
local unlockBtn = Instance.new("TextButton", rightColumn)
unlockBtn.Size = UDim2.new(1, -10, 0, 30)
unlockBtn.Text = "UNLOCK ALL SKINS"
unlockBtn.Font = Enum.Font.GothamBold
unlockBtn.TextSize = 15
unlockBtn.TextColor3 = Color3.new(1, 1, 1)
unlockBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
Instance.new("UICorner", unlockBtn).CornerRadius = UDim.new(0, 8)
unlockBtn.MouseButton1Click:Connect(function()
    -- Placeholder for skin unlock functionality
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Skins Unlocked",
        Text = "All weapon skins have been unlocked!",
        Duration = 5
    })
end)

-- ESP Options
createToggleButton("Box", espOptions, function(s) env.Settings.ESP_ShowBox = s end)
createToggleButton("Chams", espOptions, function(s) env.Settings.Chams_Enabled = s end)
createToggleButton("Name", espOptions, function(s) env.Settings.ESP_ShowName = s end)
createToggleButton("Health", espOptions, function(s) env.Settings.ESP_ShowHealth = s end)
createToggleButton("Distance", espOptions, function(s) env.Settings.ESP_ShowDistance = s end)
createToggleButton("Tracer", espOptions, function(s) env.Settings.ESP_ShowTracer = s end)

-- Player List System
local function updatePlayerList()
    playerList:ClearAllChildren()
    playerListLayout = Instance.new("UIListLayout", playerList)
    playerListLayout.Padding = UDim.new(0, 2)
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            env.ESP_Players[player] = env.ESP_Players[player] or false
            local btn = createToggleButton(player.Name, playerList, function(s) 
                env.ESP_Players[player] = s 
            end)
        end
    end
end

-- Movement Control
local flyVelocity, flyGyro
local function updateFly()
    if flyVelocity then
        flyVelocity:Destroy()
        flyGyro:Destroy()
        flyVelocity = nil
        flyGyro = nil
    end

    if env.Settings.Fly_Enabled and LocalPlayer.Character then
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            flyVelocity = Instance.new("BodyVelocity", root)
            flyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            flyVelocity.Velocity = Vector3.new()
            
            flyGyro = Instance.new("BodyGyro", root)
            flyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        end
    end
end

-- ESP Drawing System
local drawings = {}
local highlights = {}

local function updateESP()
    for player, espOn in pairs(env.ESP_Players) do
        if not drawings[player] then
            drawings[player] = {
                box = Drawing.new("Square"),
                name = Drawing.new("Text"),
                health = Drawing.new("Line"),
                dist = Drawing.new("Text"),
                tracer = Drawing.new("Line")
            }
        end
        
        local d = drawings[player]
        local isVisible = false
        local char = player.Character
        
        if espOn and char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then
                local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
                if onScreen then
                    isVisible = true
                    local head = char:FindFirstChild("Head")
                    local headPos = head and Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                    
                    if headPos then
                        local h = math.abs(headPos.Y - pos.Y) * 2
                        local w = h * 0.6
                        
                        -- Box
                        d.box.Size = Vector2.new(w, h)
                        d.box.Position = Vector2.new(pos.X - w/2, pos.Y - h/2)
                        d.box.Color = Color3.fromRGB(0, 255, 0)
                        d.box.Thickness = 2
                        d.box.Visible = env.Settings.ESP_ShowBox and isVisible
                        d.box.Filled = false
                        
                        -- Name
                        d.name.Text = player.Name
                        d.name.Position = Vector2.new(pos.X, pos.Y - h/2 - 15)
                        d.name.Size = 15
                        d.name.Color = Color3.fromRGB(255, 255, 255)
                        d.name.Visible = env.Settings.ESP_ShowName and isVisible
                        d.name.Center = true
                        
                        -- Health bar
                        local healthPerc = char.Humanoid.Health / char.Humanoid.MaxHealth
                        local healthColor = Color3.fromRGB(255 * (1 - healthPerc), 255 * healthPerc, 0)
                        
                        d.health.From = Vector2.new(pos.X - w/2 - 5, pos.Y + h/2)
                        d.health.To = Vector2.new(pos.X - w/2 - 5, pos.Y - h/2 + h * (1 - healthPerc))
                        d.health.Color = healthColor
                        d.health.Thickness = 3
                        d.health.Visible = env.Settings.ESP_ShowHealth and isVisible
                        
                        -- Distance
                        local distance = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - root.Position).Magnitude)
                        d.dist.Text = "[" .. distance .. "m]"
                        d.dist.Position = Vector2.new(pos.X, pos.Y + h/2 + 5)
                        d.dist.Size = 14
                        d.dist.Color = Color3.fromRGB(200, 200, 255)
                        d.dist.Visible = env.Settings.ESP_ShowDistance and isVisible
                        d.dist.Center = true
                        
                        -- Tracer
                        d.tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                        d.tracer.To = Vector2.new(pos.X, pos.Y + h/2)
                        d.tracer.Color = Color3.fromRGB(255, 255, 0)
                        d.tracer.Thickness = 1
                        d.tracer.Visible = env.Settings.ESP_ShowTracer and isVisible
                    end
                end
            end
        end
        
        -- Cleanup if not visible
        if not isVisible then
            for _, drawing in pairs(d) do
                drawing.Visible = false
            end
        end
        
        -- Chams
        if env.Settings.Chams_Enabled and espOn and char then
            if not highlights[player] then 
                highlights[player] = Instance.new("Highlight")
                highlights[player].Parent = char
                highlights[player].FillColor = Color3.fromRGB(255, 0, 255)
                highlights[player].OutlineColor = Color3.new(1, 1, 1)
                highlights[player].FillTransparency = 0.5
            end
        elseif highlights[player] then
            highlights[player]:Destroy()
            highlights[player] = nil
        end
    end
end

-- Main Loop
env.Connections.render = RunService.RenderStepped:Connect(function()
    -- Update FOV Circle
    fovCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    
    -- Character handling
    local char = LocalPlayer.Character
    if not char then return end
    
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    
    -- Movement settings (only apply if hack is enabled)
    if env.Settings.SpeedHack_Enabled then
        hum.WalkSpeed = env.Settings.WalkSpeed
    end
    
    if env.Settings.JumpHack_Enabled then
        hum.JumpPower = env.Settings.JumpPower
    end
    
    -- Fly system
    if env.Settings.Fly_Enabled and flyVelocity then
        local forward = UserInputService:IsKeyDown(Enum.KeyCode.W) and 1 or UserInputService:IsKeyDown(Enum.KeyCode.S) and -1 or 0
        local right = UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or UserInputService:IsKeyDown(Enum.KeyCode.A) and -1 or 0
        local up = UserInputService:IsKeyDown(Enum.KeyCode.Space) and 1 or UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and -1 or 0
        
        flyGyro.CFrame = Camera.CFrame
        flyVelocity.Velocity = flyGyro.CFrame:VectorToWorldSpace(Vector3.new(right * 100, up * 100, forward * -100))
    end
    
    -- ESP Update
    updateESP()
end)

-- Player Management
Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(function(p)
    if drawings[p] then 
        for _, drawing in pairs(drawings[p]) do 
            drawing:Remove() 
        end
        drawings[p] = nil
    end
    
    if highlights[p] then 
        highlights[p]:Destroy()
        highlights[p] = nil
    end
    
    updatePlayerList()
end)

-- UI Setup
Camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
    updateLayout()
    fovCircle.Radius = env.Settings.FOVCircle_Size
end)

updateLayout()
updatePlayerList()
updateFly()
