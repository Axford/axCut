// OpenRail delrin or steel wheel
// drawn by jdausilio/zeke7237

// from openbuilds drawings
$fn=32;
min_radius=18.75/2;
cone_major_radius=24.39/2;
cone_minor_radius=9.77;
width=10.23;
v_width=4.84;
v_gap=0.55;
hole=15.75/2;
ridge=13.89/2;

module v_cone() {
	cylinder(r1=cone_minor_radius,r2=cone_major_radius,h=v_width/2, center=true);
}

module openrailwheel() {
	difference() {
		union() {
			difference() {
				union() {
					cylinder(r=min_radius, h=width, center=true);
					translate([0,0,v_width/2+v_gap/2])cylinder(r=cone_minor_radius, h=v_width, center=true);
					translate([0,0,-v_width/2-v_gap/2])cylinder(r=cone_minor_radius, h=v_width, center=true);
					translate([0,0,v_gap/2+v_width/4])v_cone();
					translate([0,0,v_gap/2+v_width/4+v_width/2])rotate([180,0,0])v_cone();
					translate([0,0,-(v_gap/2+v_width/4)])rotate([180,0,0])v_cone();
					translate([0,0,-(v_gap/2+v_width/4+v_width/2)])v_cone();
				}
				cylinder(r=hole,h=20,center=true);
			}
			cylinder(r=hole+1,h=1,center=true);
		}
		cylinder(r=ridge,h=5,center=true);
	}
}

