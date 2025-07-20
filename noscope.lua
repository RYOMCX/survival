getgenv().Settings = {
    Aimbot = true,
    Fov = 100,
    FovCircle = true,
    Hitbox = "Head",

    ESPBox = true,
    ESPName = true,
    ESPHealth = true,
    ESPTracer = true,
    Chams = true,
    FullBright = true,
    
    Triggerbot = false,
    NoRecoil = true,
    InfiniteAmmo = true,
    RapidFire = true,

    Fly = false,
    Noclip = false,
    BHop = false,
    AntiAFK = true,

    AdminCommands = true,
    KillAll = false,

    BoxColor = Color3.fromRGB(255, 0, 0),
    TracerColor = Color3.fromRGB(255, 0, 0),
    ChamColor = Color3.fromRGB(255, 0, 255),
    ChamTransparency = 0.5
}

if getgenv().Settings.AdminCommands then
    loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local Target = nil
local NoclipEnabled = false
local Flying = false

local function CreateHighlight(parent)
    local highlight = Instance.new("Highlight", parent)
    highlight.FillColor = getgenv().Settings.ChamColor
    highlight.OutlineColor = getgenv().Settings.ChamColor
    highlight.FillTransparency = getgenv().Settings.ChamTransparency
    highlight.OutlineTransparency = 1
    highlight.DepthMode = Enum.DepthMode.AlwaysOnTop
    return highlight
end

local function GetClosest(Fov)
    local TargetPlayer, Closest = nil, Fov
    
    for i,v in pairs(Players:GetPlayers()) do
        if (v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character.Humanoid.Health > 0) then
            local ScreenPos, OnScreen = Camera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
            if OnScreen then
                local Distance = (Vector2.new(ScreenPos.X, ScreenPos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if (Distance < Closest) then
                    Closest = Distance
                    TargetPlayer = v
                end
            end
        end
    end
    
    return TargetPlayer
end

local function KillAll()
    if getgenv().Settings.KillAll then
        for i, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character.Humanoid.Health > 0 then
                local Hitbox = v.Character[getgenv().Settings.Hitbox]
                if Hitbox then
                    local remote = ReplicatedStorage:FindFirstChild("RemoteEvent", true)
                    if remote then
                        remote:FireServer("Bullet", v.Character, Hitbox, Hitbox.Position)
                    end
                end
            end
        end
    end
end

local CircleInline = Drawing.new("Circle")
CircleInline.Thickness = 2
CircleInline.Transparency = 1
CircleInline.Color = Color3.fromRGB(255, 255, 255)
CircleInline.ZIndex = 2

local CircleOutline = Drawing.new("Circle")
CircleOutline.Thickness = 4
CircleOutline.Transparency = 1
CircleOutline.Color = Color3.new()
CircleOutline.ZIndex = 1

if getgenv().Settings.AntiAFK then
    local VirtualUser = game:GetService("VirtualUser")
    LocalPlayer.Idled:connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end

if getgenv().Settings.BHop then
    UserInputService.JumpRequest:connect(function()
        if getgenv().Settings.BHop then
            LocalPlayer.Character:FindFirstChildOfClass'Humanoid':ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end

RunService.RenderStepped:Connect(function()
    CircleInline.Radius = getgenv().Settings.Fov
    CircleInline.Position = Vector2.new(Mouse.X, Mouse.Y + 36)
    CircleInline.Visible = getgenv().Settings.FovCircle

    CircleOutline.Radius = getgenv().Settings.Fov
    CircleOutline.Position = Vector2.new(Mouse.X, Mouse.Y + 36)
    CircleOutline.Visible = getgenv().Settings.FovCircle

    if getgenv().Settings.Aimbot then
        Target = GetClosest(getgenv().Settings.Fov)
    else
        Target = nil
    end

    if getgenv().Settings.Triggerbot and Mouse.Target and Mouse.Target.Parent and Players:GetPlayerFromCharacter(Mouse.Target.Parent) then
        local remote = ReplicatedStorage:FindFirstChild("RemoteEvent", true)
        if remote then
            remote:FireServer("Bullet", Mouse.Target.Parent, Mouse.Target, Mouse.Hit.p)
        end
    end

    if getgenv().Settings.FullBright then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
    end
    
    if getgenv().Settings.Noclip ~= NoclipEnabled then
        NoclipEnabled = getgenv().Settings.Noclip
        if LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = not NoclipEnabled
                end
            end
        end
    end

    if getgenv().Settings.Fly ~= Flying then
        Flying = getgenv().Settings.Fly
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, Flying)
            if Flying then
                LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Flying)
            else
                LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end
    end
    
    for i, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local head = v.Character:FindFirstChild("Head")
            if not head then continue end

            local headPos, onScreen = Camera:WorldToScreenPoint(head.Position)

            if onScreen then
                if getgenv().Settings.ESPBox then
                    local espBox = Drawing.new("Quad")
                    espBox.PointA = Vector2.new(headPos.X - 25, headPos.Y - 25)
                    espBox.PointB = Vector2.new(headPos.X + 25, headPos.Y - 25)
                    espBox.PointC = Vector2.new(headPos.X + 25, headPos.Y + 25)
                    espBox.PointD = Vector2.new(headPos.X - 25, headPos.Y + 25)
                    espBox.Color = getgenv().Settings.BoxColor
                    espBox.Thickness = 1
                    espBox.Filled = false
                    espBox.Visible = true
                    game:GetService("Debris"):AddItem(espBox, 0)
                end

                if getgenv().Settings.ESPName then
                    local espName = Drawing.new("Text")
                    espName.Text = v.Name
                    espName.Size = 14
                    espName.Center = true
                    espName.Outline = true
                    espName.Position = Vector2.new(headPos.X, headPos.Y - 35)
                    espName.Visible = true
                    game:GetService("Debris"):AddItem(espName, 0)
                end

                if getgenv().Settings.ESPHealth then
                    local health = v.Character.Humanoid.Health / v.Character.Humanoid.MaxHealth
                    local espHealth = Drawing.new("Text")
                    espHealth.Text = tostring(math.floor(v.Character.Humanoid.Health))
                    espHealth.Size = 12
                    espHealth.Center = true
                    espHealth.Outline = true
                    espHealth.Color = Color3.fromHSV(health / 3, 1, 1)
                    espHealth.Position = Vector2.new(headPos.X, headPos.Y + 30)
                    espHealth.Visible = true
                    game:GetService("Debris"):AddItem(espHealth, 0)
                end

                if getgenv().Settings.ESPTracer then
                    local espTracer = Drawing.new("Line")
                    espTracer.From = Vector2.new(Mouse.X, Mouse.Y + 36)
                    espTracer.To = Vector2.new(headPos.X, headPos.Y)
                    espTracer.Color = getgenv().Settings.TracerColor
                    espTracer.Thickness = 1
                    espTracer.Visible = true
                    game:GetService("Debris"):AddItem(espTracer, 0)
                end
            end
            
            if getgenv().Settings.Chams then
                if not v.Character:FindFirstChild("Highlight") then
                    CreateHighlight(v.Character)
                end
            else
                if v.Character:FindFirstChild("Highlight") then
                    v.Character.Highlight:Destroy()
                end
            end
        else
            if v.Character and v.Character:FindFirstChild("Highlight") then
                 v.Character.Highlight:Destroy()
            end
        end
    end
end)

local Old; Old = hookmetamethod(game, "__namecall", function(Self, ...)
    local Args = {...}
    local Method = getnamecallmethod()
    
    if not checkcaller() then
        if getgenv().Settings.NoRecoil and (Self.Name == "Fire" or Self.Name == "UpdateCamera") then
            return nil
        end
        
        if (Self.Name == "RemoteEvent" and Args[1] == "Bullet" and Method == "FireServer") then
            if getgenv().Settings.InfiniteAmmo then
                return Old(Self, unpack(Args))
            end
            
            if getgenv().Settings.RapidFire then
                pcall(function()
                    for i = 1, 3 do
                        Old(Self, unpack(Args))
                    end
                end)
                return
            end
            
            if getgenv().Settings.Aimbot and Target and Target.Character and Target.Character.Humanoid.Health > 0 then
                local Hitbox = Target.Character:FindFirstChild(getgenv().Settings.Hitbox)
                if Hitbox then
                    Args[2] = Target.Character
                    Args[3] = Hitbox
                    Args[4] = Hitbox.Position
                end
            end
        end
    end
    
    return Old(Self, unpack(Args))
end)

KillAll()