

BlackIceSR1360_bracketHeight = 370;
BlackIceSR1360_bracketDepth = 54;
BlackIceSR1360_bracketWidth = 133;
BlackIceSR1360_bracketChamfer = 8;
BlackIceSR1360_bracketRadius = 3;
BlackIceSR1360_bracketWall = 1;
BlackIceSR1360_fanFixingCentres = 105;
BlackIceSR1360_fanSpacing = 15;
BlackIceSR1360_fanInset = 12.5;
BlackIceSR1360_fanOuterCutoutWidth = 110;
BlackIceSR1360_fanOuterCutoutHeight = 91;
BlackIceSR1360_fanCutoutChamfer = 11;



module BlackIceSR1360() {

	bh = BlackIceSR1360_bracketHeight;
	bd = BlackIceSR1360_bracketDepth;
	bw = BlackIceSR1360_bracketWidth;
	bwall = BlackIceSR1360_bracketWall;
	bc = BlackIceSR1360_bracketChamfer;
	br = BlackIceSR1360_bracketRadius;
	
	fc = BlackIceSR1360_fanFixingCentres;
	fs = BlackIceSR1360_fanSpacing;
	fi = BlackIceSR1360_fanInset;
	
	focw = BlackIceSR1360_fanOuterCutoutWidth;
	foch = BlackIceSR1360_fanOuterCutoutHeight;
	fcc = BlackIceSR1360_fanCutoutChamfer;
	
	color("grey")
		//render()
		union() {
	
			// bracket
			render()
			difference() {
				// shell
				render()
					linear_extrude(bh)
					difference() {
						// outer
						hull() {
							for (x=[-1,1], y=[-1,1])
								translate([x*(bw-2*br)/2,y*(bd-bc-2*br)/2,0])
								circle(br);
							
							for (x=[-1,1], y=[-1,1])
								translate([x*(bw-bc-2*br)/2,y*(bd-2*br)/2,0])
								circle(br);	
						}
					
						// inner
						hull() {
							for (x=[-1,1], y=[-1,1])
								translate([x*(bw-2*br-2*bwall)/2,y*(bd-bc-2*br-2*bwall)/2,0])
								circle(br);
							
							for (x=[-1,1], y=[-1,1])
								translate([x*(bw-bc-2*br-2*bwall)/2,y*(bd-2*br-2*bwall)/2,0])
								circle(br);
						}
					}
		
				// fan cutouts
				for (i=[0:2])
					translate([0,(bd+2)/2,fi + fc/2 + i*(fc+fs)])
					rotate([90,0,0])
					linear_extrude(bd+2)
					chamferedRect([focw, foch], fcc, center=true);
					
				// central cutout
				translate([-(focw-2*fcc)/2, -(bd+2)/2, 4])
					cube([focw-2*fcc, bd+2, bh-8]);
				
				
				// fan fixings
				for (i=[0:2], x=[-1,1], y=[-1,1])
					translate([x*fc/2, 0, fi + fc/2 + i*(fc+fs) + y*fc/2])
					rotate([90,0,0])
					cylinder(r=screw_radius(M4_cap_screw),h=bd+2,center=true);
			}
		
					
	
		
	
	}
	
	// core
	color("black")
		translate([-(bw-2)/2,-20, 1])
		cube([bw-2,33,bh-2]);
}




module radBracket_stl() {
	bh = BlackIceSR1360_bracketHeight;
	bd = BlackIceSR1360_bracketDepth;
	bw = BlackIceSR1360_bracketWidth;
	bwall = BlackIceSR1360_bracketWall;
	bc = BlackIceSR1360_bracketChamfer;
	br = BlackIceSR1360_bracketRadius;
	
	fc = BlackIceSR1360_fanFixingCentres;
	fs = BlackIceSR1360_fanSpacing;
	fi = BlackIceSR1360_fanInset;
	
	rc = frameCY[2] - frameCY[0];
	rz1 = frameCZ[1] - frameCZ[0];
	rz2 = frameCZ[2] - frameCZ[0];
	
	radOY = (rz1 - 30 - bd - 25) / 2;

	tw = thick_wall;
	dw = default_wall;

	t = 9 + tw;
	
	lugw = 5.8;
	
	sr = screw_clearance_radius(M4_cap_screw);
	
	postW = 2*sr + 2*tw;
	

	color(x_carriage_color) 
		//render()
		union() {
			
			linear_extrude(dw)
				difference() {
					hull() {
						for (i=[0,1]) {
							// fan fixing posts				
							translate([rc + 10 - (bw-fc)/2 - i*fc, 20 + radOY - tw, 0]) 
								translate([-postW/2,0,0])
								rounded_square(postW,tw,2,center=false);
		
							// feet
							translate([-10 + i*rc,20,0])
								rounded_square(20,tw,2,center=false);
						}
					}
					
					// weight loss
					hull() {
						for (i=[0,1]) {
							// fan fixing posts				
							translate([rc + 10 - 3 - (bw-fc)/2 - i*(fc-2*tw), 20 + radOY - tw - tw, 0]) 
								translate([-postW/2,0,0])
								rounded_square(postW,tw,2,center=false);
		
							// feet
							translate([-10 + 3.5 + i*(rc-2*tw),20 + tw,0])
								rounded_square(20,tw,2,center=false);
						}
					}
				}
				
			// diagonal brace
			linear_extrude(tw)
				hull() {
						// fan fixing posts				
						translate([rc + 10 - (bw-fc)/2, 20 + radOY - tw/2, 0]) 
							circle(tw/2);
	
						// feet
						translate([-10+tw,20 + tw/2,0])
							circle(tw/2);
					}
					
			// side stiffeners
			difference() {
				linear_extrude(t)
					difference() {
						hull() {
							for (i=[0,1]) {
								// fan fixing posts				
								translate([rc + 10 - (bw-fc)/2 - i*(fc-10), 20 + radOY - tw, 0]) 
									translate([-postW/2,0,0])
									rounded_square(postW,tw,2,center=false);
		
								// feet
								translate([-10 + i*rc,20,0])
									rounded_square(20,tw,2,center=false);
							}
						}
					
						// weight loss
						hull() {
							for (i=[0,1]) {
								// fan fixing posts				
								translate([rc + 10 - 2.7 - (bw-fc)/2 - i*(fc-2*dw - 10), 20 + radOY, 0]) 
									translate([-postW/2,0,0])
									rounded_square(postW,tw,2,center=false);
		
								// feet
								translate([-10 + 3.3 + i*(rc-5),20-tw-1,0])
									rounded_square(20,tw,2,center=false);
							}
						}
					}
					
				// screw access hole
				translate([rc + 10 - (bw-fc)/2 -fc, 20 + radOY - tw, 0]) 
					translate([0,0,9/2 + tw])
					rotate([90,0,0])
					cylinder(r=sr+1, h=100, center=true);
			}
			
			
			// mounting points
			for (i=[0,1]) {
				// fan fixing posts				
				translate([rc + 10 - (bw-fc)/2 -i*fc, 20 + radOY - tw, 0]) 
					difference() {
						translate([-postW/2,0,0])
							roundedRect([postW,tw,t],2);
						
						translate([0,0,9/2 + tw])
							rotate([90,0,0])
							cylinder(r=sr, h=tw*2, center=true);
					}
			
				// feet
				translate([-10 + i*rc,20,0])
					roundedRect([20,tw,t],2);
			
				// locating lugs
				translate([-lugw/2 + i*rc,20-5,0])
					roundedRect([lugw,5+tw,t],2);
			
			}
			
			
		}


	// mating parts
	if (true) {
		translate([rc + 10 -(bw/2), bd/2 + 25 + 20 + radOY, 0]) {
			for (i=[0:2])
				translate([0, -25/2 - bd/2, fi + fc/2 + i*(fc+fs)])
				rotate([90,0,0])
				fan(fan120x25);

			BlackIceSR1360();
		}
		
		// base rails
		BR20x40WGBP([0,0,0],[0,0,400]);
		BR20x40WGBP([rc,0,0],[rc,0,400]);
		
		// mid rail
		BR20x20WGBP([rc,rz1,0],[rc,rz1,400]);
		
		// y rail
		BR20x20WGBP([rc/2,rz2,0],[rc/2,rz2,400]);
	}
}



module coolingTubeGrommet_stl() {
	ir = 14/2;
	wall = 4*perim;
	h = 12;
	
	flangeW = 6;
	flangeH = 4;

	union() {
		difference() {
			tube(ir+wall, ir, h, center=false);
			
			// flare the ends
			translate([0,0,-eta])
				cylinder(r1=ir+2perim, r2=ir, h=2perim);
				
			translate([0,0,h+eta])
				mirror([0,0,1])
				cylinder(r1=ir+2perim, r2=ir, h=2perim);
		}
				
		tube(ir + flangeW, ir+wall-eta, flangeH, center=false);		
	}
}


// cap to mate with gromment inside reservoir
module coolingTubeGrommetCap_stl() {
	ir = 14/2;
	wall = 4*perim;
	h = 12;
	
	flangeW = 6;
	flangeH = 4;

	union() {		
		tube(ir + flangeW, ir+wall+0.1, flangeH, center=false);		
	}
}

module coolingTubeReturnElbow_stl() {
	tubeOR = 14/2;
	tubeIR = 10/2;
	wall = 8*perim;
	
	elbowOR = tubeIR + wall;
	
	outletH = 15;
	
	inletH = 20;
	
	flangeW = 6;
	flangeH = 4;
	flangeR = elbowOR + flangeW;
	
	elbowR = 30;
	
	barbH = 4;
	
	union() {

		// barbed inlet
		translate([elbowR,eta,0])
			rotate([90,0,0])
			conicalTube(tubeOR, tubeIR, tubeOR-2perim, tubeIR-2perim, inletH, $fn=24);
			
		// barbs
		translate([elbowR,-inletH + barbH,0])
			rotate([90,0,0])
			conicalTube(tubeOR, tubeIR, tubeOR-2perim, tubeIR-2perim, barbH, $fn=24);
			
		// flare inlet base
		translate([elbowR,eta,0])
			rotate([90,0,0])
			conicalTube(elbowOR, tubeIR, tubeOR-2perim, tubeIR-2perim, 6, $fn=24);
		
		
		// flanged outlet
		translate([eta,elbowR,0])
			rotate([0,-90,0])
			tube(tubeIR+4*perim, tubeIR, outletH, center=false, $fn=24);
		translate([eta,elbowR,0])
			rotate([0,-90,0])
			tube(flangeR, tubeIR+eta, flangeH, center=false, $fn=24);	


		// stiffener + print support
		sector(elbowR - elbowOR + perim, 90, 4perim, center = true);
		
		translate([-flangeH,0,-2perim])
			cube([flangeH+eta, elbowR-tubeIR-flangeW, 4perim]);
		
		*translate([0,eta,0])
			mirror([0,1,0])
			right_triangle(elbowR-elbowOR,inletH+eta,4perim);
		
		
		// supports for outlet
		for (i=[0:2])
			translate([-outletH+perim + i*(outletH)/3,0,0])
			rotate([0,-90,0])
			linear_extrude(perim)
			difference() {
				translate([-cos(45)*tubeOR,-inletH,0])
					square([2*cos(45)*tubeOR, elbowR + inletH]);
					
				translate([0,elbowR,0])
					circle(tubeOR);
			}
			
		// supports for flange
		for (i=[0:1])
			translate([-flangeH+perim + i*(flangeH-perim),0,0])
			rotate([0,-90,0])
			linear_extrude(perim)
			difference() {
				translate([-cos(45)*flangeR,-inletH,0])
					square([2*cos(45)*flangeR, elbowR + inletH]);
					
				translate([0,elbowR,0])
					circle(tubeOR);
			}
			
		// elbow
		difference() {
			union() {
				intersection() {
					rotate_extrude(convexity=10)
						translate([elbowR,0,0])
						circle(elbowOR, $fn=24);
				
					translate([0,0,-50])
						cube([100,100,100]);
				}
				
				// supports for elbow
				for (i=[0:2])
					translate([5 + i*6,0,0])
					rotate([0,-90,0])
					linear_extrude(perim)
					translate([-cos(45)*elbowOR,-inletH,0])
					square([2*cos(45)*elbowOR, elbowR + inletH]);
			
			}
			
			// hollow the torus
			rotate_extrude(convexity=10)
				translate([elbowR,0,0])
				circle(tubeIR, $fn=24);			
		}
	
	}
}

module coolingTubeReturnElbowCap_stl() {
	wall = 4*perim;
	h = 12;
	
	flangeW = 6;
	flangeH = 4;

	tubeOR = 14/2;
	tubeIR = 10/2;

	union() {		
		tube(tubeIR + flangeW + 4, tubeIR + wall + 0.3, flangeH, center=false);		
	}
}



// placeholder for an assembled flow sensor
module coolingFlowSensor() {
	bodyR = 36/2;
	bodyH = 34;
	pipeOffsetY = 9;  // offset of pipe entreline from body centreline in y
	pipeOffsetZ = 13;
	bodyOutletR = 21/2;
	
	// water flow is towards x+
	
	// pipework
	color("brass")
		for(i=[0:1])
		mirror([i,0,0]) {
			translate([37/2,0,0])
				rotate([0,90,0])
				cylinder(r=27/2,h=7, $fn=6);
				
			translate([37/2,0,0])
				rotate([0,90,0])
				cylinder(r=24/2,h=19);
				
			translate([37/2 + 19,0,0])
				rotate([0,90,0])
				cylinder(r=20/2,h=9);
				
			translate([37/2 + 19 + 9,0,0])
				rotate([0,90,0])
				cylinder(r=24/2,h=14, $fn=6);
				
			translate([37/2 + 19 + 9 + 14,0,0])
				rotate([0,90,0])
				cylinder(r=12/2,h=17);
		}
	
	// body
	color("grey")
		union() {
			translate([0,pipeOffsetY,-pipeOffsetZ]) {
				cylinder(r=bodyR, h=bodyH, $fn=32);
			
				// fixings
				for (i=[0:3])
					rotate([0,0,45 + i*90])
					translate([bodyR,0,bodyH-25])
					cylinder(r=8/2, h=26, $fn=16);	
			}
		
			translate([-bodyH/2-5,0,0])
				rotate([0,90,0])
				cylinder(r=bodyOutletR, h=bodyH+10, $fn=24);
		}
		
		
	// wires
	color("red")
		translate([-3,bodyR,bodyH-pipeOffsetZ-3])
		cube([6,30,2]);
}



// print x2
module coolingFlowSensorBracket_stl() {
	sensorOffsetX = -30;
	sensorOffsetY = -20;
	
	pipeOR = 24/2 + 0.5;
	
	dw  =default_wall;
	tw = thick_wall;
	
	t = 9;
	
	color(x_carriage_color)
		difference() {
			
			union() {
				// snap fitting
				translate([0,-10,9/2])
					rotate([90,0,0])
					20x20SnapFitting_stl(embed=true);
			
				
				linear_extrude(t)
					difference() {
						hull() {
							translate([sensorOffsetX,sensorOffsetY,0])
								rotate([0,0,180])
								sector2D(pipeOR + tw,210);
								
							translate([-10,-10-tw,0])
								rounded_square(20,tw,2,center=false);
						}
						
						translate([sensorOffsetX,sensorOffsetY,0])
							circle(pipeOR);
					}
			
			}
			
			
			// fracture line
			translate([-9,-10 - 2perim - 0.7,-1])
				cube([18,2perim,t+2]);
			
			// screw hole
			translate([0,-10+eta,t/2])
				rotate([90,0,0])
				cylinder(r=screw_clearance_radius(M4_cap_screw), h=100);
				
			// countersink
			translate([0,-10-tw - 3*perim,t/2])
				rotate([90,0,0])
				cylinder(r=screw_head_radius(M4_cap_screw)+0.3, h=100);
		}
	
	// mating part placeholders
	if (false) {
		translate([sensorOffsetX, sensorOffsetY, -26])
			rotate([0,-90,180])
			coolingFlowSensor();
		
		
		BR20x20WGBP([0,0,0],[0,0,400]);
	}
}



module pumpCableGrommet_stl() {
	ir = 6/2;
	wall = 4*perim;
	h = 12;
	
	flangeW = 8;
	flangeH = 4;

	union() {
		difference() {
			tube(ir+wall, ir, h, center=false);
			
			// flare the ends
			translate([0,0,-eta])
				cylinder(r1=ir+2perim, r2=ir, h=2perim);
				
			translate([0,0,h+eta])
				mirror([0,0,1])
				cylinder(r1=ir+2perim, r2=ir, h=2perim);
		}
				
		tube(ir + flangeW, ir+wall-eta, flangeH, center=false);		
	}
}


// cap to mate with gromment inside reservoir
module pumpCableGrommetCap_stl() {
	ir = 6/2;
	wall = 4*perim;
	h = 12;
	
	flangeW = 8;
	flangeH = 4;

	union() {		
		tube(ir + flangeW, ir+wall+0.1, flangeH, center=false);		
	}
}

module waterPumpBracket_stl() {
	
	rc = frameCY[5] - frameCY[3];
	
	w = rc + 20;
	d = 9;
	t = thick_wall;
	
	ardW = 53.3;
	fixW = 48.3;
	ardO = (ardW - fixW)/2 + (rc-ardW)/2;
	
	r1 = screw_clearance_radius(M4_hex_screw);
	r2 = 3/2;

	pumpW = 46;
	pumpFixingC = 30;
	pumpFixingR = screw_clearance_radius(M4_cap_screw);

	color(x_carriage_color)	
		//render()
		difference() {
			union() {
				linear_extrude(t)
					difference() {
						translate([-10,-d/2])
							square([w,d]);
						
						// frame fixing holes
						circle(r1);
						translate([rc,0,0])
							circle(r1);
							
						// pump fixing hole
						translate([pumpFixingC,0,0])
							circle(pumpFixingR);

					}
		
				20x20SnapFitting_stl(embed=true);
			
				translate([rc,0,0]) 
					20x20SnapFitting_stl(embed=true);
				
			}
		
			// fracture lines
			for (i=[0,1])
				translate([-9 + i*rc,-d/2-1,0.7])
				cube([18,d+2,2perim]);	
		}
}

