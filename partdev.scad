include <config/config.scad>

// animation
xCarriagePos = -bedW/2 + (0.5+cos($t*360)/2) * bedW;
yCarriagePos = -bedD/2 + (0.5+cos($t*360)/2) * bedD;




BR20x20WGBP([-50,0,0],[-50,0,100]);
		   
translate([0,0,0]) 20x20TGusset(width=100-20, screws=true);        
		            
*BR20x20WGBP([50,0,0],[50,0,100]);








*translate([-350,0,-100]) xAxisAssembly();

*xCarriageBracket_stl();		            


*claddingSheets();
		            
*laserHead();

*laserMirror();

*xAxisAssembly();

*yAxesAssembly();

*translate([-650,400,0]) {
	frameAssembly();
	claddingAssembly();
	translate([0,0,bedVPos]) bedAssembly();
}

*laserAssembly();

*laserPowerSupply();
