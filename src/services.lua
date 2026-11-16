local ctx = ...

ctx.Services.Players = game:GetService("Players")
ctx.Services.RunService = game:GetService("RunService")
ctx.Services.UserInputService = game:GetService("UserInputService")
ctx.Services.TweenService = game:GetService("TweenService")
ctx.Services.HttpService = game:GetService("HttpService")

ctx.Services.LocalPlayer = ctx.Services.Players.LocalPlayer
ctx.Services.PlayerGui = ctx.Services.LocalPlayer:WaitForChild("PlayerGui")
ctx.Services.Camera = workspace.CurrentCamera

workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
	ctx.Services.Camera = workspace.CurrentCamera
end)

return ctx.Services