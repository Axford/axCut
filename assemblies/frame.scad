

module frameAssembly() {

	assembly("frame");

	// base
	// front/back
	for (i=[0,3]) {
		aluProExtrusionBetweenPoints([frameCY[0]-10,frameCX[i],frameCZ[0]],
		                             [frameCY[5]+10,frameCX[i],frameCZ[0]],
		                             BR_20x40,
		                             90);
	}

	// ribs
	for (i=[0,2,3,5]) {
		BR20x40WGBP([frameCY[i],frameCX[0]+10,frameCZ[0]],
		            [frameCY[i],frameCX[3]-10,frameCZ[0]],
		            roll=0);

		for (j=[0,1])
			translate([frameCY[i] + (i<3?10:-10),frameCX[0+j*3] + (j==0?10:-10),frameCZ[0]])
			mirror([i>2?1:0,j,0])
			rotate([0,90,0])
			20x40HeavyGusset_stl(screws=true);
	}

	// infill ribs
	ix = frameCY[3] *1/3;
	for (i=[0,1]) mirror([i,0,0])
	BR20x40WGBP([ix,frameCX[0]+10,frameCZ[0]],
		            [ix,frameCX[3]-10,frameCZ[0]],
		            roll=0,
		            startGussets=[0,1,1,0,0,0],
		            endGussets=[0,1,1,0,0,0,0]);

	// corner posts
	for (x=[0,5],y=[0,3])
		BR20x20WGBP([frameCY[x],frameCX[y],frameCZ[0]+20],
		            [frameCY[x],frameCX[y],frameCZ[3]+10],
		            roll=0,
		            startGussets=[y==0?1:0,0,y==0?0:1,0],
		            endGussets=[0,0,0,0]);

	// inner posts
	for (x=[2,3],y=[0,3])
		BR20x20WGBP([frameCY[x],frameCX[y],frameCZ[0]+20],
		            [frameCY[x],frameCX[y],frameCZ[4]+10],
		            roll=90,
		            startGussets=[0,
		            			  y==3?1:0,
		            			  0,
		            			  y==0?1:0],
		            endGussets=[0,0,0,0]);


	// left/right top ribs
	for (i=[0,5]) {
		BR20x20WGBP([frameCY[i],frameCX[0]+10,frameCZ[3]],
		            [frameCY[i],frameCX[3]-10,frameCZ[3]],
		            roll=0,
		            startGussets=[1,0,0,0],
		            endGussets=[1,0,0,0]);
	}

	// inner top ribs
	for (i=[2,3]) {
		BR20x20WGBP([frameCY[i],frameCX[0]+10,frameCZ[4]],
		            [frameCY[i],frameCX[3]-10,frameCZ[4]],
		            roll=0,
		            startGussets=[1,0,0,0],
		            endGussets=[1,0,0,0]);
	}

	// top back
	BR20x40WGBP([frameCY[2]+10,frameCX[3],frameCZ[4]-10],
		            [frameCY[3]-10,frameCX[3],frameCZ[4]-10],
		            roll=90,
		            startGussets=[0,1,0,1,0,0],
		            endGussets=[0,1,0,1,0,0]);

	// mid back
	BR20x20WGBP([frameCY[2]+10,frameCX[3],frameCZ[1]],
		            [frameCY[3]-10,frameCX[3],frameCZ[1]],
		            roll=90,
		            startGussets=[1,0,0,0],
		            endGussets=[1,0,0,0]);

	BR20x20WGBP([frameCY[2]+10,frameCX[2],frameCZ[1]],
		            [frameCY[3]-10,frameCX[2],frameCZ[1]],
		            roll=90,
		            startGussets=[0,0,0,1],
		            endGussets=[0,0,0,1]);


	// top front/back of sides
	for (x=[0,3],y=[0,3]) {
		translate([(frameCY[x] + frameCY[x+2])/2,frameCX[y],frameCZ[3]])
			rotate([180,0,0])
			20x20TGusset_stl(width=(frameCY[x+2]-frameCY[x]-20), screws=true, coreScrew=false);
	}

	// bottom front/back sides
	for (x=[0,3],y=[0,3])
		translate([(frameCY[x] + frameCY[x+2])/2,frameCX[y],frameCZ[0]+30]) {
			20x20TGusset_stl(width=(frameCY[x+2]-frameCY[x]-20), screws=true, coreScrew=false);

			// additional t-slot fixings into base
			translate([0,0,default_wall - 10]) screw_and_washer(M4_cap_screw,8);
			translate([0,0,-10]) rotate([0,0,90]) aluProTwistLockNut(BR_20x20_TwistLockNut);
	}

	// top laser casing beam
	BR20x20WGBP([frameCY[2]+10,frameCX[2],frameCZ[4]],
		            [frameCY[3]-10,frameCX[2],frameCZ[4]],
		            roll=0,
		            startGussets=[1,0,0,0],
		            endGussets=[1,0,0,0]);



	// top of z ribs
	for (i=[2,3]) {
		BR20x20WGBP([frameCY[i],frameCX[0]+10,frameCZ[1]],
		            [frameCY[i],frameCX[3]-10,frameCZ[1]],
		            roll=0,
		            startGussets=[1,0,0,0],
		            endGussets=[1,0,1,0]);
	}

	// z rib posts
	*for (x=[2,3])
		BR20x20WGBP([frameCY[x],frameCX[2],frameCZ[0]+20],
		            [frameCY[x],frameCX[2],frameCZ[1]-10],
		            roll=0,
		            startGussets=[1,0,0,0],
		            endGussets=[1,0,0,0]);


	end("frame");

}


module upperFrameBracket_stl(sideFixing=false) {
	h = 30;
	w = 65 + 40;
	dw = 2.5;
	tw = 5;
	d = tw;

	difference() {
		union() {
			// basic shape
			roundedRect([w, d, h], d/2);

			// rail fixings
			for (i=[0,1])
				translate([ i*(w-20), 0, 0])
				roundedRect([20, 17, dw], 5);

			// fillet
			translate([dw, tw-eta, dw-eta])
				rotate([0,-90,0])
				right_triangle(20, 10, dw, center = true);

			// plate fixing
			translate([w-32, 0, 0])
				roundedRect([13, 17, h], 5);

			if (sideFixing) {
				translate([0, -5, 0])
					roundedRect([6, 10, h], 3);
			}
		}

		// rail fixing holes
		for (i=[0,1])
			translate([10 +  i*(w-20), 11, 0])
			cylinder(r=4.3/2, h=100, center=true);

		// plate fixing hole
		translate([w-25, 11, 8])
			rotate([0,13,0])
			cylinder(r=4.3/2, h=100, center=true);


		// acrylic plate
		translate([21,-10,h-5])
			rotate([0,13,0])
			cube([90, 100, 50]);
		translate([21,-10,h-5])
			cube([90, 100, 5]);

		// slope the inside edge
		if (!sideFixing)
			rotate([0,5,0])
			translate([-100,-50,dw])
			cube([100,100,100]);

		// weight loss
		translate([h/2, 0, h/2-2])
			rotate([90,0,0])
			cylinder(r=h/4, h=100, center=true);

		translate([35, 0, 10])
			rotate([90,0,0])
			cylinder(r=6, h=100, center=true);

		translate([52, 0, 8])
			rotate([90,0,0])
			cylinder(r=5, h=100, center=true);

		//
		if (sideFixing)
			translate([0, 0, h/2])
			rotate([0,90,0])
			cylinder(r=4/2, h=40, center=true);

	}



	// fixings to rail
	*translate([w-10,11,dw]) screw_and_washer(M4_pan_screw,8);

	// dummy acrylic plate
	*color([0,0,0,0.2])
	translate([21,-10,h-5])
		rotate([0,13,0])
		cube([90, 100, 5]);
}

module upperFrameBracketForPiston_stl() {
	h = 30;
	w = 65 + 40;
	dw = 2.5;
	tw = 5;
	d = tw;

	r = 29/2;


	difference() {
		union() {
			upperFrameBracket_stl();

			// mounting block
			translate([21,-h,0])
				roundedRect([tw, h+tw, h], dw);

			// extra rail fixing
			translate([ 0, -h-11, 0])
				roundedRect([21 + tw, h+11+tw, dw], 5);
		}

		// acrylic plate
		translate([21,-50,h-5])
			rotate([0,13,0])
			cube([90, 100, 50]);
		translate([21-eta,-50,h-5])
			cube([90, 100, 50]);

		// piston plate
		translate([21,-h/2,h/2])
			rotate([0,-90,0]) {
				cylinder(r=r, h=2);

				// piston fixings
				for (i=[0:2])
					rotate([0,0, i * 360/3 + 180])
					translate([9.5,0,0])
					cylinder(r=4.3/2, h=100, center=true);
			}

		// extra rail fixing hole
		translate([10,-h-5,dw])
			cylinder(r=4.3/2, h=100, center=true);
	}

	*translate([10,-h-5,dw])
		screw_and_washer(M4_pan_screw,8);
}

module upperFrameBracketForHinge_stl() {
	h = 30;
	w = 65 + 40;
	dw = 2.5;
	tw = 5;
	d = tw;

	h1 = h-10;
	y1 = 15;

	difference() {
		union() {
			upperFrameBracket_stl();

			// blocks
			translate([0,0,0])
				roundedRect([tw, 25, h1], dw);
			translate([0,0,0])
				roundedRect([tw, y1, h], dw);
			translate([0,y1,h1])
				rotate([0,90,0])
				cylinder(r=10, h=tw);

			// rounded top

			// extra rail fixing
			translate([ 0, -12, 0])
				roundedRect([20, 48, dw], 5);

			// fillets
			translate([dw, eta, dw-eta])
				rotate([0,-90,180])
				right_triangle(20, 9, dw, center = true);

			translate([dw, 25-eta, dw-eta])
				rotate([0,-90,0])
				right_triangle(20, 9, dw, center = true);
		}

		// hinge
		translate([0,y1, h1])
			rotate([0,-90,0])
			cylinder(r=4.3/2, h=100, center=true);

		// rail fixing holes
		translate([10,29,dw])
			cylinder(r=4.3/2, h=100, center=true);

		translate([10,-6,dw])
			cylinder(r=4.3/2, h=100, center=true);

	}

	*translate([10,29,dw])
		screw_and_washer(M4_pan_screw,8);
}


module lidCornerBracket_stl() {
	DefConDown = [[0,0,0],[0,0,-1]];
	DefConUp = [[0,0,0],[0,0,1]];

	w = 36;
	d = 28;
	d1 = 23;
	h = 18;
	wall = 4;

	f1 = [[15,   -1.5, h/2],[0,1,0],0];
	f2 = [[w-6, -1.5, h/2],[0,1,0],0];

	f3 = [[-1.5, 9,   h/2],[1,0,0],0];
	f4 = [[-1.5, d-6, h/2],[1,0,0],0];

	f5 = [[15,   d1/2, 0],[0,0,1],0];
	f6 = [[w-6, d1/2, 0],[0,0,1],0];


	difference() {
		union() {
			hull() {
				roundedRect([w, wall, wall], wall/2);
				roundedRect([wall, d, wall], wall/2);

				attach(f6, DefConUp) cylinder(r=4.3/2 + 3, h=wall);
			}

			roundedRect([w, wall, h], wall/2);

			roundedRect([wall, d, h], wall/2);
		}

		// fixings
		attach(f1, DefConDown) cylinder(r=4.3/2, h=100, center=true);
		attach(f2, DefConDown) cylinder(r=4.3/2, h=100, center=true);
		attach(f3, DefConDown) cylinder(r=4.3/2, h=100, center=true);
		attach(f4, DefConDown) cylinder(r=4.3/2, h=100, center=true);
		attach(f5, DefConDown) cylinder(r=4.3/2, h=100, center=true);
		attach(f6, DefConDown) cylinder(r=4.3/2, h=100, center=true);
	}

	// fixings
	if (false) {
		attach(f1, DefConDown) screw_washer_and_nut(M4_pan_screw, M4_nut,12, 5.5);
		attach(f2, DefConDown) screw_washer_and_nut(M4_pan_screw, M4_nut,12, 5.5);
		attach(f3, DefConDown) screw_washer_and_nut(M4_pan_screw, M4_nut,12, 5.5);
		attach(f4, DefConDown) screw_washer_and_nut(M4_pan_screw, M4_nut,12, 5.5);
		attach(f5, DefConDown) screw_washer_and_nut(M4_pan_screw, M4_nut,12, 5.5);
		attach(f6, DefConDown) screw_washer_and_nut(M4_pan_screw, M4_nut,12, 5.5);
	}

/*
	// alu angle
	attach([[0,0,0],[0,-1,0],0,0,0], DefConDown)
		StockMetal(StockMetal_Angle_30x20x1p5, 100);

	attach([[0,0,0],[1,0,0],-90,0,0], DefConDown)
		StockMetal(StockMetal_Angle_30x20x1p5, 100);


	//StockMetal(StockMetal_Angle_25x10x1p5, 50);
*/
}
