(use unitconv)


(define-unit-prefix    milli second  ms)
(define-unit-prefix    milli volt    mV)
(define-unit-prefix    milli amp     mA)
(define-unit-prefix    nano amp      nA)
(define-unit-prefix    micro siemens uS)
(define-unit-prefix    milli mole    mM)
(define-unit-prefix    micro farad   uF)
(define-unit-prefix    micro siemens uS)

(define-quantity   CurrentDensity        (/ Current Area))
(define-quantity   CapacitanceArea       (/ Capacitance Area))
(define-quantity   ConductanceArea       (/ Conductance Area))
(define-quantity   Resistivity           (* Resistance Length))

(define-unit milliamp-per-square-centimeter   CurrentDensity  (/ mA (* cm cm)) mA/cm2)
(define-unit microfarad-per-square-centimeter CapacitanceArea (/ uF (* cm cm)) uf/cm2)
(define-unit siemens-per-square-centimeter    ConductanceArea (/ S (* cm cm)) S/cm2)
(define-unit ohm.cm                           Resistivity     (* ohm cm) ohm.cm)

(define-unit amp-per-square-meter CurrentDensity (/ A (* m m)) A/m2)

(print milliamp-per-square-centimeter)
(print amp-per-square-meter)

(print (unit-convert amp-per-square-meter milliamp-per-square-centimeter))

(print Frequency)
(print (unit* millisecond hertz))
(print (quantity-int (unit-dims (unit* millisecond hertz))))
