(defun c:MAGNETHOLE (/ hSel pSel hObj pObj arr)
  (vl-load-com)
  (setq hSel (car (entsel "\nבחר Hatch: "))
        pSel (car (entsel "\nבחר Polyline: ")))
  (if (and hSel pSel)
    (progn
      (setq hObj (vlax-ename->vla-object hSel)
            pObj (vlax-ename->vla-object pSel)
            arr  (vlax-make-safearray vlax-vbObject '(0 . 0)))
      (vlax-safearray-put-element arr 0 pObj)
      (vla-AppendInnerLoop hObj arr)    ; החדרת הפוליליין כחור חדש
      (vla-Update hObj)                 ; עדכון ה־Hatch
    )
  )
  (princ)
)
