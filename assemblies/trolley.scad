

module trolleyAssembly() {
	
	assembly("trolley");
	
	/*
	
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
	
	
	
	// corner posts
	for (x=[0,5],y=[0,3])
		BR20x20WGBP([frameCY[x],frameCX[y],frameCZ[0]+20], 
		            [frameCY[x],frameCX[y],frameCZ[3]+10],
		            roll=0,
		            startGussets=[y==0?1:0,0,y==0?0:1,0], 
		            endGussets=[0,0,0,0]);
		            
	*/
	

	
	for (x=[0,5]) {
		// front corner posts
		BR20x40WGBP([frameCY[x],frameCX[0]+10,trolleyFloorClearance], 
		            [frameCY[x],frameCX[0]+10, trolleyHeight],
		            roll=0);
	
		// back corner posts
		BR20x40WGBP([frameCY[x], frameCX[0] + trolleyDepth - 40,trolleyFloorClearance], 
		            [frameCY[x], frameCX[0] + trolleyDepth - 40, trolleyHeight],
		            roll=0);
		            
		// front feet
		translate([frameCY[x], frameCX[0], 0])
			aluProHingedFoot();
		
		// back feet
		translate([frameCY[x], frameCX[0] + trolleyDepth - 30, 0])
			aluProHingedFoot(); 
	}
	
	// top front
	BR20x40WGBP([frameCY[0]+10,frameCX[0],trolleyHeight-20], 
		        [frameCY[5]-10,frameCX[0], trolleyHeight-20],
		            roll=90);
	
	// top back
	BR20x40WGBP([frameCY[0]+10,frameCX[0] + trolleyDepth - 30,trolleyHeight-20], 
		        [frameCY[5]-10,frameCX[0] + trolleyDepth - 30, trolleyHeight-20],
		            roll=90);
		     
	// top ribs
			for (i=[1,3]) {
				BR20x20WGBP([frameCY[i],frameCX[0]+10, trolleyHeight-10], 
							[frameCY[i],frameCX[0] + trolleyDepth - 40, trolleyHeight-10],
							roll=0);
			}	
	
	// top sides
	for (i=[0,5]) {
		BR20x40WGBP([frameCY[i],frameCX[0]+30, trolleyHeight-20], 
		            [frameCY[i],frameCX[0] + trolleyDepth - 60, trolleyHeight-20],
		            roll=0);
		            
		*for (j=[0,1])
			translate([frameCY[i] + (i<3?10:-10),frameCX[0+j*3] + (j==0?10:-10),frameCZ[0]])
			mirror([i>2?1:0,j,0])
			rotate([0,90,0])
			20x40HeavyGusset_stl(screws=true);
	}
	
	// lower sides
	for (i=[0,5]) {
		BR20x40WGBP([frameCY[i],frameCX[0]+30, 100], 
		            [frameCY[i],frameCX[0] + trolleyDepth - 60, 100],
		            roll=0);
		            
		*for (j=[0,1])
			translate([frameCY[i] + (i<3?10:-10),frameCX[0+j*3] + (j==0?10:-10),frameCZ[0]])
			mirror([i>2?1:0,j,0])
			rotate([0,90,0])
			20x40HeavyGusset_stl(screws=true);
	}
	
		    
	// shelves
	for (i=[0,1]) 
		translate([0,0,100 + i*200]) {
	
			// front
			BR20x40WGBP([frameCY[0]+10, frameCX[0], 0], 
						[frameCY[5]-10, frameCX[0], 0],
							roll=90);
	
			// back
			BR20x40WGBP([frameCY[0]+10, frameCX[0] + trolleyDepth - 30,0], 
						[frameCY[5]-10, frameCX[0] + trolleyDepth - 30, 0],
							roll=90);
			 
	
			// ribs
			for (i=[-2,-1,1,2]) {
				BR20x20WGBP([i*200, frameCX[0]+10, 10], 
							[i*200, frameCX[0] + trolleyDepth - 40, 10],
							roll=0);
			}	
		
		}
	
	
	end("trolley");
	
}