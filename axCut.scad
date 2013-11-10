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
use <openrail.scad>
use <openrailwheel.scad>


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

bedRibs = 6;  // number of ribs (along y axis)

bedVPos = 200;

xO = 50;  // xOvershoot
xVPos = 300;  // height of x axis above datum
yVPos = 270;  // height of y axis - to centreline of 2040 profile

wheelOR = 19/2;  // radius to bearing surface, approx

rightW = 120;  // width of right casing, excludes outer panelling, runs from edge of bed margin
leftW = 120;
backD = 160;  // depth of back casing
frontD = 25;  // depth of front casing

claddingC = 5;  // cladding clearance, inc thickness
claddingT = 3;  // cladding thickness


module cuttingBed() {
	// centred on origin

	// dummy surface
	color([1,1,1,0.5]) cube([bedW,bedD,1],center=true);
}

module cuttingBedFrame() {

	bFW = bedW + 2*bedM + 2*bedO;

	ribSpacing = (bedWM - 20) / (bedRibs - 1);
	ribL = bedDM - 80;

	translate([-bFW/2,bedDM/2-20,-10]) rotate([0,90,0]) aluProExtrusion(BR_20x40, l=bFW);
	translate([-bFW/2,-bedDM/2+20,-10]) rotate([0,90,0]) aluProExtrusion(BR_20x40, l=bFW);
	
	for (i=[0:bedRibs-1]) {
		translate([-bedWM/2+10 + i*ribSpacing,ribL/2,-10]) rotate([90,0,0]) aluProExtrusion(BR_20x20, l=ribL);
	}
	
	// keeps bed centred at origin
	cuttingBed();
	// with cutting margins
	color([1,0,0,0.5]) cube([bedWM,bedDM,0.5],center=true);
}



module xCarriage() {
	// wheels

	translate([0,-22,20 + wheelOR + 2]) rotate([90,0,0]) openrailwheel();
	
	translate([20,-22.4,0 -wheelOR - 2]) rotate([90,0,0]) openrailwheel();
	translate([-20,-22.4,0 -wheelOR - 2]) rotate([90,0,0]) openrailwheel();

	//mounting plate
	translate([0,-22-8-5,10]) roundedRectY([70,5,70],10,center=true);

	// laser optics
	translate([0,-70,-50]) cylinder(r=25/2,h=100);
}

module xAxis() {
	xCarriage();

	l = bedWM + 2*xO;

	translate([-l/2,0,10]) rotate([0,90,0]) aluProExtrusion(BR_20x40, l=l);

	translate([0,-22,20]) { 
		mirror([0,1,0]) rotate([0,90,0]) openrail(bedWM);
		translate([0,0,-20]) rotate([0,-90,0]) openrail(bedWM);
	}

	translate([l/2 + NEMA_width(NEMA17)/2,-20,10]) rotate([90,0,0]) NEMA(NEMA17);
}


module outerFrame() {
	w = bedWM + leftW + rightW;
	d = bedDM + backD + frontD;
	h = xVPos + 100;

	h2 = h - 30;  // height of left/right edges

	xmin = -bedWM/2-rightW;
	xmax = bedWM/2 + leftW;
	ymin = -bedDM/2 - frontD;
	ymax = bedDM/2 + backD;

	
	// base - front/back
	translate([xmin,ymin+10,20]) rotate([0,90,0]) rotate([0,0,90]) aluProExtrusion(BR_20x40, l=w);
	translate([xmin,ymax-10,20]) rotate([0,90,0]) rotate([0,0,90]) aluProExtrusion(BR_20x40, l=w);

	// base - sides
	translate([xmin+10,ymin+20,20]) rotate([-90,0,0]) aluProExtrusion(BR_20x40, l=d-40);
	translate([xmax-10,ymin+20,20]) rotate([-90,0,0]) aluProExtrusion(BR_20x40, l=d-40);

	// base ribs
	translate([xmin+rightW-10-claddingC,ymin+20,20]) rotate([-90,0,0]) aluProExtrusion(BR_20x40, l=d-40);
	translate([xmax-leftW+10+claddingC,ymin+20,20]) rotate([-90,0,0]) aluProExtrusion(BR_20x40, l=d-40);

	translate([-bedWM/6,ymin+20,20]) rotate([-90,0,0]) aluProExtrusion(BR_20x40, l=d-40);
	translate([bedWM/6,ymin+20,20]) rotate([-90,0,0]) aluProExtrusion(BR_20x40, l=d-40);

	// y rails
	translate([xmin+rightW-10-claddingC,ymin+20,yVPos]) rotate([-90,0,0]) aluProExtrusion(BR_20x40, l=d-40);
	translate([xmax-leftW+10+claddingC,ymin+20,yVPos]) rotate([-90,0,0]) aluProExtrusion(BR_20x40, l=d-40);

	// inner posts - front
	translate([xmin+rightW-20-claddingC,ymin+10,40]) rotate([0,0,90]) aluProExtrusion(BR_20x40, l=h-40);	
	translate([xmax-leftW+20+claddingC,ymin+10,40]) rotate([0,0,90]) aluProExtrusion(BR_20x40, l=h-40);	

	// inner posts - back
	translate([xmin+rightW-20-claddingC,ymax-10,40]) rotate([0,0,90]) aluProExtrusion(BR_20x40, l=h-40);	
	translate([xmax-leftW+20+claddingC,ymax-10,40]) rotate([0,0,90]) aluProExtrusion(BR_20x40, l=h-40);	

	// outer posts - front
	translate([xmin+10,ymin+10,40]) rotate([0,0,90]) aluProExtrusion(BR_20x20, l=h2-40);	
	translate([xmax-10,ymin+10,40]) rotate([0,0,90]) aluProExtrusion(BR_20x20, l=h2-40);

	// outer posts - back
	translate([xmin+10,ymax-10,40]) rotate([0,0,90]) aluProExtrusion(BR_20x20, l=h2-40);	
	translate([xmax-10,ymax-10,40]) rotate([0,0,90]) aluProExtrusion(BR_20x20, l=h2-40);

	// top - sides
	translate([xmin+10,ymin+20,h2-10]) rotate([-90,0,0]) aluProExtrusion(BR_20x20, l=d-40);
	translate([xmax-10,ymin+20,h2-10]) rotate([-90,0,0]) aluProExtrusion(BR_20x20, l=d-40);

	// top inner sides
	
	translate([xmin+rightW-20-claddingC,ymin+20,h-10]) rotate([-90,0,0]) rotate([0,0,90]) aluProExtrusion(BR_20x40, l=d-40);
	translate([xmax-leftW+20+claddingC,ymin+20,h-10]) rotate([-90,0,0]) rotate([0,0,90]) aluProExtrusion(BR_20x40, l=d-40);

	// top - front
	translate([xmin+20,ymin+10,h2-10]) rotate([0,90,0]) rotate([0,0,90]) aluProExtrusion(BR_20x20, l=rightW-60);
	translate([xmax-leftW+40,ymin+10,h2-10]) rotate([0,90,0]) rotate([0,0,90]) aluProExtrusion(BR_20x20, l=leftW-60);

	// top - back
	translate([xmin+20,ymax-10,h2-10]) rotate([0,90,0]) rotate([0,0,90]) aluProExtrusion(BR_20x20, l=rightW-60);
	translate([xmax-leftW+40,ymax-10,h2-10]) rotate([0,90,0]) rotate([0,0,90]) aluProExtrusion(BR_20x20, l=leftW-60);

	// top - back - middle
	translate([xmin+rightW-claddingC,ymax-10,h-20]) rotate([0,90,0]) rotate([0,0,90]) aluProExtrusion(BR_20x40, l=bedWM+2*claddingC);
	
	// back - middle
	translate([xmin+rightW-claddingC,ymax-10,yVPos]) rotate([0,90,0]) rotate([0,0,90]) aluProExtrusion(BR_20x40, l=bedWM+2*claddingC);

	// top - hingeline
	translate([xmin+rightW-claddingC,bedDM/2+20,h-10]) rotate([0,90,0]) rotate([0,0,0]) aluProExtrusion(BR_20x40, l=bedWM+2*claddingC);

}

module zAssembly() {
	h = NEMA_length(NEMA17);

	for (x=[0,1], y=[-1,1]) 
		mirror([x,0,0])
		translate([(bedWM/2  + claddingC + NEMA_width(NEMA17)/2 + 20), y*(bedDM/2-40-NEMA_width(NEMA17)/2),0]) {
	
		// motor	
		translate([0,0,h]) NEMA(NEMA17);
	
		// threaded rod
		translate([0,0,h+20]) cylinder(h=yVPos-90, r= 5/2);

		// coupling
		translate([0,0,h+4]) cylinder(h=25, r= 15/2);

		// linear rod
		translate([-NEMA_width(NEMA17)/2-10,0,40]) cylinder(h=yVPos-60, r= 10/2);
	
		// bearing

		
	}
	
}

module laserTube() {
	color([1,1,1,0.4]) cylinder(r=60/2, h=700);
}

module laserTubeAssembly() {

	translate([-350,bedDM/2 + backD-50,xVPos+30]) rotate([0,90,0]) laserTube();

}

laserTubeAssembly();

outerFrame();

zAssembly();

translate([0,0,bedVPos]) cuttingBedFrame();

translate([0,0,xVPos]) xAxis();
