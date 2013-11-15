
// OpenRail Plates
// Derived from reference Sketchup drawings
// 
// Plates are centred in XY plane, upper face is at z=0

include <openrailwheel.scad>


//           width, depth, thickness, corner r

ORPLATE20 = [80,    80,    3.2,       10       ];
ORPLATE40 = [100,   120,   3.2,       10       ];

function ORPlateWidth(plate) = plate[0];
function ORPlateDepth(plate) = plate[1];
function ORPlateThickness(plate) = plate[2];
function ORPlateCornerR(plate) = plate[3];

openrail_plate_offset = ORPlateThickness(ORPLATE20) + 10.5;  // z distance from plate surface to centre of v-groove wheels with doubled rails

openrail_plate_offset2 = 13.7;    //  z distance from plate surface to centre of v-groove wheels with singel rail

openrail_outercentres = 22.3;

module ORPlate(plate) {
	w = ORPlateWidth(plate);
	d = ORPlateDepth(plate);
	r = ORPlateCornerR(plate);

	rounded_square(w, d, r);
}

module openrail_plate20(wheels=false,$fn=16) {
	plate = ORPLATE20;
	w = ORPlateWidth(plate);
	d = ORPlateDepth(plate);
	r = ORPlateCornerR(plate);
	t = ORPlateThickness(plate);
	
	vitamin(str("OpenRailPlate20:"));
	color(grey50) 
		render() 
		translate([0,0,-t])
		linear_extrude(t) 
		difference() {
			ORPlate(plate);
			
			if (!simplify) {
	
				// inner holes, 10mm centres, 5.2mm diameter
				for (x=[-1,1])
					translate([x*10,0,0]) 
					circle(r=5.2/2);
				
				for (y=[-1,1])
					translate([0,y*10,0]) 
					circle(r=5.2/2);
				
				// outer holes, 22.3mm centres, 5.2 dia
				for (x=[0,1],y=[-1:1]) 
					translate([x*22.3,y*22.3,0])
					circle(r=5.2/2);
			
			
				// outer holes, 22.3 centres, 7.1 dia
				for (y=[-1:1]) 
					translate([-22.3,y*22.3,0])
					circle(r=7.1/2);
				
			}
				
		}
		
	if (wheels)
		openrail_plate20_wheels();
}

module openrail_plate40(wheels=false,$fn=16) {
	plate = ORPLATE40;
	w = ORPlateWidth(plate);
	d = ORPlateDepth(plate);
	r = ORPlateCornerR(plate);
	t = ORPlateThickness(plate);
	
	vitamin(str("OpenRailPlate40:"));
	color(grey50) 
		render() 
		translate([0,0,-t])
		linear_extrude(t) 
		difference() {
			ORPlate(plate);
	
			// inner holes, 10mm centres, 5.2mm diameter
			for (y=[-1:1])
				translate([0,y*10,0]) 
				circle(r=5.2/2);
				
			// inner columns of holes, 10mm centres, 5.2 dia
			for (x=[-1,1],y=[-3,-2,0,2,3]) 
				translate([x*10,y*10,0])
				circle(r=5.2/2);
			
			// inner rows of holes, 20mm centres, 5.2 dia
			for (x=[-2:2],y=[-1,1]) 
				translate([x*20,y*10,0])
				circle(r=5.2/2);
			
			// outer rows, 10mm/42.3 centres, 5.2 dia
			for (x=[-1:1],y=[-1,1]) 
				translate([x*10,y*42.3,0])
				circle(r=5.2/2);
			
			// right holes, 22.3 centres, 5.2 dia
			for (y=[-1:1]) 
				translate([32.3,y*42.3,0])
				circle(r=5.2/2);
			for (y=[-1,1]) 
				translate([22.3,y*42.3,0])
				circle(r=5.2/2);
			
			
			// left holes, 22.3 centres, 7.1 dia
			for (y=[-1:1]) 
				translate([-32.3,y*42.3,0])
				circle(r=7.1/2);
			for (y=[-1,1]) 
				translate([-22.3,y*42.3,0])
				circle(r=7.1/2);
				
		}
		
	if (wheels)
		openrail_plate40_wheels();
}



module openrail_wheel_assembly(useEccentricSpacer=false) {
	screw(M5_cap_screw,25);
	if (useEccentricSpacer) { 
		translate([0,0,-ORPlateThickness(ORPLATE20)]) mirror([0,0,1]) openrail_eccentric_spacer();
	} else {
		translate([0,0,-ORPlateThickness(ORPLATE20)]) mirror([0,0,1]) openrail_spacer();
	}
	
	translate([0,0,-ORPlateThickness(ORPLATE20)-2.5-5]) mirror([0,0,1]) ball_bearing(BB625_2RS);
	translate([0,0,-ORPlateThickness(ORPLATE20)-10]) mirror([0,0,1]) washer(M5_washer);
	translate([0,0,-ORPlateThickness(ORPLATE20)-11-2.5])  ball_bearing(BB625_2RS);
	
	translate([0,0,-ORPlateThickness(ORPLATE20)-10.5]) openrail_wheel();
	
	translate([0,0,-ORPlateThickness(ORPLATE20)-15]) mirror([0,0,1]) nut(M5_nut,nyloc=true);
}

module openrail_plate20_wheels() {
	// wheels sit below the plate
	
	// place at corners
	for (x=[-1,1],y=[-1,1])
		translate([x*22.3,y*22.3,0])
		openrail_wheel_assembly();
}

module openrail_plate40_wheels() {
	// wheels sit below the plate
	
	// place at corners
	for (x=[-1,1],y=[-1,1])
		translate([x*32.3,y*42.3,0])
		openrail_wheel_assembly(x<0 && y<0);
}


// example usage:
// openrail_plate20();