;;; erc-extra-command-cl.el ---
;;
;; Filename: erc-extra-command-cl.el
;; Description:
;; Author: James
;; Maintainer:
;; Created: Sat Jun 26 21:04:49 2010 (+0000)
;; Version:
;; Last-Updated:
;;           By:
;;     Update #: 4
;; URL:
;; Keywords:
;; Compatibility:
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Commentary:
;;
;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Change log:
;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 3, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth
;; Floor, Boston, MA 02110-1301, USA.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Code:
(require 'erc-extra-commands-mode)
(defun erc-extra-command-cl-slime-async-eval (expression ns func)
  "Eval EXPRESSION in `slime' and pass result to BODY.

Run EXPRESSION in NS. If nil, defaults to whatever is set.

Based off of `slime-eval-async'."
  (setq erc-extra-command-cl-expression (substring-no-properties expression))

  (setq erc-extra-command-cl-func func)
  (slime-eval-async
    `(swank:eval-and-grab-output ,erc-extra-command-cl-expression)
    (lambda (result)
      (destructuring-bind (output value) result
        (funcall erc-extra-command-cl-func
                 erc-extra-command-cl-expression
                 output
                 value)))
    ns)
  nil)

(defun erc-extra-command-CL (&rest expression)
  "Evaluate common lisp and send to irc buffer.

This depends on slime being present and running before this will
work."
  (erc-extra-command-cl-slime-async-eval
   (mapconcat 'identity expression " ") nil
                     (lambda (in out value)
                       (erc-send-message
                        (format "%s --> %s" in
                                (replace-regexp-in-string
                                 "[ \n]+" " " value))))))

(defun erc-extra-command-cl (&optional arg)
  (if (< 0 arg)
      (fset 'erc-cmd-CL 'erc-extra-command-CL)
    (fmakunbound 'erc-cmd-CL)))

(provide 'erc-extra-command-cl)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; erc-extra-command-cl.el ends here
