// OpenRail
// Derived from openrail specification v5
// https://www.openpart.co.uk/download/OPENRAIL_V5.pdf


openrail_h = 19.5291;
openrail_vh = 2.9679;
openrail_w = 4.75;
openrail_t = 2.375;
openrail_r = 0.4;  // radius of corners, approx



module openrail_slot() {
	$fn = 12;
	
	hull() {
		for (y=[-1,1]) 
			translate([0,6.7/2*y,0]) circle(r=2.65);
		
	}
}

module openrail(l,slots=false,screws=false,screwlen=8) {
	 x = openrail_t-openrail_r;
	 y = openrail_vh-openrail_r;
	 
	 numslots = floor((l-50) / 50);
	 
	 $fn=8;
	 
	 vitamin(str("Openrail",l,":","Openrail ",l,"mm"));

	color(grey20) 
		render()
		union() {
			// rail body
			rotate([0,-90,0])
				linear_extrude(openrail_t)
				difference() {
					translate([0,-openrail_h,0]) square([l,openrail_h]);
					
					// slots
					if (slots && !simplify) {
						for (i=[0:numslots]) {
							translate([25 + i*50,-openrail_h/2,0]) openrail_slot();
						}
					}
				}
		
			// v cap
			linear_extrude(l) 
			{
				hull() {
					translate([0,y,0]) circle(r=openrail_r);
					translate([-x,y-x,0]) circle(r=openrail_r);
					translate([x,y-x,0]) circle(r=openrail_r);
				}
			
				translate([-openrail_t,0,0]) square([openrail_w,openrail_vh-openrail_t]);
			}	
		}

	// screws
	if (screws) {
		rotate([0,-90,0]) 
		for (i=[0:numslots]) {
			translate([25 + i*50,-openrail_h/2,openrail_t]) screw(M5_lowprofile_screw,screwlen); 
		}
	}

}


module openrail_doubled(l,slots=false,screws=false) {
	translate([-openrail_t,0,0]) openrail(l,slots,screws,10);
	translate([-openrail_t,-20,0]) rotate([0,0,180]) openrail(l,slots);
}


