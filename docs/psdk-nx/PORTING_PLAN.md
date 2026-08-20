# PSDK-NX porting plan

PSDK is tracked alongside RGSS-NX but is a separate runtime target.

## Why it cannot be routed through RGSS-NX

Current Pokémon SDK / LiteRGSS2 architecture does not use Enterbrain RGSS as
its game runtime. PSDK uses Ruby plus LiteRGSS2, whose native rendering stack is
based on SFML. A mkxp-z compatibility shim would therefore be the wrong layer.

## Target architecture

```text
Horizon / Atmosphère
  -> PSDK-NX.nro
     -> Ruby runtime
     -> LiteRGSS2-NX
        -> Switch graphics/input/audio backend
     -> user supplied PSDK game
```

No game data is to be bundled in this repository.

## Milestones

### P0 - source/build audit

- Pin current PSDK and LiteRGSS2 revisions.
- Inventory LiteRGSS2 use of SFML, OpenGL, windowing, threading, filesystem and
  audio.
- Separate functionality needed at runtime from editor/export tooling.

### P1 - LiteRGSS2 graphics/input proof

- Cross-compile the smallest LiteRGSS2 subset for devkitA64/libnx.
- Prefer an SDL2/libnx compatibility backend rather than trying to reproduce a
  full desktop SFML environment when practical.
- Render one sprite and receive Joy-Con input.

### P2 - Ruby bridge

- Bring up the Ruby version required by the selected PSDK revision on AArch64.
- Bind the LiteRGSS2 API used by a minimal PSDK scene.
- Establish writable `sdmc:/switch/PSDK-NX/` save/config paths.

### P3 - media/filesystem

- Image/font loading.
- Music and sound effects.
- Case-insensitive asset resolution where PSDK projects assume desktop paths.
- Error logging suitable for hardware iteration.

### P4 - PSDK game boot

- Load a clean PSDK sample/project supplied by the user.
- Reach map gameplay, menu, battle, save and reload.

### P5 - launcher integration

- Generic game browser.
- Direct per-game launcher entries for SwitchU/Tico-style frontends.

## Current priority

RGSS-NX M1 / Infinite Fusion 2 is the hardware test target first. PSDK-NX can
then reuse the proven Switch packaging, SD layout, logging and launcher work,
while implementing its separate native engine layer.
