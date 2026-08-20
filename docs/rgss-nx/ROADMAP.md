# RGSS-NX roadmap

## M0 — Horizon / RGSS proof

Source complete; hardware validation pending.

Exit criterion: original smoke screen renders and controller Confirm works.

## M1 — playable RPG Maker / Essentials foundation

Source complete; hardware validation pending.

- isolated generic frontend;
- deterministic mkxp-z core options;
- compatibility preload from `/System`;
- writable save/state/log directories;
- user-game installer;
- direct Infinite Fusion 2 launcher using original `Game.ini`;
- clean offline fallback when the core has no HTTP backend.

Exit criterion: Infinite Fusion 2 reaches overworld, battle and persistent
save/load on a real Switch.

## M2 — hardware-driven fixes

- graphics/OpenGL issues;
- audio/BGM/SE issues;
- VFS/path edge cases;
- HTTP/sprite-download behavior;
- long sessions and suspend/resume;
- memory pressure and controller edge cases.

## M3 — wider Pokémon Essentials matrix

Test representative Essentials generations with user-supplied games. Keep
fixes generic; add named game shims only when genuinely necessary.

## M4 — generic RPG Maker UX

- game discovery under `/switch/RGSS-NX/games`;
- friendly metadata/direct launch entries;
- per-game configuration/save isolation;
- better hardware diagnostics.

## M5 — SwitchU / Tico integration

Stable launch convention and one entry per fangame where supported, with the
generic RGSS-NX browser retained as fallback.

## Parallel track — PSDK-NX

Port LiteRGSS2/Ruby runtime pieces to libnx separately while reusing RGSS-NX's
packaging, SD layout, logging and launcher conventions.
