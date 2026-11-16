local ctx = ...
local C = ctx.UI.Components
local Core = ctx.UI.Core
local Refs = ctx.Refs
local Utils = ctx.Utils

local Page = {}

function Page.init()
	local page = Core.createPage("Features")
	local Movement = ctx.Features.Movement
	local ESP = ctx.Features.ESP
	local Teleport = ctx.Features.Teleport
	local Avatar = ctx.Features.Avatar

	C.section(page, "Movement", 1)
	local walkBox = C.box(page, "WalkSpeed (16)", "16", 2)
	local jumpBox = C.box(page, "JumpPower (50)", "50", 3)
	local applyMove = C.button(page, "Apply Walk / Jump", 4)
	applyMove.MouseButton1Click:Connect(function()
		Movement.applySpeed(tonumber(walkBox.Text), tonumber(jumpBox.Text))
	end)

	C.section(page, "Fly (CFrame + noclip)", 5)
	local speedBox = C.box(page, "Fly speed", "50", 6)
	local flyBtn = C.button(page, "Fly: OFF", 7)
	Refs.SpeedBox = speedBox
	Refs.FlyBtn = flyBtn
	flyBtn.MouseButton1Click:Connect(Movement.toggleFly)
	speedBox.FocusLost:Connect(function()
		local n = tonumber(speedBox.Text)
		if n and n > 0 then ctx.State.FlySpeed = n else speedBox.Text = tostring(ctx.State.FlySpeed) end
	end)
	C.label(page, "CFrame/body-mover fly with noclip while active. Mobile joystick supported via MoveDirection.", 8, 34)

	C.section(page, "Visuals", 9)
	local espBtn = C.button(page, "ESP: OFF", 10)
	Refs.ESPBtn = espBtn
	espBtn.MouseButton1Click:Connect(ESP.toggle)
	C.label(page, "Highlight ESP on other players (AlwaysOnTop).", 11, 20)

	C.section(page, "Teleport", 12)
	local tpBox = C.box(page, "Target player name / display name", "", 13)
	local tpBtn = C.button(page, "Teleport to Player", 14)
	local savePosBtn = C.button(page, "Save Current Position", 15)
	local loadPosBtn = C.button(page, "Load Saved Position", 16)
	tpBtn.MouseButton1Click:Connect(function()
		local ok = Teleport.toPlayer(tpBox.Text)
		Utils.notify(tpBtn, "Teleported", "Player not found", ok, "Teleport to Player", 1.2)
	end)
	savePosBtn.MouseButton1Click:Connect(function()
		Utils.notify(savePosBtn, "Saved!", "Failed", Teleport.save(), "Save Current Position", 1)
	end)
	loadPosBtn.MouseButton1Click:Connect(function()
		Utils.notify(loadPosBtn, "Loaded!", "No saved pos", Teleport.load(), "Load Saved Position", 1)
	end)

	C.section(page, "Avatar (client-side)", 17)
	local avatarIdBox = C.box(page, "Copy avatar from UserId", "", 18)
	local applyAvatarBtn = C.button(page, "Apply Avatar by UserId", 19)
	local resetAvatarBtn = C.button(page, "Reapply My Avatar", 20)
	C.label(page, "Uses HumanoidDescription where the experience allows it.", 21, 20)
	applyAvatarBtn.MouseButton1Click:Connect(function()
		applyAvatarBtn.Text = "Applying..."
		local ok = Avatar.applyFromUserId(avatarIdBox.Text)
		applyAvatarBtn.Text = ok and "Applied!" or "Failed"
		task.delay(1.2, function() if applyAvatarBtn and applyAvatarBtn.Parent then applyAvatarBtn.Text = "Apply Avatar by UserId" end end)
	end)
	resetAvatarBtn.MouseButton1Click:Connect(function()
		resetAvatarBtn.Text = "Resetting..."
		local ok = Avatar.resetToSelf()
		resetAvatarBtn.Text = ok and "Reset!" or "Failed"
		task.delay(1.2, function() if resetAvatarBtn and resetAvatarBtn.Parent then resetAvatarBtn.Text = "Reapply My Avatar" end end)
	end)

	C.section(page, "Emotes", 22)
	C.label(page, "Emotes moved to Scripts page as our built-in e4u Emotes module.", 23, 20)
	local openScripts = C.button(page, "Open Scripts Page", 24, true)
	openScripts.MouseButton1Click:Connect(function() Core.showPage("Scripts") end)

	return page
end

ctx.Pages.Features = Page
return Page