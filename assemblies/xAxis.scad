

beltOffset = 28;    // distance from centreline of 20x20 to belt


xCarriageBracket_width = ORPlateWidth(ORPLATE20);
xCarriageBracket_height = xCarriageBracket_width;
xCarriageBracket_thickness = 9;


yCarriageBracketLeft_width = ORPlateWidth(ORPLATE20);
yCarriageBracketLeft_height = ORPlateWidth(ORPLATE20);
yCarriageBracketLeft_thickness=9;

yCarriageBracketRight_width = ORPlateWidth(ORPLATE20);
yCarriageBracketRight_height = ORPlateWidth(ORPLATE20);
yCarriageBracketRight_thickness=9;


xCarriageToLaserHeadIngressY = openrail_plate_offset +
							   openrail_groove_offset +
							   xCarriageBracket_thickness +
							   laserHeadBody_tubeOffsetZ;     // world coord frame

xCarriageToLaserHeadOriginY = -laserHeadBody_ingressOffsetY
							  - 10
							  + laserMirror_width/2;  // world coord frame


xBeltClamp_width = 2*default_wall + 2*screw_clearance_radius(M3_hex_screw);
xBeltClamp_depth = 12 + 4*default_wall + 4*screw_clearance_radius(M3_hex_screw);
xBeltClamp_height = default_wall;
xBeltClamp_screwCentres = (xBeltClamp_depth - xBeltClamp_width);

xBeltClampCon = [
	[[xBeltClamp_width/2, xBeltClamp_screwCentres/2, 0],[0,0,1], 0],  // screw hole 1
	[[xBeltClamp_width/2, -xBeltClamp_screwCentres/2, 0],[0,0,1], 0],   // screw hole 2
	[[xBeltClamp_width/2, 0, xBeltClamp_height], [0,0,-1], 0]   // face to face centre
];

module xBeltClamp_stl() {
	stl("xBeltClamp");

	if (debugConnectors) {
		frame();
		for (i=[0:2])
			connector(xBeltClampCon[i]);
	}

	color(x_belt_clamp_color)
		render()
		union() {
			linear_extrude(xBeltClamp_height)
				difference() {
					hull()
						for (i=[0,1])
						mirror([0,i,0])
						translate([xBeltClamp_width/2,xBeltClamp_screwCentres/2,0])
						circle(r=xBeltClamp_width/2);


					// screw holes
					for (i=[0,1])
						mirror([0,i,0])
						translate([xBeltClamp_width/2,xBeltClamp_screwCentres/2,0])
						circle(screw_clearance_radius(M3_hex_screw));
				}

			// teeth to engage belt on left side
			for (i=[0:2])
				translate([2+ i*2.5, 0, xBeltClamp_height + 0.5 - eta])
				rotate([90,0,0])
				trapezoidPrism(1,1.5,1 + eta,0.25,12,center=true);
		}
}


xBeltTensioner_radius = 5;
xBeltTensionerCon = [
	[[0,0,0],[0,0,1],0]  // face to face
];

module xBeltTensioner_stl() {
	stl("xBeltTensioner");

	//local coordinate frame
	//frame();

	color(x_carriage_color)
		//render()
		difference() {
			rotate([90,0,0])
				union () {
					// core
					sector(xBeltTensioner_radius, 180, 10, center = true);

					// flanges
					for (i=[0,1])
						mirror([0,0,i])
						translate([0,0,5])
						sector(xBeltTensioner_radius+1, 180, 1, center = true);
				}

			// hole for screw
			translate([0,0,-eta])
				cylinder(r=screw_clearance_radius(M3_hex_screw), h=xBeltTensioner_radius/2);
		}
}


xCarriageBracketCon = [
	[[-xCarriageBracket_width/2 + xBeltClamp_width/2,
	  0,
	  xCarriageBracket_thickness + 1], [0,0,1], 0],  // left belt clamp
	[[xCarriageBracket_width/2 - xBeltClamp_width/2,
	  0,
	  xCarriageBracket_thickness + 2*xBeltTensioner_radius + 2], [0,0,1], 0],  // right belt clamp
	  [[xCarriageBracket_width/2 - xBeltClamp_width - 2,
	    0,
	    xCarriageBracket_thickness + xBeltTensioner_radius],[-1,0,0],0]  // belt tensioner
];

module xCarriageBracketOld_stl() {
	ct = xCarriageBracket_thickness;
	cw = xCarriageBracket_width;
	ch = xCarriageBracket_height;

	stl("xCarriageBracket");

	color(x_carriage_color)
		render()
		union() {
			difference() {
				linear_extrude(ct)
					difference() {
						roundedSquare([cw,ch],20);

						// screw holes for openrail plate
						for (x=[-1,1],y=[-1,1])
							translate([x*22.3,y*22.3,ct])
							circle(screw_clearance_radius(M5_cap_screw)+0.5);

						// screw holes for laser head
						translate([-laserHeadBody_mountSlotToTubeX,
			           			   laserHeadBody_mountScrew1Y + xCarriageToLaserHeadOriginY,
			           			   0])
			           			   circle(screw_clearance_radius(M4_hex_screw));

			           	translate([-laserHeadBody_mountSlotToTubeX,
			           			   laserHeadBody_mountScrew2Y + xCarriageToLaserHeadOriginY,
			           			   0])
			           			   circle(screw_clearance_radius(M4_hex_screw));

			           	// screw holes for belt clamps
			           	for (i=[0,1],j=[-1,1])
							mirror([0,i,0])
							translate([j*(cw/2-xBeltClamp_width/2), xBeltClamp_screwCentres/2, 0])
							circle(screw_clearance_radius(M3_hex_screw));


					}

				// screw countersinks for openrail plate
				for (x=[-1,1],y=[-1,1])
					translate([x*22.3,y*22.3,ct - screw_head_height(M5_cap_screw) - 0.5])
					cylinder(r=screw_head_radius(M5_cap_screw)+0.7, h=ct);

				// screw head traps for laser head
				translate([-laserHeadBody_mountSlotToTubeX,
			           	   laserHeadBody_mountScrew1Y + xCarriageToLaserHeadOriginY,
			           	   -eta])
					cylinder(r=screw_head_radius(M4_hex_screw),h=screw_head_height(M4_hex_screw), $fn=6);

				translate([-laserHeadBody_mountSlotToTubeX,
			           	   laserHeadBody_mountScrew2Y + xCarriageToLaserHeadOriginY,
			           	   -eta])
					cylinder(r=screw_head_radius(M4_hex_screw),h=screw_head_height(M4_hex_screw), $fn=6);

				// notch for belt
				translate([-cw/2-1,-6,ct-1.7])
					cube([cw+2,12,10]);

				// screw head traps for belt clamps
				for (i=[0,1],j=[-1,1])
					mirror([0,i,0])
					translate([j*(cw/2-xBeltClamp_width/2), xBeltClamp_screwCentres/2, -eta])
					cylinder(r=screw_head_radius(M3_hex_screw),h=screw_head_height(M3_hex_screw), $fn=6);


			}

			// teeth to engage belt on left side
			*for (i=[0:5])
				translate([-cw/2 + 0.75 + i*2.5,0,ct-1.7 - eta + 0.5])
				rotate([90,0,0])
				trapezoidPrism(1,1.5,1 + eta,0.25,12,center=true);


			// belt clamp right
			translate([cw/2 - xBeltClamp_width,-xBeltClamp_depth/2,ct-eta])
				difference() {
					roundedRect([xBeltClamp_width,xBeltClamp_depth,xBeltTensioner_radius*2],xBeltClamp_width/2);

					// lower notch for belt
					translate([-1,(xBeltClamp_depth - 12)/2,-1])
						cube([xBeltClamp_width+2,12,2]);

					// screw holes
					for (i=[0,1])
						translate([xBeltClamp_width/2,xBeltClamp_width/2 + i*xBeltClamp_screwCentres,-1])
						cylinder(r=screw_clearance_radius(M3_hex_screw), h=100);

					// hole for tensioner
					translate([-1,xBeltClamp_depth/2,xBeltTensioner_radius])
						rotate([0,90,0])
						cylinder(r=screw_clearance_radius(M3_hex_screw), h=100);


					// nut trap for tensioner
					translate([-1,xBeltClamp_depth/2,xBeltTensioner_radius])
						rotate([0,90,0])
						cylinder(r=screw_head_radius(M3_hex_screw), h=screw_head_height(M3_hex_screw), $fn=6);
			}


			// cable chain bracket
			// upstand
			difference() {
				translate([cw/2-20,ch/2-20,0])
					cube([20,39,thick_wall]);

				// screw hole
				translate([22.3,22.3,-1])
					cylinder(r=6, h=20);
			}

			// outrigger
			difference() {
				translate([cw/2-20,ch/2 + 19-thick_wall,-36])
					cube([20,thick_wall,37]);

				translate([cw/2-10,0,-5])
					rotate([-90,0,0])
					cylinder(r=screw_clearance_radius(M4_cap_screw),h=100);

				translate([cw/2-10,0,-30])
					rotate([-90,0,0])
					cylinder(r=screw_clearance_radius(M4_cap_screw),h=100);
			}
			// fillet
			translate([cw/2-default_wall, ch/2 + 19 - thick_wall + eta, eta])
				rotate([-90,0,-90])
				right_triangle(12, 30, default_wall, center = false);


		}
}


module xCarriageBracket_stl() {
	ct = xCarriageBracket_thickness;
	cw = xCarriageBracket_width;
	ch = xCarriageBracket_height;

	stl("xCarriageBracket");

	color(x_carriage_color)
		//render()
		union() {
			difference() {
				linear_extrude(ct)
					difference() {
						chamferedSquare([cw,ch],20, center=true);

						// screw clearance holes for openrail plate
						for (x=[-1,1],y=[-1,1])
							translate([x*22.3,y*22.3,ct])
							circle(screw_head_radius(M5_cap_screw)+1);

						// plate fixings
						for (y=[-1:1])
							translate([0,y*22.3,0])
							circle(r=5.2/2);

						// screw holes for laser head
						translate([-laserHeadBody_mountSlotToTubeX,
			           			   laserHeadBody_mountScrew1Y + xCarriageToLaserHeadOriginY,
			           			   0])
			           			   circle(screw_clearance_radius(M4_hex_screw));

			           	translate([-laserHeadBody_mountSlotToTubeX,
			           			   laserHeadBody_mountScrew2Y + xCarriageToLaserHeadOriginY,
			           			   0])
			           			   circle(screw_clearance_radius(M4_hex_screw));

			           	// screw holes for belt clamps
			           	for (i=[0,1],j=[-1,1])
							mirror([0,i,0])
							translate([j*(cw/2-xBeltClamp_width/2), xBeltClamp_screwCentres/2, 0])
							circle(screw_clearance_radius(M3_hex_screw));


					}

				// screw countersinks for openrail plate
				*for (x=[-1,1],y=[-1,1])
					translate([x*22.3,y*22.3,ct - screw_head_height(M5_cap_screw) - 0.5])
					cylinder(r=screw_head_radius(M5_cap_screw)+0.7, h=ct);

				// plate fixings
				for (y=[-1,1])
					translate([0,y*22.3,ct - screw_head_height(M5_cap_screw) - 0.5])
					cylinder(r=screw_head_radius(M5_cap_screw)+2, h=ct);

				// screw head traps for laser head
				translate([-laserHeadBody_mountSlotToTubeX,
			           	   laserHeadBody_mountScrew1Y + xCarriageToLaserHeadOriginY,
			           	   -eta])
					cylinder(r=screw_head_radius(M4_hex_screw),h=screw_head_height(M4_hex_screw), $fn=6);

				translate([-laserHeadBody_mountSlotToTubeX,
			           	   laserHeadBody_mountScrew2Y + xCarriageToLaserHeadOriginY,
			           	   -eta])
					cylinder(r=screw_head_radius(M4_hex_screw),h=screw_head_height(M4_hex_screw), $fn=6);

				// notch for belt
				translate([-cw/2-1,-6,ct-1.7])
					cube([cw+2,12,10]);

				// screw head traps for belt clamps
				for (i=[0,1],j=[-1,1])
					mirror([0,i,0])
					translate([j*(cw/2-xBeltClamp_width/2), xBeltClamp_screwCentres/2, -eta])
					cylinder(r=screw_head_radius(M3_hex_screw),h=screw_head_height(M3_hex_screw), $fn=6);


			}

			// teeth to engage belt on left side
			*for (i=[0:5])
				translate([-cw/2 + 0.75 + i*2.5,0,ct-1.7 - eta + 0.5])
				rotate([90,0,0])
				trapezoidPrism(1,1.5,1 + eta,0.25,12,center=true);


			// belt clamp right
			translate([cw/2 - xBeltClamp_width,-xBeltClamp_depth/2,ct-eta])
				difference() {
					roundedRect([xBeltClamp_width,xBeltClamp_depth,xBeltTensioner_radius*2],xBeltClamp_width/2);

					// lower notch for belt
					translate([-1,(xBeltClamp_depth - 12)/2,-1])
						cube([xBeltClamp_width+2,12,2]);

					// screw holes
					for (i=[0,1])
						translate([xBeltClamp_width/2,xBeltClamp_width/2 + i*xBeltClamp_screwCentres,-1])
						cylinder(r=screw_clearance_radius(M3_hex_screw), h=100);

					// hole for tensioner
					translate([-1,xBeltClamp_depth/2,xBeltTensioner_radius])
						rotate([0,90,0])
						cylinder(r=screw_clearance_radius(M3_hex_screw), h=100);


					// nut trap for tensioner
					translate([-1,xBeltClamp_depth/2,xBeltTensioner_radius])
						rotate([0,90,0])
						cylinder(r=screw_head_radius(M3_hex_screw), h=screw_head_height(M3_hex_screw), $fn=6);
			}


			// cable chain bracket
			// upstand
			difference() {
				translate([cw/2-20,ch/2-20,0])
					cube([20,39,thick_wall]);

				// screw hole
				translate([22.3,22.3,-1])
					cylinder(r=6, h=20);

				// clearance for silicone tube
				translate([33, 50,-1])
					cylinder(r=8/2, h=20);
			}

			// outrigger
			difference() {
				translate([cw/2-20,ch/2 + 19-thick_wall,-36])
					cube([20,thick_wall,37]);

				translate([cw/2-10,0,-5])
					rotate([-90,0,0])
					cylinder(r=screw_clearance_radius(M4_cap_screw),h=100);

				translate([cw/2-10,0,-30])
					rotate([-90,0,0])
					cylinder(r=screw_clearance_radius(M4_cap_screw),h=100);
			}
			// fillet
			translate([cw/2-default_wall, ch/2 + 19 - thick_wall + eta, eta])
				rotate([-90,0,-90])
				right_triangle(12, 30, default_wall, center = false);


		}
}




module xCarriageAssembly() {
	ct = xCarriageBracket_thickness;
	cw = xCarriageBracket_width;
	ch = xCarriageBracket_height;

	assembly("xCarriage");

	translate([0,0,0])
		rotate([90,0,0]) {
			// plate
			openrail_plate20(wheels=true);


			// laser head
			translate([-laserHeadBody_tubeOffsetX,
					   xCarriageToLaserHeadOriginY,
					   ct])
				laserHead(100);

			// bracket
			xCarriageBracket_stl(showClamps=true, showScrews=true);

			// left belt clamp
			attach(xCarriageBracketCon[0], xBeltClampCon[2])
				xBeltClamp_stl();

			// right belt clamp
			attach(xCarriageBracketCon[1], xBeltClampCon[2])
				xBeltClamp_stl();

			// belt tensioner
			attach(xCarriageBracketCon[2], xBeltTensionerCon[0])
				xBeltTensioner_stl();


			// screws, nuts, washers for laserhead
			translate([-laserHeadBody_mountSlotToTubeX,
			           laserHeadBody_mountScrew1Y + xCarriageToLaserHeadOriginY,
			           0])
					translate([0,0,screw_head_height(M4_hex_screw)])
					mirror([0,0,1])
					screw_washer_and_nut(M4_hex_screw, M4_nut, 20, ct + laserHeadBody_plateThickness - screw_head_height(M4_hex_screw), true);


			translate([-laserHeadBody_mountSlotToTubeX,
			           laserHeadBody_mountScrew2Y + xCarriageToLaserHeadOriginY,
			           0])
					translate([0,0,screw_head_height(M4_hex_screw)])
					mirror([0,0,1])
					screw_washer_and_nut(M4_hex_screw, M4_nut, 20, ct + laserHeadBody_plateThickness - screw_head_height(M4_hex_screw), true);

			// long screws through openplate and wheels
			for (x=[-1,1],y=[-1,1])
				translate([x*22.3,y*22.3,thick_wall])
				screw(M5_cap_screw, 30);




			// screws, washers, nuts for belt clamp left
			for (i=[0,1])
				mirror([0,i,0])
				translate([-cw/2+xBeltClamp_width/2, xBeltClamp_screwCentres/2, screw_head_height(M3_hex_screw)])
				mirror([0,0,1])
				screw_washer_and_nut(M3_hex_screw, M3_nut, 16, ct + xBeltClamp_height - screw_head_height(M3_hex_screw));

			// screws, washers, nuts for belt clamp right
			for (i=[0,1])
				mirror([0,i,0])
				translate([cw/2-xBeltClamp_width/2, xBeltClamp_screwCentres/2, screw_head_height(M3_hex_screw)])
				mirror([0,0,1])
				screw_washer_and_nut(M3_hex_screw, M3_nut, 25, xCarriageBracketCon[1][0][2] + xBeltClamp_height - screw_head_height(M3_hex_screw));

		}

	end("xCarriage");
}

yCarriageBracketRightCon = [
	[[yCarriageBracketRight_width/2 - 20 - 3*xBeltClamp_width/2,
	  0,
	  yCarriageBracketRight_thickness + 1], [0,0,1], 0],  // left belt clamp
	[[yCarriageBracketRight_width/2 - xBeltClamp_width/2,
	  0,
	  yCarriageBracketRight_thickness + 1], [0,0,1], 0],  // right belt clamp
	[[yCarriageBracketRight_width/2 - xBeltClamp_width,
	  -yCarriageBracketRight_width/3,
	  yCarriageBracketRight_thickness+10
	 ],[-1,0,0],0], // frame fixing 1
	[[yCarriageBracketRight_width/2 - xBeltClamp_width,
	  yCarriageBracketRight_width/3,
	  yCarriageBracketRight_thickness+10
	 ],[-1,0,0],0], // frame fixing 2
	 [[
	 	yCarriageBracketRight_width/2 - xBeltClamp_width - 10,
	 	yCarriageBracketRight_width/2,
	 	yCarriageBracketRight_thickness + 10
	 ], [0,-1,0], 0]  // xRail origin
];

module yCarriageBracketRight_stl() {

	ct = yCarriageBracketRight_thickness;
	cw = yCarriageBracketRight_width;
	ch = yCarriageBracketRight_height;
	con = yCarriageBracketRightCon;

	stl("yCarriageBracketRight");

	if (debugConnectors) {
		for (i=[0:4])
			connector(con[i]);
	}

	color(x_carriage_color)
		render()
		union() {
			difference() {
				linear_extrude(ct)
					difference() {
						roundedSquare([cw,ch],10);

						// screw holes for openrail plate
						for (x=[-1,1],y=[-1,1])
							translate([x*22.3,y*22.3,ct])
							circle(screw_clearance_radius(M5_cap_screw)+0.5);

			           	// screw holes for belt clamps
			           	for (i=[0,1],j=[0,1])
							mirror([0,i,0])
							translate([con[j][0][0], xBeltClamp_screwCentres/2, 0])
							circle(screw_clearance_radius(M3_hex_screw));
					}

				// screw countersinks for openrail plate
				for (x=[-1,1],y=[-1,1])
					translate([x*22.3,y*22.3,ct - screw_head_height(M5_cap_screw) - 0.5])
					cylinder(r=screw_head_radius(M5_cap_screw)+0.7, h=ct);


				// notch for belt
				translate([-cw/2-1,-6,ct-1.7])
					cube([cw+2,12,10]);

				// screw head traps for belt clamps
				for (i=[0,1],j=[0,1])
					mirror([0,i,0])
					translate([con[j][0][0], xBeltClamp_screwCentres/2, -eta])
					cylinder(r=screw_head_radius(M3_hex_screw),h=screw_head_height(M3_hex_screw), $fn=6);


			}


			// teeth to engage belt on left side
			for (i=[0:3])
				translate([cw/2 - 0.75 - i*2.5,0,ct-1.7 - eta + 0.5])
				rotate([90,0,0])
				trapezoidPrism(1,1.5,1 + eta,0.25,12,center=true);

			// mounts for x rail
			for (i=[0,1])
				difference() {
					translate([cw/2 - xBeltClamp_width/2, -cw/3 + (i*2*cw/3), (20 + ct)/2])
						roundedRectX([xBeltClamp_width, cw/4, 20 + ct],5,center=true, $fn=16);

					// screw hole
					translate(con[2 + i][0])
						rotate([0,90,0])
						cylinder(r=screw_clearance_radius(M4_cap_screw), h=100, center=true);
				}

		}

}

yCarriageBracketLeftCon = [
	[[yCarriageBracketLeft_width/2 - 20 - 3*xBeltClamp_width/2,
	  0,
	  yCarriageBracketLeft_thickness + 1], [0,0,1], 0],  // left belt clamp
	[[yCarriageBracketLeft_width/2 - xBeltClamp_width/2,
	  0,
	  yCarriageBracketLeft_thickness + 1], [0,0,1], 0],  // right belt clamp
	[[yCarriageBracketLeft_width/2 - xBeltClamp_width,
	  -yCarriageBracketLeft_width/3,
	  yCarriageBracketLeft_thickness+10
	 ],[-1,0,0],0], // frame fixing 1
	[[yCarriageBracketLeft_width/2 - xBeltClamp_width,
	  yCarriageBracketLeft_width/3,
	  yCarriageBracketLeft_thickness+10
	 ],[-1,0,0],0], // frame fixing 2
	 [[
	 	yCarriageBracketLeft_width/2 - xBeltClamp_width - 10,
	 	yCarriageBracketLeft_width/2,
	 	yCarriageBracketLeft_thickness + 10
	 ], [0,-1,0], 0],  // xRail origin
	 [[yCarriageBracketLeft_width/2 - xBeltClamp_width - 10 - beltOffset, -yCarriageBracketLeft_width/2 + 15,0], [0,0,1], 0]  // bearing axle
];


module yCarriageBracketLeft_stl() {

	ct = yCarriageBracketLeft_thickness;
	cw = yCarriageBracketLeft_width;
	ch = yCarriageBracketLeft_height;
	con = yCarriageBracketLeftCon;

	mw = laserMirror_width;
	md = 2*laserMirror_depth + laserMirror_separation + default_wall;
	mo = (laserMirror_depth + laserMirror_separation)/2;

	mirrorYOffset = xCarriageToLaserHeadIngressY + laserMirror_fixingOffset - con[4][0][0];

	stl("yCarriageBracketLeft");

	if (debugConnectors) {
		for (i=[0:5])
			connector(con[i]);
	}

	color(x_carriage_color)
		render()
		union() {
			difference() {
				linear_extrude(ct)
					difference() {
						union () {
							roundedSquare([cw,ch],10);

							translate([-mirrorYOffset,laserMirror_fixingOffset,0])
								rotate([0,0,-135])
								translate([0,mo,0])
								roundedSquare([mw,md],5,center=true);
						}

						// screw holes for openrail plate
						for (x=[-1,1],y=[-1,1])
							translate([x*22.3,y*22.3,ct])
							circle(screw_clearance_radius(M5_cap_screw)+0.5);

			           	// screw holes for belt clamps
			           	for (i=[0,1],j=[0,1])
							mirror([0,i,0])
							translate([con[j][0][0], xBeltClamp_screwCentres/2, 0])
							circle(screw_clearance_radius(M3_hex_screw));

						// screw hole for bearing axle
						translate([con[5][0][0], con[5][0][1], 0])
							circle(screw_clearance_radius(M4_hex_screw));

						// screw holes for mirror
						translate([-mirrorYOffset,laserMirror_fixingOffset,0])
								rotate([0,0,-135]) {
									circle(screw_clearance_radius(M6_cap_screw));

									translate([laserMirror_outerFixingCentres/2,0,0])
										circle(screw_clearance_radius(M4_hex_screw));
									translate([-laserMirror_outerFixingCentres/2,0,0])
										circle(screw_clearance_radius(M4_hex_screw));
								}
					}

				// screw countersinks for openrail plate
				for (x=[-1,1],y=[-1,1])
					translate([x*22.3,y*22.3,ct - screw_head_height(M5_cap_screw) - 0.5])
					cylinder(r=screw_head_radius(M5_cap_screw)+0.7, h=ct);


				// notch for belt
				translate([-cw,-6,ct-1.7])
					cube([2*cw,12,10]);

				// screw head traps for belt clamps
				for (i=[0,1],j=[0,1])
					mirror([0,i,0])
					translate([con[j][0][0], xBeltClamp_screwCentres/2, -eta])
					cylinder(r=screw_head_radius(M3_hex_screw),h=screw_head_height(M3_hex_screw), $fn=6);

				// screw head trap for bearing axle
				translate([con[5][0][0], con[5][0][1], -eta])
					cylinder(r=screw_head_radius(M4_hex_screw), h=screw_head_height(M4_hex_screw), $fn=6);

			}


			// teeth to engage belt on left side
			for (i=[0:3])
				translate([cw/2 - 0.75 - i*2.5,0,ct-1.7 - eta + 0.5])
				rotate([90,0,0])
				trapezoidPrism(1,1.5,1 + eta,0.25,12,center=true);

			// mounts for x rail
			for (i=[0,1])
				difference() {
					translate([cw/2 - xBeltClamp_width/2, -cw/3 + (i*2*cw/3), (20 + ct)/2])
						roundedRectX([xBeltClamp_width, cw/4, 20 + ct],5,center=true, $fn=16);

					// screw hole
					translate(con[2 + i][0])
						rotate([0,90,0])
						cylinder(r=screw_clearance_radius(M4_cap_screw), h=100, center=true);
				}

			// bearing spacer
			translate([con[5][0][0], con[5][0][1],ct-eta])
				difference() {
					cylinder(r1=10,r2=7,h=2.8);

					translate([0,0,-1])
						cylinder(r=screw_clearance_radius(M4_hex_screw), h=100);
				}

		}

}

module yCarriageAssemblyLeft() {
	ct = yCarriageBracketLeft_thickness;
	cw = yCarriageBracketLeft_width;
	ch = yCarriageBracketLeft_height;
	con = yCarriageBracketLeftCon;

	assembly("yCarriageLeft");

	translate([0,0,openrail_plate_offset]) {

		// plate and wheels
		*rotate([0,0,180])
			openrail_plate20(wheels=true);

		// bracket
		rotate([0,0,90]) {
			yCarriageBracketLeft_stl();

			// left belt clamp
			attach(yCarriageBracketLeftCon[0], xBeltClampCon[2])
				xBeltClamp_stl();

			// right belt clamp
			attach(yCarriageBracketLeftCon[1], xBeltClampCon[2])
				xBeltClamp_stl();

			// screws, washers, nuts for belt clamps
			for (i=[0,1],j=[0,1])
				attachWithOffset(con[j], screwCon, [
					0,
					-xBeltClamp_screwCentres/2 + i*xBeltClamp_screwCentres,
					-con[j][0][2] + screw_head_height(M3_hex_screw)
				])
				screw_washer_and_nut(M3_hex_screw, M3_nut, 16, ct + 2);

			// frame fixings
			for (i=[2,3])
				attach(con[i],20x20TwistLockFixingCon)
				20x20TwistLockFixing(xBeltClamp_width, screw=M4_cap_screw, screwLen = 16, rot=0);

			// bearing axle
			attach(
				con[5],
				[[0,0,screw_head_height(M4_hex_screw)],[0,0,-1],0]
			)
				threadTogether([
					washer_thickness(M4_washer),
					ct - screw_head_height(M4_hex_screw) - washer_thickness(M4_washer) + 2.8 + washer_thickness(M5_penny_washer),
					washer_thickness(M4_washer),
					ball_bearing_width(BB624)/2,
					ball_bearing_width(BB624),
					ball_bearing_width(BB624)/2 + washer_thickness(M4_washer),
					washer_thickness(M5_penny_washer),
					2.8 + thick_wall + washer_thickness(M4_washer),
					0
				]) {
					screw(M4_hex_screw,40);
					washer(M4_washer);
					washer(M5_penny_washer);
					washer(M4_washer);
					ball_bearing(BB624);
					ball_bearing(BB624);
					washer(M4_washer);
					washer(M5_penny_washer);
					washer(M4_washer);
					rotate([180,0,0]) nut(M4_nut,nyloc=true);
				}

		}

		// long screws
			for (x=[-1,1],y=[-1,1])
				translate([x*22.3,y*22.3,thick_wall])
				screw(M5_cap_screw, 30);
	}


	end("yCarriageLeft");
}

module yCarriageAssemblyRight() {
	ct = yCarriageBracketRight_thickness;
	cw = yCarriageBracketRight_width;
	ch = yCarriageBracketRight_height;
	con = yCarriageBracketRightCon;

	assembly("yCarriageRight");

	translate([0,0,openrail_plate_offset]) {

		// plate and wheels
		rotate([0,0,180])
			openrail_plate20(wheels=true);

		// bracket
		rotate([0,0,90]) {
			yCarriageBracketRight_stl();

			// left belt clamp
			attach(yCarriageBracketRightCon[0], xBeltClampCon[2])
				xBeltClamp_stl();

			// right belt clamp
			attach(yCarriageBracketRightCon[1], xBeltClampCon[2])
				xBeltClamp_stl();

			// screws, washers, nuts for belt clamps
			for (i=[0,1],j=[0,1])
				attachWithOffset(con[j], screwCon, [
					0,
					-xBeltClamp_screwCentres/2 + i*xBeltClamp_screwCentres,
					-con[j][0][2] + screw_head_height(M3_hex_screw)
				])
				screw_washer_and_nut(M3_hex_screw, M3_nut, 16, ct + 2);

			// frame fixings
			for (i=[2,3])
				attach(con[i],20x20TwistLockFixingCon)
				20x20TwistLockFixing(xBeltClamp_width, screw=M4_cap_screw, screwLen = 16, rot=0);

		}

		// long screws
			for (x=[-1,1],y=[-1,1])
				translate([x*22.3,y*22.3,thick_wall])
				screw(M5_cap_screw, 30);
	}


	end("yCarriageRight");
}

module xAxisCableChain() {

	z = 60;  // vertical offset to mounting point, relative to xAxis coord frame


	xExcess = ((xCarriagePos + bedW/2))/2;

	// silicone tube
	color(silicone_color)
		curvedPipe([ [frameCY[3],0,7],
					[xCarriagePos - xExcess - 30,0,7],
					[xCarriagePos - xExcess - 30,0,z],
					[xCarriagePos + 30,0,z]
				   ],
					3,
					[z/2-5,z/2-5],
					5,
					3);
}


// dims
xAxisMotorPlate_width = NEMA_width(NEMA17) + 2 * default_wall;

// connections
xAxisMotorPlateConnectors = [
	[[xAxisMotorPlate_width/2,10,0], [0,0,1], 0],   // to frame
	[[xAxisMotorPlate_width/2,10 + beltOffset,thick_wall], [0,0,-1], 0],    // to motor
	[[xAxisMotorPlate_width/2,0,0], [0,0,1], 0]  // 2nd optional frame fixing
];

module xAxisMotorPlate_stl( showMotor=false, singleFlange=false) {
	w = xAxisMotorPlate_width;
	d = xAxisMotorPlateConnectors[1][0][1] + NEMA_width(NEMA17)/2;
	h = thick_wall;
	w2 = w / 4;

	fw = 2*screw_clearance_radius(M4_hex_screw) + 2 * default_wall;


	mcon = [[0,0,0],[0,0,1],0];

	color(x_carriage_color)
		union() {
			// base
			linear_extrude(h)
				difference() {
					rounded_square(w,d,5,center=false);

					translate([w/2,xAxisMotorPlateConnectors[1][0][1],0]) {
						// boss
						circle(r=NEMA_big_hole(NEMA17));

						// motor fixings
						for(a = [0: 90 : 90 * (4 - 1)])
							rotate([0, 0, a])
							translate([NEMA_holes(NEMA17)[0], NEMA_holes(NEMA17)[1], 0])
							circle(r=screw_clearance_radius(M3_cap_screw));
					}


					// frame fixings
					for (i=[0,1])
						translate([w2 + 2*w2*i,10,0])
						circle(r=screw_clearance_radius(M4_hex_screw));
				}

			// fixing flanges
			for (i=[singleFlange?1:0,1])
				translate([-fw + i*(w + 2*fw),20,-20])
				mirror([i,0,0])
				difference() {
					hull() {
						translate([fw-1+eta,0,0])
							cube([1, default_wall, 20 + h]);

						translate([fw/2,0,10])
						rotate([-90,0,0])
							cylinder(r=fw/2, h=default_wall, center=false);
					}

					translate([fw/2,0,10])
						rotate([90,0,0])
						cylinder(r=screw_clearance_radius(M4_hex_screw), h=100, center=true);
				}

			// fillets
			for (i=[singleFlange?1:0,1])
				translate([default_wall + i*(w-default_wall),20,eta])
				rotate([-90,0,90])
				difference() {
					trapezoidPrism(17,25,20+eta,0,default_wall,center=false);

					// notch for belt
					translate([8,3,-1])
						trapezoidPrism(10,10,14,-5,default_wall+2,center=false);
				}

		}

	if (debugConnectors) {
		frame();

		for (i=[0:2])
			connector(xAxisMotorPlateConnectors[i]);
	}

	if (showMotor) {

		// frame fixings
		for (i=[0,1])
			translate([w2 + 2*w2*i,10,0])
			20x20TwistLockFixing(h, screw=M4_cap_screw, screwLen = 8);

		for (i=[0,1])
			translate([-fw/2 + i*(w+fw),20,-10])
			rotate([-90,0,0])
			20x20TwistLockFixing(default_wall, screw=M4_cap_screw, screwLen = 10);

		// motor
		attach(xAxisMotorPlateConnectors[1], mcon)
			union() {
				NEMA(NEMA17);
				//connector(mcon, "Red");

				translate([0,0,h]) NEMA_screws(NEMA17);

				translate([0,0,3])
					metal_pulley(pulley_type);
			}
	}
}

xRailLen = frameCY[4] - frameCY[1] + ORPlateWidth(ORPLATE20);

xRailCon = [
	[[-xRailLen/2,0,-openrail_plate_offset],[1,0,0],0]
];

module xRailAssembly() {

	l = xRailLen;
	railLen = bedWM + ORPlateWidth(ORPLATE20)/2;

	mirrorYOffset = xCarriageToLaserHeadIngressY + laserMirror_fixingOffset;

	// drive belt centres
	beltCX = [frameCY[1]+20 , frameCY[4]];
	beltCY = [-14 - openrail_plate_offset];
	beltCZ = [16];

	beltIR = pulley_ir(T2p5x18_metal_pulley);

	assembly("xRail");

	// coordinate frame
	frame();

	// 20x20
	translate([-l/2,0,0])
		rotate([0,90,0])
		aluProExtrusion(BR_20x20, l=l);

	// openrail
	translate([-railLen/2,-10,10]) {
		rotate([0,90,0]) rotate([0,0,90]) openrail_doubled(railLen,true,true);
	}

	// xCarriage
	translate([xCarriagePos,-openrail_plate_offset - openrail_groove_offset,0])
		xCarriageAssembly();


	// cable chain
	xAxisCableChain();


	// motor mount plate
	con_xAxis_to_motorMount = [[beltCX[1],0,10], [0,0,1], 180];

	attach(con_xAxis_to_motorMount, xAxisMotorPlateConnectors[0])
		xAxisMotorPlate_stl(showMotor=true);

	// limit switch
	translate([beltCX[1] - 45,0,10])
		xLimitSwitchAssembly();


	// mirror
	translate([frameCY[1] - laserMirror_fixingOffset, -mirrorYOffset, -10])
		rotate([0,0,135])
		laserMirror([bedD - (yCarriagePos + bedD/2), xCarriagePos + bedW/2 + 80]);



	// belt
	translate([0,0,beltCZ[0] - 15])
		belt(T2p5x6, beltCX[0], beltCY[0], beltIR , beltCX[1], beltCY[0], beltIR, gap = 0);



	end("xRail");
}

module xAxisAssembly() {

	t  =ORPlateThickness(ORPLATE20);
	l = frameCY[4] - frameCY[1] + ORPlateWidth(ORPLATE20);

	railLen = bedWM + ORPlateWidth(ORPLATE20)/2;



	assembly("xAxis");

	// show co-ordinate frame

	if (debugConnectors) {
		frame();
	}


	// left
	translate([frameCY[1],0, 0]) {
		yCarriageAssemblyLeft();

		// x rail
		rotate([0,0,90])
		attach(
			yCarriageBracketLeftCon[4],
			xRailCon[0]
		)
			xRailAssembly();
	}


	// right
	translate([frameCY[4],0, 0])
		yCarriageAssemblyRight();


	// y sealing plates
	if (showSealingBelts)
		for (i=[0,1])
		mirror([i,0,0]) {

			translate([frameCY[3]-8,-80,-25])
				color(grey20)
				render()
				difference () {
					cube([5,105,80]);

					// belt
					translate([-1,42,20])
						cube([10,20,12]);

					// rail
					translate([-1,70,13])
						cube([10,22,22]);

					// laser
					translate([-1,20,50])
						roundedRectX([10,10,10],4);

				}

		}

	end("xAxis");
}


module  cableChainXBracket_stl() {
	tw = 4;
	dw = 3;
	w = 4 + 2*dw;
	wall = dw;
	h1 = 50;  // from x-axis centreline to top of bracket
	h2 = 50;  // from x-axis centreline to bottom of bracket

	offset = 21/2;

	d = offset + 4 + 2*dw;

	// local frame = laid on XY plane
	// x-axis centred on Y-axis, to right of X=0, extends in Z
	// "up" is y+

	difference() {
		union() {
			linear_extrude(w)
				difference() {
					union() {
						// tab for rail fixing
						translate([0,-10-dw,0])
							square([16, dw]);

						// vert support
						translate([0,-h2-10,0])
							square([dw, h2]);

						// tab for cable chain bracket
						translate([-d,-h2-10,0])
							square([d, dw]);
					}

					// x-axis
					translate([0, -20/2, 0])
						square([20,20]);
				}

			// stiffining triangle
			translate([-eta,-10,0])
				mirror([0,1,0])
				right_triangle(8, 12, dw, center=false);
		}

		// rail fixing
		translate([10,0,w/2])
			rotate([90,0,0])
			cylinder(r=4.3/2, h=100, center=true);

		// cable chain fixing
		translate([-offset-dw, -h2, w/2])
			rotate([90,0,0])
			cylinder(r=4.3/2, h=100, center=true);
	}


	// dummy x-axis
	*translate([10, 0, 0])
		aluProExtrusion(BR_20x20, l=100);

	*attach([[-offset-dw, -h2-10+dw, w/2],[0,-1,0],-90,0,0], [[cableChain_length - cableChain_height/2,0,0], [0,0,-1], 0,0,0])
		cableChainFrameFixingMale_stl();
}

module cableChainCarriageBracket_stl() {
	tw = 4;
	dw = 3;
	w = 4 + 2*dw;
	wall = dw;
	h1 = 50;  // from x-axis centreline to top of bracket
	h2 = 50;  // from x-axis centreline to bottom of bracket

	offset = 21/2;

	d = offset + 4 + 2*dw;

	// local frame = laid on XY plane
	// x-axis centred on Y-axis, to right of X=0, extends in Z
	// "up" is y+

	difference() {
		hull() {
			translate([0, 0,0])
				roundedRectY([36, dw, w], 3);

			translate([-d, 0, 20 - 4])
				roundedRectY([20, dw, w], 5);
		}

		// carriage bracket fixings
		translate([6,0,w/2])
			rotate([90,0,0])
			cylinder(r=4.3/2, h=100, center=true);

		translate([6 + 25,0,w/2])
			rotate([90,0,0])
			cylinder(r=4.3/2, h=100, center=true);


		// cable chain fixing
		translate([-offset-dw, 0, 20])
			rotate([90,0,0])
			cylinder(r=4.3/2, h=100, center=true);

		// cable tie points
		translate([10, 0, 14])
			rotate([90,0,0])
			cylinder(r=4.3/2, h=100, center=true);

		translate([0, 0, 18])
			rotate([90,0,0])
			cylinder(r=4.3/2, h=100, center=true);
	}


	// dummy x-axis
	*translate([10, -10, 0])
		aluProExtrusion(BR_20x20, l=100);

	*attach([[-offset-dw, -h2-10+dw, w/2],[0,-1,0],-90,0,0], [[cableChain_length - cableChain_height/2,0,0], [0,0,-1], 0,0,0])
		cableChainFrameFixingMale_stl();
}

module  cableChainXSupportBracket_stl() {
	tw = 4;
	dw = 3;
	w = 4 + 2*dw;
	wall = dw;
	h1 = 46;  // from x-axis centreline to top of bracket

	offset = 21/2;

	d = offset + 4 + 2*dw + 2;

	h2 = 23;

	// local frame = laid on XY plane
	// x-axis centred on Y-axis, to right of X=0, extends in Z
	// "up" is y+

	difference() {
		union() {
			translate([-dw, -10, 0])
				cube([dw, h1, w]);

			// lower curve
			translate([0,h1-15,w/2])
				rotate([0,-90,0])
				rotate([0,0,30])
				linear_extrude(d)
				donutSector2D(15,15-dw, 120, center=true);

			// lower joining piece
			hull () {
				translate([-dw, h1-30, 0])
					cube([dw, 10, w]);

				translate([0,h1-15,w/2])
					rotate([0,-90,0])
					rotate([0,0,30])
					linear_extrude(dw)
					donutSector2D(15,15-dw, 120, center=true);
			}

			// upper curve
			translate([0,h1+h2+15,w/2])
				mirror([0,1,0])
				rotate([0,-90,0])
				rotate([0,0,45])
				linear_extrude(d)
				donutSector2D(15,15-dw, 90, center=true);

			// curve joining piece
			hull () {
				translate([-d+1,h1-15,w/2])
					rotate([0,-90,0])
					rotate([0,0,30])
					linear_extrude(2)
					donutSector2D(15,15-dw, 120, center=true);

				translate([-d+1,h1+h2+15,w/2])
					mirror([0,1,0])
					rotate([0,-90,0])
					rotate([0,0,45])
					linear_extrude(2)
					donutSector2D(15,15-dw, 90, center=true);
			}

			// print support
			for (i=[-2:2])
				translate([-d, h1 + h2/2 + i*4.7, -25/2 + w/2])
				cube([d, 0.5, 25]);

		}

		// rail fixing
		translate([10,0,w/2])
			rotate([0,90,0])
			cylinder(r=4.3/2, h=100, center=true);

		// trim hulls
		translate([-dw-2,h1-15,w/2])
			rotate([0,-90,0])
			rotate([0,0,30])
			cylinder(r=15-dw, h=d+2);

		translate([-dw-2,h1+h2+15,w/2])
			rotate([0,-90,0])
			rotate([0,0,30])
			cylinder(r=15-dw, h=d+2);

		// weight loss
		translate([10,h1-12,w/2])
			scale([1,1.3,1])
			rotate([0,90,0])
			cylinder(r=6, h=100, center=true);

		// upper weight loss
		translate([10,h1+h2/2,w/2])
			scale([1,1.3,1])
			rotate([0,90,0])
			cylinder(r=8, h=100, center=true);
	}


	// dummy x-axis
	*translate([10, 0, 0])
		aluProExtrusion(BR_20x20, l=100);

	*attach([[-offset-dw, h1, w/2],[0,-1,0],-90,0,0], [[cableChain_length - cableChain_height/2,0,0], [0,0,-1], 0,0,0])
		cableChainFrameFixingMale_stl();
}
