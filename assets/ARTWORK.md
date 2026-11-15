# Mochi artwork

Primary reference: the user's `Mochi Hub Pastel Branding Kit.png`. The four raster outputs were made with the built-in imagegen tool, not the fallback CLI. They are reference-derived recreations/extractions, not lossless crops. Each was visually reviewed before integration.

## Final prompt set

**Main logo:** Background-extraction edit of the attached kit. Produce only the top-left MAIN LOGO (HUB) as a clean transparent PNG. Preserve Mochi Hub lettering, white cat with pink bow, paws, hearts and dark outline. Remove the board background, section label and all other objects. Uncropped padding; no added text or mockup.

**Mascot:** Background-extraction edit. Extract only the small white cat head, pink bow and two front paws from the second LOGO VARIATIONS item. Preserve its shading, dark and white outlines and golden nose. Centered transparent cutout with clear padding, no text or other objects.

**Compact logo:** Background-extraction edit. Extract only the top-right ICON / LOADER LOGO: rounded pink square, winking white cat, bow, big pink M and paw. Preserve design and outlines, with transparency outside the rounded square. No label, board pieces, added words or mockup.

**Background:** Illustration for a wide 900 × 540 UI, inspired by the kit's banner: baby-pink moon, cream-pink clouds along the bottom, soft-black kitten seen from behind with a pink bow, cherry blossoms in upper corners, sparse hearts/stars. Cat near bottom-right; center and left mostly calm cream-pink space for legible controls. Airbrushed kawaii illustration using `#F8BBD5`, `#E88CB7`, `#FFF8FC`, `#211B23`. Light, airy, low contrast. No text, logos, UI, border, labels or dark maroon full backdrop.

## Runtime assets

The runtime uses the main wordmark during loading, compact mark in the sidebar/reopen control, mascot in small charms, dreamscape beneath both loader and main interface, three subtle paw accents, and a paw cursor. The outlined atlas covers eighteen stock icons in 64px cells, eight columns. Custom caller-supplied icons retain their original fallback behavior. Raster dimensions and PNG signatures are checked by the test runner.
