local ctx = ...
local State = ctx.State
local Utils = ctx.Utils
local Refs = ctx.Refs

local Teleport = {}

function Teleport.toPlayer(name)
	local t = Utils.findPlayer(name)
	if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then
		local hrp = Utils.getHRP()
		if hrp then hrp.CFrame = t.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3) end
		return true
	end
	return false
end

function Teleport.save()
	local hrp = Utils.getHRP()
	if hrp then
		State.SavedCF = hrp.CFrame
		return true
	end
	return false
end

function Teleport.load()
	local hrp = Utils.getHRP()
	if hrp and State.SavedCF then
		hrp.CFrame = State.SavedCF
		return true
	end
	return false
end

ctx.Features.Teleport = Teleport
return Teleport