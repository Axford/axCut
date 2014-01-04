/* Printable hammer-style t-nut by Tomi T. Salo <ttsalo@iki.fi> 2013 */

slot_depth = 6;
slot_width = 6;
slot_total_width = 12;
slot_bottom_width = 6;
slot_lip = 2;
slot_shoulder = 0.5;
tol = 0.25;

module rect_nut(length) {
  translate([0, length/2, 0])
    rotate([90, 0, 0])
      linear_extrude(height=length)
        polygon([[-slot_width/2 + tol, slot_depth - tol], 
                 [slot_width/2 - tol, slot_depth - tol], 
                 [slot_width/2 - tol, slot_depth - slot_lip - tol],
                 [slot_total_width/2 - tol, slot_depth - slot_lip - tol],
                 [slot_total_width/2 - tol, 
                  slot_depth - slot_lip - slot_shoulder - tol],
                 [slot_bottom_width/2 - tol, 0],
                 [- slot_bottom_width/2 + tol, 0],
                 [- slot_total_width/2 + tol, 
                  slot_depth - slot_lip - slot_shoulder - tol],
                 [- slot_total_width/2 + tol, slot_depth - slot_lip - tol],
                 [- slot_width/2 + tol, slot_depth - slot_lip - tol],
                 ]);
}

module round_nut() {
  cylinder(r=slot_width/2-tol, h=slot_depth - tol, $fn=24);
  cylinder(r1=slot_bottom_width/2-tol, r2=slot_total_width/2-tol, 
           h=slot_depth - slot_lip - slot_shoulder - tol, $fn=24);
  translate([0, 0, slot_depth - slot_lip - slot_shoulder - tol])
  cylinder(r=slot_total_width/2-tol, 
           h=slot_shoulder, $fn=24);
}

module hammer_nut(hole_r=0) {
  intersection() {
    union () {
      round_nut();
      difference() {
        rect_nut(slot_width - 2*tol);
        translate([0, -slot_total_width, 0])
          cube([slot_total_width, slot_total_width, slot_depth]);
        translate([-slot_total_width, 0, 0])
          cube([slot_total_width, slot_total_width, slot_depth]);
      }
    }
    difference() {
      translate([- slot_total_width / 2, - (slot_width - tol*2) / 2, 0])
        cube([slot_total_width, slot_width - tol*2, slot_depth]);
      if (hole_r > 0) {
        cylinder(r=hole_r, h=slot_depth, $fn=12);
      }
    }
  }
}

hammer_nut(hole_r=1.25);
