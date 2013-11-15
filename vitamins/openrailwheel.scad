// OpenRail delrin or steel wheel
// drawn by jdausilio/zeke7237

// from openbuilds drawings
openrailwheel_minRadius=18.75/2;
openrailwheel_coneMajorRadius=24.39/2;
openrailwheel_coneMinorRadius=9.77;
openrailwheel_width=10.23;
openrailwheel_vWidth=4.84;
openrailwheel_vGap=0.55;
openrailwheel_holeRadius=15.75/2;
openrailwheel_ridge=13.89/2;

module v_cone() {
	cylinder(r1=openrailwheel_coneMinorRadius,r2=openrailwheel_coneMajorRadius,h=openrailwheel_vWidth/2, center=true);
}

module openrail_eccentric_spacer() {
	vitamin(str("OpenRailEccentricSpacer:"));
	
	color(grey80)
		render()
		tube(8/2,5/2,5,$fn=6,center=false);
}

module openrail_spacer() {
	vitamin(str("OpenRailSpacer:"));
	
	color(grey80)
		render()
		tube(7/2,5/2,5,center=false);
}

module openrail_wheel() {
	vitamin(str("DelrinVGrooveWheel:"));

	color(grey20)
	render()
	difference() {
		union() {
			difference() {
				union() {
					cylinder(r=openrailwheel_minRadius, h=openrailwheel_width, center=true);
					translate([0,0,openrailwheel_vWidth/2+openrailwheel_vGap/2])cylinder(r=openrailwheel_coneMinorRadius, h=openrailwheel_vWidth, center=true);
					translate([0,0,-openrailwheel_vWidth/2-openrailwheel_vGap/2])cylinder(r=openrailwheel_coneMinorRadius, h=openrailwheel_vWidth, center=true);
					translate([0,0,openrailwheel_vGap/2+openrailwheel_vWidth/4])v_cone();
					translate([0,0,openrailwheel_vGap/2+openrailwheel_vWidth/4+openrailwheel_vWidth/2])rotate([180,0,0])v_cone();
					translate([0,0,-(openrailwheel_vGap/2+openrailwheel_vWidth/4)])rotate([180,0,0])v_cone();
					translate([0,0,-(openrailwheel_vGap/2+openrailwheel_vWidth/4+openrailwheel_vWidth/2)])v_cone();
				}
				cylinder(r=openrailwheel_holeRadius,h=20,center=true);
			}
			cylinder(r=openrailwheel_holeRadius+1,h=1,center=true);
		}
		cylinder(r=openrailwheel_ridge,h=5,center=true);
	}
}

