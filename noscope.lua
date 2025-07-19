local SkyLib = {}
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

do
    local function Create(instanceType)
        return function(data)
            local obj = Instance.new(instanceType)
            for k, v in pairs(data) do
                if type(k) == 'number' then
                    v.Parent = obj
                else
                    obj[k] = v
                end
            end
            return obj
        end
    end

    local function makeDraggable(guiObject)
        local dragging = false
        local dragInput = nil
        local dragStart = nil
        local startPos = nil

        guiObject.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = guiObject.Parent.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)

        guiObject.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                guiObject.Parent.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end

    function SkyLib:CreateWindow(title)
        local screenGui = Create'ScreenGui'{
            Name = "SkyGui_"..math.random(1, 1000),
            Parent = game:GetService("CoreGui"),
            ZIndexBehavior = Enum.ZIndexBehavior.Global,
            ResetOnSpawn = false
        }

        local mainFrame = Create'Frame'{
            Name = "MainFrame",
            Size = UDim2.new(0, 550, 0, 350),
            Position = UDim2.new(0.5, -275, 0.5, -175),
            BackgroundColor3 = Color3.fromRGB(25, 25, 25),
            BorderSizePixel = 0,
            Parent = screenGui
        }
        
        local header = Create'Frame'{
            Name = "Header",
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundColor3 = Color3.fromRGB(15, 15, 15),
            BorderSizePixel = 0,
            Parent = mainFrame,
        }

        local titleLabel = Create'TextLabel'{
            Name = "Title",
            Size = UDim2.new(1, -60, 1, 0),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundColor3 = Color3.fromRGB(15, 15, 15),
            BackgroundTransparency = 1,
            TextColor3 = Color3.fromRGB(220, 220, 220),
            Text = title or "SkyLib",
            Font = Enum.Font.SourceSansBold,
            TextSize = 16,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = header,
            [1] = Create'UIPadding'{
                PaddingLeft = UDim.new(0, 10)
            }
        }
        
        local closeButton = Create'TextButton'{
            Name = "Close",
            Size = UDim2.new(0, 30, 1, 0),
            Position = UDim2.new(1, -30, 0, 0),
            BackgroundColor3 = Color3.fromRGB(15,15,15),
            BackgroundTransparency = 0,
            Text = "X",
            TextColor3 = Color3.fromRGB(220, 220, 220),
            Font = Enum.Font.SourceSansBold,
            TextSize = 16,
            Parent = header,
        }

        local minimizeButton = Create'TextButton'{
            Name = "Minimize",
            Size = UDim2.new(0, 30, 1, 0),
            Position = UDim2.new(1, -60, 0, 0),
            BackgroundColor3 = Color3.fromRGB(15,15,15),
            BackgroundTransparency = 0,
            Text = "-",
            TextColor3 = Color3.fromRGB(220, 220, 220),
            Font = Enum.Font.SourceSansBold,
            TextSize = 24,
            Parent = header,
        }

        local tabContainer = Create'Frame'{
            Name = "TabContainer",
            Size = UDim2.new(0, 100, 1, -30),
            Position = UDim2.new(0, 0, 0, 30),
            BackgroundColor3 = Color3.fromRGB(20, 20, 20),
            BorderSizePixel = 0,
            Parent = mainFrame
        }

        local contentContainer = Create'Frame'{
            Name = "ContentContainer",
            Size = UDim2.new(1, -100, 1, -30),
            Position = UDim2.new(0, 100, 0, 30),
            BackgroundColor3 = Color3.fromRGB(25, 25, 25),
            BorderSizePixel = 0,
            Parent = mainFrame,
            [1] = Create'UIPadding'{
                PaddingLeft = UDim.new(0, 10),
                PaddingRight = UDim.new(0, 10),
                PaddingTop = UDim.new(0, 10),
            }
        }

        makeDraggable(header)

        local tabs = {}
        local contentYOffset = 10

        local window = {}

        function window:MakeTab(tabName)
            local contentFrame = Create'Frame'{
                Name = tabName.."_Content",
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Parent = contentContainer,
                Visible = #tabs == 0
            }

            local tabButton = Create'TextButton'{
                Name = tabName,
                Size = UDim2.new(1, 0, 0, 35),
                BackgroundColor3 = Color3.fromRGB(20, 20, 20),
                Text = tabName,
                TextColor3 = Color3.fromRGB(200, 200, 200),
                Font = Enum.Font.SourceSans,
                TextSize = 16,
                Parent = tabContainer
            }
            
            table.insert(tabs, {button = tabButton, content = contentFrame})
            
            tabButton.MouseButton1Click:Connect(function()
                for _, t in pairs(tabs) do
                    t.content.Visible = false
                    t.button.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                end
                contentFrame.Visible = true
                tabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            end)

            if #tabs == 1 then
                tabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            end
            
            local tab = {
                _yOffset = 0,
                _frame = contentFrame,
            }

            function tab:AddToggle(data)
                local yPos = self._yOffset
                self._yOffset = self._yOffset + 25

                local toggleState = data.Default or false
                local callback = data.Callback or function() end

                local toggleFrame = Create'Frame'{
                    Name = data.Name,
                    Size = UDim2.new(1, 0, 0, 20),
                    Position = UDim2.new(0,0,0,yPos),
                    BackgroundTransparency = 1,
                    Parent = self._frame,
                }
                
                local toggleButton = Create'TextButton'{
                    Name = "Button",
                    Size = UDim2.new(0, 20, 0, 20),
                    BackgroundColor3 = toggleState and Color3.fromRGB(100, 180, 255) or Color3.fromRGB(50, 50, 50),
                    Text = "",
                    Parent = toggleFrame,
                }

                local label = Create'TextLabel'{
                    Name = "Label",
                    Size = UDim2.new(1, -30, 1, 0),
                    Position = UDim2.new(0, 30, 0, 0),
                    BackgroundTransparency = 1,
                    TextColor3 = Color3.fromRGB(220, 220, 220),
                    Text = data.Name or "Toggle",
                    Font = Enum.Font.SourceSans,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = toggleFrame
                }
                
                toggleButton.MouseButton1Click:Connect(function()
                    toggleState = not toggleState
                    toggleButton.BackgroundColor3 = toggleState and Color3.fromRGB(100, 180, 255) or Color3.fromRGB(50, 50, 50)
                    callback(toggleState)
                end)
                callback(toggleState)
            end

            function tab:AddButton(data)
                 local yPos = self._yOffset
                 self._yOffset = self._yOffset + 35

                 local button = Create'TextButton'{
                    Name = data.Name,
                    Size = UDim2.new(1, 0, 0, 30),
                    Position = UDim2.new(0,0,0,yPos),
                    BackgroundColor3 = Color3.fromRGB(50, 50, 50),
                    TextColor3 = Color3.fromRGB(220,220,220),
                    Text = data.Name or "Button",
                    Font = Enum.Font.SourceSansSemibold,
                    TextSize = 14,
                    Parent = self._frame
                 }
                 button.MouseButton1Click:Connect(function()
                     (data.Callback or function() end)(button)
                 end)
                 return button
            end

            return tab
        end
        
        local isMinimized = false
        minimizeButton.MouseButton1Click:Connect(function()
            isMinimized = not isMinimized
            contentContainer.Visible = not isMinimized
            tabContainer.Visible = not isMinimized
            mainFrame.Size = isMinimized and UDim2.new(0, 550, 0, 30) or UDim2.new(0, 550, 0, 350)
        end)
        
        closeButton.MouseButton1Click:Connect(function()
            screenGui:Destroy()
        end)

        return window
    end
end

local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local ESP_Objects = {}
local Aimbot_Target = nil

local Config = {
    Aimbot = { Enabled = false, Silent = false, Magic = false, Part = "Head" },
    ESP = {
        Enabled = false, Boxes = false, Names = false, Health = false, Distance = false,
        Tracers = false, Skeletons = false, LookAt = false, HeadDots = false, TeamColor = false,
        Color = Color3.fromRGB(255, 0, 255)
    }
}

local Window = SkyLib:CreateWindow("Project: SKYNET V2.1")

local EspTab = Window:MakeTab("ESP")
local AimTab = Window:MakeTab("Aim")
local MiscTab = Window:MakeTab("Misc")

local function getClosestPlayer()
    local closestPlayer, shortestDistance = nil, math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.Humanoid.Health > 0 then
            local distance = (player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                closestPlayer = player
            end
        end
    end
    return closestPlayer
end

local function createDrawing(className, properties)
    local d = Drawing.new(className)
    for k, v in pairs(properties or {}) do d[k] = v end
    table.insert(ESP_Objects, d)
    return d
end

local function drawSkeleton(player, color)
    local connections = {
        {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"}, {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"},
        {"LeftLowerArm", "LeftHand"}, {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"},
        {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"}, {"LowerTorso", "RightUpperLeg"},
        {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"},
    }
    for _, c in pairs(connections) do
        local p1, p2 = player.Character:FindFirstChild(c[1]), player.Character:FindFirstChild(c[2])
        if p1 and p2 then
            local v1, on1 = Camera:WorldToViewportPoint(p1.Position)
            local v2, on2 = Camera:WorldToViewportPoint(p2.Position)
            if on1 and on2 then
                createDrawing("Line", {From = Vector2.new(v1.X, v1.Y), To = Vector2.new(v2.X, v2.Y), Color = color, Thickness = 2, Visible = true})
            end
        end
    end
end

AimTab:AddToggle({ Name = "Aimbot", Default = false, Callback = function(v) Config.Aimbot.Enabled = v end })
AimTab:AddToggle({ Name = "Silent Aim", Default = false, Callback = function(v) Config.Aimbot.Silent = v end })
AimTab:AddToggle({ Name = "Magic Bullet", Default = false, Callback = function(v) Config.Aimbot.Magic = v end })
AimTab:AddButton({ Name = "Cycle Aim Part: Head", Callback = function(btn)
    if Config.Aimbot.Part == "Head" then
        Config.Aimbot.Part = "HumanoidRootPart"
        btn.Text = "Cycle Aim Part: HRP"
    elseif Config.Aimbot.Part == "HumanoidRootPart" then
         Config.Aimbot.Part = "Torso"
         btn.Text = "Cycle Aim Part: Torso"
    else
        Config.Aimbot.Part = "Head"
        btn.Text = "Cycle Aim Part: Head"
    end
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

MiscTab:AddButton({ Name = "Rejoin Server", Callback = function() game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer) end })

local oldMagicCFrame = nil

RunService.RenderStepped:Connect(function()
    for _, obj in ipairs(ESP_Objects) do obj:Remove() end
    ESP_Objects = {}

    if Config.Aimbot.Enabled or Config.Aimbot.Silent or Config.Aimbot.Magic then
        Aimbot_Target = getClosestPlayer()
    else
        Aimbot_Target = nil
    end

    if Aimbot_Target and Aimbot_Target.Character then
        local targetPart = Aimbot_Target.Character:FindFirstChild(Config.Aimbot.Part)
        if targetPart then
            if Config.Aimbot.Enabled then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
            end
            if Config.Aimbot.Silent then
                local mouse = LocalPlayer:GetMouse()
                mouse.Hit = CFrame.new(targetPart.Position)
            end
            if Config.Aimbot.Magic and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                oldMagicCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
                LocalPlayer.Character.HumanoidRootPart.CFrame = Aimbot_Target.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,-5)
                task.wait()
                if oldMagicCFrame then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = oldMagicCFrame
                    oldMagicCFrame = nil
                end
            end
        end
    end
    
    if not Config.Aimbot.Magic and oldMagicCFrame then
         if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = oldMagicCFrame
         end
         oldMagicCFrame = nil
    end
    
    if not Config.ESP.Enabled then return end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.Humanoid.Health > 0 then
            local rootPart = player.Character.HumanoidRootPart
            local head = player.Character:FindFirstChild("Head")
            local humanoid = player.Character.Humanoid
            
            local pos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
            
            if onScreen and head then
                local headPos, _ = Camera:WorldToViewportPoint(head.Position)
                local color = Config.ESP.TeamColor and player.TeamColor.Color or Config.ESP.Color
                local boxHeight = math.abs(headPos.Y - pos.Y) * 1.15
                local boxWidth = boxHeight / 2
                local boxTopLeft = Vector2.new(pos.X - boxWidth / 2, headPos.Y - boxHeight * 0.1)

                if Config.ESP.Tracers then
                    createDrawing("Line", {From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y), To = Vector2.new(pos.X, pos.Y), Color = color, Thickness = 1, Visible = true})
                end
                
                if Config.ESP.Boxes then
                     createDrawing("Quad", {
                        PointA = boxTopLeft,
                        PointB = Vector2.new(boxTopLeft.X + boxWidth, boxTopLeft.Y),
                        PointC = Vector2.new(boxTopLeft.X + boxWidth, boxTopLeft.Y + boxHeight),
                        PointD = Vector2.new(boxTopLeft.X, boxTopLeft.Y + boxHeight),
                        Color = color, Thickness = 2, Filled = false, Visible = true
                    })
                end

                if Config.ESP.Names then
                    createDrawing("Text", {Text = player.DisplayName, Size = 14, Color = color, Center = true, Position = boxTopLeft - Vector2.new(0, 15), Visible = true})
                end
                
                if Config.ESP.Distance then
                    local dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).magnitude)
                    createDrawing("Text", {Text = dist .. "m", Size = 12, Color = color, Center = true, Position = Vector2.new(pos.X, pos.Y + 5), Visible = true})
                end

                if Config.ESP.Health then
                    local health = humanoid.Health / humanoid.MaxHealth
                    local healthColor = Color3.fromHSV(health * 0.33, 1, 1)
                    local barX, barY = boxTopLeft.X - 6, boxTopLeft.Y
                    createDrawing("Line", {From=Vector2.new(barX, barY), To=Vector2.new(barX, barY + boxHeight), Color=Color3.new(0,0,0), Thickness=4, Visible=true})
                    createDrawing("Line", {From=Vector2.new(barX, barY + (boxHeight * (1 - health))), To=Vector2.new(barX, barY + boxHeight), Color=healthColor, Thickness=2, Visible=true})
                end

                if Config.ESP.Skeletons then drawSkeleton(player, color) end
                
                if Config.ESP.HeadDots then
                     createDrawing("Circle", {Position = headPos, Radius = 4, Color = color, Filled = true, Visible = true})
                end

                if Config.ESP.LookAt and head then
                    local start, finish = head.Position, head.Position + head.CFrame.LookVector * 10
                    local v1, on1 = Camera:WorldToViewportPoint(start)
                    local v2, on2 = Camera:WorldToViewportPoint(finish)
                    if on1 and on2 then
                        createDrawing("Line", {From=Vector2.new(v1.X, v1.Y), To=Vector2.new(v2.X, v2.Y), Color=color, Thickness=2, Visible=true})
                    end
                end
            end
        end
    end
end)
