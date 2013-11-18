

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