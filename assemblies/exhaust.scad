


module exhaustCoupling_stl() {
    od1 = 99;
    od2 = 97;
    h = 38;
    t = 4;
    wall = 3;

    w = od1 + 8;

    difference() {
        union() {
            // tube connector
            cylinder(r1=od1/2, r2=od2/2, h=h);

            // base plate
            translate([-w/2, -w/2, 0])
                roundedRect([w,w,t],28);

            // chamfer join to base plate
            rotate_extrude()
                polygon(points = [[od1/2-eta,t-eta], [od1/2+4, t-eta], [od1/2-eta, t + 4]]);
        }

        // hole in base plate
        translate([0,0,-1])
            cylinder(r1=od1/2-wall, r2=od2/2-wall, h=h+2);

        // fixings
        for (x=[-1,1], y=[-1,1])
            translate([x * (w-25)/2, y* (w-25)/2, 0])
            cylinder(r=4.3/2, h=100, center=true);

        // nibble the sides
        for (i=[0:3])
            rotate([0,0, 90*i])
            translate([2.5*w-4, 0, 0])
            cylinder(r=2*w, h=100, center=true, $fn=256);
    }
}
