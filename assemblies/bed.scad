module bed() {
	// centred on origin

	// dummy surface
	color([1,1,1,0.5]) cube([bedW,bedD,1],center=true);
}



module bedBearingClamp(incBearing=true) {

	x1 = NEMA_width(NEMA17)/2 + 10;
	x2 = NEMA_width(NEMA17)/2 - 4;

	y1 = bedMotorYOffset - 20;
	y2 = bedBearingOffset - 20;

	bh = bearing_height(Z_bearings);
	br = bearing_radius(Z_bearings);
	bo = br * 2/7;

	or = br + default_wall;

	z1 = -bh - default_wall + 20;

	color(plastic_part_color("lime"))
		//render()
		union() {
			if (incBearing) {

				// cap
				translate([-or,0,z1 + bh])
					cube([or*2,y2 - br + default_wall, default_wall]);

				// bearing clamp
				translate([0,0,z1])
					linear_extrude(bh + default_wall)
					difference() {
						union() {
							translate([-or,0]) square([or*2,y2]);

							translate([0,y2]) circle(or);
						}

						// hollow
						translate([0,y2]) circle(br);

						// opening
						translate([0,y2])
							rotate([0,0,45])
							square([br*2, br*2]);
					}

			}

			// mount plate
			difference() {
				hull() {
					translate([br,0,-5])
						cube([x1+0.5, thick_wall, 25]);

					translate([x2,0 ,10 - 20])
						rotate([-90,0,0])
						cylinder(r=screw_clearance_radius(M5_cap_screw)+thick_wall,h=thick_wall);

				}

				// screw holes
				for (i=[0,1])
					translate([x2,-1 ,10 - i*20])
					rotate([-90,0,0])
					cylinder(r=screw_clearance_radius(M5_cap_screw),h=10);

			}

			// fillets
			translate([x1-10 + thick_wall/2,thick_wall,10])
				rotate([0,90,0])
				right_triangle(15,15,h=thick_wall);

			translate([x1+10 - thick_wall/2,thick_wall,10])
				rotate([0,90,0])
				right_triangle(15,15,h=thick_wall);

			// nut plate
			difference() {
				translate([x1 - 10,0, 10])
					cube([20, y1 + 10, 10]);

				// for nut
				translate([x1,y1, 9])
					rotate([0,0,0])
					cylinder(r=nut_radius(M6_nut), h=nut_thickness(M6_nut)+2, $fn=6);

				// for threaded rod
				translate([x1,y1, 0])
					cylinder(r=screw_clearance_radius(M6_cap_screw), h=100);
			}
		}

	// t-nuts and screws
	*for (i=[0,1]) {
		translate([x2,thick_wall ,10 - i*20])
			rotate([-90,0,0])
			screw(M4_cap_screw, 8);

		translate([x2,0 ,10 - i*20])
			rotate([-90,90,0])
			aluProTwistLockNut(BR_20x20_TwistLockNut);
	}

	// bearing
	*if (incBearing)
		translate([0,y2,-bh/2+20-4perim])
		rotate([0,90,0])
		linear_bearing(Z_bearings);

	// nut
	*translate([x1,y1,10-1])
		nut(M6_nut);
}

module bedAssembly() {

	bFW = bedW + 2*bedM + 2*bedO;

	ribSpacing = (bedWM - 20) / (bedRibs - 1);
	ribL = bedDM - 40;

	echo("ribSpacing: ",ribSpacing);
	echo("firstRibOffset: ",(bFW - bedWM + 20)/2);

	assembly("bed");

	//back rail
	translate([-bFW/2,bedDM/2-10,0])
		rotate([0,90,0])
		rotate([0,0,90])
		aluProExtrusion(BR_20x40, l=bFW);

	//front rail
	translate([-bFW/2,-bedDM/2+10,0])
		rotate([0,90,0])
		rotate([0,0,90])
		aluProExtrusion(BR_20x40, l=bFW);

	// ribs
	for (j=[0,1])
		mirror([j,0,0])
		for (i=[0:bedRibs/2-1]) {
		BR20x20WGBP([-bedWM/2+10 + i*ribSpacing, -ribL/2, -10],
		            [-bedWM/2+10 + i*ribSpacing, ribL/2, -10],
		            roll=0,
		            startGussets=[0,0,0,1],
		            endGussets=[0,0,0,1]);
	}

	// zBearings
	//bedBearingOffset
	for (i=[0,1])
	for (j=[0,1])
		mirror([i,0,0])
		mirror([0,j,0])
		translate([frameCY[3],-bedDM/2+20,0])
			bedBearingClamp(j==0);


	*translate([0,0,20]) {
		// keeps bed centred at origin
		bed();

		// with cutting margins
		color([1,0,0,0.5]) cube([bedWM,bedDM,0.5],center=true);
	}

	end("bed");
}


// for clamping 3-5mm material onto the bed, e.g. foam core - to stop warping durin cutting!
module bedMaterialClamp_stl() {
	// clamping arm points along y+

	w = 10;
	d = 20;
	t = 4;
	offset = 23;  // between face of rail and face of material (assumes 3mm material)
	l = 55;  //  dist from fixing centre to tip of clamp arm

	difference() {
		union() {
			// rail fixing
			translate([-w/2, -d/2, 0])
				roundedRectX([w,d,t], 2);

			// clamping tab
			translate([-w/2, l-w, offset])
			roundedRectX([w,w,t], 2);

			// arm
			hull() {
				translate([-w/2, d/2-2, 0])
				roundedRectX([w,2,t], 2);

				// clamping tab
				translate([-w/2, l-w, offset])
				roundedRectX([w,2,t], 2);
			}

		}

		// rail fixing
		cylinder(r=4.3/2, h=100, center=true);
	}
}


module bedFrontEdgeClamp_stl() {
	t=3;

	difference() {
		union() {
			hull() {
				cylinder(r=12/2, h=t);

				translate([0,12,0])
					cylinder(r=8/2, h=t);
			}
		}

		//frame fixing
		cylinder(r=4.3/2, h=100, center=true);
	}

}
