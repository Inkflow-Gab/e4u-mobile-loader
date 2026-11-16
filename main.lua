-- e4u | modular mobile hub loader (entry point)
-- Repo: https://github.com/Inkflow-Gab/e4u-mobile-loader

if not game:IsLoaded() then game.Loaded:Wait() end

local BASE = "https://raw.githubusercontent.com/Inkflow-Gab/e4u-mobile-loader/main/"

local function import(path, ctx)
	local okFetch, src = pcall(function() return game:HttpGet(BASE .. path, true) end)
	if not okFetch then
		warn("[e4u] fetch failed: " .. path .. " :: " .. tostring(src))
		return nil
	end
	local fn, err = loadstring(src, path)
	if not fn then
		warn("[e4u] compile failed: " .. path .. " :: " .. tostring(err))
		return nil
	end
	local okRun, res = pcall(fn, ctx)
	if not okRun then
		warn("[e4u] runtime failed: " .. path .. " :: " .. tostring(res))
		return nil
	end
	return res
end

local ctx = {
	BASE = BASE,
	import = import,
	Services = {},
	State = {},
	Utils = {},
	UI = {},
	Features = {},
	Pages = {},
	Scripts = {},
	Refs = {},
}

local modules = {
	"src/services.lua",
	"src/state.lua",
	"src/utils.lua",
	"src/ui/components.lua",
	"src/ui/core.lua",
	"src/features/esp.lua",
	"src/features/movement.lua",
	"src/features/teleport.lua",
	"src/features/animations.lua",
	"src/features/avatar.lua",
	"src/scripts/emotes.lua",
	"src/pages/home.lua",
	"src/pages/profile.lua",
	"src/pages/features.lua",
	"src/pages/scripts.lua",
	"src/pages/about.lua",
	"src/pages/customizer.lua",
	"src/bootstrap.lua",
}

for _, path in ipairs(modules) do
	import(path, ctx)
end

print("[e4u] bootstrap complete")
return ctx