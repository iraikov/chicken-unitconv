# unitconv

Conversion of units of measurement.

## Documentation

The `unitconv` library is an implementation of unit conversion
routines based on the paper by Gordon S. Novak:

 Conversion of Units of Measurement.
 IEEE Trans. on Software Engineering, vol. 21, no. 8 (Aug. 1995), pp. 651-661.

(Available online at http://www.cs.utexas.edu/users/novak/units95.html). 

Correctness of unit conversion is established by the technique of
dimensional analysis: the source and goal units must have the same
dimensions. Following Novak, this extension defines a dimension as an
8-vector of integral powers of the following base quantities:

```scheme
 (define-base-quantity  Unity          0)
 (define-base-quantity  Length         dimvals[0])
 (define-base-quantity  Time           dimvals[1])
 (define-base-quantity  Temperature    dimvals[2])
 (define-base-quantity  Mass           dimvals[3])
 (define-base-quantity  Current        dimvals[4])
 (define-base-quantity  Luminosity     dimvals[5])
 (define-base-quantity  Substance      dimvals[6])
 (define-base-quantity  Currency       dimvals[7])
 (define-base-quantity  Information    dimvals[8])
```

The unit conversion routine uses dimension integers to check that the
requested unit conversion is legitimate. For example, the conversion
from kilograms to meters illegal. Consequently, the dimensionality of
each unit must be specified when the unit is declared.

```scheme
 ;; Syntax is (define-unit name quantity factor abbreviation ...)
 
 ;; define units of length
 (define-unit meter     Length 1.0       m meters)
 (define-unit inch      Length 0.0254    in inches)
 
 ;; define units of mass and time
 (define-unit kilogram  Mass   1.0       kg kilograms)
 (define-unit second    Time   1.0       s seconds)
 
 ;; define two new derived quantities: acceleration and force
 (define-quantity   Acceleration  (/ Length (** Time 2)))
 (define-quantity   Force         (* Mass Acceleration))
 
 ;; define a unit of force
 (define-unit newton       Force (/ (* kilogram meter) (* second second)) nt newtons)
```

Now only conversion between units of the same dimensionality is permitted: 

```scheme
 (unit-convert meter inch 1) ->  39.3700787401575
 (unit-convert meter inch 2 3 4) ->  (78.740157480315 118.110236220472 157.48031496063)
 
 (unit-convert meter kilogram 1)
 Error: (unitconv) unit-convert : given units are of different dimensions: 
  source= #(unit meter (m meters) [Length] 1.0) ; 
  dest=  #(unit kilogram (kg kilograms) [Mass] 1.0)
```

## Procedures and Macros


<procedure>unit-convert:: SRC * DEST * [VAL1 ...] -> (FACTOR1 ... )</procedure>

Converts the given numeric values expressed in unit `SRC` to their equivalents in unit `DEST`. 

Arguments `SRC, DEST` are records of type `unit`. See the
definitions below for information about the units that are defined by
this extension, as well as for information about creating new units.


<procedure>unit-equal?:: UNIT1 * UNIT2 -> BOOL</procedure>
Returns true if the two units have the same dimension and factor, false otherwise. 


<macro>(define-quantity name expr)</macro>

Defines a derivative quantity `NAME`. 

`EXPR` is an S-expression with the following syntax: 
 
  quantity-expr ::=  base-quantity
                   | derived-quantity
                   | (* quantity-expr quantity-expr)
                   | (* quantity-expr integer)
                   | (/ quantity-expr quantity-expr)
                   | (/ quantity-expr integer)
                   | (** quantity-expr integer) 

where 

- `base-quantity` : one of the predefined base quantities
- `derived-quantity` : a quantity created by `define-quantity`
- `**` : exponentiation operator

<macro>(define-unit name dims factor . abbrevs)</macro>

Defines a variable `NAME` that holds a unit definition of a unit with the given dimension and factor. 

`DIMS` can be either one of the base quantities (see next section)  or a derivative quantity created by `define-quantity`. 

<macro>(define-prefix-unit unit prefix . abbrevs)</macro>

Defines a variable whose name is the concatenated `PREFIX` and `UNIT` and that holds a unit definition of the given unit and prefix. 



## Predefined Quantities


### Base Quantities

- `Unity`  (dimensionless)
- `Length`
- `Time`
- `Temperature`
- `Mass`
- `Current`
- `Luminosity`
- `Substance`
- `Currency`
- `Information`

### Derived Quantities

#### Geometry
- `Area` : `(** Length 2)`
- `Volume` : `(** Length 3)`

#### Mechanics
- `Velocity` : `(/ Length Time)`
- `Acceleration` : `(/ Length (** Time 2))`
- `Force` : `(* Mass Acceleration)`
- `Pressure` : `(/ Force Area)`
- `Energy` : `(* Force Length)`
- `Power` : `(/ Energy Time)`

#### Electricity
- `Charge` : `(* Current Time)`
- `Potential` : `(/ Energy Charge)`
- `Capacitance` : `(/ Charge Potential)`
- `Resistance` : `(/ Potential Current)`
- `Conductance` : `(/ Current Potential)`
- `Inductance` : `(/ (* Potential Time) Current)`

#### Chemistry
- `Concentration` : `(/ Substance Volume)`
- `Density` : `(/ Mass Volume)`

#### Optics
- `Luminance` : `(/ Luminosity Area)`

#### Other
- `Frequency` : `(/ Unity Time)`
- `Rate` : `(/ Information Time)`


## Predefined Units

### SI Unit Prefixes

<table style="table { table-layout: fixed; }">
<col width="25%" /><col width="25%" /><col width="25%" /><col width="25%" />
<tr><th>Name</th><th>Quantity</th><th>Factor</th><th">Abbreviation(s)</th></tr>
<tr><td>yocto</td><td>Unity</td><td>1e-24</td><td></td></tr>
<tr><td>zepto</td><td>Unity</td><td>1e-21</td><td></td></tr>
<tr><td>atto</td><td>Unity</td><td>1e-18</td><td></td></tr>
<tr><td>femto</td><td>Unity</td><td>1e-15</td><td></td></tr>
<tr><td>pico</td><td>Unity</td><td>1e-12</td><td></td></tr>
<tr><td>nano</td><td>Unity</td><td>1e-09</td><td></td></tr>
<tr><td>micro</td><td>Unity</td><td>1e-06</td><td></td></tr>
<tr><td>milli</td><td>Unity</td><td>0.001</td><td></td></tr>
<tr><td>centi</td><td>Unity</td><td>0.01</td><td></td></tr>
<tr><td>deci</td><td>Unity</td><td>0.1</td><td></td></tr>
<tr><td>deca</td><td>Unity</td><td>10.0</td><td></td></tr>
<tr><td>hecto</td><td>Unity</td><td>100.0</td><td></td></tr>
<tr><td>kilo</td><td>Unity</td><td>1000.0</td><td></td></tr>
<tr><td>mega</td><td>Unity</td><td>1000000.0</td><td></td></tr>
<tr><td>giga</td><td>Unity</td><td>1000000000.0</td><td></td></tr>
<tr><td>tera</td><td>Unity</td><td>1000000000000.0</td><td></td></tr>
<tr><td>peta</td><td>Unity</td><td>1e+15</td><td></td></tr>
<tr><td>exa</td><td>Unity</td><td>1e+18</td><td></td></tr>
<tr><td>zetta</td><td>Unity</td><td>1e+21</td><td></td></tr>
<tr><td>yotta</td><td>Unity</td><td>1e+24</td><td></td></tr>
</table>

### IEC Standard Prefixes

<table style="table { table-layout: fixed; }">
<col width="25%" /><col width="25%" /><col width="25%" /><col width="25%" />
<tr><th>Name</th><th>Quantity</th><th>Factor</th><th>Abbreviation(s)</th></tr>
<tr><td>kibi</td><td>Unity</td><td>1024</td><td></td></tr>
<tr><td>mebi</td><td>Unity</td><td>1048576</td><td></td></tr>
<tr><td>gibi</td><td>Unity</td><td>1073741824.0</td><td></td></tr>
<tr><td>tebi</td><td>Unity</td><td>1099511627776.0</td><td></td></tr>
<tr><td>pebi</td><td>Unity</td><td>1.12589990684262e+15</td><td></td></tr>
<tr><td>exbi</td><td>Unity</td><td>1.15292150460685e+18</td><td></td></tr>
<tr><td>zebi</td><td>Unity</td><td>1.18059162071741e+21</td><td></td></tr>
<tr><td>yobi</td><td>Unity</td><td>1.20892581961463e+24</td><td></td></tr>
</table>

### Time Multiples

<table style="table { table-layout: fixed; }">
<col width="25%" /><col width="25%" /><col width="25%" /><col width="25%" />
<tr><th>Name</th><th>Quantity</th><th>Factor</th><th>Abbreviation(s)</th></tr>
<tr><td>twelve</td><td>Unity</td><td>12</td><td></td></tr>
<tr><td>sixty</td><td>Unity</td><td>60</td><td></td></tr>
</table>

### Angles

<table style="table { table-layout: fixed; }">
<col width="25%" /><col width="25%" /><col width="25%" /><col width="25%" />
<tr><th>Name</th><th>Quantity</th><th>Factor</th><th>Abbreviation(s)</th></tr>
<tr><th>Name</th><th>Quantity</th><th>Factor</th><th>Abbreviation(s)</th></tr>
<tr><td>radian</td><td>Unity</td><td>1.0</td><td>(rad radians)</td></tr>
<tr><td>degree</td><td>Unity</td><td>(/ pi 180)</td><td>(deg degrees)</td></tr>
</table>

### Units of Length

<table style="table { table-layout: fixed; }">
<col width="25%" /><col width="25%" /><col width="25%" /><col width="25%" />
<tr><th>Name</th><th>Quantity</th><th>Factor</th><th>Abbreviation(s)</th></tr>
<tr><td>meter</td><td>Length</td><td>1.0</td><td>(m meters)</td></tr>
<tr><td>inch</td><td>Length</td><td>0.0254</td><td>(in inches)</td></tr>
<tr><td>foot</td><td>Length</td><td>0.3048</td><td>(ft feet)</td></tr>
<tr><td>angstrom</td><td>Length</td><td>1e-10</td><td>(ang angstroms)</td></tr>
<tr><td>parsec</td><td>Length</td><td>3.083e+16</td><td>(parsecs)</td></tr>
</table>

### Units of Area and Volume

<table style="table { table-layout: fixed; }">
<col width="25%" /><col width="25%" /><col width="25%" /><col width="25%" />
<tr><th>Name</th><th>Quantity</th><th>Factor</th><th>Abbreviation(s)</th></tr>
<tr><td>square-meter</td><td>Area</td><td>(* meter meter)</td><td>(m^2 m2 meter-squared meters-squared square-meters)</td></tr>
<tr><td>square-inch</td><td>Area</td><td>(* inch inch)</td><td>(in^2 inch-squared inches-squared square-inches)</td></tr>
<tr><td>square-micron</td><td>Area</td><td>(* micrometer micrometer)</td><td>(um^2 micrometer-squared micrometers-squared micron-squared microns-squared square-microns)</td></tr>
<tr><td>square-millimeter</td><td>Area</td><td>(* millimeter millimeter)</td><td>(mm^2 millimeter-squared millimeters-squared square-millimeters)</td></tr>
<tr><td>cubic-meter</td><td>Volume</td><td>(* meter (* meter meter))</td><td>(m^3 meter-cubed meters-cubed cubic-meters)</td></tr>
<tr><td>liter</td><td>Volume</td><td>(* 0.001 cubic-meter)</td><td>(L litre liters)</td></tr>
</table>

### Units of Mass

<table style="table { table-layout: fixed; }">
<col width="25%" /><col width="25%" /><col width="25%" /><col width="25%" />
<tr><th>Name</th><th>Quantity</th><th>Factor</th><th>Abbreviation(s)</th></tr>
<tr><td>kilogram</td><td>Mass</td><td>1.0</td><td>(kg kilograms)</td></tr>
<tr><td>gram</td><td>Mass</td><td>0.001</td><td>(g grams)</td></tr>
<tr><td>pound</td><td>Mass</td><td>(* gram 453.59237)</td><td>(lb pounds)</td></tr>
<tr><td>slug</td><td>Mass</td><td>(* pound 32.17405)</td><td>(slugs)</td></tr>
<tr><td>atomic-mass-unit</td><td>Mass</td><td>1.6605402e-27</td><td>(amu atomic-mass-units)</td></tr>
</table>

### Units of Time

<table style="table { table-layout: fixed; }">
<col width="25%" /><col width="25%" /><col width="25%" /><col width="25%" />
<tr><th>Name</th><th>Quantity</th><th>Factor</th><th>Abbreviation(s)</th></tr>
<tr><td>second</td><td>Time</td><td>1.0</td><td>(s seconds)</td></tr>
<tr><td>hour</td><td>Time</td><td>(* sixty (* sixty second))</td><td>(h hrs hours)</td></tr>
</table>

### Units of Acceleration

<table style="table { table-layout: fixed; }">
<col width="25%" /><col width="25%" /><col width="25%" /><col width="25%" />
<tr><th>Name</th><th>Quantity</th><th>Factor</th><th>Abbreviation(s)</th></tr>
<tr><td>meters-per-second-squared</td><td>Acceleration</td><td>(/ meter (* second second))</td><td>(m/s2 m/s^2 m/sec2 m/sec^2)</td></tr>
</table>

### Units of Frequency

<table style="table { table-layout: fixed; }">
<col width="25%" /><col width="25%" /><col width="25%" /><col width="25%" />
<tr><th>Name</th><th>Quantity</th><th>Factor</th><th>Abbreviation(s)</th></tr>
<tr><td>hertz</td><td>Frequency</td><td>1.0</td><td>(hz)</td></tr>
</table>

### Units of Force

<table style="table { table-layout: fixed; }">
<col width="25%" /><col width="25%" /><col width="25%" /><col width="25%" />
<tr><th>Name</th><th>Quantity</th><th>Factor</th><th>Abbreviation(s)</th></tr>
<tr><td>newton</td><td>Force</td><td>(/ (* kilogram meter) (* second second))</td><td>(nt newtons)</td></tr>
<tr><td>pound-force</td><td>Force</td><td>(/ (* slug foot) (* second second))</td><td>(lbf)</td></tr>
</table>

### Units of Power

<table style="table { table-layout: fixed; }">
<col width="25%" /><col width="25%" /><col width="25%" /><col width="25%" />
<tr><th>Name</th><th>Quantity</th><th>Factor</th><th>Abbreviation(s)</th></tr>
<tr><td>watt</td><td>Power</td><td>(/ (* kilogram meter meter) (* second second second))</td><td>(W watts)</td></tr>
<tr><td>horsepower</td><td>Power</td><td>(* 550 (/ (* foot pound-force) second))</td><td>(hp)</td></tr>
</table>

### Units of Energy

<table style="table { table-layout: fixed; }">
<col width="25%" /><col width="25%" /><col width="25%" /><col width="25%" />
<tr><th>Name</th><th>Quantity</th><th>Factor</th><th>Abbreviation(s)</th></tr>
<tr><td>joule</td><td>Energy</td><td>(* newton meter)</td><td>(J joules)</td></tr>
<tr><td>electron-volt</td><td>Energy</td><td>(* 1.60217733e-19 joule)</td><td>(ev electron-volts)</td></tr>
<tr><td>kilowatt-hour</td><td>Energy</td><td>(* kilo (* watt hour))</td><td>(kwh kilowatt-hours)</td></tr>
<tr><td>calorie</td><td>Energy</td><td>(* 4.184 joule)</td><td>(cal calories)</td></tr>
<tr><td>erg</td><td>Energy</td><td>(* 1e-07 joule)</td><td>(ergs)</td></tr>
<tr><td>british-thermal-unit</td><td>Energy</td><td>(* 1055.056 joule)</td><td>(btu btus)</td></tr>
</table>

### Units of Current

<table style="table { table-layout: fixed; }">
<col width="25%" /><col width="25%" /><col width="25%" /><col width="25%" />
<tr><th>Name</th><th>Quantity</th><th>Factor</th><th>Abbreviation(s)</th></tr>
<tr><td>ampere</td><td>Current</td><td>1.0</td><td>(A amp amps amperes)</td></tr>
</table>

### Units of Electric Charge

<table style="table { table-layout: fixed; }">
<col width="25%" /><col width="25%" /><col width="25%" /><col width="25%" />
<tr><th>Name</th><th>Quantity</th><th>Factor</th><th>Abbreviation(s)</th></tr>
<tr><td>coulomb</td><td>Charge</td><td>(* ampere second)</td><td>(C coulombs)</td></tr>
</table>

### Units of Electric Potential
<table style="table { table-layout: fixed; }">
<col width="25%" /><col width="25%" /><col width="25%" /><col width="25%" />
<tr><th>Name</th><th>Quantity</th><th>Factor</th><th>Abbreviation(s)</th></tr>
<tr><td>volt</td><td>Potential</td><td>(/ (* kilogram meter meter) (* ampere second second second))</td><td>(V volts)</td></tr>
</table>

### Units of Resistance

<table style="table { table-layout: fixed; }">
<col width="25%" /><col width="25%" /><col width="25%" /><col width="25%" />
<tr><th>Name</th><th>Quantity</th><th>Factor</th><th>Abbreviation(s)</th></tr>
<tr><td>ohm</td><td>Resistance</td><td>(/ volt ampere)</td><td>(ohms)</td></tr>
</table>

### Units of Capacitance

<table style="table { table-layout: fixed; }">
<col width="25%" /><col width="25%" /><col width="25%" /><col width="25%" />
<tr><th>Name</th><th>Quantity</th><th>Factor</th><th>Abbreviation(s)</th></tr>
<tr><td>farad</td><td>Capacitance</td><td>(/ coulomb volt)</td><td>(F farads)</td></tr>
</table>

### Units of Conductance

<table style="table { table-layout: fixed; }">
<col width="25%" /><col width="25%" /><col width="25%" /><col width="25%" />
<tr><th>Name</th><th>Quantity</th><th>Factor</th><th>Abbreviation(s)</th></tr>
<tr><td>siemens</td><td>Conductance</td><td>(/ ampere volt)</td><td>(S mho)</td></tr>
</table>

### Units of Inductance

<table style="table { table-layout: fixed; }">
<col width="25%" /><col width="25%" /><col width="25%" /><col width="25%" />
<tr><th>Name</th><th>Quantity</th><th>Factor</th><th>Abbreviation(s)</th></tr>
<tr><td>henry</td><td>Inductance</td><td>(/ (* meter meter kilogram) (* ampere ampere second second))</td><td>(H)</td></tr>
</table>

### Units of Substance

<table style="table { table-layout: fixed; }">
<col width="25%" /><col width="25%" /><col width="25%" /><col width="25%" />
<tr><th>Name</th><th>Quantity</th><th>Factor</th><th>Abbreviation(s)</th></tr>
<tr><td>mole</td><td>Substance</td><td>1.0</td><td>(mol moles)</td></tr>
</table>

### Units of density

<table style="table { table-layout: fixed; }">
<col width="25%" /><col width="25%" /><col width="25%" /><col width="25%" />
<tr><th>Name</th><th>Quantity</th><th>Factor</th><th>Abbreviation(s)</th></tr>
<tr><td>rho</td><td>Density</td><td>(/ kilogram cubic-meter)</td><td></td></tr>
</table>

### Units of concentration

<table style="table { table-layout: fixed; }">
<col width="25%" /><col width="25%" /><col width="25%" /><col width="25%" />
<tr><th>Name</th><th>Quantity</th><th>Factor</th><th>Abbreviation(s)</th></tr>
<tr><td>molarity</td><td>Concentration</td><td>(/ mole liter)</td><td>(M mol/L)</td></tr>
<tr><td>parts-per-million</td><td>Concentration</td><td>(/ milligram kilogram)</td><td>(ppm)</td></tr>
</table>

### Units of temperature

<table style="table { table-layout: fixed; }">
<col width="25%" /><col width="25%" /><col width="25%" /><col width="25%" />
<tr><th>Name</th><th>Quantity</th><th>Factor</th><th>Abbreviation(s)</th></tr>
<tr><td>degK</td><td>Temperature</td><td>1.0</td><td>(K)</td></tr>
</table>

### Units of information

<table style="table { table-layout: fixed; }">
<col width="25%" /><col width="25%" /><col width="25%" /><col width="25%" />
<tr><th>Name</th><th>Quantity</th><th>Factor</th><th>Abbreviation(s)</th></tr>
<tr><td>bit</td><td>Information</td><td>1</td><td>(b bits shannon shannons Sh)</td></tr>
<tr><td>byte</td><td>Information</td><td>8</td><td>(B bytes)</td></tr>
<tr><td>nat</td><td>Information</td><td>1.44269504088896</td><td>(nats nit nits nepit nepits)</td></tr>
<tr><td>ban</td><td>Information</td><td>3.32192809488736</td><td>(bans hartley hartleys Hart Harts dit dits)</td></tr>
</table>

### Units of information rate

<table style="table { table-layout: fixed; }">
<col width="25%" /><col width="25%" /><col width="25%" /><col width="25%" />
<tr><th>Name</th><th>Quantity</th><th>Factor</th><th>Abbreviation(s)</th></tr>
<tr><td>bits-per-second</td><td>Rate</td><td>(/ bit second)</td><td>(bps)</td></tr>
<tr><td>bytes-per-second</td><td>Rate</td><td>(/ byte second)</td><td>(Bps)</td></tr>
</table>

## Arithmetic Operations with Units


The `with-units` library contains procedures for arithmetic
operations on quantities with units. A quantity with unit information
is created by procedure `val-with-units`:

```scheme
 (use unitconv with-units)
 (val-with-units 10 m) ->  #(10 #(unit meter (m meters) [Length] 1.0))
```

The following operations are available for operations on quantities with units: 

- `u:value`: Returns the value of the given quantity.
- `u:units`: Returns the unit of the given quantity.
- `u:equal?`: Returns true if the units of the given quantities are equal, false otherwise.
- `u:zero?`
- `u:=`
- `u:negate`
- `u:invert`
- `u:+ u:- u:* u:/ `
- `u:sqrt`
- `u:sin`
- `u:cos`
- `u:expt` 

## Version history

- 2.6 : Bugfixes in unit* and unit/
- 2.3 : Added definitions for centimeter and centimeter-squared
- 2.2 : Removed redundant definition of define-unit (reported by felix)
- 2.1 : Documentation converted to wiki format
- 2.0 : Added unit arithmetic (with-units)
- 1.8 : Exporting all prefixed units; added info on information units [Joshua Griffith]
- 1.7 : Exporting the Rate quantity
- 1.6 : Exporting the IEC standard prefixes
- 1.5 : Ported to Chicken 4
- 1.4 : The predefined quantities have been put into unit-definitions.scm
- 1.3 : Bug fix in unit-convert
- 1.2 : Changed unit-convert to return a single numeric value given a single conversion argument
- 1.1 : Added information units [patch by Joshua Griffith]
- 1.0 : Initial release


## License

>
> Copyright 2007-2015 Ivan Raikov and the University of California, Irvine.
> 
> This program is free software: you can redistribute it and/or modify
> it under the terms of the GNU General Public License as published by
> the Free Software Foundation, either version 3 of the License, or (at
> your option) any later version.
> 
> This program is distributed in the hope that it will be useful, but
> WITHOUT ANY WARRANTY; without even the implied warranty of
> MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> General Public License for more details.
> 
> A full copy of the GPL license can be found at
> <http://www.gnu.org/licenses/>.


