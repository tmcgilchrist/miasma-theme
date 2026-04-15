# Changelog

All notable changes to miasma-theme are documented here. Versions follow
[Semantic Versioning](https://semver.org/).

## 0.1.0

### Added
- Initial release based on xero's miasma terminal theme.
- Built on `doom-themes` infrastructure.
- Options: `miasma-brighter-modeline`, `miasma-brighter-comments`,
  `miasma-comment-bg`, `miasma-padded-modeline`.
- Face tuning for doom-modeline, ivy, markdown, org, solaire-mode,
  LaTeX, elscreen, css/scss.
- `DESIGN.md` documenting semantic colour roles and the intentionally
  earth-toned palette (accent names like `blue` / `cyan` / `magenta` map
  to warm hues by design).
- `miasma-scale-headings` defcustom to scale outline / org / markdown
  headings above body text. Defaults to `t`.
- `miasma-override-colors-alist` defcustom — tweak individual palette
  entries without forking.
- Public `miasma-colors-alist` palette constant plus `miasma-darken` /
  `miasma-lighten` helpers.
- Explicit miasma-tuned faces for: org (levels, todo/done, blocks,
  tables, agenda), markdown, magit (sections, branches, diff, hunks),
  flymake / flycheck, corfu, vertico, marginalia, eglot, tree-sitter-hl,
  ediff, dired, compilation, isearch, ansi-color, doom-modeline,
  solaire-mode, LaTeX, CSS/SCSS.
- `CHANGELOG.md` (this file).

### Changed
- **Breaking:** dropped the `doom-themes` dependency. Miasma is now
  a plain `deftheme` and works in vanilla Emacs 27.1+. Users who relied
  on doom-themes' blanket face coverage for unthemed packages should
  file an issue for any regressions.
- Palette moved out of the `def-doom-theme` macro into a top-level
  `defconst`, so face definitions can be shared between variants in
  the future.
- `miasma-padded-modeline` default is now `nil` (previously inherited
  from `doom-themes-padded-modeline`).

### Removed
- Dependency on `doom-themes`. `Package-Requires` now lists only
  `(emacs "27.1")`.
- `no-byte-compile: t` file-local variable — the theme now
  byte-compiles cleanly with `byte-compile-error-on-warn` enabled.

### Infrastructure
- GitHub Actions CI (`.github/workflows/ci.yml`) byte-compiles and
  loads the theme across Emacs 27.1, 28.2, 29.4, 30.1, and snapshot.

### Fixed
- Magit selection highlights (`magit-section-heading-selection`,
  `magit-diff-file-heading-selection`, `magit-diff-hunk-heading-selection`)
  no longer fall back to magit's salmon defaults. They now use a neutral
  grey that matches the rest of Emacs's region highlighting. New palette
  slots `selection` and `region-bg` (both default `#333333`) let users
  retint via `miasma-override-colors-alist`.

### Docs
- `README.md` documenting installation, customisation, supported
  packages, and the complementary terminal theme.
