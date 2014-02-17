




module yAxesAssembly() {

	railLen = bedDM + ORPlateDepth(ORPLATE20)/2;
	
	w = NEMA_width(NEMA17);
	d = w + 10;
	
	beltIR = pulley_ir(T5x10_metal_pulley);

	beltCX = [frameCY[4] +  w/2 + 2];
	beltCY = [frameCX[0] + 40, 
			  frameCX[3] - 40];
	beltCZ = [frameCZ[2] - 16];
	
	
	// xAxis
	translate([0,yCarriagePos + 35,frameCZ[2] + openrail_groove_offset])
		xAxisAssembly();
	
	
	// y rails
	for (i=[1,4]) {
		BR20x20WGBP([frameCY[i],frameCX[0]+10,frameCZ[2]], 
		            [frameCY[i],frameCX[3]-10,frameCZ[2]],
		            roll=0,
		            startGussets=[0,0,0,0], 
		            endGussets=[0,0,0,0]);
	}
	
	// end brackets for rails
	for (x=[0,3],y=[0,3]) {
		translate([(frameCY[x] + frameCY[x+2])/2,frameCX[y],frameCZ[2]])
			rotate([180,0,0]) 
			20x20TGusset_stl(width=(frameCY[x+2]-frameCY[x]-20), screws=true, coreScrew=true, coreSide=y==0?false:true);
	}
	
	// openrails
	for (i=[0,1])
		mirror([i,0,0])
		translate([frameCY[4] + 10,-bedDM/2 + 20,frameCZ[2] + 10]) 
		rotate([-90,90,0])
	 {
			translate([0,20,0]) openrail_doubled(railLen,true,true);
		}
		
	
	
	
	// alternate motor position
	// motor mount plate
	con_xAxis_to_motorMount = [[frameCY[1]+10,beltCY[1]-28,frameCZ[2]], [1,0,0], 90];
	
	attach(con_xAxis_to_motorMount, xAxisMotorPlateConnectors[0]) 
		xAxisMotorPlate_stl(showMotor=true);
		
	// 2nd y-axis motor
	con_xAxis_to_motorMount2 = [[frameCY[4]-10,beltCY[1]-28,frameCZ[2]], [-1,0,0], -90];
	
	attach(con_xAxis_to_motorMount2, xAxisMotorPlateConnectors[0]) 
		xAxisMotorPlate_stl(showMotor=true);
		
		
	// idlers
	con_yAxis_to_yIdler = [[frameCY[1],frameCX[0]+15,frameCZ[2]], [0,1,0], 0];
	
	attach(con_yAxis_to_yIdler, yIdlerAssemblyConnectors[0]) 
		yIdlerAssembly();
		
		
	
	// belts
	*for (i=[0,1])
		mirror([i,0,0]) 
		translate([0,0,beltCZ[0] + 15])
		belt(T5x10, beltCX[0], beltCY[0], beltIR , beltCX[0], beltCY[1], beltIR, gap = 0);
	
	
	
		
		
	// mirror
	translate([frameCY[1],frameCX[3] - 45,frameCZ[2]])
		fixedMirrorHolderAssembly();
	
	
	// sealing belts
	if (showSealingBelts) 
		for (i=[0,1])
		mirror([i,0,0]) 
		{
			// the belt
			translate([frameCY[3]-10, frameCX[0]+20 ,frameCZ[2] + 12])
				color(belt_color)
				render()
				difference() {
					roundedRect([110,railLen + 60, 80], 10, shell=2);
					
					// punch out for sealing plate
					translate([-1,xCarriagePos + bedDM/2 + 2,0]) 
						cube([10,80,100]);
				}
				
			// corner rollers
			translate([frameCY[3] + 2, frameCX[0] + 32 ,frameCZ[2] + 2])
				color(grey80)
				render() {
					
					for (i=[0,1],j=[0,1]) 
						translate([i*86,j* (railLen + 36),0])
						cylinder(r=10, h=100);
					
				}
			
	}
}


// little holder for 3x  6x1mm disc neodymium magnets for use with hall sensor on Y2
module yMagnetHolder_stl() {
	mr = 6/2 + 0.5;
	mh = 3*1 + 0.5;
	
	h = mh + 3*layers;
	
	sr = screw_clearance_radius(M4_cap_screw);
	
	r = washer_radius(M4_washer);

	dw = default_wall;
	
	mo = sr + mr + 3;

	color(x_carriage_color)
		difference() {
			linear_extrude(h)
			difference() {
				hull() {
					circle(r);
					
					translate([mo,0,0])
						circle(mr + dw);
				}
			
				// screw hole
				circle(sr);
			}
		
			// hollow for magnets
			translate([mo,0,-eta])
				cylinder(r=mr, h=mh + eta);
		}
	
	// mating parts	
	if (false) {
		translate([0,0,h])
			screw_and_washer(M4_cap_screw, M4_washer);
	}
}