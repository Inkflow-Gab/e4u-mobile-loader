# e4u

Modular Roblox mobile hub/loader with a custom UI (no emoji/symbol icon assets), separate floating icon + navigation dock, draggable/resizable window, and feature modules split by file for easier debugging.

## Loadstring

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Inkflow-Gab/e4u-mobile-loader/main/main.lua", true))()
```

Compatibility entry (also works):

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Inkflow-Gab/e4u-mobile-loader/main/e4u.lua", true))()
```

## Features

- **Custom UI shell**: splash screen, floating `e4u` icon, separate floating nav dock, draggable top bar, resizable window, custom-drawn icons/controls
- **Profile**: user display/name/id/account age, character/body info (rig, HP, parts, accessories, clothing)
- **Movement**: WalkSpeed/JumpPower apply, CFrame-based fly with speed control and noclip while active (mobile MoveDirection-friendly)
- **Visuals**: ESP highlights for other players (AlwaysOnTop)
- **Teleport**: teleport to player (partial name match), save/load position
- **Avatar**: client-side avatar copy/apply by UserId and reset to self (where experience allows `HumanoidDescription`)
- **Scripts**: built-in `e4u Emotes` module (presets, custom ID, speed, loop) with room to add more
- **Customizer**: accent colors and window transparency

## Project Structure

```text
.
├── main.lua                  # Entry point: loads modules from repo and bootstraps
├── e4u.lua                   # Compatibility loader -> main.lua
└── src/
    ├── services.lua          # Roblox services / shared refs
    ├── state.lua             # Global state and theme
    ├── utils.lua             # Helpers (character/hrp/hum, tween, notify, etc.)
    ├── bootstrap.lua         # Init order and app startup
    ├── ui/
    │   ├── core.lua          # ScreenGui, splash, icon, nav dock, window, paging
    │   └── components.lua    # Reusable UI components + accent/theme helpers
    ├── features/
    │   ├── esp.lua
    │   ├── movement.lua      # Walk/jump + CFrame fly/noclip
    │   ├── teleport.lua
    │   ├── animations.lua    # Animation helpers
    │   └── avatar.lua
    ├── scripts/
    │   └── emotes.lua        # e4u Emotes module (our own script)
    └── pages/
        ├── home.lua
        ├── profile.lua
        ├── features.lua
        ├── scripts.lua
        ├── about.lua
        └── customizer.lua
```

## Setup / Usage

1. Use a Roblox mobile executor that supports `loadstring` and `HttpGet`.
2. Execute the loadstring above.
3. Use the floating **e4u** icon to open/close the main window.
4. Use the separate floating **nav dock** to switch pages (Profile, Features, Scripts, About, Customizer).
5. Drag the top bar to move the window, drag the bottom-right handle to resize, drag icon/dock to reposition.

## Adding or Fixing Scripts

Because the hub is modular, changes can be made in the file responsible for the behavior:

- **UI/layout issues**: `src/ui/core.lua`, `src/ui/components.lua`, or a specific `src/pages/*.lua`
- **Feature bugs**: `src/features/*.lua`
- **Shared helpers/state**: `src/utils.lua`, `src/state.lua`, `src/services.lua`
- **Custom scripts**: add to `src/scripts/` (e.g. `src/scripts/myscript.lua`)

To add a new script module:

1. Create `src/scripts/your_script.lua` that attaches to `ctx.Scripts.YourScript` (follow `emotes.lua` pattern).
2. Add the module path to the `modules` list in `main.lua` (before pages/bootstrap as needed).
3. Register/open it from `src/pages/scripts.lua`.
4. Commit/push so `HttpGet` can load the new file from `main`.

## Notes

- Some actions are **client-side** and depend on game/executor restrictions (avatar description apply, animations/emotes, etc.).
- ESP/Fly/TP behavior can vary by game anti-cheat or replication rules; modules are separated so fixes can target the exact system.
- No external GUI libraries or emoji/symbol icon fonts are required; UI elements are built in-script.

## Development

- Edit files locally, then push to this repo so the loader can fetch updated modules from `main`.
- Keep modules focused (one responsibility per file) to make issues easier to locate and patch.