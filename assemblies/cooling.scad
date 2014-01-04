

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
	if (false) {
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
