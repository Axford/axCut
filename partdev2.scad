include <config/config.scad>

// animation
xCarriagePos = -bedW/2 + (0.5+cos($t*360)/2) * bedW;
yCarriagePos = -bedD/2 + (0.5+cos($t*360)/2) * bedD;

debugConnectors=false;


//xLimitSwitchAssembly();


*rotate([0,90,0])
	xLimitSwitchBracket_stl();

*rotate([-135,0,0]) 20x20PrintedGusset_stl();


*translate([2*(30-12),0,0]) cableChainLink_stl();
*translate([30 - 12,0,0]) cableChainLink_stl();

*cableChainFrameFixingFemale_stl();

//translate([0,-20,0])
//cableChainFrameFixingMale_stl();

*rotate([180,0,0]) zMotorBracket_stl();

//mirror([1,0,0]) bedBearingClamp();

//rearCableManagementBracket_stl();

//20x20SnapFitting_stl(true);

exhaustCoupling_stl();
