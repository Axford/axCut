//  laserOptics parts
//  Based on parts ordered from cnsigntech (ebay member) - http://www.ebay.co.uk/usr/cnsigntech


laserHeadBody_width = 38;
laserHeadBody_height = 74;
laserHeadBody_depth = 36.5;
laserHeadBody_plateThickness = 5;
laserHeadBody_chamferStart = 40;
laserHeadBody_notchWidth = 9.5;
laserHeadBody_notchHeight = 52;
laserHeadBody_notchRadius = 10;
laserHeadBody_mountSlotWidth = 5;
laserHeadBody_mountSlotHeight = 14;
laserHeadBody_mountSlotOffsetY = 3.5;
laserHeadBody_mountSlotCentres = 23.5;
laserHeadBody_tubeOffsetZ = 15.5;
laserHeadBody_tubeOffsetX = laserHeadBody_notchWidth + (laserHeadBody_width - laserHeadBody_notchWidth)/2;
laserHeadBody_tubeOffsetY =  -14;  //  minimum offset
laserHeadBody_ingressRadius = 14/2;
laserHeadBody_ingressOffsetY = 60;  // centreline of ingress hole

laserHeadBody_mountSlotToTubeX = laserHeadBody_tubeOffsetX - (laserHeadBody_notchWidth)/2;
laserHeadBody_mountScrew1Y = laserHeadBody_mountSlotOffsetY + laserHeadBody_mountSlotHeight/2;
laserHeadBody_mountScrew2Y = laserHeadBody_mountScrew1Y + laserHeadBody_mountSlotCentres;

laserHeadFocusingTube_radius = 20/2;
laserHeadFocusingTube_height = 61;
laserHeadFocusingTube_LensHousingRadius = 27.5/2;
laserHeadFocusingTube_LensHousingHeight = 19;
laserHeadFocusingTube_tipRadius = 8.5/2;
laserHeadFocusingTube_tipHeight = 14.5;


module laserHeadFocusingTube() {
	r = laserHeadFocusingTube_radius;
	h = laserHeadFocusingTube_height;
	
	lhr = laserHeadFocusingTube_LensHousingRadius;
	lhh = laserHeadFocusingTube_LensHousingHeight;
	
	tr = laserHeadFocusingTube_tipRadius;
	th = laserHeadFocusingTube_tipHeight;
	
	color(grey20)
		render()
		union() {
			//upper tube
			cylinder(r=r, h=h);
		
			//lens housing
			translate([0,0,-lhh]) 
				cylinder(r=lhr, h=lhh);
			
			// tip
			translate([0,0,-lhh-th]) 
				cylinder(r1=tr, r2=lhr, h=th);
		}
}


module laserHeadBody() {
	// laser egress points down -y
	// casing positioned with bottom left at origin
	
	w = laserHeadBody_width;
	h = laserHeadBody_height;
	d = laserHeadBody_depth;
	pt = laserHeadBody_plateThickness;
	cs = laserHeadBody_chamferStart;
	nw = laserHeadBody_notchWidth;
	nh = laserHeadBody_notchHeight;
	nr = laserHeadBody_notchRadius;
	msw = laserHeadBody_mountSlotWidth;
	msh = laserHeadBody_mountSlotHeight;
	msoy = laserHeadBody_mountSlotOffsetY;
	msc = laserHeadBody_mountSlotCentres;
	
	r = laserHeadFocusingTube_radius;
	
	toz = laserHeadBody_tubeOffsetZ;
	toy = laserHeadBody_tubeOffsetY;
	tox = laserHeadBody_tubeOffsetX;
	
	ir = laserHeadBody_ingressRadius;
	ioy = laserHeadBody_ingressOffsetY;
	
	color(grey20)
		render()
		difference() {
			// body
			linear_extrude(d)
			difference() {
				polygon([[0,0],
						 [w,0],
						 [w,cs],
						 [w-(h-cs), h],
						 [0,h]]);
						 
				// mounting holes
				for (j=[0,1])
					translate([nw/2,msoy + msw/2 + j*msc,0])
					hull() {
						circle(msw/2);
						translate([0,msh-msw,0]) 
							circle(msw/2);
					}
						 
			}
						 
			// notch bottom
			translate([-1,-1,pt])
				cube([nw+1, nh-nr+1, h]);
			
			// notch top
			translate([-1,-1,pt+nr])
				cube([nw+1, nh+1, h]);
			
						 
			// notch radius
			translate([-1,nh-nr,pt+nr])
				rotate([0,90,0])
				cylinder(r=nr,h=nw+1);	
				
			// tube
			translate([tox,-1,toz])
				rotate([-90,0,0])
				cylinder(r=r, h=h+2);
				
			// laser ingress
			translate([-1,ioy,toz])
				rotate([0,90,0])
				cylinder(r=ir, h=w+2);
				
				
		}
	
	// vertical adjustment knob
	color(grey20)
		render() 
		translate([w,6,d-9])
		rotate([0,90,0])
		cylinder(r=15/2, h=10);
	
	
	// laserHeadFocusingTube
	translate([tox,toy,toz])
		rotate([-90,0,0])
		laserHeadFocusingTube();
}



module laserHead() {
	vitamin("laserHead:");
	
	laserHeadBody();
}