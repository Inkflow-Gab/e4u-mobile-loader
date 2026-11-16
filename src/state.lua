local ctx = ...

ctx.State = {
	Open = false,
	CurrentPage = "Home",
	ESP = false,
	Fly = false,
	FlySpeed = 50,
	SavedCF = nil,
	ESPObjects = {},
	CurrentAnimTrack = nil,
	Connections = {},
	Theme = {
		Accent = Color3.fromRGB(90, 140, 255),
		BG = Color3.fromRGB(16, 16, 20),
		Panel = Color3.fromRGB(24, 24, 30),
		Top = Color3.fromRGB(22, 22, 28),
		Stroke = Color3.fromRGB(55, 55, 65),
		Text = Color3.fromRGB(245, 245, 250),
		SubText = Color3.fromRGB(165, 165, 180),
		Transparency = 0,
	},
	AccentObjects = {}, -- {obj=Instance, prop=string}
}

return ctx.State