
include <z-coupling.scad>;


module zRodAssembly() {
	
	rodLen = frameCZ[1] - frameCZ[0] - 30;
	
	assembly("zRod");
	
	// linear rod
	rod(Z_bar_dia, rodLen, false);
	
	// bottom clamp
	
	
	// top clamp
	
	
	end("zRod");
	
}


module zMotorAssembly() {
	h = NEMA_length(NEMA17);
	h1 = h + z_coupling_length()/2 + 5;
	
	Z_screw_length = frameCZ[1]-80;

	assembly("zMotor");

	// motor	
	translate([0,0,h]) NEMA(NEMA17);
	
	// threaded rod
	translate([0,0,h1]) 
		studding(d = Z_screw_dia, l = Z_screw_length, center=false);

	// coupling
	translate([0,0,h1]) 
		z_coupler_assembly();
	
	end("zMotor");
}


module zAxesAssembly() {

	assembly("zAxes");

	// motor assemblies
	for (x=[0,1], y=[-1,1]) 
		mirror([x,0,0])
		translate([(frameCY[3] + NEMA_width(NEMA17)/2 + 10), y*(bedDM/2-bedMotorYOffset),0]) 
		zMotorAssembly();
		
	
	// linear rod assemblies
	for (x=[0,1]) 
		mirror([x,0,0])
		translate([(frameCY[3]), -(bedDM/2 - bedBearingOffset),40]) 
			zRodAssembly();
			
	end("zAxes");
}