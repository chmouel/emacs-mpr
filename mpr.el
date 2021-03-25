;;; mpr.el --- Make pull request with hub  -*- lexical-binding: t -*-

;; Copyright (C) 2021 Chmouel Boudjnah <chmouel@chmouel.com>

;; Author: Chmouel Boudjnah <chmouel@chmouel.com>
;; Keywords: git
;; URL: https://github.com/chmouel/emacs-mpr
;; Version: 0.1
;; Package-Requires: ((magit "2.1.0")()

;; This file is not part of GNU Emacs.

;; This file is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this file.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This mode allow making a pull request with hub, you can specify the user
;; remote or the origin remote and the target branch.
;;
;; You can as well use it programtically for example :
;;
;; (defun make-pull-request-against-my-fork ()
;;   (interactive)
;;   (mpr-make-pull-request "origin" "myusernameremote" "main" t))

;;; Code:

(require 'magit-remote)

(defun mpr-magit-read-remote-branch (prompt remote)
  (magit-completing-read prompt (magit-remote-list-branches remote)))

(defun mpr-magit-read-remote (prompt &optional exclude)
  (magit-completing-read prompt (magit-list-remotes)
                         (lambda (elt) (not (string= elt exclude)))))

(defun mpr-get-github-remote (remote)
  (replace-regexp-in-string
   "\\(https://github.com/\\\|git@github.com:\\)" ""
   (magit-git-string "remote" "get-url" remote)))

(defun mpr-make-pull-request (origin-remote user-remote &optional origin-remote-branch pushforce)
  (interactive
   (list (magit-read-remote "Base Remote")
         (magit-read-remote "User Remote")))
  (let* ((github-origin-remote (mpr-get-github-remote origin-remote))
         (github-user-remote (mpr-get-github-remote user-remote))
         (current-branch (magit-get-current-branch))
         (origin-remote-branch
          (if origin-remote-branch
              origin-remote-branch
            (mpr-magit-read-remote-branch
             (format "Base remote branch on %s" origin-remote)
             origin-remote))))
    (if (or pushforce
            (yes-or-no-p
             (format "Push force current branch %s to user remote %s"
                     current-branch
                     user-remote)))
        (magit-run-git
         "push" "-f" "-v"
         user-remote current-branch))
    (with-editor (magit-shell-command
                  (format "hub pull-request -b %s:%s -h %s:%s"
                          github-origin-remote
                          origin-remote-branch github-user-remote current-branch)))))

(provide 'git-mpr)
