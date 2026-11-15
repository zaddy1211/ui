# Mochi artwork

Primary reference: the user's `Mochi Hub Pastel Branding Kit.png`. The three final illustration assets were made with the built-in imagegen tool, not the fallback CLI. They are reference-derived recreations/extractions, not lossless crops. Each was visually reviewed before integration. The old framed compact and glow-backed mascot variants were removed in v1.1.

## Final prompt set

**Main logo:** Background-extraction edit of the attached kit. Produce only the top-left MAIN LOGO (HUB) as a clean transparent PNG. Preserve Mochi Hub lettering, white cat with pink bow, paws, hearts and dark outline. Remove the board background, section label and all other objects. Uncropped padding; no added text or mockup.

**Unframed mark (v2):** Background-extraction edit of the v1 reference-derived cat mascot. Keep the same white kitty face, pink bow, little front paws, outlines, shading and golden nose. Remove diffuse glow, mist, drop shadow, rectangular or circular background and badge. Outside the silhouette is transparent. Fit the kitty tightly with a small even margin. This is an unframed 48px sidebar icon: crisp silhouette, readable bow, no lettering, M, frame or other objects. Square transparent canvas. This final image is saved as `mochi-mark-v2.png` so an older cached badge cannot be reused accidentally.

**Background:** Illustration for a wide 900 × 540 UI, inspired by the kit's banner: baby-pink moon, cream-pink clouds along the bottom, soft-black kitten seen from behind with a pink bow, cherry blossoms in upper corners, sparse hearts/stars. Cat near bottom-right; center and left mostly calm cream-pink space for legible controls. Airbrushed kawaii illustration using `#F8BBD5`, `#E88CB7`, `#FFF8FC`, `#211B23`. Light, airy, low contrast. No text, logos, UI, border, labels or dark maroon full backdrop.

## Runtime assets

The runtime uses the main wordmark for a standalone launch, then hands off to the unframed cat mark as the window expands. The same cat mark is used by the sidebar and draggable reopen control. The original dreamscape is now visible at nearly full strength behind glass surfaces, with three static paw accents and an optional paw cursor. Official Lucide SVGs supply the 32-slot atlas and paw cursor; see `icons/lucide/README.md` for source, pin and license. Other caller-supplied icons retain their original fallback behavior. Raster dimensions and PNG signatures are checked by the test runner.
