use_realistic_colors = true;
simplify = false;    // reduces complexity of some parts, e.g. alu extrusions

silicone_color = [1,0.2,0.2,1];
microbore_color = [0.8,0.65,0.4,1];

include <bom.scad>
include <config.scad>
include <colors.scad>
include <aluminiumProfiles.scad>
include <stepper-motors.scad>
include <ball-bearings.scad>
include <screws.scad>
include <washers.scad>
include <nuts.scad>
use <parametric_involute_gear_v5.0.scad>
use <gear_calculator.scad>
use <roundedRect.scad>
use <2DShapes.scad>
use <maths.scad>
use <vector.scad>
use <curvedPipe.scad>
use <microbore.scad>
use <moreShapes.scad>

perim = 0.7;
layers = 0.3;
2perim = 2*perim;
4perim = 4*perim;
eta = 0.001;



bedW = 850;
bedD = 600;
bedH = 300;
bedM = 30;  // bed margin, applied all round
bedO = 60;  //bedOvershoot - applies to width only

bedWM = bedW + 2*bedM;  // with margins
bedDM = bedD + 2*bedM;

bedRibs = 4;  // number of ribs (along y axis)



module cuttingBed() {
	// centred on origin

	// dummy surface
	color([1,1,1,0.5]) cube([bedW,bedD,1],center=true);
}

module cuttingBedFrame() {
	// keeps bed centred at origin
	//cuttingBed();

	// with cutting margins
	//color([1,0,0,0.5]) cube([bedWM,bedDM,0.5],center=true);

	bFW = bedW + 2*bedM + 2*bedO;

	ribSpacing = (bedWM - 20) / (bedRibs - 1);
	ribL = bedDM - 80;

	translate([-bFW/2,bedDM/2-20,-10]) rotate([0,90,0]) aluProExtrusion(BR_20x40, l=bFW);
	translate([-bFW/2,-bedDM/2+20,-10]) rotate([0,90,0]) aluProExtrusion(BR_20x40, l=bFW);
	
	for (i=[0:bedRibs-1]) {
		translate([-bedWM/2+10 + i*ribSpacing,ribL/2,-10]) rotate([90,0,0]) aluProExtrusion(BR_20x20, l=ribL);
	}
	
}


//aluProExtrusion(BR_20x20, l=70);
//aluProExtrusion(BR_20x40, l=70, center=false);


cuttingBedFrame();