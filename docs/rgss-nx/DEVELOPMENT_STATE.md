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

Pinned investigation head:

`650cb0888a07d0b5044e131160ddfa53feaf595b`

The upstream implementation already contains:

- Nintendo Switch / libnx Meson cross configuration;
- a Switch libretro static-core build;
- a RetroArch/libnx frontend build producing an NRO;
- virtual game/save/system filesystems for libretro;
- selectable preload/postload Ruby scripts;
- save-state support.

## M0 status

Done in this bootstrap:

- architecture and legal boundaries fixed;
- upstream commit pinned;
- asset-free RGSS smoke test created;
- non-invasive runtime probe preload created;
- dedicated Switch-only CI workflow drafted;
- SD preparation helper created.

Not yet validated on physical Switch:

- NRO boots under Horizon;
- OpenGL/libnx presentation works;
- audio works;
- Joy-Con input reaches RGSS `Input`;
- VFS paths are correct on Horizon;
- game save persistence survives restart.

## Compatibility policy

Do not patch individual fangames until the smoke test works. Then test a
minimal Pokémon Essentials project, followed by Infinite Fusion. Any
workaround should first live in a named preload/postload compatibility layer;
engine changes are reserved for problems that cannot safely be shimmed in Ruby.
