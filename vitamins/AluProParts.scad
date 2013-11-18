




// composite connector that joins two parallel extrusions (mid-rail) to an orthogonal extrusion (end)
// sized for 20x20 extrusion
// mid-rail joints to be secured by t-nuts
// end joint to be secured by core screw
// further ancillary connection points are provided (e.g. for cladding panels)

// part origin is at intersection of rail centrelines
// with parallel extrusions lying in xz plane, end on extrusion in y plane
// gussets protruding along z+  (print orientation)
// endSide:  false= y-, true=y+

module 20x20TGusset(width=100, coreSide=true, screws=false, coreScrew=false) {
	
	h1 = 20;  // web height
	
	gh = 20;  // gusset height
	gw = gh;  // gusset width
	
	screws = M4_cap_screw;
	core_screw = M6_selftap_screw;   // S6x16
	  
	sw = 5;  // slow width, between centres
	
	color(plastic_part_color())
		translate([0,0,-h1/2])
		render()
		union() {
		
			// base
			linear_extrude(default_wall) 
				difference() {
					square([width,20],center=true);
					
					// centre fixing
					circle(screw_clearance_radius(screws));
					
					// outer ancillary fixings
					if (width > 60)
						for (i=[0:2])
						translate([-20 + i*20,0,0])
						circle(screw_clearance_radius(screws));
				}
			
			// sides
			for (i=[0,1])
				mirror([i,0,0])
				translate([width/2,-10,0])
				rotate([0,-90,0])
				linear_extrude(default_wall)
				difference() {
					square([h1 + gh, 20]);
					
					// fixings
					translate([h1/2,10,0])
						circle(screw_clearance_radius(core_screw));
					
					translate([h1 + gh/2,10,0])
						circle(screw_clearance_radius(core_screw));
					
				}
			
		
			// front/back
			for (i=[0,1])
				mirror([0,i,0])
				translate([0,10,0])
				rotate([90,0,0])
				linear_extrude(default_wall)
				difference() {
					union() {
						// cross web
						translate([0,h1/2])
							square([width, h1], center=true);
			
						// gusset sides	
						for (i=[0,1])
							mirror([i,0,0])
							translate([-width/2,h1,0])
							polygon(points = [[0,0], [gw, 0], [default_wall, gh], [0, gh]]);
					}
			
					// centre slot			
					hull () {
						translate([-sw/2,h1/2,0])
							circle(screw_clearance_radius(core_screw));
						translate([sw/2,h1/2,0])
							circle(screw_clearance_radius(core_screw));
					}
		
					// ancillary fixings
					if (width > 60)
						for (i=[0,1])
						mirror([i,0,0])
						translate([-20,h1/2,0])
						circle(screw_clearance_radius(screws));
				}
		}
		
	if (coreScrew) 
		mirror([0,coreSide?0:1,0])
		translate([0,10 - default_wall,0])
		rotate([90,0,0])
		screw_and_washer(core_screw,16);
	
	if (screws)
		for (i=[0,1],j=[0,1])
		mirror([i,0,0]) {
			translate([width/2,0,j*(h1/2 + gh/2)])
				rotate([0,-90,0]) {
					translate([0,0,default_wall]) screw_and_washer(M4_cap_screw,8);
					translate([0,0,0]) rotate([0,0,90]) aluProTwistLockNut(BR_20x20_TwistLockNut);
				}
			
		}
	
}