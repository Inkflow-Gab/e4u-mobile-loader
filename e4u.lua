-- e4u | mobile hub/loader
-- ESP • Teleport • Fly (CFrame) • Speed • Profile/Body • Emotes • Avatar
-- Built for mobile executors, minimalist UI with splash/icon/resize

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

local function getChar(plr)
	plr = plr or LocalPlayer
	return plr.Character or plr.CharacterAdded:Wait()
end
local function getHRP(char)
	char = char or getChar()
	return char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart", 10)
end
local function getHum(char)
	char = char or getChar()
	return char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 10)
end

local State = {
	ESP = false,
	Fly = false,
	FlySpeed = 50,
	Noclip = false,
	SavedCF = nil,
	Connections = {},
	ESPObjects = {},
	CurrentAnimTrack = nil,
	Open = false,
}

local function cleanupOld()
	pcall(function()
		local old = PlayerGui:FindFirstChild("e4u")
		if old then old:Destroy() end
	end)
end
cleanupOld()

local gui = Instance.new("ScreenGui")
gui.Name = "e4u"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 999999
gui.Parent = PlayerGui

local function corner(parent, r)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r or 8)
	c.Parent = parent
	return c
end
local function stroke(parent, color, t)
	local s = Instance.new("UIStroke")
	s.Color = color or Color3.fromRGB(60, 60, 70)
	s.Thickness = t or 1
	s.Transparency = 0.2
	s.Parent = parent
	return s
end
local function pad(parent, l, r, t, b)
	local p = Instance.new("UIPadding")
	p.PaddingLeft = UDim.new(0, l or 8)
	p.PaddingRight = UDim.new(0, r or l or 8)
	p.PaddingTop = UDim.new(0, t or l or 8)
	p.PaddingBottom = UDim.new(0, b or t or l or 8)
	p.Parent = parent
	return p
end

-- Splash
local splash = Instance.new("Frame")
splash.Name = "Splash"
splash.Size = UDim2.fromScale(1, 1)
splash.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
splash.BackgroundTransparency = 0
splash.BorderSizePixel = 0
splash.ZIndex = 50
splash.Parent = gui

local splashTitle = Instance.new("TextLabel")
splashTitle.BackgroundTransparency = 1
splashTitle.Size = UDim2.new(1, 0, 0, 60)
splashTitle.Position = UDim2.new(0, 0, 0.5, -40)
splashTitle.Font = Enum.Font.GothamBold
splashTitle.Text = "e4u"
splashTitle.TextSize = 54
splashTitle.TextColor3 = Color3.fromRGB(240, 240, 245)
splashTitle.TextTransparency = 1
splashTitle.ZIndex = 51
splashTitle.Parent = splash

local splashSub = Instance.new("TextLabel")
splashSub.BackgroundTransparency = 1
splashSub.Size = UDim2.new(1, 0, 0, 24)
splashSub.Position = UDim2.new(0, 0, 0.5, 18)
splashSub.Font = Enum.Font.Gotham
splashSub.Text = "mobile hub loading..."
splashSub.TextSize = 14
splashSub.TextColor3 = Color3.fromRGB(150, 150, 165)
splashSub.TextTransparency = 1
splashSub.ZIndex = 51
splashSub.Parent = splash

task.spawn(function()
	TweenService:Create(splashTitle, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
	TweenService:Create(splashSub, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
	task.wait(1.4)
	TweenService:Create(splashTitle, TweenInfo.new(0.35), {TextTransparency = 1}):Play()
	TweenService:Create(splashSub, TweenInfo.new(0.35), {TextTransparency = 1}):Play()
	TweenService:Create(splash, TweenInfo.new(0.45), {BackgroundTransparency = 1}):Play()
	task.wait(0.5)
	splash:Destroy()
end)

-- Floating icon
local icon = Instance.new("TextButton")
icon.Name = "Icon"
icon.Size = UDim2.new(0, 46, 0, 46)
icon.Position = UDim2.new(0, 12, 0.5, -120)
icon.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
icon.Text = "e4u"
icon.Font = Enum.Font.GothamBold
icon.TextSize = 14
icon.TextColor3 = Color3.fromRGB(240, 240, 245)
icon.AutoButtonColor = true
icon.Active = true
icon.Draggable = true
icon.ZIndex = 20
icon.Parent = gui
corner(icon, 14)
stroke(icon, Color3.fromRGB(80, 80, 95), 1)

-- Main window
local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 330, 0, 420)
main.Position = UDim2.new(0.5, -165, 0.5, -210)
main.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
main.BorderSizePixel = 0
main.Active = true
main.Visible = false
main.ClipsDescendants = true
main.ZIndex = 10
main.Parent = gui
corner(main, 12)
stroke(main, Color3.fromRGB(55, 55, 65), 1)

local top = Instance.new("Frame")
top.Name = "Topbar"
top.Size = UDim2.new(1, 0, 0, 44)
top.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
top.BorderSizePixel = 0
top.ZIndex = 11
top.Parent = main
corner(top, 12)

local topFix = Instance.new("Frame")
topFix.Size = UDim2.new(1, 0, 0, 12)
topFix.Position = UDim2.new(0, 0, 1, -12)
topFix.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
topFix.BorderSizePixel = 0
topFix.ZIndex = 11
topFix.Parent = top

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Position = UDim2.new(0, 12, 0, 0)
title.Size = UDim2.new(1, -60, 1, 0)
title.Font = Enum.Font.GothamBold
title.Text = "e4u"
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(240, 240, 245)
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 12
title.Parent = top

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -36, 0.5, -14)
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
closeBtn.Text = "×"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.TextColor3 = Color3.fromRGB(220, 220, 225)
closeBtn.ZIndex = 12
closeBtn.Parent = top
corner(closeBtn, 8)

-- Drag main
do
	local dragging, dragStart, startPos
	top.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = main.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

-- Resize handle
local resize = Instance.new("TextButton")
resize.Name = "Resize"
resize.Size = UDim2.new(0, 22, 0, 22)
resize.Position = UDim2.new(1, -22, 1, -22)
resize.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
resize.Text = "⋮⋮"
resize.Font = Enum.Font.GothamBold
resize.TextSize = 10
resize.TextColor3 = Color3.fromRGB(160, 160, 170)
resize.ZIndex = 13
resize.Parent = main
corner(resize, 6)
do
	local resizing, rStart, startSize
	resize.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			resizing = true
			rStart = input.Position
			startSize = main.Size
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then resizing = false end
			end)
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - rStart
			local w = math.clamp(startSize.X.Offset + delta.X, 280, 520)
			local h = math.clamp(startSize.Y.Offset + delta.Y, 320, 700)
			main.Size = UDim2.new(0, w, 0, h)
		end
	end)
end

-- Tabs bar
local tabBar = Instance.new("ScrollingFrame")
tabBar.Name = "TabBar"
tabBar.Size = UDim2.new(1, -16, 0, 34)
tabBar.Position = UDim2.new(0, 8, 0, 50)
tabBar.BackgroundTransparency = 1
tabBar.BorderSizePixel = 0
tabBar.ScrollBarThickness = 2
tabBar.CanvasSize = UDim2.new(0, 0, 0, 0)
tabBar.AutomaticCanvasSize = Enum.AutomaticSize.X
tabBar.ScrollingDirection = Enum.ScrollingDirection.X
tabBar.ZIndex = 11
tabBar.Parent = main
local tabList = Instance.new("UIListLayout")
tabList.FillDirection = Enum.FillDirection.Horizontal
tabList.Padding = UDim.new(0, 6)
tabList.SortOrder = Enum.SortOrder.LayoutOrder
tabList.Parent = tabBar

local pages = Instance.new("Frame")
pages.Name = "Pages"
pages.Size = UDim2.new(1, -16, 1, -100)
pages.Position = UDim2.new(0, 8, 0, 90)
pages.BackgroundTransparency = 1
pages.ZIndex = 11
pages.Parent = main

local Tabs, Pages = {}, {}
local function createTab(name, order)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0, 0, 1, 0)
	b.AutomaticSize = Enum.AutomaticSize.X
	b.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
	b.Text = name
	b.Font = Enum.Font.GothamSemibold
	b.TextSize = 12
	b.TextColor3 = Color3.fromRGB(180, 180, 190)
	b.AutoButtonColor = true
	b.LayoutOrder = order
	b.ZIndex = 12
	b.Parent = tabBar
	corner(b, 8)
	pad(b, 10, 10, 0, 0)

	local p = Instance.new("ScrollingFrame")
	p.Name = name
	p.Size = UDim2.fromScale(1, 1)
	p.BackgroundTransparency = 1
	p.BorderSizePixel = 0
	p.ScrollBarThickness = 3
	p.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 95)
	p.CanvasSize = UDim2.new(0, 0, 0, 0)
	p.AutomaticCanvasSize = Enum.AutomaticSize.Y
	p.Visible = false
	p.ZIndex = 11
	p.Parent = pages
	local pl = Instance.new("UIListLayout")
	pl.Padding = UDim.new(0, 8)
	pl.SortOrder = Enum.SortOrder.LayoutOrder
	pl.Parent = p
	pad(p, 2, 6, 2, 8)

	Tabs[name] = b
	Pages[name] = p
	b.MouseButton1Click:Connect(function()
		for n, pg in pairs(Pages) do
			pg.Visible = (n == name)
			Tabs[n].BackgroundColor3 = (n == name) and Color3.fromRGB(70, 110, 255) or Color3.fromRGB(30, 30, 38)
			Tabs[n].TextColor3 = (n == name) and Color3.fromRGB(255,255,255) or Color3.fromRGB(180,180,190)
		end
	end)
	return p
end

local homePage = createTab("Home", 1)
local playerPage = createTab("Player", 2)
local visualsPage = createTab("Visuals", 3)
local tpPage = createTab("Teleport", 4)
local emotesPage = createTab("Emotes", 5)
local avatarPage = createTab("Avatar", 6)

-- show first tab
Pages["Home"].Visible = true
Tabs["Home"].BackgroundColor3 = Color3.fromRGB(70, 110, 255)
Tabs["Home"].TextColor3 = Color3.fromRGB(255,255,255)

local function section(parent, text, order)
	local l = Instance.new("TextLabel")
	l.Size = UDim2.new(1, 0, 0, 18)
	l.BackgroundTransparency = 1
	l.Font = Enum.Font.GothamBold
	l.Text = text
	l.TextSize = 13
	l.TextColor3 = Color3.fromRGB(200, 200, 210)
	l.TextXAlignment = Enum.TextXAlignment.Left
	l.LayoutOrder = order or 1
	l.ZIndex = 12
	l.Parent = parent
	return l
end
local function button(parent, text, order)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1, 0, 0, 36)
	b.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
	b.Text = text
	b.Font = Enum.Font.GothamSemibold
	b.TextSize = 13
	b.TextColor3 = Color3.fromRGB(235, 235, 240)
	b.AutoButtonColor = true
	b.LayoutOrder = order or 1
	b.ZIndex = 12
	b.Parent = parent
	corner(b, 8)
	return b
end
local function box(parent, placeholder, default, order)
	local t = Instance.new("TextBox")
	t.Size = UDim2.new(1, 0, 0, 34)
	t.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
	t.Text = default or ""
	t.PlaceholderText = placeholder or ""
	t.ClearTextOnFocus = false
	t.Font = Enum.Font.Gotham
	t.TextSize = 13
	t.TextColor3 = Color3.fromRGB(235, 235, 240)
	t.PlaceholderColor3 = Color3.fromRGB(120, 120, 135)
	t.LayoutOrder = order or 1
	t.ZIndex = 12
	t.Parent = parent
	corner(t, 8)
	pad(t, 10, 10, 0, 0)
	return t
end
local function label(parent, text, order, size)
	local l = Instance.new("TextLabel")
	l.Size = UDim2.new(1, 0, 0, size or 20)
	l.BackgroundTransparency = 1
	l.Font = Enum.Font.Gotham
	l.Text = text
	l.TextSize = 12
	l.TextColor3 = Color3.fromRGB(170, 170, 185)
	l.TextXAlignment = Enum.TextXAlignment.Left
	l.TextWrapped = true
	l.LayoutOrder = order or 1
	l.ZIndex = 12
	l.Parent = parent
	return l
end

-- HOME / PROFILE
section(homePage, "Your Profile", 1)
local profileCard = Instance.new("Frame")
profileCard.Size = UDim2.new(1, 0, 0, 150)
profileCard.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
profileCard.LayoutOrder = 2
profileCard.ZIndex = 12
profileCard.Parent = homePage
corner(profileCard, 10)
stroke(profileCard, Color3.fromRGB(50,50,60), 1)

local avatarImg = Instance.new("ImageLabel")
avatarImg.Size = UDim2.new(0, 72, 0, 72)
avatarImg.Position = UDim2.new(0, 10, 0, 10)
avatarImg.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
avatarImg.Image = ""
avatarImg.ScaleType = Enum.ScaleType.Crop
avatarImg.ZIndex = 13
avatarImg.Parent = profileCard
corner(avatarImg, 36)

local nameLbl = Instance.new("TextLabel")
nameLbl.BackgroundTransparency = 1
nameLbl.Position = UDim2.new(0, 92, 0, 12)
nameLbl.Size = UDim2.new(1, -100, 0, 20)
nameLbl.Font = Enum.Font.GothamBold
nameLbl.TextSize = 15
nameLbl.TextColor3 = Color3.fromRGB(240,240,245)
nameLbl.TextXAlignment = Enum.TextXAlignment.Left
nameLbl.Text = LocalPlayer.DisplayName
nameLbl.ZIndex = 13
nameLbl.Parent = profileCard

local userLbl = Instance.new("TextLabel")
userLbl.BackgroundTransparency = 1
userLbl.Position = UDim2.new(0, 92, 0, 32)
userLbl.Size = UDim2.new(1, -100, 0, 16)
userLbl.Font = Enum.Font.Gotham
userLbl.TextSize = 12
userLbl.TextColor3 = Color3.fromRGB(160,160,175)
userLbl.TextXAlignment = Enum.TextXAlignment.Left
userLbl.Text = "@" .. LocalPlayer.Name .. " • " .. tostring(LocalPlayer.UserId)
userLbl.ZIndex = 13
userLbl.Parent = profileCard

local ageLbl = Instance.new("TextLabel")
ageLbl.BackgroundTransparency = 1
ageLbl.Position = UDim2.new(0, 92, 0, 50)
ageLbl.Size = UDim2.new(1, -100, 0, 16)
ageLbl.Font = Enum.Font.Gotham
ageLbl.TextSize = 12
ageLbl.TextColor3 = Color3.fromRGB(160,160,175)
ageLbl.TextXAlignment = Enum.TextXAlignment.Left
ageLbl.Text = "Account age: " .. tostring(LocalPlayer.AccountAge) .. " days"
ageLbl.ZIndex = 13
ageLbl.Parent = profileCard

local bodyLbl = Instance.new("TextLabel")
bodyLbl.BackgroundTransparency = 1
bodyLbl.Position = UDim2.new(0, 10, 0, 90)
bodyLbl.Size = UDim2.new(1, -20, 0, 52)
bodyLbl.Font = Enum.Font.Gotham
bodyLbl.TextSize = 12
bodyLbl.TextColor3 = Color3.fromRGB(170,170,185)
bodyLbl.TextXAlignment = Enum.TextXAlignment.Left
bodyLbl.TextYAlignment = Enum.TextYAlignment.Top
bodyLbl.TextWrapped = true
bodyLbl.Text = "Body: loading..."
bodyLbl.ZIndex = 13
bodyLbl.Parent = profileCard

local function refreshProfile()
	pcall(function()
		avatarImg.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
	end)
	local char = LocalPlayer.Character
	if char then
		local hum = char:FindFirstChildOfClass("Humanoid")
		local hrp = char:FindFirstChild("HumanoidRootPart")
		local rig = hum and hum.RigType.Name or "Unknown"
		local hp = hum and math.floor(hum.Health) .. "/" .. math.floor(hum.MaxHealth) or "?"
		local parts = 0
		for _,v in ipairs(char:GetDescendants()) do if v:IsA("BasePart") then parts += 1 end end
		local acc = 0
		for _,v in ipairs(char:GetDescendants()) do if v:IsA("Accessory") then acc += 1 end end
		bodyLbl.Text = string.format("Rig: %s  |  HP: %s\nParts: %d  Accessories: %d  HRP: %s", rig, hp, parts, acc, hrp and "yes" or "no")
	else
		bodyLbl.Text = "Body: character not loaded"
	end
end
local refreshProfileBtn = button(homePage, "Refresh Profile / Body", 3)
refreshProfileBtn.MouseButton1Click:Connect(refreshProfile)
task.spawn(refreshProfile)

-- PLAYER
section(playerPage, "Movement", 1)
local walkBox = box(playerPage, "WalkSpeed (16)", "16", 2)
local jumpBox = box(playerPage, "JumpPower (50)", "50", 3)
local applyMove = button(playerPage, "Apply Walk/Jump", 4)
applyMove.MouseButton1Click:Connect(function()
	local hum = getHum()
	if hum then
		local ws = tonumber(walkBox.Text) if ws then hum.WalkSpeed = ws end
		local jp = tonumber(jumpBox.Text) if jp then hum.UseJumpPower = true hum.JumpPower = jp end
	end
end)
section(playerPage, "Fly (CFrame, mobile-friendly)", 5)
local speedBox = box(playerPage, "Fly speed", "50", 6)
local flyBtn = button(playerPage, "Fly: OFF", 7)
local flyHint = label(playerPage, "Uses joystick/move direction in camera space + noclip while active.", 8, 34)

-- VISUALS
section(visualsPage, "ESP", 1)
local espBtn = button(visualsPage, "ESP: OFF", 2)
label(visualsPage, "Highlight ESP on other players (AlwaysOnTop).", 3, 30)

-- TELEPORT
section(tpPage, "Teleport", 1)
local tpBox = box(tpPage, "Target player name/display", "", 2)
local tpBtn = button(tpPage, "Teleport to Player", 3)
local savePosBtn = button(tpPage, "Save Current Position", 4)
local loadPosBtn = button(tpPage, "Load Saved Position", 5)
label(tpPage, "Partial name match supported.", 6, 20)

-- EMOTES / ANIMATIONS
section(emotesPage, "FE Animations", 1)
local animIdBox = box(emotesPage, "Animation ID (numbers)", "", 2)
local playAnimBtn = button(emotesPage, "Play Animation ID", 3)
local stopAnimBtn = button(emotesPage, "Stop Animation", 4)
label(emotesPage, "Presets (client-side):", 5, 18)
local presetWave = button(emotesPage, "Wave (507770239)", 6)
local presetDance = button(emotesPage, "Dance (507771019)", 7)
local presetPoint = button(emotesPage, "Point (507770453)", 8)
local presetLaugh = button(emotesPage, "Laugh (507770818)", 9)
local loadEmoterBtn = button(emotesPage, "Load Emoter GUI (opensource)", 10)
label(emotesPage, "Emoter by Fixel656 (GPL-3.0) loaded from GitHub.", 11, 28)

-- AVATAR
section(avatarPage, "Avatar Changer (client-side)", 1)
local avatarIdBox = box(avatarPage, "Copy avatar from UserId", "", 2)
local applyAvatarBtn = button(avatarPage, "Apply Avatar by UserId", 3)
local resetAvatarBtn = button(avatarPage, "Reapply My Avatar", 4)
label(avatarPage, "Applies HumanoidDescription locally where allowed by the game. Some experiences restrict this.", 5, 48)

-- ESP logic
local espFolder = Instance.new("Folder")
espFolder.Name = "ESPFolder"
espFolder.Parent = gui

local function removeESP(plr)
	if State.ESPObjects[plr] then
		pcall(function() State.ESPObjects[plr]:Destroy() end)
		State.ESPObjects[plr] = nil
	end
end
local function addESP(plr)
	if plr == LocalPlayer then return end
	local function attach(char)
		if not State.ESP then return end
		removeESP(plr)
		local h = Instance.new("Highlight")
		h.Name = "e4uESP"
		h.Adornee = char
		h.FillColor = Color3.fromRGB(255, 90, 130)
		h.OutlineColor = Color3.fromRGB(255, 255, 255)
		h.FillTransparency = 0.45
		h.OutlineTransparency = 0
		h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		h.Parent = espFolder
		State.ESPObjects[plr] = h
	end
	if plr.Character then attach(plr.Character) end
	plr.CharacterAdded:Connect(function(char)
		char:WaitForChild("HumanoidRootPart", 10)
		if State.ESP then attach(char) end
	end)
end
local function setESP(on)
	State.ESP = on
	espBtn.Text = "ESP: " .. (on and "ON" or "OFF")
	espBtn.BackgroundColor3 = on and Color3.fromRGB(50, 120, 70) or Color3.fromRGB(32, 32, 40)
	if on then
		for _, p in ipairs(Players:GetPlayers()) do addESP(p) end
	else
		for plr in pairs(State.ESPObjects) do removeESP(plr) end
	end
end
Players.PlayerAdded:Connect(function(p) if State.ESP then addESP(p) end end)
Players.PlayerRemoving:Connect(removeESP)
espBtn.MouseButton1Click:Connect(function() setESP(not State.ESP) end)

-- Fly logic (CFrame/body movers)
local flyConn, noclipConn
local function stopFly()
	State.Fly = false
	flyBtn.Text = "Fly: OFF"
	flyBtn.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
	if flyConn then flyConn:Disconnect() flyConn = nil end
	if noclipConn then noclipConn:Disconnect() noclipConn = nil end
	local char = LocalPlayer.Character
	if char then
		local hrp = char:FindFirstChild("HumanoidRootPart")
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hrp then
			for _, v in ipairs(hrp:GetChildren()) do
				if v:IsA("BodyVelocity") or v:IsA("BodyGyro") then v:Destroy() end
			end
			hrp.AssemblyLinearVelocity = Vector3.zero
		end
		if hum then hum.PlatformStand = false end
	end
end

local function startFly()
	local char = getChar()
	local hrp = getHRP(char)
	local hum = getHum(char)
	if not hrp or not hum then return end
	local speed = tonumber(speedBox.Text) or 50
	State.FlySpeed = speed
	State.Fly = true
	flyBtn.Text = "Fly: ON"
	flyBtn.BackgroundColor3 = Color3.fromRGB(50, 120, 70)
	hum.PlatformStand = true

	local bv = Instance.new("BodyVelocity")
	bv.Name = "e4uFlyVel"
	bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
	bv.Velocity = Vector3.zero
	bv.Parent = hrp

	local bg = Instance.new("BodyGyro")
	bg.Name = "e4uFlyGyro"
	bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
	bg.P = 1e4
	bg.CFrame = hrp.CFrame
	bg.Parent = hrp

	noclipConn = RunService.Stepped:Connect(function()
		if not State.Fly then return end
		local c = LocalPlayer.Character
		if c then
			for _, part in ipairs(c:GetDescendants()) do
				if part:IsA("BasePart") then part.CanCollide = false end
			end
		end
	end)

	flyConn = RunService.RenderStepped:Connect(function()
		if not State.Fly or not hrp or not hrp.Parent then return end
		local spd = tonumber(speedBox.Text) or State.FlySpeed or 50
		State.FlySpeed = spd
		local move = hum.MoveDirection
		local cam = workspace.CurrentCamera
		local dir = Vector3.zero
		if move.Magnitude > 0 then
			dir = move
		end
		-- allow ascent/descent on jump input (mobile jump button sets JumpRequest)
		if hum.Jump then
			dir = dir + Vector3.new(0, 1, 0)
		end
		if dir.Magnitude > 0 then dir = dir.Unit end
		bv.Velocity = dir * spd
		if cam then bg.CFrame = cam.CFrame end
	end)
end

flyBtn.MouseButton1Click:Connect(function()
	if State.Fly then stopFly() else startFly() end
end)
speedBox.FocusLost:Connect(function()
	local n = tonumber(speedBox.Text)
	if n and n > 0 then State.FlySpeed = n else speedBox.Text = tostring(State.FlySpeed) end
end)

LocalPlayer.CharacterAdded:Connect(function()
	task.wait(0.5)
	refreshProfile()
	if State.Fly then
		stopFly()
		task.wait(0.2)
		startFly()
	end
end)

-- Teleport
local function findPlayer(str)
	if not str or str == "" then return nil end
	str = str:lower()
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer then
			if p.Name:lower():sub(1,#str) == str or p.DisplayName:lower():sub(1,#str) == str then
				return p
			end
		end
	end
	return nil
end

tpBtn.MouseButton1Click:Connect(function()
	local t = findPlayer(tpBox.Text)
	if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then
		local hrp = getHRP()
		if hrp then hrp.CFrame = t.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,3) end
	else
		tpBtn.Text = "Player not found"
		task.delay(1.2, function() tpBtn.Text = "Teleport to Player" end)
	end
end)

savePosBtn.MouseButton1Click:Connect(function()
	local hrp = getHRP()
	if hrp then
		State.SavedCF = hrp.CFrame
		savePosBtn.Text = "Saved!"
		task.delay(1, function() savePosBtn.Text = "Save Current Position" end)
	end
end)
loadPosBtn.MouseButton1Click:Connect(function()
	local hrp = getHRP()
	if hrp and State.SavedCF then
		hrp.CFrame = State.SavedCF
		loadPosBtn.Text = "Loaded!"
		task.delay(1, function() loadPosBtn.Text = "Load Saved Position" end)
	end
end)

-- Animations / Emotes (client-side)
local function stopAnim()
	if State.CurrentAnimTrack then
		pcall(function() State.CurrentAnimTrack:Stop() end)
		State.CurrentAnimTrack = nil
	end
end
local function playAnim(id)
	local num = tonumber(id)
	if not num then return end
	local char = getChar()
	local hum = getHum(char)
	if not hum then return end
	local animator = hum:FindFirstChildOfClass("Animator")
	if not animator then
		animator = Instance.new("Animator")
		animator.Parent = hum
	end
	stopAnim()
	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://" .. tostring(num)
	local ok, track = pcall(function() return animator:LoadAnimation(anim) end)
	if ok and track then
		track.Priority = Enum.AnimationPriority.Action
		track:Play()
		State.CurrentAnimTrack = track
	end
end

playAnimBtn.MouseButton1Click:Connect(function() playAnim(animIdBox.Text) end)
stopAnimBtn.MouseButton1Click:Connect(stopAnim)
presetWave.MouseButton1Click:Connect(function() playAnim(507770239) end)
presetDance.MouseButton1Click:Connect(function() playAnim(507771019) end)
presetPoint.MouseButton1Click:Connect(function() playAnim(507770453) end)
presetLaugh.MouseButton1Click:Connect(function() playAnim(507770818) end)
loadEmoterBtn.MouseButton1Click:Connect(function()
	loadEmoterBtn.Text = "Loading..."
	local ok, err = pcall(function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Fixel656/Emoter-GUI_Roblox-Animations-Script/refs/heads/main/MainScript.lua", true))()
	end)
	loadEmoterBtn.Text = ok and "Emoter Loaded" or "Load Failed"
	task.delay(1.5, function() loadEmoterBtn.Text = "Load Emoter GUI (opensource)" end)
end)

-- Avatar changer
local function applyAvatarFromUserId(uid)
	uid = tonumber(uid)
	if not uid then return false end
	local ok, desc = pcall(function()
		return Players:GetHumanoidDescriptionFromUserId(uid)
	end)
	if not ok or not desc then return false end
	local hum = getHum()
	if not hum then return false end
	local ok2 = pcall(function() hum:ApplyDescription(desc) end)
	return ok2
end

applyAvatarBtn.MouseButton1Click:Connect(function()
	applyAvatarBtn.Text = "Applying..."
	local ok = applyAvatarFromUserId(avatarIdBox.Text)
	applyAvatarBtn.Text = ok and "Applied!" or "Failed"
	task.delay(1.2, function() applyAvatarBtn.Text = "Apply Avatar by UserId" end)
end)
resetAvatarBtn.MouseButton1Click:Connect(function()
	resetAvatarBtn.Text = "Resetting..."
	local ok = applyAvatarFromUserId(LocalPlayer.UserId)
	resetAvatarBtn.Text = ok and "Reset!" or "Failed"
	task.delay(1.2, function() resetAvatarBtn.Text = "Reapply My Avatar" end)
end)

-- Toggle window
local function setOpen(v)
	State.Open = v
	main.Visible = v
end
icon.MouseButton1Click:Connect(function() setOpen(not State.Open) end)
closeBtn.MouseButton1Click:Connect(function() setOpen(false) end)

print("[e4u] loaded")