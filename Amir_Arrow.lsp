(defun c:ORTHOARROW_KNEE (/ p1 knee tip leg1 leg2 ang size a1 a2 ah1 ah2)
  (vl-load-com)

  ;; Select starting point
  (setq p1 (getpoint "\nPick start point: "))

  ;; Drag to choose the knee position and set the first leg orthogonally
  (setq knee (getpoint p1 "\nDrag to set arrow direction (knee): "))
  (setq leg1
        (if (> (abs (- (car knee) (car p1)))
               (abs (- (cadr knee) (cadr p1))))
          (list (car knee) (cadr p1) 0.0) ; horizontal first segment
          (list (car p1) (cadr knee) 0.0) ; vertical first segment
        )
  )

  ;; Drag again to place the final tip; second leg stays orthogonal to the first
  (setq tip (getpoint leg1 "\nPick arrow tip: "))
  (setq leg2
        (if (= (car leg1) (car p1))      ; first leg vertical
          (list (car tip) (cadr leg1) 0.0)
          (list (car leg1) (cadr tip) 0.0)
        )
  )

  ;; Arrowhead calculations
  (setq size 2.0)                        ; constant arrowhead size
  (setq ang  (angle leg2 tip))
  (setq ah1 (polar tip (+ ang (* 3 (/ pi 4))) size)
        ah2 (polar tip (- ang (* 3 (/ pi 4))) size))

  ;; Draw the parts
  (command "_LINE" p1 leg1 "")           ; first leg
  (command "_LINE" leg1 leg2 "")         ; second leg (knee to tip)
  (command "_LINE" ah1 tip ah2 "")       ; arrowhead
  (princ)
)