include <config/config.scad>

bom = 2;

*laserAssembly();

frameAssembly();

zAxesAssembly();

translate([0,0,bedVPos]) bedAssembly();

yAxesAssembly();

*claddingAssembly();


*translate([frameCY[3] - 10, laserPowerSupply_depth,40])
	rotate([90,-90,90])
	laserPowerSupply();