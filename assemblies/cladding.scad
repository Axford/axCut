

module claddingAssembly() {
	assembly("cladding");
	
	w1 = frameCY[5] - frameCY[0] + 20;
	w2 = frameCY[3] - frameCY[2] + 20;
	
	d1 = frameCX[3] - frameCX[0] + 20;
	d2 = frameCX[3] - frameCX[0] + 20;
	
	// bottom
	color(grey20)
		translate([-w1/2, frameCX[0] - 10, -3])
		cube([w1, d1, 3]);
		
	// inner bottom
	color(grey20)
		translate([0,0,40])
		render()
		linear_extrude(3)
		difference() {
			translate([-w2/2, frameCX[0] - 10, 0])
				square([w2, d2]);
			
			// inner posts
			for (x=[1,2],y=[0,3])
				translate([frameCY[x] - 8,frameCX[y],0])
				roundedSquare([42,62],3,center=true);
			
			// rear inner posts
			for (x=[1,2],y=[1])
				translate([frameCY[x],frameCX[y] + 10,0])
				roundedSquare([22,42],3,center=true);
			
			// stepper brackets
			// ??
			
			// linear rod brackets
			// ??
			
		}
		

	// left/right outer panels
	for (i=[0,1])
		mirror([i,0,0])
		color(grey20)
		translate([frameCY[5]+10, frameCX[0] - 10, 0])
		cube([3, d1, frameCZ[3] + 10]);
	
	
	// left/right inner lower panels
	for (i=[0,1])
		mirror([i,0,0])
		color("orange")
		render()
		translate([frameCY[3]-13, frameCX[0] - 10, 43])
		difference() {
			cube([3, d2, frameCZ[1] + 8]);
			
			// vertical slots for bed
			translate([-2,38,-10]) 
				cube([10,24,frameCZ[1]-73+20]);
	
			translate([-2, bedDM + 15,-10]) 
				cube([10,30,frameCZ[1]-73+20]);
		}
		
	// left/right inner upper panels
	for (i=[0,1])
		mirror([i,0,0])
		color("orange")
		render()
		translate([frameCY[3]-13, frameCX[0] - 10, frameCZ[1]+51])
		difference() {
			cube([3, frameCX[2] - frameCX[0], frameCZ[4] - frameCZ[1]-41]);
			
			// slot for x axis travel and laser path
			translate([-2,70,-2]) roundedRectX([10,bedDM + 15,40],10);
		}
		
	// lower back
	color(polycarbonate_color)
		translate([frameCY[2]+10,frameCX[3]+10,0])
		rotate([-45,0,0])
		render()
		cube([w2-40,3,frameCZ[1]-10]);
		
	// upper back
	color("orange")
		translate([frameCY[2]+10,frameCX[3]+10,frameCZ[1]-10])
		render()
		cube([w2-40,3,frameCZ[3]-frameCZ[1] + 20]);
	
	// inner upper back
	color("orange")
		translate([frameCY[2]+10,frameCX[2]-13,frameCZ[1]-10])
		render()
		cube([w2-40,3,frameCZ[4] - frameCZ[1] + 20]);
		
	// inner shelf
	color("orange")
		translate([0,frameCX[2]-10,frameCZ[1]-13])
		render()
		linear_extrude(3)
		difference() {
			translate([-w2/2+20, 0, 0])
				square([w2-40, frameCX[3] - frameCX[2]  +20]);
			
			// punch out for rear posts
			
		}
	
		
	// front / back sides
	for (i=[0,1],j=[0,1])
		mirror([i,0,0])
		color(grey20)
		render()
		translate([frameCY[3]-10, j==0?frameCX[0] - 10: frameCX[3]+13, 0])
		rotate([90,0,0])
		linear_extrude(3)
		polygon( points=[[0, 0], 
						 [frameCY[5]-frameCY[3]+20, 0],
						 [frameCY[5]-frameCY[3]+20, frameCZ[3]+10],
						 [40, frameCZ[4]+10],
						 [0, frameCZ[4]+10]] );
						 
						 
	// top of sides
	for (i=[0,1])
		mirror([i,0,0])
		color(grey20)
		translate([frameCY[3]-10, frameCX[0] - 10, frameCZ[3] + 10])
		cube([frameCY[5]-frameCY[3] + 20, d1, 3]);
	
	
	// top of back
	color("orange")
		translate([frameCY[2]+10,frameCX[2]-10,frameCZ[3]+10])
		render()
		cube([w2-40,frameCX[3] - frameCX[2] + 20,3]);
	
	
	// lid
	color(polycarbonate_color)
		translate([frameCY[2]+10,frameCX[2]-10,frameCZ[3]+10])
		render()
		rotate([-40,0,0])
		{
			// place origin at hinge line
			translate([0,-(frameCX[2] - frameCX[0]),-(frameCZ[3]-frameCZ[2])]) 
				cube([w2-40,3 ,frameCZ[3]-frameCZ[2]]);
				
			translate([0,-(frameCX[2] - frameCX[0]),0]) 
				cube([w2-40,frameCX[2] - frameCX[0] ,3]);	
		}
	
	
	// front door - needs handle
	color("orange")
		translate([frameCY[2]+10,frameCX[0]-10,frameCZ[0]+20])
		render()
		rotate([60,0,0])
		cube([w2-40,3 ,frameCZ[2]-30]);
	
	end("cladding");
}