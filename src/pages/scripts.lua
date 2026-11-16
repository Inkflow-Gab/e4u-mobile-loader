local ctx = ...
local C = ctx.UI.Components
local Core = ctx.UI.Core

local Page = {}

function Page.init()
	local page = Core.createPage("Scripts")
	local Emotes = ctx.Scripts and ctx.Scripts.Emotes

	C.section(page, "Scripts", 1)
	C.label(page, "Built-in e4u scripts. No external loads for core scripts.", 2, 20)

	local listCard = C.card(page, 54, 3)
	local listLabel = Instance.new("TextLabel")
	listLabel.BackgroundTransparency = 1
	listLabel.Size = UDim2.new(1, -24, 1, -12)
	listLabel.Position = UDim2.new(0, 12, 0, 6)
	listLabel.Font = Enum.Font.GothamSemibold
	listLabel.TextSize = 13
	listLabel.TextXAlignment = Enum.TextXAlignment.Left
	listLabel.TextYAlignment = Enum.TextYAlignment.Top
	listLabel.TextWrapped = true
	listLabel.TextColor3 = Color3.fromRGB(220,220,230)
	listLabel.ZIndex = 23
	listLabel.Text = "Available: e4u Emotes\nCustom animation player with presets, speed and loop."
	listLabel.Parent = listCard

	local openEmotes = C.button(page, "Open e4u Emotes", 4, true)
	local emotesMount = Instance.new("Frame")
	emotesMount.Name = "EmotesMount"
	emotesMount.Size = UDim2.new(1, 0, 0, 0)
	emotesMount.AutomaticSize = Enum.AutomaticSize.Y
	emotesMount.BackgroundTransparency = 1
	emotesMount.LayoutOrder = 5
	emotesMount.Visible = false
	emotesMount.ZIndex = 22
	emotesMount.Parent = page
	local emotesLayout = Instance.new("UIListLayout")
	emotesLayout.Padding = UDim.new(0, 8)
	emotesLayout.SortOrder = Enum.SortOrder.LayoutOrder
	emotesLayout.Parent = emotesMount

	local built = false
	openEmotes.MouseButton1Click:Connect(function()
		emotesMount.Visible = not emotesMount.Visible
		openEmotes.Text = emotesMount.Visible and "Hide e4u Emotes" or "Open e4u Emotes"
		if emotesMount.Visible and not built and Emotes and Emotes.buildUI then
			Emotes.buildUI(emotesMount, C)
			built = true
		end
	end)

	C.label(page, "Add more scripts in src/scripts/ and register them here.", 6, 20)
	return page
end

ctx.Pages.Scripts = Page
return Page