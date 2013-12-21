

// bearing stack	
// core is 14.4mm wide, so need 5.6mm of spacers, or 2.8 each side

// dims
yIdler_width = 40;

// connections
yIdlerRightConnectors = [
	[[10,10,0], [0,0,-1], 0],   // frame 1
	[[yIdler_width-10,10,0], [0,0,-1], 0],   // frame 2
	[[8,38, thick_wall], [0,0,-1], 0]    // bearing axle
];

module yIdlerSpacer() {
	linear_extrude(2.8)
		difference() {
			circle(8);
			circle(screw_clearance_radius(M4_hex_screw));
		}
}

module yIdlerRight_stl(skinny=false) {
	con = yIdlerRightConnectors;
	
	w = yIdler_width;
	d = con[2][0][1] + thick_wall * 2;
	h = thick_wall;
	w2 = w / 4;
	
	ribH = 8*layers;
	
	fw = 2*screw_clearance_radius(M4_hex_screw) + 2 * default_wall;
	
	
	mcon = [[0,0,0],[0,0,1],0];
	
	stl("y_idler_right");
	
	color(x_carriage_color)
		union() {	
			// base
			linear_extrude(h)
				difference() {
					hull() {
						// axle
						translate([con[2][0][0], con[2][0][1],0]) 
							circle(r=8);
							
							
						// frame fixings
						for (i=[0,skinny?0:1])
						translate([con[i][0][0],con[i][0][1],0])
							circle(r=10);
					}
					
					
					// axle
					translate([con[2][0][0], con[2][0][1],0]) 
						circle(r=screw_clearance_radius(M4_hex_screw));
					
			
			
					// frame fixings
					for (i=[0,1])
						translate([con[i][0][0],con[i][0][1],0])
						circle(r=screw_clearance_radius(M4_hex_screw));
				}
				
			// rib
			translate([0,20,eta-ribH]) 
				roundedRect([skinny?w*0.4:w*0.7,4*perim, ribH],1);
				
			// spacer
			translate([con[2][0][0], con[2][0][1], eta-2.8])
				yIdlerSpacer();
		}
		
	if (debugConnectors) {
		frame();
		
		for (i=[0:2])
			connector(con[i]);
	}
}

// connections
yIdlerLeftConnectors = [
	[[10,10,thick_wall], [0,0,1], 0],   // frame 1
	[[yIdler_width-10,10,thick_wall], [0,0,1], 0],   // frame 2
	[[8,38, 0], [0,0,1], 0]    // bearing axle
];

module yIdlerLeft_stl() {
	con = yIdlerLeftConnectors;
	
	w = yIdler_width;
	d = con[2][0][1] + thick_wall * 2;
	h = thick_wall;
	w2 = w / 4;
	
	ribH = 8*layers;
	
	fw = 2*screw_clearance_radius(M4_hex_screw) + 2 * default_wall;
	
	
	mcon = [[0,0,0],[0,0,1],0];
	
	stl("y_idler_left");
	
	color(x_carriage_color)
		union() {	
			// base
			linear_extrude(h)
				difference() {
					hull() {
						// axle
						translate([con[2][0][0], con[2][0][1],0]) 
							circle(r=8);
							
							
						// frame fixings
						for (i=[0,1])
						translate([con[i][0][0],con[i][0][1],0])
							circle(r=10);
					}
					
					
					// axle
					translate([con[2][0][0], con[2][0][1],0]) 
						circle(r=screw_clearance_radius(M4_hex_screw));
					
			
			
					// frame fixings
					for (i=[0,1])
						translate([con[i][0][0],con[i][0][1],0])
						circle(r=screw_clearance_radius(M4_hex_screw));
				}
				
			// rib
			translate([0,20,h-eta]) 
				roundedRect([w*0.7,4*perim, ribH],1);
				
			// spacer
			translate([con[2][0][0], con[2][0][1], h-eta])
				yIdlerSpacer();
		}
		
	if (debugConnectors) {
		frame();
		
		for (i=[0:2])
			connector(con[i]);
	}
}


yIdlerAssemblyConnectors = [
	[[0,0,0],[0,1,0],0]  // to frame
];

module yIdlerAssembly() {

	assembly("y_idler_assembly");

	attach([[-10,10,0],[1,0,0],90], yIdlerLeftConnectors[0]) {
		yIdlerLeft_stl();
	
		// frame fixings
		for (i=[0,1])
			attach(yIdlerLeftConnectors[i], 20x20TwistLockFixingCon)
			20x20TwistLockFixing(thick_wall, screw=M4_cap_screw, screwLen = 8);
	
		// bearing axle
		attach(
			yIdlerLeftConnectors[2],
			[[0,0,-washer_thickness(M4_washer)],[0,0,-1],0]
		) 
			threadTogether([
				washer_thickness(M4_washer),
				thick_wall + 2.8 + washer_thickness(M5_penny_washer),
				washer_thickness(M4_washer),
				ball_bearing_width(BB624)/2,
				ball_bearing_width(BB624),
				ball_bearing_width(BB624)/2 + washer_thickness(M4_washer),
				washer_thickness(M5_penny_washer),
				2.8 + thick_wall + washer_thickness(M4_washer),
				0
			]) {
				screw(M4_hex_screw,40);
				washer(M4_washer);
				washer(M5_penny_washer);
				washer(M4_washer);
				ball_bearing(BB624);
				ball_bearing(BB624);
				washer(M4_washer);
				washer(M5_penny_washer);
				washer(M4_washer);
				rotate([180,0,0]) nut(M4_nut,nyloc=true);
			}	
	}
	
	attach([[10,10,0],[-1,0,0],-90], yIdlerRightConnectors[0]) {
		yIdlerRight_stl();
	
		// frame fixings
		for (i=[0,1])
			attach(yIdlerRightConnectors[i], 20x20TwistLockFixingCon)
			20x20TwistLockFixing(thick_wall, screw=M4_cap_screw, screwLen = 8);	
	}
	
	end("y_idler_assembly");
}
