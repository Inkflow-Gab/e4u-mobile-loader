local ctx = ...
local Services = ctx.Services
local C = ctx.UI.Components
local Core = ctx.UI.Core
local Refs = ctx.Refs

local Page = {}

function Page.refresh()
	local lp = Services.LocalPlayer
	pcall(function()
		if Refs.ProfileAvatar then
			Refs.ProfileAvatar.Image = Services.Players:GetUserThumbnailAsync(lp.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
		end
	end)
	local char = lp.Character
	if char and Refs.ProfileBody then
		local hum = char:FindFirstChildOfClass("Humanoid")
		local hrp = char:FindFirstChild("HumanoidRootPart")
		local rig = hum and hum.RigType.Name or "Unknown"
		local hp, maxhp = "?", "?"
		if hum then hp = math.floor(hum.Health); maxhp = math.floor(hum.MaxHealth) end
		local parts, accs, clothes = 0, 0, 0
		for _, v in ipairs(char:GetDescendants()) do
			if v:IsA("BasePart") then parts += 1 end
			if v:IsA("Accessory") then accs += 1 end
			if v:IsA("Clothing") or v:IsA("ShirtGraphic") then clothes += 1 end
		end
		Refs.ProfileBody.Text = string.format("Rig: %s  |  HP: %s/%s\nHRP: %s  |  Parts: %d\nAccessories: %d  |  Clothing: %d", rig, tostring(hp), tostring(maxhp), hrp and "yes" or "no", parts, accs, clothes)
	elseif Refs.ProfileBody then
		Refs.ProfileBody.Text = "Body: character not loaded"
	end
	if Refs.ProfileName then Refs.ProfileName.Text = lp.DisplayName end
	if Refs.ProfileUser then Refs.ProfileUser.Text = "@" .. lp.Name .. " • " .. tostring(lp.UserId) end
end

function Page.init()
	local page = Core.createPage("Profile")
	local lp = Services.LocalPlayer

	C.section(page, "Your Profile & Body", 1)
	local profileCard = C.card(page, 176, 2)

	local avatarImg = Instance.new("ImageLabel")
	avatarImg.Size = UDim2.new(0, 74, 0, 74)
	avatarImg.Position = UDim2.new(0, 10, 0, 10)
	avatarImg.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
	avatarImg.ScaleType = Enum.ScaleType.Crop
	avatarImg.ZIndex = 23
	avatarImg.Parent = profileCard
	C.corner(avatarImg, 37)

	local nameLbl = Instance.new("TextLabel")
	nameLbl.BackgroundTransparency = 1
	nameLbl.Position = UDim2.new(0, 94, 0, 12)
	nameLbl.Size = UDim2.new(1, -104, 0, 20)
	nameLbl.Font = Enum.Font.GothamBold
	nameLbl.TextSize = 15
	nameLbl.TextColor3 = Color3.fromRGB(245,245,250)
	nameLbl.TextXAlignment = Enum.TextXAlignment.Left
	nameLbl.Text = lp.DisplayName
	nameLbl.ZIndex = 23
	nameLbl.Parent = profileCard

	local userLbl = Instance.new("TextLabel")
	userLbl.BackgroundTransparency = 1
	userLbl.Position = UDim2.new(0, 94, 0, 33)
	userLbl.Size = UDim2.new(1, -104, 0, 16)
	userLbl.Font = Enum.Font.Gotham
	userLbl.TextSize = 12
	userLbl.TextColor3 = Color3.fromRGB(160,160,175)
	userLbl.TextXAlignment = Enum.TextXAlignment.Left
	userLbl.Text = "@" .. lp.Name .. " • " .. tostring(lp.UserId)
	userLbl.ZIndex = 23
	userLbl.Parent = profileCard

	local ageLbl = Instance.new("TextLabel")
	ageLbl.BackgroundTransparency = 1
	ageLbl.Position = UDim2.new(0, 94, 0, 51)
	ageLbl.Size = UDim2.new(1, -104, 0, 16)
	ageLbl.Font = Enum.Font.Gotham
	ageLbl.TextSize = 12
	ageLbl.TextColor3 = Color3.fromRGB(160,160,175)
	ageLbl.TextXAlignment = Enum.TextXAlignment.Left
	ageLbl.Text = "Account age: " .. tostring(lp.AccountAge) .. " days"
	ageLbl.ZIndex = 23
	ageLbl.Parent = profileCard

	local bodyLbl = Instance.new("TextLabel")
	bodyLbl.BackgroundTransparency = 1
	bodyLbl.Position = UDim2.new(0, 10, 0, 94)
	bodyLbl.Size = UDim2.new(1, -20, 0, 72)
	bodyLbl.Font = Enum.Font.Gotham
	bodyLbl.TextSize = 12
	bodyLbl.TextColor3 = Color3.fromRGB(175,175,188)
	bodyLbl.TextXAlignment = Enum.TextXAlignment.Left
	bodyLbl.TextYAlignment = Enum.TextYAlignment.Top
	bodyLbl.TextWrapped = true
	bodyLbl.Text = "Body: loading..."
	bodyLbl.ZIndex = 23
	bodyLbl.Parent = profileCard

	Refs.ProfileAvatar = avatarImg
	Refs.ProfileName = nameLbl
	Refs.ProfileUser = userLbl
	Refs.ProfileBody = bodyLbl

	local refreshBtn = C.button(page, "Refresh Profile / Body", 3)
	refreshBtn.MouseButton1Click:Connect(Page.refresh)

	lp.CharacterAdded:Connect(function()
		task.wait(0.5)
		Page.refresh()
	end)

	task.spawn(Page.refresh)
	return page
end

ctx.Pages.Profile = Page
return Page