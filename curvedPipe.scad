
use <vector.scad>   // Author: Juan Gonzalez-Gomez, GPL
use <maths.scad>    // Author: William A Adams, Public Domain
use <moreShapes.scad>    // Author: Damian Axford, with elements by nophead, Public Domain

fudge = 0.01;

// result is u-v
function subv(u,v) = [u[0]-v[0], u[1]-v[1], u[2]-v[2]];

function vec3_from_vec4(v) = [v[0], v[1], v[2]];
function vec4_from_vec3(v) = [v[0], v[1], v[2], 1];

module pipeOrientate(v1,v2)
{
	// calc rotation for v1	
	v1axis = v1[0]==0 && v1[1] == 0 ? [0,1,0] : cross([0,0,1], v1);    // condition accounts for v1 being aligned with z axis
	v1ang = anglev([0,0,1], v1);
		
	v1axisLen = mod(v1axis);
	
	// v2 as vec4	
	vec2 = vec4_from_vec3(v2);
	
	// make quat to reverse the final rotation
	qRev = quat(v1axis, v1ang);
	qRevMat = quat_to_mat4(qRev);

	// rotate v2 by qRev
	vec2Rev = v1axisLen>0 ? vec4_mult_mat4(vec2, qRevMat) : vec2;

	// look and x,y components of vec2Rev and calc rot about z
	theta = atan2(vec2Rev[1], vec2Rev[0]);
	
	// complete the two rotations
    rotate(a=v1ang, v=v1axis)
	  rotate(a=theta<0 || theta>0?theta:0, v=[0,0,1])
         child(0);
}

module pipeCurve(points,point,radii, od,id,isLastSegment=false) {
	pre = points[point-1];
	start = points[point];
	mid = points[point+1];
	end = points[point+2];

	post = points[point+3];
	preR = radii[point-1];
	r = radii[point];	
	postR = radii[point+1];

	dir1 = subv(mid,start);
	dir2 = subv(end,mid);
	l1 = mod(dir1);
	l2 = mod(dir2);
	ang = anglev(dir1,dir2);

	preDir = pre? subv(start,pre) : dir1;
	preAng = pre? anglev(preDir, dir1) : 0;
	preInset = pre? preR * tan(preAng/2) : 0;
	
	postDir = post? subv(post,end) : dir2;
	postAng = post? anglev(dir2, postDir) : 0;
	postInset = post? postR * tan(postAng/2) : 0;
	
	dir1u = unitv(dir1);
	inset = r * tan(ang/2);
	rStart = start + (l1-inset)*dir1u;
	
	// start
	translate(start) orientate(dir1) translate([0,0,preInset]) tube(h=l1-preInset-inset,or=od/2, ir=id/2, center=false);

	//end
	translate(mid) orientate(dir2) translate([0,0,inset]) tube(h=l2-postInset-inset,or=od/2, ir=id/2, center=false);
	
	// curved section
	// nb: torus slice always starts at x axis and goes counter clockwise around z
	translate(rStart) 
	pipeOrientate(dir1,dir2)
	rotate([0,0,180])  // rotate to lie along x
	rotate([90,0,0]) // flip up
	translate([-r,0,0]) torusSlice(r1=r, r2=od/2, r3=id/2, start_angle=0, end_angle=ang);
}


module curvedPipe(points, segments, radii, od, id) {
	union() {
		for (point = [0:segments-2]) 
			pipeCurve(points,point,radii,od,id);
	}
}



//test pieces
if (false) {
	curvedPipe([ [0,0,0],
				[100,0,0],
				[100,100,0],
				[50,100,100],
				[50,100,150],
				[0,100,50],
				[0,0,0],
				[50,0,50]
			   ],
	            7,
				[70,30,30,6,50,30],
			    10,
				8);
	
	
	rotate([0,0,180]) curvedPipe([ [0,0,0],
				[100,0,0],
				[100,100,0],
				[100,100,100],
				[0,100,100],
				[0,100,0],
				[0,0,0],
				[50,0,50]
			   ],
	            7,
				[70,30,30,6,50,30],
			    10,
				8);
}

