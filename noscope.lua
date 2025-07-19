task.wait()

-- // Core Services
local Players, RunService, UserInputService, Workspace, CoreGui, Lighting, TeleportService, ReplicatedStorage, VirtualInputManager =
    game:GetService("Players"),
    game:GetService("RunService"),
    game:GetService("UserInputService"),
    game:GetService("Workspace"),
    game:GetService("CoreGui"),
    game:GetService("Lighting"),
    game:GetService("TeleportService"),
    game:GetService("ReplicatedStorage"),
    game:GetService("VirtualInputManager")

-- // Local Environment
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local DrawingObjects = {} -- A table to hold all active 'Drawing' objects for easy cleanup.

-- // Global Settings Table
-- This table is placed in the 'getgenv()' environment, allowing it to be accessed by other scripts if needed.
-- It holds the state for every single toggle, slider, and option in the UI.
getgenv().SkyDominatorSettings = {
    Aim = {
        -- Aimbot Settings
        AimbotEnabled = false,      -- Master switch for the aimbot functionality.
        AimOnKey = true,            -- Requires holding a key (Right Mouse) to activate.
        AimPart = "Head",           -- The body part the aimbot will target. (e.g., "HumanoidRootPart")
        TeamCheck = true,           -- If true, the aimbot will ignore teammates.
        VisibleCheck = true,        -- If true, the aimbot will only target visible players.
        FOVCircle = false,          -- If true, a circle showing the aimbot's field of view will be drawn.
        FOV = 100,                  -- The radius (in pixels) from the mouse that the aimbot will search for targets.

        -- Advanced Aim Settings
        SilentAimEnabled = false,   -- Master switch for the silent aim functionality.
        MagicBulletEnabled = false, -- Master switch for the magic bullet functionality.
        RemoteSearch = true         -- Attempt to automatically find game's firing remote for Silent Aim.
    },
    ESP = {
        -- Master ESP Switch
        Enabled = true,             -- The main switch for all visual features.

        -- Player ESP Features
        Names = true,               -- Show player names.
        Distance = true,            -- Show distance to player.
        Health = true,              -- Show a health bar and/or text.
        Boxes = true,               -- Draw a 2D or 3D box around players.
        Skeleton = true,            -- Draw lines connecting player's body parts.
        Tracers = true,             -- Draw a line from the bottom of the screen to players.
        TeamCheck = true,           -- If true, ESP will not be drawn on teammates.

        -- ESP Styling
        VisibleColor = Color3.fromRGB(255, 0, 80),  -- Color for visible players.
        InvisibleColor = Color3.fromRGB(255, 150, 0), -- Color for players behind walls.
        BoxMode = "2D"              -- Can be "2D" or "3D".
    },
    Misc = {
        -- Utility Features
        AntiAFK = false,            -- Prevents the game from kicking you for being idle.
        ChatSpy = false,            -- Prints other players' chat messages to the developer console.
        NoFallDamage = false,       -- Prevents you from taking fall damage.
        FullBright = false,         -- Makes the environment permanently bright.
        Noclip = false,             -- Allows you to fly through walls.
        
        -- Interactive Features
        ClickTeleportEnabled = false, -- Teleport to where you click (requires keybind).
        ClickTeleportKey = Enum.KeyCode.LeftAlt,

        -- Player Modification
        InfiniteStamina = false,    -- Prevents stamina from draining if the game has a stamina system.
        AntiAim = false,            -- Attempts to mess up your hitbox to make you harder to hit.
        
        -- World & UI
        CustomCrosshair = false,    -- Draws a custom crosshair on your screen.
        RemoveFog = false,          -- Removes fog from the game world.

        -- Camera Settings
        CameraFOV = 70              -- The value for the Field of View slider.
    }
}
local Settings = getgenv().SkyDominatorSettings -- Create a local alias for easier access.

-- // Global Runtime Variables
local NoclipEnabled = false
local NoclipConnection = nil
local OriginalLighting = {} -- Store original lighting settings for FullBright toggle.
local FoundFireRemote = nil -- Store the remote found by the remote spy for Silent Aim.

--[[ ==========================================================================================================================================================
    SECTION 2: CORE LIBRARIES (INTERNAL)
    This section contains self-made libraries for handling common tasks like drawing, UI creation, and remote event manipulation.
    This modular approach keeps the main code clean and makes it easier to manage and expand.
-- ========================================================================================================================================================== ]]

-- // Drawing Manager Library
-- Manages the creation and destruction of 'Drawing' objects to prevent memory leaks and screen clutter.
local DrawingManager = {}
function DrawingManager:Add(object)
    table.insert(DrawingObjects, object)
    return object
end
function DrawingManager:Clear()
    for i, object in ipairs(DrawingObjects) do
        object:Remove() -- Properly destroy the drawing object.
    end
    DrawingObjects = {} -- Clear the table.
end

-- // Remote Spy Library
-- This library is designed to find potentially vulnerable remote events that handle shooting or damage.
-- This is crucial for making features like Silent Aim functional across different games.
local RemoteSpy = {}
function RemoteSpy:FindFireRemote()
    if FoundFireRemote then return FoundFireRemote end -- Return cached remote if already found.

    local searchAreas = {ReplicatedStorage, LocalPlayer.PlayerGui} -- Common places for remotes.
    local commonNames = {"Fire", "Damage", "Shoot", "Bullet", "Hit", "DealDamage"}

    for _, area in pairs(searchAreas) do
        for _, remote in ipairs(area:GetDescendants()) do
            if remote:IsA("RemoteEvent") then
                for _, name in ipairs(commonNames) do
                    if string.find(remote.Name:lower(), name:lower()) then
                        FoundFireRemote = remote -- Cache the found remote.
                        return remote
                    end
                end
            end
        end
    end
    return nil -- Return nil if no suitable remote is found.
end

-- // UI Creation Library
-- A comprehensive, verbose library for building the script's graphical user interface from scratch.
local UI_Lib = {}
local UIElements = {} -- Keep track of created UI elements.
function UI_Lib:CreateWindow(title)
    local screenGui = Instance.new("ScreenGui", CoreGui)
    screenGui.Name = "SkyDominator_GUI_V6"
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    screenGui.ResetOnSpawn = false
    UIElements.ScreenGui = screenGui

    local mainWindow = Instance.new("Frame", screenGui)
    mainWindow.Name = "MainWindow"
    mainWindow.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    mainWindow.BorderColor3 = Color3.fromRGB(255, 0, 80)
    mainWindow.BorderSizePixel = 1
    mainWindow.Position = UDim2.new(0.5, -250, 0.5, -225)
    mainWindow.Size = UDim2.new(0, 500, 0, 450)
    mainWindow.Active = true
    mainWindow.Draggable = true
    mainWindow.ClipsDescendants = true
    UIElements.MainWindow = mainWindow

    local titleBar = Instance.new("Frame", mainWindow)
    titleBar.Name = "TitleBar"
    titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    titleBar.Size = UDim2.new(1, 0, 0, 30)

    local titleLabel = Instance.new("TextLabel", titleBar)
    titleLabel.Name = "TitleLabel"
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0.03, 0, 0, 0)
    titleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    titleLabel.Font = Enum.Font.SourceSansSemibold
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local closeButton = Instance.new("TextButton", titleBar)
    closeButton.Name = "CloseButton"
    closeButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    closeButton.Position = UDim2.new(1, -30, 0, 0)
    closeButton.Size = UDim2.new(0, 30, 1, 0)
    closeButton.Font = Enum.Font.SourceSans
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.MouseButton1Click:Connect(function() screenGui:Destroy() end)

    local minimizeButton = Instance.new("TextButton", titleBar)
    minimizeButton.Name = "MinimizeButton"
    minimizeButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    minimizeButton.Position = UDim2.new(1, -60, 0, 0)
    minimizeButton.Size = UDim2.new(0, 30, 1, 0)
    minimizeButton.Font = Enum.Font.SourceSans
    minimizeButton.Text = "—"
    minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)

    local tabContainer = Instance.new("Frame", mainWindow)
    tabContainer.Position = UDim2.new(0, 0, 0, 30)
    tabContainer.Size = UDim2.new(1, 0, 0, 35)
    tabContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    UIElements.TabContainer = tabContainer

    local pagesContainer = Instance.new("Frame", mainWindow)
    pagesContainer.Position = UDim2.new(0, 0, 0, 65)
    pagesContainer.Size = UDim2.new(1, 0, 1, -65)
    pagesContainer.BackgroundTransparency = 1
    UIElements.PagesContainer = pagesContainer
    
    minimizeButton.MouseButton1Click:Connect(function()
        local isMinimized = not pagesContainer.Visible
        pagesContainer.Visible = isMinimized
        tabContainer.Visible = isMinimized
        mainWindow.Size = isMinimized and UDim2.new(0, 500, 0, 450) or UDim2.new(0, 500, 0, 30)
    end)
    
    -- Draggable Logic
    local dragging, dragInput, dragStart, startPos
    titleBar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging, dragStart, startPos = true, input.Position, mainWindow.Position; input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end) end end)
    titleBar.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
    UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then local delta = input.Position - dragStart; mainWindow.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)

    return UIElements
end

function UI_Lib:CreateTabs(tabNames)
    local Pages = {}
    for i, tabName in ipairs(tabNames) do
        local Page = Instance.new("ScrollingFrame", UIElements.PagesContainer)
        Page.Name = tabName .. "Page"
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.BorderSizePixel = 0
        Page.Visible = (i == 1) -- Only the first page is visible by default.
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        Page.ScrollBarThickness = 6
        Pages[tabName] = Page

        local TabButton = Instance.new("TextButton", UIElements.TabContainer)
        TabButton.Size = UDim2.new(0, 100, 1, 0)
        TabButton.Position = UDim2.new(0, 10 + (i-1) * 110, 0, 0)
        TabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabButton.Text = tabName
        TabButton.Font = Enum.Font.SourceSansSemibold
        
        TabButton.MouseButton1Click:Connect(function()
            for name, page in pairs(Pages) do page.Visible = (name == tabName) end
        end)
    end
    return Pages
end

function UI_Lib:CreateToggle(parentPage, text, settingsTable, settingsKey, callback)
    local currentY = parentPage.CanvasSize.Y.Offset
    local frame = Instance.new("Frame", parentPage)
    frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    frame.Size = UDim2.new(1, -20, 0, 30)
    frame.Position = UDim2.new(0, 10, 0, currentY + 10)
    Instance.new("UICorner", frame)

    local label = Instance.new("TextLabel", frame); label.Size = UDim2.new(0.7, 0, 1, 0); label.BackgroundTransparency = 1; label.Font = Enum.Font.SourceSans; label.TextColor3 = Color3.fromRGB(255, 255, 255); label.Text = text; label.TextXAlignment = Enum.TextXAlignment.Left; label.Position = UDim2.new(0, 10, 0, 0)
    local button = Instance.new("TextButton", frame); button.Size = UDim2.new(0.25, 0, 0.8, 0); button.Position = UDim2.new(0.725, 0, 0.1, 0); button.BackgroundColor3 = settingsTable[settingsKey] and Color3.fromRGB(255, 0, 80) or Color3.fromRGB(80, 80, 80); button.Font = Enum.Font.SourceSansBold; button.Text = settingsTable[settingsKey] and "ON" or "OFF"; button.TextColor3 = Color3.fromRGB(255, 255, 255); Instance.new("UICorner", button)
    
    button.MouseButton1Click:Connect(function()
        settingsTable[settingsKey] = not settingsTable[settingsKey]
        button.BackgroundColor3 = settingsTable[settingsKey] and Color3.fromRGB(255, 0, 80) or Color3.fromRGB(80, 80, 80)
        button.Text = settingsTable[settingsKey] and "ON" or "OFF"
        if callback then callback(settingsTable[settingsKey]) end
    end)
    parentPage.CanvasSize = UDim2.new(0, 0, 0, currentY + 40)
end

function UI_Lib:CreateButton(parentPage, text, callback)
    local currentY = parentPage.CanvasSize.Y.Offset
    local button = Instance.new("TextButton", parentPage)
    button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    button.Size = UDim2.new(1, -20, 0, 30)
    button.Position = UDim2.new(0, 10, 0, currentY + 10)
    button.Font = Enum.Font.SourceSansSemibold
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255,255,255)
    Instance.new("UICorner", button)
    button.MouseButton1Click:Connect(callback)
    parentPage.CanvasSize = UDim2.new(0, 0, 0, currentY + 40)
end

function UI_Lib:CreateSlider(parentPage, text, min, max, start, settingsTable, settingsKey, callback)
    local currentY = parentPage.CanvasSize.Y.Offset
    local frame = Instance.new("Frame", parentPage)
    frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    frame.Size = UDim2.new(1, -20, 0, 50)
    frame.Position = UDim2.new(0, 10, 0, currentY + 10)
    Instance.new("UICorner", frame)
    
    local label = Instance.new("TextLabel", frame); label.Size = UDim2.new(1, -20, 0.5, 0); label.BackgroundTransparency = 1; label.Font = Enum.Font.SourceSans; label.TextColor3 = Color3.fromRGB(255, 255, 255); label.Text = text .. ": " .. start; label.TextXAlignment = Enum.TextXAlignment.Left; label.Position = UDim2.new(0, 10, 0, 0)
    local slider = Instance.new("Slider", frame); slider.Size = UDim2.new(1, -20, 0.5, 0); slider.Position = UDim2.new(0, 10, 0.5, 0); slider.MinValue = min; slider.MaxValue = max; slider.Value = start
    
    slider.ValueChanged:Connect(function(val)
        local intVal = math.floor(val)
        label.Text = text .. ": " .. intVal
        settingsTable[settingsKey] = intVal
        if callback then callback(intVal) end
    end)
    parentPage.CanvasSize = UDim2.new(0, 0, 0, currentY + 60)
end

--[[ ==========================================================================================================================================================
    SECTION 3: UI CONSTRUCTION
    This section uses the UI_Lib to build the visible interface for the user.
-- ========================================================================================================================================================== ]]

-- // Create the main window and tabs
UI_Lib:CreateWindow("SkyDominator V6 - MEGASYSTEM :: RYOXFC")
local Pages = UI_Lib:CreateTabs({"Aim", "ESP", "Misc", "Settings"})

-- // Populate Aim Page
UI_Lib:CreateToggle(Pages.Aim, "Enable Aimbot", Settings.Aim, "AimbotEnabled")
UI_Lib:CreateToggle(Pages.Aim, "Aim on Key (RMB)", Settings.Aim, "AimOnKey")
UI_Lib:CreateToggle(Pages.Aim, "Team Check", Settings.Aim, "TeamCheck")
UI_Lib:CreateToggle(Pages.Aim, "Visibility Check", Settings.Aim, "VisibleCheck")
UI_Lib:CreateToggle(Pages.Aim, "Show FOV Circle", Settings.Aim, "FOVCircle")
UI_Lib:CreateSlider(Pages.Aim, "FOV Radius", 10, 500, Settings.Aim.FOV, Settings.Aim, "FOV")
UI_Lib:CreateToggle(Pages.Aim, "Enable Silent Aim", Settings.Aim, "SilentAimEnabled")
UI_Lib:CreateToggle(Pages.Aim, "Enable Magic Bullet", Settings.Aim, "MagicBulletEnabled")
UI_Lib:CreateToggle(Pages.Aim, "Auto-Find Fire Remote", Settings.Aim, "RemoteSearch", function(state) if state then RemoteSpy:FindFireRemote() end end)

-- // Populate ESP Page
UI_Lib:CreateToggle(Pages.ESP, "Master ESP Switch", Settings.ESP, "Enabled")
UI_Lib:CreateToggle(Pages.ESP, "Show Names", Settings.ESP, "Names")
UI_Lib:CreateToggle(Pages.ESP, "Show Distance", Settings.ESP, "Distance")
UI_Lib:CreateToggle(Pages.ESP, "Show Health Bars", Settings.ESP, "Health")
UI_Lib:CreateToggle(Pages.ESP, "Show Boxes", Settings.ESP, "Boxes")
UI_Lib:CreateToggle(Pages.ESP, "Show Skeletons", Settings.ESP, "Skeleton")
UI_Lib:CreateToggle(Pages.ESP, "Show Tracers", Settings.ESP, "Tracers")
UI_Lib:CreateToggle(Pages.ESP, "Ignore Teammates", Settings.ESP, "TeamCheck")

-- // Populate Misc Page
UI_Lib:CreateToggle(Pages.Misc, "Anti-AFK", Settings.Misc, "AntiAFK")
UI_Lib:CreateToggle(Pages.Misc, "Chat Spy", Settings.Misc, "ChatSpy")
UI_Lib:CreateToggle(Pages.Misc, "No Fall Damage", Settings.Misc, "NoFallDamage")
UI_Lib:CreateToggle(Pages.Misc, "Full Bright", Settings.Misc, "FullBright")
UI_Lib:CreateToggle(Pages.Misc, "Noclip", Settings.Misc, "Noclip")
UI_Lib:CreateToggle(Pages.Misc, "Click Teleport", Settings.Misc, "ClickTeleportEnabled")
UI_Lib:CreateToggle(Pages.Misc, "Infinite Stamina", Settings.Misc, "InfiniteStamina")
UI_Lib:CreateToggle(Pages.Misc, "Anti-Aim (Local)", Settings.Misc, "AntiAim")
UI_Lib:CreateToggle(Pages.Misc, "Custom Crosshair", Settings.Misc, "CustomCrosshair")
UI_Lib:CreateToggle(Pages.Misc, "Remove Fog", Settings.Misc, "RemoveFog")
UI_Lib:CreateButton(Pages.Misc, "Server Hop", function() pcall(TeleportService.Teleport, TeleportService, game.PlaceId) end)
UI_Lib:CreateButton(Pages.Misc, "Give BTools", function() pcall(function() for _,v in pairs({"Clone", "Copy", "Delete"}) do local t=Instance.new("HopperBin", LocalPlayer.Backpack); t.BinType=Enum.BinType[v] end end) end)
UI_LIb:CreateButton(Pages.Misc, "Infinite Yield", function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end)

-- // Populate Settings Page
UI_Lib:CreateSlider(Pages.Settings, "Camera FOV", 30, 120, Settings.Misc.CameraFOV, Settings.Misc, "CameraFOV", function(val) Camera.FieldOfView = val end)

--[[ ==========================================================================================================================================================
    SECTION 4: FEATURE IMPLEMENTATIONS
    This section contains the logic for all features. Each function is designed to be as robust and error-proof as possible.
-- ========================================================================================================================================================== ]]

-- // Utility Functions
local function GetBestTarget()
    local bestTarget, smallestDistance = nil, math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.Humanoid.Health > 0 then
            if Settings.Aim.TeamCheck and player.TeamColor == LocalPlayer.TeamColor then continue end
            
            local rootPart = player.Character.HumanoidRootPart
            local screenPosition, onScreen = Camera:WorldToScreenPoint(rootPart.Position)
            if onScreen then
                local distance = (Vector2.new(screenPosition.X, screenPosition.Y) - UserInputService:GetMouseLocation()).Magnitude
                if distance < smallestDistance and distance < Settings.Aim.FOV then
                    if Settings.Aim.VisibleCheck and not IsVisible(rootPart) then continue end
                    smallestDistance = distance
                    bestTarget = player
                end
            end
        end
    end
    return bestTarget
end

function IsVisible(part)
    local _, onScreen = Camera:WorldToScreenPoint(part.Position)
    if not onScreen then return false end
    return not Workspace:FindPartOnRayWithIgnoreList(Ray.new(Camera.CFrame.Position, part.Position - Camera.CFrame.Position), {LocalPlayer.Character})
end

-- // Feature Handlers
function Aimbot_Handler()
    if Settings.Aim.AimOnKey and not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then return end
    local targetPlayer = GetBestTarget()
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild(Settings.Aim.AimPart) then
        local targetPart = targetPlayer.Character[Settings.Aim.AimPart]
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
    end
end

-- This is a conceptual implementation. The actual remote event arguments will vary widely between games.
function SilentAim_Handler()
    if not FoundFireRemote then return end
    -- The hook would be placed here, for example:
    -- FoundFireRemote.OnClientEvent:Connect(function(...)
    --      local args = {...}
    --      local target = GetBestTarget()
    --      if target then args[2] = target.Character.HumanoidRootPart.Position end -- Modify direction/target argument
    --      FoundFireRemote:FireServer(unpack(args))
    -- end)
    -- This requires a proper __namecall hook or remote spy to prevent the original call.
end

-- Modular ESP Drawing Functions
function DrawESP_Box(player, root, color)
    local cf, size = root.CFrame, player.Character:GetExtentsSize() * 1.1
    local points = {(cf*CFrame.new(size.X/2,size.Y/2,0)).Position,(cf*CFrame.new(-size.X/2,size.Y/2,0)).Position,(cf*CFrame.new(-size.X/2,-size.Y/2,0)).Position,(cf*CFrame.new(size.X/2,-size.Y/2,0)).Position}
    local screenPoints, valid = {}, true
    for _, p in ipairs(points) do local sp, os = Camera:WorldToScreenPoint(p); if not os then valid=false; break end; table.insert(screenPoints, Vector2.new(sp.X, sp.Y)) end
    if valid then for i=1,#screenPoints do DrawingManager:Add(Drawing.new("Line"){From=screenPoints[i],To=screenPoints[i%#screenPoints+1],Color=color,Thickness=1}) end end
end
function DrawESP_Health(screenPos, humanoid)
    local hpRatio = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
    local barColor = Color3.fromHSV(hpRatio / 3, 1, 1)
    local barY = screenPos.Y + 35
    DrawingManager:Add(Drawing.new("Line"){From=Vector2.new(screenPos.X-25,barY),To=Vector2.new(screenPos.X+25,barY),Color=Color3.new(0,0,0),Thickness=4})
    DrawingManager:Add(Drawing.new("Line"){From=Vector2.new(screenPos.X-25,barY),To=Vector2.new(screenPos.X-25+(50*hpRatio),barY),Color=barColor,Thickness=4})
end
function DrawESP_Skeleton(character, color)
    local bones = {Head="UpperTorso",UpperTorso="LowerTorso",LowerTorso="RightUpperLeg",RightUpperLeg="RightLowerLeg",RightLowerLeg="RightFoot",LowerTorso="LeftUpperLeg",LeftUpperLeg="LeftLowerLeg",LeftLowerLeg="LeftFoot",UpperTorso="RightUpperArm",RightUpperArm="RightLowerArm",RightLowerArm="RightHand",UpperTorso="LeftUpperArm",LeftUpperArm="LeftLowerArm",LeftLowerArm="LeftHand"}
    for from,to in pairs(bones) do
        local p1,p2 = character:FindFirstChild(from),character:FindFirstChild(to)
        if p1 and p2 then
            local sp1,os1=Camera:WorldToScreenPoint(p1.Position); local sp2,os2=Camera:WorldToScreenPoint(p2.Position)
            if os1 and os2 then DrawingManager:Add(Drawing.new("Line"){From=Vector2.new(sp1.X,sp1.Y),To=Vector2.new(sp2.X,sp2.Y),Color=color,Thickness=1}) end
        end
    end
end

function Master_ESP_Handler(player)
    local character = player.Character
    if not (character and character.Parent and character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("Humanoid")) then return end
    local humanoid = character.Humanoid
    if humanoid.Health <= 0 then return end

    local rootPart = character.HumanoidRootPart
    local isVisible = IsVisible(rootPart)
    local color = isVisible and Settings.ESP.VisibleColor or Settings.ESP.InvisibleColor
    local screenPos, onScreen = Camera:WorldToScreenPoint(rootPart.Position)

    if onScreen then
        if Settings.ESP.Names or Settings.ESP.Distance then
            local info = {}
            if Settings.ESP.Names then table.insert(info, player.Name) end
            if Settings.ESP.Distance then table.insert(info, string.format("[%dm]", (rootPart.Position - Camera.CFrame.Position).Magnitude)) end
            local text = DrawingManager:Add(Drawing.new("Text")); text.Text=table.concat(info," "); text.Size=14; text.Color=color; text.Center=true; text.Outline=true; text.Position=Vector2.new(screenPos.X, screenPos.Y - 40)
        end
        if Settings.ESP.Health then DrawESP_Health(screenPos, humanoid) end
        if Settings.ESP.Tracers then DrawingManager:Add(Drawing.new("Line"){From=Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y),To=Vector2.new(screenPos.X,screenPos.Y+25),Color=color,Thickness=1}) end
    end
    if Settings.ESP.Boxes then DrawESP_Box(player, rootPart, color) end
    if Settings.ESP.Skeleton then DrawESP_Skeleton(character, color) end
end

function Noclip_Handler()
    if not NoclipEnabled or not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("Humanoid") then return end
    for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end end
    LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
end

--[[ ==========================================================================================================================================================
    SECTION 5: MAIN EXECUTION LOOP (HEARTBEAT)
    This is the heart of the script. It runs on every frame of the game, calling all necessary handler functions.
-- ========================================================================================================================================================== ]]

RunService.RenderStepped:Connect(function()
    pcall(DrawingManager.Clear) -- Wrap in pcall for safety.

    if Settings.ESP.Enabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and (not Settings.ESP.TeamCheck or player.TeamColor ~= LocalPlayer.TeamColor) then
                pcall(Master_ESP_Handler, player)
            end
        end
    end

    if Settings.Aim.AimbotEnabled then
        pcall(Aimbot_Handler)
    end
    
    if Settings.Aim.FOVCircle then
        local circle = DrawingManager:Add(Drawing.new("Circle"))
        circle.Thickness = 1
        circle.NumSides = 24
        circle.Radius = Settings.Aim.FOV
        circle.Position = UserInputService:GetMouseLocation()
        circle.Color = Color3.new(1,1,1)
    end
    
    if Settings.Misc.CustomCrosshair then
        local crosshairX = DrawingManager:Add(Drawing.new("Line")); local crosshairY = DrawingManager:Add(Drawing.new("Line"))
        local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
        crosshairX.From, crosshairX.To = Vector2.new(center.X - 10, center.Y), Vector2.new(center.X + 10, center.Y)
        crosshairY.From, crosshairY.To = Vector2.new(center.X, center.Y - 10), Vector2.new(center.X, center.Y + 10)
        crosshairX.Color, crosshairY.Color = Color3.new(1,0,0), Color3.new(1,0,0)
        crosshairX.Thickness, crosshairY.Thickness = 1,1
    end
end)

RunService.Heartbeat:Connect(function()
    if NoclipEnabled then pcall(Noclip_Handler) end
end)