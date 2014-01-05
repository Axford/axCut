include <config/config.scad>

// animation
xCarriagePos = -bedW/2 + (0.5+cos($t*360)/2) * bedW;
yCarriagePos = -bedD/2 + (0.5+cos($t*360)/2) * bedD;

debugConnectors=false;

if (false) { 

	*laserAssembly();
	
	*frameAssembly();

	*yAxesAssembly();

	zAxesAssembly();

	translate([0,0,bedVPos]) bedAssembly();

}


//laserDiodeTube();

//laserDiodeTubeHolder_stl();

//laserDiodeTubeTarget_stl();

//laserDiodeHolder_stl();

//laserDiodeAdjuster_stl();

//laserDiode();


//PowerSocketMount_stl();

//PSUBracket_stl();


//fan(fan120x25);

//BlackIceSR1360();

//radBracket_stl();

//coolingTubeGrommet_stl();

//coolingTubeReturnElbow_stl();

xLimitSwitchBracket_stl();