include <config/config.scad>

xCarriagePos = -bedW/2 + (0.5+cos($t*360)/2) * bedW;
yCarriagePos = -bedD/2 + (0.5+cos($t*360)/2) * bedD;

laserAssembly();

frameAssembly();

*zAxesAssembly();

translate([0,0,bedVPos]) bedAssembly();

yAxesAssembly();

*claddingAssembly();


*translate([frameCY[3] - 10, laserPowerSupply_depth,40])
	rotate([90,-90,90])
	laserPowerSupply();