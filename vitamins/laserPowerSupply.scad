

laserPowerSupply_width = 169;
laserPowerSupply_height = 97;
laserPowerSupply_depth = 143;

module laserPowerSupply() {

	vitamin("laserPowerSupply:");

	//body
	color("copper")
		render()
		cube([laserPowerSupply_width, laserPowerSupply_depth, laserPowerSupply_height]);
		
	// connectors
	color("green")
		render()
		translate([12.5,-11,12])
		cube([31,11,15]);
	
	color("green")
		render()
		translate([136,-11,12])
		cube([15,11,15]);
	
	// test button
	color("red")
		render()
		translate([79,0,14])
		rotate([90,0,0])
		cylinder(r=3,h=3);
		
		
	// mounting feet
	for (x=[0,1],y=[0,1])
		if (x>0 || y>0)
		color("copper")
		render()
		translate([23.5 + x*122, y*laserPowerSupply_depth, 0])
		rotate([0,0,(y-1)*180])
		translate([-7.5,0,0]) 
		difference() {
			cube([15,16,1]);
		
			translate([7.5,4,-1]) cylinder(r=8/2, h=3);	
			
			translate([5.5,4,-1]) cube([4,9,3]);
		}
}