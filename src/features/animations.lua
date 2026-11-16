local ctx = ...
local State = ctx.State
local Utils = ctx.Utils

local Animations = {}

function Animations.stop()
	if State.CurrentAnimTrack then
		pcall(function() State.CurrentAnimTrack:Stop() end)
		State.CurrentAnimTrack = nil
	end
end

function Animations.play(id)
	local num = tonumber(id)
	if not num then return false end
	local char = Utils.getChar()
	local hum = Utils.getHum(char)
	if not hum then return false end
	local animator = hum:FindFirstChildOfClass("Animator")
	if not animator then
		animator = Instance.new("Animator")
		animator.Parent = hum
	end
	Animations.stop()
	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://" .. tostring(num)
	local ok, track = pcall(function() return animator:LoadAnimation(anim) end)
	if ok and track then
		track.Priority = Enum.AnimationPriority.Action
		track:Play()
		State.CurrentAnimTrack = track
		return true
	end
	return false
end

function Animations.loadEmoter()
	local ok = pcall(function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Fixel656/Emoter-GUI_Roblox-Animations-Script/refs/heads/main/MainScript.lua", true))()
	end)
	return ok
end

ctx.Features.Animations = Animations
return Animations