;;
;; Based on code by  Dmitry A. Kazakov  and Gordon S. Novak
;;
;; TODO: implement non-strict conversion (e.g. mass <-> energy, mass <-> weight)
;;
;; Copyright 2007-2016 Ivan Raikov.
;;
;; This program is free software: you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation, either version 3 of the
;; License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; A full copy of the GPL license can be found at
;; <http://www.gnu.org/licenses/>.
;;


(module unitconv

	(

	 define-quantity 
	 define-unit 
	 define-unit-prefix
	 make-unit-prefix

         quantity-expr-eval
	 unit-factor-eval
	 unit-factor-dim
         dimint

	 unitconv:error
	 make-quantity 
	 quantity?
	 quantity-name
	 quantity-int

	 make-unit
	 unit?
	 unit-equal?
	 unit-name
	 unit-factor
	 unit-dims
	 unit-prefix

	 unit-convert
	 unit/
	 unit*
	 unit-invert
	 unit-expt

	 unitless?

	 Unity       
	 Length      
	 Time        
	 Temperature 
	 Mass        
	 Current     
	 Luminosity  
	 Substance   
	 Currency    
	 Information

	 ;;
	 ;; Geometry
	 ;;
	 Area
	 Volume

	 ;;
	 ;; Mechanics
	 ;;
	 Velocity
	 Acceleration
	 Force
	 Pressure
	 Energy
	 Power

	 ;;
	 ;; Electricity
	 ;;
	 Charge
	 Potential
	 Capacitance
	 Resistance
	 Conductance
	 Inductance

	 ;;
	 ;; Chemistry
	 ;;
	 Concentration
	 Density

	 ;;
	 ;; Optic
	 ;;
	 Luminance

	 ;;
	 ;; Other
	 ;;
	 Frequency
	 Rate

	 unitless
	 
	 ;; SI unit prefixes 
	 yocto
	 zepto
	 atto
	 femto
	 pico
	 nano
	 micro
	 milli
	 centi
	 deci
	 deca
	 hecto
	 kilo
	 mega
	 giga
	 tera
	 peta
	 exa
	 zetta
	 yotta

	 ;; Time multiples
	 twelve
	 sixty

	 ;; Angles (dimensionless ratio)
	 radian rad radians
	 degree deg degrees
         arcminute arcmin amin MOA
	 arcsec
         grad gon grd

	 ;; Units of length
	 meter m meters
	 inch in inches
	 foot ft feet
	 angstrom ang angstroms
	 parsec parsecs
	 centimeter cm centimeters
	 millimeter mm millimeters
	 micrometer um micron microns micrometer micrometers

	 ;; Units of area and volume
	 square-meter m^2 m2 meter-squared meters-squared square-meters
	 square-inch in^2 inch-squared inches-squared square-inches
	 square-micron um^2 micrometer-squared micrometers-squared micron-squared microns-squared square-microns
	 square-millimeter mm^2 millimeter-squared millimeters-squared square-millimeters
	 square-centimeter cm^2 centimeter-squared centimeters-squared square-centimeters
	 cubic-meter m^3 meter-cubed meters-cubed cubic-meters
	 liter L litre liters

	 ;; Units of mass
	 kilogram kg kilograms
	 gram g grams
	 milligram mg milligrams
	 pound lb pounds
	 slug slugs
	 atomic-mass-unit amu atomic-mass-units

	 ;; Units of time
	 second s seconds
	 hour h hrs hours

	 ;; Units of acceleration
	 meters-per-second-squared m/s2 m/s^2 m/sec2 m/sec^2

	 ;; Units of frequency
	 hertz hz

	 ;; Units of force
	 newton nt newtons
	 pound-force lbf

	 ;; Units of power
	 watt W watts
	 horsepower hp

	 ;; Units of energy
	 joule J joules
	 electron-volt ev electron-volts
	 kilowatt-hour kwh kilowatt-hours
	 calorie cal calories
	 erg ergs
	 british-thermal-unit btu btus

	 ;; Units of current
	 ampere A amp amps amperes

	 ;; Units of electric charge
	 coulomb C coulombs

	 ;; Units of electric potential
	 volt V volts

	 ;; Units of resistance
	 ohm ohms

	 ;; Units of capacitance
	 farad F farads
	 microfarad uF microfarads
	 picofarad pF picofarads

	 ;; Units of conductance
	 siemens S mho

	 ;; Units of inductance
	 henry H
	 millihenry mH
	 microhenry uH

	 ;; Units of substance
	 mole mol moles

	 ;; Units of density
	 rho

	 ;; Units of concentration
	 molarity M mol/L
	 parts-per-million ppm

	 ;; Units of temperature
	 degK K

	 ;; Units of information quantity, evidence, and information entropy

	 ;; bit = log_2(p)     (Shannon)
	 bit b bits shannon shannons Sh

	 ;; byte = 8 bits
	 byte B bytes

	 ;; nat = log_e(p)     (Boulton and Wallace)
	 nat nats nit nits nepit nepits

	 ;; ban = log_10(p)    (Hartley, Turing, and Good)
	 ban bans hartley hartleys Hart Harts dit dits

	 ;; The deciban is the smallest weight of evidence discernible by a human
	 ;; deciban = 10*log_10(p)
	 deciban db decibans

	 ;; IEC standard prefixes
	 kibi   
	 mebi   
	 gibi   
	 tebi   
	 pebi   
	 exbi   
	 zebi   
	 yobi   

	 ;; bits
	 kilobit kb kilobits
	 megabit Mb megabits
	 gigabit Gb gigabits
	 terabit Tb terabits
	 petabit  Pb petabits
	 exabit	  Eb exabits  
	 zettabit Zb zettabits
	 yottabit Yb yottabits
	 kibibit  Kib kibibits
	 mebibit  Mib mebibits
	 gibibit  Gib gibibits
	 tebibit  Tib tebibits
	 pebibit  Pib pebibits
	 exbibit  Eib exbibits
	 zebibit  Zib zebibits
	 yobibit  Yib yobibits

	 ;; bytes
	 kilobyte   kB kilobytes 
	 megabyte   MB megabytes 
	 gigabyte   GB gigabytes 
	 terabyte   TB terabytes 
	 petabyte   PB petabytes 
	 exabyte    EB exabytes  
	 zettabyte  ZB zettabytes
	 yottabyte  YB yottabytes
	 kibibyte   KiB kibibytes
	 mebibyte   MiB mebibytes
	 gibibyte   GiB gibibytes
	 tebibyte   TiB tebibytes
	 pebibyte   PiB pebibytes
	 exbibyte   EiB exbibytes
	 zebibyte   ZiB zebibytes
	 yobibyte   YiB yobibytes

	 ;; bit rates
	 bits-per-second       bps 
	 kilobits-per-second   kbps
	 megabits-per-second   Mbps
	 gigabits-per-second   Gbps
	 terabits-per-second   Tbps
	 petabits-per-second   Pbps
	 exabits-per-second    Ebps
	 zettabits-per-second  Zbps
	 yottabits-per-second  Ybps
			            
	 ;; byte rates	            
	 bytes-per-second      Bps 
	 kilobytes-per-second  kBps
	 megabytes-per-second  MBps
	 gigabytes-per-second  GBps
	 terabytes-per-second  TBps
	 petabytes-per-second  PBps
	 exabytes-per-second   EBps
	 zettabytes-per-second ZBps
	 yottabytes-per-second YBps
	 
	 )
	

   (import scheme chicken data-structures extras srfi-4)

   (require-extension datatype matchable srfi-4)	
   (import-for-syntax matchable chicken)	

(define pi 3.14159265358979)


(define (unitconv:error x . rest)
  (let ((port (open-output-string)))
    (let loop ((objs (cons x rest)))
      (if (null? objs)
	  (begin
	    (newline port)
	    (error 'unitconv (get-output-string port)))
	  (begin (display (car objs) port)
		 (display " " port)
		 (loop (cdr objs)))))))



(define-record-type quantity
  (make-quantity name int)
  quantity?
  (name quantity-name)
  (int quantity-int))

(define-record-printer (quantity x out)
  (if (zero? (quantity-int x))
      (fprintf out "#(quantity Unity)")
      (fprintf out "#(quantity ~S ~S)"
	       (quantity-name x)
	       (quantity-int x))))


;; The number of base quantities defined
(define Q 9)

(define dref s32vector-ref)

;; The sizes of the field assigned to each base quantity; a field size
;; of 20 allows a value range of +-9 for the power of that quantity
(define dimsizes  (s32vector 20 20 20 10 10 10 10 10 20))

;; Multipliers that can be used to move a vector value to its proper
;; field position; defined as follows:
;;
;;  dimvals_{0} = 1
;;  dimvals_{i} = dimvals_{i-1} * dimsizes_{i-1}   i > 0
;;
(define dimvals  (let loop ((i 1) (lst (list 1)))
		   (if (< i Q)
		       (let ((x  (* (car lst) (dref dimsizes (- i 1)))))
			 (loop (+ 1 i) (cons x lst)))
		       (list->s32vector (reverse lst)))))

;; (s32vector 1 20 400 8000 80000 800000 8000000 80000000))

;; A value that, when added to a dimension integer will make it
;; positive and will bias each vector component within its field by
;; half the size of the field; defined as:
;;
;;  dimbias = sum_{i=0}^{7}\frac{dimvals_{i} * dimsizes_{i}}{2}
;;

(define dimbias  (let loop ((i 0)  (sum 0))
		   (if (< i Q)
		       (loop (+ i 1) (+ sum (/ (* (dref dimvals i) (dref dimsizes i)) 2)))
		       sum)))
		       

;; 444444210

;; Compute a dimension integer from a dimension vector
;;
;; For example, the dimension integer for force can be calculated as
;; follows:
;;
;; force = length * time^{-2} * mass
;;
;; (dimint (s32vector 1 -2 0 1 0 0 0 0))
;; => 7961
;;
(define (dimint v)
  (let loop ((i (- Q 1)) (sum 0))
    (if (fx<= 0 i)
	(loop (fx- i 1)  (+ sum (* (dref dimvals i) (dref v i))))
	sum)))


(define-syntax define-base-quantity
  (lambda (x r c)
    (let ((name   (cadr x))
	  (value  (caddr x))
	  (%define (r 'define)))
      `(,%define ,name (make-quantity ',name ,value)))))


(define-base-quantity  Unity          0)
(define-base-quantity  Length         (dref dimvals 0))
(define-base-quantity  Time           (dref dimvals 1))
(define-base-quantity  Temperature    (dref dimvals 2))
(define-base-quantity  Mass           (dref dimvals 3))
(define-base-quantity  Current        (dref dimvals 4))
(define-base-quantity  Luminosity     (dref dimvals 5))
(define-base-quantity  Substance      (dref dimvals 6))
(define-base-quantity  Currency       (dref dimvals 7))
(define-base-quantity  Information    (dref dimvals 8))


(define-record-type unit
  (make-unit name dims factor abbrevs)
  unit?
  (name     unit-name)
  (dims     unit-dims)
  (factor   unit-factor)
  (abbrevs  unit-abbrevs))


(define (unit-equal? x y)
  (and (= (quantity-int (unit-dims x)) 
	  (quantity-int (unit-dims y)))
       (< (abs (- (unit-factor x) (unit-factor y))) 1e-16)))


(define (unitless? u)
  (assert (unit? u))
  (= (quantity-int Unity) (quantity-int (unit-dims u))))

(define (unit* u1 u2)
  (cond ((unitless? u1) u2)
	((unitless? u2) u1)
	(else (assert (and (unit? u1) (unit? u2)))
	      (make-unit (gensym "u")  
			 (make-quantity (gensym "q")
					(+ (quantity-int (unit-dims u1)) 
					   (quantity-int (unit-dims u2))))
			 (* (unit-factor u1) (unit-factor u2))  
                         '())
	      )))


(define (unit-invert u)
  (assert (unit? u))
    (make-unit (gensym "u")  
	       (make-quantity (gensym "q") (- (quantity-int (unit-dims u)) ))
	       (/ 1 (unit-factor u)) 
	       '()))


(define (unit/ u1 u2)
  (assert (and (unit? u1) (unit? u2)))
  (cond ((unitless? u1)
	 (let ((v2 (unit-factor u2)))
	   (make-unit (gensym "u") (unit-dims u2) (/ 1 v2) '())))

	((unitless? u2) u1)

	(else  (assert (and (unit? u1) (unit? u2)))
	       (unit* u1 (unit-invert u2)))

        ))

(define (unit-expt u p)
  (cond ((unitless? u) u)
	(else (assert (unit? u) )
	      (make-unit (gensym "u")
			 (make-quantity (gensym "q")
					(* (quantity-int (unit-dims u)) p))
			 (expt (unit-factor u) p)
			 '()))))

  
(define-record-printer (unit x out)
  (let ((dims     (unit-dims x))
	(abbrevs  (unit-abbrevs x)))
    (if (null? abbrevs)
	(fprintf out "#(unit ~S " (unit-name x))
	(fprintf out "#(unit ~S ~S " (unit-name x) (unit-abbrevs x)))
    (fprintf out "[~S] ~S)"
	   (quantity-name (unit-dims x))
	   (unit-factor x))))



(define (unit-prefix prefix u abbrevs)
  (or (and (unit? prefix) (unit? u)) 
      (unitconv:error 'unit-prefix ": invalid unit: " u))
  (if (not (= 0 (quantity-int (unit-dims prefix))))
      (unitconv:error 'unit-prefix ": prefix must be dimensionless: " prefix))
  (if (zero? (quantity-int (unit-dims u)))
      (unitconv:error 'unit-prefix ": unit must not be dimensionless: " u))
  (make-unit (string->symbol
	      (string-append (symbol->string (unit-name prefix))
			     (symbol->string (unit-name u))))
	     (unit-dims u)
	     (* (unit-factor prefix) (unit-factor u))
	     abbrevs))
      

;;
;; Unit conversion
;;
(define (unit-convert src dest . vals)
  (or (and (unit? src) (unit? dest)) 
      (unitconv:error 'unit-convert ": invalid unit: " src dest))
  (if (= (quantity-int (unit-dims src)) (quantity-int (unit-dims dest)))
      (let ((f  (/ (unit-factor src) (unit-factor dest))))
	(if (null? vals)  f
	    ((lambda (x) (if (null? (cdr x)) (car x) x)) 
	     (map (lambda (x) (* f x)) vals))))
      (unitconv:error 'unit-convert 
		      ": given units are of different dimensions: source=" 
		      src "; dest= " dest)))


(define-syntax quantity-expr-eval
  (lambda (x r c)
    (let ((expr       (cadr x))
	  (left?      (caddr x))
	  (%let       (r 'let))
	  (%cond      (r 'cond))
	  (%else      (r 'else))
	  (integer?   (r 'integer?))
	  (not        (r 'not))
	  (and        (r 'and))
	  (x1         (r 'x1))
	  (y1         (r 'y1))
	  (quantity-expr-eval    (r 'quantity-expr-eval))
	  (quantity?       (r 'quantity?))
	  (quantity-int    (r 'quantity-int))
          )
      (match expr 
	     ((op x y)
	      `(,%let ((,x1  (,quantity-expr-eval ,x #t))
		       (,y1  (,quantity-expr-eval ,y #f)))
		 ,(case op 
		    ((**)    `(* ,x1 ,y1))
		    ((*)     `(+ ,x1 ,y1))
		    ((/)     `(- ,x1 ,y1))
		    (else (unitconv:error 'quantity-expr-eval ": unknown quantity operation " op)))))
	     
	     (x
	      `(,%cond ((,quantity? ,x)    (,quantity-int ,x))
		       ((,and (,not ,left?) (,integer? ,x)) ,x)
		       ((,and ,left? (,integer? ,x))     
			(unitconv:error 'quantity-expr-eval 
					"integers are not allowed as the left operand of quantity expression" (quote ,x)))
		       (,%else  (unitconv:error 'quantity-expr-eval ": unknown quantity " ,x))))))))
	 
  

(define-syntax define-quantity
  (lambda (x r c)
    (let ((name (cadr x))
	  (expr (caddr x))
	  (%define (r 'define))
	  (make-quantity (r 'make-quantity))
	  (quantity-expr-eval (r 'quantity-expr-eval)))
      `(,%define ,name (,make-quantity ',name (,quantity-expr-eval ,expr #f))))))


(define-for-syntax (binop-fold op lst)
  (if (null? lst) lst
      (match lst
	     ((x)   x)
	     ((x y) `(,op ,x ,y))
	     ((x y . rest) `(,op (,op ,x ,y) ,(binop-fold op rest)))
	     ((x . rest) `(,op ,x ,(binop-fold op rest))))))


(define-syntax unit-factor-eval
  (lambda (x r c)
    (let ((expr (cadr x))
	  (%let       (r 'let))
	  (%cond      (r 'cond))
	  (%else      (r 'else))
	  (x1         (r 'x1))
	  (y1         (r 'y1))
	  (unit?        (r 'unit?))
	  (unit-factor  (r 'unit-factor))
	  (number?      (r 'number?)))
      (match expr 
	     ((op x y)  
	      `(,%let ((,x1  (unit-factor-eval ,x))
		       (,y1  (unit-factor-eval ,y)))
		 ,(case op 
		    ((*)     `(* ,x1 ,y1))
		    ((/)     `(/ ,x1 ,y1))
		    (else (unitconv:error 'unit-factor-eval ": unknown unit factor operation " op)))))
	     
	     ((op x . y) 
	      `(unit-factor-eval ,(binop-fold op (cons x y))))

	     (x         `(cond ((,unit? ,x)    
				(,unit-factor ,x))
			       ((,number? ,x)  ,x)
			       (else  (unitconv:error 'unit-factor-eval ": unknown unit " ,x))))

             (else (error 'unit-factor-eval "invalid unit factor expression" expr)))
      )))
	 
  

(define-syntax unit-factor-dim
  (lambda (x r c)
    (let ((expr (cadr x))
	  (%let       (r 'let))
	  (%cond      (r 'cond))
	  (%else      (r 'else))
	  (%print     (r 'print))
	  (x1         (r 'x1))
	  (y1         (r 'y1))
	  (unit?      (r 'unit?))
	  (unit-dims  (r 'unit-dims))
	  (quantity-int  (r 'quantity-int))
	  (number?    (r 'number?)))

      (match expr 
	     ((op x y)  
	      `(,%let ((,x1  (unit-factor-dim ,x))
		       (,y1  (unit-factor-dim ,y)))
		 ,(case op 
		    ((*)     `(+ ,x1 ,y1))
		    ((/)     `(- ,x1 ,y1))
		    (else (unitconv:error 'unit-factor-dim ": unknown unit factor operation " op)))))
	     
	     ((op x . y) 
	      `(unit-factor-dim ,(binop-fold op (cons x y))))

	     (x         `(cond ((,unit? ,x)    
				(,quantity-int (,unit-dims ,x)))
			       ((,number? ,x)  0)
			       (else  (unitconv:error 'unit-factor-dim ": unknown unit " ,x))))
             (else (error 'unit-factor-dim "invalid unit factor expression" expr)))
      )))
	 

(define-syntax make-unit-prefix
  (lambda (x r c)
    (let ((prefix (cadr x))
	  (unit (caddr x))
	  (abbrevs (cdddr x)))
      `(unit-prefix ,prefix ,unit ',abbrevs))))


(define-syntax define-unit
  (lambda (x r c)
    (let ((name    (cadr x))
	  (dims    (caddr x))
	  (factor  (cadddr x))
	  (abbrevs (cddddr x))
	  (%factordim  (r 'factordim))
	  (%if     (r 'if))
	  (%define (r 'define))
	  (%let    (r 'let))
	  (%begin  (r 'begin))
          )
      
      `(,%begin 
	(,%define ,name (,%let
                         ((,%factordim (unit-factor-dim ,factor)))
                         (,%if (or (zero? ,%factordim) (= ,%factordim (quantity-int ,dims)))
                               (make-unit ',name ,dims (unit-factor-eval ,factor) ',abbrevs) 
                               (unitconv:error 'define-unit "unit dimension mismatch" ,dims ,%factordim))))
	,@(map (lambda (abbrev) `(,%define ,abbrev ,name)) abbrevs)))))


(define-syntax define-unit-prefix
  (lambda (x r c)
    (let ((prefix  (cadr x))
	  (unit    (caddr x))
	  (abbrevs (cdddr x))
	  (%define (r 'define))
	  (%begin (r 'begin)))
      (let ((name (string->symbol (string-append (->string prefix) (->string unit)))))
	`(,%begin
	  (,%define ,name (unit-prefix ,prefix ,unit ',abbrevs))
	  ,@(map (lambda (abbrev) `(,%define ,abbrev ,name)) abbrevs))))))

;;
;; Geometry
;;
(define-quantity   Area     (** Length 2))
(define-quantity   Volume   (** Length 3))

;;
;; Mechanics
;;
(define-quantity   Velocity      (/ Length Time))
(define-quantity   Acceleration  (/ Length (** Time 2)))
(define-quantity   Force         (* Mass Acceleration))
(define-quantity   Pressure      (/ Force Area))
(define-quantity   Energy        (* Force Length))
(define-quantity   Power         (/ Energy Time))

;;
;; Electricity
;;
(define-quantity   Charge         (* Current Time))
(define-quantity   Potential      (/ Energy Charge))
(define-quantity   Capacitance    (/ Charge Potential))
(define-quantity   Resistance     (/ Potential Current))
(define-quantity   Conductance    (/ Current Potential))
(define-quantity   Inductance     (/ (* Potential Time) Current))

;;
;; Chemistry
;;
(define-quantity   Concentration  (/ Substance Volume))
(define-quantity   Density        (/ Mass Volume))

;;
;; Optic
;;
(define-quantity    Luminance     (/ Luminosity Area))

;;
;; Other
;;
(define-quantity    Frequency     (/ Unity Time))

;;
;; Information
;;
(define-quantity    Rate          (/ Information Time))


(define-unit unitless Unity 1.0)
	
;; SI unit prefixes 
(define-unit yocto  Unity 1.0e-24)
(define-unit zepto  Unity 1.0e-21)
(define-unit atto   Unity 1.0e-18)
(define-unit femto  Unity 1.0e-15)
(define-unit pico   Unity 1.0e-12)
(define-unit nano   Unity 1.0e-9)
(define-unit micro  Unity 1.0e-6)
(define-unit milli  Unity 1.0e-3)
(define-unit centi  Unity 1.0e-2)
(define-unit deci   Unity 1.0e-1)
(define-unit deca   Unity  1.0e1)
(define-unit hecto  Unity  1.0e2)
(define-unit kilo   Unity  1.0e3)
(define-unit mega   Unity  1.0e6)
(define-unit giga   Unity  1.0e9)
(define-unit tera   Unity  1.0e12)
(define-unit peta   Unity  1.0e15)
(define-unit exa    Unity  1.0e18)
(define-unit zetta  Unity  1.0e21)
(define-unit yotta  Unity  1.0e24)

;; IEC standard prefixes
(define-unit kibi   Unity  1024)
(define-unit mebi   Unity  1048576)
(define-unit gibi   Unity  1073741824)
(define-unit tebi   Unity  1099511627776)
(define-unit pebi   Unity  1125899906842624)
(define-unit exbi   Unity  1152921504606846976)
(define-unit zebi   Unity  1180591620717411303424)
(define-unit yobi   Unity  1208925819614629174706176)

;; Time multiples
(define-unit twelve Unity 12)
(define-unit sixty  Unity 60)

;; Angles (dimensionless ratio)
(define-unit radian     Unity  1.0  rad radians)
(define-unit degree     Unity  (/ pi 180)  deg degrees)
(define-unit arcminute  Unity  (/ degree 60)  arcmin amin MOA)
(define-unit arcsecond  Unity  (/ arcminute 60)  arcsec)
(define-unit grad       Unity  (/ pi 200)  gon grd)

;; Units of length
(define-unit meter     Length 1.0       m meters)
(define-unit inch      Length 0.0254    in inches)
(define-unit foot      Length 0.3048    ft feet)
(define-unit angstrom  Length 1.0e-10   ang angstroms)
(define-unit parsec    Length 3.083e16  parsecs)
(define-unit-prefix    centi meter cm centimeters)
(define-unit-prefix    milli meter mm millimeters)
(define-unit-prefix    micro meter um micron microns micrometers)

;; Units of area and volume
(define-unit square-meter  Area (* meter meter) m^2 m2 meter-squared meters-squared square-meters)
(define-unit square-inch   Area  (* inch inch) in^2 inch-squared inches-squared square-inches)
(define-unit square-micron Area (* micrometer micrometer) um^2 micrometer-squared
                                micrometers-squared micron-squared microns-squared square-microns)
(define-unit square-millimeter Area (* millimeter millimeter) mm^2 millimeter-squared millimeters-squared
                                                              square-millimeters)
(define-unit square-centimeter Area (* centimeter centimeter) cm^2 centimeter-squared centimeters-squared
                                                              square-centimeters)

(define-unit cubic-meter   Volume  (* meter (* meter meter)) m^3 meter-cubed meters-cubed cubic-meters )
(define-unit liter         Volume  (* 0.001 cubic-meter) L litre liters)

;; Units of mass
(define-unit kilogram     Mass  1.0       kg kilograms)
(define-unit gram         Mass  1e-3      g grams)
(define-unit-prefix       milli gram mg milligrams)
(define-unit pound        Mass  (* gram 453.59237) lb pounds)
(define-unit slug         Mass  (* pound 32.17405) slugs)
(define-unit atomic-mass-unit Mass 1.6605402e-27 amu atomic-mass-units)

;; Units of time
(define-unit second       Time  1.0       s seconds)
(define-unit hour         Time  (* sixty (* sixty second)) h hrs hours)

;; Units of acceleration
(define-unit meters-per-second-squared Acceleration (/ meter (* second second)) m/s2 m/s^2 m/sec2 m/sec^2)

;; Units of frequency
(define-unit hertz Frequency 1.0 hz)

;; Units of force
(define-unit newton       Force (/ (* kilogram meter) (* second second)) nt newtons)
(define-unit pound-force  Force (/ (* slug foot) (* second second)) lbf)


;; Units of power
(define-unit watt         Power (/ (* kilogram meter meter)
				   (* second second second))  W watts)
(define-unit horsepower   Power (* 550 (/ (* foot pound-force) second)) hp)

;; Units of energy
(define-unit joule Energy  (* newton meter) J joules)
(define-unit electron-volt Energy  (* 1.60217733e-19 joule) ev electron-volts)
(define-unit kilowatt-hour Energy  (* kilo (* watt hour)) kwh kilowatt-hours)
(define-unit calorie       Energy  (* 4.184 joule) cal calories)
(define-unit erg           Energy  (* 1.0e-7 joule) ergs)
(define-unit british-thermal-unit Energy (* 1055.056 joule) btu btus)

;; Units of current
(define-unit ampere  Current 1.0 A amp amps amperes)

;; Units of electric charge
(define-unit coulomb Charge  (* ampere second) C coulombs)

;; Units of electric potential
(define-unit volt Potential  (/ (* kilogram meter meter)
				(* ampere second second second)) V volts)

;; Units of resistance
(define-unit ohm Resistance  (/ volt ampere) ohms)

;; Units of capacitance
(define-unit farad Capacitance  (/ coulomb volt) F farads)
(define-unit-prefix micro farad uF microfarads)
(define-unit-prefix pico farad pF picofarads)

;; Units of conductance
(define-unit siemens Conductance (/ ampere volt) S mho)

;; Units of inductance
(define-unit henry Inductance  (/ (* meter meter kilogram)
				  (* ampere ampere second second)) H)
(define-unit-prefix milli henry mH)
(define-unit-prefix micro henry uH)

;; Units of substance
(define-unit mole Substance 1.0 mol moles)

;; Units of density
(define-unit rho Density (/ kilogram cubic-meter))

;; Units of concentration
(define-unit molarity Concentration (/ mole liter) M mol/L)
(define-unit parts-per-million Concentration (/ milligram kilogram) ppm)

;; Units of temperature
(define-unit degK       Temperature  1.0       K)

;; Units of information quantity, evidence, and information entropy

;; bit = log_2(p)     (Shannon)
(define-unit bit      Information  1                 b bits 
  shannon shannons Sh)

;; byte = 8 bits
(define-unit byte     Information  8                 B bytes)

;; nat = log_e(p)     (Boulton and Wallace)
(define-unit nat      Information  1.44269504088896  nats
  nit nits
  nepit nepits)

;; ban = log_10(p)    (Hartley, Turing, and Good)
(define-unit ban      Information  3.32192809488736  bans
  hartley hartleys
  Hart Harts
  dit dits)

;; The deciban is the smallest weight of evidence discernible by a human
;; deciban = 10*log_10(p)
(define-unit deciban  Information  (/ ban 10)        db decibans)

;; bits
(define-unit-prefix kilo  bit   kb kilobits)
(define-unit-prefix mega  bit   Mb megabits)
(define-unit-prefix giga  bit   Gb gigabits)
(define-unit-prefix tera  bit   Tb terabits)
(define-unit-prefix peta  bit   Pb petabits)
(define-unit-prefix exa   bit   Eb exabits)
(define-unit-prefix zetta bit   Zb zettabits)
(define-unit-prefix yotta bit   Yb yottabits)
(define-unit-prefix kibi  bit   Kib kibibits)
(define-unit-prefix mebi  bit   Mib mebibits)
(define-unit-prefix gibi  bit   Gib gibibits)
(define-unit-prefix tebi  bit   Tib tebibits)
(define-unit-prefix pebi  bit   Pib pebibits)
(define-unit-prefix exbi  bit   Eib exbibits)
(define-unit-prefix zebi  bit   Zib zebibits)
(define-unit-prefix yobi  bit   Yib yobibits)

;; bytes
(define-unit-prefix kilo  byte  kB kilobytes)
(define-unit-prefix mega  byte  MB megabytes)
(define-unit-prefix giga  byte  GB gigabytes)
(define-unit-prefix tera  byte  TB terabytes)
(define-unit-prefix peta  byte  PB petabytes)
(define-unit-prefix exa   byte  EB exabytes)
(define-unit-prefix zetta byte  ZB zettabytes)
(define-unit-prefix yotta byte  YB yottabytes)
(define-unit-prefix kibi  byte  KiB kibibytes)
(define-unit-prefix mebi  byte  MiB mebibytes)
(define-unit-prefix gibi  byte  GiB gibibytes)
(define-unit-prefix tebi  byte  TiB tebibytes)
(define-unit-prefix pebi  byte  PiB pebibytes)
(define-unit-prefix exbi  byte  EiB exbibytes)
(define-unit-prefix zebi  byte  ZiB zebibytes)
(define-unit-prefix yobi  byte  YiB yobibytes)

;; bit rates
(define-unit       bits-per-second  Rate  (/ bit       second)  bps)
(define-unit   kilobits-per-second  Rate  (/ kilobit   second)  kbps)
(define-unit   megabits-per-second  Rate  (/ megabit   second)  Mbps)
(define-unit   gigabits-per-second  Rate  (/ gigabit   second)  Gbps)
(define-unit   terabits-per-second  Rate  (/ terabit   second)  Tbps)
(define-unit   petabits-per-second  Rate  (/ petabit   second)  Pbps)
(define-unit    exabits-per-second  Rate  (/ exabit    second)  Ebps)
(define-unit  zettabits-per-second  Rate  (/ zettabit  second)  Zbps)
(define-unit  yottabits-per-second  Rate  (/ yottabit  second)  Ybps)

;; byte rates
(define-unit      bytes-per-second  Rate  (/ byte      second)  Bps)
(define-unit  kilobytes-per-second  Rate  (/ kilobyte  second)  kBps)
(define-unit  megabytes-per-second  Rate  (/ megabyte  second)  MBps)
(define-unit  gigabytes-per-second  Rate  (/ gigabyte  second)  GBps)
(define-unit  terabytes-per-second  Rate  (/ terabyte  second)  TBps)
(define-unit  petabytes-per-second  Rate  (/ petabyte  second)  PBps)
(define-unit   exabytes-per-second  Rate  (/ exabyte   second)  EBps)
(define-unit zettabytes-per-second  Rate  (/ zettabyte second)  ZBps)
(define-unit yottabytes-per-second  Rate  (/ yottabyte second)  YBps)



)
