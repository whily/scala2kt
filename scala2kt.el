;;; scala2kt.el --- An Emacs package to convert Scala source code to Kotlin. -*- lexical-binding: t; -*-

;; Copyright (C) 2018 Yujian Zhang

;; Author: Yujian Zhang <yujian.zhang@gmail.com>
;; Maintainer: Yujian Zhang <yujian.zhang@gmail.com>
;; Created: 17 Oct 2018
;; Modified: 06 Nov 2018
;; Version: 0.1
;; Package-Requires: ((emacs "24.3"))
;; Keywords: emacs scala kotlin
;; URL: https://github.com/whily/scala2kt

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 3, or (at
;; your option) any later version.

;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:

;; Please Check README.md from the repository for detailed documentation.

;;; Code:

;;; Options

(defgroup scala2kt nil
  "Customization options for scala2kt"
  :group 'help
  :prefix "scala2kt-")

(defcustom scala2kt-replace-regexps
  '(;; import
    ("^\\(import.*\\.\\){\\(.*\\), ?\\(.*\\), ?\\(.*\\), ?\\(.*\\), ?\\(.*\\), ?\\(.*\\), ?\\(.*\\), ?\\(.*\\)}"
     "\\1\\2\n\\1\\3\n\\1\\4\n\\1\\5\n\\1\\6\n\\1\\7\n\\1\\8\n\\1\\9")
    ("^\\(import.*\\.\\){\\(.*\\), ?\\(.*\\), ?\\(.*\\), ?\\(.*\\), ?\\(.*\\), ?\\(.*\\), ?\\(.*\\)}"
     "\\1\\2\n\\1\\3\n\\1\\4\n\\1\\5\n\\1\\6\n\\1\\7\n\\1\\8")
    ("^\\(import.*\\.\\){\\(.*\\), ?\\(.*\\), ?\\(.*\\), ?\\(.*\\), ?\\(.*\\), ?\\(.*\\)}"
     "\\1\\2\n\\1\\3\n\\1\\4\n\\1\\5\n\\1\\6\n\\1\\7")
    ("^\\(import.*\\.\\){\\(.*\\), ?\\(.*\\), ?\\(.*\\), ?\\(.*\\), ?\\(.*\\)}"
     "\\1\\2\n\\1\\3\n\\1\\4\n\\1\\5\n\\1\\6")
    ("^\\(import.*\\.\\){\\(.*\\), ?\\(.*\\), ?\\(.*\\), ?\\(.*\\)}"
     "\\1\\2\n\\1\\3\n\\1\\4\n\\1\\5")
    ("^\\(import.*\\.\\){\\(.*\\), ?\\(.*\\), ?\\(.*\\)}"
     "\\1\\2\n\\1\\3\n\\1\\4")
    ("^\\(import.*\\.\\){\\(.*\\), ?\\(.*\\)}" "\\1\\2\n\\1\\3")
    ("^\\(import.*\\)_" "\\1*")

    ;; Class, interface
    (" extends\\(.*\\) with\\(.*\\) with\\(.*\\) with\\(.*{\\)" ":\\1,\\2,\\3,\\4")
    (" extends\\(.*\\) with\\(.*\\) with\\(.*{\\)" ":\\1,\\2,\\3")
    (" extends\\(.*\\) with\\(.*{\\)" ":\\1,\\2")
    (" extends\\b" ":")
    ("\\bcase class\\b" "data class")
    ("\\btrait\\b" "interface")
    (" new\\b" "")
    ("(new " "(")

    ;; Nullable
    ("\\(var.*: [a-zA-z0-9_]+\\) = null" "\\1? = null")

    ;; Function
    ("\\bdef\\b" "fun")

    ;; Lambda
    (" \\(map\\|filter\\) (\\(.*\\))" ".\\1 { \\2 }")
    ("\\b_\\." "it.")

    ;; For loop
    ("\\(for (.*\\)<-" "\\1in")

    ;; when
    ("\\( +\\)\\(.*\\) match {" "\\1when (\\2) {")
    ("case \\(.*\\) =>" "\\1 ->")

    ;; Reflection (TODO: further check)
    ("classOf\\[\\(.*\\)\\]" "\\1::class")

    ;; Math
    ("\\( \\|(\\)math." "\\1kotlin.math.")

    ;; Array
    ("= Array(" "= arrayOf(")
    ("\\.toArray" ".toCharArray()")
    ("\\.mkString(" ".joinToString(separator = ")

    ;; List
    ("= List(" "= listOf(")

    ;; HashMap
    ("mutable\\.HashMap\\[\\(.*?\\)]" "HashMap<\\1>")
    ("\\.contains(" ".containsKey(")

    ;; Regex
    ("import scala.util.matching.Regex\n" "")

    ;; Range
    ("Range(\\(.*\\), ?\\(.*\\))" "\\1 until \\2"))
  "A list storing regexps for replacement.

Each element of the list is a pair of two elements. First element
is regexp for Scala structures to be replaced, while second element
is regexp for Kotlin structure to replace Scala structure."
  :group 'scala2kt
  :type 'list)

;;;###autoload
(defun scala2kt ()
  "Assistant to convert Scala to Kotlin."
  (interactive)
  ;; Force to use Scala mode.
  ;; (scala-mode)
  (save-excursion
    (dolist (replace-regexp-pair scala2kt-replace-regexps)
      (scala2kt-replace (car replace-regexp-pair) (nth 1 replace-regexp-pair)))))

;;;###autoload
(defun scala2kt-replace (from to)
  "Replace all occurrences of FROM in regexp to TO in regexp."
  (goto-char (point-min))
  (while (re-search-forward from nil t)
    ;; Only replace if not in comment or string.
    ;; Please refer to doc of parse-partial-sexp for the returned list from syntax-ppss.
    (unless (nth 8 (syntax-ppss))
      (replace-match to))))

(provide 'scala2kt)

;;; scala2kt.el ends here
