local ctx = ...
local Services = ctx.Services
local C = ctx.UI.Components
local Core = ctx.UI.Core

local Page = {}

function Page.init()
	local page = Core.createPage("Home")
	local lp = Services.LocalPlayer

	C.section(page, "e4u", 1)
	local homeCard = C.card(page, 86, 2)
	local homeBig = Instance.new("TextLabel")
	homeBig.BackgroundTransparency = 1
	homeBig.Position = UDim2.new(0, 12, 0, 10)
	homeBig.Size = UDim2.new(1, -24, 0, 28)
	homeBig.Font = Enum.Font.GothamBold
	homeBig.TextSize = 22
	homeBig.Text = "hey, " .. lp.DisplayName
	homeBig.TextColor3 = Color3.fromRGB(245,245,250)
	homeBig.TextXAlignment = Enum.TextXAlignment.Left
	homeBig.ZIndex = 23
	homeBig.Parent = homeCard

	local homeSmall = Instance.new("TextLabel")
	homeSmall.BackgroundTransparency = 1
	homeSmall.Position = UDim2.new(0, 12, 0, 40)
	homeSmall.Size = UDim2.new(1, -24, 0, 36)
	homeSmall.Font = Enum.Font.Gotham
	homeSmall.TextSize = 12
	homeSmall.TextWrapped = true
	homeSmall.TextXAlignment = Enum.TextXAlignment.Left
	homeSmall.TextYAlignment = Enum.TextYAlignment.Top
	homeSmall.Text = "minimal mobile hub • esp, teleport, cframe fly, profile, emotes, avatar & gui tools"
	homeSmall.TextColor3 = Color3.fromRGB(160,160,175)
	homeSmall.ZIndex = 23
	homeSmall.Parent = homeCard

	C.label(page, "Use the floating dock (separate window) to switch pages: Profile, Features, Scripts, About, Customizer.", 3, 36)
	local openFeat = C.button(page, "Open Features", 4, true)
	openFeat.MouseButton1Click:Connect(function() Core.showPage("Features") end)

	return page
end

ctx.Pages.Home = Page
return Page