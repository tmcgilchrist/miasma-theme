# Changelog

All notable changes to miasma-theme are documented here. Versions follow
[Semantic Versioning](https://semver.org/).

## Unreleased

### Added
- `DESIGN.md` documenting semantic colour roles and the intentionally
  earth-toned palette (accent names like `blue` / `cyan` / `magenta` map
  to warm hues by design).
- `miasma-scale-headings` defcustom to scale outline / org / markdown
  headings above body text. Defaults to `t`.
- Explicit miasma-tuned faces for:
  - magit (branches, tags, hash, section headings)
  - flymake (wave underlines with miasma accents)
  - corfu (in-buffer completion popup)
  - vertico (minibuffer completion)
  - marginalia (annotations)
  - eglot (symbol highlight, mode-line, diagnostic tags)
  - tree-sitter-hl (function/method/type/parameter/property)
- `CHANGELOG.md` (this file).

## 0.1.0

### Added
- Initial release based on xero's miasma terminal theme.
- Built on `doom-themes` infrastructure.
- Options: `miasma-brighter-modeline`, `miasma-brighter-comments`,
  `miasma-comment-bg`, `miasma-padded-modeline`.
- Face tuning for doom-modeline, ivy, markdown, org, solaire-mode,
  LaTeX, elscreen, css/scss.
