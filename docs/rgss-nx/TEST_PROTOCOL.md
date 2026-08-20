# M0 test protocol

## Expected SD layout

```text
/switch/RGSS-NX/RGSS-NX.nro
/rgss-nx/smoke-test/mkxp.json
/rgss-nx/smoke-test/smoke.rb
/retroarch/system/mkxp-z/Scripts/Preload/rgss_nx_bootstrap.rb
```

## Test

1. Launch `RGSS-NX.nro` through hbmenu using title takeover/full-memory mode.
2. Load `/rgss-nx/smoke-test/mkxp.json`.
3. Expected: dark 640x480 screen with `RGSS-NX M0` text and blue borders.
4. Press the controller input mapped to RGSS `C` / Confirm.
5. Expected: the panel changes state and shows `INPUT: OK`.
6. Quit from the frontend menu.
7. Preserve the complete log for the next compatibility pass.

If text is missing but the rectangles render, record that separately: it means
the graphics path works and the next issue is font discovery rather than a full
engine boot failure.
