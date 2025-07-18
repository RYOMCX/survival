local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local mouse = LocalPlayer:GetMouse()
local RunService = game:GetService("RunService")

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "NoScopeArcadeHack"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 350, 0, 370)
frame.Position = UDim2.new(0.05, 0, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "🎯 No Scope Arcade Hack"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(0, 255, 127)
title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)

local close = Instance.new("TextButton", frame)
close.Text = "❌"
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -35, 0, 5)
close.TextSize = 14
close.Font = Enum.Font.GothamBold
close.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 6)
close.MouseButton1Click:Connect(function() gui:Destroy() end)

local min = Instance.new("TextButton", frame)
min.Text = "—"
min.Size = UDim2.new(0, 30, 0, 30)
min.Position = UDim2.new(1, -70, 0, 5)
min.TextSize = 14
min.Font = Enum.Font.GothamBold
min.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Instance.new("UICorner", min).CornerRadius = UDim.new(0, 6)
local minimized = false
min.MouseButton1Click:Connect(function()
    minimized = not minimized
    for _,v in pairs(frame:GetChildren()) do
        if v:IsA("TextButton") or v:IsA("TextLabel") then
            if v ~= title and v ~= min and v ~= close then
                v.Visible = not minimized
            end
        end
    end
end)

local function createButton(text, y)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(0.9, 0, 0, 30)
	btn.Position = UDim2.new(0.05, 0, y, 0)
	btn.Text = text
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 15
	btn.TextColor3 = Color3.new(1,1,1)
	btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
	btn.BorderSizePixel = 0
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
	return btn
end

createButton("🎥 POV Mode", 0.2).MouseButton1Click:Connect(function()
	Camera.FieldOfView = 50
end)

createButton("🔵 Show POV Circle", 0.3).MouseButton1Click:Connect(function()
	local circle = Instance.new("Frame", gui)
	circle.Size = UDim2.new(0, 100, 0, 100)
	circle.Position = UDim2.new(0.5, -50, 0.5, -50)
	circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	circle.BackgroundTransparency = 0.8
	circle.BorderSizePixel = 0
	Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
	wait(5)
	circle:Destroy()
end)

createButton("💀 Auto Kill", 0.4).MouseButton1Click:Connect(function()
	for _,v in pairs(Players:GetPlayers()) do
		if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") then
			local dist = (LocalPlayer.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
			if dist < 50 then
				v.Character.Humanoid.Health = 0
			end
		end
	end
end)

createButton("⚡ Speed Boost", 0.5).MouseButton1Click:Connect(function()
	local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
	if hum then hum.WalkSpeed = 50 end
end)

createButton("⛅ Jump Boost", 0.6).MouseButton1Click:Connect(function()
	local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
	if hum then hum.JumpPower = 120 end
end)

createButton("🎯 Auto Headshot (Silent Aim)", 0.7).MouseButton1Click:Connect(function()
	getgenv().SilentHeadshot = true
	local function GetClosestEnemy()
		local closest, dist = nil, math.huge
		for _, v in pairs(Players:GetPlayers()) do
			if v ~= LocalPlayer and v.Team ~= LocalPlayer.Team and v.Character and v.Character:FindFirstChild("Head") then
				local pos, onScreen = Camera:WorldToViewportPoint(v.Character.Head.Position)
				if onScreen then
					local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude
					if mag < dist then
						dist = mag
						closest = v
					end
				end
			end
		end
		return closest
	end
	local old
	old = hookmetamethod(game, "__namecall", function(self, ...)
		local args = {...}
		if getgenv().SilentHeadshot and tostring(self) == "Raycast" and getnamecallmethod() == "FindPartOnRayWithIgnoreList" then
			local target = GetClosestEnemy()
			if target and target.Character and target.Character:FindFirstChild("Head") then
				if math.random(1,100) <= 95 then
					args[1] = Ray.new(Camera.CFrame.Position, (target.Character.Head.Position - Camera.CFrame.Position).Unit * 999)
					return old(self, unpack(args))
				end
			end
		end
		return old(self, ...)
	end)
end)

createButton("📦 Toggle ESP", 0.8).MouseButton1Click:Connect(function()
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer then
			local box = Drawing.new("Square")
			box.Thickness = 1.5
			box.Color = Color3.fromRGB(0, 255, 0)
			box.Transparency = 1
			box.Visible = false

			local name = Drawing.new("Text")
			name.Size = 14
			name.Color = Color3.fromRGB(255, 255, 255)
			name.Center = true
			name.Outline = true
			name.Visible = false

			local health = Drawing.new("Square")
			health.Filled = true
			health.Color = Color3.fromRGB(255, 0, 0)
			health.Visible = false

			local line = Drawing.new("Line")
			line.Color = Color3.fromRGB(255, 255, 0)
			line.Thickness = 1.5
			line.Visible = false

			RunService.RenderStepped:Connect(function()
				if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChild("Humanoid") then
					local pos, onScreen = Camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
					local headPos = Camera:WorldToViewportPoint(plr.Character.Head.Position + Vector3.new(0, 0.5, 0))
					local rootPos = Camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position - Vector3.new(0, 2.5, 0))
					if onScreen and plr.Character.Humanoid.Health > 0 then
						local h = math.abs(headPos.Y - rootPos.Y)
						local w = h / 2
						box.Size = Vector2.new(w, h)
						box.Position = Vector2.new(pos.X - w/2, pos.Y - h/2)
						box.Visible = true
						name.Text = plr.Name
						name.Position = Vector2.new(pos.X, pos.Y - h/2 - 14)
						name.Visible = true
						local hpRatio = plr.Character.Humanoid.Health / plr.Character.Humanoid.MaxHealth
						local hpHeight = h * hpRatio
						health.Size = Vector2.new(4, hpHeight)
						health.Position = Vector2.new(pos.X - w/2 - 6, pos.Y + h/2 - hpHeight)
						health.Visible = true
						line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
						line.To = Vector2.new(pos.X, pos.Y + h/2)
						line.Visible = true
					else
						box.Visible = false
						name.Visible = false
						health.Visible = false
						line.Visible = false
					end
				else
					box.Visible = false
					name.Visible = false
					health.Visible = false
					line.Visible = false
				end
			end)
		end
	end
end)
