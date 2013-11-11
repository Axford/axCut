//===================================== 
// This is public Domain Code
// Contributed by: William A Adams
// May 2011
//=====================================

/*
	A set of math routines for graphics calculations

	There are many sources to draw from to create the various math
	routines required to support a graphics library.  The routines here
	were created from scratch, not borrowed from any particular 
	library already in existance.

	One great source for inspiration is the book:
		Geometric Modeling
		Author: Michael E. Mortenson

	This book has many great explanations about the hows and whys
	of geometry as it applies to modeling.

	As this file may accumulate quite a lot of routines, you can either
	include it whole in your OpenScad files, or you can choose to 
	copy/paste portions that are relevant to your particular situation.

	It is public domain code, simply to avoid any licensing issues.
*/

//=======================================
//				Constants
//=======================================
// a very small number
Cepsilon = 0.00000001;

// The golden mean 
Cphi = 1.61803399;

// PI
Cpi = 3.14159;
Chalfpi = Cpi/2;
Ctau = Cpi*2;

//=======================================
//
// 				Point Routines
//
//=======================================

// Create a point
function Point2D_Create(u,v) = [u,v]; 
function Point3D_Create(u,v,w) = [u,v,w];

// Create a homogenized point from a vec3
function point3_from_vec3(vec) = [vec[0], vec[1], vec[2], 1]; 
function vec3_from_point3(pt) = [pt[0], pt[1], pt[2]];
function vec2_from_point3(pt) = [pt[0], pt[1]];
function vec2_from_vec3(pt) = [pt[0], pt[1]];

//=======================================
//
// 				Vector Routines
//
//=======================================

// Basic vector routines
function vec2_add(v1, v2) =  [v1[0]+v2[0], v1[1]+v2[1]];
function vec3_add(v1, v2) =  [v1[0]+v2[0], v1[1]+v2[1], v1[2]+v2[2]];
function vec4_add(v1, v2) = [v1[0]+v2[0], v1[1]+v2[1], v1[2]+v2[2], v1[3]+v2[3]];


function vec2_mults(v, s) =  [v[0]*s, v[1]*s];
function vec3_mults(v, s) =  [v[0]*s, v[1]*s, v[2]*s];
function vec4_mults(v, s) =  [v[0]*s, v[1]*s, v[2]*s, v[3]*s];

function vec3_dot(v1,v2) = v1[0]*v2[0]+v1[1]*v2[1]+v1[2]*v2[2];
function vec4_dot(v1,v2) = v1[0]*v2[0]+v1[1]*v2[1]+v1[2]*v2[2]+v1[3]*v2[3];

function vec4_lengthsqr(v) = v[0]*v[0]+v[1]*v[1]+v[2]*v[2]+v[3]*v[3];

// Sum of two vectors
function VSUM(v1, v2) = [v1[0]+v2[0], v1[1]+v2[1], v1[2]+v2[2]];

function VSUB(v1, v2) = [v1[0]-v2[0], v1[1]-v2[1], v1[2]-v2[2]];

function VMULT(v1, v2) = [v1[0]*v2[0], v1[1]*v2[1], v1[2]*v2[2]];

// Magnitude of a vector
// Gives the Euclidean norm
function VLENSQR(v) = (v[0]*v[0]+v[1]*v[1]+v[2]*v[2]);
function VLEN(v) = sqrt(VLENSQR(v));
function VMAG(v) = sqrt(v[0]*v[0]+v[1]*v[1]+v[2]*v[2]);


// Returns the unit vector associated with a vector
function VUNIT(v) = v/VMAG(v);
function VNORM(v) = v/VMAG(v);

// The scalar, or 'dot' product
// law of cosines
// if VDOT(v1,v2) == 0, they are perpendicular
function SPROD(v1,v2) = v1[0]*v2[0]+v1[1]*v2[1]+v1[2]*v2[2];
function VDOT(v1v2) = SPROD(v1v2[0], v1v2[1]);

// The vector, or Cross product
// Given an array that contains two vectors
function VPROD(vs) = [
	(vs[0][1]*vs[1][2])-(vs[1][1]*vs[0][2]), 
	(vs[0][2]*vs[1][0])-(vs[1][2]*vs[0][0]),
	(vs[0][0]*vs[1][1])-(vs[1][0]*vs[0][1])];
function VCROSS(v1, v2) = VPROD([v1,v2]);

// Calculate the angle between two vectors
function VANG(v1, v2) = acos(VDOT([v1,v2])/(VMAG(v1)*VMAG(v2)));

// Calculate the rotations necessary to take a polygon, and apply 
// the rotate() transform, and get the polygon to be perpendicular to 
// the specified vector.
function rotations(v) = [ 
	VANG([0,1,0], [0,v[1],v[2]]), 
	VANG([0,0,-1], [v[0],0,v[2]]), 
	VANG([1,0,0], [v[0], v[1],0])];

// Get the appropriate rotations to place a cylinder in world space 
// This is helpful when trying to place a 'line segment' in space
// Book: Essential Mathematics for Games and Interactive Applications (p.75)
function LineRotations(v) = [
	atan2(sqrt(v[0]*v[0]+v[1]*v[1]), v[2]), 
	0, 
	atan2(v[1], v[0])+90];

// The following are already provided in OpenScad, but are
// here for completeness
function VMULTS(v, s) = [v[0]*s, v[1]*s, v[2]*s];
function VDIVS(v,s) = [v[0]/s, v[1]/s, v[2]/s];
function VADDS(v,s) = [v[0]+s, v[1]+s, v[2]+s];
function VSUBS(v,s) = [v[0]-s, v[1]-s, v[2]-s];


// Some more convenience routines.  Not found in OpenScad, but primarily using OpenScad routines
function VMIN(v1,v2) = [min(v1[0],v2[0]), min(v1[1],v2[1]), min(v1[2], v2[2])];
function VMIN3(v1, v2, v3) = VMIN(VMIN(v1,v2),v3);
function VMIN4(v1, v2, v3, v4) = VMIN(VMIN3(v1, v2, v3), v4);

function VMAX(v1,v2) = [max(v1[0],v2[0]), max(v1[1],v2[1]), max(v1[2], v2[2])];
function VMAX3(v1, v2, v3) = VMAX(VMAX(v1,v2),v3);
function VMAX4(v1, v2, v3, v4) = VMAX(VMAX(v1, v2, v3), v4);


//=======================================
//
// 			MATRIX Routines
//
//=======================================
function MADD2X2(m1, m2) = [
	[m1[0][0]+m2[0][0],  m1[0][1]+m2[0][1]],
	[m1[1][2]+m2[1][0],  m1[1][1]+m2[1][1]]];

// Returns the determinant of a 2X2 matrix
// Matrix specified in row major order
function DETVAL2X2(m) = m[0[0]]*m[1[1]] - m[0[1]]*m[1[0]];

// Returns the determinant of a 3X3 matrix
function DETVAL(m) = 
	m[0[0]]*DETVAL2X2([ [m[1[1]],m[1[2]]], [m[2[1]],m[2[2]]] ]) - 
	m[0[1]]*DETVAL2X2([ [m[1[0]],m[1[2]]], [m[2[0]],m[2[2]]] ]) + 
	m[0[2]]*DETVAL2X2([ [m[1[0]],m[1[1]]], [m[2[0]],m[2[1]]] ]);

//=========================================
//	Matrix 4X4 Operations
//
// Upper left 3x3 == scaling, shearing, reflection, rotation (linear transformations)
// Upper right 3x1 == Perspective transformation
// Lower left 1x3 == translation
// Lower right 1x1 == overall scaling
//
// Note that the data is stored in a single large array
// which is column ordered.
//=========================================
m400 = 0; m401=4; m402=8;   m403=12;
m410 = 1; m411=5; m412=9;   m413=13;
m420 = 2; m421=6; m422=10; m423=14;
m430 = 3; m431=7; m432=11; m433=15;

function mat3_to_mat4(m) = [
	[m[0][0], m[0][1], m[0][2], 0],
	[m[1][0], m[1][1], m[1][2], 0],
	[m[2][0], m[2][1], m[2][2], 0],
	[m[3][0], m[3][1], m[3][2], 1],
];
 
function mat4_identity() = [
	[1, 0, 0, 0],  
	[0, 1, 0, 0],
	[0, 0, 1, 0],
	[0, 0, 0, 1]];


function mat4_transpose(m) = [
	mat4_col(m,0),
	mat4_col(m,1),
	mat4_col(m,2),
	mat4_col(m,3)
	];

function mat4_col(m, col) = [
	m[0][col],
	m[1][col],
	m[2][col],
	m[3][col]
	];

function mat4_row(m, row) = m[row];


function mat4_add(m1, m2) = m1 + m2;

// Multiply two 4x4 matrices together
// This is one of the workhorse mechanisms of the 
// graphics system
function mat4_mult_mat4(m1, m2) = [
	[vec4_dot(m1[0], mat4_col(m2,0)),
	vec4_dot(m1[0], mat4_col(m2,1)),
	vec4_dot(m1[0], mat4_col(m2,2)),
	vec4_dot(m1[0], mat4_col(m2,3))],

	[vec4_dot(m1[1], mat4_col(m2,0)),
	vec4_dot(m1[1], mat4_col(m2,1)),
	vec4_dot(m1[1], mat4_col(m2,2)),
	vec4_dot(m1[1], mat4_col(m2,3))],
	
	[vec4_dot(m1[2], mat4_col(m2,0)),
	vec4_dot(m1[2], mat4_col(m2,1)),
	vec4_dot(m1[2], mat4_col(m2,2)),
	vec4_dot(m1[2], mat4_col(m2,3))],

	[vec4_dot(m1[3], mat4_col(m2,0)),
	vec4_dot(m1[3], mat4_col(m2,1)),
	vec4_dot(m1[3], mat4_col(m2,2)),
	vec4_dot(m1[3], mat4_col(m2,3))],
];

// This is the other workhorse routine
// Most transformations are of a vector and 
// a transformation matrix.
function vec4_mult_mat4(vec, mat) = [
	vec4_dot(vec, mat4_col(mat,0)), 
	vec4_dot(vec, mat4_col(mat,1)), 
	vec4_dot(vec, mat4_col(mat,2)), 
	vec4_dot(vec, mat4_col(mat,3)), 
	];

function vec4_mult_mat34(vec, mat) = [
	vec4_dot(vec, mat4_col(mat,0)), 
	vec4_dot(vec, mat4_col(mat,1)), 
	vec4_dot(vec, mat4_col(mat,2))
	];


// Linear Transformations
//	Translate
function transform_translate(xyz) = [
	[1, 0, 0, xyz[0]],
	[0, 1, 0, xyz[1]],
	[0, 0, 1, xyz[2]],
	[0, 0, 0, 1]
	];

// 	Scale
function  transform_scale(xyz) = [
	[xyz[0],0,0,0],
	[0,xyz[1],0,0],
	[0,0,xyz[2],0],
	[0,0,0,1]
	];

//	Rotation
function transform_rotx(angle) = [
	[1, 0, 0, 0],
	[0, cos(angle), -sin(angle), 0],
	[0, sin(angle), cos(angle), 0],
	[0, 0, 0, 1]
	];

function  transform_rotz(deg) = [
	[cos(deg), -sin(deg), 0, 0],
	[sin(deg), cos(deg), 0, 0],
	[0, 0, 1, 0],
	[0, 0, 0, 1]
	];

function  transform_roty(deg) = [
	[cos(deg), 0, sin(deg), 0],
	[0, 1, 0, 0],
	[-sin(deg), 0, cos(deg), 0],
	[0, 0, 0, 1]
	];



//=======================================
//		QUATERNION
//
// As a data structure, the quaternion is represented as:
// 	x, y, z, w
//=======================================
function quat_new(x, y, z, w) = [x, y, z, w];

function quat_identity() = [0,0,0,1];

function _quat(a, s, c) = 	
	[a[0]*s, 
	a[1]*s, 
	a[2]*s,
	c];

/*
	Function: quat

	Description: Create a quaternion which represents a rotation
	around a specified axis by a given angle.

	Parameters
		axis - vec3
		angle - The amount of rotation in degrees
*/
function quat(axis, angle) = _quat(
	VNORM(axis), 
	s=sin(angle/2), 
	c=cos(angle/2));

// Basic quaternion functions
function quat_add(q1, q2) = [q1[0]+q2[0], q1[1]+q2[1], q1[2]+q2[2], q1[3]+q2[3]];

function quat_adds(q1, s) = [q1[0], q1[1], q1[2], q1[3]+s];

function quat_sub(q1, q2) = [q1[0]-q2[0], q1[1]-q2[1], q1[2]-q2[2], q1[3]-q2[3]];

function quat_subs(q1, s) = [q1[0], q1[1], q1[2], q1[3]-s];

function scalar_sub_quat(s, q1) = [-q1[0], -q1[1], -q1[2], s-q1[3]];

// Multiply two quaternions
function quat_mult(a, r) = [
	a[1]*r[2] - a[2]*r[1] + r[3]*a[0] + a[3]*r[0],
	a[2]*r[0] - a[0]*r[2] + r[3]*a[1] + a[3]*r[1],
	a[0]*r[1] - a[1]*r[0] + r[3]*a[2] + a[3]*r[2],
	a[3]*r[3] - a[0]*r[0] - a[1]*r[1] - a[2]*r[2]
	];

function quat_mults(q1, s) = [q1[0]*s, q1[1]*s,q1[2]*s,q1[3]*s];

function quat_divs(q1, s) = [q1[0]/s, q1[1]/s,q1[2]/s,q1[3]/s];

function quat_neg(q1) = [-q1[0], -q1[1],-q1[2],-q1[3]];

function quat_dot(q1, q2) = q1[0]*q2[0]+q1[1]*q2[1]+q1[2]*q2[2]+ q1[3]*q2[3];

function quat_norm(q) = sqrt(q[0]*q[0]+q[1]*q[1]+q[2]*q[2]+q[3]*q[3]);
function quat_normalize(q) = q/quat_norm(q);

function quat_conj(q) = [-q[0], -q[1], -q[2], q[3]];

function quat_distance(q1, q2) = quat_norm(quat_sub(q1-q2));

// Converting quaternion to matrix4x4
function quat_to_mat4_s(q) = (vec4_lengthsqr(q)!=0) ? 2/vec4_lengthsqr(q) : 0; 
function quat_to_mat4_xyzs(q, s) = [q[0]*s,q[1]*s, q[2]*s];
function quat_to_mat4_X(xyzs, x) = xyzs*x;
function _quat_xyzsw(xyzs, w) = xyzs*w;
function _quat_XYZ(xyzs, q)= [
		quat_to_mat4_X(xyzs, q[0]),
		quat_to_mat4_X(xyzs, q[1]),
		quat_to_mat4_X(xyzs,q[2])
		];
 
function _quat_to_mat4(xyzsw, XYZ) = [
		[(1.0-(XYZ[1][1]+XYZ[2][2])),  (XYZ[0][1]-xyzsw[2]), (XYZ[0][2]+xyzsw[1]), 0], 

		[(XYZ[0][1]+xyzsw[2]), (1-(XYZ[0][0]+XYZ[2][2])), (XYZ[1][2]-xyzsw[0]), 0],
		[(XYZ[0][2]-xyzsw[1]), (XYZ[1][2]+xyzsw[0]), (1.0-(XYZ[0][0]+XYZ[1][1])), 0], 
		[0,  0, 0, 1]
		];


function quat_to_mat4(q) = _quat_to_mat4(
	_quat_xyzsw(quat_to_mat4_xyzs(q, quat_to_mat4_s(q)),q[3]), 
	_quat_XYZ(quat_to_mat4_xyzs(q, quat_to_mat4_s(q)), q));


//=======================================
//
// 			Helper Routines
//
//=======================================

function AvgThree(v1,v2,v3) = (v1+v2+v3)/3; 
function AvgFour(v1,v2,v3,v4) = (v1+v2+v3+v4)/4;

function CenterOfGravity3(p0, p1, p2) = [
	AvgThree(p0[0], p1[0], p2[0]), 
	AvgThree(p0[1], p1[1], p2[1]), 
	AvgThree(p0[2], p1[2], p2[2])];
function CenterOfGravity4(p0, p1, p2, p3) = [
	AvgThree(p0[0], p1[0], p2[0], p3[0]), 
	AvgThree(p0[1], p1[1], p2[1], p3[1]), 
	AvgThree(p0[2], p1[2], p2[2], p3[2])];

function lerp1( p0, p1, u) = (1-u)*p0 + u*p1;
function lerp(v1, v2, u) = [
	lerp1(v1[0], v2[0],u),
	lerp1(v1[1], v2[1],u),
	lerp1(v1[2], v2[2],u)
	];

//=======================================
//
//		Cubic Curve Routines
//
//=======================================
function quadratic_U(u) = [3*(u*u), 2*u, 1, 0];
function cubic_U(u) = [u*u*u, u*u, u, 1];

function ccerp(U, M, G) = vec4_mult_mat34(vec4_mult_mat4(U, M), G); 


function cubic_hermite_M() = [ 
	[2, -2, 1, 1],
	[-3, 3, -2, -1],
	[0, 0, 1, 0],
	[1, 0, 0, 0]
	];

function cubic_bezier_M() = [
	[-1, 3, -3, 1],
	[3, -6, 3, 0],
	[-3, 3, 0, 0],
	[1, 0, 0, 0]
	];

function cubic_catmullrom_M() = [
	[-1, 3, -3, 1],
	[2, -5, 4, -1],
	[-1, 0, 1, 0],
	[0, 2, 0, 0]
	];

/*
	To use the B-spline, you must use a multiplier of 1/6 on the matrix itself
	Also, the parameter matrix is
	[(t-ti)^3, (t-ti)^2, (t-ti), 1]

	and the geometry is

	[Pi-3, Pi-2, Pi-1, Pi]
	
	Reference: http://spec.winprog.org/curves/
*/

function cubic_bspline_M() = [
	[-1, 2, -3, 1],
	[3, -6, 3, 0],
	[-3, 0, 3, 0],
	[1, 4, 1, 0],
	];

//=======================================
//
//		Bezier Curve Routines
//
//=======================================

 /* 
	Bernstein Basis Functions
	These are the coefficients for bezier curves

*/

// For quadratic curve (parabola)
function Basis02(u) = pow((1-u), 2);
function Basis12(u) = 2*u*(1-u);
function Basis22(u) = u*u;

// For cubic curves, these functions give the weights per control point.
function Basis03(u) = pow((1-u), 3);
function Basis13(u) = 3*u*(pow((1-u),2));
function Basis23(u) = 3*(pow(u,2))*(1-u);
function Basis33(u) = pow(u,3);


// Given an array of control points
// Return a point on the quadratic Bezier curve as specified by the 
// parameter: 0<= 'u' <=1
function Bern02(cps, u) = [Basis02(u)*cps[0][0], Basis02(u)*cps[0][1], Basis02(u)*cps[0][2]];
function Bern12(cps, u) = [Basis12(u)*cps[1][0], Basis12(u)*cps[1][1], Basis12(u)*cps[1][2]];
function Bern22(cps, u) = [Basis22(u)*cps[2][0], Basis22(u)*cps[2][1], Basis22(u)*cps[2][2]];

function berp2(cps, u) = Bern02(cps,u)+Bern12(cps,u)+Bern22(cps,u);

//===========
// Cubic Beziers - described by 4 control points
//===========
// Calculate a singe point along a cubic bezier curve
// Given a set of 4 control points, and a parameter 0 <= 'u' <= 1
// These functions will return the exact point on the curve
function PtOnBez2D(p0, p1, p2, p3, u) = [
	Basis03(u)*p0[0]+Basis13(u)*p1[0]+Basis23(u)*p2[0]+Basis33(u)*p3[0],
	Basis03(u)*p0[1]+Basis13(u)*p1[1]+Basis23(u)*p2[1]+Basis33(u)*p3[1]];

// Given an array of control points
// Return a point on the cubic Bezier curve as specified by the 
// parameter: 0<= 'u' <=1
function Bern03(cps, u) = [Basis03(u)*cps[0][0], Basis03(u)*cps[0][1], Basis03(u)*cps[0][2]];
function Bern13(cps, u) = [Basis13(u)*cps[1][0], Basis13(u)*cps[1][1], Basis13(u)*cps[1][2]];
function Bern23(cps, u) = [Basis23(u)*cps[2][0], Basis23(u)*cps[2][1], Basis23(u)*cps[2][2]];
function Bern33(cps, u) = [Basis33(u)*cps[3][0], Basis33(u)*cps[3][1], Basis33(u)*cps[3][2]];

function berp(cps, u) = Bern03(cps,u)+Bern13(cps,u)+Bern23(cps,u)+Bern33(cps,u);

// Calculate a point on a Bezier mesh
// Given the mesh, and the parametric 'u', and 'v' values
function berpm(mesh, uv) = berp(
	[berp(mesh[0], uv[0]), berp(mesh[1], uv[0]),
	berp(mesh[2], uv[0]), berp(mesh[3], uv[0])], 
	uv[1]);



//========================================
// Bezier Mesh normals
//========================================

// The following uses a partial derivative at each point.
// It is very expensive.
// For each point, calculate a partial derivative in both 'u' and 'v' directions, then do a cross
// product between those two to get the normal vector

// Partial derivative in the 'u' direction
function Bern03du(mesh, uv) = (Basis02(uv[0]) *  Basis03(uv[1])  *  (mesh[0][1]-mesh[0][0])) + 
					(Basis12(uv[0]) *  Basis03(uv[1])  *  (mesh[0][2]-mesh[0][1]))+
					(Basis22(uv[0]) *  Basis03(uv[1])  *  (mesh[0][3]-mesh[0][2]));


function Bern13du(mesh, uv) = ( Basis02(uv[0]) *  Basis13(uv[1])  *  (mesh[1][1]-mesh[1][0])) +
					 ( Basis12(uv[0]) *  Basis13(uv[1])  *  (mesh[1][2]-mesh[1][1])) +
					 ( Basis22(uv[0]) *  Basis13(uv[1])  *  (mesh[1][3]-mesh[1][2]));

function Bern23du(mesh, uv) = (Basis02(uv[0]) *  Basis23(uv[1])  *  (mesh[2][1]-mesh[2][0])) +
					(Basis12(uv[0]) *  Basis23(uv[1])  *  (mesh[2][2]-mesh[2][1])) +
					(Basis22(uv[0]) *  Basis23(uv[1])  *  (mesh[2][3]-mesh[2][2]));

function Bern33du(mesh, uv) =  (Basis02(uv[0]) *  Basis33(uv[1])  *  (mesh[3][1]-mesh[3][0])) +
					(Basis12(uv[0]) *  Basis33(uv[1])  *  (mesh[3][2]-mesh[3][1])) +
					(Basis22(uv[0]) *  Basis33(uv[1])  *  (mesh[3][3]-mesh[3][2]));


// Partial derivative in the 'v' direction
function Bern03dv(mesh, uv) = (Basis02(uv[1]) *  Basis03(uv[0])  *  (mesh[1][0]-mesh[0][0])) + 
					(Basis12(uv[1]) *  Basis03(uv[0])  *  (mesh[2][0]-mesh[1][0]))+
					(Basis22(uv[1]) *  Basis03(uv[0])  *  (mesh[3][0]-mesh[2][0]));


function Bern13dv(mesh, uv) = ( Basis02(uv[1]) *  Basis13(uv[0])  *  (mesh[1][1]-mesh[0][1])) +
					 ( Basis12(uv[1]) *  Basis13(uv[0])  *  (mesh[2][1]-mesh[1][1])) +
					 ( Basis22(uv[1]) *  Basis13(uv[0])  *  (mesh[3][1]-mesh[2][1]));

function Bern23dv(mesh, uv) = (Basis02(uv[1]) *  Basis23(uv[0])  *  (mesh[1][2]-mesh[0][2])) +
					(Basis12(uv[1]) *  Basis23(uv[0])  *  (mesh[2][2]-mesh[1][2])) +
					(Basis22(uv[1]) *  Basis23(uv[0])  *  (mesh[3][2]-mesh[2][2]));

function Bern33dv(mesh, uv) =  (Basis02(uv[1]) *  Basis33(uv[0])  *  (mesh[1][3]-mesh[0][3])) +
					(Basis12(uv[1]) *  Basis33(uv[0])  *  (mesh[2][3]-mesh[1][3])) +
					(Basis22(uv[1]) *  Basis33(uv[0])  *  (mesh[3][3]-mesh[2][3]));



function Bern3du(mesh, uv) = Bern03du(mesh, uv) + Bern13du(mesh, uv) + Bern23du(mesh, uv) + Bern33du(mesh, uv);
function Bern3dv(mesh, uv) = Bern03dv(mesh, uv) + Bern13dv(mesh, uv) + Bern23dv(mesh, uv) + Bern33dv(mesh, uv);


// Calculate the normal at a specific u/v on a Bezier patch
function nberpm(mesh, uv) = VUNIT(VPROD([Bern3du(mesh, uv), Bern3dv(mesh, uv)]));





// Given a mesh of control points, and an array that contains the 
// row and column of the quad we want, return the quad as an 
// ordered set of points. The winding will be counter clockwise
function GetControlQuad(mesh, rc) = [ 
	mesh[rc[0]+1][rc[1]], 
	mesh[rc[0]][rc[1]], 
	mesh[rc[0]][rc[1]+1], 
	mesh[rc[0]+1][rc[1]+1]
	];


// Given a mesh, and the 4 parametric points, return a quad that has the appropriate 
// points along the curve, in counter clockwise order
function GetCurveQuad(mesh, u1v1, u2v2) = [
	berpm(mesh, [u1v1[0],u2v2[1]]), 
	berpm(mesh, u1v1),
	berpm(mesh, [u2v2[0],u1v1[1]]), 
	berpm(mesh, u2v2)];

function GetCurveQuadNormals(mesh, u1v1, u2v2) = [[ 
	berpm(mesh, [u1v1[0],u2v2[1]]), 
	berpm(mesh, u1v1),
	berpm(mesh, [u2v2[0],u1v1[1]]), 
	berpm(mesh, u2v2),
	],[
	nberpm(mesh, [u1v1[0],u2v2[1]]), 
	nberpm(mesh, u1v1),
	nberpm(mesh, [u2v2[0],u1v1[1]]), 
	nberpm(mesh, u2v2),
	]];


//=======================================
//
//		Hermite Curve Routines
//
//=======================================

/* 
Hermite Curve Basis Functions
Expressed in terms of cubic Bernstein basis functions

For cubic Hermite curves
these functions give the weights per control point.

http://en.wikipedia.org/wiki/Cubic_Hermite_spline
*/

// To express in terms of Bernstein cubic basis functions
function HERMp0(u) = Basis03(u)+Basis13(u); 	// h00
function HERMm0(u) = 1/3 * Basis13(u); 		// h10
function HERMp1(u) = Basis33(u) + Basis23(u); 	// h01
function HERMm1(u) = -1/3 * Basis23(u); 		// h11


// Given an array of control points
// Return a point on the Hermite curve as specified by the 
// parameter: 0<= 'u' <=1
function herp1(cps, u) = HERMp0(u)*cps[0] + HERMm0(u)*cps[1] + HERMp1(u)*cps[2] + HERMm1(u)*cps[3];

// Hermite Interpolation
function herp(cps, u) = [herp1([cps[0][0][0], cps[0][1][0], cps[1][0][0], cps[1][1][0]]),
				herp1([cps[0][0][1], cps[0][1][1], cps[1][0][1], cps[1][1][1]]),
				herp1([cps[0][0][2], cps[0][1][2], cps[1][0][2], cps[1][1][2]])];

// Calculate a point on a Hermite mesh
// Given the mesh, and the parametric 'u', and 'v' values
function herpm(mesh, uv) = herp(
	[herp(mesh[0], uv[0]), herp(mesh[1], uv[0]),
	herp(mesh[2], uv[0]), herp(mesh[3], uv[0])], 
	uv[1]);


// Given a mesh, and the 4 parametric points, return a quad that has the appropriate 
// points along the curve, in counter clockwise order
function GetHermiteQuad(mesh, u1v1, u2v2) = [
herpm(mesh, [u1v1[0],u2v2[1]]), 
herpm(mesh, u1v1),
herpm(mesh, [u2v2[0],u1v1[1]]), 
herpm(mesh, u2v2)];

// Given a first hermite curve, 'cpsu'
// and a second hermite curve 'cpsv'
// sweep the first, cpsu, along the second cpsv
// Calculate a patch for the given u,v parameters
function GetHermSweepQuad(cpsu, cpsv, uv1, uv2) = [
	herp(cpsu, uv1[0])+herp(cpsv, uv1[1]),
	herp(cpsu, uv2[0])+herp(cpsv, uv1[1]),
	herp(cpsu, uv2[0])+herp(cpsv, uv2[1]),
	herp(cpsu, uv1[0])+herp(cpsv, uv2[1])
	];
