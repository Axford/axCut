//---------------------------------------------------------------
//-- Openscad Attachment library
//-- Attach parts easily. Make your designs more reusable and clean
//---------------------------------------------------------------
//-- This is a component of the obiscad opescad tools by Obijuan
//-- (C) Juan Gonzalez-Gomez (Obijuan)
//-- Sep-2012
//---------------------------------------------------------------
//-- Released under the GPL license
//---------------------------------------------------------------

use <vector.scad>

//--------------------------------------------------------------------
//-- Draw a connector
//-- A connector is defined a 3-tuple that consist of a point
//--- (the attachment point), and axis (the attachment axis) and
//--- an angle the connected part should be rotate around the 
//--  attachment axis
//--
//--- Input parameters:
//--
//--  Connector c = [p , v, ang] where:
//--
//--     p : The attachment point
//--     v : The attachment axis
//--   ang : the angle
//--------------------------------------------------------------------
module connector(c,clr="Gray")
{
  //-- Get the three components from the connector
  p = c[0];
  v = c[1];
  ang = c[2];

  //-- Draw the attachment poing
  color("Gray") point(p);

  //-- Draw the attachment axis vector (with a mark)
  
  translate(p)
    rotate(a=ang, v=v)
    color(clr) vector(unitv(v)*6, l_arrow=2, mark=true);
}


//-------------------------------------------------------------------------
//--  ATTACH OPERATOR
//--  This operator applies the necesary transformations to the 
//--  child (attachable part) so that it is attached to the main part
//--  
//--  Parameters
//--    a -> Connector of the main part
//--    b -> Connector of the attachable part
//-------------------------------------------------------------------------
module attach(a,b)
{
  //-- Get the data from the connectors
  pos1 = a[0];  //-- Attachment point. Main part
  v    = a[1];  //-- Attachment axis. Main part
  roll = a[2];  //-- Rolling angle
  
  pos2 = b[0];  //-- Attachment point. Attachable part
  vref = b[1];  //-- Atachment axis. Attachable part
                //-- The rolling angle of the attachable part is not used

  //-------- Calculations for the "orientate operator"------
  //-- Calculate the rotation axis
  //raxis = cross(vref,v);
  raxis = v[0]==vref[0] && v[1]==vref[1] ? [0,1,0] : cross(vref,v);
    
  //-- Calculate the angle between the vectors
  ang = anglev(vref,v);
  //--------------------------------------------------------.-

  //-- Apply the transformations to the child ---------------------------

  //-- Place the attachable part on the main part attachment point
  translate(pos1)
    //-- Orientate operator. Apply the orientation so that
    //-- both attachment axis are paralell. Also apply the roll angle
    rotate(a=roll, v=v)  rotate(a=ang, v=raxis)
      //-- Attachable part to the origin
      translate(-pos2)
	child(0); 
}



  




