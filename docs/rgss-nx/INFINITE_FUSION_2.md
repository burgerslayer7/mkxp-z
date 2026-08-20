# Infinite Fusion 2 on RGSS-NX

Status: M1 hardware-test candidate.

RGSS-NX does not execute `InfiniteFusion2.exe` or the RGSS DLLs. It loads the
RPG Maker project directly through mkxp-z using `Game.ini` and
`RGSSNX.mkxp.json`.

## Expected SD layout

```text
/switch/RGSS-NX/
  RGSS-NX.nro
  RGSS-NX-IF2.nro
  games/
    InfiniteFusion2/
      Game.ini
      Data/
      Graphics/
      Audio/
      Fonts/
      RGSSNX.mkxp.json
      RGSSNX/
        compat/
          rgss_nx_bootstrap.rb
          rgss_nx_compat.rb
  saves/
  states/
  screenshots/
  logs/
  system/
```

The user supplies the game files. No Pokémon game assets are part of RGSS-NX.

## Windows installer

From an extracted `RGSS-NX-M1-Switch` artifact:

```powershell
.\Install-Game.ps1 -GamePath "C:\Games\Infinite Fusion 2" -SdRoot "E:\" -Profile infinite-fusion-2
```

Replace `E:\` with the mounted SD card drive.

The installer copies the M1 NRO payload when present, copies the user-owned game
folder, and injects only RGSS-NX's compatibility scripts/configuration.

## Launch

Use `RGSS-NX-IF2.nro` for the direct path. It requests:

```text
sdmc:/switch/RGSS-NX/games/InfiniteFusion2/RGSSNX.mkxp.json
```

Use `RGSS-NX.nro` for the generic browser and manually select a game's
`RGSSNX.mkxp.json`, `mkxp.json` or `Game.ini`.

## Compatibility behavior

- RGSS1 / RPG Maker XP is forced for this profile.
- mkxp-z's Ruby-classic, mkxp and Win32 compatibility preload scripts are
  enabled before the game scripts.
- RGSS-NX's postload layer runs after the game scripts and before `rgss_main`.
- If `HTTPLite` exists, the game's own network/download behavior is preserved.
- If `HTTPLite` is unavailable in the Switch core, downloads are disabled
  cleanly. Local gameplay and bundled sprites remain the first target.
- Attempts to launch an external web browser are ignored on Horizon instead of
  spawning an unavailable desktop command.
- Saves are routed to `/switch/RGSS-NX/saves` by the dedicated frontend.

## First hardware acceptance test

1. The NRO reaches the game without returning immediately to hbmenu.
2. Title/menu graphics render.
3. D-pad and A/B work.
4. Start a new game and reach controllable overworld gameplay.
5. Save, exit the NRO completely, reopen it, and load the save.
6. Enter a battle and return to the overworld.
7. Trigger at least one fusion/sprite display path.

If any step fails, preserve the exact on-screen error and the newest file from
`/switch/RGSS-NX/logs` when available.
