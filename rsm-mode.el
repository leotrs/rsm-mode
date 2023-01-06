;;; rsm-mode.el --- major mode for RSM
;;;
;;; Commentary:
;;; Emacs RSM mode.
;;;
;;; Code:

(require 'tree-sitter)
(require 'tree-sitter-hl)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; font faces
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Taken from Tomorrow theme's "day" color palette
;; https://github.com/chriskempson/tomorrow-theme/blob/master/GNU%20Emacs/color-theme-tomorrow.el
(defconst rsm-color-theme:gray "#8e908c")
(defconst rsm-color-theme:red "#c82829")
(defconst rsm-color-theme:orange "#f5871f")
(defconst rsm-color-theme:yellow "#eab700")
(defconst rsm-color-theme:green "#718c00")
(defconst rsm-color-theme:aqua "#3e999f")
(defconst rsm-color-theme:purple "#8959a8")
(defconst rsm-color-theme:blue "#4271ae")

(defgroup rsm nil
  "Major mode for editing text files in RSM format."
  :prefix "rsm-"
  :group 'text
  ;; :link '(url-link "https://jblevins.org/projects/markdown-mode/")
  )

(defgroup rsm-faces nil
  "Faces used in RSM Mode."
  :group 'rsm
  :group 'faces)

(defface tree-sitter-hl-face:block-tag
  `((t :foreground ,rsm-color-theme:blue :weight bold))
  "Face for block tags."
  :group 'tree-sitter-hl-faces
  :group 'rsm-faces)

(defface tree-sitter-hl-face:block-halmos
  `((t :inherit tree-sitter-hl-face:block-tag))
  "Face for block tags."
  :group 'tree-sitter-hl-faces
  :group 'rsm-faces)

(defface tree-sitter-hl-face:inline-tag
  `((t :foreground ,rsm-color-theme:aqua))
  "Face for block tags."
  :group 'tree-sitter-hl-faces
  :group 'rsm-faces)

(defface tree-sitter-hl-face:inline-halmos
  `((t :inherit tree-sitter-hl-face:inline-tag))
  "Face for block tags."
  :group 'tree-sitter-hl-faces
  :group 'rsm-faces)

(defface tree-sitter-hl-face:construct-tag
  `((t :foreground ,rsm-color-theme:green))
  "Face for block tags."
  :group 'tree-sitter-hl-faces
  :group 'rsm-faces)

(defface tree-sitter-hl-face:construct-halmos
  `((t :inherit tree-sitter-hl-face:construct-tag))
  "Face for block tags."
  :group 'tree-sitter-hl-faces
  :group 'rsm-faces)

(defface tree-sitter-hl-face:trshort-colon
  `((t :inherit tree-sitter-hl-face:inline-halmos))
  "Face for block tags."
  :group 'tree-sitter-hl-faces
  :group 'rsm-faces)

(defface tree-sitter-hl-face:meta-tag
  `((t :foreground ,rsm-color-theme:gray))
  "Face for block tags."
  :group 'tree-sitter-hl-faces
  :group 'rsm-faces)

(defface tree-sitter-hl-face:heading
  `((t :foreground ,rsm-color-theme:orange :weight bold))
  "Face for emphas spans."
  :group 'tree-sitter-hl-faces
  :group 'rsm-faces)

(defface tree-sitter-hl-face:heading-halmos
  `((t :inherit tree-sitter-hl-face:heading))
  "Face for emphas spans."
  :group 'tree-sitter-hl-faces
  :group 'rsm-faces)

(defface tree-sitter-hl-face:emphas
  `((t :slant italic))
  "Face for emphas spans."
  :group 'tree-sitter-hl-faces
  :group 'rsm-faces)

(defface tree-sitter-hl-face:strong
  `((t :weight bold))
  "Face for emphas spans."
  :group 'tree-sitter-hl-faces
  :group 'rsm-faces)

(defface tree-sitter-hl-face:special-delim
  `((t :foreground ,rsm-color-theme:purple :weight bold))
  "Face for emphas spans."
  :group 'tree-sitter-hl-faces
  :group 'rsm-faces)

(defface tree-sitter-hl-face:meta-delim
  `((t :foreground ,rsm-color-theme:purple))
  "Face for emphas spans."
  :group 'tree-sitter-hl-faces
  :group 'rsm-faces)

(defface tree-sitter-hl-face:asis
  `((t :foreground "rosy brown"))
  "Face for emphas spans."
  :group 'tree-sitter-hl-faces
  :group 'rsm-faces)

(defface tree-sitter-hl-face:rsm-label
  `((t :foreground ,rsm-color-theme:yellow))
  "Face for emphas spans."
  :group 'tree-sitter-hl-faces
  :group 'rsm-faces)

(defface tree-sitter-hl-face:draft
  `((t :foreground "#4169e1" :slant italic))
  "Face for emphas spans."
  :group 'tree-sitter-hl-faces
  :group 'rsm-faces)

(defface tree-sitter-hl-face:error
  `((t :background "#ffdead" :foreground ,rsm-color-theme:red))
  "Face for emphas spans."
  :group 'tree-sitter-hl-faces
  :group 'rsm-faces)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; syntax highlighting
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defconst rsm-mode-tree-sitter-patterns
  [
   ;; Labels
   (blockmeta
    (pair
     (metakey_text (label))
     (metaval_text) @rsm-label))
   (inlinemeta
    (pair
     (metakey_text (label))
     (metaval_text) @rsm-label))
   (specialinline
    tag: (ref)
    target: (text) @rsm-label
    reftext: (text))
   (specialinline
    tag: (ref)
    target: (text) @rsm-label)
   (specialinline
    tag: (cite)
    targetlabels: (text) @rsm-label)
   (bibitem
    (label) @rsm-label)

   ;; Tags
   [
    (author)
    (abstract)
    (toc)
    (theorem)
    (lemma)
    (remark)
    (proposition)
    (proof)
    (step)
    (subproof)
    (sketch)
    (bibliography)
    (figure)
    (algorithm)
    (codeblock)
    (enumerate)
    (itemize)
    (definition)
    ] @block-tag

   [
    (draft)
    (note)
    (span)
    (cite)
    (code)
    (ref)
    (prev)
    (prev2)
    (prev3)
    (previous)
    (url)
    ] @inline-tag

   [
    (let)
    (new)
    (claim)
    (assume)
    (prove)
    (suffices)
    (define)
    (write)
    (case)
    (then)
    (qed)
    ] @construct-tag

   [
    (label)
    (types)
    (title)
    (isclaim)
    (date)
    (path)
    (scale)
    (affiliation)
    (email)
    (name)
    (reftext)
    (nonum)
    (strong)
    (emphas)
    (keywords)
    (msc)
    (lang)
    (goal)
    ] @meta-tag

   (paragraph (":paragraph:") @inline-tag)
   (item (":item:") @inline-tag)
   (caption (":caption:") @inline-tag)

   ;; Special regions
   (asis_text) @asis

   ;; Bibliography stuff
   (bibtex (":bibtex:") @block-tag)
   (bibitem (kind) @block-tag)
   (bibitem (kind) @block-tag)
   (bibitempair
    (key) @meta-tag
    ("=") @special-delim
    ("{") @special-delim
    (value)
    ("}") @special-delim)
   (bibtex ("::") @block-halmos)

   ;; Table
   (table (":table:") @block-tag)
   (tbody (":tbody:") @block-tag)
   (thead (":thead:") @block-tag)
   (table ("::") @block-halmos)
   (tbody ("::") @block-halmos)
   (thead ("::") @block-halmos)
   (tr (":tr:") @inline-tag)
   (td (":td:") @inline-tag)
   (trshort (":tr:") @inline-tag)
   (tr ("::") @inline-halmos)
   (td ("::") @inline-halmos)
   (trshort ("::") @inline-halmos)
   (trshort (tdcontent) \. (":") @trshort-colon \. (tdcontent))

   ;; Delimiters
   [(mathblock) "mathblock"] @special-delim
   [(math) "math"] @special-delim
   ;; [(codeblock) "codeblock"] @special-delim
   ;; [(code) "code"] @special-delim
   (inlinemeta ("{") @meta-delim)
   (inlinemeta ("}") @meta-delim)

   ;; Span properties
   (specialinline (spanemphas) (text)) @emphas
   (specialinline (spanstrong) (text)) @strong

   ;; Sections
   (manuscript) @heading
   (specialblock
    tag: [(section) (subsection) (subsubsection)]
    title: (text) @heading)
   ((metakey_text (title)) (metaval_text) @heading)
   (specialblock [(section) (subsection) (subsubsection)] @heading)

   ;; Halmos
   (inline ("::") @inline-halmos)
   (specialinline ("::") @inline-halmos)
   (block ("::") @block-halmos)
   (specialblock [(section) (subsection) (subsubsection)] ("::") @heading-halmos .)
   (construct ("::") @construct-halmos)
   (source_file ("::") @heading-halmos)

   ;; Draft
   (inline
     (draft)
     (text) @draft)

   ;; Comments
   (comment) @comment

   ;; Errors
   (ERROR) @error
   ]
  )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; syntax table
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar rsm-mode-syntax-table
  (let ((table (make-syntax-table)))
    ;; (modify-syntax-entry ?\: "w." table) ; colon is a word constituent
    (modify-syntax-entry ?\: "." table) ; colon is punctuation
    (modify-syntax-entry ?\: "(:" table) ; colon open delimiter
    (modify-syntax-entry ?\: "):" table) ; colon close delimiter
    (modify-syntax-entry ?\{ "(}" table) ; { is the open delim for }
    (modify-syntax-entry ?\} "){" table) ; } is the close delim for {
    (modify-syntax-entry ?\% "<" table)	 ; percent is a comment starter
    (modify-syntax-entry ?\n ">" table)	 ; newline is a comment ender
    table))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; indentation
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defconst rsm-mode-indent-width 2
  "Default tab size for RSM mode.")

;; this one works on the tree
(defun rsm-get-parent-block (node)
  "Return the closest block ancestor of the given NODE."
  (if (eq (tsc-node-type node) 'source_file)
      node
    (progn
      (let ((parent (tsc-get-parent node)))
	(if (member (tsc-node-type parent) (list 'source_file 'block 'specialblock))
	    parent
	  (rsm-get-parent-block parent))))))

;; this one works on the buffer
(defun rsm-closest-block-tag ()
  "Get the position of the opening tag of the closest block ancestor."
  (let ((node (tree-sitter-node-at-point)))
    (message (if (tsc-node-named-p node)
		 (symbol-name (tsc-node-type node))
	       (tsc-node-type node)))
    (if (member (tsc-node-type node) (list 'source_file 'block 'specialblock))
	(tsc-node-start-position node)
      (let ((parent (rsm-get-parent-block (tree-sitter-node-at-point))))
	(tsc-node-start-position parent)))))

;; this one works on the buffer
(defun rsm-goto-closest-block-tag ()
  "Move point to the tag of the closest block ancestor."
  (interactive)
  (when (eq (char-after) ?:)
    (backward-char))
  (goto-char (rsm-closest-block-tag)))

(defun rsm-node-at-point ()
  (interactive)
  (message (symbol-name (tsc-node-type (tree-sitter-node-at-point)))))

(defun rsm-get-sibling ()
  (interactive)
  (message (tsc-node-type (tsc-get-next-sibling (tree-sitter-node-at-point)))))

(defun rsm-mode-calculate-indent ()
  "Calculate the indentation of the current line."
  (if (= 1 (line-number-at-pos))
      0
    (let ((sibling (tsc-get-next-sibling (tree-sitter-node-at-point))))
      (save-excursion
	(rsm-goto-closest-block-tag)
	(if (= 1 (line-number-at-pos))
	    0
	  (progn
	    (if sibling
		(let ((sibling-type (tsc-node-type sibling)))
		  (message (if (stringp sibling-type) sibling-type (symbol-name sibling-type)))
		  (if (and (stringp sibling-type) (string= "::" sibling-type))
		      (current-indentation)
		    (+ rsm-mode-indent-width (current-indentation))))
	      (current-indentation))))))))

(defun rsm-mode-indent-line ()
  "Indent current line as RSM code."
  (save-excursion
    (back-to-indentation)
    (let ((new-indent (rsm-mode-calculate-indent)))
      (when (not (= new-indent (current-indentation)))
	(let ((beg (point)))
	  (beginning-of-line)
	  (delete-region beg (point))
	  (indent-to new-indent))))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; abbrev tables
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ?


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; commands
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (defun rsm-mode-find-node-with-label (label)
;;   "Return the first node found with the given LABEL, or nil."

;;   (metatag_text
;;    (label))

;;   )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; keymap
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defvar rsm-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-M-u") 'rsm-goto-closest-block-tag)
    map)
  "Keymap for RSM major mode.")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; linter via flycheck
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(flycheck-define-checker rsm-lint
  "Linter for RSM using rsm-linter.

See URL `https://write-rsm.org/'."
  :command ("rsm-lint" source)
  :error-patterns
  ((info line-start (one-or-more alpha) ":" line ":" column ": " "LINT" ": " (message) line-end)
   (warning line-start (one-or-more alpha) ":" line ":" column ": " "WRN" ": " (message) line-end)
   (error line-start (one-or-more alpha) ":" line ":" column ": " "ERROR" ": " (message) line-end))
    :modes rsm-mode)

(add-to-list 'flycheck-checkers 'rsm-lint)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; export the mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;###autoload
(define-derived-mode rsm-mode prog-mode "RSM"
  "Major mode for RSM files."
  (unless font-lock-defaults
    (setq font-lock-defaults '(nil)))
  (setq-local tree-sitter-hl-default-patterns rsm-mode-tree-sitter-patterns)
  (setq-local comment-start "%")
  (setq-local comment-end "")
  (setq-local indent-line-function #'rsm-mode-indent-line)
  (setq-local indent-tabs-mode nil)
  (setq-local tree-sitter-debug-highlight-jump-region t)
  (setq-local tree-sitter-debug-jump-buttons t)
  (tree-sitter-hl-mode)
  (add-to-list 'write-file-functions 'delete-trailing-whitespace))

(add-to-list 'tree-sitter-major-mode-language-alist '(rsm-mode . rsm))

(provide 'rsm-mode)
;;; rsm-mode.el ends here
