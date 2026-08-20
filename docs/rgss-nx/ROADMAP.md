# RGSS-NX roadmap

## M0 — Horizon boot / RGSS smoke test

- Produce `RGSS-NX.nro` from mkxp-z libretro + RetroArch/libnx.
- Launch the original asset-free `rgss-nx/smoke-test/mkxp.json`.
- Validate graphics, text fallback, input and clean logs.

Exit criterion: smoke screen renders and Confirm toggles the panel.

## M1 — Filesystem and saves

- Validate `/Game`, `/Save`, `/System` mappings on Switch.
- Save and reload a small RGSS data file.
- Validate case-insensitive asset lookup and paths containing spaces/non-ASCII.

## M2 — Audio and controller mapping

- BGM/BGS/ME/SE test matrix.
- Joy-Con / Pro Controller mapping for RGSS A/B/C/X/Y/Z/L/R.
- Handheld and docked modes.

## M3 — Pokémon Essentials baseline

- Use a redistributable/minimal test project only.
- Record unsupported Win32API calls, filesystem assumptions and Ruby failures.
- Add compatibility shims only from observed failures.

## M4 — Infinite Fusion boot

- User supplies an unmodified legal copy of the game.
- Load its existing `mkxp.json` first.
- Target: title screen -> new/load game -> map -> battle -> save/reload.

## M5 — Infinite Fusion compatibility

- Fix only reproducible Switch/libretro incompatibilities.
- Validate sprite loading/cache, fusion UI, downloads/network-dependent paths,
  saves, long sessions and sleep/resume.

## M6 — Other Essentials fangames

- Compatibility profiles for other fangames only when legally testable by the user.
- No game assets in RGSS-NX.

## M7 — Standalone user experience

- Reduce visible RetroArch plumbing.
- Game discovery and per-game launch metadata.
- Stable paths suitable for SwitchU/Tico integration.
