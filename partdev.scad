include <config/config.scad>

// animation
xCarriagePos = -bedW/2 + (0.5+cos($t*360)/2) * bedW;
yCarriagePos = -bedD/2 + (0.5+cos($t*360)/2) * bedD;


*translate([-10,10,0]) openrail_doubled(100,true,true);

*translate([0,-10,0]) aluProExtrusion(BR_20x20, 100);

*aluProGusset(BR_20x20_Gusset, screws=true);

*translate([0,50,-10]) rotate([90,0,0]) aluProExtrusion(BR_20x20, 100);

*translate([-openrail_plate_offset - 10,0,0])
rotate([0,-90,0]) {
	openrail_plate20(wheels=true);
}

*belt(T5x10, 10, 11-4.87, 4.87, 200, 20, 11);


*BR20x40WG(100,startGussets=[1,1,0,1,1,1], 
		            endGussets=[1,1,0,1,0,1]);
		            

*translate([-350,0,-100]) xAxisAssembly();

xCarriageBracket_stl();		            


*claddingSheets();
		            
*laserHead();

*laserMirror();

*xAxisAssembly();

*yAxesAssembly();

*frameAssembly();

*claddingAssembly();

*translate([0,0,bedVPos]) bedAssembly();


*laserAssembly();

*laserPowerSupply();

*cableChainLink();