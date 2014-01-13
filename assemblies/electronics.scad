


module arduinoMegaBracket1_stl() {
	
	rc = frameCY[5] - frameCY[3];
	
	w = rc + 10;
	d = 9;
	t = 5*perim;
	
	ardW = 53.3;
	fixW = 48.3;
	ardO = (ardW - fixW)/2 + (rc-ardW)/2;
	
	r1 = screw_clearance_radius(M4_hex_screw);
	r2 = 3/2;

	color(x_carriage_color)	
		render()
		difference() {
			union() {
				linear_extrude(t)
					difference() {
						translate([-5,-d/2])
							square([w,d]);
						
						// frame fixing holes
						circle(r1);
						translate([rc,0,0])
							circle(r1);

					}
					
				// arduino locating posts
				translate([ardO,0,t-eta]) {
					cylinder(r=r2, h=4);
					
					translate([fixW,-1.3,0])
						cylinder(r=r2, h=4);
						
					// print support
					translate([0,0,1])
						cube([perim,d/2,3]);
					
					translate([fixW,-1,1])
						cube([perim,d/2+1,3]);
				}
				
				// retaining clip
				translate([ardO+fixW + 4,d/2-3,t-eta]) {
					cube([4perim,3,4+4perim]);
					
					translate([-5,0,4])
						cube([6,3,4perim]);
				}
		
				20x20SnapFitting_stl(embed=true);
			
				translate([rc,0,0]) 
					20x20SnapFitting_stl(embed=true);
				
			}
		
			// fracture lines
			for (i=[0,1])
				translate([-4 + i*(rc-6),-d/2-1,perim])
				cube([14,d+2,perim]);	
				
			// weight loss?
			
		}
}



module arduinoMegaBracket2_stl() {
	
	rc = frameCY[5] - frameCY[3];
	
	w = rc + 10;
	d = 9;
	t = 5*perim;
	
	ardW = 53.3;
	fixW = 48.3;
	yO = 6.35;
	ardO = (ardW - fixW)/2 + (rc-ardW)/2;
	
	r1 = screw_clearance_radius(M4_hex_screw);
	r2 = 3/2;

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
								translate([ardO,0,0])
									circle(d/2);
							
								translate([ardO,-yO,0])
									circle(d/2);
								
							}
						}
						
						// frame fixing holes
						circle(r1);
						translate([rc,0,0])
							circle(r1);
							
						// weight loss
						translate([ardO + d/2,-d/2-eta,0])
							trapezoid(fixW-15,fixW-5,d/2+eta,aOffset=5,center=false);
						
					}
		
				20x20SnapFitting_stl(embed=true);
			
				translate([rc,0,0]) 
					20x20SnapFitting_stl(embed=true);
					
				// arduino locating posts
				translate([ardO,0,t-eta]) {
					translate([fixW,0,0])
						cylinder(r=r2, h=4);
					
					translate([0,-yO,0])
						cylinder(r=r2, h=4);
						
					// print support
					translate([fixW,0,1])
						cube([perim,d/2,3]);
					
					translate([0,-yO,1])
						cube([perim,yO+d/2,3]);
				}
				
			}
		
			// fracture lines
			for (i=[0,1])
				translate([-4 + i*(rc-6),-d/2-1,perim])
				cube([14,d+2,perim]);	
		}
}




module PSUBracket_stl() {
	
	rc = frameCY[5] - frameCY[3];
	
	w = rc + 10;
	d = 9;
	t = 8*perim;
	
	r1 = screw_clearance_radius(M4_hex_screw);
	
	fixW = 52;
	offset = (rc-fixW)/2;
	outset = 5.5;
	
	pw = 2*(r1+ default_wall);
	ph = outset+r1+default_wall;
	pd = d/2;
	

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
						*translate([offset,0,0]) {
							circle(r1);
							
							translate([fixW,0,0])
								circle(r1);
						}
					}
					
				// mounting posts
				for (i=[0,1])
					translate([offset + i*fixW, 0, 0])
					difference() {
						union() {
							translate([-pw/2,0,0])
								cube([pw,pd,t+ph-pw/2]);
								
							translate([0,0,t+outset])
								rotate([-90,0,0])
								cylinder(r=pw/2, h=pd);
						}
						
						translate([0,0,t+outset])
							rotate([90,0,0])
							cylinder(r=r1, h=100, center=true);
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



module rearCableManagementBracket_stl() {
	
	rc = frameCX[3] - frameCX[2];
	
	w = rc + 10;
	d = 9;
	t = 6*perim;
	
	fixW = 52;
	offset = (rc-fixW)/2;
	
	r1 = screw_clearance_radius(M4_hex_screw);
	r2 = screw_clearance_radius(M3_hex_screw);
	
	numClips = 4;
	clipW = 12;
	clipH = 6;
	clipSpacing = (rc - 20 - clipW) / (numClips-1);
	

	color(x_carriage_color)	
		render()
		difference() {
			union() {
				linear_extrude(t)
					difference() {
						translate([-5,-d/2])
							square([w,d]);
						
						
						// frame fixing holes
						circle(r1);
						translate([rc,0,0])
							circle(r1);
							
						// weight loss
						translate([5,-d/2-1,0])
							trapezoid(rc-20,rc-10,d/2+1,aOffset=5,center=false);
						
					}
					
				// cable clips
				for (i=[0:numClips-1])
					translate([5 + i*clipSpacing,d/2,t-eta]) 
					rotate([90,0,0])
					linear_extrude(d/2)
					union() {
						translate([default_wall*2-eta,clipH-default_wall,0])
							square([clipW - 5*default_wall/2,default_wall]);
						
						translate([clipW-default_wall/2,clipH-default_wall/2,0])
							circle(default_wall/2);
							
						translate([0,0,0])
							square([default_wall,clipH-2*default_wall+eta]);
							
						translate([default_wall*2,clipH-default_wall*2,0])
							rotate([0,0,90])
							donutSector2D(2*default_wall,default_wall,90);
					}
					
				// end nubbin
				translate([rc-10,0,t-default_wall])
					roundedRectY([default_wall,d/2,clipH + default_wall],default_wall/2);
				
		
				20x20SnapFitting_stl(embed=true);
			
				translate([rc,0,0]) 
					20x20SnapFitting_stl(embed=true);
				
			}
		
			// fracture lines
			for (i=[0,1])
				translate([-4 + i*(rc-6),-d/2-1,perim])
				cube([14,d+2,perim]);	
		}
		
	// dummy
	*BR20x20WGBP([0,0,-10],[0,100,-10]);
	*BR20x20WGBP([frameCX[3]-frameCX[2],0,-10],[frameCX[3]-frameCX[2],100,-10]);
	
}


module rightCableManagementBracket_stl() {
	
	dw = default_wall;
	2dw = 2*dw;
	
	rc = 50;
	
	w = rc + 5;
	d = 9;
	t = 6*perim;
	
	r1 = screw_clearance_radius(M4_hex_screw);
	r2 = screw_clearance_radius(M3_hex_screw);
	
	numClips = 4;
	clipW = 10;
	clipH = 6;
	spaceForClips = rc - 5;
	clipSpacing = (spaceForClips - clipW) / (numClips-1);

	color(x_carriage_color)	
		render()
		difference() {
			union() {
				linear_extrude(t)
					difference() {
						translate([-5,-d/2])
							square([w,d]);
						
						
						// frame fixing
						circle(r1);
							
						// weight loss
						translate([5,-d/2-1,0])
							trapezoid(rc,rc+10,d/2+1,aOffset=5,center=false);
						
					}
					
				// cable clips
				for (i=[0:numClips-1])
					translate([5 + i*clipSpacing,d/2,t-eta]) 
					rotate([90,0,0])
					linear_extrude(d/2)
					union() {
						translate([default_wall/2,clipH-2dw,0])
							circle(default_wall/2);
							
						translate([default_wall*2-eta,clipH-default_wall,0])
							square([clipW - 4*dw + 2*eta,default_wall]);
							
						translate([default_wall*2,clipH-default_wall*2,0])
							rotate([0,0,90])
							donutSector2D(2*default_wall,default_wall,90);
							
						translate([clipW-2dw,clipH-2dw,0])
							donutSector2D(2dw,dw,90);
							
						translate([clipW-dw,0,0])
							square([dw,clipH-2dw+eta]);
						
					}
				
		
				20x20SnapFitting_stl(embed=true);
				
			}
		
			// fracture lines
			for (i=[0])
				translate([-4 + i*(rc-6),-d/2-1,perim])
				cube([14,d+2,perim]);	
		}
		
	// dummy
	*BR20x20WGBP([0,0,-10],[0,100,-10]);
	*BR20x20WGBP([frameCX[3]-frameCX[2],0,-10],[frameCX[3]-frameCX[2],100,-10]);
	
}



module laserPSUBracket_stl() {
	
	rc = frameCY[5] - frameCY[3];
	
	csd = screw_head_height(M4_pan_screw) + washer_thickness(M4_washer);
	
	csd2 = screw_head_height(M3_pan_screw) + washer_thickness(M3_washer);
	
	w = rc + 20;
	d = 9;
	t = 8*perim + csd;
	
	// offset to PSU fixing hole
	offset = 9;
	
	r1 = screw_clearance_radius(M4_hex_screw);
	r2 = screw_clearance_radius(M3_hex_screw);  // PSU fixing hole
	
	bw = 10 - screw_head_radius(M4_pan_screw);
	bh = offset + d/2;
	
	numClips = 4;
	clipW = 12;
	clipH = 6;
	clipSpacing = (rc - 20 - clipW) / (numClips-1);
	

	color(x_carriage_color)	
		render()
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
							
						// weight loss
						translate([10,-d/2-1,0])
							trapezoid(rc-30,rc-20,d/2+1,aOffset=5,center=false);
						
					}
				
				20x20SnapFitting_stl(embed=true);
			
				translate([rc,0,0]) 
					20x20SnapFitting_stl(embed=true);
					
				// PSU fixing
				translate([rc+10 - bw, -d/2,t-eta])
					difference() {
						union() {
							cube([bw, d, bh - d/2]);
						
							translate([0,d/2,bh-d/2])
								rotate([0,90,0])
								cylinder(r=d/2,h=bw);	
						}
						
					
						// screw hole
						translate([0,d/2,offset])
							rotate([0,90,0])
							cylinder(r=r2,h=2*bw+2,center=true);
							
						// countersink
						translate([bw - csd2,d/2,offset])
							rotate([0,90,0])
							cylinder(r=washer_clearance_radius(M3_washer),h=2*bw);
					}
				
			}
		
			// fracture lines
			for (i=[0,1])
				translate([-9 + i*(rc),-d/2-1,perim])
				cube([18,d+2,perim]);	
				
			// countersink frame fixings
			translate([0,0,8*perim])
				cylinder(r=washer_clearance_radius(M4_washer),h=t);
			translate([rc,0,8*perim])
				cylinder(r=washer_clearance_radius(M4_washer),h=t);
				
			// weight loss
			translate([15,d/2+1,t/2])
				rotate([90,0,0])
				trapezoidPrism(rc-20,rc-30,d/2+1,aOffset=-5,height=d+2,center=false);
		}
		
		
	if (false) {	
		
		// rails
		BR20x20WGBP([0,0,-10],[0,100,-10]);
		BR20x20WGBP([rc,0,-10],[rc,100,-10]);
	
		// screws
		translate([0,0,6*perim]) 
			screw_and_washer(M4_pan_screw, M4_washer);
		translate([rc,0,6*perim]) 
			screw_and_washer(M4_pan_screw, M4_washer);
	}
}



module RPIBracket1_stl() {
	
	rc = frameCY[5] - frameCY[3];
	
	w = rc + 10;
	d = 9;
	t = 5*perim;
	
	piW = 56;
	ardO = (rc - 20 - piW)/2 + 10 + 18;
	
	r1 = screw_clearance_radius(M4_hex_screw);
	r2 = 3/2;

	color(x_carriage_color)	
		render()
		difference() {
			union() {
				linear_extrude(t)
					difference() {
						translate([-5,-d/2])
							square([w,d]);
						
						// frame fixing holes
						circle(r1);
						translate([rc,0,0])
							circle(r1);
							
						// weight loss
						translate([ardO + 5,-d/2-1,0])
							trapezoid(rc-25-ardO,rc-15-ardO,d/2+1,aOffset=5,center=false);

					}
					
				// locating posts
				translate([ardO,0,t-eta]) {
					cylinder(r=r2, h=4);
					
					
					// print support
					translate([0,0,1])
						cube([perim,d/2,3]);

				}
				
				// retaining clip
				*translate([ardO+fixW + 4,d/2-3,t-eta]) {
					cube([4perim,3,4+4perim]);
					
					translate([-5,0,4])
						cube([6,3,4perim]);
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
		
		
		// dummy pi
		*color([0.1,0.5,0.1,0.3])
			translate([(rc - 20 - piW)/2 + 10,-59,t]) {
			difference() {
				cube([piW, 84,2]);
				
				translate([18,59,-1])
					cylinder(r=3/2, h=10);
					
				translate([56 - 12.6, 10,-1])
					cylinder(r=3/2, h=10);
			}
		}
}

module RPIBracket2_stl() {
	
	rc = frameCY[5] - frameCY[3];
	
	w = rc + 10;
	d = 9;
	t = 5*perim;
	
	piW = 56;
	ardO = (rc - 20 - piW)/2 + 10 + piW - 12.6;
	
	r1 = screw_clearance_radius(M4_hex_screw);
	r2 = 3/2;

	color(x_carriage_color)	
		render()
		difference() {
			union() {
				linear_extrude(t)
					difference() {
						translate([-5,-d/2])
							square([w,d]);
						
						// frame fixing holes
						circle(r1);
						translate([rc,0,0])
							circle(r1);
							
						// weight loss
						translate([10,-d/2-1,0])
							trapezoid(ardO-25,ardO-15,d/2+1,aOffset=5,center=false);

					}
					
				// locating posts
				translate([ardO,0,t-eta]) {
					cylinder(r=r2, h=4);
					
					
					// print support
					translate([0,0,1])
						cube([perim,d/2,3]);

				}
				
				// retaining clip
				translate([ardO + 12.6 + 1,d/2-3,t-eta]) {
					cube([4perim,3,4+4perim]);
					
					translate([-5,0,4])
						cube([6,3,4perim]);
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


// panel mount for fused, switched IEC inlet socket
module PowerSocketMount_stl() {
	sw = 28 + 0.6;  // inc tolerance
	sh = 47 + 0.6;
	
	rc = frameCY[5] - frameCY[3];
	
	dw = default_wall;
	tw  = thick_wall;
	
	t = dw;
	
	w = rc + 20;
	h = sw + 2*tw;
	
	linear_extrude(t)
		difference() {
			roundedSquare([w,h],5,center=false);
		
			// hole for socket
			translate([(w-sh)/2,(h-sw)/2,0])
				square([sh,sw]);
				
			// fixing holes
			for (i=[0:1])
				translate([10 + i*rc,h/2,0])
				circle(screw_clearance_radius(M4_hex_screw));
		}
}



// simple protective case for relay module
module relayModuleCase_stl() {
	dw = default_wall;
	pcbW = 50.5;
	pcbD = 39;
	fixingInset = 3;  // fixings are 3mm from each corner
	fixingR = screw_clearance_radius(M3_cap_screw);
	caseW =  pcbW + 2 + 2*dw;
	caseD =  pcbD + 2 + 2*dw;
	
	difference() {
		union() {
			roundedRect([caseW, caseD, 3*layers],3,center=true);
			
			// walls
			for (j=[-1,1])
				translate([0,j*(caseD/2 - dw/2),5/2])
				cube([pcbW,dw, 5], center=true);	
		}
		
		// fixings
		for (i=[-1,1],j=[-1,1])
			translate([i*(pcbW/2-fixingInset), j*(pcbD/2-fixingInset), 0])
			cylinder(r=fixingR, h=10, center=true);
	}
}
