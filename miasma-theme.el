;;; miasma-theme.el --- A fog descends upon your editor -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2026 Tim McGilchrist
;;
;; Author: Tim McGilchrist <tim@mcgilchrist.com>
;; Created: October 28, 2024
;; Version: 0.2.0
;; Keywords: faces, theme
;; Homepage:
;; Package-Requires: ((emacs "27.1"))
;;
;;; Commentary:
;;
;; Miasma theme - A dark colour scheme inspired by the woods.
;; Based on the Miasma terminal theme by xero
;; https://terminalcolors.com/themes/miasma/default/
;;
;; See DESIGN.md for the palette's semantic roles.  Accent slot names
;; (blue, cyan, magenta) are kept for compatibility with Emacs face
;; vocabulary, but the hues are deliberately warm earth tones.
;;
;;; Code:

(require 'cl-lib)

;;
;;; Options

(defgroup miasma-theme nil
  "Options for the `miasma' theme."
  :group 'faces
  :prefix "miasma-")

(defcustom miasma-brighter-modeline nil
  "If non-nil, use a more vivid background for the mode-line."
  :group 'miasma-theme
  :type 'boolean)

(defcustom miasma-brighter-comments nil
  "If non-nil, highlight comments in a brighter colour."
  :group 'miasma-theme
  :type 'boolean)

(defcustom miasma-comment-bg miasma-brighter-comments
  "If non-nil, give comments a subtle background to improve legibility."
  :group 'miasma-theme
  :type 'boolean)

(defcustom miasma-padded-modeline nil
  "If non-nil, add padding inside the mode-line.
A positive integer sets the exact pixel width; t defaults to 4."
  :group 'miasma-theme
  :type '(choice integer boolean))

(defcustom miasma-scale-headings t
  "If non-nil, scale outline / org / markdown headings above body text.
Set before loading the theme."
  :group 'miasma-theme
  :type 'boolean)

(defcustom miasma-override-colors-alist '()
  "Alist of colour overrides.
Each entry is (NAME . HEX) where NAME matches a key in
`miasma-colors-alist'.  Overrides take precedence over the defaults;
changes take effect next time the theme is loaded."
  :group 'miasma-theme
  :type '(alist :key-type symbol :value-type string))

;;
;;; Colour helpers

(defun miasma--hex-to-rgb (hex)
  "Parse HEX string \"#rrggbb\" into a list (R G B) of floats in [0,1]."
  (list (/ (string-to-number (substring hex 1 3) 16) 255.0)
        (/ (string-to-number (substring hex 3 5) 16) 255.0)
        (/ (string-to-number (substring hex 5 7) 16) 255.0)))

(defun miasma--rgb-to-hex (r g b)
  "Format floats R G B in [0,1] as \"#rrggbb\"."
  (format "#%02x%02x%02x"
          (round (* 255 (max 0.0 (min 1.0 r))))
          (round (* 255 (max 0.0 (min 1.0 g))))
          (round (* 255 (max 0.0 (min 1.0 b))))))

(defun miasma-darken (hex fraction)
  "Return HEX darkened toward black by FRACTION in [0,1]."
  (pcase-let ((`(,r ,g ,b) (miasma--hex-to-rgb hex)))
    (miasma--rgb-to-hex (* r (- 1 fraction))
                        (* g (- 1 fraction))
                        (* b (- 1 fraction)))))

(defun miasma-lighten (hex fraction)
  "Return HEX lightened toward white by FRACTION in [0,1]."
  (pcase-let ((`(,r ,g ,b) (miasma--hex-to-rgb hex)))
    (miasma--rgb-to-hex (+ r (* (- 1 r) fraction))
                        (+ g (* (- 1 g) fraction))
                        (+ b (* (- 1 b) fraction)))))

;;
;;; Palette

(defconst miasma-colors-alist
  '((bg         . "#222222")
    (bg-alt     . "#1a1a1a")
    (base0      . "#0d0d0d")
    (base1      . "#1a1a1a")
    (base2      . "#222222")
    (base3      . "#333333")
    (base4      . "#444444")
    (base5      . "#555555")
    (base6      . "#666666")
    (base7      . "#888888")
    (base8      . "#aaaaaa")
    (fg         . "#c2c2b0")
    (fg-alt     . "#b0b09e")
    (red        . "#685742")
    (orange     . "#b36d43")
    (green      . "#5f875f")
    (teal       . "#5f875f")
    (yellow     . "#c9a554")
    (blue       . "#78824b")
    (dark-blue  . "#6a7444")
    (magenta    . "#bb7744")
    (violet     . "#bb7744")
    (cyan       . "#c9a554")
    (dark-cyan  . "#b39448"))
  "Miasma colour palette — hex strings keyed by role.
See DESIGN.md for the semantic meaning of each slot.")

;;
;;; Theme

(deftheme miasma
  "A dark theme inspired by the woods — fog descends upon your editor.")

(let* ((colors (append miasma-override-colors-alist miasma-colors-alist))
       (bg         (alist-get 'bg colors))
       (bg-alt     (alist-get 'bg-alt colors))
       (base0      (alist-get 'base0 colors))
       (base1      (alist-get 'base1 colors))
       (base2      (alist-get 'base2 colors))
       (base3      (alist-get 'base3 colors))
       (base4      (alist-get 'base4 colors))
       (base5      (alist-get 'base5 colors))
       (base6      (alist-get 'base6 colors))
       (base7      (alist-get 'base7 colors))
       (base8      (alist-get 'base8 colors))
       (fg         (alist-get 'fg colors))
       (fg-alt     (alist-get 'fg-alt colors))
       (red        (alist-get 'red colors))
       (orange     (alist-get 'orange colors))
       (green      (alist-get 'green colors))
       (teal       (alist-get 'teal colors))
       (yellow     (alist-get 'yellow colors))
       (blue       (alist-get 'blue colors))
       (magenta    (alist-get 'magenta colors))
       (cyan       (alist-get 'cyan colors))
       (dark-cyan  (alist-get 'dark-cyan colors))

       ;; semantic roles
       (highlight  yellow)
       (region     base3)
       (vertical-bar (miasma-darken base1 0.1))
       (comments   (if miasma-brighter-comments dark-cyan base6))
       (doc-comments (miasma-lighten (if miasma-brighter-comments dark-cyan base6) 0.25))

       ;; modeline
       (-bright miasma-brighter-modeline)
       (-pad (cond ((integerp miasma-padded-modeline) miasma-padded-modeline)
                   (miasma-padded-modeline 4)))
       (modeline-fg      fg)
       (modeline-fg-alt  base5)
       (modeline-bg      (if -bright (miasma-darken blue 0.475)
                           (miasma-darken bg-alt 0.15)))
       (modeline-bg-alt  (if -bright (miasma-darken blue 0.45)
                           (miasma-darken bg-alt 0.10)))
       (modeline-bg-inactive     bg-alt)
       (modeline-bg-inactive-alt (miasma-darken bg-alt 0.10))

       ;; heading sizes
       (h1 (if miasma-scale-headings 1.50 1.0))
       (h2 (if miasma-scale-headings 1.30 1.0))
       (h3 (if miasma-scale-headings 1.20 1.0))
       (h4 (if miasma-scale-headings 1.10 1.0))
       (h5 (if miasma-scale-headings 1.05 1.0)))

  (custom-theme-set-faces
   'miasma

;;;; basic faces
   `(default             ((t (:background ,bg :foreground ,fg))))
   `(cursor              ((t (:background ,fg))))
   `(fringe              ((t (:background ,bg :foreground ,base5))))
   `(vertical-border     ((t (:foreground ,vertical-bar))))
   `(window-divider      ((t (:foreground ,vertical-bar))))
   `(window-divider-first-pixel ((t (:foreground ,vertical-bar))))
   `(window-divider-last-pixel  ((t (:foreground ,vertical-bar))))
   `(region              ((t (:background ,region :extend t))))
   `(secondary-selection ((t (:background ,base3 :extend t))))
   `(highlight           ((t (:background ,base3 :foreground ,fg))))
   `(hl-line             ((t (:background ,base2 :extend t))))
   `(lazy-highlight      ((t (:background ,base3 :foreground ,fg :weight bold))))
   `(match               ((t (:foreground ,green :weight bold))))
   `(shadow              ((t (:foreground ,base6))))
   `(trailing-whitespace ((t (:background ,red))))
   `(link                ((t (:foreground ,yellow :underline t))))
   `(link-visited        ((t (:foreground ,magenta :underline t))))
   `(error               ((t (:foreground ,red :weight bold))))
   `(warning             ((t (:foreground ,yellow :weight bold))))
   `(success             ((t (:foreground ,green :weight bold))))
   `(minibuffer-prompt   ((t (:foreground ,yellow))))
   `(tooltip             ((t (:background ,bg-alt :foreground ,fg))))
   `(escape-glyph        ((t (:foreground ,cyan))))
   `(homoglyph           ((t (:foreground ,cyan))))
   `(header-line         ((t (:background ,bg-alt :foreground ,fg))))
   `(fill-column-indicator ((t (:foreground ,base3))))
   `(widget-field        ((t (:background ,base3 :extend t))))

;;;; line numbers
   `(line-number              ((t (:background ,bg :foreground ,base4))))
   `(line-number-current-line ((t (:background ,bg :foreground ,fg :weight bold))))

;;;; mode line
   `(mode-line
     ((t (:background ,modeline-bg :foreground ,modeline-fg
          ,@(when -pad `(:box (:line-width ,-pad :color ,modeline-bg)))))))
   `(mode-line-inactive
     ((t (:background ,modeline-bg-inactive :foreground ,modeline-fg-alt
          ,@(when -pad `(:box (:line-width ,-pad :color ,modeline-bg-inactive)))))))
   `(mode-line-emphasis ((t (:foreground ,(if -bright base8 highlight)))))
   `(mode-line-buffer-id ((t (:foreground ,fg :weight bold))))
   `(mode-line-highlight ((t (:foreground ,yellow))))

;;;; font-lock
   `(font-lock-builtin-face              ((t (:foreground ,magenta))))
   `(font-lock-comment-face
     ((t (:foreground ,comments :slant italic
          ,@(when miasma-comment-bg `(:background ,(miasma-lighten bg 0.05)))))))
   `(font-lock-comment-delimiter-face    ((t (:foreground ,comments :slant italic))))
   `(font-lock-constant-face             ((t (:foreground ,orange))))
   `(font-lock-doc-face                  ((t (:foreground ,doc-comments :slant italic))))
   `(font-lock-doc-markup-face           ((t (:foreground ,base6))))
   `(font-lock-function-name-face        ((t (:foreground ,yellow))))
   `(font-lock-function-call-face        ((t (:foreground ,yellow))))
   `(font-lock-keyword-face              ((t (:foreground ,blue))))
   `(font-lock-negation-char-face        ((t (:foreground ,red))))
   `(font-lock-number-face               ((t (:foreground ,orange))))
   `(font-lock-operator-face             ((t (:foreground ,blue))))
   `(font-lock-preprocessor-face         ((t (:foreground ,teal))))
   `(font-lock-property-name-face        ((t (:foreground ,orange))))
   `(font-lock-property-use-face         ((t (:foreground ,orange))))
   `(font-lock-regexp-grouping-construct ((t (:foreground ,yellow :weight bold))))
   `(font-lock-regexp-grouping-backslash ((t (:foreground ,yellow :weight bold))))
   `(font-lock-string-face               ((t (:foreground ,green))))
   `(font-lock-type-face                 ((t (:foreground ,green))))
   `(font-lock-variable-name-face        ((t (:foreground ,(miasma-lighten magenta 0.4)))))
   `(font-lock-variable-use-face         ((t (:foreground ,(miasma-lighten magenta 0.4)))))
   `(font-lock-warning-face              ((t (:foreground ,yellow :weight bold))))
   `(font-lock-bracket-face              ((t (:foreground ,fg-alt))))
   `(font-lock-delimiter-face            ((t (:foreground ,fg-alt))))
   `(font-lock-escape-face               ((t (:foreground ,cyan))))
   `(font-lock-misc-punctuation-face     ((t (:foreground ,fg-alt))))

;;;; isearch / replace / paren
   `(isearch              ((t (:background ,yellow :foreground ,bg :weight bold))))
   `(isearch-fail         ((t (:background ,base3 :foreground ,red))))
   `(isearch-group-1      ((t (:background ,blue  :foreground ,bg))))
   `(isearch-group-2      ((t (:background ,green :foreground ,bg))))
   `(query-replace        ((t (:background ,orange :foreground ,bg :weight bold))))
   `(show-paren-match     ((t (:background ,base4 :foreground ,yellow :weight bold))))
   `(show-paren-match-expression ((t (:background ,base3))))
   `(show-paren-mismatch  ((t (:background ,red :foreground ,bg :weight bold))))

;;;; completions (built-in)
   `(completions-annotations      ((t (:foreground ,comments))))
   `(completions-common-part      ((t (:foreground ,yellow :weight bold))))
   `(completions-first-difference ((t (:foreground ,orange))))
   `(completions-highlight        ((t (:background ,base3))))
   `(completions-group-title      ((t (:foreground ,blue :weight bold :slant italic))))
   `(completions-group-separator  ((t (:foreground ,comments :strike-through t))))

;;;; compilation
   `(compilation-error             ((t (:foreground ,red :weight bold))))
   `(compilation-warning           ((t (:foreground ,yellow :weight bold))))
   `(compilation-info              ((t (:foreground ,green))))
   `(compilation-mode-line-exit    ((t (:foreground ,green :weight bold))))
   `(compilation-mode-line-fail    ((t (:foreground ,red :weight bold))))
   `(compilation-mode-line-run     ((t (:foreground ,yellow :weight bold))))
   `(compilation-line-number       ((t (:foreground ,base6))))
   `(compilation-column-number     ((t (:foreground ,base6))))

;;;; diff / ediff
   `(diff-added            ((t (:foreground ,green :background ,(miasma-darken green 0.7) :extend t))))
   `(diff-removed          ((t (:foreground ,red   :background ,(miasma-darken red 0.5)   :extend t))))
   `(diff-changed          ((t (:foreground ,orange :background ,(miasma-darken orange 0.7) :extend t))))
   `(diff-refine-added     ((t (:foreground ,green :background ,(miasma-darken green 0.5) :weight bold :extend t))))
   `(diff-refine-removed   ((t (:foreground ,red   :background ,(miasma-darken red 0.3)   :weight bold :extend t))))
   `(diff-refine-changed   ((t (:foreground ,orange :background ,(miasma-darken orange 0.5) :weight bold :extend t))))
   `(diff-header           ((t (:foreground ,fg-alt :background ,bg-alt :extend t))))
   `(diff-file-header      ((t (:foreground ,yellow :background ,bg-alt :weight bold :extend t))))
   `(diff-hunk-header      ((t (:foreground ,blue   :background ,bg-alt :extend t))))
   `(diff-indicator-added   ((t (:foreground ,green))))
   `(diff-indicator-removed ((t (:foreground ,red))))
   `(diff-indicator-changed ((t (:foreground ,orange))))
   `(ediff-current-diff-A  ((t (:background ,(miasma-darken red 0.5) :extend t))))
   `(ediff-current-diff-B  ((t (:background ,(miasma-darken green 0.7) :extend t))))
   `(ediff-current-diff-C  ((t (:background ,(miasma-darken orange 0.7) :extend t))))
   `(ediff-even-diff-A     ((t (:background ,base2 :extend t))))
   `(ediff-even-diff-B     ((t (:background ,base2 :extend t))))
   `(ediff-even-diff-C     ((t (:background ,base2 :extend t))))
   `(ediff-odd-diff-A      ((t (:background ,base1 :extend t))))
   `(ediff-odd-diff-B      ((t (:background ,base1 :extend t))))
   `(ediff-odd-diff-C      ((t (:background ,base1 :extend t))))

;;;; dired
   `(dired-directory     ((t (:foreground ,blue :weight bold))))
   `(dired-symlink       ((t (:foreground ,cyan))))
   `(dired-header        ((t (:foreground ,magenta :weight bold))))
   `(dired-flagged       ((t (:foreground ,red))))
   `(dired-marked        ((t (:foreground ,magenta :weight bold))))
   `(dired-mark          ((t (:foreground ,orange :weight bold))))
   `(dired-ignored       ((t (:foreground ,comments))))
   `(dired-warning       ((t (:foreground ,yellow :weight bold))))
   `(dired-broken-symlink ((t (:foreground ,red :weight bold))))
   `(dired-perm-write    ((t (:foreground ,fg-alt))))

;;;; outline (and therefore org-level-N / markdown-header-N by inheritance)
   `(outline-1 ((t (:foreground ,red     :weight bold :height ,h2))))
   `(outline-2 ((t (:foreground ,orange  :weight bold :height ,h3))))
   `(outline-3 ((t (:foreground ,yellow  :weight bold :height ,h4))))
   `(outline-4 ((t (:foreground ,green   :weight bold :height ,h5))))
   `(outline-5 ((t (:foreground ,blue    :weight bold))))
   `(outline-6 ((t (:foreground ,magenta :weight bold))))
   `(outline-7 ((t (:foreground ,cyan    :weight bold))))
   `(outline-8 ((t (:foreground ,fg-alt  :weight bold))))

;;;; org-mode
   `(org-document-title         ((t (:foreground ,red :weight bold :height ,h1))))
   `(org-document-info          ((t (:foreground ,fg-alt))))
   `(org-document-info-keyword  ((t (:foreground ,comments))))
   `(org-hide                   ((t (:foreground ,bg))))
   `(org-ellipsis               ((t (:foreground ,comments :underline nil))))
   `(org-archived               ((t (:foreground ,comments))))
   `(org-date                   ((t (:foreground ,cyan :underline t))))
   `(org-tag                    ((t (:foreground ,base7))))
   `(org-todo                   ((t (:foreground ,orange :weight bold))))
   `(org-done                   ((t (:foreground ,green :weight bold))))
   `(org-headline-done          ((t (:foreground ,comments))))
   `(org-checkbox               ((t (:foreground ,yellow :weight bold))))
   `(org-checkbox-statistics-todo ((t (:foreground ,orange))))
   `(org-checkbox-statistics-done ((t (:foreground ,green))))
   `(org-drawer                 ((t (:foreground ,comments))))
   `(org-footnote               ((t (:foreground ,teal))))
   `(org-formula                ((t (:foreground ,orange))))
   `(org-code                   ((t (:foreground ,teal))))
   `(org-verbatim               ((t (:foreground ,green))))
   `(org-block                  ((t (:background ,bg-alt :extend t))))
   `(org-block-begin-line       ((t (:foreground ,comments :background ,bg-alt :extend t :slant italic))))
   `(org-block-end-line         ((t (:inherit org-block-begin-line))))
   `(org-table                  ((t (:foreground ,fg-alt))))
   `(org-meta-line              ((t (:foreground ,comments))))
   `(org-special-keyword        ((t (:foreground ,magenta))))
   `(org-link                   ((t (:foreground ,yellow :underline t))))
   `(org-priority               ((t (:foreground ,red :weight bold))))
   `(org-quote                  ((t (:background ,bg-alt :slant italic :extend t))))
   `(org-agenda-date            ((t (:foreground ,blue))))
   `(org-agenda-date-today      ((t (:foreground ,yellow :weight bold))))
   `(org-agenda-date-weekend    ((t (:foreground ,comments))))
   `(org-agenda-structure       ((t (:foreground ,magenta :weight bold))))

;;;; markdown
   `(markdown-markup-face       ((t (:foreground ,base5))))
   `(markdown-code-face         ((t (:background ,(miasma-lighten base3 0.05) :extend t))))
   `(markdown-inline-code-face  ((t (:foreground ,teal))))
   `(markdown-link-face         ((t (:foreground ,yellow))))
   `(markdown-url-face          ((t (:foreground ,cyan :underline t))))
   `(markdown-metadata-key-face ((t (:foreground ,magenta))))
   `(markdown-metadata-value-face ((t (:foreground ,fg-alt))))
   `(markdown-blockquote-face   ((t (:foreground ,base7 :slant italic))))
   `(markdown-pre-face          ((t (:foreground ,green))))

;;;; magit
   `(magit-section-heading          ((t (:foreground ,yellow :weight bold))))
   `(magit-section-highlight        ((t (:background ,base2 :extend t))))
   `(magit-diff-file-heading        ((t (:foreground ,fg :weight bold))))
   `(magit-diff-file-heading-highlight ((t (:background ,base2 :weight bold :extend t))))
   `(magit-diff-hunk-heading        ((t (:foreground ,blue :background ,bg-alt :extend t))))
   `(magit-diff-hunk-heading-highlight ((t (:foreground ,blue :background ,base2 :weight bold :extend t))))
   `(magit-diff-added               ((t (:foreground ,green :background ,(miasma-darken green 0.7) :extend t))))
   `(magit-diff-added-highlight     ((t (:foreground ,green :background ,(miasma-darken green 0.5) :extend t))))
   `(magit-diff-removed             ((t (:foreground ,red :background ,(miasma-darken red 0.5) :extend t))))
   `(magit-diff-removed-highlight   ((t (:foreground ,red :background ,(miasma-darken red 0.3) :extend t))))
   `(magit-diff-context             ((t (:foreground ,fg-alt :extend t))))
   `(magit-diff-context-highlight   ((t (:foreground ,fg :background ,base2 :extend t))))
   `(magit-branch-local             ((t (:foreground ,blue))))
   `(magit-branch-remote            ((t (:foreground ,green))))
   `(magit-branch-current           ((t (:foreground ,yellow :weight bold :box t))))
   `(magit-tag                      ((t (:foreground ,orange))))
   `(magit-hash                     ((t (:foreground ,base6))))
   `(magit-log-author               ((t (:foreground ,magenta))))
   `(magit-log-date                 ((t (:foreground ,base7))))
   `(magit-log-graph                ((t (:foreground ,comments))))
   `(magit-process-ok               ((t (:foreground ,green :weight bold))))
   `(magit-process-ng               ((t (:foreground ,red :weight bold))))
   `(magit-signature-good           ((t (:foreground ,green))))
   `(magit-signature-bad            ((t (:foreground ,red :weight bold))))

;;;; flymake / flycheck
   `(flymake-error    ((t (:underline (:style wave :color ,red)))))
   `(flymake-warning  ((t (:underline (:style wave :color ,yellow)))))
   `(flymake-note     ((t (:underline (:style wave :color ,green)))))
   `(flycheck-error   ((t (:underline (:style wave :color ,red)))))
   `(flycheck-warning ((t (:underline (:style wave :color ,yellow)))))
   `(flycheck-info    ((t (:underline (:style wave :color ,green)))))
   `(flycheck-fringe-error    ((t (:foreground ,red))))
   `(flycheck-fringe-warning  ((t (:foreground ,yellow))))
   `(flycheck-fringe-info     ((t (:foreground ,green))))

;;;; corfu
   `(corfu-default     ((t (:background ,bg-alt :foreground ,fg))))
   `(corfu-current     ((t (:background ,base3  :foreground ,fg))))
   `(corfu-bar         ((t (:background ,base5))))
   `(corfu-border      ((t (:background ,base3))))
   `(corfu-annotations ((t (:foreground ,comments :slant italic))))

;;;; vertico
   `(vertico-current         ((t (:background ,base3 :extend t))))
   `(vertico-group-title     ((t (:foreground ,yellow :weight bold :slant italic))))
   `(vertico-group-separator ((t (:foreground ,base5 :strike-through t))))

;;;; marginalia
   `(marginalia-key           ((t (:foreground ,yellow))))
   `(marginalia-type          ((t (:foreground ,magenta))))
   `(marginalia-documentation ((t (:foreground ,comments :slant italic))))
   `(marginalia-string        ((t (:foreground ,green))))
   `(marginalia-number        ((t (:foreground ,orange))))
   `(marginalia-file-name     ((t (:foreground ,fg))))
   `(marginalia-file-priv-dir ((t (:foreground ,blue :weight bold))))
   `(marginalia-symbol        ((t (:foreground ,magenta))))
   `(marginalia-date          ((t (:foreground ,base7))))

;;;; eglot
   `(eglot-highlight-symbol-face ((t (:background ,base3 :weight bold))))
   `(eglot-mode-line             ((t (:inherit mode-line-emphasis))))
   `(eglot-diagnostic-tag-unnecessary-face ((t (:inherit shadow))))
   `(eglot-diagnostic-tag-deprecated-face  ((t (:strike-through t))))

;;;; tree-sitter-hl
   `(tree-sitter-hl-face:function.call  ((t (:foreground ,yellow))))
   `(tree-sitter-hl-face:method.call    ((t (:foreground ,cyan))))
   `(tree-sitter-hl-face:type.builtin   ((t (:foreground ,green))))
   `(tree-sitter-hl-face:variable.parameter ((t (:foreground ,(miasma-lighten magenta 0.2)))))
   `(tree-sitter-hl-face:property       ((t (:foreground ,orange))))

;;;; ivy
   `(ivy-current-match ((t (:background ,base3 :distant-foreground ,base0))))
   `(ivy-minibuffer-match-face-1 ((t (:foreground ,base6))))
   `(ivy-minibuffer-match-face-2 ((t (:foreground ,yellow :weight bold))))
   `(ivy-minibuffer-match-face-3 ((t (:foreground ,green :weight bold))))
   `(ivy-minibuffer-match-face-4 ((t (:foreground ,orange :weight bold))))

;;;; doom-modeline
   `(doom-modeline-bar
     ((t (:background ,(if -bright modeline-bg yellow)))))
   `(doom-modeline-buffer-file       ((t (:inherit mode-line-buffer-id :weight bold))))
   `(doom-modeline-buffer-path       ((t (:inherit mode-line-emphasis :weight bold))))
   `(doom-modeline-buffer-project-root ((t (:foreground ,green :weight bold))))
   `(doom-modeline-buffer-modified   ((t (:foreground ,orange :weight bold))))
   `(doom-modeline-info              ((t (:foreground ,green))))
   `(doom-modeline-warning           ((t (:foreground ,yellow))))
   `(doom-modeline-urgent            ((t (:foreground ,red))))

;;;; solaire-mode
   `(solaire-default-face            ((t (:background ,bg-alt :foreground ,fg))))
   `(solaire-hl-line-face            ((t (:background ,base2 :extend t))))
   `(solaire-mode-line-face
     ((t (:inherit mode-line :background ,modeline-bg-alt
          ,@(when -pad `(:box (:line-width ,-pad :color ,modeline-bg-alt)))))))
   `(solaire-mode-line-inactive-face
     ((t (:inherit mode-line-inactive :background ,modeline-bg-inactive-alt
          ,@(when -pad `(:box (:line-width ,-pad :color ,modeline-bg-inactive-alt)))))))

;;;; LaTeX
   `(font-latex-math-face ((t (:foreground ,green))))

;;;; css / scss
   `(css-proprietary-property ((t (:foreground ,orange))))
   `(css-property             ((t (:foreground ,green))))
   `(css-selector             ((t (:foreground ,blue))))

;;;; ansi-color
   `(ansi-color-black          ((t (:foreground ,base1 :background ,base1))))
   `(ansi-color-red            ((t (:foreground ,red   :background ,red))))
   `(ansi-color-green          ((t (:foreground ,green :background ,green))))
   `(ansi-color-yellow         ((t (:foreground ,yellow :background ,yellow))))
   `(ansi-color-blue           ((t (:foreground ,blue  :background ,blue))))
   `(ansi-color-magenta        ((t (:foreground ,magenta :background ,magenta))))
   `(ansi-color-cyan           ((t (:foreground ,cyan  :background ,cyan))))
   `(ansi-color-white          ((t (:foreground ,base8 :background ,base8))))
   `(ansi-color-bright-black   ((t (:foreground ,base4 :background ,base4))))
   `(ansi-color-bright-red     ((t (:foreground ,orange :background ,orange))))
   `(ansi-color-bright-green   ((t (:foreground ,teal  :background ,teal))))
   `(ansi-color-bright-yellow  ((t (:foreground ,yellow :background ,yellow))))
   `(ansi-color-bright-blue    ((t (:foreground ,blue  :background ,blue))))
   `(ansi-color-bright-magenta ((t (:foreground ,magenta :background ,magenta))))
   `(ansi-color-bright-cyan    ((t (:foreground ,cyan  :background ,cyan))))
   `(ansi-color-bright-white   ((t (:foreground ,fg    :background ,fg))))))

;;
;;; Autoload

;;;###autoload
(when load-file-name
  (add-to-list 'custom-theme-load-path
               (file-name-as-directory (file-name-directory load-file-name))))

(provide-theme 'miasma)
(provide 'miasma-theme)

;;; miasma-theme.el ends here
