// xLimitSwitch Assembly

xLimitSwitchOffset = openrail_plate_offset + 
							   openrail_groove_offset - 10;


xLimitSwitchBracket_connectors = [
	[[0,0,0],[0,0,1],0],  // frame fixing
	[[0,-xLimitSwitchOffset,13],[0,0,-1],-90]   // microswitch
];


module xLimitSwitchBracket_stl(noSnapFitting=false) {

	con = xLimitSwitchBracket_connectors;
	mcon = microswitch2_connectors;
	
	mw = microswitch2_width;
	md = microswitch2_depth;
	
	t = 9;
	
	//steps 5mm from centreline of rail
	armW = -con[1][0][1] + mw - 5 - mcon[0][0][0];

	armH = con[1][0][2] - md - thick_wall;
	
	

	if (debugConnectors) {
		frame();
		
		for (i=[0,1])
			connector(con[i]);
	}
	
	
	color(x_carriage_color)
		//render()
		difference() {
			union() {
				translate([t/2,0,0])
					rotate([0,-90,0])
					linear_extrude(t)
					union() {
						// fixing arm
						translate([armH,-armW - 5,0])
							square([thick_wall, armW + 15]);
			
						// frame fixing 
						translate([0,-5,0])
							square([thick_wall, 15]);
			
						// fillet
						translate([0,-10+eta,0])
							polygon(points = [[armH+eta,5], [armH+eta, 0], [0, 5]]);
						
						translate([default_wall-eta,-5 - eta,0])	
							 polygon(points = [[0,0], [armH, 0], [0, 5]]);
					}
			
		
		
				// union to snap fitting
				if (!noSnapFitting)
					rotate([0,0,90])
					20x20SnapFitting_stl(embed=true);
		
			}
		
			// fracture line
			if (!noSnapFitting)
				translate([-50,-5+perim,0.7])
				cube([100,15 - 2perim,0.7]);
		
			// hollow for screw
			translate([0,0,-eta])
				cylinder(r=screw_clearance_radius(M4_cap_screw),h=50);
		
			// countersink
			translate([0,0,thick_wall + 2perim])
				cylinder(r=screw_head_radius(M4_cap_screw) + 0.3,h=50);
		
	
			// mswitch fixing holes
			for (i=[0:1])
				translate([0,con[1][0][1] - i*microswitch2_fixingCentres,0])
				cylinder(r=3/2, h=20,center=true);
	
		}

}



xLimitSwitchAssembly_connnectors = [
	[[0,0,0],[0,0,1],0]  // attach to x rail
];

module xLimitSwitchAssembly() {

	con = xLimitSwitchAssembly_connnectors;
	bcon = xLimitSwitchBracket_connectors;
	mcon = microswitch2_connectors;

	attach(con[0],bcon[0]) {
		xLimitSwitchBracket_stl();

		attach(bcon[1],mcon[0])
			microswitch2();
	}
	
		
	// dummy 20x20
	BR20x20WGBP([-50,0,-10],[50,0,-10]);
}