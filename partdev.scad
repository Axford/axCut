include <config/config.scad>

// animation
xCarriagePos = -bedW/2 + (0.5+cos($t*360)/2) * bedW;
yCarriagePos = -bedD/2 + (0.5+cos($t*360)/2) * bedD;

debugConnectors=false;

*rotate([0,90,0]) 
	yCarriageBracketLeft_stl();
//yCarriageAssemblyLeft();	
*yAxesAssembly();

fixedMirrorHolder_stl();
*fixedMirrorHolderAssembly();
*BR20x20WGBP([0,0,0],[0,100,0], startGussets=[0,0,0,0]);

*rotate([180,0,0]) 
	xAxisMotorPlate_stl(showMotor=false,singleFlange=true);


//yCarriageBracket_stl();

*BR20x20WGBP([-50,0,0],[-50,0,100]);
		   
*translate([0,0,0]) 20x20TGusset(width=100-20, screws=true, coreScrew=true);        
		            
*BR20x20WGBP([0,10,0],[0,100,0], startGussets=[0,1,0,1]);

*rotate([-135,0,0]) 20x40HeavyGusset_stl();


*BR20x40WGBP([0,0,-10],[0,100,-10],90);


*20x20TGusset_stl(width=(frameCY[2]-frameCY[0]-20), screws=false, coreScrew=false);


*for (x=[0:3],y=[0:3])
	translate([x*15,y*13,0])
	aluProTNut_stl(BR_20x20, $fn=8);
	
*for (x=[0:3],y=[0:3])
	translate([x*21,y*28,15])
	rotate([-135,0,0])
	aluProGusset(BR_20x20_Gusset);

*rotate([0,180,0]) import("stl/M4_T-slot_vise.stl");


*translate([-350,0,-100]) xAxisAssembly();

*rotate([0,90,0])
	xCarriageBracket_stl();		            


*claddingSheets();
		            
*laserHead();

*laserMirror();

*xAxisAssembly();

*yAxesAssembly();

*laserAssembly();

*laserPowerSupply();
