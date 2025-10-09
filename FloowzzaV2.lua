-- Floowzza's Ultimate GUI V2
-- Features: Anti-AFK, Lock Avatar, Fix Lag, Respawn, Graphics Info
-- By Floowzza, Modified by ChatGPT (2025)

local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer

if Player.PlayerGui:FindFirstChild("FloowzzaGUI") then
    Player.PlayerGui.FloowzzaGUI:Destroy()
end

-- Variables
local antiAfkEnabled = false
local avatarLocked = false
local minimized = false
local fixLagActive = false
local currentFPS = 0
local savedPosition = nil

----------------------------------------------------
-- UI CREATION
----------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "FloowzzaGUI"
gui.Parent = Player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0,350,0,430)
mainFrame.Position = UDim2.new(0.5,-175,0.5,-215)
mainFrame.BackgroundColor3 = Color3.fromRGB(25,25,35)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui
Instance.new("UICorner", mainFrame)

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1,0,0,45)
header.BackgroundColor3 = Color3.fromRGB(35,35,50)
header.Parent = mainFrame
Instance.new("UICorner", header)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-90,1,0)
title.Position = UDim2.new(0,15,0,0)
title.BackgroundTransparency = 1
title.Text = "Floowzza's Ultimate GUI v2"
title.TextColor3 = Color3.fromRGB(100,200,255)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

-- Buttons
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0,35,0,35)
minimizeBtn.Position = UDim2.new(1,-75,0,5)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(255,200,0)
minimizeBtn.Text = "−"
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextColor3 = Color3.fromRGB(0,0,0)
minimizeBtn.Parent = header
Instance.new("UICorner", minimizeBtn)

local closeBtn = minimizeBtn:Clone()
closeBtn.Position = UDim2.new(1,-37,0,5)
closeBtn.BackgroundColor3 = Color3.fromRGB(255,70,70)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.Parent = header

-- Content
local content = Instance.new("ScrollingFrame")
content.Size = UDim2.new(1,-20,1,-55)
content.Position = UDim2.new(0,10,0,50)
content.BackgroundTransparency = 1
content.ScrollBarThickness = 4
content.ScrollBarImageColor3 = Color3.fromRGB(100,200,255)
content.Parent = mainFrame


----------------------------------------------------
-- 📊 INFO SECTION
----------------------------------------------------
local infoFrame = Instance.new("Frame")
infoFrame.Size = UDim2.new(1,0,0,90)
infoFrame.BackgroundColor3 = Color3.fromRGB(35,35,50)
infoFrame.Parent = content
Instance.new("UICorner", infoFrame)

local infoTitle = Instance.new("TextLabel")
infoTitle.Text = "📊 PC Graphics Info"
infoTitle.Size = UDim2.new(1,-20,0,25)
infoTitle.Position = UDim2.new(0,10,0,5)
infoTitle.BackgroundTransparency = 1
infoTitle.Font = Enum.Font.GothamBold
infoTitle.TextColor3 = Color3.new(1,1,1)
infoTitle.TextSize = 14
infoTitle.TextXAlignment = Enum.TextXAlignment.Left
infoTitle.Parent = infoFrame

local fpsLabel = Instance.new("TextLabel")
fpsLabel.Text = "FPS: Calculating..."
fpsLabel.Size = UDim2.new(1,-20,0,20)
fpsLabel.Position = UDim2.new(0,10,0,35)
fpsLabel.BackgroundTransparency = 1
fpsLabel.Font = Enum.Font.Gotham
fpsLabel.TextColor3 = Color3.fromRGB(100,255,100)
fpsLabel.TextSize = 12
fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
fpsLabel.Parent = infoFrame

local pingLabel = Instance.new("TextLabel")
pingLabel.Text = "Ping: " .. math.floor(Player:GetNetworkPing() * 1000) .. " ms"
pingLabel.Size = UDim2.new(1,-20,0,20)
pingLabel.Position = UDim2.new(0,10,0,55)
pingLabel.BackgroundTransparency = 1
pingLabel.Font = Enum.Font.Gotham
pingLabel.TextColor3 = Color3.fromRGB(255,200,100)
pingLabel.TextSize = 12
pingLabel.TextXAlignment = Enum.TextXAlignment.Left
pingLabel.Parent = infoFrame


----------------------------------------------------
-- 🛡️ ANTI AFK
----------------------------------------------------
local afkFrame = Instance.new("Frame")
afkFrame.Size = UDim2.new(1,0,0,70)
afkFrame.Position = UDim2.new(0,0,0,95)
afkFrame.BackgroundColor3 = Color3.fromRGB(35,35,50)
afkFrame.Parent = content
Instance.new("UICorner", afkFrame)

local afkTitle = Instance.new("TextLabel")
afkTitle.Text = "🛡️ Anti-AFK System"
afkTitle.Size = UDim2.new(1,-20,0,25)
afkTitle.Position = UDim2.new(0,10,0,5)
afkTitle.BackgroundTransparency = 1
afkTitle.Font = Enum.Font.GothamBold
afkTitle.TextColor3 = Color3.new(1,1,1)
afkTitle.TextSize = 14
afkTitle.TextXAlignment = Enum.TextXAlignment.Left
afkTitle.Parent = afkFrame

local afkStatus = Instance.new("TextLabel")
afkStatus.Position = UDim2.new(0,10,0,35)
afkStatus.Size = UDim2.new(0.5,-15,0,20)
afkStatus.Text = "Status: OFF"
afkStatus.TextColor3 = Color3.fromRGB(255,100,100)
afkStatus.Font = Enum.Font.Gotham
afkStatus.TextSize = 12
afkStatus.BackgroundTransparency = 1
afkStatus.Parent = afkFrame

local afkBtn = Instance.new("TextButton")
afkBtn.Position = UDim2.new(0.5,5,0,40)
afkBtn.Size = UDim2.new(0.5,-15,0,30)
afkBtn.Text = "Turn ON"
afkBtn.Font = Enum.Font.GothamBold
afkBtn.TextSize = 13
afkBtn.TextColor3 = Color3.new(1,1,1)
afkBtn.BackgroundColor3 = Color3.fromRGB(70,200,100)
afkBtn.Parent = afkFrame
Instance.new("UICorner", afkBtn)


----------------------------------------------------
-- 🧍 LOCK AVATAR POSITION
----------------------------------------------------
local lockFrame = Instance.new("Frame")
lockFrame.Size = UDim2.new(1,0,0,80)
lockFrame.Position = UDim2.new(0,0,0,170)
lockFrame.BackgroundColor3 = Color3.fromRGB(35,35,50)
lockFrame.Parent = content
Instance.new("UICorner", lockFrame)

local lockTitle = afkTitle:Clone()
lockTitle.Text = "🧍 Avatar Lock Position"
lockTitle.Parent = lockFrame

local lockStatus = afkStatus:Clone()
lockStatus.Text = "Status: OFF"
lockStatus.TextColor3 = Color3.fromRGB(255,100,100)
lockStatus.Parent = lockFrame

local lockBtn = afkBtn:Clone()
lockBtn.Text = "Lock"
lockBtn.BackgroundColor3 = Color3.fromRGB(70,200,100)
lockBtn.Parent = lockFrame


----------------------------------------------------
-- ⚙️ FIX LAG
----------------------------------------------------
local fixFrame = Instance.new("Frame")
fixFrame.Size = UDim2.new(1,0,0,80)
fixFrame.Position = UDim2.new(0,0,0,255)
fixFrame.BackgroundColor3 = Color3.fromRGB(35,35,50)
fixFrame.Parent = content
Instance.new("UICorner", fixFrame)

local fixTitle = afkTitle:Clone()
fixTitle.Text = "⚙️ Fix Lag"
fixTitle.Parent = fixFrame

local fixStatus = afkStatus:Clone()
fixStatus.Text = "Status: OFF"
fixStatus.Parent = fixFrame

local fixBtn = afkBtn:Clone()
fixBtn.Text = "Run Fix"
fixBtn.BackgroundColor3 = Color3.fromRGB(100,150,255)
fixBtn.Parent = fixFrame


----------------------------------------------------
-- 🔄 RESPAWN
----------------------------------------------------
local respawnFrame = Instance.new("Frame")
respawnFrame.Size = UDim2.new(1,0,0,60)
respawnFrame.Position = UDim2.new(0,0,0,340)
respawnFrame.BackgroundColor3 = Color3.fromRGB(35,35,50)
respawnFrame.Parent = content
Instance.new("UICorner", respawnFrame)

local respawnBtn = Instance.new("TextButton")
respawnBtn.Size = UDim2.new(0.6,0,0,40)
respawnBtn.Position = UDim2.new(0.2,0,0.15,0)
respawnBtn.BackgroundColor3 = Color3.fromRGB(255,150,50)
respawnBtn.Text = "Respawn Character"
respawnBtn.TextColor3 = Color3.new(1,1,1)
respawnBtn.Font = Enum.Font.GothamBold
respawnBtn.TextSize = 13
respawnBtn.Parent = respawnFrame
Instance.new("UICorner", respawnBtn)

content.CanvasSize = UDim2.new(0,0,0,410)

----------------------------------------------------
-- FPS COUNTER LOOP
----------------------------------------------------
local lastUpdate = tick()
local frames = 0
RunService.RenderStepped:Connect(function()
	frames += 1
	if tick() - lastUpdate >= 1 then
		currentFPS = frames
		fpsLabel.Text = "FPS: " .. currentFPS
		pingLabel.Text = "Ping: " .. math.floor(Player:GetNetworkPing() * 1000) .. " ms"
		frames = 0
		lastUpdate = tick()
	end
end)

----------------------------------------------------
-- FUNCTIONS
----------------------------------------------------

-- Anti-AFK
local function antiAfkLoop()
	while antiAfkEnabled do
		wait(math.random(30,60))
		VirtualUser:CaptureController()
		VirtualUser:ClickButton2(Vector2.new())
	end
end

-- Lock Position
RunService.Heartbeat:Connect(function()
	if avatarLocked and savedPosition and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
		local root = Player.Character.HumanoidRootPart
		root.Velocity = Vector3.new()
		root.CFrame = savedPosition
	end
end)

-- Fix Lag function
local function fixLag()
	fixLagActive = true
	fixStatus.Text = "Status: RUNNING"
	fixStatus.TextColor3 = Color3.fromRGB(255,255,100)

	task.spawn(function()
		for _,v in pairs(workspace:GetDescendants()) do
			if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") then
				v.Enabled = false
			elseif v:IsA("Decal") or v:IsA("Texture") then
				v.Transparency = 0.7
			end
		end
		workspace.StreamingEnabled = true
		settings().Rendering.QualityLevel = Enum.QualityLevel.Level3
		workspace.Terrain.WaterReflectance = 0
		workspace.Terrain.WaterTransparency = 0.9
		wait(2)
		fixLagActive = false
		fixStatus.Text = "Status: DONE"
		fixStatus.TextColor3 = Color3.fromRGB(100,255,100)
		game.StarterGui:SetCore("SendNotification",{Title="Fix Lag Complete",Text="Game optimized!",Duration=3})
	end)
end

----------------------------------------------------
-- BUTTON EVENTS
----------------------------------------------------
afkBtn.MouseButton1Click:Connect(function()
	antiAfkEnabled = not antiAfkEnabled
	if antiAfkEnabled then
		afkStatus.Text = "Status: ON"
		afkStatus.TextColor3 = Color3.fromRGB(100,255,100)
		afkBtn.Text = "Turn OFF"
		afkBtn.BackgroundColor3 = Color3.fromRGB(255,70,70)
		task.spawn(antiAfkLoop)
	else
		afkStatus.Text = "Status: OFF"
		afkStatus.TextColor3 = Color3.fromRGB(255,100,100)
		afkBtn.Text = "Turn ON"
		afkBtn.BackgroundColor3 = Color3.fromRGB(70,200,100)
	end
end)

lockBtn.MouseButton1Click:Connect(function()
	avatarLocked = not avatarLocked
	if avatarLocked then
		local char = Player.Character or Player.CharacterAdded:Wait()
		savedPosition = char.HumanoidRootPart.CFrame
		lockStatus.Text = "Status: ON"
		lockStatus.TextColor3 = Color3.fromRGB(100,255,100)
		lockBtn.Text = "Unlock"
		lockBtn.BackgroundColor3 = Color3.fromRGB(255,80,80)
		game.StarterGui:SetCore("SendNotification",{Title="Avatar Locked",Text="Movement disabled.",Duration=3})
	else
		savedPosition = nil
		lockStatus.Text = "Status: OFF"
		lockStatus.TextColor3 = Color3.fromRGB(255,100,100)
		lockBtn.Text = "Lock"
		lockBtn.BackgroundColor3 = Color3.fromRGB(70,200,100)
		game.StarterGui:SetCore("SendNotification",{Title="Unlocked",Text="You can move again!",Duration=3})
	end
end)

fixBtn.MouseButton1Click:Connect(function()
	if not fixLagActive then
		fixLag()
	end
end)

respawnBtn.MouseButton1Click:Connect(function()
	if Player.Character and Player.Character:FindFirstChild("Humanoid") then
		Player.Character.Humanoid.Health = 0
	end
	game.StarterGui:SetCore("SendNotification",{Title="Respawned",Text="Your character has been respawned!",Duration=3})
end)

minimizeBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	if minimized then
		mainFrame:TweenSize(UDim2.new(0,350,0,45),"Out","Quad",0.3,true)
		content.Visible = false
		minimizeBtn.Text = "+"
	else
		mainFrame:TweenSize(UDim2.new(0,350,0,430),"Out","Quad",0.3,true)
		content.Visible = true
		minimizeBtn.Text = "−"
	end
end)

closeBtn.MouseButton1Click:Connect(function()
	antiAfkEnabled = false
	avatarLocked = false
	gui:Destroy()
end)

----------------------------------------------------
-- NOTIFY READY
----------------------------------------------------
game.StarterGui:SetCore("SendNotification", {
	Title = "Floowzza v2 Loaded ✅",
	Text = "GUI loaded with Lock, Anti-AFK, and Fix Lag!",
	Duration = 4
})
