//

cableChain_width = 12;
cableChain_height = 12;
cableChain_length = 26;  // link length, must be greater than 2 * height

cableChain_wall = 1.5;
cableChain_spacing = 0.3;  // inter link spacing

cableChain_maxAngle = 45;

module cableChainLink() {
	w = cableChain_width;
	h = cableChain_height;
	l = cableChain_length;
	wall = cableChain_wall;
	s = cableChain_spacing;
	s2 = sqrt( s*s + s*s);
	ma = 90 - cableChain_maxAngle;
	
	j = l - 2 * h -s;
	
	r1 = h/2;
	
	lx1 = r1*sin(ma);
	ly1 = r1*cos(ma);
	lx2 = r1*sin(ma) - (r1 - ly1)/tan(ma);
	
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
							polygon([
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
					
						translate([h/2,h/2])
							circle(h/4 - wall + s2 + perim/2);
					}
			
					// nipple
					translate([h/2,h/2,-eta]) 
						cylinder(r1=h/4 + s2,r2=h/4 - wall + s2,h=wall+2*eta);
				}
			
			// join
			translate([h + j,-w/2,0])
				rotate([0,-90,0])
				linear_extrude(j)
					difference() {
						square([h,w]);
				
						union() {
							translate([wall,2*wall,0])
								square([h/2, w-4*wall]);
							
							translate([h/2 + wall,w/2,0])
								circle((w-4*wall)/2);
						}
					}
			
	
		}	
}