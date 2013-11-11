include <config/config.scad>





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
		translate([-bedWM/2+10 + i*ribSpacing,ribL/2,-10]) rotate([90,0,0]) aluProExtWithGussets(BR_20x20, ribL, [0,i>0?1:0,0,i<1?1:0], [0,i>0?1:0,0,i<1?1:0], true);
	}
	
	// keeps bed centred at origin
	cuttingBed();
	// with cutting margins
	color([1,0,0,0.5]) cube([bedWM,bedDM,0.5],center=true);
}



module xCarriage() {
	// plate
	translate([0,-20-openrail_plate_offset,10]) rotate([90,0,0]) openrail_plate20(wheels=true);

	// laser optics
	translate([0,-60,-50]) cylinder(r=25/2,h=100);
}

module xAxis() {
	xCarriage();

	l = bedWM + 2*xO;

	translate([-l/2,0,10]) rotate([0,90,0]) aluProExtrusion(BR_20x40, l=l);

	translate([-bedWM/2,-20,20]) { 
		rotate([0,90,0]) rotate([0,0,90]) openrail_doubled(bedWM,true,true);
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
