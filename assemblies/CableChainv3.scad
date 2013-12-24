// 2013 Thomas Bucher
// CableChain v3
//
// Make sure, length is >= 2 * height + 3 * wall
// Define the following parameters as needed.
// chain parts to connect and print - 8
chainlength=1;
// Total Length of one chain peace - 30
length=26;
// Width of the chain - 12
width=12;
// Hight of the chain - 12
height=12;
// Wall thinkness - 1.2
wall=0.7*2;
// Space between the chain parts and the matches - 0.2
space=0.3;
// Angle for maximum bending of one peace. -  45 
// Possible values from 0 - 90
angle=50;
// overlapping value to make the Object simple - leave this at 0.01
overlapping=0.01;
// Connection tweak - 0 
// You may add or subtract here a little for the nopples, so the whole thing gets stickier or less between the chainparts.
conntweak=0;
// No need to change stuff beyond this point... hopefully :-D

// Middle part of a Chainpeace
module pcsMiddlePart(width, length, height, wall) 
{
	difference() {
		// Main Object
		cube([width,length - height * 2 ,height]);
		// Hole in the Middle
		translate([2 * wall + space,-1 ,wall]) 
			cube([width - 4 * wall - 2 * space,length + 2 ,height - 2* wall]);
		// Cutout Front
		translate([1 * wall , 0 - overlapping,wall])	
			cube([width - 2 * wall , space * 2 ,height - 2 * wall]);
		// Cutout Back left
		translate([- overlapping,length - height * 2 - 2 * space + overlapping,-.5]) 
			cube([wall+space+overlapping, space * 2, height + 1]);
		// Cutout Back Right
		translate([width - wall - space ,length - height * 2 - 2 * space + overlapping,-.5]) 
			cube([wall+space+overlapping, space * 2, height + 1]);
	}
}

// Front Part, the one with the nopples
module pcsOFront(width, length, height, wall,angle)
{
	// Add all the single Objects
	union() { 
		// Cut out the Hole from the big Part
		difference() {
			// Model the full object
			union() {
				rotate([0,90,0])	
					translate([-height/2,-height/2,0]) 
						cylinder(width,height/2,height/2, $fn=48);
				translate([0,-height / 2,0]) 
					cube([width,height/2,height]);
				translate([0,-height , 0]) 
					cube([width,height/2,height/2]);
				difference() {
					translate([0,-height/2,height/2])
						rotate([90-angle,0,0])
							cube([wall,height/2,height/2]);
 					translate([-1,-height,height])
							cube([wall+2, height, height]);
				}
				difference() {
					translate([width - wall,-height/2,height/2])
						rotate([90-angle,0,0])
							cube([wall,height/2,height/2]);
 					translate([width - wall -1,-height,height])
							cube([wall+2, height, height]);
				}

			}
			// Cut out cableway
			translate([wall,-height -1 ,-1]) 
				cube([width - 2 * wall,height+2,height+2]);
		}
		// Add the Nopples
		translate([wall,-height/2,height/2]) 
			rotate([0,90,0]) 
				cylinder(wall + space,wall*2 + space + conntweak,wall + space+ conntweak, $fn=48);
		translate([width-wall ,-height/2,height/2]) 
			rotate([180,90,0]) 
				cylinder(wall + space,wall*2 + space+ conntweak,wall + space+ conntweak, $fn=48);
	}
}

// Back Part, the one with the holes
module pcsOBack(width, length, height, wall)
{
	// Cut out all the holes we need
	difference() { 
		// Cut out the Hole from the big Part
		difference() {
			// Model the full Object
			union() {
				rotate([0,90,0])	
					translate([-height/2,-height/2,wall + space]) 
						cylinder(width - 2 * (wall + space),height/2,height/2, $fn=48);
				translate([wall + space ,-height,0]) 
					cube([width - 2 * (wall + space),height/2,height]);
			}
			translate([2 * wall + space, -height -1 ,-1]) 
				cube([width - 4 * wall - 2 * space,height+2,height+2]);
		}
		translate([wall + space -overlapping,- height/2,height/2]) 
			rotate([0,90,0]) 
				cylinder(wall+space,wall*2+space,wall+space, $fn=48);
		translate([width - wall + overlapping - space,-height/2,height/2]) 
			rotate([180,90,0]) 
				cylinder(wall+space,wall*2+space,wall+space, $fn=48);
	}
}

// Put the Parts together to a single Chain object
module pcsOChain(width, length, height, wall, angle, posx,posy) 
{
	translate([posx,posy,0]) {
		pcsMiddlePart(width, length, height, wall);
		pcsOFront(width, length, height, wall,angle);
		translate([0,length - height - overlapping,0]) pcsOBack(width, length, height, wall);
	}
}

module cableChainV3() {
	// Magic happens here, make several chain parts and add them to a chain
	for (i = [1:chainlength]) { 
		pcsOChain(width, length, height, wall,angle, 0, i * (length - height));
	}
}