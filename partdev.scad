include <config/config.scad>

*translate([-10,10,0]) openrail_doubled(100,true,true);

translate([0,-10,0]) aluProExtrusion(BR_20x20, 100);

aluProGusset(BR_20x20_Gusset, screws=true);

translate([0,50,-10]) rotate([90,0,0]) aluProExtrusion(BR_20x20, 100);

*translate([-openrail_plate_offset - 10,0,0])
rotate([0,-90,0]) {
	openrail_plate20(wheels=true);
}