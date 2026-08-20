# RGSS-NX development state

Date: 2026-08-20

## Objective

Run RPG Maker XP / Pokémon Essentials compatible games under Nintendo Switch
Horizon/Atmosphère without booting Android or Linux. Game assets are always
supplied by the user and are never committed to RGSS-NX.

## Upstream base

RGSS-NX tracks the `white-axe/mkxp-z` `libretro` work proposed in upstream PR
#255, pinned initially at:

`650cb0888a07d0b5044e131160ddfa53feaf595b`

The upstream branch already provides the libnx cross-build, Switch libretro
core, VFS (`/Game`, `/Save`, `/System`), controller mapping, preload scripts,
save states and a RetroArch/libnx frontend build.

## M0

Source complete; physical validation pending:

- Switch-only build pipeline;
- asset-free RGSS graphics/input smoke test;
- diagnostics and SD helpers.

## M1 — usable RPG Maker / Essentials runtime

Implemented in source:

- `RGSS-NX.nro`: isolated generic frontend for supported RPG Maker content;
- `RGSS-NX-IF2.nro`: direct Infinite Fusion 2 launcher;
- independent `/switch/RGSS-NX/` games/save/state/log/system layout;
- deterministic core options bundled in RomFS;
- automatic `ruby_classic_wrap.rb`, `mkxp_wrap.rb`, upstream Win32 wrapper and
  RGSS-NX compatibility preload;
- compatibility preload lives in `/System`, so fangame files remain untouched;
- Horizon-safe handling of browser-launch calls;
- HTTP capability detection and clean offline fallback;
- Windows installer that copies the runtime and user game to the required SD
  paths without modifying `Game.ini` or `mkxp.json`.

Infinite Fusion 2 is the first full-game target because its current public
layout contains `Game.ini`, `mkxp.json`, `Data`, `Graphics`, `Audio` and `Fonts`.
The Windows executable/DLL are not required by the mkxp-z route.

## Required next evidence

A real Switch test must establish, in order:

1. NRO boots under Horizon.
2. Generic menu renders and receives Joy-Con input.
3. Infinite Fusion 2 reaches title/menu.
4. New-game overworld is controllable.
5. Battle flow works.
6. Save -> full exit -> reload persists.
7. Fusion/sprite extraction paths work without crashes.

Failures should be fixed first in the compatibility/packaging layer. Engine
changes are reserved for bugs that cannot be solved safely above mkxp-z.

## PSDK

PSDK is a parallel project named `PSDK-NX`, not an mkxp-z profile. Modern PSDK
uses LiteRGSS2/Ruby/SFML rather than Enterbrain RGSS. Its port can reuse the
proven libnx packaging and SD conventions, but needs a separate engine/backend.
See `docs/psdk-nx/PORTING_PLAN.md`.
