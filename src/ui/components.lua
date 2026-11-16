local ctx = ...
local Services = ctx.Services
local State = ctx.State

local Components = {}

function Components.corner(parent, r)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r or 8)
	c.Parent = parent
	return c
end

function Components.stroke(parent, color, t, tr)
	local s = Instance.new("UIStroke")
	s.Color = color or Color3.fromRGB(60, 60, 70)
	s.Thickness = t or 1
	s.Transparency = tr or 0.2
	s.Parent = parent
	return s
end

function Components.pad(parent, l, r, t, b)
	local p = Instance.new("UIPadding")
	p.PaddingLeft = UDim.new(0, l or 8)
	p.PaddingRight = UDim.new(0, r or l or 8)
	p.PaddingTop = UDim.new(0, t or l or 8)
	p.PaddingBottom = UDim.new(0, b or t or l or 8)
	p.Parent = parent
	return p
end

function Components.registerAccent(obj, prop)
	table.insert(State.AccentObjects, {obj = obj, prop = prop})
end

function Components.applyAccent(color)
	State.Theme.Accent = color
	for _, item in ipairs(State.AccentObjects) do
		if item.obj and item.obj.Parent then
			pcall(function() item.obj[item.prop] = color end)
		end
	end
end

function Components.section(parent, text, order)
	local l = Instance.new("TextLabel")
	l.Size = UDim2.new(1, 0, 0, 18)
	l.BackgroundTransparency = 1
	l.Font = Enum.Font.GothamBold
	l.Text = text
	l.TextSize = 13
	l.TextColor3 = Color3.fromRGB(205, 205, 215)
	l.TextXAlignment = Enum.TextXAlignment.Left
	l.LayoutOrder = order or 1
	l.ZIndex = 22
	l.Parent = parent
	return l
end

function Components.label(parent, text, order, h)
	local l = Instance.new("TextLabel")
	l.Size = UDim2.new(1, 0, 0, h or 20)
	l.BackgroundTransparency = 1
	l.Font = Enum.Font.Gotham
	l.Text = text
	l.TextSize = 12
	l.TextColor3 = State.Theme.SubText
	l.TextXAlignment = Enum.TextXAlignment.Left
	l.TextYAlignment = Enum.TextYAlignment.Top
	l.TextWrapped = true
	l.LayoutOrder = order or 1
	l.ZIndex = 22
	l.Parent = parent
	return l
end

function Components.button(parent, text, order, accent)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1, 0, 0, 36)
	b.BackgroundColor3 = accent and State.Theme.Accent or Color3.fromRGB(32, 32, 40)
	b.Text = text
	b.Font = Enum.Font.GothamBlack
	b.TextSize = 13
	b.TextColor3 = Color3.fromRGB(240, 240, 245)
	b.AutoButtonColor = true
	b.LayoutOrder = order or 1
	b.ZIndex = 22
	b.Parent = parent
	Components.corner(b, 8)
	if accent then Components.registerAccent(b, "BackgroundColor3") end
	return b
end

function Components.box(parent, placeholder, default, order)
	local t = Instance.new("TextBox")
	t.Size = UDim2.new(1, 0, 0, 34)
	t.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
	t.Text = default or ""
	t.PlaceholderText = placeholder or ""
	t.ClearTextOnFocus = false
	t.Font = Enum.Font.GothamBold
	t.TextSize = 13
	t.TextColor3 = Color3.fromRGB(235, 235, 240)
	t.PlaceholderColor3 = Color3.fromRGB(120, 120, 135)
	t.LayoutOrder = order or 1
	t.ZIndex = 22
	t.Parent = parent
	Components.corner(t, 8)
	Components.pad(t, 10, 10, 0, 0)
	return t
end

function Components.card(parent, height, order)
	local f = Instance.new("Frame")
	f.Size = UDim2.new(1, 0, 0, height or 100)
	f.BackgroundColor3 = State.Theme.Panel
	f.BorderSizePixel = 0
	f.LayoutOrder = order or 1
	f.ZIndex = 22
	f.Parent = parent
	Components.corner(f, 10)
	Components.stroke(f, Color3.fromRGB(50, 50, 60), 1, 0.3)
	return f
end

ctx.UI.Components = Components
return Components