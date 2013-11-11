//
// axCut
//
// GNU GPL v2
//
// Configuration file
//
bom = 2;                        // 0 no bom, 1 assemblies and stls, 2 vitamins as well
exploded = 0;                   // 1 for exploded view
simplify = false;    // reduces complexity of some parts, e.g. alu extrusions

show_jigs = true;               // show printed jigs required to build the machine
show_support = true;            // show support structures, must be set when generating STLs

// Real-world colors for various parts & vitamins
use_realistic_colors = true;    // true for "real" colors, false for "distinct" colors (useful during design and for build instructions)
printed_plastic_color = "blue";
cable_strip_real_color = "fuchsia";
belt_real_color = "yellow";
bulldog_real_color ="black";

eta = 0.01;                     // small fudge factor to stop CSG barfing on coincident faces.
$fa = 5;
$fs = 0.5;

perim = 0.7;
layers = 0.3;
2perim = 2*perim;
4perim = 4*perim;

//
// Hole sizes
//
No2_pilot_radius = 1.7 / 2;       // self tapper into ABS
No4_pilot_radius = 2.0 / 2;       // wood screw into soft wood
No6_pilot_radius = 2.0 / 2;       // wood screw into soft wood

No2_clearance_radius = 2.5 / 2;
No4_clearance_radius = 3.5 / 2;
No6_clearance_radius = 4.0 / 2;

M2p5_tap_radius = 2.05 / 2;
M2p5_clearance_radius= 2.8 / 2;   // M2.5
M2p5_nut_trap_depth = 2.5;

M3_tap_radius = 2.5 / 2;
M3_clearance_radius = 3.3 / 2;
M3_nut_radius = 6.5 / 2;
M3_nut_trap_depth = 3;

M4_tap_radius = 3.3 / 2;
M4_clearance_radius = 2.2;
M4_nut_radius = 8.2 / 2;
M4_nut_trap_depth = 4;

M5_tap_radius = 4.2 / 2;
M5_clearance_radius = 5.3 / 2;
M5_nut_radius = 9.2 / 2;
M5_nut_depth = 4;

M6_tap_radius = 5 / 2;
M6_clearance_radius = 6.4 / 2;
M6_nut_radius = 11.6 / 2;
M6_nut_depth = 5;

M8_tap_radius = 6.75 / 2;
M8_clearance_radius = 8.4 / 2;
M8_nut_radius = 15.4 / 2;
M8_nut_depth = 6.5;


include <colors.scad>
include <utils.scad>
include <vitamins.scad>

endstop_wires    = [2, 1.4, "A"];   // 7 strands of 0.2
motor_wires      = [4, 1.4, "B"];
bed_wires        = [2, 2.8, "C"];   // 13A mains cable
fan_motor_wires  = [6, 1.4, "D"];   // fan and motor wires along top of gantry
two_motor_wires  = [8, 1.4,,"E"];   // Y and Z motors
thermistor_wires = endstop_wires;

endstop_wires_hole_radius = wire_hole_radius(endstop_wires);
motor_wires_hole_radius = wire_hole_radius(motor_wires);
two_motor_wires_hole_radius = wire_hole_radius(two_motor_wires);
fan_motor_wires_hole_radius = wire_hole_radius(fan_motor_wires);
bed_wires_hole_radius = wire_hole_radius(bed_wires);
thermistor_wires_hole_radius = wire_hole_radius(thermistor_wires);

cnc_sheets = false;                 // If sheets are cut by CNC we can use slots, etc instead of just round holes
base_nuts = false;                  // Need something under the base if using nuts
pulley_type = T5x8_plastic_pulley;

Z_bearings = LM10UU;

X_motor = NEMA17;
Y_motor = NEMA17;
Z_motor = NEMA17;

pulley_type = T2p5x16_metal_pulley;

X_belt = T2p5x6;
Y_belt = T2p5x6;

motor_shaft = 5;
Z_screw_dia = 6;            // Studding for Z axis

Z_nut_radius = M6_nut_radius;
Z_nut_depth = M6_nut_depth;
Z_nut = M6_nut;

//
// Default screw use where size doesn't matter
//
cap_screw = M3_cap_screw;
hex_screw = M3_hex_screw;
//
// Screw for the frame and base
//
frame_soft_screw = No6_screw;               // Used when sheet material is soft, e.g. wood
frame_thin_screw = M4_cap_screw;            // Used with nuts when sheets are thin
frame_thick_screw = M4_pan_screw;           // Used with tapped holes when sheets are thick and hard, e.g. plastic or metal
//
// Feature sizes
//
default_wall = 3;
thick_wall = 4;

screw_clearance_radius = screw_clearance_radius(cap_screw);
nut = screw_nut(cap_screw);
nut_radius = nut_radius(nut);
nut_trap_depth = nut_trap_depth(nut);
washer = screw_washer(cap_screw);

belt_clearance = 0.2;                   // clearance of belt clamp slots

Z_bar_dia = Z_bearings[2];

Y_idler_bearing = BB624;
X_idler_bearing = BB624;



///  

bedW = 850;
bedD = 600;
bedH = 300;
bedM = 30;  // bed margin, applied all round
bedO = 60;  //bedOvershoot - applies to width only

bedWM = bedW + 2*bedM;  // with margins
bedDM = bedD + 2*bedM;

bedRibs = 6;  // number of ribs (along y axis)

bedVPos = 200;

xO = 50;  // xOvershoot
xVPos = 300;  // height of x axis above datum
yVPos = 270;  // height of y axis - to centreline of 2040 profile

wheelOR = 19/2;  // radius to bearing surface, approx

rightW = 120;  // width of right casing, excludes outer panelling, runs from edge of bed margin
leftW = 120;
backD = 160;  // depth of back casing
frontD = 25;  // depth of front casing

claddingC = 5;  // cladding clearance, inc thickness
claddingT = 3;  // cladding thickness
