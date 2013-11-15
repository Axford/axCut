include <config/config.scad>


laserAssembly();

frameAssembly();

zAxesAssembly();

translate([0,0,bedVPos]) bedAssembly();

yAxesAssembly();

*claddingAssembly();
