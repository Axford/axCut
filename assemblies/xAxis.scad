
xCarriageBracket_width = ORPlateWidth(ORPLATE20);
xCarriageBracket_height = xCarriageBracket_width;
xCarriageBracket_thickness = 9;


yCarriageBracket_width = ORPlateWidth(ORPLATE20);
yCarriageBracket_height = ORPlateWidth(ORPLATE20);
yCarriageBracket_thickness=9;


xCarriageToLaserHeadIngress = openrail_plate_offset + openrail_groove_offset + xCarriageBracket_thickness + laserHeadBody_tubeOffsetZ;  

echo(laserHeadBody_tubeOffsetZ);

module xCarriageBracket() {
	ct = xCarriageBracket_thickness;
	cw = xCarriageBracket_width;
	ch = xCarriageBracket_height;
	
	vitamin("xCarriageBracket");

	color("blue")
		render()
		difference() {
			linear_extrude(ct) 
				difference() {
					roundedSquare([cw,ch],10);
			
					// screw holes
					for (x=[-1,1],y=[-1,1])
						translate([x*22.3,y*22.3,ct])
						circle(screw_clearance_radius(M5_cap_screw));
				}
				
			// screw countersinks
			for (x=[-1,1],y=[-1,1])
				translate([x*22.3,y*22.3,thick_wall])
				cylinder(r=screw_head_radius(M5_cap_screw), h=ct);
		}
}



module xCarriageAssembly() {
	ct = xCarriageBracket_thickness;
	cw = xCarriageBracket_width;
	ch = xCarriageBracket_height;
	
	assembly("xCarriage");
	
	// plate
	translate([0,0,0]) 
		rotate([90,0,0]) {
			// plate
			openrail_plate20(wheels=true);


			// laser head
			translate([-laserHeadBody_tubeOffsetX, 
					   -42,
					   ct])
				laserHead();
	
			// bracket
			xCarriageBracket();
			
				
				
			// long screws
			for (x=[-1,1],y=[-1,1])
				translate([x*22.3,y*22.3,thick_wall])
				screw(M5_cap_screw, 30);
		
		}
		
	end("xCarriage");
}

module yCarriageBracket() {
	
	ct = yCarriageBracket_thickness;
	cw = yCarriageBracket_width;
	ch = yCarriageBracket_height;
	
	vitamin("yCarriageBracket");

	color("blue")
		render()
		difference() {
			linear_extrude(ct) 
				difference() {
					roundedSquare([cw,ch],10);
			
					// screw holes
					for (x=[-1,1],y=[-1,1])
						translate([x*22.3,y*22.3,ct])
						circle(screw_clearance_radius(M5_cap_screw));
				}
				
			// screw countersinks
			for (x=[-1,1],y=[-1,1])
				translate([x*22.3,y*22.3,thick_wall])
				cylinder(r=screw_head_radius(M5_cap_screw), h=ct);
		}
	
}

module yCarriageAssembly() {
	assembly("yCarriage");

	translate([0,0,openrail_plate_offset]) {

		// plate and wheels
		rotate([0,0,180]) 
			openrail_plate20(wheels=true);
	
		// bracket
		yCarriageBracket();
		
		// long screws
			for (x=[-1,1],y=[-1,1])
				translate([x*22.3,y*22.3,thick_wall])
				screw(M5_cap_screw, 30);
	}
	

	end("yCarriage");
}


module xRailAssembly() {

	l = frameCY[4] - frameCY[1] + ORPlateWidth(ORPLATE20);
	railLen = bedWM + ORPlateWidth(ORPLATE20)/2;
	
	mirrorYOffset = xCarriageToLaserHeadIngress + laserMirror_fixingOffset;
	
	// drive belt centres
	beltCX = [frameCY[1]+20 , frameCY[4]];
	beltCY = [-12 - openrail_plate_offset];
	beltCZ = [16];
	
	beltIR = pulley_ir(T5x10_metal_pulley);
	
	assembly("xRail");
	
	// coordinate frame
	frame();
	
	// 20x20
	translate([-l/2,0,0]) 
		rotate([0,90,0]) 
		aluProExtrusion(BR_20x20, l=l);
		
	// openrail
	translate([-railLen/2,-10,10]) { 
		rotate([0,90,0]) rotate([0,0,90]) openrail_doubled(railLen,true,true);
	}
	
	// xCarriage
	translate([0,-openrail_plate_offset - openrail_groove_offset,0]) 	
		xCarriageAssembly();
	
	
	// y belt clips
	for (i=[0,1])
		mirror([i,0,0]) {
		
			translate([l/2-10,-28.3, -63]) 
				cube([10,12,30]);
			translate([l/2,-32.3, -63]) 
				roundedRectX([5,20,53],3);
		}
		
		
	// motor assembly
	translate([beltCX[1],beltCY[0],beltCZ[0]]) {
		rotate([0,180,0]) {
			NEMA(NEMA17);
			metal_pulley(T5x10_metal_pulley);
		}
		
		translate([-25,-23,-6]) roundedRect([50,60,6],6);
	}

	// idler/mirror assembly
	translate([beltCX[0],beltCY[0],beltCZ[0]]) {
	
		// idler screw
		screw(M5_cap_screw);
		
		// idler
		rotate([0,180,0]) 
			metal_pulley(T5x10_metal_pulley);
	}
	
	// mirror
	translate([frameCY[1] - laserMirror_fixingOffset, -mirrorYOffset, -10])
		rotate([0,0,135])
		laserMirror();
	
	
	
	// belt
	translate([0,0,beltCZ[0] - 15])
		belt(T5x10, beltCX[0], beltCY[0], beltIR , beltCX[1], beltCY[0], beltIR, gap = 0); 	
	
	
	
	end("xRail");
}

module xAxisAssembly() {

	t  =ORPlateThickness(ORPLATE20);
	l = frameCY[4] - frameCY[1] + ORPlateWidth(ORPLATE20);

	railLen = bedWM + ORPlateWidth(ORPLATE20)/2;
	
	

	assembly("xAxis");
	
	// show co-ordinate frame
	frame();

	// x rail
	translate([0,
			   22.3,
			   openrail_plate_offset + yCarriageBracket_thickness + 10]) 
		xRailAssembly();


	// y carriages
	for (i=[0,1])
		mirror([i,0,0])
		translate([frameCY[4],0, 0]) 
		yCarriageAssembly();
		
		
	// y sealing plates
	if (showSealingBelts) 
		for (i=[0,1])
		mirror([i,0,0]) {
		
			translate([frameCY[3]-8,-80,-25])
				color(grey20)
				render()
				difference () {
					cube([5,105,80]);
				
					// belt
					translate([-1,42,20]) 
						cube([10,20,12]);
					
					// rail
					translate([-1,70,13]) 
						cube([10,22,22]);
					
					// laser	
					translate([-1,20,50]) 
						roundedRectX([10,10,10],4);
					
				}
			
		}
		
	end("xAxis");
}
