local ctx = ...
local Services = ctx.Services
local State = ctx.State
local Utils = ctx.Utils
local C = ctx.UI.Components

local Core = {}

local function makeIcon(parent, kind, color)
	-- Custom drawn icons (no emoji/symbol text)
	local c = color or Color3.fromRGB(200, 200, 210)
	local function f(p, size, pos, bg, radius)
		local fr = Instance.new("Frame")
		fr.Size = size
		fr.Position = pos
		fr.BackgroundColor3 = bg or c
		fr.BorderSizePixel = 0
		fr.ZIndex = 37
		fr.Parent = p
		if radius then
			local u = Instance.new("UICorner")
			u.CornerRadius = UDim.new(0, radius)
			u.Parent = fr
		end
		return fr
	end

	if kind == "Home" then
		f(parent, UDim2.new(0, 14, 0, 10), UDim2.new(0.5, -7, 0.5, -2), c, 2)
		f(parent, UDim2.new(0, 16, 0, 3), UDim2.new(0.5, -8, 0.5, -6), c, 2)
		f(parent, UDim2.new(0, 4, 0, 5), UDim2.new(0.5, -2, 0.5, 3), Color3.fromRGB(26,26,32), 1)
	elseif kind == "Profile" then
		f(parent, UDim2.new(0, 8, 0, 8), UDim2.new(0.5, -4, 0.5, -8), c, 8)
		f(parent, UDim2.new(0, 14, 0, 8), UDim2.new(0.5, -7, 0.5, 1), c, 4)
	elseif kind == "Features" then
		f(parent, UDim2.new(0, 3, 0, 14), UDim2.new(0.5, -1, 0.5, -7), c, 2)
		f(parent, UDim2.new(0, 14, 0, 3), UDim2.new(0.5, -7, 0.5, -1), c, 2)
		f(parent, UDim2.new(0, 10, 0, 3), UDim2.new(0.5, -5, 0.5, -7), c, 2)
		f(parent, UDim2.new(0, 10, 0, 3), UDim2.new(0.5, -5, 0.5, 5), c, 2)
	elseif kind == "Scripts" then
		f(parent, UDim2.new(0, 12, 0, 16), UDim2.new(0.5, -6, 0.5, -8), c, 2)
		f(parent, UDim2.new(0, 8, 0, 2), UDim2.new(0.5, -4, 0.5, -4), Color3.fromRGB(26,26,32), 1)
		f(parent, UDim2.new(0, 8, 0, 2), UDim2.new(0.5, -4, 0.5, 0), Color3.fromRGB(26,26,32), 1)
		f(parent, UDim2.new(0, 6, 0, 2), UDim2.new(0.5, -4, 0.5, 4), Color3.fromRGB(26,26,32), 1)
	elseif kind == "About" then
		f(parent, UDim2.new(0, 4, 0, 4), UDim2.new(0.5, -2, 0.5, -8), c, 4)
		f(parent, UDim2.new(0, 3, 0, 10), UDim2.new(0.5, -1, 0.5, -2), c, 2)
	elseif kind == "Customizer" then
		f(parent, UDim2.new(0, 14, 0, 3), UDim2.new(0.5, -7, 0.5, -6), c, 2)
		f(parent, UDim2.new(0, 14, 0, 3), UDim2.new(0.5, -7, 0.5, -1), c, 2)
		f(parent, UDim2.new(0, 14, 0, 3), UDim2.new(0.5, -7, 0.5, 4), c, 2)
		f(parent, UDim2.new(0, 4, 0, 4), UDim2.new(0.5, -5, 0.5, -6.5), Color3.fromRGB(245,245,250), 4)
		f(parent, UDim2.new(0, 4, 0, 4), UDim2.new(0.5, 1, 0.5, -1.5), Color3.fromRGB(245,245,250), 4)
		f(parent, UDim2.new(0, 4, 0, 4), UDim2.new(0.5, -3, 0.5, 3.5), Color3.fromRGB(245,245,250), 4)
	end
end

function Core.init()
	pcall(function()
		local old = Services.PlayerGui:FindFirstChild("e4u")
		if old then old:Destroy() end
	end)

	local gui = Instance.new("ScreenGui")
	gui.Name = "e4u"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.DisplayOrder = 999999
	gui.Parent = Services.PlayerGui

	-- Splash
	local splash = Instance.new("Frame")
	splash.Name = "Splash"
	splash.Size = UDim2.fromScale(1, 1)
	splash.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
	splash.BorderSizePixel = 0
	splash.ZIndex = 80
	splash.Parent = gui

	local splashTitle = Instance.new("TextLabel")
	splashTitle.BackgroundTransparency = 1
	splashTitle.Size = UDim2.new(1, 0, 0, 64)
	splashTitle.Position = UDim2.new(0, 0, 0.5, -42)
	splashTitle.Font = Enum.Font.GothamBold
	splashTitle.Text = "e4u"
	splashTitle.TextSize = 58
	splashTitle.TextColor3 = Color3.fromRGB(245, 245, 250)
	splashTitle.TextTransparency = 1
	splashTitle.ZIndex = 81
	splashTitle.Parent = splash

	local splashSub = Instance.new("TextLabel")
	splashSub.BackgroundTransparency = 1
	splashSub.Size = UDim2.new(1, 0, 0, 22)
	splashSub.Position = UDim2.new(0, 0, 0.5, 20)
	splashSub.Font = Enum.Font.Gotham
	splashSub.Text = "mobile hub loading"
	splashSub.TextSize = 14
	splashSub.TextColor3 = Color3.fromRGB(150, 150, 165)
	splashSub.TextTransparency = 1
	splashSub.ZIndex = 81
	splashSub.Parent = splash

	task.spawn(function()
		Utils.tween(splashTitle, {TextTransparency = 0}, 0.35)
		Utils.tween(splashSub, {TextTransparency = 0}, 0.35)
		task.wait(1.1)
		Utils.tween(splashTitle, {TextTransparency = 1}, 0.3)
		Utils.tween(splashSub, {TextTransparency = 1}, 0.3)
		Utils.tween(splash, {BackgroundTransparency = 1}, 0.4)
		task.wait(0.45)
		Utils.safeDestroy(splash)
	end)

	-- Floating icon (separate) - custom asset mark
	local icon = Instance.new("TextButton")
	icon.Name = "Icon"
	icon.Size = UDim2.new(0, 46, 0, 46)
	icon.Position = UDim2.new(0, 14, 0.5, -140)
	icon.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
	icon.Text = ""
	icon.AutoButtonColor = true
	icon.Active = true
	icon.Draggable = true
	icon.ZIndex = 40
	icon.Parent = gui
	C.corner(icon, 14)
	C.stroke(icon, Color3.fromRGB(85, 85, 100), 1)
	local iconMark = Instance.new("TextLabel")
	iconMark.BackgroundTransparency = 1
	iconMark.Size = UDim2.fromScale(1, 1)
	iconMark.Font = Enum.Font.GothamBold
	iconMark.Text = "e4u"
	iconMark.TextSize = 13
	iconMark.TextColor3 = Color3.fromRGB(245,245,250)
	iconMark.ZIndex = 41
	iconMark.Parent = icon

	-- Floating nav dock (separate)
	local nav = Instance.new("Frame")
	nav.Name = "NavDock"
	nav.Size = UDim2.new(0, 50, 0, 320)
	nav.Position = UDim2.new(0, 14, 0.5, -80)
	nav.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
	nav.BorderSizePixel = 0
	nav.Active = true
	nav.Draggable = true
	nav.ZIndex = 35
	nav.Parent = gui
	C.corner(nav, 14)
	C.stroke(nav, Color3.fromRGB(70, 70, 85), 1, 0.15)

	local navList = Instance.new("UIListLayout")
	navList.Padding = UDim.new(0, 6)
	navList.HorizontalAlignment = Enum.HorizontalAlignment.Center
	navList.SortOrder = Enum.SortOrder.LayoutOrder
	navList.Parent = nav
	C.pad(nav, 6, 6, 8, 8)

	local navIndicator = Instance.new("Frame")
	navIndicator.Size = UDim2.new(0, 3, 0, 22)
	navIndicator.Position = UDim2.new(0, 0, 0, 8)
	navIndicator.BackgroundColor3 = State.Theme.Accent
	navIndicator.BorderSizePixel = 0
	navIndicator.ZIndex = 36
	navIndicator.Parent = nav
	C.corner(navIndicator, 2)
	C.registerAccent(navIndicator, "BackgroundColor3")

	-- Main window
	local main = Instance.new("Frame")
	main.Name = "Main"
	main.Size = UDim2.new(0, 340, 0, 430)
	main.Position = UDim2.new(0.5, -150, 0.5, -215)
	main.BackgroundColor3 = State.Theme.BG
	main.BackgroundTransparency = State.Theme.Transparency
	main.BorderSizePixel = 0
	main.Active = true
	main.Visible = false
	main.ClipsDescendants = true
	main.ZIndex = 20
	main.Parent = gui
	C.corner(main, 12)
	C.stroke(main, State.Theme.Stroke, 1, 0.1)

	local top = Instance.new("Frame")
	top.Name = "Topbar"
	top.Size = UDim2.new(1, 0, 0, 44)
	top.BackgroundColor3 = State.Theme.Top
	top.BorderSizePixel = 0
	top.ZIndex = 21
	top.Parent = main
	C.corner(top, 12)
	local topFix = Instance.new("Frame")
	topFix.Size = UDim2.new(1, 0, 0, 12)
	topFix.Position = UDim2.new(0, 0, 1, -12)
	topFix.BackgroundColor3 = State.Theme.Top
	topFix.BorderSizePixel = 0
	topFix.ZIndex = 21
	topFix.Parent = top

	local title = Instance.new("TextLabel")
	title.BackgroundTransparency = 1
	title.Position = UDim2.new(0, 12, 0, 0)
	title.Size = UDim2.new(1, -60, 1, 0)
	title.Font = Enum.Font.GothamBold
	title.Text = "e4u"
	title.TextSize = 18
	title.TextColor3 = State.Theme.Text
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.ZIndex = 22
	title.Parent = top

	local closeBtn = Instance.new("TextButton")
	closeBtn.Size = UDim2.new(0, 28, 0, 28)
	closeBtn.Position = UDim2.new(1, -36, 0.5, -14)
	closeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
	closeBtn.Text = ""
	closeBtn.AutoButtonColor = true
	closeBtn.ZIndex = 22
	closeBtn.Parent = top
	C.corner(closeBtn, 8)
	-- custom close X icon
	local cx1 = Instance.new("Frame")
	cx1.Size = UDim2.new(0, 12, 0, 2)
	cx1.Position = UDim2.new(0.5, -6, 0.5, -1)
	cx1.Rotation = 45
	cx1.BackgroundColor3 = Color3.fromRGB(220,220,225)
	cx1.BorderSizePixel = 0
	cx1.ZIndex = 23
	cx1.Parent = closeBtn
	C.corner(cx1, 1)
	local cx2 = cx1:Clone()
	cx2.Rotation = -45
	cx2.Parent = closeBtn

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
		Services.UserInputService.InputChanged:Connect(function(input)
			if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				local delta = input.Position - dragStart
				main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			end
		end)
	end

	-- Resize handle (custom)
	local resize = Instance.new("TextButton")
	resize.Name = "Resize"
	resize.Size = UDim2.new(0, 22, 0, 22)
	resize.Position = UDim2.new(1, -22, 1, -22)
	resize.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
	resize.Text = ""
	resize.AutoButtonColor = true
	resize.ZIndex = 23
	resize.Parent = main
	C.corner(resize, 6)
	for i = 0, 2 do
		local d = Instance.new("Frame")
		d.Size = UDim2.new(0, 2 + i * 3, 0, 2)
		d.Position = UDim2.new(1, -6 - i * 3, 1, -6 - i * 0)
		d.BackgroundColor3 = Color3.fromRGB(150,150,165)
		d.BorderSizePixel = 0
		d.Rotation = -45
		d.ZIndex = 24
		d.Parent = resize
	end
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
		Services.UserInputService.InputChanged:Connect(function(input)
			if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				local delta = input.Position - rStart
				local w = math.clamp(startSize.X.Offset + delta.X, 290, 560)
				local h = math.clamp(startSize.Y.Offset + delta.Y, 320, 720)
				main.Size = UDim2.new(0, w, 0, h)
			end
		end)
	end

	local pageTitle = Instance.new("TextLabel")
	pageTitle.BackgroundTransparency = 1
	pageTitle.Position = UDim2.new(0, 12, 0, 50)
	pageTitle.Size = UDim2.new(1, -24, 0, 22)
	pageTitle.Font = Enum.Font.GothamBold
	pageTitle.Text = "Home"
	pageTitle.TextSize = 15
	pageTitle.TextColor3 = Color3.fromRGB(220, 220, 230)
	pageTitle.TextXAlignment = Enum.TextXAlignment.Left
	pageTitle.ZIndex = 21
	pageTitle.Parent = main

	local pagesHost = Instance.new("Frame")
	pagesHost.Name = "Pages"
	pagesHost.Size = UDim2.new(1, -16, 1, -84)
	pagesHost.Position = UDim2.new(0, 8, 0, 76)
	pagesHost.BackgroundTransparency = 1
	pagesHost.ZIndex = 21
	pagesHost.Parent = main

	ctx.Refs.Gui = gui
	ctx.Refs.Main = main
	ctx.Refs.Top = top
	ctx.Refs.TopFix = topFix
	ctx.Refs.Icon = icon
	ctx.Refs.Nav = nav
	ctx.Refs.NavIndicator = navIndicator
	ctx.Refs.PageTitle = pageTitle
	ctx.Refs.PagesHost = pagesHost
	ctx.Refs.Pages = {}
	ctx.Refs.NavButtons = {}
	ctx.Refs.NavIcons = {}
	ctx.Refs.CloseBtn = closeBtn

	function Core.createPage(name)
		local p = Instance.new("ScrollingFrame")
		p.Name = name
		p.Size = UDim2.fromScale(1, 1)
		p.BackgroundTransparency = 1
		p.BorderSizePixel = 0
		p.ScrollBarThickness = 3
		p.ScrollBarImageColor3 = Color3.fromRGB(85, 85, 100)
		p.CanvasSize = UDim2.new(0, 0, 0, 0)
		p.AutomaticCanvasSize = Enum.AutomaticSize.Y
		p.Visible = false
		p.ZIndex = 21
		p.Parent = pagesHost
		local pl = Instance.new("UIListLayout")
		pl.Padding = UDim.new(0, 8)
		pl.SortOrder = Enum.SortOrder.LayoutOrder
		pl.Parent = p
		C.pad(p, 4, 6, 2, 10)
		ctx.Refs.Pages[name] = p
		return p
	end

	function Core.setIconColor(name, color)
		local holder = ctx.Refs.NavIcons[name]
		if not holder then return end
		for _, ch in ipairs(holder:GetChildren()) do
			if ch:IsA("Frame") and ch.Name ~= "KnobKeep" then
				-- knobs we set white in customizer icon stay white; others follow
				if ch.BackgroundColor3 ~= Color3.fromRGB(245,245,250) or name ~= "Customizer" then
					ch.BackgroundColor3 = color
				end
			end
		end
	end

	function Core.showPage(name)
		for k, p in pairs(ctx.Refs.Pages) do p.Visible = (k == name) end
		State.CurrentPage = name
		if ctx.Refs.PageTitle then ctx.Refs.PageTitle.Text = name end
		for k, b in pairs(ctx.Refs.NavButtons) do
			local active = (k == name)
			b.BackgroundColor3 = active and Color3.fromRGB(38, 38, 48) or Color3.fromRGB(26, 26, 32)
			Core.setIconColor(k, active and State.Theme.Accent or Color3.fromRGB(190, 190, 200))
		end
		local btn = ctx.Refs.NavButtons[name]
		if btn and navIndicator and nav then
			Utils.tween(navIndicator, {Position = UDim2.new(0, 0, 0, btn.AbsolutePosition.Y - nav.AbsolutePosition.Y + 6)}, 0.12)
		end
	end

	function Core.setOpen(v)
		State.Open = v
		main.Visible = v
	end

	icon.MouseButton1Click:Connect(function() Core.setOpen(not State.Open) end)
	closeBtn.MouseButton1Click:Connect(function() Core.setOpen(false) end)

	local NavDef = {
		{key="Home", order=1},
		{key="Profile", order=2},
		{key="Features", order=3},
		{key="Scripts", order=4},
		{key="About", order=5},
		{key="Customizer", order=6},
	}

	for _, def in ipairs(NavDef) do
		local b = Instance.new("TextButton")
		b.Size = UDim2.new(0, 36, 0, 36)
		b.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
		b.Text = ""
		b.AutoButtonColor = true
		b.LayoutOrder = def.order
		b.ZIndex = 36
		b.Parent = nav
		C.corner(b, 10)
		local iconHolder = Instance.new("Frame")
		iconHolder.Name = "IconHolder"
		iconHolder.BackgroundTransparency = 1
		iconHolder.Size = UDim2.fromScale(1, 1)
		iconHolder.ZIndex = 37
		iconHolder.Parent = b
		makeIcon(iconHolder, def.key, Color3.fromRGB(190,190,200))
		ctx.Refs.NavButtons[def.key] = b
		ctx.Refs.NavIcons[def.key] = iconHolder
		b.MouseButton1Click:Connect(function()
			Core.setOpen(true)
			Core.showPage(def.key)
		end)
	end

	ctx.UI.Core = Core
	return Core
end

ctx.UI.Core = Core
return Core