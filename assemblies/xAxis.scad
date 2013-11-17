
xCarriageBracket_width = ORPlateWidth(ORPLATE20);
xCarriageBracket_height = xCarriageBracket_width;
xCarriageBracket_thickness = 9;


yCarriageBracket_width = ORPlateWidth(ORPLATE20);
yCarriageBracket_height = ORPlateWidth(ORPLATE20);
yCarriageBracket_thickness=9;


xCarriageToLaserHeadIngressY = openrail_plate_offset + 
							   openrail_groove_offset + 
							   xCarriageBracket_thickness + 
							   laserHeadBody_tubeOffsetZ;     // world coord frame

xCarriageToLaserHeadOriginY = -laserHeadBody_ingressOffsetY
							  - 10
							  + laserMirror_width/2;  // world coord frame


xBeltClamp_width = 2*default_wall + 2*screw_clearance_radius(M3_hex_screw);
xBeltClamp_depth = 12 + 4*default_wall + 4*screw_clearance_radius(M3_hex_screw);
xBeltClamp_height = default_wall;
xBeltClamp_screwCentres = (xBeltClamp_depth - xBeltClamp_width);

module xBeltClamp_stl() {
	stl("xBeltClamp");
	
	// local coordinate frame
	//frame();
	
	color(x_belt_clamp_color)
		render()
		linear_extrude(xBeltClamp_height)
		difference() {
			hull()
				for (i=[0,1])
				mirror([0,i,0])
				translate([xBeltClamp_width/2,xBeltClamp_screwCentres/2,0])
				circle(r=xBeltClamp_width/2);
			
			
			// screw holes
			for (i=[0,1])
				mirror([0,i,0])
				translate([xBeltClamp_width/2,xBeltClamp_screwCentres/2,0])
				circle(screw_clearance_radius(M3_hex_screw));
		}
	
}


xBeltTensioner_radius = 5;


module xBeltTensioner_stl() {
	stl("xBeltTensioner");

	//local coordinate frame
	frame();

	

}


module xCarriageBracket_stl() {
	ct = xCarriageBracket_thickness;
	cw = xCarriageBracket_width;
	ch = xCarriageBracket_height;
	
	stl("xCarriageBracket");

	color(x_carriage_color)
		render()
		union() {
			difference() {
				linear_extrude(ct) 
					difference() {
						roundedSquare([cw,ch],10);
			
						// screw holes for openrail plate
						for (x=[-1,1],y=[-1,1])
							translate([x*22.3,y*22.3,ct])
							circle(screw_clearance_radius(M5_cap_screw));
							
						// screw holes for laser head
						translate([-laserHeadBody_mountSlotToTubeX,
			           			   laserHeadBody_mountScrew1Y + xCarriageToLaserHeadOriginY, 
			           			   0]) 
			           			   circle(screw_clearance_radius(M4_hex_screw));
			           			   
			           	translate([-laserHeadBody_mountSlotToTubeX,
			           			   laserHeadBody_mountScrew2Y + xCarriageToLaserHeadOriginY, 
			           			   0]) 
			           			   circle(screw_clearance_radius(M4_hex_screw));
			           			   
			           	// screw holes for belt clamps
			           	for (i=[0,1],j=[-1,1])
							mirror([0,i,0])
							translate([j*(cw/2-xBeltClamp_width/2), xBeltClamp_screwCentres/2, 0])
							circle(screw_clearance_radius(M3_hex_screw));
							
			
					}
				
				// screw countersinks for openrail plate
				for (x=[-1,1],y=[-1,1])
					translate([x*22.3,y*22.3,ct - screw_head_height(M5_cap_screw)])
					cylinder(r=screw_head_radius(M5_cap_screw), h=ct);
					
				// screw head traps for laser head
				translate([-laserHeadBody_mountSlotToTubeX,
			           	   laserHeadBody_mountScrew1Y + xCarriageToLaserHeadOriginY, 
			           	   -eta]) 
					cylinder(r=screw_head_radius(M4_hex_screw),h=screw_head_height(M4_hex_screw), $fn=6);
					
				translate([-laserHeadBody_mountSlotToTubeX,
			           	   laserHeadBody_mountScrew2Y + xCarriageToLaserHeadOriginY, 
			           	   -eta]) 
					cylinder(r=screw_head_radius(M4_hex_screw),h=screw_head_height(M4_hex_screw), $fn=6);
			
				// notches for belt
				for (i=[0,1])
					mirror([i,0,0])
					translate([cw/2 - 15,-6,ct-1.7])
					cube([20,12,10]);
					
				// screw head traps for belt clamps
				for (i=[0,1],j=[-1,1])
					mirror([0,i,0])
					translate([j*(cw/2-xBeltClamp_width/2), xBeltClamp_screwCentres/2, -eta])
					cylinder(r=screw_head_radius(M3_hex_screw),h=screw_head_height(M3_hex_screw), $fn=6);
					
			
			}
			
			// teeth to engage belt on left side
			for (i=[0:5])
				translate([-cw/2 + 0.75 + i*2.5,0,ct-1.7 - eta + 0.5])
				rotate([90,0,0])
				trapezoidPrism(1,1.5,1 + eta,0.25,12,center=true);
			
			
			// belt clamp right
			translate([cw/2 - xBeltClamp_width,-xBeltClamp_depth/2,ct-eta]) 
				difference() {
					roundedRect([xBeltClamp_width,xBeltClamp_depth,xBeltTensioner_radius*2],xBeltClamp_width/2);
			
					// lower notch for belt
					translate([-1,(xBeltClamp_depth - 12)/2,-1])  
						cube([xBeltClamp_width+2,12,2]);
					
					// screw holes
					for (i=[0,1])
						translate([xBeltClamp_width/2,xBeltClamp_width/2 + i*xBeltClamp_screwCentres,-1])
						cylinder(r=screw_clearance_radius(M3_hex_screw), h=100);
					
					// hole for tensioner
					translate([-1,xBeltClamp_depth/2,xBeltTensioner_radius])
						rotate([0,90,0])
						cylinder(r=screw_clearance_radius(M3_hex_screw), h=100);
					
					
					// nut trap for tensioner
					translate([-1,xBeltClamp_depth/2,xBeltTensioner_radius])
						rotate([0,90,0])
						cylinder(r=screw_head_radius(M3_hex_screw), h=screw_head_height(M3_hex_screw), $fn=6);
			}
				
		
			// cable chain bracket
			translate([12,ch/2-1,0])
				cube([20,19,ct]);
			translate([12,ch/2 + 9,-36])
				cube([20,9,37]);
		
		}
}



module xCarriageAssembly() {
	ct = xCarriageBracket_thickness;
	cw = xCarriageBracket_width;
	ch = xCarriageBracket_height;
	
	assembly("xCarriage");
	
	translate([0,0,0]) 
		rotate([90,0,0]) {
			// plate
			openrail_plate20(wheels=true);


			// laser head
			translate([-laserHeadBody_tubeOffsetX, 
					   xCarriageToLaserHeadOriginY,
					   ct])
				laserHead(100);
	
			// bracket
			xCarriageBracket_stl();
			
			
			// screws, nuts, washers for laserhead
			translate([-laserHeadBody_mountSlotToTubeX,
			           laserHeadBody_mountScrew1Y + xCarriageToLaserHeadOriginY, 
			           0])
					translate([0,0,screw_head_height(M4_hex_screw)])
					mirror([0,0,1])	
					screw_washer_and_nut(M4_hex_screw, M4_nut, 20, ct + laserHeadBody_plateThickness - screw_head_height(M4_hex_screw), true);
					
				
			translate([-laserHeadBody_mountSlotToTubeX,
			           laserHeadBody_mountScrew2Y + xCarriageToLaserHeadOriginY, 
			           0]) 
					translate([0,0,screw_head_height(M4_hex_screw)])
					mirror([0,0,1])
					screw_washer_and_nut(M4_hex_screw, M4_nut, 20, ct + laserHeadBody_plateThickness - screw_head_height(M4_hex_screw), true);
					
			// long screws through openplate and wheels
			for (x=[-1,1],y=[-1,1])
				translate([x*22.3,y*22.3,thick_wall])
				screw(M5_cap_screw, 30);
		
		
			// belt clamp left
			translate([-cw/2,0,ct]) xBeltClamp_stl();
			
			// screws, washers, nuts for belt clamp left
			for (i=[0,1])
				mirror([0,i,0])
				translate([-cw/2+xBeltClamp_width/2, xBeltClamp_screwCentres/2, screw_head_height(M3_hex_screw)])
				mirror([0,0,1])
				screw_washer_and_nut(M3_hex_screw, M3_nut, 16, ct + xBeltClamp_height - screw_head_height(M3_hex_screw));
			
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

module xAxisCableChain() {
	
	z = 60;  // vertical offset to mounting point, relative to xAxis coord frame
	
	
	xExcess = ((xCarriagePos + bedW/2))/2;
	
	*translate([xCarriagePos + 30,0,z])
		frame();
	
	// silicone tube
	color(silicone_color)
		curvedPipe([ [frameCY[3],0,7],
					[xCarriagePos - xExcess - 30,0,7],
					[xCarriagePos - xExcess - 30,0,z],
					[xCarriagePos + 30,0,z]
				   ],
					3,
					[z/2-5,z/2-5],
					5,
					3);
}


module xRailAssembly() {

	l = frameCY[4] - frameCY[1] + ORPlateWidth(ORPLATE20);
	railLen = bedWM + ORPlateWidth(ORPLATE20)/2;
	
	mirrorYOffset = xCarriageToLaserHeadIngressY + laserMirror_fixingOffset;
	
	// drive belt centres
	beltCX = [frameCY[1]+20 , frameCY[4]];
	beltCY = [-13 - openrail_plate_offset];
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
	translate([xCarriagePos,-openrail_plate_offset - openrail_groove_offset,0]) 	
		xCarriageAssembly();
	
	
	// cable chain
	xAxisCableChain();
	
	
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
			metal_pulley(pulley_type);
		}
		
		translate([-25,-23,-6]) roundedRect([50,60,6],6);
	}

	// idler/mirror assembly
	translate([beltCX[0],beltCY[0],beltCZ[0]]) {
	
		// idler screw
		screw(M5_cap_screw);
		
		// idler
		rotate([0,180,0]) 
			metal_pulley(pulley_type);
	}
	
	// mirror
	translate([frameCY[1] - laserMirror_fixingOffset, -mirrorYOffset, -10])
		rotate([0,0,135])
		laserMirror([bedD - (yCarriagePos + bedD/2), xCarriagePos + bedW/2 + 80]);
	
	
	
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
