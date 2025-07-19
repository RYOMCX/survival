local plr = game.Players.LocalPlayer
local mouse = plr:GetMouse()
local cam = workspace.CurrentCamera

local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
gui.Name = "RYOFC_HACK_GUI"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 600, 0, 400)
main.Position = UDim2.new(0.5, -300, 0.5, -200)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

local minimize = Instance.new("TextButton", main)
minimize.Text = "_"
minimize.Size = UDim2.new(0, 60, 0, 30)
minimize.Position = UDim2.new(1, -120, 0, 0)
minimize.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
minimize.TextColor3 = Color3.new(1, 1, 1)

local close = Instance.new("TextButton", main)
close.Text = "X"
close.Size = UDim2.new(0, 60, 0, 30)
close.Position = UDim2.new(1, -60, 0, 0)
close.BackgroundColor3 = Color3.fromRGB(80, 20, 20)
close.TextColor3 = Color3.new(1, 1, 1)

local minimized = false
minimize.MouseButton1Click:Connect(function()
    minimized = not minimized
    for _, c in pairs(main:GetChildren()) do
        if c:IsA("TextButton") or c:IsA("Frame") then
            if c ~= minimize and c ~= close then
                c.Visible = not minimized
            end
        end
    end
    minimize.Text = minimized and "RYOFC HACKS" or "_"
end)

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

function createTab(y)
    local f = Instance.new("Frame", main)
    f.Size = UDim2.new(0, 580, 0, 100)
    f.Position = UDim2.new(0, 10, 0, y)
    f.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    return f
end

local espTab = createTab(40)
local miscTab = createTab(150)

function toggle(name, parent, callback)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0, 180, 0, 25)
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    b.TextColor3 = Color3.new(1,1,1)
    b.Text = "[OFF] " .. name
    local on = false
    b.MouseButton1Click:Connect(function()
        on = not on
        b.Text = (on and "[ON] " or "[OFF] ") .. name
        callback(on)
    end)
end

function getClosest()
    local dist, target = math.huge, nil
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= plr and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local mag = (v.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
            if mag < dist then
                dist = mag
                target = v
            end
        end
    end
    return target
end

-- ESP Fitur
toggle("ESP Box", espTab, function(state)
    if state then
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= plr and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local b = Instance.new("BoxHandleAdornment", p.Character)
                b.Name = "ESPBox"
                b.Adornee = p.Character.HumanoidRootPart
                b.AlwaysOnTop = true
                b.ZIndex = 5
                b.Size = p.Character.HumanoidRootPart.Size
                b.Transparency = 0.4
                b.Color3 = Color3.fromRGB(255, 0, 0)
            end
        end
    else
        for _, p in pairs(game.Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("ESPBox") then
                p.Character.ESPBox:Destroy()
            end
        end
    end
end)

toggle("ESP Name", espTab, function(state)
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= plr and p.Character and p.Character:FindFirstChild("Head") then
            if state then
                local tag = Instance.new("BillboardGui", p.Character.Head)
                tag.Name = "NameTag"
                tag.Size = UDim2.new(0, 100, 0, 40)
                tag.AlwaysOnTop = true
                local text = Instance.new("TextLabel", tag)
                text.Size = UDim2.new(1, 0, 1, 0)
                text.BackgroundTransparency = 1
                text.Text = p.Name
                text.TextColor3 = Color3.new(1, 1, 1)
                text.TextScaled = true
            else
                if p.Character.Head:FindFirstChild("NameTag") then
                    p.Character.Head.NameTag:Destroy()
                end
            end
        end
    end
end)

for i = 3, 22 do
    toggle("ESP Feature " .. i, espTab, function(state)
        -- Misalnya tambahkan fitur ESP lain:
        if state then
            print("ESP Fitur " .. i .. " aktif")
        end
    end)
end

-- MISC Fitur

toggle("Anti Kick", miscTab, function(s)
    if s then
        local mt = getrawmetatable(game)
        setreadonly(mt, false)
        local old = mt.__namecall
        mt.__namecall = newcclosure(function(self, ...)
            if getnamecallmethod() == "Kick" then return nil end
            return old(self, ...)
        end)
    end
end)

toggle("No Recoil", miscTab, function(s)
    if s then
        local tool = plr.Character:FindFirstChildOfClass("Tool")
        if tool and tool:FindFirstChild("Recoil") then
            tool.Recoil.Value = 0
        end
    end
end)

toggle("Infinite Ammo", miscTab, function(s)
    if s then
        local tool = plr.Character:FindFirstChildOfClass("Tool")
        if tool and tool:FindFirstChild("Ammo") then
            tool.Ammo.Value = 9999
        end
    end
end)

toggle("Fly", miscTab, function(s)
    if s then
        local bp = Instance.new("BodyPosition", plr.Character.HumanoidRootPart)
        bp.Name = "Fly"
        bp.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        game:GetService("RunService").RenderStepped:Connect(function()
            if bp and plr.Character then
                bp.Position = plr.Character.HumanoidRootPart.Position + Vector3.new(0, 5, 0)
            end
        end)
    else
        if plr.Character.HumanoidRootPart:FindFirstChild("Fly") then
            plr.Character.HumanoidRootPart.Fly:Destroy()
        end
    end
end)

toggle("God Mode", miscTab, function(s)
    if s then
        local h = plr.Character:FindFirstChild("Humanoid")
        if h then h.MaxHealth = math.huge h.Health = math.huge end
    end
end)

toggle("Teleport to Closest", miscTab, function(s)
    if s then
        local t = getClosest()
        if t then plr.Character:MoveTo(t.Character.HumanoidRootPart.Position + Vector3.new(0, 5, 0)) end
    end
end)

toggle("Fake Lag", miscTab, function(s)
    settings().Network.IncomingReplicationLag = s and 10 or 0
end)

toggle("No Fall Damage", miscTab, function(s)
    if s then
        plr.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
    else
        plr.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
    end
end)

toggle("Auto Heal", miscTab, function(s)
    if s then
        while s do
            wait(1)
            if plr.Character:FindFirstChild("Humanoid") then
                plr.Character.Humanoid.Health = plr.Character.Humanoid.MaxHealth
            end
        end
    end
end)

toggle("Invisible", miscTab, function(s)
    for _, v in pairs(plr.Character:GetDescendants()) do
        if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
            v.Transparency = s and 1 or 0
        end
    end
end)

toggle("Speed x2", miscTab, function(s)
    if plr.Character:FindFirstChild("Humanoid") then
        plr.Character.Humanoid.WalkSpeed = s and 32 or 16
    end
end)

toggle("High FOV", miscTab, function(s)
    cam.FieldOfView = s and 120 or 70
end)
