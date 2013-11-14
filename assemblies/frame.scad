

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
		            roll=0,
		            startGussets=[0,i%2,i%2,0,(i+1)%2,(i+1)%2], 
		            endGussets=[0,i%2,i%2,0,(i+1)%2,(i+1)%2]);
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
		            startGussets=[y==0?1:0,x==5?1:0,y==0?0:1,x==0?1:0], 
		            endGussets=[0,0,0,0]);
		            
	// inner posts
	for (x=[2,3],y=[0,3])
		BR20x20WGBP([frameCY[x],frameCX[y],frameCZ[0]+20], 
		            [frameCY[x],frameCX[y],frameCZ[4]+10],
		            roll=90,
		            startGussets=[x==2?1:0,
		            			  y==3?1:0,
		            			  x==3?1:0,
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
		            startGussets=[1,0,1,0], 
		            endGussets=[1,0,1,0]);
		            
	BR20x20WGBP([frameCY[2]+10,frameCX[1],frameCZ[1]], 
		            [frameCY[3]-10,frameCX[1],frameCZ[1]],
		            roll=90,
		            startGussets=[0,0,1,1], 
		            endGussets=[0,0,1,1]);
	
	
	// top beams
	for (x=[0,3],y=[0,3]) {
		BR20x20WGBP([frameCY[x]+10,frameCX[y],frameCZ[3]], 
		            [frameCY[x+2]-10,frameCX[y],frameCZ[3]],
		            roll=0,
		            startGussets=[(x==0&&y==0?1:0),0,(x==0&&y==3?1:0),1], 
		            endGussets=[(x==3&&y==0?1:0),0,(x==3&&y==3?1:0),1]);
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
	for (x=[2,3])
		BR20x20WGBP([frameCY[x],frameCX[1],frameCZ[0]+20], 
		            [frameCY[x],frameCX[1],frameCZ[1]-10],
		            roll=0,
		            startGussets=[1,0,0,0], 
		            endGussets=[1,0,0,0]);
	
	
	end("frame");
	
}