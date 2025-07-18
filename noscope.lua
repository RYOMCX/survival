local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local mouse = LocalPlayer:GetMouse()

getgenv().ESP_Toggled = false
getgenv().SilentHeadshot = false
getgenv().MagicBullet = false
getgenv().HeadshotAccuracy = 100
getgenv().ESP_Players = {}
getgenv().ShowPOVCircle = false

local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "NoScopeArcadeHack_Ryofc_Revised"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local originalFrameSize = UDim2.new(0, 550, 0, 500)
local minimizedFrameSize = UDim2.new(0, 250, 0, 40)

local frame = Instance.new("Frame", gui)
frame.Size = originalFrameSize
frame.Position = UDim2.new(0.05, 0, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local header = Instance.new("Frame", frame)
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1, -110, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.Text = "🎯 No Scope Arcade Hack"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(0, 255, 127)
title.TextXAlignment = Enum.TextXAlignment.Left
title.BackgroundTransparency = 1

local close = Instance.new("TextButton", header)
close.Text = "❌"
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -35, 0, 5)
close.TextSize = 14
close.Font = Enum.Font.GothamBold
close.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 6)
close.MouseButton1Click:Connect(function() gui:Destroy() end)

local min = Instance.new("TextButton", header)
min.Text = "—"
min.Size = UDim2.new(0, 30, 0, 30)
min.Position = UDim2.new(1, -70, 0, 5)
min.TextSize = 14
min.Font = Enum.Font.GothamBold
min.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Instance.new("UICorner", min).CornerRadius = UDim.new(0, 6)

local contentContainer = Instance.new("Frame", frame)
contentContainer.Size = UDim2.new(1, 0, 1, -40)
contentContainer.Position = UDim2.new(0, 0, 0, 40)
contentContainer.BackgroundTransparency = 1

local leftColumn = Instance.new("Frame", contentContainer)
leftColumn.Size = UDim2.new(0.5, -10, 1, -10)
leftColumn.Position = UDim2.new(0, 5, 0, 5)
leftColumn.BackgroundTransparency = 1
local leftLayout = Instance.new("UIListLayout", leftColumn)
leftLayout.Padding = UDim.new(0, 5)
leftLayout.SortOrder = Enum.SortOrder.LayoutOrder

local rightColumn = Instance.new("Frame", contentContainer)
rightColumn.Size = UDim2.new(0.5, -10, 1, -10)
rightColumn.Position = UDim2.new(0.5, 5, 0, 5)
rightColumn.BackgroundTransparency = 1

local espLabel = Instance.new("TextLabel", rightColumn)
espLabel.Size = UDim2.new(1, 0, 0, 20)
espLabel.Text = "Player ESP List"
espLabel.Font = Enum.Font.GothamBold
espLabel.TextSize = 16
espLabel.TextColor3 = Color3.new(1,1,1)
espLabel.BackgroundTransparency = 1

local playerList = Instance.new("ScrollingFrame", rightColumn)
playerList.Size = UDim2.new(1, 0, 1, -25)
playerList.Position = UDim2.new(0, 0, 0, 25)
playerList.BackgroundColor3 = Color3.fromRGB(40,40,40)
playerList.BorderSizePixel = 0
Instance.new("UICorner", playerList).CornerRadius = UDim.new(0, 8)
local playerListLayout = Instance.new("UIListLayout", playerList)
playerListLayout.Padding = UDim.new(0, 2)
playerListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local minimized = false
local function toggleMinimize()
    minimized = not minimized
    contentContainer.Visible = not minimized
    if minimized then
        frame:TweenSize(minimizedFrameSize, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
        title.Text = "ryofc arcade hack"
    else
        frame:TweenSize(originalFrameSize, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
        title.Text = "🎯 No Scope Arcade Hack"
    end
end

min.MouseButton1Click:Connect(toggleMinimize)
title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1Click and minimized then
        toggleMinimize()
    end
end)

local function createToggleButton(text, parent, callback)
    local state = false
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.Text = text .. ": OFF"
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 15
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    btn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            btn.Text = text .. ": ON"
            btn.BackgroundColor3 = Color3.fromRGB(0, 180, 80)
        else
            btn.Text = text .. ": OFF"
            btn.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
        end
        if callback then
            callback(state)
        end
    end)
    return btn
end

local originalWalkSpeed, originalJumpPower, originalFov = 16, 50, 70
pcall(function()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid")
    originalWalkSpeed = hum.WalkSpeed
    originalJumpPower = hum.JumpPower
    originalFov = Camera.FieldOfView
end)

createToggleButton("Speed", leftColumn, function(state)
    local currentHum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if currentHum then currentHum.WalkSpeed = state and 80 or originalWalkSpeed end
end)

createToggleButton("Jump", leftColumn, function(state)
    local currentHum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if currentHum then currentHum.JumpPower = state and 120 or originalJumpPower end
end)

createToggleButton("Magic Bullet", leftColumn, function(state)
    getgenv().MagicBullet = state
end)

local silentAimToggle = createToggleButton("Silent Aim", leftColumn, function(state)
    getgenv().SilentHeadshot = state
end)

local function createSlider(parent, labelText, minVal, maxVal, defaultVal, callback)
    local sliderFrame = Instance.new("Frame", parent)
    sliderFrame.Size = UDim2.new(1, 0, 0, 40)
    sliderFrame.BackgroundTransparency = 1

    local label = Instance.new("TextLabel", sliderFrame)
    label.Size = UDim2.new(1, 0, 0.5, 0)
    label.Font = Enum.Font.Gotham
    label.TextSize = 15
    label.TextColor3 = Color3.new(1,1,1)
    label.BackgroundTransparency = 1

    local sliderBar = Instance.new("Frame", sliderFrame)
    sliderBar.Size = UDim2.new(1, 0, 0, 6)
    sliderBar.Position = UDim2.new(0, 0, 0.5, 0)
    sliderBar.BackgroundColor3 = Color3.fromRGB(60,60,60)
    Instance.new("UICorner", sliderBar).CornerRadius = UDim.new(0, 3)

    local sliderHandle = Instance.new("TextButton", sliderBar)
    sliderHandle.Size = UDim2.new(0, 16, 0, 16)
    sliderHandle.BackgroundColor3 = Color3.fromRGB(0, 255, 127)
    sliderHandle.Text = ""
    Instance.new("UICorner", sliderHandle).CornerRadius = UDim.new(1, 0)

    local function updateSlider(value)
        local percentage = (value - minVal) / (maxVal - minVal)
        label.Text = labelText .. ": " .. math.floor(value)
        sliderHandle.Position = UDim2.new(percentage, -8, 0.5, -8)
        callback(value)
    end
    
    updateSlider(defaultVal)

    local dragging = false
    sliderHandle.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local newX = math.clamp(mouse.X - sliderBar.AbsolutePosition.X, 0, sliderBar.AbsoluteSize.X)
            local percentage = newX / sliderBar.AbsoluteSize.X
            local newValue = minVal + (maxVal - minVal) * percentage
            updateSlider(newValue)
        end
    end)
    return sliderFrame, label, updateSlider
end

createSlider(leftColumn, "Accuracy", 1, 100, 100, function(value)
    getgenv().HeadshotAccuracy = value
end)

createSlider(leftColumn, "POV", 30, 120, originalFov, function(value)
    Camera.FieldOfView = value
end)

createToggleButton("Show POV Circle", leftColumn, function(state)
    getgenv().ShowPOVCircle = state
end)

local function GetClosestEnemy(checkVisibility)
    local closest, dist = nil, math.huge
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Team ~= LocalPlayer.Team and v.Character and v.Character:FindFirstChild("Head") and v.Character.Humanoid.Health > 0 then
            local pos, onScreen = Camera:WorldToViewportPoint(v.Character.Head.Position)
            if not checkVisibility or onScreen then
                local mag = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(pos.X, pos.Y)).Magnitude
                if mag < dist then dist = mag; closest = v end
            end
        end
    end
    return closest
end

local old
old = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    if (getgenv().SilentHeadshot or getgenv().MagicBullet) and tostring(self) == "Raycast" and getnamecallmethod() == "FindPartOnRayWithIgnoreList" then
        local target = getgenv().MagicBullet and GetClosestEnemy(false) or (getgenv().SilentHeadshot and GetClosestEnemy(true))
        if target and target.Character and target.Character:FindFirstChild("Head") then
            if math.random(1, 100) <= getgenv().HeadshotAccuracy then
                args[1] = Ray.new(Camera.CFrame.Position, (target.Character.Head.Position - Camera.CFrame.Position).Unit * 1000)
                return old(self, unpack(args))
            end
        end
    end
    return old(self, ...)
end)

local espToggle = createToggleButton("Master ESP", leftColumn, function(state)
    getgenv().ESP_Toggled = state
    rightColumn.Visible = state
end)
rightColumn.Visible = false

local function updatePlayerList()
    playerList:ClearAllChildren()
    Instance.new("UIListLayout", playerList).Padding = UDim.new(0, 2)
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            getgenv().ESP_Players[player] = getgenv().ESP_Players[player] or false
            
            local playerFrame = Instance.new("Frame", playerList)
            playerFrame.Size = UDim2.new(1, 0, 0, 25)
            playerFrame.BackgroundTransparency = 1
            
            local nameLabel = Instance.new("TextLabel", playerFrame)
            nameLabel.Size = UDim2.new(1, -35, 1, 0)
            nameLabel.Text = player.Name
            nameLabel.Font = Enum.Font.Gotham
            nameLabel.TextColor3 = Color3.new(1,1,1)
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left
            nameLabel.BackgroundTransparency = 1
            
            local espSwitch = Instance.new("TextButton", playerFrame)
            espSwitch.Size = UDim2.new(0, 25, 0, 25)
            espSwitch.Position = UDim2.new(1, -25, 0, 0)
            espSwitch.BackgroundColor3 = getgenv().ESP_Players[player] and Color3.fromRGB(0, 180, 80) or Color3.fromRGB(200, 30, 30)
            espSwitch.Text = ""
            Instance.new("UICorner", espSwitch).CornerRadius = UDim.new(0, 4)
            
            espSwitch.MouseButton1Click:Connect(function()
                getgenv().ESP_Players[player] = not getgenv().ESP_Players[player]
                espSwitch.BackgroundColor3 = getgenv().ESP_Players[player] and Color3.fromRGB(0, 180, 80) or Color3.fromRGB(200, 30, 30)
            end)
        end
    end
end

local povCircle = Instance.new("ImageLabel", gui)
povCircle.Image = "rbxassetid://1061853419" 
povCircle.BackgroundTransparency = 1
povCircle.ImageColor3 = Color3.new(1,1,1)
povCircle.ImageTransparency = 0.5
povCircle.ScaleType = Enum.ScaleType.Fit
povCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
povCircle.AnchorPoint = Vector2.new(0.5, 0.5)
povCircle.Visible = false

local drawings = {}
RunService.RenderStepped:Connect(function()
    povCircle.Visible = getgenv().ShowPOVCircle
    if povCircle.Visible then
        local circleSize = 25000 / Camera.FieldOfView
        povCircle.Size = UDim2.fromOffset(circleSize, circleSize)
    end
    
    for player, espOn in pairs(getgenv().ESP_Players) do
        if not drawings[player] then
            drawings[player] = { box = Drawing.new("Square"), name = Drawing.new("Text"), healthBar = Drawing.new("Square"), healthBg = Drawing.new("Square") }
            drawings[player].box.Thickness = 1
            drawings[player].box.Color = Color3.fromRGB(0, 255, 0)
            drawings[player].name.Size = 14
            drawings[player].name.Center = true
            drawings[player].name.Outline = true
            drawings[player].name.Color = Color3.fromRGB(255, 255, 255)
            drawings[player].healthBg.Filled = true
            drawings[player].healthBg.Color = Color3.fromRGB(50, 0, 0)
            drawings[player].healthBar.Filled = true
            drawings[player].healthBar.Color = Color3.fromRGB(0, 255, 0)
        end
        
        local drawing = drawings[player]
        local isVisible = false
        
        if getgenv().ESP_Toggled and espOn and player and player.Character and player.Character:FindFirstChildOfClass("Humanoid") and player.Character.Humanoid.Health > 0 then
            local rootPart = player.Character.HumanoidRootPart
            if rootPart then
                local pos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
                if onScreen then
                    isVisible = true
                    local headPos = Camera:WorldToViewportPoint(player.Character.Head.Position + Vector3.new(0, 0.5, 0))
                    local h = math.abs(headPos.Y - pos.Y) * 2
                    local w = h / 2
                    drawing.box.Size = Vector2.new(w, h)
                    drawing.box.Position = Vector2.new(pos.X - w/2, pos.Y - h/2)
                    drawing.name.Text = player.Name
                    drawing.name.Position = Vector2.new(pos.X, pos.Y - h/2 - 14)
                    local hpRatio = math.clamp(player.Character.Humanoid.Health / player.Character.Humanoid.MaxHealth, 0, 1)
                    drawing.healthBg.Size = Vector2.new(4, h)
                    drawing.healthBg.Position = Vector2.new(pos.X - w/2 - 6, pos.Y - h/2)
                    drawing.healthBar.Size = Vector2.new(4, h * hpRatio)
                    drawing.healthBar.Position = Vector2.new(pos.X - w/2 - 6, pos.Y + h/2 - (h * hpRatio))
                end
            end
        end
        for _, d in pairs(drawing) do d.Visible = isVisible end
    end
end)

Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(function(player)
    if drawings[player] then
        for _, d in pairs(drawings[player]) do d:Remove() end
        drawings[player] = nil
    end
    getgenv().ESP_Players[player] = nil
    updatePlayerList()
end)

updatePlayerList()
