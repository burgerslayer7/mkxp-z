# RGSS-NX roadmap

## M0 — Horizon boot / RGSS smoke test

Source complete; physical validation pending.

- Build `RGSS-NX.nro` from mkxp-z libretro + RetroArch/libnx.
- Run the original asset-free smoke test.
- Validate graphics and controller input.

## M1 — Playable RMXP / Essentials foundation

Source complete; physical validation pending.

- Isolated RGSS-NX frontend and SD directories.
- Generic RMXP profile.
- Ruby compatibility wrappers.
- Writable save/state/log paths.
- User-game installer.
- Infinite Fusion 2 direct launcher/profile.
- Clean offline fallback if the Switch core lacks HTTP.

Exit criterion: Infinite Fusion 2 reaches overworld, battle and persistent
save/load on a real Switch.

## M2 — Hardware fixes / complete IF2 compatibility

Driven only by real M1 logs/errors:

- graphics/OpenGL issues;
- audio/BGM/SE issues;
- VFS/path edge cases;
- HTTP/sprite-download behavior;
- long sessions, suspend/resume and memory pressure;
- any missing key/controller semantics.

## M3 — Wider Pokémon Essentials matrix

- Test representative Essentials generations/versions using user-supplied games.
- Keep compatibility fixes generic whenever possible.
- Add named per-game profiles only for genuine game-specific behavior.

## M4 — Generic RPG Maker XP/VX/VX Ace UX

- Game discovery from `/switch/RGSS-NX/games`.
- Metadata and friendly launch entries.
- Per-game config/save isolation.
- Better diagnostics and recovery UI.

## M5 — SwitchU / Tico integration

- Stable direct-launch convention.
- One frontend entry per fangame where supported.
- Keep the generic RGSS-NX browser as fallback.

## Parallel track — PSDK-NX

PSDK is not RGSS. Port LiteRGSS2/Ruby/SFML functionality separately while
reusing RGSS-NX's proven libnx packaging, SD layout and launcher conventions.
See `docs/psdk-nx/PORTING_PLAN.md`.
