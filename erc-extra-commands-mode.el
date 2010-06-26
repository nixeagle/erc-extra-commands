;;; erc-extra-commands-mode.el ---
;;
;; Filename: erc-extra-commands-mode.el
;; Description:
;; Author: James
;; Maintainer:
;; Created: Sat Jun 26 19:55:37 2010 (+0000)
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
(require 'erc)
(defgroup erc-extra-commands-mode nil
  "Extra commands for erc."
  :group 'erc)

(define-erc-module extra-commands nil
  "Allows enabling extra erc-mode commands.

See the group `erc-extra-commands-mode' for more."
  ()
  ())

(defcustom erc-extra-commands nil
  "Extra commands that can be enabled."
  :group 'erc-extra-commands-mode
  :set (lambda (sym val)
	 ;; disable modules which have just been removed
         (print (list sym val))
	 (when (and (boundp 'erc-extra-commands))
           (dolist (command erc-extra-commands)
             (print "val is bound")
             (unless (member command val)
	       (let ((f (intern-soft (format "erc-extra-command-%s" command))))
		 (when (and (fboundp f))
                   ;; original had (and .... (boundp f) (symbol-value f))
		   (message "Disabling `erc-extra-command-%s'" command)
		   (funcall f 0))))))
	 (set sym val)
	 ;; this test is for the case where erc hasn't been loaded yet
	 (when (fboundp 'erc-update-extra-commands)
	   (erc-update-extra-commands)))
  :type
  '(set :greedy t
        (const :tag "elisp: Evaluate emacs lisp" elisp)))

(defun erc-update-extra-commands ()
  "run this to enable commands for `erc-extra-commands'."
  (dolist (command erc-extra-commands)
    (let ((.require (concat "erc-extra-command-" (symbol-name command))))
      (condition-case nil
          (require (intern .require))
        (error nil))
      (let ((sym (intern-soft (concat "erc-extra-command-" (symbol-name command)))))
        (if (fboundp sym)
            (funcall sym 1)
          (error "`%s' is not a known erc command" command))))))

(provide 'erc-extra-commands-mode)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; erc-extra-commands-mode.el ends here
