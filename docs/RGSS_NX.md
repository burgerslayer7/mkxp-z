# RGSS-NX bootstrap

Experimental Horizon/Atmosphère runtime work for RPG Maker XP / RGSS games,
based on the Nintendo Switch libretro work in mkxp-z PR #255.

## Current target

M0 is deliberately independent from Pokémon Infinite Fusion. The first proof
is an original, asset-free RGSS script that must render and receive controller
input on a real Switch. Only after that passes do we introduce Pokémon
Essentials and then a user-supplied Infinite Fusion installation.

## Upstream baseline

See `rgss-nx/upstream.lock`. The investigated branch already contains a libnx Meson
cross file and CI logic that builds an mkxp-z static libretro core, links it
into a RetroArch/libnx frontend and outputs an NRO.

## Files in this bootstrap

- `.github/workflows/rgss-nx-switch.yml` — focused M0 Switch build.
- `rgss-nx/smoke-test/` — original RGSS graphics/input test, no proprietary assets.
- `rgss-nx/compat/preload/rgss_nx_bootstrap.rb` — non-invasive runtime probe.
- `tools/rgss-nx/Prepare-SD.ps1` — prepares the expected M0 SD layout.
- `tools/rgss-nx/Inspect-Game.ps1` — read-only preflight inspection of a fangame folder.
- `docs/rgss-nx/` — state, roadmap and physical Switch test protocol.

## Repository strategy

RGSS-NX stays close to the `white-axe/mkxp-z` `libretro` branch initially so
engine/libnx issues can be fixed with small, reviewable changes instead of
maintaining a second engine copy.

No game data should ever be committed to the fork.
