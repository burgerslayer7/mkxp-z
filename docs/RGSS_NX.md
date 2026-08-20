# RGSS-NX

Experimental Horizon/Atmosphère runtime for RPG Maker XP/VX/VX Ace games,
focused first on Pokémon Essentials and Infinite Fusion 2.

RGSS-NX is built on the Nintendo Switch libretro work in mkxp-z PR #255. It
keeps the upstream engine close to its original design and adds Switch-specific
packaging, compatibility and launch behavior around it.

## Runtime layout

- `RGSS-NX.nro` — generic RPG Maker browser/frontend.
- `RGSS-NX-IF2.nro` — direct Infinite Fusion 2 launcher.
- `/switch/RGSS-NX/games/` — user-installed games.
- `/switch/RGSS-NX/system/` — runtime compatibility scripts/RTP/fonts.
- `/switch/RGSS-NX/saves/` — writable game saves.

Compatibility scripts are installed in the runtime system directory. RGSS-NX
does not rewrite a fangame's `Game.ini` or `mkxp.json`.

## PSDK

PSDK is intentionally handled as a separate `PSDK-NX` port because LiteRGSS2
is not an Enterbrain RGSS runtime. See `docs/psdk-nx/PORTING_PLAN.md`.

## Asset policy

No Pokémon, Nintendo, RPG Maker RTP, commercial fonts or third-party fangame
assets are distributed by this repository. Users supply their own game files.
