cladding_thickness = 3;

cladding_outerWidth = frameCY[5] - frameCY[0] + 20;
cladding_innerWidth = frameCY[3] - frameCY[2] + 20;
	
cladding_outerDepth = frameCX[3] - frameCX[0] + 20;

cladding_outerHeight = frameCZ[3] + 10;

cladding_sideWidth = frameCY[5]-frameCY[3]+20;

cladding_doorWidth = cladding_innerWidth-40;
cladding_doorHeight = frameCZ[2]-30;

cladding_topDepth = frameCX[3] - frameCX[2] + 20;

cladding_upperBackHeight = frameCZ[3]-frameCZ[1] + 20;

cladding_sideInnerHeight = frameCZ[1] + 8;
cladding_sideInnerUpperHeight = frameCZ[4] - frameCZ[1]-41;

cladding_cutMargin = 5;  // gap between panels on sheet layout


module claddingBottom() {
	cube([cladding_outerWidth, cladding_outerDepth, cladding_thickness]);
}


module claddingInnerBottom() {
	render()
		linear_extrude(cladding_thickness)
		difference() 
		{
			translate([0, 0, 0])
				square([cladding_innerWidth, cladding_outerDepth]);
			
			// inner posts
			for (i=[0,1],j=[0,1])
				translate([-2 + i * (cladding_innerWidth - 16), 
				           -2 + j * (cladding_outerDepth - 38),
				           0])
				roundedSquare([22,42],3,center=false);
				
			// stepper brackets
			
			
		}
}

module claddingOuterSide() {
	cube([cladding_outerHeight, cladding_outerDepth, cladding_thickness]);
}


module claddingFrontSide() {
	linear_extrude(cladding_thickness)
		polygon( points=[[0, 0], 
						 [cladding_sideWidth, 0],
						 [cladding_sideWidth, cladding_outerHeight],
						 [40, cladding_outerHeight],
						 [0, cladding_outerHeight]] );
}

module claddingTopSide() {
	cube([cladding_sideWidth, cladding_outerDepth, cladding_thickness]);
}

module claddingFrontDoor() {
	cube([cladding_doorWidth, cladding_doorHeight, cladding_thickness]);
}

module claddingBackDoor() {
	cube([cladding_doorWidth, cladding_doorHeight + 40, cladding_thickness]);
}

module claddingBackTop() {
	cube([cladding_doorWidth,cladding_topDepth,cladding_thickness]);
}

module claddingUpperBack() {
	cube([cladding_doorWidth,cladding_upperBackHeight, cladding_thickness]);
}

module claddingInnerLowerSide() {
	linear_extrude(cladding_thickness)
	difference() {
			square([cladding_sideInnerHeight, cladding_outerDepth]);
			
			// vertical slots for bed
			translate([-2,38,0]) 
				square([frameCZ[1]-73+20, 24]);
	
			translate([-2, bedDM + 15,0]) 
				square([frameCZ[1]-73+20, 30]);
		}
}

module claddingInnerUpperSide() {
	linear_extrude(cladding_thickness)
		difference() {
			square([cladding_sideInnerUpperHeight, frameCX[2] - frameCX[0] - cladding_thickness]);
			
			// slot for x axis travel and laser path
			translate([-2,70,-2]) 
				square([40, bedDM + 30],10);
		}
}


module claddingAssembly() {
	assembly("cladding");
	
	// bottom
	color(grey20)
		translate([-cladding_outerWidth/2, frameCX[0] - 10, -3])
		claddingBottom();
		
		
	// inner bottom
	color("orange")
		translate([-cladding_innerWidth/2,frameCX[0]-10,40])
		claddingInnerBottom();
		

	// left/right outer panels
	for (i=[0,1])
		mirror([i,0,0])
		color(grey20)
		translate([frameCY[5]+10 + cladding_thickness, frameCX[0] - 10, 0])
		rotate([0,-90,0])
		claddingOuterSide();
	
	
	// left/right inner lower panels
	for (i=[0,1])
		mirror([i,0,0])
		color("orange")
		render()
		translate([frameCY[3]-10, frameCX[0] - 10, 40 + cladding_thickness])
		rotate([0,-90,0])
		claddingInnerLowerSide();
		
	// left/right inner upper panels
	for (i=[0,1])
		mirror([i,0,0])
		color("orange")
		render()
		translate([frameCY[3]-10, frameCX[0] - 10, frameCZ[1]+51])
		rotate([0,-90,0])
		claddingInnerUpperSide();
		
	// back door
	color(grey20)
		translate([frameCY[2]+10,frameCX[3]+10,0])
		rotate([45,0,0])
		claddingBackDoor();
		
	// upper back
	color("orange")
		translate([frameCY[2]+10,frameCX[3]+10 + cladding_thickness,frameCZ[1]-10])
		rotate([90,0,0])
		claddingUpperBack();
	
	// inner upper back
	color("orange")
		translate([frameCY[2]+10,frameCX[2]-10,frameCZ[1]-10])
		rotate([90,0,0])
		claddingUpperBack();
		
	// inner shelf
	color("orange")
		translate([frameCY[2]+10,frameCX[2]-10,frameCZ[1]-13])
		claddingBackTop();
	
		
	// front / back sides
	for (i=[0,1],j=[0,1])
		mirror([i,0,0])
		color(grey20)
		render()
		translate([frameCY[3]-10, j==0?frameCX[0] - 10: frameCX[3]+13, 0])
		rotate([90,0,0])
		claddingFrontSide();
						 
						 
	// top of sides
	for (i=[0,1])
		mirror([i,0,0])
		color(grey20)
		translate([frameCY[3]-10, frameCX[0] - 10, frameCZ[3] + 10])
		claddingTopSide();
	
	
	// top of back
	color("orange")
		translate([frameCY[2]+10,frameCX[2]-10,frameCZ[3]+10])
		claddingBackTop();
	
	
	// lid
	color(polycarbonate_color)
		translate([frameCY[2]+10,frameCX[2]-10,frameCZ[3]+10])
		render()
		rotate([-40,0,0])
		{
			// place origin at hinge line
			translate([0,-(frameCX[2] - frameCX[0]),-(frameCZ[3]-frameCZ[2])]) 
				cube([cladding_innerWidth-40,3 ,frameCZ[3]-frameCZ[2]]);
				
			translate([0,-(frameCX[2] - frameCX[0]),0]) 
				cube([cladding_innerWidth-40,frameCX[2] - frameCX[0] ,3]);	
		}
	
	
	// front door - needs handle
	color("orange")
		translate([frameCY[2]+10,frameCX[0]-10,frameCZ[0]+20])
		render()
		rotate([160,0,0])
		claddingFrontDoor();
	
	end("cladding");
}


module claddingSheets() {

	// layout for 2440 x 1220 panels
	
	// sheet 1
	translate() {
		color("black") roundedRect([2440,1220,3],1,shell=5);
	
		// panels on sheet 1
		color(grey20)
		translate([0,0,0]) {
			translate([cladding_outerDepth,0,0])
				rotate([0,0,90])
				claddingBottom();

			// outer sides x2
			for (i=[0,1])
				translate([cladding_outerDepth + cladding_cutMargin + i*(cladding_outerHeight + cladding_cutMargin),0,0])
				rotate([0,0,0])
				claddingOuterSide();
	
			// front/back sides x4
			for (i=[0,1],j=[0,1])
				translate([cladding_outerDepth + cladding_cutMargin + i*(cladding_outerHeight + cladding_cutMargin),
						   cladding_outerDepth + (j+1) * (cladding_sideWidth + cladding_cutMargin),
						   0])
				rotate([0,0,-90])
				claddingFrontSide();
			
			// top sides x2
			for (i=[0,1])
				translate([cladding_outerDepth + cladding_cutMargin +
					      2*(cladding_outerHeight + cladding_cutMargin) +
					      i*(cladding_sideWidth + cladding_cutMargin),0,0])
				rotate([0,0,0])
				claddingTopSide();
				
			translate([cladding_outerDepth + cladding_cutMargin +
					      2*(cladding_outerHeight + cladding_cutMargin) +
					      2*(cladding_sideWidth + cladding_cutMargin) +
					   cladding_doorHeight + 40,
					   0,0])
				rotate([0,0,90])
				claddingBackDoor();


		}
	}
	
	// sheet 2
	translate([0,1300,0]) {
		color("black") roundedRect([2440,1220,3],1,shell=5);
	
		// panels on sheet 1
		color("orange")
		translate([0,0,0]) {
			translate([cladding_outerDepth,0,0])
				rotate([0,0,90])
				claddingInnerBottom();

			translate([cladding_outerDepth + cladding_cutMargin +
					   cladding_doorHeight,0,0])
				rotate([0,0,90])
				claddingFrontDoor();
				
			// back top x2
			for (i=[0,1])
				translate([i*(cladding_doorWidth + cladding_cutMargin),
				 		   cladding_innerWidth + cladding_cutMargin,0])
				claddingBackTop();
				
			// back top x2
			for (i=[0,1])
				translate([cladding_outerDepth + cladding_cutMargin +
						   cladding_doorHeight + 
						   (i+1)*(cladding_upperBackHeight + cladding_cutMargin),
				 		   0,0])
				rotate([0,0,90])
				claddingUpperBack();
				
				
			// inner lower sides x2
			for (i=[0,1])
				translate([cladding_outerDepth + cladding_cutMargin +
						   cladding_doorHeight + cladding_cutMargin +
						   2 * (cladding_upperBackHeight + cladding_cutMargin) +
						   i*(cladding_sideInnerHeight + cladding_cutMargin),
				 		   0,0])	
				claddingInnerLowerSide();
				
			for (i=[0,1])
				translate([cladding_outerDepth + cladding_cutMargin +
						   cladding_doorHeight + cladding_cutMargin +
						   2 * (cladding_upperBackHeight + cladding_cutMargin) +
						   2 * (cladding_sideInnerHeight + cladding_cutMargin) +
						   i*(cladding_sideInnerUpperHeight + cladding_cutMargin),
				 		   0,0])		
				claddingInnerUpperSide();

		}
	}
}