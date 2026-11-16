local ctx = ...
local Services = ctx.Services
local State = ctx.State
local Utils = ctx.Utils
local Refs = ctx.Refs

local Movement = {}
local flyConn, noclipConn

function Movement.applySpeed(walk, jump)
	local hum = Utils.getHum()
	if not hum then return end
	if walk then hum.WalkSpeed = walk end
	if jump then hum.UseJumpPower = true hum.JumpPower = jump end
end

function Movement.stopFly()
	State.Fly = false
	if Refs.FlyBtn then
		Refs.FlyBtn.Text = "Fly: OFF"
		Refs.FlyBtn.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
	end
	if flyConn then flyConn:Disconnect() flyConn = nil end
	if noclipConn then noclipConn:Disconnect() noclipConn = nil end
	local char = Services.LocalPlayer.Character
	if char then
		local hrp = char:FindFirstChild("HumanoidRootPart")
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hrp then
			for _, v in ipairs(hrp:GetChildren()) do
				if v:IsA("BodyVelocity") or v:IsA("BodyGyro") then v:Destroy() end
			end
			hrp.AssemblyLinearVelocity = Vector3.zero
		end
		if hum then hum.PlatformStand = false end
	end
end

function Movement.startFly()
	local char = Utils.getChar()
	local hrp = Utils.getHRP(char)
	local hum = Utils.getHum(char)
	if not hrp or not hum then return end
	local speed = tonumber(Refs.SpeedBox and Refs.SpeedBox.Text) or State.FlySpeed or 50
	State.FlySpeed = speed
	State.Fly = true
	if Refs.FlyBtn then
		Refs.FlyBtn.Text = "Fly: ON"
		Refs.FlyBtn.BackgroundColor3 = Color3.fromRGB(50, 120, 70)
	end
	hum.PlatformStand = true

	local bv = Instance.new("BodyVelocity")
	bv.Name = "e4uFlyVel"
	bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
	bv.Velocity = Vector3.zero
	bv.Parent = hrp

	local bg = Instance.new("BodyGyro")
	bg.Name = "e4uFlyGyro"
	bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
	bg.P = 1e4
	bg.CFrame = hrp.CFrame
	bg.Parent = hrp

	noclipConn = Services.RunService.Stepped:Connect(function()
		if not State.Fly then return end
		local c = Services.LocalPlayer.Character
		if c then
			for _, part in ipairs(c:GetDescendants()) do
				if part:IsA("BasePart") then part.CanCollide = false end
			end
		end
	end)

	flyConn = Services.RunService.RenderStepped:Connect(function()
		if not State.Fly or not hrp or not hrp.Parent then return end
		local spd = tonumber(Refs.SpeedBox and Refs.SpeedBox.Text) or State.FlySpeed or 50
		State.FlySpeed = spd
		local move = hum.MoveDirection
		local dir = Vector3.zero
		if move and move.Magnitude > 0 then dir = move end
		if hum.Jump then dir = dir + Vector3.new(0, 1, 0) end
		if dir.Magnitude > 0 then dir = dir.Unit end
		bv.Velocity = dir * spd
		local cam = workspace.CurrentCamera
		if cam then bg.CFrame = cam.CFrame end
	end)
end

function Movement.toggleFly()
	if State.Fly then Movement.stopFly() else Movement.startFly() end
end

function Movement.bind()
	Services.LocalPlayer.CharacterAdded:Connect(function()
		task.wait(0.5)
		if State.Fly then
			Movement.stopFly()
			task.wait(0.2)
			Movement.startFly()
		end
	end)
end

ctx.Features.Movement = Movement
return Movement