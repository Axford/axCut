




// composite connector that joins two parallel extrusions (mid-rail) to an orthogonal extrusion (end)
// sized for 20x20 extrusion
// mid-rail joints to be secured by t-nuts
// end joint to be secured by core screw
// further ancillary connection points are provided (e.g. for cladding panels)

// part origin is at intersection of rail centrelines
// with parallel extrusions lying in xz plane, end on extrusion in y plane
// gussets protruding along z+  (print orientation)
// endSide:  false= y-, true=y+

module 20x20TGusset_stl(width=100, coreSide=true, showScrews=false, showCoreScrew=false) {
	
	h1 = 20;  // web height
	
	gh = 20;  // gusset height
	gw = gh;  // gusset width
	
	screws = M4_cap_screw;
	core_screw = M6_selftap_screw;   // S6x16
	  
	sw = 5;  // slow width, between centres
	
	vitamin("20x20TGusset:");
	
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
						circle(screw_clearance_radius(screws));
					
					translate([h1 + gh/2,10,0])
						circle(screw_clearance_radius(screws));
					
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
		
	if (showCoreScrew) 
		mirror([0,coreSide?0:1,0])
		translate([0,10 - default_wall,0])
		rotate([90,0,0])
		screw_and_washer(core_screw,16);
	
	if (showScrews)
		for (i=[0,1],j=[0,1])
		mirror([i,0,0]) {
			translate([width/2,0,j*(h1/2 + gh/2)])
				rotate([0,-90,0]) {
					translate([0,0,default_wall]) screw_and_washer(M4_cap_screw,8);
					translate([0,0,0]) rotate([0,0,90]) aluProTwistLockNut(BR_20x20_TwistLockNut);
				}
			
		}
	
}




// heavy duty 90 degree gusset to join 20x40 profile
// designed for the base of the axCut machine

module 20x40HeavyGusset_stl(screws=false) {
	// sits on z=0
	// faces along y+ and z+	
	w = 40;
	t = default_wall;
	slotw = screw_clearance_radius(M4_cap_screw) * 2;
	sloth = slotw * 1.5;
	nib = 1;   // depth of nib
	nibw = 5.8;  // width of nib
	
	vitamin("20x40HeavyGusset:");
	
	//color(grey80)
	color(plastic_part_color())  // colour as plastic for axCut build
	render()
	union() {
		// ends
		for (i=[0,1])
			mirror([0,-i,i])
			linear_extrude(t) {
				difference() {
					translate([-w/2,0,0]) square([w,w]);
					
					// slots for screw, 20mm centres
					for (j=[0,1],k=[0,1])
						translate([-10 + j*w/2 - slotw/2, 9 + k*20, 0]) 
						square([slotw,sloth]);
				}
			}
			
		// nibs - must add these at some point!
		if (!simplify)
			for (i=[0,1],j=[0,1],k=[0,1])
			mirror([0,-i,i])
			rotate([0,-90,0])
			translate([j*(w-2*nib),0,-10 + k*20 -nibw/2])
			linear_extrude(nibw)
			polygon([[0,0],
			         [2*nib,0],
			         [nib,-nib],
			         [-nib,-nib]]);
		
		//sides and inner rib
		for (i=[0:2])
			translate([-w/2+t/2 + i*(w-t)/2 ,t-eta,t-eta])
			rotate([0,-90,0])
			right_triangle(width=w-t, height=w-t, h=t, center = true);
	
		// tips
		if (!simplify)
			for (i=[0,1])
			mirror([0,-i,i])
			translate([w/2-t-eta,w-1,t-eta])
			rotate([0,-90,0])
			right_triangle(width=1, height=1, h=w-2*t+2*eta, center=false);
	}
	
	if (screws) {
		for (i=[0,1],j=[0,1],k=[0,1])
			mirror([0,-i,i]) {
				translate([-10 + k*20,12 + j*20,t]) screw(M4_cap_screw,8);
				translate([-10 + k*20,12 + j*20,0]) aluProTwistLockNut(BR_20x20_TwistLockNut);
			}
	}
}