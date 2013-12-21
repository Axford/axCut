module laserTube() {
	color([1,1,1,0.4]) 
		cylinder(r=60/2, h=700);
}

module laserAssembly() {

	translate([-350, frameCX[3]-50,frameCZ[2]+60]) 
		rotate([0,90,0]) 
		laserTube();

}




fixedMirrorZOffset = openrail_plate_offset + 
							   openrail_groove_offset + 
							   xCarriageBracket_thickness;

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
}