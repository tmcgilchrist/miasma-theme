# Design Principles

Miasma is a dark theme built from muted earth tones — moss, bark, rust, amber,
and fog. It is inspired by xero's
[miasma terminal theme](https://terminalcolors.com/themes/miasma/default/) and
evokes a damp autumn forest rather than neon city lights.

## Palette is earth-toned, not rainbow

Accent slot names (`blue`, `cyan`, `magenta`) are kept for compatibility with
the Emacs / doom-themes face vocabulary, but the *hues* are deliberately warm:

| Slot      | Hex       | Actual hue        | Role                                 |
|-----------|-----------|-------------------|--------------------------------------|
| `red`     | `#685742` | muted brown       | errors, vc-deleted                   |
| `orange`  | `#b36d43` | rust              | constants, numbers, vc-modified      |
| `yellow`  | `#c9a554` | amber             | functions, warnings, highlights      |
| `green`   | `#5f875f` | moss              | strings, types, success, vc-added    |
| `blue`    | `#78824b` | olive (not blue)  | keywords, operators                  |
| `magenta` | `#bb7744` | burnt orange      | builtins, variables                  |
| `cyan`    | `#c9a554` | amber (= yellow)  | methods                              |

This is a feature, not a bug. When adding a face, pick the slot whose *role*
fits — do not reach for a colour because its name sounds right. If you want a
"blue" function name, miasma is the wrong theme.

## Semantic colour mapping

Each slot has a role that stays consistent across every face:

- **green** — strings, successful states, additions, types. The most
  "plant-like" tone; used where something is alive or correct.
- **yellow** — names you define (functions), warnings, the cursor-ish
  highlight. Draws the eye without shouting.
- **orange** — literal values (constants, numbers), modifications. Warmer
  than yellow, used for things that are fixed or changed.
- **blue (olive)** — control flow (keywords, operators). Recedes slightly so
  that names and values remain the visual focus.
- **magenta (burnt orange)** — builtins and variables. Sits between orange
  and red in warmth.
- **red** — errors, deletions. The most muted slot; miasma's red is closer
  to brown than crimson, so errors *look* serious without being alarming.
- **base5 / base6 (greys)** — comments, inactive UI, line numbers. Receding
  tones that layer without competing.
- **selection / region-bg (neutral dark grey, default `#333333`)** —
  backgrounds for the active region and for magit's section / diff
  selection highlights. Kept neutral on purpose: selection should signal
  "this is what you picked" without competing with accent colours already
  on the line. Retint either slot via `miasma-override-colors-alist`
  (e.g. `'((selection . "#3a2f22"))` for a warmer highlight).

When theming a new package, match the closest role. Consistency across
packages matters more than local visual variety.

## Restrained emphasis

- Use `:weight bold` only to signal structural importance (section headings,
  current selection, diagnostic severity). Never as default body weight.
- Use `:slant italic` for comments, docstrings, and contextual text.
- Avoid stacking attributes. One or two (colour + weight, colour + slant) is
  almost always enough.
- Avoid boxes and underlines unless they convey meaning (links, wave
  underlines for diagnostics).

## Readable contrast, not maximum contrast

The whole palette sits within a narrow luminance band on purpose: miasma is
meant to feel like fog, not spotlights. De-emphasised elements should
recede; primary text should be legible; nothing should shout. If a face
feels too loud, it probably is.

## Optional customisations

Users can tune miasma without forking:

- `miasma-brighter-modeline` — vivid mode-line background.
- `miasma-brighter-comments` — dark-cyan comments instead of grey.
- `miasma-comment-bg` — subtle background on comments.
- `miasma-padded-modeline` — extra padding around the mode-line.
- `miasma-scale-headings` — scale org/markdown/outline headings.

Custom options are set *before* the theme is loaded. Re-load the theme after
changing them.

## Theme what exists, don't invent decoration

Only set attributes that solve a problem. A foreground colour alone is
usually enough. Extra backgrounds, boxes, and underlines must earn their
place — miasma's aesthetic depends on *absence* as much as presence.
