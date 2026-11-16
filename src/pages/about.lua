local ctx = ...
local C = ctx.UI.Components
local Core = ctx.UI.Core

local Page = {}

function Page.init()
	local page = Core.createPage("About")
	C.section(page, "About e4u", 1)
	local card = C.card(page, 220, 2)
	local txt = Instance.new("TextLabel")
	txt.BackgroundTransparency = 1
	txt.Size = UDim2.new(1, -24, 1, -24)
	txt.Position = UDim2.new(0, 12, 0, 12)
	txt.Font = Enum.Font.Gotham
	txt.TextSize = 13
	txt.TextWrapped = true
	txt.TextXAlignment = Enum.TextXAlignment.Left
	txt.TextYAlignment = Enum.TextYAlignment.Top
	txt.TextColor3 = Color3.fromRGB(180, 180, 195)
	txt.ZIndex = 23
	txt.Text = "e4u - modular mobile hub\n\nBuilt with custom UI assets (no emoji/symbol icons), separate floating icon and nav dock, draggable and resizable window.\n\nModules: services, state, utils, ui, features, pages, scripts.\nFeatures: ESP, teleport, CFrame fly + speed, profile/body viewer, avatar copy/apply.\nScripts: e4u Emotes (our own module).\n\nDesigned so issues can be traced to the specific file."
	txt.Parent = card
	return page
end

ctx.Pages.About = Page
return Page