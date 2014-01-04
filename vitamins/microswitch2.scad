// mini microswitch model
// Damian Axford

microswitch2_width = 12.8;
microswitch2_height = 6;
microswitch2_depth = 5.8;
microswitch2_fixingCentres = 6.5;
microswitch2_fixingRadius = 2.5/2;

microswitch2_connectors = [
	[[(microswitch2_width-microswitch2_fixingCentres)/2,microswitch2_fixingRadius,0],[0,0,1],0],   // mount one
	[[(microswitch2_width-microswitch2_fixingCentres)/2 + microswitch2_fixingCentres,microswitch2_fixingRadius,0],[0,0,1],0]    // mount two
];

module microswitch2() {
	w = microswitch2_width;
	h = microswitch2_height;
	d = microswitch2_depth;
	con = microswitch2_connectors;
	
	if (debugConnectors) {
		frame();
		
		for (i=[0:1])
			connector(con[i]);
	}
	
	// body
	color([0.2,0.2,0.2,1])
		linear_extrude(d)
		difference() {
			square([w,h]);
		
			// mounting holes
			for (i=[0,1])
				translate([con[i][0][0], con[i][0][1],0])
				circle(microswitch2_fixingRadius);
		}
		
	// switch plate
	color("silver")
		translate([1,h,(d-3.4)/2])
		rotate([0,0,17])
		cube([12.6,0.3,3.4]);
		
		
	// connecting tabs
	for (i=[0:2])
		translate([i*(w-2.5)/2 + 0.5, -1.8, d/2])
		linear_extrude(0.3)
		difference() {
			square([1.6,1.6]);
			
			translate([0.8,0.8,0])
				circle(0.4);
		}
	
}