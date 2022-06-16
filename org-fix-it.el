(defun wr/org-pdftool-correct-current-path ()
   "Fix the path used in org-pdftools.

 For example, user shall have a link:

 [[pdftools:~/push/done/393945dc3d6e4fcc8dbb33eb5f872703.pdf::3++0.00;;annot-3-19][Resource]]

 After 393945dc3d6e4fcc8dbb33eb5f872703.pdf is moved to a data
 directory, this link is no longer available.

 This function corrects the PATH for the link.

 [[pdftools:~/path/to/db/393945dc3d6e4fcc8dbb33eb5f872703.pdf::3++0.00;;annot-3-19][Resource]]
 "
   (interactive)
   (let* ((context
	   (org-element-lineage
	    (org-element-context)
	    '(link)
	    t))
          (full-path-and-description (plist-get (car (cdr context)) :path))
          (full-path (progn
                       (string-match "\\(.*\\)::\\(.*\\)" full-path-and-description)
                       (match-string 1 full-path-and-description)))
          (full-path-only-description (progn
                                      (string-match "\\(.*\\)::\\(.*\\)" full-path-and-description)
                                      (match-string 2 full-path-and-description))))
     (if (string-prefix-p (expand-file-name wr/pdfs-db-location) (expand-file-name full-path))
         (message "Path is good for %s." full-path)
       (if (org-in-regexp org-link-bracket-re 1)
           (save-excursion
             (let ((remove (list (match-beginning 0) (match-end 0))))
               (apply 'delete-region remove)
               (insert "[[pdftools:" (concat wr/pdfs-db-location
                                             (file-name-nondirectory full-path)
                                             "::"
                                             full-path-only-description)
                       "][Resource]]")))))))
