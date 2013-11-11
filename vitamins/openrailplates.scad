
// OpenRail Plates
// Derived from reference Sketchup drawings
// 
// Plates are centred in XY plane, upper face is at z=0


//           width, depth, thickness, corner r

ORPLATE20 = [80,    80,    3.2,       10       ];
ORPLATE40 = [100,   120,   3.2,       10       ];

function ORPlateWidth(plate) = plate[0];
function ORPlateDepth(plate) = plate[1];
function ORPlateThickness(plate) = plate[2];
function ORPlateCornerR(plate) = plate[3];

module ORPlate(plate) {
	w = ORPlateWidth(plate);
	d = ORPlateDepth(plate);
	r = ORPlateCornerR(plate);

	rounded_square(w, d, r);
}

module ORPlate20($fn=16) {
	plate = ORPLATE20;
	w = ORPlateWidth(plate);
	d = ORPlateDepth(plate);
	r = ORPlateCornerR(plate);
	t = ORPlateThickness(plate);
	
	vitamin(str("OpenRail Plate 20"));
	color(grey50) 
		render() 
		translate([0,0,-t])
		linear_extrude(t) 
		difference() {
			ORPlate(plate);
	
			// holes
			circle(r=5.2/2);
		}
}





// example usage:
// ORPlate20();