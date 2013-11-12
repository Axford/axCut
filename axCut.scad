include <config/config.scad>





module cuttingBed() {
	// centred on origin

	// dummy surface
	color([1,1,1,0.5]) cube([bedW,bedD,1],center=true);
}

module cuttingBedFrame() {

	bFW = bedW + 2*bedM + 2*bedO;

	ribSpacing = (bedWM - 20) / (bedRibs - 1);
	ribL = bedDM - 80;

	translate([-bFW/2,bedDM/2-20,-10]) rotate([0,90,0]) aluProExtrusion(BR_20x40, l=bFW);
	translate([-bFW/2,-bedDM/2+20,-10]) rotate([0,90,0]) aluProExtrusion(BR_20x40, l=bFW);
	
	for (j=[0,1]) 
		mirror([j,0,0])
		for (i=[0:bedRibs/2-1]) {
		BR20x20WGBP([-bedWM/2+10 + i*ribSpacing, -ribL/2, -10], 
		            [-bedWM/2+10 + i*ribSpacing, ribL/2, -10],
		            roll=0,
		            startGussets=[0,0,0,1], 
		            endGussets=[0,0,0,1]);
	}
	
	// keeps bed centred at origin
	cuttingBed();
	// with cutting margins
	color([1,0,0,0.5]) cube([bedWM,bedDM,0.5],center=true);
}



module xCarriage() {
	// plate
	translate([0,0,0]) rotate([90,0,0]) openrail_plate20(wheels=true);

	// laser optics
	translate([0,-25,-50]) cylinder(r=25/2,h=100);
}

module xAxis() {

	t  =ORPlateThickness(ORPLATE20);
	l = frameCY[2] - frameCY[1] + 2*(openrail_plate_offset2 + 10 - t);

	translate([-l/2,0,openrail_outercentres+10]) rotate([0,90,0]) aluProExtrusion(BR_20x20, l=l);

	translate([-bedWM/2,-10,openrail_outercentres + 20]) { 
		rotate([0,90,0]) rotate([0,0,90]) openrail_doubled(bedWM,true,true);
	}

	translate([l/2 + t + NEMA_width(NEMA17)/2,0,ORPlateWidth(ORPLATE40)/2-5]) rotate([0,0,0]) NEMA(NEMA17);
	
	translate([0,-openrail_plate_offset-10,openrail_outercentres+10]) xCarriage();
	
	// y carriages
	for (i=[0,1])
		mirror([i,0,0])
		translate([frameCY[2] + 10 + openrail_plate_offset2,0,0]) 
		rotate([0,90,0]) 
		openrail_plate40(wheels=true);
}



module frame() {
	
	assembly("frame");
	
	// base
	// front/back
	for (i=[0,2]) {
		aluProExtrusionBetweenPoints([frameCY[0]-10,frameCX[i],frameCZ[0]], 
		                             [frameCY[3]+10,frameCX[i],frameCZ[0]],
		                             BR_20x40,
		                             90);
	}
	
	// ribs
	for (i=[0:3]) {
		BR20x40WGBP([frameCY[i],frameCX[0]+10,frameCZ[0]], 
		            [frameCY[i],frameCX[2]-10,frameCZ[0]],
		            roll=0,
		            startGussets=[0,i%2,i%2,0,(i+1)%2,(i+1)%2], 
		            endGussets=[0,i%2,i%2,0,(i+1)%2,(i+1)%2]);
	}
	
	// infill ribs
	ix = frameCY[2] *1/3;
	for (i=[0,1]) mirror([i,0,0])
	BR20x40WGBP([ix,frameCX[0]+10,frameCZ[0]], 
		            [ix,frameCX[2]-10,frameCZ[0]],
		            roll=0,
		            startGussets=[0,1,1,0,0,0], 
		            endGussets=[0,1,1,0,0,0,0]);
	
	// corner posts
	for (x=[0,3],y=[0,2])
		BR20x20WGBP([frameCY[x],frameCX[y],frameCZ[0]+20], 
		            [frameCY[x],frameCX[y],frameCZ[2]+10],
		            roll=0,
		            startGussets=[y==0?1:0,x==3?1:0,y==0?0:1,x==0?1:0], 
		            endGussets=[0,0,0,0]);
		            
	// inner posts
	for (x=[1,2],y=[0,2])
		BR20x40WGBP([frameCY[x] + (x==1?-10:+10),frameCX[y],frameCZ[0]+20], 
		            [frameCY[x] + (x==1?-10:+10),frameCX[y],frameCZ[3]+10],
		            roll=90,
		            startGussets=[x==1?1:0,
		            			  x==2&&y==2?1:0,
		            			  x==1&&y==2?1:0,
		            			  x==2?1:0,
		            			  x==1&&y==0?1:0,
		            			  x==2&&y==0?1:0], 
		            endGussets=[0,0,0,0,0,0]);
	
	
	// left/right top ribs
	for (i=[0,3]) {
		BR20x20WGBP([frameCY[i],frameCX[0]+10,frameCZ[2]], 
		            [frameCY[i],frameCX[2]-10,frameCZ[2]],
		            roll=0,
		            startGussets=[1,0,0,0], 
		            endGussets=[1,0,0,0]);
	}
	
	// inner top ribs
	for (i=[1,2]) {
		BR20x40WGBP([frameCY[i] + (i==1?-10:10),frameCX[0]+10,frameCZ[3]], 
		            [frameCY[i] + (i==1?-10:10),frameCX[2]-10,frameCZ[3]],
		            roll=90,
		            startGussets=[0,0,0,0,1,1], 
		            endGussets=[0,0,0,0,1,1]);
	}
	
	// y rails
	for (i=[1,2]) {
		BR20x40WGBP([frameCY[i],frameCX[0]+10,frameCZ[1]], 
		            [frameCY[i],frameCX[2]-10,frameCZ[1]],
		            roll=0,
		            startGussets=[1,0,0,1,0,0], 
		            endGussets=[1,0,0,1,0,0]);
	}
	
	// top back
	BR20x40WGBP([frameCY[1]+10,frameCX[2],frameCZ[3]-10], 
		            [frameCY[2]-10,frameCX[2],frameCZ[3]-10],
		            roll=90,
		            startGussets=[0,1,0,1,0,0], 
		            endGussets=[0,1,0,1,0,0]);
		            
	// mid back
	BR20x40WGBP([frameCY[1]+10,frameCX[2],frameCZ[1]], 
		            [frameCY[2]-10,frameCX[2],frameCZ[1]],
		            roll=90,
		            startGussets=[1,1,0,1,0,0], 
		            endGussets=[1,1,0,1,0,0]);
	
	// top beams
	for (x=[0,2],y=[0,2]) {
		BR20x20WGBP([frameCY[x]+(x==0?10:30),frameCX[y],frameCZ[2]], 
		            [frameCY[x+1]-(x==0?30:10),frameCX[y],frameCZ[2]],
		            roll=0,
		            startGussets=[(x==0&&y==0?1:0),0,(x==0&&y==2?1:0),1], 
		            endGussets=[(x==2&&y==0?1:0),0,(x==2&&y==2?1:0),1]);
	}
	
	// top hinge beam
	BR20x40WGBP([frameCY[1]+10,frameCX[1]+10,frameCZ[3]], 
		            [frameCY[2]-10,frameCX[1]+10,frameCZ[3]],
		            roll=0,
		            startGussets=[1,0,0,0,0,0], 
		            endGussets=[1,0,0,0,0,0]);
	
	end("frame");
	
}

module zAssembly() {
	h = NEMA_length(NEMA17);

	for (x=[0,1], y=[-1,1]) 
		mirror([x,0,0])
		translate([(bedWM/2  + claddingC + NEMA_width(NEMA17)/2 + 20), y*(bedDM/2-40-NEMA_width(NEMA17)/2),0]) {
	
		// motor	
		translate([0,0,h]) NEMA(NEMA17);
	
		// threaded rod
		translate([0,0,h+20]) cylinder(h=yVPos-90, r= 5/2);

		// coupling
		translate([0,0,h+4]) cylinder(h=25, r= 15/2);

		// linear rod
		translate([-NEMA_width(NEMA17)/2-10,0,40]) cylinder(h=yVPos-60, r= 10/2);
	
		// bearing

		
	}
	
}

module laserTube() {
	color([1,1,1,0.4]) cylinder(r=60/2, h=700);
}

module laserTubeAssembly() {

	translate([-350, frameCX[2]-50,frameCZ[1]+50]) rotate([0,90,0]) laserTube();

}

module yAssembly() {

	railLen = bedD + ORPlateDepth(ORPLATE40);

	translate([0,0,frameCZ[1]]) xAxis();
	
	// rails
	for (i=[0,1])
		mirror([i,0,0])
		translate([-frameCY[2]-10,-bedDM/2 + 15,frameCZ[1]]) 
		rotate([-90,0,0])
	 {
			translate([0,20,0]) openrail(railLen,true,true);
			translate([0,-20,0,]) mirror([0,1,0]) openrail(railLen,true,true);
		}
}

laserTubeAssembly();

frame();

zAssembly();

translate([0,0,bedVPos]) cuttingBedFrame();

yAssembly();

