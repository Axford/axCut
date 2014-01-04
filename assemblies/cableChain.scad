//

cableChain_width = 18;
cableChain_height = 12;
cableChain_length = 30;  // link length, must be greater than 2 * height

cableChain_wall = 1;
cableChain_spacing = 0.2;  // inter link spacing

cableChain_maxAngle = 45;

module cableChainLink_stl() {
	w = cableChain_width;
	h = cableChain_height;
	l = cableChain_length;
	wall = cableChain_wall;
	s = cableChain_spacing;
	s2 = sqrt( s*s + s*s);
	ma = 90 - cableChain_maxAngle;
	
	j = l - 2 * h ;
	
	r1 = h/2;
	
	lx1 = r1*sin(ma);
	ly1 = r1*cos(ma);
	lx2 = r1*sin(ma) - (r1 - ly1)/tan(ma);
	
	nr =h/4 - wall + s2 + perim;
	
	color(x_carriage_color)
		render()
		union() {
	
			// male
			for (i=[0,1])
				mirror([0,i,0])
				translate([0,w/2,0])
				rotate([90,0,0])
				union() {
					linear_extrude(wall)
						union() {
							translate([h/2,0,0])
								square([h/2+eta,h]);
			
							translate([h/2,h/2])
								circle(r1);
				
							square([h+eta,h/2]);
			
							// maxAngle segment
							// this doesn't work in reality - needs larger surface area
							*polygon([
								[h/2,h/2],
								[h/2 - lx1, h/2 + ly1],
								[h/2 - lx2,h],
								[h/2,h]
							]);
						}
			
					// nipple
					translate([h/2,h/2,wall-eta]) 
						cylinder(r1=h/4 + s,r2=h/4 - wall,h=wall+eta+s);
				}
			
			// female
			for (i=[0,1])
				mirror([0,i,0])
				translate([l - h,w/2 - wall - s,0])
				rotate([90,0,0])
				difference() {
					linear_extrude(wall)
					difference() {
						union() {
							translate([-s - eta,0,0])
								square([h/2 + s + eta,h]);
			
							translate([h/2,h/2])
								circle(r1);
						}
					
						// nipple hole
						translate([h/2,h/2])
							circle(nr);
							
						// teardrop the nipple
						translate([h/2,h/2,0])
							polygon([
								[-cos(45)*nr,sin(45)*nr],
								[cos(45)*nr,sin(45)*nr],
								[0,2*cos(45)*nr]
							]);
							
						// teardrop the bottom as well
						translate([h/2,h/2,0])
							polygon([
								[-cos(45)*nr,-sin(45)*nr],
								[cos(45)*nr,-sin(45)*nr],
								[0,-2*cos(45)*nr]
							]);
					}
			
					// nipple
					translate([h/2,h/2,-eta]) 
						cylinder(r1=h/4 + s2,r2=h/4 - wall + s2,h=wall+2*eta);
				}
			
			// join
			difference() {
				translate([h + j,-w/2,0])
					rotate([0,-90,0])
					linear_extrude(j)
						union() {
							// central rib
							translate([0,w/2 - perim/2,0])
								square([h, perim]);
					
							difference() {
								square([h,w]);
				
								translate([wall,2*wall+s,0])
									square([h - 2*wall, w-4*wall-2*s]);
							}
						}
						
				// weight loss
				if (j > 5*wall) {
					translate([h+wall,-(w-4*wall-2*s)/2,-1])
						cube([j-2*wall, w-4*wall-2*s, h+2]);
						
				}
			}
			
	
		}	
}





module cableChainFrameFixingFemale_stl() {
	w = cableChain_width;
	h = cableChain_height;
	l = cableChain_length;
	wall = cableChain_wall;
	s = cableChain_spacing;
	s2 = sqrt( s*s + s*s);
	ma = 90 - cableChain_maxAngle;
	
	j = l - 2 * h ;
	
	r1 = h/2;
	
	lx1 = r1*sin(ma);
	ly1 = r1*cos(ma);
	lx2 = r1*sin(ma) - (r1 - ly1)/tan(ma);
	
	nr =h/4 - wall + s2 + perim;
	
	color(x_carriage_color)
		render()
		union() {
	
			// frame fitting
			linear_extrude(default_wall)
				difference() {
					translate([0,-w/2,0])
						roundedSquare([h+3,w],3,center=false);
					
					translate([h/2,0,0])
						circle(screw_clearance_radius(M4_cap_screw));
				}
				
			// fillets
			for (i=[0,1])
				mirror([0,i,0])
				translate([h+eta,-w/2+wall,0])
				rotate([90,0,0])
				mirror([1,0,0])
				right_triangle(h-3, h, wall, center = false);
				
			
			// female
			for (i=[0,1])
				mirror([0,i,0])
				translate([l - h,w/2 - wall - s,0])
				rotate([90,0,0])
				difference() {
					linear_extrude(wall)
					difference() {
						union() {
							translate([-s - eta,0,0])
								square([h/2 + s + eta,h]);
			
							translate([h/2,h/2])
								circle(r1);
							
						}
					
						// nipple hole
						translate([h/2,h/2])
							circle(nr);
							
						// teardrop the nipple
						translate([h/2,h/2,0])
							polygon([
								[-cos(45)*nr,sin(45)*nr],
								[cos(45)*nr,sin(45)*nr],
								[0,2*cos(45)*nr]
							]);
							
						// teardrop the bottom as well
						translate([h/2,h/2,0])
							polygon([
								[-cos(45)*nr,-sin(45)*nr],
								[cos(45)*nr,-sin(45)*nr],
								[0,-2*cos(45)*nr]
							]);
					}
			
					// nipple
					translate([h/2,h/2,-eta]) 
						cylinder(r1=h/4 + s2,r2=h/4 - wall + s2,h=wall+2*eta);
				}
			
			// join
			translate([h + j,-w/2,0])
				rotate([0,-90,0])
				linear_extrude(j)
					union() {
						
						difference() {
							square([h,w]);
				
							translate([wall,2*wall+s,0])
								square([h +eta, w-4*wall-2*s]);
							
						}
					}
			
	
		}	
}


module cableChainFrameFixingMale_stl() {
	w = cableChain_width;
	h = cableChain_height;
	l = cableChain_length;
	wall = cableChain_wall;
	s = cableChain_spacing;
	s2 = sqrt( s*s + s*s);
	ma = 90 - cableChain_maxAngle;
	
	j = l - 2 * h ;
	
	r1 = h/2;
	
	lx1 = r1*sin(ma);
	ly1 = r1*cos(ma);
	lx2 = r1*sin(ma) - (r1 - ly1)/tan(ma);
	
	nr =h/4 - wall + s2 + perim;
	
	color(x_carriage_color)
		//render()
		union() {
	
			// frame fitting
			linear_extrude(default_wall)
				difference() {
					translate([l-h-3,-w/2,0])
						roundedSquare([h+3,w],3,center=false);
					
					translate([l-h/2,0,0])
						circle(screw_clearance_radius(M4_cap_screw));
				}
				
			// fillets
			for (i=[0,1])
				mirror([0,i,0])
				translate([l-h-eta,-w/2+wall,0])
				rotate([90,0,0])
				right_triangle(h-3, h, wall, center = false);
				
			
			// male
			for (i=[0,1])
				mirror([0,i,0])
				translate([0,w/2,0])
				rotate([90,0,0])
				union() {
					linear_extrude(wall)
						union() {
							translate([h/2,0,0])
								square([h/2+eta,h]);
			
							translate([h/2,h/2])
								circle(r1);
				
							
							// maxAngle segment
							// this doesn't work in reality - needs larger surface area
							*polygon([
								[h/2,h/2],
								[h/2 - lx1, h/2 + ly1],
								[h/2 - lx2,h],
								[h/2,h]
							]);
						}
			
					// nipple
					translate([h/2,h/2,wall-eta]) 
						cylinder(r1=h/4 + s,r2=h/4 - wall,h=wall+eta+s);
				}
			
			// join
			translate([h + j,-w/2,0])
				rotate([0,-90,0])
				linear_extrude(j)
					union() {
						
						difference() {
							square([h,w]);
				
							translate([wall,2*wall+s,0])
								square([h +eta, w-4*wall-2*s]);
							
						}
					}
			
	
		}	
}


// bracket to hold 20x20mm aluminium L channel against the 20x20 frame
module cableChainChannelBracket_stl() {
	
	w = 16;
	
	color(x_carriage_color)
		render()
		difference() {
			union() {
				linear_extrude(w)
					union() {
						translate([-default_wall,-default_wall,0])
							square([20 + default_wall,default_wall]);
						
						translate([-default_wall,-default_wall,0])
							square([default_wall,10]);
						
						translate([20-default_wall,-w,0])
							square([default_wall,w]);
					}
					
				// fillet
				translate([20,0,0])
					rotate([0,0,180])
					right_triangle(w, w, default_wall, center = false);
				
			}
			
			// frame fixing hole
			translate([0,-w/2 -default_wall,w/2])
				rotate([0,90,0])
				cylinder(r=screw_clearance_radius(M4_cap_screw),h=100,center=true);
				
			// rail fixing hole
			translate([10,0,w/2])
				rotate([90,0,0])
				cylinder(r=screw_clearance_radius(M4_cap_screw),h=100,center=true);
		}
	
	
	
	// dummy L bracket
	*translate([0,0,-80])
		color("silver")
		render()
		linear_extrude(100) 
		union() {
			square([20,2]);
			square([2,20]);
		}
}