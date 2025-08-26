-- Mod Menu V4 - Slider Version with all 50 Mods (Xeno Compatible)
-- Draggable, closable, minimizable, scrollable

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ModMenuV4"
screenGui.ResetOnSpawn = false
screenGui.Parent = game.CoreGui

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 400)
frame.Position = UDim2.new(0.05, 0, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = screenGui

-- Top Bar
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 30)
topBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
topBar.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 5, 0, 0)
title.Text = "Suff Mod Menu V4"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.BackgroundTransparency = 1
title.Parent = topBar

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 1, 0)
closeBtn.Position = UDim2.new(1, -30, 0, 0)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 16
closeBtn.Parent = topBar
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Minimize Button
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 30, 1, 0)
minimizeBtn.Position = UDim2.new(1, -60, 0, 0)
minimizeBtn.Text = "-"
minimizeBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
minimizeBtn.TextColor3 = Color3.new(1, 1, 1)
minimizeBtn.Font = Enum.Font.SourceSansBold
minimizeBtn.TextSize = 16
minimizeBtn.Parent = topBar

local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    for _, child in pairs(frame:GetChildren()) do
        if child ~= topBar then
            child.Visible = not minimized
        end
    end
    frame.Size = minimized and UDim2.new(0, 300, 0, 30) or UDim2.new(0, 300, 0, 400)
end)

-- Draggable
do
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    topBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- Scrolling Frame
local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(1, 0, 1, -30)
scrollingFrame.Position = UDim2.new(0, 0, 0, 30)
scrollingFrame.CanvasSize = UDim2.new(0, 0, 5, 0)
scrollingFrame.ScrollBarThickness = 8
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.Parent = frame

-- List Layout
local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 5)
layout.FillDirection = Enum.FillDirection.Vertical
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = scrollingFrame

-- Button Maker
local function createButton(name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 16
    btn.Font = Enum.Font.SourceSansBold
    btn.Text = name
    btn.Parent = scrollingFrame
    btn.MouseButton1Click:Connect(callback)
end

-- 🔹 50 Mods
-- Movement
createButton("Speed Boost", function() character.Humanoid.WalkSpeed = 50 end)
createButton("Super Jump", function() character.Humanoid.JumpPower = 150 end)
createButton("Reset Speed/Jump", function() character.Humanoid.WalkSpeed = 16 character.Humanoid.JumpPower = 50 end)
createButton("Infinite Jump", function()
    game:GetService("UserInputService").JumpRequest:Connect(function()
        character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end)
end)
createButton("Low Gravity", function() workspace.Gravity = 25 end)
createButton("Normal Gravity", function() workspace.Gravity = 196.2 end)
createButton("Fly Up", function() character.HumanoidRootPart.Velocity = Vector3.new(0,100,0) end)
createButton("Noclip ON", function()
    RunService.Stepped:Connect(function()
        for _,v in pairs(character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end)
end)
createButton("Sit", function() character.Humanoid.Sit = true end)
createButton("Ragdoll", function() character.Humanoid:ChangeState(Enum.HumanoidStateType.Physics) end)

-- Teleports
createButton("Teleport to Spawn", function() if workspace:FindFirstChild("SpawnLocation") then character:MoveTo(workspace.SpawnLocation.Position) end end)
createButton("Teleport Up 50", function() character:MoveTo(character.HumanoidRootPart.Position + Vector3.new(0,50,0)) end)
createButton("Teleport Down 50", function() character:MoveTo(character.HumanoidRootPart.Position + Vector3.new(0,-50,0)) end)
createButton("Teleport Forward", function() character:MoveTo(character.HumanoidRootPart.Position + character.HumanoidRootPart.CFrame.LookVector * 20) end)
createButton("Teleport to Random Player", function()
    local others = Players:GetPlayers()
    if #others > 1 then
        local target = others[math.random(1,#others)]
        if target ~= player then
            character:MoveTo(target.Character.HumanoidRootPart.Position)
        end
    end
end)

-- Camera
createButton("FOV 120", function() workspace.CurrentCamera.FieldOfView = 120 end)
createButton("FOV 30", function() workspace.CurrentCamera.FieldOfView = 30 end)
createButton("FOV Reset", function() workspace.CurrentCamera.FieldOfView = 70 end)

-- Character Size/Look
createButton("Big Head", function() if character:FindFirstChild("Head") then character.Head.Size = character.Head.Size*2 end end)
createButton("Tiny Head", function() if character:FindFirstChild("Head") then character.Head.Size = character.Head.Size*0.5 end end)
createButton("Giant Body", function() for _,p in pairs(character:GetChildren()) do if p:IsA("BasePart") then p.Size = p.Size*2 end end end)
createButton("Tiny Body", function() for _,p in pairs(character:GetChildren()) do if p:IsA("BasePart") then p.Size = p.Size*0.5 end end end)
createButton("Invisible", function() for _,p in pairs(character:GetDescendants()) do if p:IsA("BasePart") then p.Transparency = 1 end end end)
createButton("Visible", function() for _,p in pairs(character:GetDescendants()) do if p:IsA("BasePart") then p.Transparency = 0 end end end)
createButton("Rainbow Body", function()
    spawn(function()
        while true do
            for _,p in pairs(character:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.Color = Color3.fromHSV(tick()%5/5,1,1)
                end
            end
            wait(0.2)
        end
    end)
end)

-- Health
createButton("Heal Full", function() character.Humanoid.Health = character.Humanoid.MaxHealth end)
createButton("Die", function() character.Humanoid.Health = 0 end)
createButton("God Mode (no dmg)", function()
    character.Humanoid.HealthChanged:Connect(function() character.Humanoid.Health = character.Humanoid.MaxHealth end)
end)

-- Tools / Fun
createButton("Give Sword", function()
    local sword = Instance.new("Tool")
    sword.RequiresHandle = true
    sword.Name = "Sword"
    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(1,4,1)
    handle.Parent = sword
    sword.Parent = player.Backpack
end)
createButton("Sparkles", function() Instance.new("Sparkles", character.HumanoidRootPart) end)
createButton("Fire Effect", function() Instance.new("Fire", character.HumanoidRootPart) end)
createButton("Smoke Effect", function() Instance.new("Smoke", character.HumanoidRootPart) end)
createButton("Light Aura", function()
    local light = Instance.new("PointLight")
    light.Brightness = 5
    light.Range = 15
    light.Parent = character.HumanoidRootPart
end)

-- Lighting/World
createButton("Daytime", function() game.Lighting.ClockTime = 12 end)
createButton("Nighttime", function() game.Lighting.ClockTime = 0 end)
createButton("Foggy", function() game.Lighting.FogEnd = 50 end)
createButton("Clear Fog", function() game.Lighting.FogEnd = 100000 end)
createButton("Red Sky", function() game.Lighting.Ambient = Color3.fromRGB(255,0,0) end)
createButton("Normal Sky", function() game.Lighting.Ambient = Color3.fromRGB(128,128,128) end)

-- Funny
createButton("Spin", function()
    spawn(function()
        while wait() do
            character.HumanoidRootPart.CFrame = character.HumanoidRootPart.CFrame * CFrame.Angles(0,math.rad(10),0)
        end
    end)
end)
createButton("Bounce", function()
    spawn(function()
        while wait(0.5) do
            character.HumanoidRootPart.Velocity = Vector3.new(0,100,0)
        end
    end)
end)
createButton("Clone Yourself", function()
    local clone = character:Clone()
    clone.Parent = workspace
    clone:MoveTo(character.HumanoidRootPart.Position + Vector3.new(5,0,0))
end)
createButton("Explode", function()
    local explosion = Instance.new("Explosion")
    explosion.Position = character.HumanoidRootPart.Position
    explosion.BlastRadius = 10
    explosion.Parent = workspace
end)
createButton("Launch Forward", function()
    character.HumanoidRootPart.Velocity = character.HumanoidRootPart.CFrame.LookVector*200
end)
