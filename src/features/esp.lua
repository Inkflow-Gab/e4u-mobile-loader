local ctx = ...
local Services = ctx.Services
local State = ctx.State
local Refs = ctx.Refs

local ESP = {}

function ESP.init()
	local espFolder = Instance.new("Folder")
	espFolder.Name = "ESPFolder"
	espFolder.Parent = Refs.Gui
	Refs.ESPFolder = espFolder
end

local function removeESP(plr)
	if State.ESPObjects[plr] then
		pcall(function() State.ESPObjects[plr]:Destroy() end)
		State.ESPObjects[plr] = nil
	end
end

local function addESP(plr)
	if plr == Services.LocalPlayer then return end
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
		h.Parent = Refs.ESPFolder
		State.ESPObjects[plr] = h
	end
	if plr.Character then attach(plr.Character) end
	plr.CharacterAdded:Connect(function(char)
		char:WaitForChild("HumanoidRootPart", 10)
		if State.ESP then attach(char) end
	end)
end

function ESP.set(on)
	State.ESP = on
	if Refs.ESPBtn then
		Refs.ESPBtn.Text = "ESP: " .. (on and "ON" or "OFF")
		Refs.ESPBtn.BackgroundColor3 = on and Color3.fromRGB(50, 120, 70) or Color3.fromRGB(32, 32, 40)
	end
	if on then
		for _, p in ipairs(Services.Players:GetPlayers()) do addESP(p) end
	else
		for plr in pairs(State.ESPObjects) do removeESP(plr) end
	end
end

function ESP.toggle()
	ESP.set(not State.ESP)
end

function ESP.bind()
	Services.Players.PlayerAdded:Connect(function(p)
		if State.ESP then addESP(p) end
	end)
	Services.Players.PlayerRemoving:Connect(removeESP)
end

ctx.Features.ESP = ESP
return ESP