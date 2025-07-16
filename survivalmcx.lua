local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "DisasterCheatUI"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 420, 0, 300)
Main.Position = UDim2.new(0.3, 0, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "🌪️ Natural Disaster Executor"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.BackgroundTransparency = 1

local Tabs = Instance.new("Frame", Main)
Tabs.Size = UDim2.new(0, 100, 1, -40)
Tabs.Position = UDim2.new(0, 0, 0, 40)
Tabs.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", Tabs).CornerRadius = UDim.new(0, 10)

local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1, -110, 1, -40)
Content.Position = UDim2.new(0, 110, 0, 40)
Content.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Instance.new("UICorner", Content).CornerRadius = UDim.new(0, 10)

local categories = {
    Movement = {},
    Visual = {},
    Fun = {},
    Utility = {},
    Sound = {}
}

local currentTab = nil

local function clearContent()
    for _, v in pairs(Content:GetChildren()) do
        if v:IsA("TextButton") or v:IsA("UIGridLayout") then
            v:Destroy()
        end
    end
end

local function showTab(tabName)
    clearContent()
    currentTab = tabName
    local layout = Instance.new("UIGridLayout", Content)
    layout.CellSize = UDim2.new(0, 120, 0, 35)
    layout.CellPadding = UDim2.new(0, 5, 0, 5)
    layout.FillDirectionMaxCells = 3
    for _, button in pairs(categories[tabName]) do
        button.Parent = Content
    end
end

local function createTabButton(name, pos)
    local btn = Instance.new("TextButton", Tabs)
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.Position = UDim2.new(0, 0, 0, 10 + (pos * 35))
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(function()
        showTab(name)
    end)
end

local function createButton(label, callback, tab)
    local btn = Instance.new("TextButton")
    btn.Text = label
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.MouseButton1Click:Connect(callback)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    table.insert(categories[tab], btn)
end

createButton("🕵️ Invisible", function()
    for _, p in pairs(LocalPlayer.Character:GetDescendants()) do
        if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
            p.Transparency = 1
            if p:FindFirstChild("face") then p.face:Destroy() end
        end
    end
end, "Movement")

createButton("🎈 Get Balloon", function()
    local id = 16688968
    local tool = game:GetObjects("https://www.roblox.com/asset/?id=" .. id)[1]
    if tool then tool.Parent = LocalPlayer.Backpack end
end, "Movement")

createButton("⚡ Speed Boost", function()
    if LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 50
    end
end, "Movement")

createButton("🚀 Super Jump", function()
    if LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = 120
    end
end, "Movement")

local tabNames = {"Movement", "Visual", "Fun", "Utility", "Sound"}
for i, name in ipairs(tabNames) do
    createTabButton(name, i - 1)
end

showTab("Movement")
