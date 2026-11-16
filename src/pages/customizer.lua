local ctx = ...
local C = ctx.UI.Components
local Core = ctx.UI.Core
local Refs = ctx.Refs

local Page = {}

function Page.init()
	local page = Core.createPage("Customizer")
	C.section(page, "GUI Customizer", 1)
	C.label(page, "Accent color", 2, 18)

	local accentWrap = Instance.new("Frame")
	accentWrap.Size = UDim2.new(1, 0, 0, 36)
	accentWrap.BackgroundTransparency = 1
	accentWrap.LayoutOrder = 3
	accentWrap.ZIndex = 22
	accentWrap.Parent = page
	local accentList = Instance.new("UIListLayout", accentWrap)
	accentList.FillDirection = Enum.FillDirection.Horizontal
	accentList.Padding = UDim.new(0, 8)

	local function accentBtn(color, order)
		local b = Instance.new("TextButton")
		b.Size = UDim2.new(0, 36, 0, 36)
		b.BackgroundColor3 = color
		b.Text = ""
		b.AutoButtonColor = true
		b.LayoutOrder = order
		b.ZIndex = 23
		b.Parent = accentWrap
		C.corner(b, 10)
		b.MouseButton1Click:Connect(function() C.applyAccent(color) end)
		return b
	end
	accentBtn(Color3.fromRGB(90,140,255), 1)
	accentBtn(Color3.fromRGB(120, 220, 150), 2)
	accentBtn(Color3.fromRGB(255, 120, 160), 3)
	accentBtn(Color3.fromRGB(255, 185, 90), 4)
	accentBtn(Color3.fromRGB(180, 140, 255), 5)

	C.label(page, "Window transparency (0 - 0.4)", 4, 18)
	local transBox = C.box(page, "0", "0", 5)
	local applyTrans = C.button(page, "Apply Transparency", 6)
	applyTrans.MouseButton1Click:Connect(function()
		local n = tonumber(transBox.Text) or 0
		n = math.clamp(n, 0, 0.4)
		ctx.State.Theme.Transparency = n
		if Refs.Main then Refs.Main.BackgroundTransparency = n end
		if Refs.Top then Refs.Top.BackgroundTransparency = n end
		if Refs.TopFix then Refs.TopFix.BackgroundTransparency = n end
	end)

	C.label(page, "Drag top bar to move. Drag corner grip to resize. Icon and nav dock move separately.", 7, 36)
	return page
end

ctx.Pages.Customizer = Page
return Page