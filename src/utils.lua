local ctx = ...
local Services = ctx.Services

local Utils = {}

function Utils.getChar(plr)
	plr = plr or Services.LocalPlayer
	return plr.Character or plr.CharacterAdded:Wait()
end

function Utils.getHRP(char)
	char = char or Utils.getChar()
	return char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart", 10)
end

function Utils.getHum(char)
	char = char or Utils.getChar()
	return char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 10)
end

function Utils.findPlayer(str)
	if not str or str == "" then return nil end
	str = str:lower()
	for _, p in ipairs(Services.Players:GetPlayers()) do
		if p ~= Services.LocalPlayer then
			if p.Name:lower():sub(1, #str) == str or p.DisplayName:lower():sub(1, #str) == str then
				return p
			end
		end
	end
	return nil
end

function Utils.tween(obj, props, t, style, dir)
	local ti = TweenInfo.new(t or 0.18, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out)
	local tw = Services.TweenService:Create(obj, ti, props)
	tw:Play()
	return tw
end

function Utils.safeDestroy(inst)
	if inst then pcall(function() inst:Destroy() end) end
end

function Utils.notify(btn, okText, failText, ok, resetText, delaySec)
	if not btn then return end
	btn.Text = ok and okText or failText
	task.delay(delaySec or 1.2, function()
		if btn and btn.Parent then btn.Text = resetText end
	end)
end

ctx.Utils = Utils
return Utils