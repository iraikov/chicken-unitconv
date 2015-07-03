;; -*-Hen-*-
;;
;; Modified for Chicken Scheme by Ivan Raikov (2009-2010).
;; 
;; Copyright (C) 1986, 1987, 1988, 1989, 1990, 1991, 1992, 1993, 1994,
;;    1995, 1996, 1997, 1998, 1999, 2000, 2001, 2002, 2003, 2004, 2005,
;;    2006, 2007 Massachusetts Institute of Technology
;;
;; This file is part of MIT/GNU Scheme.
;;
;; MIT/GNU Scheme is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 3 of the
;; License, or (at your option) any later version.
;;
;; MIT/GNU Scheme is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with MIT/GNU Scheme; if not, write to the Free Software
;; Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
;; 02110-1301, USA.

;;;; Quantities with units

(module with-units

	(
	 *permissive-units*
	 with-units?
	 without-units?
	 unitless-quantity?
	 val-with-units

	 u:value
	 u:units
	 u:equal?
	 u:zero?
	 u:=
	 u:negate
	 u:invert
	 u:+ u:- u:* u:/ 
	 u:sqrt
	 u:sin
	 u:cos
	 u:expt
	 )

	
	(import scheme chicken data-structures )
	(require-extension unitconv numbers)
	(import (only extras fprintf))

;;; If set to #t allows contageous no-unit combinations.
(define *permissive-units* (make-parameter #f))

;;; Quantities without explicit units are assumed unitless.

(define-record-type with-units
  (make-with-units unit value)
  with-units?
  (unit       with-units-unit )
  (value      with-units-value )
  )


(define-record-printer (with-units x out)
      (fprintf out "#(~S ~S)"
	       (with-units-value x)
	       (with-units-unit x)))

(define (u:units x)
  (cond ((with-units? x) (with-units-unit x))
	(else unitless)))

(define (u:value x)
  (cond ((with-units? x) (with-units-value x))
	(else x)))

(define (without-units? x)
  (not (with-units? x)))

(define (unitless-quantity? x)
  (cond ((with-units? x) (unitless? (u:units x)))
	(else #t)))


(define (u:equal? x y)
  (cond ((and (with-units? x) (with-units? y))
	 (equal? (u:units x) (u:units y)))
	(else #t)))

(define (val-with-units value unit)
  (and (unit? unit) (number? value) 
       (make-with-units unit value)))

(define (u:zero? x) (zero? (u:value x)))

(define (u:= x y)
  (and (u:equal? x y)
       (= (u:value x) (u:value y))))

(define (u:negate x)
  (val-with-units (- (u:value x)) (u:units x)))

(define (invert x) (/ 1 x))

(define (u:invert x)
  (val-with-units (invert (u:value x)) (unit-invert (u:units x))))

(define (u:sqrt x)
  (val-with-units (sqrt (u:value x)) (unit-expt (u:units x) 0.5)))

(define (u:sin x)
  (val-with-units (sin (u:value x)) unitless))

(define (u:cos x)
  (val-with-units (cos (u:value x)) unitless))

(define (u:+ x y)
  (if (and (with-units? x) (with-units? y))
      (cond ((u:zero? x) y)
	    ((u:zero? y) x)
	    ((u:equal? x y)
	     (val-with-units (+ (u:value x) (u:value y)) (u:units x) ))
	    ((and (*permissive-units*)
		  (or (without-units? x) (without-units? y)))
	     (+ (u:value x) (u:value y)))
	    (else (error 'u:+ "units do not match: " x y)))
      (val-with-units(+ x y)  unitless )))

(define (u:- x y)
  (if (and (with-units? x) (with-units? y))
      (cond ((u:zero? y) x)
	    ((u:zero? x) (u:negate y))
	    ((u:equal? x y)
	     (val-with-units (- (u:value x) (u:value y)) (u:units x) ))	
	    ((and (*permissive-units*)
		  (or (without-units? x) (without-units? y)))
	     (- (u:value x) (u:value y)))
	    (else (error 'u:- "units do not match: " x y)))
      (val-with-units (- x y) unitless)))

(define (u:* x y)
  (if (and (with-units? x) (with-units? y))
      (val-with-units (* (u:value x) (u:value y))
		      (unit* (u:units x) (u:units y)))
      (val-with-units(* x y) unitless )))

(define (u:/ x y)
  (if (and (with-units? x) (with-units? y))
      (val-with-units (/ (u:value x) (u:value y))
		      (unit/ (u:units x) (u:units y)))
      (val-with-units (/ x y) unitless )))

(define (u:expt x y)
  (if (with-units? x) 
      (if (unitless-quantity? y)
	  (val-with-units (expt (u:value x) (u:value y))
			  (unit-expt (u:units x) (u:value y)))
	  (error 'u:expt "exponent must be unitless:" x y))
      (val-with-units (expt x y) unitless)))



)
