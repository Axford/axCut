
xCarriageBracket_width = ORPlateWidth(ORPLATE20);
xCarriageBracket_height = xCarriageBracket_width - 20;
xCarriageBracket_thickness = 9;


module xCarriageBracket() {
	ct = xCarriageBracket_thickness;
	cw = xCarriageBracket_width;
	ch = xCarriageBracket_height;

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
	
	// plate
	translate([0,0,0]) 
		rotate([90,0,0]) {
			openrail_plate20(wheels=true);


			translate([-laserHeadBody_tubeOffsetX, 
					   -(laserHeadBody_mountScrew2Y - laserHeadBody_mountScrew1Y),
					   ct])
				laserHead();
	
			// bracket
			xCarriageBracket();
			
				
				
			// long screws
			for (x=[-1,1],y=[-1,1])
				translate([x*22.3,y*22.3,thick_wall])
				screw(M5_cap_screw, 30);
		
		}
}

module xAxisAssembly() {

	t  =ORPlateThickness(ORPLATE20);
	l = frameCY[4] - frameCY[1] + ORPlateWidth(ORPLATE20);

	railLen = bedWM + ORPlateWidth(ORPLATE20)/2;
	
	// drive belt centres
	beltCX = [-railLen/2 - 15 , railLen/2 + 30];
	beltCY = [-12 - openrail_plate_offset];
	beltCZ = [16];
	
	beltIR = pulley_ir(T5x10_metal_pulley);

	// x rail
	translate([-l/2,0,0]) 
		rotate([0,90,0]) 
		aluProExtrusion(BR_20x20, l=l);

	translate([-railLen/2,-10,10]) { 
		rotate([0,90,0]) rotate([0,0,90]) openrail_doubled(railLen,true,true);
	}

	// motor assembly
	translate([beltCX[1],beltCY[0],beltCZ[0]]) {
		rotate([0,180,0]) {
			NEMA(NEMA17);
			metal_pulley(T5x10_metal_pulley);
		}
		
		translate([-25,-23,-6]) roundedRect([50,60,6],6);
	}

	// idler assembly
	translate([beltCX[0],beltCY[0],beltCZ[0]]) {
		rotate([0,180,0]) metal_pulley(T5x10_metal_pulley);
		
		translate([-10,-10,-6]) roundedRect([20,50,6],6);
		
		translate([-10,-10,-32]) roundedRect([20,50,6],6);
	}
	
	// belt
	translate([0,0,beltCZ[0] - 15])
		belt(T5x10, beltCX[0], beltCY[0], beltIR , beltCX[1], beltCY[0], beltIR, gap = 0); 


	translate([0,-openrail_plate_offset-10,0]) 	
		xCarriageAssembly();	
	
	
	
	// y carriages
	for (i=[0,1])
		mirror([i,0,0])
		translate([frameCY[4],0, -10]) 
		rotate([0,0,180]) 
		openrail_plate20(wheels=true);
		
	// y belt clips
	for (i=[0,1])
		mirror([i,0,0]) {
		
			translate([l/2-10,-6, -43]) 
				cube([10,12,30]);
			translate([l/2,-10, -43]) 
				cube([5,20,53]);
		}
		
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
}
