;;; miasma-theme.el --- A fog descends upon your editor -*- lexical-binding: t; no-byte-compile: t; -*-
;;
;; Copyright (C) 2024
;;
;; Author: Tim McGilchrist
;; Created: October 28, 2024
;; Version: 0.1.0
;; Keywords: faces, theme
;; Homepage:
;; Package-Requires: ((emacs "25.1") (cl-lib "0.5"))
;;
;;; Commentary:
;;
;; Miasma theme - A dark color scheme inspired by the woods
;; Based on the Miasma terminal theme by xero
;; https://terminalcolors.com/themes/miasma/default/
;; Prior art https://github.com/daut/miasma-theme.el/blob/main/miasma-theme.el
;;
;;; Code:

(require 'doom-themes)

;;
;;; Variables

(defgroup miasma-theme nil
  "Options for the `miasma' theme."
  :group 'doom-themes)

(defcustom miasma-brighter-modeline nil
  "If non-nil, more vivid colors will be used to style the mode-line."
  :group 'miasma-theme
  :type 'boolean)

(defcustom miasma-brighter-comments nil
  "If non-nil, comments will be highlighted in more vivid colors."
  :group 'miasma-theme
  :type 'boolean)

(defcustom miasma-comment-bg miasma-brighter-comments
  "If non-nil, comments will have a subtle background to enhance their legibility."
  :group 'miasma-theme
  :type 'boolean)

(defcustom miasma-padded-modeline doom-themes-padded-modeline
  "If non-nil, adds a 4px padding to the mode-line.
Can be an integer to determine the exact padding."
  :group 'miasma-theme
  :type '(choice integer boolean))

(defcustom miasma-scale-headings t
  "If non-nil, scale outline / org / markdown headings above body text.
Set before loading the theme."
  :group 'miasma-theme
  :type 'boolean)

;;
;;; Theme definition

(def-doom-theme miasma
  "A dark theme inspired by the woods - fog descends upon your editor"

  ;; name        default   256       16
  ((bg         '("#222222" "#222222" "black"        ))
   (bg-alt     '("#1a1a1a" "#1a1a1a" "black"        ))
   (base0      '("#0d0d0d" "#0d0d0d" "black"        ))
   (base1      '("#1a1a1a" "#1a1a1a" "brightblack"  ))
   (base2      '("#222222" "#222222" "brightblack"  ))
   (base3      '("#333333" "#333333" "brightblack"  ))
   (base4      '("#444444" "#444444" "brightblack"  ))
   (base5      '("#555555" "#555555" "brightblack"  ))
   (base6      '("#666666" "#666666" "brightblack"  ))
   (base7      '("#888888" "#888888" "brightblack"  ))
   (base8      '("#aaaaaa" "#aaaaaa" "white"        ))
   (fg         '("#c2c2b0" "#c2c2b0" "brightwhite"  ))
   (fg-alt     '("#b0b09e" "#b0b09e" "white"        ))

   (grey       base4)
   (red        '("#685742" "#685742" "red"          ))
   (orange     '("#b36d43" "#b36d43" "brightred"    ))
   (green      '("#5f875f" "#5f875f" "green"        ))
   (teal       '("#5f875f" "#5f875f" "brightgreen"  ))
   (yellow     '("#c9a554" "#c9a554" "yellow"       ))
   (blue       '("#78824b" "#78824b" "brightblue"   ))
   (dark-blue  '("#6a7444" "#6a7444" "blue"         ))
   (magenta    '("#bb7744" "#bb7744" "brightmagenta"))
   (violet     '("#bb7744" "#bb7744" "magenta"      ))
   (cyan       '("#c9a554" "#c9a554" "brightcyan"   ))
   (dark-cyan  '("#b39448" "#b39448" "cyan"         ))

   ;; face categories -- required for all themes
   (highlight      yellow)
   (vertical-bar   (doom-darken base1 0.1))
   (selection      base4)
   (builtin        magenta)
   (comments       (if miasma-brighter-comments dark-cyan base6))
   (doc-comments   (doom-lighten (if miasma-brighter-comments dark-cyan base6) 0.25))
   (constants      orange)
   (functions      yellow)
   (keywords       blue)
   (methods        cyan)
   (operators      blue)
   (type           green)
   (strings        green)
   (variables      (doom-lighten magenta 0.4))
   (numbers        orange)
   (region         base3)
   (error          red)
   (warning        yellow)
   (success        green)
   (vc-modified    orange)
   (vc-added       green)
   (vc-deleted     red)

   ;; custom categories
   (hidden     `(,(car bg) "black" "black"))
   (-modeline-bright miasma-brighter-modeline)
   (-modeline-pad
    (when miasma-padded-modeline
      (if (integerp miasma-padded-modeline) miasma-padded-modeline 4)))

   (modeline-fg     fg)
   (modeline-fg-alt base5)

   (modeline-bg
    (if -modeline-bright
        (doom-darken blue 0.475)
      `(,(doom-darken (car bg-alt) 0.15) ,@(cdr base0))))
   (modeline-bg-alt
    (if -modeline-bright
        (doom-darken blue 0.45)
      `(,(doom-darken (car bg-alt) 0.1) ,@(cdr base0))))
   (modeline-bg-inactive   `(,(car bg-alt) ,@(cdr base1)))
   (modeline-bg-inactive-alt `(,(doom-darken (car bg-alt) 0.1) ,@(cdr bg-alt))))

  ;;;; Base theme face overrides
  (((line-number &override) :foreground base4)
   ((line-number-current-line &override) :foreground fg)
   ((font-lock-comment-face &override)
    :background (if miasma-comment-bg (doom-lighten bg 0.05)))
   (mode-line
    :background modeline-bg :foreground modeline-fg
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg)))
   (mode-line-inactive
    :background modeline-bg-inactive :foreground modeline-fg-alt
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-inactive)))
   (mode-line-emphasis :foreground (if -modeline-bright base8 highlight))

   ;;;; css-mode <built-in> / scss-mode
   (css-proprietary-property :foreground orange)
   (css-property             :foreground green)
   (css-selector             :foreground blue)
   ;;;; doom-modeline
   (doom-modeline-bar :background (if -modeline-bright modeline-bg highlight))
   (doom-modeline-buffer-file :inherit 'mode-line-buffer-id :weight 'bold)
   (doom-modeline-buffer-path :inherit 'mode-line-emphasis :weight 'bold)
   (doom-modeline-buffer-project-root :foreground green :weight 'bold)
   ;;;; elscreen
   (elscreen-tab-other-screen-face :background "#353a42" :foreground "#1e2022")
   ;;;; ivy
   (ivy-current-match :background base3 :distant-foreground base0 :weight 'normal)
   ;;;; LaTeX-mode
   (font-latex-math-face :foreground green)
   ;;;; markdown-mode
   (markdown-markup-face :foreground base5)
   (markdown-header-face :inherit 'bold :foreground red)
   ((markdown-code-face &override) :background (doom-lighten base3 0.05))
   ;;;; org-mode
   (org-hide :foreground hidden)
   (solaire-hl-line-face :background base2)
   ;;;; solaire-mode
   (solaire-mode-line-face
    :inherit 'mode-line
    :background modeline-bg-alt
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-alt)))
   (solaire-mode-line-inactive-face
    :inherit 'mode-line-inactive
    :background modeline-bg-inactive-alt
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-inactive-alt)))

   ;;;; outline / org / markdown heading sizes
   ((outline-1 &override) :height (if miasma-scale-headings 1.30 1.0))
   ((outline-2 &override) :height (if miasma-scale-headings 1.20 1.0))
   ((outline-3 &override) :height (if miasma-scale-headings 1.15 1.0))
   ((outline-4 &override) :height (if miasma-scale-headings 1.10 1.0))
   ((outline-5 &override) :height (if miasma-scale-headings 1.05 1.0))
   ((org-document-title &override)
    :foreground red :weight 'bold
    :height (if miasma-scale-headings 1.50 1.0))
   ((markdown-header-face-1 &override) :height (if miasma-scale-headings 1.30 1.0))
   ((markdown-header-face-2 &override) :height (if miasma-scale-headings 1.20 1.0))
   ((markdown-header-face-3 &override) :height (if miasma-scale-headings 1.10 1.0))

   ;;;; magit — reinforce earth-tone roles on branches / tags
   ((magit-branch-local &override)   :foreground blue)
   ((magit-branch-remote &override)  :foreground green)
   ((magit-branch-current &override) :foreground yellow :weight 'bold)
   ((magit-tag &override)            :foreground orange)
   ((magit-hash &override)           :foreground base6)
   ((magit-section-heading &override) :foreground yellow :weight 'bold)

   ;;;; flymake — wave underlines with miasma accents
   (flymake-error   :underline `(:style wave :color ,red))
   (flymake-warning :underline `(:style wave :color ,yellow))
   (flymake-note    :underline `(:style wave :color ,green))

   ;;;; corfu — in-buffer completion popup
   (corfu-default :background bg-alt :foreground fg)
   (corfu-current :background base3  :foreground fg)
   (corfu-bar     :background base5)
   (corfu-border  :background base3)
   (corfu-annotations :foreground base6 :slant 'italic)

   ;;;; vertico — minibuffer completion
   (vertico-current      :background base3 :extend t)
   (vertico-group-title  :foreground yellow :weight 'bold :slant 'italic)
   (vertico-group-separator :foreground base5 :strike-through t)

   ;;;; marginalia — annotations alongside vertico
   (marginalia-key           :foreground yellow)
   (marginalia-type          :foreground magenta)
   (marginalia-documentation :foreground base6 :slant 'italic)
   (marginalia-string        :foreground green)
   (marginalia-number        :foreground orange)
   (marginalia-file-name     :foreground fg)
   (marginalia-file-priv-dir :foreground blue :weight 'bold)
   (marginalia-symbol        :foreground magenta)
   (marginalia-date          :foreground base7)

   ;;;; eglot
   (eglot-highlight-symbol-face :background base3 :weight 'bold)
   (eglot-mode-line             :inherit 'mode-line-emphasis)
   (eglot-diagnostic-tag-unnecessary-face :inherit 'shadow)
   (eglot-diagnostic-tag-deprecated-face  :strike-through t)

   ;;;; tree-sitter / tree-sitter-hl (modern highlighting)
   ((tree-sitter-hl-face:function.call &override)  :foreground yellow)
   ((tree-sitter-hl-face:method.call &override)    :foreground cyan)
   ((tree-sitter-hl-face:type.builtin &override)   :foreground green)
   ((tree-sitter-hl-face:variable.parameter &override) :foreground (doom-lighten magenta 0.2))
   ((tree-sitter-hl-face:property &override)       :foreground orange))

  ;;;; Base theme variable overrides-
  ())

;;; miasma-theme.el ends here
