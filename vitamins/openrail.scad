// OpenRail rail
// drawn by jdausilio/zeke7237
// I had to do this one from measurements, and assume that the wheel profile is the same as the rail
// Modified by damian@axford.me.uk to play nice with other libraries

openrail_side=3.42;
openrail_width=20;		// openrail_width not including point
openrail_overhang=0.8;	// rectangle below point
openrail_thickness=2.4;	// openrail_thickness of skinny part
openrail_hypotenuse=openrail_side*sqrt(2);
openrail_hole_spacing=50;
openrail_hole_width=5.25;
openrail_hole_height=12;

module openrail_oval_hole() {
	minkowski() {
		cylinder(r=2.625,h=openrail_thickness+5,center=true);
		cube([0.00001,openrail_hole_height/2,openrail_thickness+5],center=true);
	}
}

module openrail(length) {
	color([0.2,0.2,0.2]) difference() {
		union() {
			rotate([0,0,45])cube([openrail_side,openrail_side,length],center=true);
			translate([openrail_width/2,0,0])cube([openrail_width,openrail_hypotenuse,length],center=true);
		}
		translate([(openrail_width-openrail_overhang)/2+openrail_overhang+0.1,-openrail_thickness/2-0.1,0])cube([openrail_width-openrail_overhang+0.2,openrail_hypotenuse-openrail_thickness+0.2,length+0.1],center=true);
		for(i=[-floor(length/(2*openrail_hole_spacing)):1:floor(length/(2*openrail_hole_spacing))]) {
			*translate([openrail_width/2,openrail_thickness/2+0,i*50])rotate([0,90,90])openrail_oval_hole();
		}
	}
}


