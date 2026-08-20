# RGSS-NX development state

Date: 2026-08-20

## Objective

Run RPG Maker XP / Pokémon Essentials compatible games natively under Nintendo
Switch Horizon/Atmosphère, without booting Android or Linux.

The project does not distribute Pokémon, Nintendo, RPG Maker RTP, commercial
fonts, game data, or third-party fangame assets. Users supply games they are
allowed to use.

## Upstream selected

RGSS-NX is based on the `libretro` work in `white-axe/mkxp-z`, proposed to
`mkxp-z/mkxp-z` as PR #255.

Pinned base head:

`650cb0888a07d0b5044e131160ddfa53feaf595b`

The upstream implementation already provides the libnx cross-build, static
libretro core, RetroArch/libnx frontend, virtual game/save/system filesystems,
preload/postload scripts, controller mappings and save-state support.

## M0

Complete in source:

- upstream pinned;
- asset-free RGSS graphics/input smoke test;
- Switch-only build workflow;
- basic runtime diagnostics.

Physical hardware validation remains pending.

## M1 - Essentials / Infinite Fusion 2 test candidate

Implemented in source:

- generic dedicated `RGSS-NX.nro` frontend with isolated RetroArch config;
- direct `RGSS-NX-IF2.nro` launcher targeting
  `sdmc:/switch/RGSS-NX/games/InfiniteFusion2/RGSSNX.mkxp.json`;
- per-game `RGSSNX.mkxp.json` profiles;
- automatic Ruby compatibility preloads (`ruby_classic_wrap`, `mkxp_wrap`,
  `win32_wrap`);
- RGSS-NX postload compatibility layer;
- safe Horizon handling for browser-launch requests;
- clean offline fallback when `HTTPLite` is not exposed by the Switch core;
- dedicated writable save/state/log directories on SD;
- Windows installer that copies the runtime payload, user-supplied game and
  compatibility files to the expected SD structure.

Infinite Fusion 2 is the first full game target because its public release has
both `Game.ini` and `mkxp.json`, so RGSS-NX can load the project directly rather
than emulating its Windows executable.

## Required next evidence

A real Switch test must establish, in order:

1. M1 NRO starts under Horizon.
2. Generic browser renders and accepts Joy-Con input.
3. Infinite Fusion 2 reaches title/menu through the direct launcher.
4. New-game overworld is controllable.
5. Battle flow works.
6. Save -> full exit -> reload persists.
7. Sprite extraction/download paths do not crash the runtime.

Any failing step should be fixed in the Ruby compatibility layer first. Engine
changes are reserved for faults below the game scripting layer.

## PSDK

PSDK is intentionally split into `PSDK-NX`. PSDK uses LiteRGSS2/SFML rather than
Enterbrain RGSS, so routing it through mkxp-z would be the wrong architecture.
See `docs/psdk-nx/PORTING_PLAN.md`.
