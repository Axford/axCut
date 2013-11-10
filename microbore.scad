microbore_color = [0.8,0.65,0.4,1];

use <curvedPipe.scad>
use <moreShapes.scad>

// modules are repeated to allow for longer hierarchical chains


module microborePipe(l=100, od=10, id=8) {
	// children are long z, -z

	color(microbore_color) tube(od/2, id/2, l, false);

	if ($children > 0) {
		translate([0,0,l]) child(0);
	
		if ($children > 1) rotate([0,180,0]) child(1);
	}
}

module microborePipe2(l=100, od=10, id=8) {
	// children are long z, -z

	color(microbore_color) tube(od/2, id/2, l, false);

	if ($children > 0) {
		translate([0,0,l]) child(0);
	
		if ($children > 1) rotate([0,180,0]) child(1);
	}
}

module microborePipe3(l=100, od=10, id=8) {
	// children are long z, -z

	color(microbore_color) tube(od/2, id/2, l, false);

	if ($children > 0) {
		translate([0,0,l]) child(0);
	
		if ($children > 1) rotate([0,180,0]) child(1);
	}
}



module microboreCap(od=10) {
	color(microbore_color) difference() {
		cylinder(h=od, r=od/2+1);
		translate([0,0,-1]) cylinder(h=od, r=od/2);
	}

	// children are along -z
	if ($children > 0) {
		rotate([0,180,0]) child(0);
	}
}

module microboreT(od=10) {
	// children are along x, z, -x	

	// T points up z axis
	color(microbore_color) union() {
		microborePipe(l=20, od=od+2);
		translate([-15,0,0]) rotate([0,90,0]) microborePipe(l=30, od=od+2);
	}

	if ($children > 0) {
		rotate([0,90,0]) translate([0,0,15]) child(0);
	
		if ($children > 1) translate([0,0,l]) child(1);
		if ($children > 2) rotate([0,-90,0]) translate([0,0,15]) child(2);
	}
}

module microboreNozzle(l=25, od=10, nod=4) {
	// nod = nozzle outer diameter
	// children are along -z
	color(microbore_color) difference() {
		union() {
			cylinder(h=od, r=od/2+1);
			translate([0,0,od]) cylinder(h=(l-od)/2, r1=od/2+1, r2=nod/2);
			cylinder(h=l, r=nod/2);
		}
		translate([0,0,-1]) cylinder(h=l+2, r=nod/2-0.2);
	}

	if ($children > 0) {
		rotate([0,180,0]) child(0);
	}
}

module microboreElbow(od=10) {
	// elbow points along x
	// children are along x, -z
	color(microbore_color) union() {
		microborePipe(l=1.5*od, od=od+2);
		translate([0,0,od * 1.5]) rotate([0,90,0]) microborePipe(l=1.5*od, od=od+2);
		translate([0,0,od * 1.5]) sphere(r=(od + 2)/2);
	}

	if ($children > 0) {
		translate([1.5 * od,0,1.5*od]) rotate([0,90,0]) child(0);
	
		if ($children > 1) rotate([0,180,0]) child(1);
	}
}

module microboreElbow2(od=10) {
	// elbow points along x
	// children are along x, -z
	color(microbore_color) union() {
		microborePipe(l=1.5*od, od=od+2);
		translate([0,0,od * 1.5]) rotate([0,90,0]) microborePipe(l=1.5*od, od=od+2);
		translate([0,0,od * 1.5]) sphere(r=(od + 2)/2);
	}

	if ($children > 0) {
		translate([1.5 * od,0,1.5*od]) rotate([0,90,0]) child(0);
	
		if ($children > 1) rotate([0,180,0]) child(1);
	}
}


module pipeNetwork(fittings, network, lengths) {
	for (path=network) {
		echo("network ", path);
		for(segment = path) {
			if (len(segment)) {
				for (segment1 = segment) {
					echo ("segment1 ", segment1);
					echo(segment);
				}
			} else {
				
				echo ("segment ", segment);
			}
		}
	}
	
}

//pipeNetwork(fittings=[0,0,0,0], network=[[0,[1,3],2]], lengths=[[100,[50],150]]);




// test
module microboreTest() {
	microboreT() {
		microborePipe() microboreNozzle();
		microborePipe() microboreCap();
		microborePipe() microboreElbow() microborePipe2() microboreElbow2() microborePipe3();
	}

	translate([0,50,0]) microboreElbow() { microborePipe(); microborePipe(); }
}

microboreTest();
