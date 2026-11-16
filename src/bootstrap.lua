local ctx = ...
local Core = ctx.UI.Core
local ESP = ctx.Features.ESP
local Movement = ctx.Features.Movement

-- Init core UI shell
Core.init()

-- Init feature systems that need UI refs/folders
ESP.init()
ESP.bind()
Movement.bind()

-- Init pages
ctx.Pages.Home.init()
ctx.Pages.Profile.init()
ctx.Pages.Features.init()
ctx.Pages.Scripts.init()
ctx.Pages.About.init()
ctx.Pages.Customizer.init()

-- Default page and open state
Core.showPage("Home")
Core.setOpen(true)

print("[e4u] ready")
return true