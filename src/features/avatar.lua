local ctx = ...
local Services = ctx.Services
local Utils = ctx.Utils

local Avatar = {}

function Avatar.applyFromUserId(uid)
	uid = tonumber(uid)
	if not uid then return false end
	local ok, desc = pcall(function()
		return Services.Players:GetHumanoidDescriptionFromUserId(uid)
	end)
	if not ok or not desc then return false end
	local hum = Utils.getHum()
	if not hum then return false end
	local ok2 = pcall(function() hum:ApplyDescription(desc) end)
	return ok2
end

function Avatar.resetToSelf()
	return Avatar.applyFromUserId(Services.LocalPlayer.UserId)
end

ctx.Features.Avatar = Avatar
return Avatar