# RGSS-NX M1 hardware test protocol

## Before testing

Use the `RGSS-NX-M1-Switch` GitHub Actions artifact. Extract it on Windows, then
run `Install-Game.ps1` with a user-supplied RPG Maker game folder and the mounted
Switch SD root.

For Infinite Fusion 2:

```powershell
.\Install-Game.ps1 -GamePath "C:\Games\Infinite Fusion 2" -SdRoot "E:\" -Profile infinite-fusion-2
```

## Expected SD essentials

```text
/switch/RGSS-NX/RGSS-NX.nro
/switch/RGSS-NX/RGSS-NX-IF2.nro
/switch/RGSS-NX/games/InfiniteFusion2/Game.ini
/switch/RGSS-NX/system/mkxp-z/Scripts/Preload/rgss_nx_bootstrap.rb
```

## Test A — generic frontend

1. Launch `RGSS-NX.nro` through hbmenu using title takeover/full-memory mode.
2. Confirm the RGUI frontend renders and Joy-Con navigation works.
3. Browse to `/switch/RGSS-NX/games/<game>/Game.ini` and launch it.
4. Preserve any exact error shown on screen.

## Test B — Infinite Fusion 2 direct launcher

1. Launch `RGSS-NX-IF2.nro`.
2. Expected: it directly opens
   `sdmc:/switch/RGSS-NX/games/InfiniteFusion2/Game.ini`.
3. Reach the title/menu.
4. Verify D-pad and A/B.
5. Start a new game and reach the overworld.
6. Enter and leave one battle.
7. Save, fully exit to Horizon/hbmenu, reopen, and load the save.
8. Exercise at least one fusion/custom-sprite display path.

## Logs

When a failure occurs, preserve:

- exact on-screen text;
- the newest file under `/switch/RGSS-NX/logs` if present;
- which NRO was used;
- whether the generic frontend itself still responds to controls.

If text is missing but shapes/graphics render, report that separately: the core
has booted and the next issue is font discovery rather than a full engine failure.
