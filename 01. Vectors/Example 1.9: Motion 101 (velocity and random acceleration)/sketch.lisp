(defpackage :nature-of-code.vectors.example-9
  (:export :start-sketch)
  (:use :cl :trivial-gamekit)
  (:import-from :cl-bodge :vector-length :normalize))
  (in-package :nature-of-code.vectors.example-9)

(defvar *width* 640)
(defvar *height* 360)

(defvar *black* (vec4 0 0 0 1))
(defvar *gray* (vec4 0.5 0.5 0.5 1))

(defun limit-vec (vec max)
  (if (> (vector-length vec) max)
      (mult (normalize vec) max)
      vec))

(defun random-in-range (start end)
  (+ start (random (+ 1 (- end start)))))

(defun random-unit-vector ()
  "Generates a unit vector with a random direction"
  (let* ((angle (* (random 1.0) 2 pi))
         (vx (cos angle))
         (vy (sin angle)))
    (vec2 vx vy)))

(defclass mover ()
  ((location
    :initform (vec2 (random-in-range 0 *width*) (random-in-range 0 *height*))
    :accessor location)
   (velocity
    :initform (vec2 0 0)
    :accessor velocity)
   (top-speed
    :initform 10
    :accessor top-speed)))

(defmethod check-edges ((mover mover))
  (let* ((location (location mover))
         (x (x location))
         (y (y location)))
    (cond ((< x 0) (setf (x location) *width*))
          ((> x *width*) (setf (x location) 0)))
    (cond ((< y 0) (setf (y location) *height*))
          ((> y *height*) (setf (y location) 0)))))

(defmethod update ((mover mover))
  (let* ((a (random-unit-vector))
         (v (limit-vec (add a (velocity mover)) 10)))
    (setf (velocity mover) v)
    (setf (location mover) (add v (location mover)))
    (check-edges mover)))

(defmethod display ((mover mover))
  (draw-circle (location mover) 16
               :fill-paint *gray*
               :stroke-paint *black*
               :thickness 2))

(defgame sketch ()
  ((mover
    :initform (make-instance 'mover)
    :accessor mover))
  (:viewport-width *width*)
  (:viewport-height *height*)
  (:viewport-title "Motion 101 (velocity and random acceleration)"))

(defmethod draw ((this sketch))
  (display (mover this)))

(defmethod act ((this sketch))
  (update (mover this)))

(defun start-sketch ()
  (start 'sketch))
