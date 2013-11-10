// OpenRail rail
// drawn by jdausilio/zeke7237
// I had to do this one from measurements, and assume that the wheel profile is the same as the rail

$fn=100;

side=3.42;
width=20;		// width not including point
overhang=0.8;	// rectangle below point
thickness=2.4;	// thickness of skinny part
hypotenuse=side*sqrt(2);
hole_spacing=50;
hole_width=5.25;
hole_height=12;

module oval_hole() {
	minkowski() {
		cylinder(r=2.625,h=thickness+5,center=true);
		cube([0.00001,hole_height/2,thickness+5],center=true);
	}
}

module openrail(length) {
	color([0.2,0.2,0.2]) difference() {
		union() {
			rotate([0,0,45])cube([side,side,length],center=true);
			translate([width/2,0,0])cube([width,hypotenuse,length],center=true);
		}
		translate([(width-overhang)/2+overhang+0.1,-thickness/2-0.1,0])cube([width-overhang+0.2,hypotenuse-thickness+0.2,length+0.1],center=true);
		for(i=[-floor(length/(2*hole_spacing)):1:floor(length/(2*hole_spacing))]) {
			*translate([width/2,thickness/2+0,i*50])rotate([0,90,90])oval_hole();
		}
	}
}


