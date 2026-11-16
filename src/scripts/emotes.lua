-- e4u | custom emotes script (ours)
-- Client-side animation player with presets, speed, loop

local ctx = ...
local Services = ctx.Services
local Utils = ctx.Utils
local State = ctx.State

local Emotes = {}
Emotes.Presets = {
	{name = "Wave", id = 507770239},
	{name = "Point", id = 507770453},
	{name = "Laugh", id = 507770818},
	{name = "Cheer", id = 507770677},
	{name = "Dance 1", id = 507771019},
	{name = "Dance 2", id = 507776043},
	{name = "Dance 3", id = 507777268},
}

local track = nil
local currentSpeed = 1

local function getAnimator()
	local hum = Utils.getHum()
	if not hum then return nil end
	local animator = hum:FindFirstChildOfClass("Animator")
	if not animator then
		animator = Instance.new("Animator")
		animator.Parent = hum
	end
	return animator
end

function Emotes.stop()
	if track then
		pcall(function() track:Stop() end)
		track = nil
		State.CurrentAnimTrack = nil
	end
end

function Emotes.play(id, looped, speed)
	id = tonumber(id)
	if not id then return false end
	local animator = getAnimator()
	if not animator then return false end
	Emotes.stop()
	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://" .. tostring(id)
	local ok, tr = pcall(function() return animator:LoadAnimation(anim) end)
	if not ok or not tr then return false end
	tr.Priority = Enum.AnimationPriority.Action
	tr.Looped = looped and true or false
	tr:Play()
	if speed and tonumber(speed) then
		pcall(function() tr:AdjustSpeed(tonumber(speed)) end)
		currentSpeed = tonumber(speed)
	end
	track = tr
	State.CurrentAnimTrack = tr
	return true
end

function Emotes.setSpeed(speed)
	currentSpeed = tonumber(speed) or 1
	if track then pcall(function() track:AdjustSpeed(currentSpeed) end) end
end

function Emotes.buildUI(parent, C)
	local order = 1
	local function nextOrder() local o = order; order = order + 1; return o end

	C.section(parent, "e4u Emotes", nextOrder())
	C.label(parent, "Client-side animation player. Presets + custom ID, speed, loop.", nextOrder(), 20)

	local idBox = C.box(parent, "Animation ID", "", nextOrder())
	local speedBox = C.box(parent, "Speed (1)", "1", nextOrder())
	local loopState = false
	local loopBtn = C.button(parent, "Loop: OFF", nextOrder())
	loopBtn.MouseButton1Click:Connect(function()
		loopState = not loopState
		loopBtn.Text = "Loop: " .. (loopState and "ON" or "OFF")
		loopBtn.BackgroundColor3 = loopState and Color3.fromRGB(50,120,70) or Color3.fromRGB(32,32,40)
		if track then track.Looped = loopState end
	end)

	local playBtn = C.button(parent, "Play Animation ID", nextOrder(), true)
	local stopBtn = C.button(parent, "Stop Animation", nextOrder())
	playBtn.MouseButton1Click:Connect(function()
		Emotes.play(idBox.Text, loopState, speedBox.Text)
	end)
	stopBtn.MouseButton1Click:Connect(Emotes.stop)
	speedBox.FocusLost:Connect(function() Emotes.setSpeed(speedBox.Text) end)

	C.section(parent, "Presets", nextOrder())
	for _, p in ipairs(Emotes.Presets) do
		local b = C.button(parent, p.name, nextOrder())
		b.MouseButton1Click:Connect(function()
			idBox.Text = tostring(p.id)
			Emotes.play(p.id, loopState, speedBox.Text)
		end)
	end

	return {idBox = idBox, speedBox = speedBox}
end

ctx.Scripts = ctx.Scripts or {}
ctx.Scripts.Emotes = Emotes
return Emotes