include <config/config.scad>

include <assemblies/zAxes.scad>
include <assemblies/bed.scad>
include <assemblies/cladding.scad>
include <assemblies/xAxis.scad>
include <assemblies/frame.scad>
include <assemblies/laser.scad>
include <assemblies/yAxes.scad>


laserAssembly();

*frameAssembly();

zAxesAssembly();

translate([0,0,bedVPos]) bedAssembly();

*yAxesAssembly();

*claddingAssembly();
