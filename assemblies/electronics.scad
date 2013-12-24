


module arduinoMegaBracket1() {
	
	rc = frameCY[5] - frameCY[3];
	
	w = rc + 10;
	d = 8;
	t = 5*perim;
	
	ardW = 53.3;
	fixW = 48.3;
	ardO = (ardW - fixW)/2 + (rc-ardW)/2;
	
	r1 = screw_clearance_radius(M4_hex_screw);
	r2 = screw_clearance_radius(M3_hex_screw);

	color(x_carriage_color)	
		render()
		difference() {
			union() {
				linear_extrude(t)
					difference() {
						union() {
							translate([-5,-d/2])
								square([w,d]);
							
							translate([ardO + fixW,-1.3,0])
								circle(d/2);
						}
						
						// frame fixing holes
						circle(r1);
						translate([rc,0,0])
							circle(r1);
							
						// arduino fixing holes
						translate([ardO,0,0]) {
							circle(r2);
							
							translate([fixW,-1.3,0])
								circle(r2);
						}
					}
		
				20x20SnapFitting_stl(embed=true);
			
				translate([rc,0,0]) 
					20x20SnapFitting_stl(embed=true);
				
			}
		
			// fracture lines
			for (i=[0,1])
				translate([-4 + i*(rc-6),-d/2-1,perim])
				cube([14,d+2,perim]);	
		}
}



module arduinoMegaBracket2() {
	
	rc = frameCY[5] - frameCY[3];
	
	w = rc + 10;
	d = 8;
	t = 5*perim;
	
	ardW = 53.3;
	fixW = 48.3;
	yO = 6.35;
	ardO = (ardW - fixW)/2 + (rc-ardW)/2;
	
	r1 = screw_clearance_radius(M4_hex_screw);
	r2 = screw_clearance_radius(M3_hex_screw);

	color(x_carriage_color)	
		render()
		difference() {
			union() {
				linear_extrude(t)
					difference() {
						union() {
							translate([-5,-d/2])
								square([w,d]);
							
							hull () {
								translate([ardO + fixW,0,0])
									circle(d/2);
							
								translate([ardO + fixW,-yO,0])
									circle(d/2);
								
							}
						}
						
						// frame fixing holes
						circle(r1);
						translate([rc,0,0])
							circle(r1);
							
						// arduino fixing holes
						translate([ardO,0,0]) {
							circle(r2);
							
							translate([fixW,-yO,0])
								circle(r2);
						}
					}
		
				20x20SnapFitting_stl(embed=true);
			
				translate([rc,0,0]) 
					20x20SnapFitting_stl(embed=true);
				
			}
		
			// fracture lines
			for (i=[0,1])
				translate([-4 + i*(rc-6),-d/2-1,perim])
				cube([14,d+2,perim]);	
		}
}




module PSUBracket() {
	
	rc = frameCY[5] - frameCY[3];
	
	w = rc + 10;
	d = 8;
	t = 6*perim;
	
	fixW = 52;
	offset = (rc-fixW)/2;
	
	r1 = screw_clearance_radius(M4_hex_screw);
	r2 = screw_clearance_radius(M3_hex_screw);

	color(x_carriage_color)	
		render()
		difference() {
			union() {
				linear_extrude(t)
					difference() {
						union() {
							translate([-5,-d/2])
								square([w,d]);
						}
						
						// frame fixing holes
						circle(r1);
						translate([rc,0,0])
							circle(r1);
							
						// PSU fixing holes
						translate([offset,0,0]) {
							circle(r2);
							
							translate([fixW,0,0])
								circle(r2);
						}
					}
		
				20x20SnapFitting_stl(embed=true);
			
				translate([rc,0,0]) 
					20x20SnapFitting_stl(embed=true);
				
			}
		
			// fracture lines
			for (i=[0,1])
				translate([-4 + i*(rc-6),-d/2-1,perim])
				cube([14,d+2,perim]);	
		}
}


module cableClip() {
	difference() {
		union() {
			
		}
	}

	
}