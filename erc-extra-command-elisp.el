;;; erc-extra-command-elisp.el ---
;;
;; Filename: erc-extra-command-elisp.el
;; Description:
;; Author: James
;; Maintainer:
;; Created: Sat Jun 26 21:05:37 2010 (+0000)
;; Version:
;; Last-Updated:
;;           By:
;;     Update #: 2
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

(defun erc-extra-command-ELISP (&rest expression)
  "Evaluate given elisp expression."
  (let* ((expr (mapconcat 'identity expression " "))
         (result (condition-case err
                     (eval (read-from-whole-string expr))
                   (error (format "ERROR: %S" error)))))
    (erc-send-message (format "%s ---> %S" expr result))))

(defun erc-extra-command-elisp (&optional arg)
  (if (< 0 arg)
      (fset 'erc-cmd-ELISP 'erc-extra-command-ELISP)
    (fmakunbound 'erc-cmd-ELISP)))


(provide 'erc-extra-command-elisp)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; erc-extra-command-elisp.el ends here
