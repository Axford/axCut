module laserTube() {
	color([1,1,1,0.4]) 
		cylinder(r=60/2, h=700);
}

module laserAssembly() {

	translate([-350, frameCX[3]-50,frameCZ[1]+90]) 
		rotate([0,90,0]) 
		laserTube();

}