(defun c:CopyLayout (/ srcFile srcLayout dstLayout)
  (setq srcFile (getfiled "Choose source file" "" "dwg" 16))
  (setq srcLayout (getstring "\nSource Layout name: "))
  (setq dstLayout (getstring "\nNew Layout name <no change>: "))
  (if (eq dstLayout "") (setq dstLayout srcLayout))
  (command "-layout" "template" srcFile srcLayout dstLayout)
  (princ)
)