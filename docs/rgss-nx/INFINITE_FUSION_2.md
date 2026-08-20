# Infinite Fusion 2 on RGSS-NX

Status: M1 hardware-test candidate.

RGSS-NX does **not** execute `InfiniteFusion2.exe` or the Windows RGSS DLL. The
mkxp-z core loads the RPG Maker project directly from its original `Game.ini`
and then reads the game's own `mkxp.json` when present.

RGSS-NX never rewrites the copied fangame configuration. Compatibility is
provided from the runtime's system directory.

## Expected SD layout

```text
/switch/RGSS-NX/
  RGSS-NX.nro
  RGSS-NX-IF2.nro
  games/
    InfiniteFusion2/
      Game.ini
      mkxp.json
      Data/
      Graphics/
      Audio/
      Fonts/
      ...other original game files...
  system/
    mkxp-z/
      Scripts/
        Preload/
          rgss_nx_bootstrap.rb
  saves/
  states/
  screenshots/
  logs/
```

The user supplies the game. RGSS-NX contains no Pokémon/fangame assets.

## Windows installer

Extract the `RGSS-NX-M1-Switch` GitHub Actions artifact, then run:

```powershell
.\Install-Game.ps1 -GamePath "C:\Games\Infinite Fusion 2" -SdRoot "E:\" -Profile infinite-fusion-2
```

Replace `E:\` with the mounted SD card drive.

The installer copies the NRO/runtime payload, copies the user-supplied game to
`/switch/RGSS-NX/games/InfiniteFusion2/`, and leaves its `Game.ini` and
`mkxp.json` untouched.

## Launch

`RGSS-NX-IF2.nro` directly loads:

```text
sdmc:/switch/RGSS-NX/games/InfiniteFusion2/Game.ini
```

`RGSS-NX.nro` is the generic browser. It can load `Game.ini`, `mkxp.json`,
`.rxproj`, `.rvproj`, `.rvproj2`, `.mkxpz`, `.zip` and `.7z` content supported
by the mkxp-z libretro core.

## Compatibility behavior

The dedicated frontend enables mkxp-z's `ruby_classic_wrap.rb`,
`mkxp_wrap.rb`, the upstream Win32 compatibility wrapper, and RGSS-NX's own
preload. RGSS-NX's preload is installed under the libretro system directory,
not inside the game.

For Infinite Fusion 2 specifically:

- if `HTTPLite` is available, the game's own download setting and HTTP methods
  remain in control;
- if it is unavailable, sprite/data downloads are cleanly disabled rather than
  crashing the game;
- attempts to spawn a desktop web browser are ignored on Horizon;
- save writes are routed through mkxp-z's `/Save` VFS into the dedicated SD
  save directory.

## First hardware acceptance test

1. `RGSS-NX-IF2.nro` starts without returning immediately to hbmenu.
2. Infinite Fusion 2 reaches its title/menu.
3. D-pad and A/B work.
4. A new game reaches controllable overworld gameplay.
5. A battle starts and returns to the map.
6. Save, completely exit, reopen, and load the save.
7. Display at least one fusion/custom sprite path.

If a step fails, preserve the exact on-screen error and the newest file from
`/switch/RGSS-NX/logs` when one is created.
