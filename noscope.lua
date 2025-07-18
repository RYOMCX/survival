local ui = Instance.new("ScreenGui", game.CoreGui)
local main = Instance.new("Frame", ui)
main.Size = UDim2.new(0, 320, 0, 550)
main.Position = UDim2.new(0.02, 0, 0.2, 0)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)

local close = Instance.new("TextButton", main)
close.Size = UDim2.new(0, 25, 0, 25)
close.Position = UDim2.new(1, -30, 0, 5)
close.Text = "✖"
close.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
close.TextColor3 = Color3.new(1, 1, 1)
close.Font = Enum.Font.GothamBold
close.TextSize = 14
Instance.new("UICorner", close)

local minimize = Instance.new("TextButton", main)
minimize.Size = UDim2.new(0, 25, 0, 25)
minimize.Position = UDim2.new(1, -60, 0, 5)
minimize.Text = "–"
minimize.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
minimize.TextColor3 = Color3.new(0, 0, 0)
minimize.Font = Enum.Font.GothamBold
minimize.TextSize = 14
Instance.new("UICorner", minimize)

local ryofc = Instance.new("TextButton", ui)
ryofc.Size = UDim2.new(0, 120, 0, 35)
ryofc.Position = UDim2.new(0.02, 0, 0.05, 0)
ryofc.Text = "ryofc hack"
ryofc.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ryofc.TextColor3 = Color3.fromRGB(0, 255, 0)
ryofc.Font = Enum.Font.GothamBold
ryofc.TextSize = 14
ryofc.Visible = false
Instance.new("UICorner", ryofc)

close.MouseButton1Click:Connect(function()
    ui:Destroy()
end)

minimize.MouseButton1Click:Connect(function()
    main.Visible = false
    ryofc.Visible = true
end)

ryofc.MouseButton1Click:Connect(function()
    main.Visible = true
    ryofc.Visible = false
end)

local buttons = {
    "ESP BOX", "ESP LINE", "ESP NAME", "ESP HEALTH BAR", "AUTO KILL",
    "AUTO HEADSHOT", "FULL BRIGHT", "NIGHT VISION", "AIMBOT (NO SCOPE)",
    "SPEED HACK", "INVISIBLE", "FLY", "POV MODE", "POV CIRCLE", "FREE GAMEPASS"
}

local btns = {}
local povSize = 100

for i,v in pairs(buttons) do
    local b = Instance.new("TextButton", main)
    b.Size = UDim2.new(0, 300, 0, 30)
    b.Position = UDim2.new(0, 10, 0, 40 + (i - 1) * 35)
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    b.Text = v
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    Instance.new("UICorner", b)
    btns[v] = b
end

btns["ESP BOX"].MouseButton1Click:Connect(function()
    for _,v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local box = Instance.new("BoxHandleAdornment", v.Character)
            box.Size = Vector3.new(4, 6, 1)
            box.Adornee = v.Character
            box.AlwaysOnTop = true
            box.ZIndex = 5
            box.Color3 = Color3.new(1, 0, 0)
            box.Transparency = 0.5
        end
    end
end)

btns["ESP LINE"].MouseButton1Click:Connect(function()
    local camera = workspace.CurrentCamera
    for _,v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
            local beam = Instance.new("Beam", camera)
            local a0 = Instance.new("Attachment", camera)
            local a1 = Instance.new("Attachment", v.Character.Head)
            beam.Attachment0 = a0
            beam.Attachment1 = a1
            beam.Color = ColorSequence.new(Color3.new(1, 1, 0))
            beam.Width0 = 0.05
            beam.Width1 = 0.05
            beam.FaceCamera = true
        end
    end
end)

btns["ESP NAME"].MouseButton1Click:Connect(function()
    for _,v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
            local nameTag = Instance.new("BillboardGui", v.Character.Head)
            nameTag.Size = UDim2.new(0, 100, 0, 20)
            nameTag.StudsOffset = Vector3.new(0, 3, 0)
            nameTag.AlwaysOnTop = true
            local txt = Instance.new("TextLabel", nameTag)
            txt.Size = UDim2.new(1, 0, 1, 0)
            txt.BackgroundTransparency = 1
            txt.Text = v.Name
            txt.TextColor3 = Color3.new(0, 1, 0)
            txt.TextStrokeTransparency = 0
        end
    end
end)

btns["ESP HEALTH BAR"].MouseButton1Click:Connect(function()
    for _,v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
            local bar = Instance.new("BillboardGui", v.Character.Head)
            bar.Size = UDim2.new(3, 0, 0.3, 0)
            bar.StudsOffset = Vector3.new(0, 4, 0)
            bar.AlwaysOnTop = true
            local frame = Instance.new("Frame", bar)
            frame.BackgroundColor3 = Color3.new(1, 0, 0)
            frame.Size = UDim2.new(v.Character.Humanoid.Health / v.Character.Humanoid.MaxHealth, 0, 1, 0)
        end
    end
end)

btns["AUTO KILL"].MouseButton1Click:Connect(function()
    while wait(0.1) do
        for _,v in pairs(game.Players:GetPlayers()) do
            if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") then
                v.Character.Humanoid.Health = 0
            end
        end
    end
end)

btns["AUTO HEADSHOT"].MouseButton1Click:Connect(function()
    local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
    while wait(0.1) do
        for _,v in pairs(game.Players:GetPlayers()) do
            if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
                if tool and tool:FindFirstChild("RemoteEvent") then
                    tool.RemoteEvent:FireServer(v.Character.Head.Position)
                end
            end
        end
    end
end)

btns["FULL BRIGHT"].MouseButton1Click:Connect(function()
    game.Lighting.Brightness = 2
    game.Lighting.ClockTime = 14
    game.Lighting.FogEnd = 100000
end)

btns["NIGHT VISION"].MouseButton1Click:Connect(function()
    game.Lighting.ColorCorrection.TintColor = Color3.fromRGB(0,255,255)
end)

btns["AIMBOT (NO SCOPE)"].MouseButton1Click:Connect(function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local Mouse = LocalPlayer:GetMouse()
    local Camera = workspace.CurrentCamera
    game:GetService("RunService").RenderStepped:Connect(function()
        local closestPlayer = nil
        local shortestDistance = math.huge
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                local screenPoint, onScreen = Camera:WorldToScreenPoint(player.Character.Head.Position)
                if onScreen then
                    local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestPlayer = player
                    end
                end
            end
        end
        if closestPlayer and closestPlayer.Character then
            Mouse.Target = closestPlayer.Character.Head
        end
    end)
end)

btns["SPEED HACK"].MouseButton1Click:Connect(function()
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 100
end)

btns["INVISIBLE"].MouseButton1Click:Connect(function()
    for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
        if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
            v.Transparency = 1
        end
    end
end)

btns["FLY"].MouseButton1Click:Connect(function()
    local player = game.Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local flying = true
    local speed = 4
    game:GetService("RunService").RenderStepped:Connect(function()
        if flying then
            hrp.Velocity = Vector3.new(0, 0, 0)
        end
    end)
end)

btns["POV MODE"].MouseButton1Click:Connect(function()
    local circle = Instance.new("Frame", ui)
    circle.Size = UDim2.new(0, povSize, 0, povSize)
    circle.Position = UDim2.new(0.5, -povSize/2, 0.5, -povSize/2)
    circle.BackgroundTransparency = 1
    local uicircle = Instance.new("UICorner", circle)
    uicircle.CornerRadius = UDim.new(1, 0)
    local outline = Instance.new("Frame", circle)
    outline.AnchorPoint = Vector2.new(0.5, 0.5)
    outline.Position = UDim2.new(0.5, 0, 0.5, 0)
    outline.Size = UDim2.new(1, 0, 1, 0)
    outline.BackgroundColor3 = Color3.new(1, 1, 1)
    outline.BackgroundTransparency = 1
    outline.BorderSizePixel = 3
    outline.BorderColor3 = Color3.fromRGB(0, 255, 0)
end)

btns["POV CIRCLE"].MouseButton1Click:Connect(function()
    local circle = Instance.new("Frame", ui)
    circle.Size = UDim2.new(0, povSize, 0, povSize)
    circle.Position = UDim2.new(0.5, -povSize/2, 0.5, -povSize/2)
    circle.BackgroundTransparency = 1
    local stroke = Instance.new("UIStroke", circle)
    stroke.Thickness = 2
    stroke.Color = Color3.new(1, 1, 1)
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
end)

ui.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        povSize = math.clamp(input.Position.X / 5, 50, 400)
    end
end)

btns["FREE GAMEPASS"].MouseButton1Click:Connect(function()
    local MarketplaceService = game:GetService("MarketplaceService")
    local oldOwnsGamePass = MarketplaceService.UserOwnsGamePassAsync
    setreadonly(MarketplaceService, false)
    MarketplaceService.UserOwnsGamePassAsync = function()
        return true
    end
    setreadonly(MarketplaceService, true)
end)
