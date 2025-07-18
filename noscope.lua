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
	NoRecoil_Enabled = false
}
env.ESP_Players = {}

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
loadingLabel.Text = "roblox badge ryofc script"
loadingLabel.Font = Enum.Font.GothamBold
loadingLabel.TextSize = 18
loadingLabel.TextColor3 = Color3.fromRGB(0, 255, 127)
loadingLabel.BackgroundTransparency = 1
wait(3.5)
loadingGui:Destroy()

local mainGui = Instance.new("ScreenGui", CoreGui)
mainGui.Name = "RyofcMainGUI"
mainGui.ResetOnSpawn = false
mainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local mainFrame = Instance.new("Frame", mainGui)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
Instance.new("UIAspectRatioConstraint", mainFrame).AspectRatio = 1.5

local header = Instance.new("Frame", mainFrame)
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1, -50, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.Text = "ryofc arcade hack"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(0, 255, 127)
title.TextXAlignment = Enum.TextXAlignment.Left
title.BackgroundTransparency = 1

local close = Instance.new("TextButton", header)
close.Text = "❌"
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -35, 0, 5)
close.Font = Enum.Font.GothamBold
close.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 6)
close.MouseButton1Click:Connect(function() mainGui:Destroy() end)

local contentContainer = Instance.new("Frame", mainFrame)
contentContainer.Position = UDim2.new(0, 0, 0, 40)
contentContainer.BackgroundTransparency = 1
local contentLayout = Instance.new("UIListLayout", contentContainer)
contentLayout.Padding = UDim.new(0, 10)
contentLayout.FillDirection = Enum.FillDirection.Horizontal
contentLayout.VerticalAlignment = Enum.VerticalAlignment.Top

local leftColumn = Instance.new("ScrollingFrame", contentContainer)
leftColumn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
leftColumn.BorderSizePixel = 0
Instance.new("UICorner", leftColumn)
local leftLayout = Instance.new("UIListLayout", leftColumn)
leftLayout.Padding = UDim.new(0, 5)
leftLayout.SortOrder = Enum.SortOrder.LayoutOrder

local rightColumn = Instance.new("ScrollingFrame", contentContainer)
rightColumn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
rightColumn.BorderSizePixel = 0
Instance.new("UICorner", rightColumn)
local rightLayout = Instance.new("UIListLayout", rightColumn)
rightLayout.Padding = UDim.new(0, 5)
rightLayout.SortOrder = Enum.SortOrder.LayoutOrder

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
espOptions.Size = UDim2.new(1, -10, 0, 70)
espOptions.Position = UDim2.new(0, 5, 0, 35)
espOptions.BackgroundTransparency = 1
local espOptionsLayout = Instance.new("UIGridLayout", espOptions)
espOptionsLayout.CellPadding = UDim2.fromOffset(5, 5)
espOptionsLayout.CellSize = UDim2.new(0.3, 0, 0.45, 0)

local playerList = Instance.new("ScrollingFrame", espWindow)
playerList.Size = UDim2.new(1, -10, 1, -115)
playerList.Position = UDim2.new(0, 5, 0, 110)
playerList.BackgroundColor3 = Color3.fromRGB(40,40,40)
playerList.BorderSizePixel = 0
Instance.new("UICorner", playerList)
local playerListLayout = Instance.new("UIListLayout", playerList)
playerListLayout.Padding = UDim.new(0, 2)

local function updateLayout()
    local vp = Camera.ViewportSize
    local isMobile = vp.X < vp.Y
    mainFrame.Size = isMobile and UDim2.new(0.9, 0, 0.6, 0) or UDim2.new(0.5, 0, 0.6, 0)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    contentLayout.FillDirection = isMobile and Enum.FillDirection.Vertical or Enum.FillDirection.Horizontal
    leftColumn.Size = isMobile and UDim2.new(1, -10, 0.5, -5) or UDim2.new(0.5, -5, 1, -10)
    rightColumn.Size = isMobile and UDim2.new(1, -10, 0.5, -5) or UDim2.new(0.5, -5, 1, -10)
    contentContainer.Size = UDim2.new(1, -10, 1, -50)
    contentContainer.Position = UDim2.new(0.5, -contentContainer.AbsoluteSize.X / 2, 0, 45)
end

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
        btn.Text, btn.BackgroundColor3 = state and (text .. ": ON") or (text .. ": OFF"), state and Color3.fromRGB(0, 180, 80) or Color3.fromRGB(200, 30, 30)
        if callback then callback(state) end
    end)
    return btn
end

local function createSlider(parent, labelText, minVal, maxVal, defaultVal, callback)
    local sliderFrame = Instance.new("Frame", parent)
    sliderFrame.Size = UDim2.new(1, 0, 0, 40)
    sliderFrame.BackgroundTransparency = 1
    local label = Instance.new("TextLabel", sliderFrame)
    label.Size = UDim2.new(1, 0, 0.5, 0); label.Font = Enum.Font.Gotham; label.TextSize = 15; label.TextColor3 = Color3.new(1,1,1); label.BackgroundTransparency = 1
    local sliderBar = Instance.new("Frame", sliderFrame)
    sliderBar.Size = UDim2.new(1, 0, 0, 6); sliderBar.Position = UDim2.new(0, 0, 0.5, 0); sliderBar.BackgroundColor3 = Color3.fromRGB(60,60,60)
    Instance.new("UICorner", sliderBar).CornerRadius = UDim.new(0, 3)
    local sliderHandle = Instance.new("TextButton", sliderBar)
    sliderHandle.Size = UDim2.new(0, 16, 0, 16); sliderHandle.BackgroundColor3 = Color3.fromRGB(0, 255, 127); sliderHandle.Text = ""
    Instance.new("UICorner", sliderHandle).CornerRadius = UDim.new(1, 0)
    local function updateSlider(value)
        local percentage = (value - minVal) / (maxVal - minVal)
        label.Text = labelText .. ": " .. math.floor(value)
        sliderHandle.Position = UDim2.new(percentage, -sliderHandle.AbsoluteSize.X/2, 0.5, -sliderHandle.AbsoluteSize.Y/2)
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
end

createSlider(leftColumn, "Speed", 16, 200, 16, function(v) env.Settings.WalkSpeed = v end)
createSlider(leftColumn, "Jump", 50, 300, 50, function(v) env.Settings.JumpPower = v end)
createSlider(leftColumn, "POV", 30, 120, 70, function(v) env.Settings.FieldOfView = v end)
createSlider(leftColumn, "Accuracy", 1, 100, 100, function(v) env.Settings.Accuracy = v end)
createToggleButton("Silent Aim", leftColumn, function(s) env.Settings.SilentAim_Enabled = s end)
createToggleButton("Magic Bullet", leftColumn, function(s) env.Settings.MagicBullet_Enabled = s end)

createToggleButton("Toggle ESP", rightColumn, function(s) espWindow.Visible = s end)
createToggleButton("Fly", rightColumn, function(s) env.Settings.Fly_Enabled = s end)
createToggleButton("Third Person", rightColumn, function(s) env.Settings.ThirdPerson_Enabled = s end)
createToggleButton("Infinite Ammo", rightColumn, function(s) env.Settings.InfAmmo_Enabled = s end)
createToggleButton("No Recoil", rightColumn, function(s) env.Settings.NoRecoil_Enabled = s end)

local function updatePlayerList()
    playerList:ClearAllChildren()
    Instance.new("UIListLayout", playerList).Padding = UDim.new(0, 2)
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            env.ESP_Players[player] = env.ESP_Players[player] or false
            local btn = createToggleButton(player.Name, playerList, function(s) env.ESP_Players[player] = s end)
        end
    end
end
createToggleButton("Box", espOptions, function(s) env.Settings.ESP_ShowBox = s end)
createToggleButton("Chams", espOptions, function(s) env.Settings.Chams_Enabled = s end)
createToggleButton("Name", espOptions, function(s) env.Settings.ESP_ShowName = s end)
createToggleButton("Health", espOptions, function(s) env.Settings.ESP_ShowHealth = s end)
createToggleButton("Distance", espOptions, function(s) env.Settings.ESP_ShowDistance = s end)
createToggleButton("Tracer", espOptions, function(s) env.Settings.ESP_ShowTracer = s end)

local drawings = {}
local highlights = {}
local flyVelocity, flyGyro
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    hum.WalkSpeed = env.Settings.WalkSpeed
    hum.JumpPower = env.Settings.JumpPower
    Camera.FieldOfView = env.Settings.FieldOfView
    LocalPlayer.CameraMode = env.Settings.ThirdPerson_Enabled and Enum.CameraMode.Classic or Enum.CameraMode.LockFirstPerson
    
    if env.Settings.Fly_Enabled then
        if not flyVelocity then
            flyVelocity = Instance.new("BodyVelocity", hum.HumanoidRootPart); flyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
            flyGyro = Instance.new("BodyGyro", hum.HumanoidRootPart); flyGyro.MaxTorque = Vector3.new(0, math.huge, 0)
        end
        flyVelocity.Velocity = Vector3.new(0, UserInputService:IsKeyDown(Enum.KeyCode.Space) and 50 or (UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and -50 or 0), 0)
        flyGyro.CFrame = Camera.CFrame
    elseif flyVelocity then
        flyVelocity:Destroy(); flyGyro:Destroy(); flyVelocity = nil; flyGyro = nil
    end

    for player, espOn in pairs(env.ESP_Players) do
        local pChar = player.Character
        if not drawings[player] then
            drawings[player] = {box=Drawing.new("Square"),name=Drawing.new("Text"),health=Drawing.new("Line"),dist=Drawing.new("Text"),tracer=Drawing.new("Line")}
        end
        local d = drawings[player]
        local isVisible = false
        if espOn and pChar and pChar:FindFirstChildOfClass("Humanoid") and pChar.Humanoid.Health > 0 then
            local root = pChar.HumanoidRootPart
            if root then
                local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
                if onScreen then
                    isVisible = true
                    local headPos = Camera:WorldToViewportPoint(pChar.Head.Position + Vector3.new(0,0.5,0))
                    local h, w = math.abs(headPos.Y - pos.Y) * 2, math.abs(headPos.Y - pos.Y)
                    d.box.Size, d.box.Position, d.box.Color, d.box.Thickness, d.box.Visible = Vector2.new(w,h),Vector2.new(pos.X-w/2,pos.Y-h/2),Color3.fromRGB(0,255,0),2,env.Settings.ESP_ShowBox
                    d.name.Text, d.name.Position, d.name.Size, d.name.Color, d.name.Visible = player.Name,Vector2.new(pos.X,pos.Y-h/2-15),15,Color3.fromRGB(255,255,255),env.Settings.ESP_ShowName
                    d.health.From, d.health.To, d.health.Color, d.health.Thickness, d.health.Visible = Vector2.new(pos.X-w/2-3,pos.Y+h/2),Vector2.new(pos.X-w/2-3,pos.Y-h/2 + h*(1-pChar.Humanoid.Health/pChar.Humanoid.MaxHealth)),Color3.fromRGB(0,255,0),3,env.Settings.ESP_ShowHealth
                    local distance = math.floor((char.HumanoidRootPart.Position - root.Position).Magnitude)
                    d.dist.Text, d.dist.Position, d.dist.Visible = "["..distance.."m]", Vector2.new(pos.X, pos.Y+h/2+5), env.Settings.ESP_ShowDistance
                    d.tracer.From, d.tracer.To, d.tracer.Color, d.tracer.Visible = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y), Vector2.new(pos.X, pos.Y+h/2), Color3.fromRGB(255,255,0), env.Settings.ESP_ShowTracer
                end
            end
        end
        for _, obj in pairs(d) do if obj.Visible ~= isVisible then obj.Visible = isVisible end end
        if env.Settings.Chams_Enabled and espOn and pChar then
            if not highlights[player] then highlights[player] = Instance.new("Highlight", pChar); highlights[player].FillColor=Color3.fromRGB(255,0,255); highlights[player].OutlineTransparency=0 end
        elseif highlights[player] then
            highlights[player]:Destroy(); highlights[player] = nil
        end
    end
end)

Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(function(p) if drawings[p] then for _,d in pairs(drawings[p]) do d:Remove() end drawings[p]=nil end; if highlights[p] then highlights[p]:Destroy() highlights[p]=nil end; updatePlayerList() end)

Camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateLayout)
updateLayout()
updatePlayerList()
