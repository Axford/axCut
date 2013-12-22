
fixedMirrorZOffset = openrail_plate_offset + 
							   openrail_groove_offset + 
							   xCarriageBracket_thickness;

laserTubeOffsetY = 45;


module laserTube() {
	color([1,1,1,0.4]) 
		cylinder(r=50/2, h=700);
}




laserBracket_railCentres = frameCZ[3] - frameCZ[1] - 10;

module laserBracket_stl() {

	stl("laserBracket");
	
	rc = laserBracket_railCentres;

	t = default_wall;
	h = 20;
	
	nh = 2*nut_radius(M5_nut) + 2*default_wall;
	nw = nut_thickness(M5_nut) + 2*default_wall;
	
	ir = 60/2;
	
	lp = [-laserTubeOffsetY, frameCZ[2] - frameCZ[1] + fixedMirrorZOffset + laserMirror_width/2];

	color(x_carriage_color)
		render()
		difference() {
		union() {
			// base plate
			linear_extrude(t) 
				difference() {
					hull() {
						// spring collars
						for (i=[0,1])
							translate([lp[0],lp[1],0])
							rotate([0,0,25 -i*165])
							translate([50/2 + 5 + nw/2,0,0])
							rotate([0,90,0]) 
							circle(r=nw/2);
							
						// nut traps
							for (i=[0,1])
								translate([lp[0],lp[1],0])
								rotate([0,0,-i*120])
								translate([50/2 + 5,-nh/2,0])
								rotate([0,90,0]) 
								roundedSquare([nw,nh],3,center=false);
					
						// frame fixings
						translate([-10,10,0])
							square([20,default_wall],center=false);
					
						translate([-10,rc - 20 - default_wall,0])
							square([20,default_wall],center=false);
				
					}
			
					// hollow for laser tube
					translate([lp[0],lp[1],0])
						circle(r=ir);
						
					// hollow for frame
					translate([-10,rc-20,0])
						square([20,40],center=false);
						
					// spring fixings
						for (i=[0,1])
							translate([lp[0],lp[1],0])
							rotate([0,0,25 -i*165])
							translate([50/2 + 5 + nw/2,0,0])
							rotate([0,90,0]) 
							circle(r=screw_clearance_radius(M3_hex_screw));
			
					// weight loss
					translate([-6,15,0])
						roundedSquare([12,rc - 40],4,center=false);
				
					hull() {
						translate([-14,24,0]) circle(4);
						translate([-14,56,0]) circle(4);
						translate([-36,38,0]) circle(4);
					}
			
				}
			
			linear_extrude(h) 
				difference() {
					difference() {					
						hull() {
							// nut traps
							for (i=[0,1])
								translate([lp[0],lp[1],0])
								rotate([0,0,-i*120])
								translate([50/2 + 5,-nh/2,0])
								rotate([0,90,0]) 
								roundedSquare([nw,nh],3,center=false);
					
							// frame fixings
							translate([-10,10,0])
								square([20,default_wall],center=false);
					
							translate([-10,rc - 20 - default_wall,0])
								square([20,default_wall],center=false);
				
						}
			
						// hollow for laser tube
						translate([lp[0],lp[1],0])
							circle(r=ir);
					}
				
					difference() {					
						hull() {
							// nut traps
							for (i=[0,1])
								translate([lp[0],lp[1],0])
								rotate([0,0,-i*120])
								translate([50/2 + 5 + default_wall,-nh/2,0])
								rotate([0,90,0]) 
								square([nw - 2*default_wall,nh - 2*default_wall],3,center=false);
					
							// frame fixings
							translate([-10,10 + default_wall,0])
								square([20 +1,default_wall],center=false);
					
							translate([-10,rc - 20 - 2*default_wall,0])
								square([20 +1,default_wall],center=false);
				
						}
			
						// hollow for laser tube
						translate([lp[0],lp[1],0])
							circle(r=ir + default_wall);
					}
				
			
				}
			
			// nut traps
			for (i=[0,1])
				linear_extrude(h)
				translate([lp[0],lp[1],0])
				rotate([0,0,-i*120])
				translate([50/2 + 5,-nh/2,0])
				rotate([0,90,0]) 
				difference() {
					roundedSquare([nw,nh],3,center=false);
			
					translate([nw/2, nh/2])
						square([nut_thickness(M5_nut)+0.5, 2*nut_flat_radius(M5_nut)+0.5],center=true);	
				}
			
			// frame fixings
			linear_extrude(h) {
				translate([-10,10,0])
					square([20,default_wall],center=false);
					
				translate([-10,rc - 20 - default_wall,0])
					square([20,default_wall],center=false);
			}
		
		}
	
		// laser tube screws
		for (i=[0,1])
			translate([lp[0],lp[1],10])
			rotate([0,0,-i*120])
			translate([50/2 + 20,0,0])
			rotate([0,90,0]) 
			cylinder(r=screw_clearance_radius(M5_cap_screw), h=100, center=true);
			
		// screw driver acces hole
		*translate([0,lp[1],10])
			rotate([0,90,0])
			cylinder(r=7, h=100);
		
		// frame fixings
		translate([0,0,10])
			rotate([-90,0,0])
			cylinder(r=screw_clearance_radius(M4_cap_screw),h=2*rc);
		
		// weight loss
		*for (i=[0:2])
			translate([0,24+i*20,10])
			rotate([0,90,0])
			cylinder(r=7, h=100);
		
			
		for (i=[0:2])
			rotate([0,0,57])
			translate([-2,26+i*18,10])
			rotate([0,90,0])
			cylinder(r=6, h=10);
			
		for (i=[0:2])
			translate([lp[0],lp[1],10])
			rotate([0,0,-30 - i*30])
			translate([ir-5,0,0])
			rotate([0,90,0])
			cylinder(r=6, h=10);
		
	}
	
}


module laserBracketAssembly() {
	lp = [-laserTubeOffsetY, frameCZ[2] - frameCZ[1] + fixedMirrorZOffset + laserMirror_width/2];
	rc = laserBracket_railCentres;
	
	assembly("laserBracketAssembly");
	
	laserBracket_stl();
			
	// laser adjustment screws
	for (i=[0,1])
		translate([lp[0],lp[1],10])
		rotate([0,0,-i*120])
		translate([50/2 + 20,0,0])
		rotate([0,90,0]) 
		screw(M5_cap_screw, 20);

	// nuts
	for (i=[0,1])
		translate([lp[0],lp[1],10])
		rotate([0,0,-i*120])
		translate([50/2 + 5 + default_wall,0,0])
		rotate([0,90,0]) 
		nut(M5_nut);

	// frame fixings
	translate([0,10,10])
		rotate([-90,0,0])
		20x20TwistLockFixing(default_wall, screw=M4_cap_screw, screwLen = 10, rot=0);	

	translate([0,rc-20,10])
		rotate([-90,0,180])
		20x20TwistLockFixing(default_wall, screw=M4_cap_screw, screwLen = 10, rot=0);
	
	
	end("laserBracketAssembly");
}



module laserAssembly() {

	

	assembly("laserAssembly");

	translate([190, frameCX[3], frameCZ[1]])
	 	rotate([90,0,90]) 
	 	laserBracketAssembly();	
			
	translate([-210, frameCX[3], frameCZ[1]])
	 	rotate([90,0,90]) 
	 	laserBracketAssembly();		
	
	

	translate([-350, frameCX[3]-laserTubeOffsetY,frameCZ[2] + fixedMirrorZOffset + laserMirror_width/2]) 
		rotate([0,90,0]) 
		laserTube();

	end("laserAssembly");

}






fixedMirrorHolderConnectors = [
	[],  // to frame
	[]   // M6 to mirror
];

module fixedMirrorHolder_stl() {
	mw = laserMirror_width;
	md = 2*laserMirror_depth + laserMirror_separation + default_wall;
	mo = (laserMirror_depth + laserMirror_separation)/2;
	
	w = thick_wall;
	d = cos(45)*mw + 2*thick_wall;

	con = fixedMirrorHolderConnectors;
	
	mx = -cos(45)*mw/2 - laserMirror_fixingOffset;
	my = laserMirror_fixingOffset - sin(45)*mw/2;
	mz = fixedMirrorZOffset + mw/2;
	
	// corners of mirror in x/y plane, clockwise from leftmost
	// in stl coordinate frame
	cmw2 = cos(45)*mw/2;
	lmfo = laserMirror_fixingOffset;
	clmd2 = cos(45)*laserMirror_depth/2;
	cmd = cos(45)*(md);
	
	mc = [
		[
			-cmw2 - lmfo -clmd2,
		 	lmfo - cmw2 + clmd2
		 ],
		[
			-lmfo + cmw2 - clmd2,
			lmfo + cmw2 + clmd2
		],
		[
			-lmfo + cmw2 + cmd - clmd2,
			lmfo + cmw2 - cmd + clmd2
		],
		[
			-lmfo - cmw2 + cmd - clmd2,
			lmfo - cmw2 - cmd + clmd2
		]
	];
	
	x1 = -cmw2 - lmfo - clmd2 - 2*cos(45)*thick_wall;
	
	
	mirrorYOffset = xCarriageToLaserHeadIngressY + laserMirror_fixingOffset - 0;
	
	stl("fixedMirrorHolder");
	
	if (debugConnectors) {
		for (i=[0:1])
			connector(con[i]);
	}

	color(x_carriage_color)
		render()
		union() {	
			
		
		
			difference() {
				translate([0,0,-10])
					union() {
						linear_extrude(fixedMirrorZOffset  + 10)
							hull($fn=16) {
								translate([mc[0][0] + 2, mc[0][1] - 2, 0]) circle(thick_wall);
								translate([-14, x1 + 18,0]) circle(4);
								translate([-14,-x1 - 27,0]) circle(4);
							};
							
						translate([0,0,fixedMirrorZOffset + 10 - eta])
							linear_extrude(mw/2 + 10)
							hull($fn=16) {
								translate([mc[0][0] + 2, mc[0][1] - 2, 0]) circle(thick_wall);
								translate([mc[3][0] -5, mc[3][1] + 5, 0]) circle(thick_wall);
							};	
							
					}
				
				
				// subtraction volume for mirror holder
				translate([-laserMirror_fixingOffset,laserMirror_fixingOffset,fixedMirrorZOffset])
					rotate([0,0,45])
					translate([-mw/2,-100,0])
					cube([mw,200,mw]);
					
				
				// m6 side fixing
				translate([mx,my,mz])
					rotate([90,90,-45])
					cylinder(r=screw_clearance_radius(M6_cap_screw),h=100);
					
			
				// frame fixings
				translate([0,x1+23,0])
					 {
						rotate([0,90,0])
							cylinder(r=screw_clearance_radius(M4_cap_screw),h=100,center=true);	
						
						translate([-10-thick_wall,0,0])
							rotate([0,-90,0])
							cylinder(r=screw_head_radius(M4_cap_screw)+1,h=50);
					}
					
				translate([0,-x1-33,0])
					 {
						rotate([0,90,0])
							cylinder(r=screw_clearance_radius(M4_cap_screw),h=100,center=true);	
						
						translate([-10-thick_wall,0,0])
							rotate([0,-90,0])
							cylinder(r=screw_head_radius(M4_cap_screw)+1,h=50);
					}
			
			}	
		}
}


module fixedMirrorHolderAssembly() {
	
	
	fixedMirrorHolder_stl();
	
	translate([-laserMirror_fixingOffset,laserMirror_fixingOffset,fixedMirrorZOffset])
		rotate([0,0,45])
		laserMirror([300, frameCX[3] - bedD/2]);
		
	// frame fixings
	
}





// print these to align the fixed mirror to the laser tube
module laserTubeCalibrator_stl() {
	or = 50/2;
	ir = or - perim;

	union () {
		// base
		linear_extrude(3*layers)
			union() {
				// outer ring
				donut(or,ir-perim);
				
				// aiming hole
				donut(3,1);
				
				// arms
				for (i=[0:4]) {
					rotate([0,0,i*360/5])
						translate([1,-2*perim,0])
						square([ir - 1,4*perim]);
				}
			}
		
		// wall
		tube(or,ir,10,center=false);
	}
}