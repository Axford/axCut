include <config/config.scad>

debugConnectors=false;


trolleyAssembly();

translate([0,0, trolleyHeight])
	frameAssembly();

