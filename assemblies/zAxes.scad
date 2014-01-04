
include <z-coupling.scad>;


module zRodTopBracket_stl() {
	
	mw = NEMA_width(NEMA17);
	
	d = mw;
	t = 10;
	w = 20;
	
	
	if (debugConnectors) {
		frame();
	}
	
	
	color(x_carriage_color)
		render()
		translate([0,0,-t])
		difference() {
			linear_extrude(t)
				difference() {
					// plate
					translate([-10,-d/2])
						roundedSquare([w,d], 9, center=false);
					
					// frame fixings
					for (i=[-1,1])
						translate([0,i*(mw/2 - (mw-10)/4),0])
						circle(screw_clearance_radius(M4_cap_screw));
						
					// hollow for linear rod
					circle(5.1);
					
				}	
			
			// weight loss
			translate([-11,-5,5])
				cube([22, 10, 6]);	
		
		}
}


module zRodAssembly() {
	
	rodLen = frameCZ[1] - frameCZ[0] - 30;
	
	echo("Rodlen",rodLen);
	
	assembly("zRod");
	
	// linear rod
	rod(Z_bar_dia, rodLen, false);
	
	// bottom clamp integrated with motor bracket
	
	
	// top clamp
	translate([0,0,rodLen])
		zRodTopBracket_stl();
	
	
	end("zRod");
	
}


module zMotorBracket_stl() {
	
	ml = NEMA_length(NEMA17);
	mw = NEMA_width(NEMA17);
	
	d = mw;
	t = thick_wall + ml - 40;
	w = 20 + d;
	
	
	if (debugConnectors) {
		frame();
	}
	
	
	color(x_carriage_color)
		render()
		difference() {
			linear_extrude(t)
				difference() {
					// plate
					translate([-10,-d/2])
						roundedSquare([w,d], 5, center=false);
				
					// motor fixings / boss
					translate([10 + mw/2, 0, 0]) {
						// boss
						circle(r=NEMA_big_hole(NEMA17));
				
						// motor fixings
						for(a = [0: 90 : 90 * (4 - 1)])
							rotate([0, 0, a])
							translate([NEMA_holes(NEMA17)[0], NEMA_holes(NEMA17)[1], 0])
							circle(r=screw_clearance_radius(M3_cap_screw));
					}
					
					// frame fixings
					for (i=[-1,1])
						translate([0,i*(mw/2 - (mw-10)/4),0])
						circle(screw_clearance_radius(M4_cap_screw));
						
					// hollow for linear rod
					circle(5.1);
					
				}	
			
			// weight loss
			translate([-11,-5,-1])
				cube([22, 10, ml-40+1]);
		
		
			// hollow for motor
			translate([10,-d/2-1,-1])
				cube([mw+1, mw+2, ml-40+1]);
				
			
		
		}
}






module zMotorAssembly() {
	h = NEMA_length(NEMA17);
	h1 = h + z_coupling_length()/2 + 5;
	
	Z_screw_length = frameCZ[1]-80;

	assembly("zMotor");
	
	// motor bracket
	
	
	translate([0,0,40])
		zMotorBracket_stl();
	
	
	translate([NEMA_width(NEMA17)/2 + 10,0,0]) {
		// motor	
		translate([0,0,h]) NEMA(NEMA17);
	
		// threaded rod
		translate([0,0,h1]) 
			studding(d = Z_screw_dia, l = Z_screw_length, center=false);

		// coupling
		translate([0,0,h1]) 
			z_coupler_assembly();
		
	}
	
	end("zMotor");
}


module zAxesAssembly() {

	assembly("zAxes");

	// motor assemblies
	for (x=[0,1], y=[-1,1]) 
		mirror([x,0,0])
		translate([(frameCY[3]), y*(bedDM/2-bedMotorYOffset),0]) 
		zMotorAssembly();
		
	
	// linear rod assemblies
	for (x=[0,1]) 
		mirror([x,0,0])
		translate([(frameCY[3]), -(bedDM/2 - bedBearingOffset),40]) 
			zRodAssembly();
			
	end("zAxes");
}