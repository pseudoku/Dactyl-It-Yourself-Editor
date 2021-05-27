use <Switch.scad> //modules for switches and key holes generation
use <sweep.scad>
use <scad-utils/transformations.scad>
use <scad-utils/morphology.scad>
use <scad-utils/lists.scad>
use <scad-utils/shapes.scad>
use <scad-utils/trajectory.scad>
use <scad-utils/trajectory_path.scad>
use <skin.scad>
/*
//TODOs

* separate var for screw and thread insets
* consolidate functions and modules
* mcu/trrs/ locations and dim needs to be global and local
* cleaner framework for buildint enclosure???
* update major layouts to work with new build calls.

*/
module rotate(angle)            // built-in rotate is inaccurate for 90 degrees, etc
{
 a = len(angle) == undef ? [0, 0, angle] : angle;
 cx = cos(a[0]);
 cy = cos(a[1]);
 cz = cos(a[2]);
 sx = sin(a[0]);
 sy = sin(a[1]);
 sz = sin(a[2]);
 multmatrix([
  [ cy * cz, cz * sx * sy - cx * sz, cx * cz * sy + sx * sz, 0],
  [ cy * sz, cx * cz + sx * sy * sz,-cz * sx + cx * sy * sz, 0],
  [-sy,      cy * sx,                cx * cy,                0],
  [ 0,       0,                      0,                      1]
 ]) children();
}

//################ Main Builder ############################
module BuildTopPlate(Keyhole = false, Enclosure = true, Trackball = false, ThumbJoint = false, Border = false, PrettyBorder = false, ColoredSection = false,CustomBorder = false)
{
  //Submodules
  //TODO: change scope of submodules and remove duplicates now that calls are merged
  module modPlate (Hulls = true, thickBuff = 0, sides = TOP, refSides = BOTTOM, hullSides = [0,0,0], row, col){//shorthand

    if (SwitchOrientation[row][col] == true){
      PlaceRmCn(row, col)scale([CapScale[row][col],1,1])modulate(PlateDim,[0,sign(Clipped[row][col]), sides],PlateDim-[0,abs(Clipped[row][col]),-PBuffer-thickBuff], [0,-sign(Clipped[row][col]),refSides], Hull = Hulls, hullSide = hullSides);
    }
    else{
      PlaceRmCn(row, col)scale([1,CapScale[row][col],1])modulate(PlateDim,[sign(Clipped[row][col]), 0, sides], PlateDim-[abs(Clipped[row][col]),0,-PBuffer-thickBuff], [-sign(Clipped[row][col]), 0, refSides], Hull = Hulls, hullSide = hullSides);
    }
  }

  module modWeb (Hulls = true,  sides = 0, refSides = 0, hullSides = [0,0,0], row, col){
  if(SwitchOrientation[row][col] == true){
    PlaceRmCn(row, col)scale([CapScale[row][col],1,1])modulate(PlateDim+[0,-abs(Clipped[row][col])*2,PBuffer*2], [refSides,sides,TOP],PlateDim+[-WebThickness,-abs(Clipped[row][col]),PBuffer], [-refSides,-sides,BOTTOM], Hull = Hulls, hullSide = hullSides);
  }else {
    PlaceRmCn(row, col)scale([1,CapScale[row][col],1])modulate(PlateDim+[-abs(Clipped[row][col])*2,0,PBuffer*2], [refSides,sides,TOP],PlateDim+[-WebThickness,0,PBuffer], [-refSides,sides,BOTTOM], Hull = Hulls, hullSide = hullSides);
  }
  }
  //End of Submodules

  //Builds
  difference(){
    union(){
      rotate(tenting)translate([0,0,plateHeight]){//move plate to tent positions
        for (cols = colRange)BuildColumn(PlateDim[2]+PBuffer, 0, BOTTOM, col = cols, rowInit = RowInits[cols], rowEnd = RowEnds[cols]);
        //plate binding is done via layouts. most cases require custom config and generalization does not suffice. if it does than just use dactyl
        for (i=[0:len(PBind)-1])BindColums(TopAlignment = BOTTOM, BufferAlignment1 = PBind[i][1], BufferAlignment2 = PBind[i][2], cols= PBind[i][0]);
        for (i=[0:len(PlateCustomBind)-1]){
          hull(){
            for (j = [0:len(PlateCustomBind[i])-1]){
              modWeb(Hulls = true,  sides = PlateCustomBind[i][j][4], refSides = PlateCustomBind[i][j][2], hullSides = PlateCustomBind[i][j][3], row=PlateCustomBind[i][j][1], col=PlateCustomBind[i][j][0]);
            }
          }
        }

        //----- Borders
        PaintColor(ColoredSection){
          if (Border == true )BuildTopEnclosure(bBotScale = RScale); //for easier debugging
  //      if (PrettyBorder == true)BuildPrettyTransition(bBotScale = RScale); // it never worked well on edge cases which is 99% of my build
          if (CustomBorder == true){color("Crimson")BuildCustomBorder(struct = Sborder);}
          if (ThumbJoint == true)color("Salmon")BuildCustomBorder(struct = TCJoints);
          if (Trackball == true){
            color("Yellow")BuildTrackBorder(struct = TBborder);
            translate(trackOrigin)rotate(trackTilt)TrackBall();
          }
        }
      }
      //enclosure
      if(Enclosure == true)color("lightpink")BuildBottomEnclosure(struct = Eborder, Mount = true, JackType = "TRRS", MCUType = true);
    }//end build union
    //CUTS
    // Remove inter-columnar artifacts from borders and web joints
    BindTopCuts(Struct = TopCuts, height = 1);

    // Keyholes
    if(Keyhole == true)rotate(tenting)translate([0,0,plateHeight])BuildKeyWells(); //cuttting keywell and switch top to remove artifacts
    if (Trackball == true){
          translate(trackOrigin)rotate(trackTilt)sphere(d=trackR*2+1.25);  //cuts must be after building enclosures

/* TODOs track ball modules
//    translate(JackLoc+[0,0,0])rotate(JackAng+[0,0,0])translate([0,-4,0])cube([15.24,20.75,15], center= true); // additional cut
//    translate([0,0,-1])cube([150,150,2], center = true);
//    #rotate(tenting)translate([0,0,plateHeight])translate(trackOrigin)rotate(trackTilt)color("royalblue"){
//      sphere(d=trackR*2+1.25,$fn= 64);
//        //bearing holes
//      for(i= [0:1])rotate([0,50,120*i+30]){//upper bearing for tighter fit?
//        #translate([trackR+rbearing,0,0])sphere(r=rbearing);
//        #translate([trackR+rbearing-1,0,0])rotate([0,90,0])cylinder(r=rbearing,1);
//      }
//      for(i= [0:0])rotate([0,-30,180*i-90])translate([trackR+rbearing,0,0]){
//        #sphere(r=rbearing); //upper bearing for tighter fit?
//        #translate([-1,0,0])rotate([0,90,0])cylinder(r=rbearing,1);
//      }

//      translate(MCULoc+[0,-2.5,-7])cube([23.5,37.5,3],center=true);
//    }
//    translate(MCULoc+[-2.5,5-32.5/2,0])cylinder(d = 3, 30, center = true);
//}
//translate(JackLoc+[2.5,0,-6.5])cube([23,11,3],center=true);

//    #rotate(tenting)translate([0,0,plateHeight])translate(trackOrigin)rotate(trackTilt)rotate(SensorRot)translate([0,0,-38/2])PCB();
////  }


//     rotate(tenting)translate([0,0,plateHeight]){ BuildSet(capType = MX, capType = 1, colors = "ivory", stemcolor = "lightGreen",switchH = 0);} //(switchH = 0 for mx platethicknes 3.5, for -.75 for 2 )

//}
*/
    }

    if(Enclosure == true && BottomPlateCuts == true)BuildBottomPlate(struct = Eborder, hullList = Hstruct, Mount = false, JackType = false, MCUType = false); // cutout bottod plate outline to make them incertable

    //Tray Mount
      // big if
    //PCB mount
      // like-wise
  }
}

//----- Supporting Modules for Main Builder Modules

//----  functions
function hadamard (a, b) = (is_list(a)) ? (!(len(a) > 0) ? a*b : [ for (i = [0:len(a) - 1]) hadamard(a[i], b[i])]) :  a*b; // elementwise mult
function rowRange (col) = [RowInits[col]:RowEnds[col]]; // shorthand for row loop range

//cal global y position without considering rotation for quick condition check
function BRowYPos (i) = ColumnOrigin[i][0][1]+RowTrans[RowInits[i]][i];
function FRowYPos (i) = ColumnOrigin[i][0][1]+RowTrans[RowEnds[i]][i];
function FRowZPos (i) = ColumnOrigin[i][0][1]+Height[RowEnds[i]][i];

//----  Transformations and Modulating cube
module hullPlate (referenceDimensions = [0,0,0], offsets = [0,0,0], scalings = [1,1,1]) //Convenient notation for hulling a cube by face/edge/vertex
{
  hullDimension = [
    offsets[0] == 0 ?  scalings[0]*referenceDimensions[0]:HullThickness, // x
    offsets[1] == 0 ?  scalings[1]*referenceDimensions[1]:HullThickness, // y
    offsets[2] == 0 ?  scalings[2]*referenceDimensions[2]:HullThickness, // z
  ];

  translate(hadamard(referenceDimensions, offsets/2))translate(hadamard(hullDimension, -offsets/2))cube(hullDimension, center = true);
}

module modulate (referenceDimension = [0,0,0], referenceSide = [0,0,0], objectDimension = [0,0,0], objectSide = [0,0,0], Hull = false, hullSide = [0,0,0], scalings = [1,1,1]){//Convinient cube transferomation and hulling ref
  if(Hull == false){
    translate(hadamard(referenceDimension, referenceSide/2))
      translate(hadamard(hadamard(objectDimension,scalings),objectSide/2))
        scale(scalings)
          cube(objectDimension, center = true);
  }else{
    color("red")
      translate(hadamard(referenceDimension,referenceSide/2))
        translate(hadamard(hadamard(objectDimension,scalings), objectSide/2)) //TODO: scaled hull location issue may have something to do here
          hullPlate(objectDimension, hullSide, scalings);
  }
}

module PlaceColumnOrigin(Cn = C0) {
 if (Cn < T0) {// std construction
   rotate(ColumnOrigin[Cn][1])
    translate(ColumnOrigin[Cn][0])
      rotate([90,0,0])
        mirror([0,1,0])
          rotate(ColumnOrigin[Cn][2])
            children();
 }else if (Cn >= T0) { //additional Global thumb cluster jog
    rotate(ThumbShift[1])
      translate(ThumbShift[0])
        rotate(ColumnOrigin[Cn][1])
          translate(ColumnOrigin[Cn][0])
            rotate([90,0,0])
              mirror([0,1,0])
                rotate(ColumnOrigin[Cn][2])
                  children();
 }
}

//place child object on the target position with all transforms
module PlaceRmCn(row, col) {
  PlaceColumnOrigin(col)
    translate([RowTrans[row][col],Height[row][col]+PlateThickness/2,ColTrans[row][col]])
      rotate([90,90,Pitch[row][col]])
        rotate([0,Roll[row][col],0])
          children();
}


//--- Building Modules
module BuildColumn (plateThickness, offsets, sides =TOP, col=0, rowInit = R0, rowEnd = R0, offset2 = 0, adjust = 0){//generate switch plates and hull in between between per column
  refDim   = PlateDim +[0,0,offsets];
  buildDim = [PlateDim[0]-offset2, PlateDim[1], plateThickness];

  //TODO: Refactor all modplate type calls
  module modPlateLen (Hulls = true, hullSides = [0,0,0], rows, cols){//shorthand call for length-wise clipping
    modulate(refDim,[adjust,sign(Clipped[rows][cols]),TOP], buildDim-[0,abs(Clipped[rows][cols]),0], [0,-sign(Clipped[rows][cols]),sides], Hull = Hulls, hullSide = hullSides);
    //use clip length sign to direct transform sides and adjust platle length rather than if else statement for more compact call
  }

  module modPlateWid (Hulls = true, hullSides = [0,0,0], rows, cols){//shorthand call for Width-wise clipping
    modulate(refDim,[sign(Clipped[rows][cols]), 0, TOP], buildDim-[abs(Clipped[rows][cols]),0,0], [-sign(Clipped[rows][cols]), 0,sides], Hull = Hulls, hullSide = hullSides);
  }

  //
  for (row = [rowInit:rowEnd]){//build plate
    if (SwitchOrientation[row][col] == true){ //for length-wise Clip
      PlaceRmCn(row, col)scale([CapScale[row][col],1,1])modPlateLen(Hulls = false, rows =row, cols = col);
      if (row < rowEnd){//Support struct in between rows
        hull(){
          PlaceRmCn(row, col)scale([CapScale[row][col],1,1])modPlateLen(Hulls = true, hullSides = [0,FRONT,0], rows = row, cols = col);
          if(SwitchOrientation[row+1][col] == true){
            PlaceRmCn(row+1, col)scale([CapScale[row+1][col],1,1])modPlateLen(Hulls = true, hullSides = [0,BACK,0], rows = row+1, cols = col);
          }else {
            PlaceRmCn(row+1, col)scale([1,CapScale[row+1][col],1])modPlateWid(Hulls = true, hullSides = [0,BACK,0], rows = row+1, cols = col);
          }
        }
      }
    }else { // for Width-wise Clip
      PlaceRmCn(row, col)scale([1,CapScale[row][col],1])modPlateWid(Hulls = false, rows =row, cols = col);
      if (row < rowEnd){//Support struct
        hull(){
          PlaceRmCn(row, col)scale([1,CapScale[row][col],1])modPlateWid(Hulls = true, hullSides = [0,FRONT,0], rows = row, cols = col);
          if(SwitchOrientation[row+1][col] == true){
            PlaceRmCn(row+1, col)scale([CapScale[row+1][col],1,1])modPlateLen(Hulls = true, hullSides = [0,BACK,0], rows = row+1, cols = col);
          }else {
            PlaceRmCn(row+1, col)scale([1,CapScale[row+1][col],1])modPlateWid(Hulls = true, hullSides = [0,BACK,0], rows = row+1, cols = col);
          }
        }
      }
    }
  }
}

module BindColums (TopAlignment =TOP, BufferAlignment1 = 0,  BufferAlignment2 = 0, cols=0, plateThickness = PlateDim[2], offsets = 0){//Build support structure between columns, Buffers side option to aligne hull surface
  refDim   = PlateDim +[0,0,offsets];
  buildDim = [PlateDim[0], PlateDim[1], plateThickness];

  function Sides(r, c)  = SwitchOrientation[r][c]?-sign(Clipped[r][c]):0;
  function SideMod(r,c, refsides) = (!SwitchOrientation[r][c] && refsides == sign(Clipped[r][c]))?0:1;

  module modWeb (Hulls = true,  sides = 0, refSides = 0, hullSides = [0,0,0], row, col){
    if(SwitchOrientation[row][col] == true){
      PlaceRmCn(row, col)scale([CapScale[row][col],1,1])modulate(refDim+[0,-abs(Clipped[row][col])*2,PBuffer*2], [refSides,sides,TOP],buildDim+[-WebThickness,-abs(Clipped[row][col]),PBuffer], [-refSides,-sides,TopAlignment], Hull = Hulls, hullSide = hullSides);
    }else {
      PlaceRmCn(row, col)scale([1,CapScale[row][col],1])modulate(refDim+[-abs(Clipped[row][col])*2*SideMod(row,col, refSides),0,PBuffer*2], [refSides,sides,TOP],buildDim+[-WebThickness,0,PBuffer], [-refSides,sides,TopAlignment], Hull = Hulls, hullSide = hullSides);
    }
  }

  //build start
  if (cols != CEnd && cols != TEnd){//Hull Between Columns TODO: Modulize
    for(rows = [max(RowInits[cols],RowInits[cols+1]):min(RowEnds[cols],RowEnds[cols+1])]){//build only nearest
      hull(){
        modWeb(true, sides = Sides(rows,cols), refSides = RIGHT, hullSides = [BufferAlignment1,0,0], row = rows, col = cols);
        modWeb(true, sides = Sides(rows,cols+1), refSides = LEFT,  hullSides = [BufferAlignment2,0,0], row = rows, col = cols+1);
      }
    }
    //between corners
    for(rows = [max(RowInits[cols],RowInits[cols+1]):min(RowEnds[cols],RowEnds[cols+1])]){
      if (rows != min(RowEnds[cols],RowEnds[cols+1])){
        hull(){
          modWeb(true, sides = Sides(rows,cols),     refSides = RIGHT, hullSides = [BufferAlignment1,FRONT,0],  row = rows,   col =   cols);
          modWeb(true, sides = Sides(rows,cols+1),   refSides = LEFT,  hullSides = [BufferAlignment2,FRONT,0], row = rows,   col = cols+1);
          modWeb(true, sides = Sides(rows+1,cols),   refSides = RIGHT, hullSides = [BufferAlignment1,BACK,0],   row = rows+1, col =   cols);
          modWeb(true, sides = Sides(rows+1,cols+1), refSides = LEFT,  hullSides = [BufferAlignment2,BACK,0],  row = rows+1, col = cols+1);
        }
      }
    }
    //Condition for non-matched rowInits
    if (RowInits[cols]>RowInits[cols+1]){
      hull(){
        modWeb(true, sides = Sides(RowInits[cols],cols),     refSides = LEFT,  hullSides = [BufferAlignment1,BACK,0],   row = RowInits[cols],   col = cols);
        modWeb(true, sides = Sides(RowInits[cols],cols),     refSides = RIGHT, hullSides = [BufferAlignment1,BACK,0],   row = RowInits[cols],   col = cols);
        modWeb(true, sides = Sides(RowInits[cols+1],cols+1), refSides = LEFT,  hullSides = [BufferAlignment2,BACK,0], row = RowInits[cols+1], col = cols+1);
      }
      hull(){
        modWeb(true, sides = Sides(RowInits[cols],cols),     refSides = RIGHT, hullSides = [BufferAlignment1,BACK,0],   row = RowInits[cols],   col = cols);
        modWeb(true, sides = Sides(RowInits[cols+1],cols+1), refSides = LEFT,  hullSides = [BufferAlignment2,BACK,0], row = RowInits[cols+1],   col = cols+1);
        modWeb(true, sides = Sides(RowInits[cols+1]+1,cols+1),refSides = LEFT,  hullSides = [BufferAlignment2,BACK,0], row = RowInits[cols+1]+1, col = cols+1);
      }

    }
    if (RowInits[cols]<RowInits[cols+1]){
      hull(){
        modWeb(true, sides = Sides(RowInits[cols],cols),     refSides = RIGHT, hullSides = [BufferAlignment1,0,0],     row = RowInits[cols],   col =   cols);
        modWeb(true, sides = Sides(RowInits[cols+1],cols+1), refSides = LEFT,  hullSides = [-BufferAlignment2,BACK,0], row = RowInits[cols+1], col = cols+1);
      }
    }
  }
}


module BindTopCuts(Struct = TopCuts, height = 0) {
  plateThickness = PlateDim[2]+PBuffer+height;
  offsets = 0;
  sides = TOP;
  refDim   = PlateDim +[0,0,offsets];
  buildDim = [PlateDim[0], PlateDim[1], plateThickness];

  //TODO: Refactor all modplate type calls
  module modPlateLen (Hulls = true, hullSides = [0,0,0], rows, cols){//shorthand call for length-wise clipping
    modulate(refDim,[0,sign(Clipped[rows][cols]),TOP], buildDim-[0,abs(Clipped[rows][cols]),0], [0,-sign(Clipped[rows][cols]),sides], Hull = Hulls, hullSide = hullSides);
    //use clip length sign to direct transform sides and adjust platle length rather than if else statement for more compact call
  }

  module modPlateWid (Hulls = true, hullSides = [0,0,0], rows, cols){//shorthand call for Width-wise clipping
    modulate(refDim,[sign(Clipped[rows][cols]), 0, TOP], buildDim-[abs(Clipped[rows][cols]),0,0], [-sign(Clipped[rows][cols]), 0,sides], Hull = Hulls, hullSide = hullSides);
  }
  for (i = [0:len(Struct)-1]){
    hull(){
      if(SwitchOrientation[Struct[i][1]][Struct[i][0]] == true){
        PlaceRmCn(Struct[i][1], Struct[i][0])scale([CapScale[Struct[i][1]][Struct[i][0]],1,1])modPlateLen(Hulls = true, hullSides = Struct[i][2], rows = Struct[i][1], cols = Struct[i][0]);
      }else {
        PlaceRmCn(Struct[i][1], Struct[i][0])scale([1,CapScale[Struct[i][1]][Struct[i][0]],1])modPlateWid(Hulls = true, hullSides = Struct[i][2], rows = Struct[i][1], cols = Struct[i][0]);
      }
      if(SwitchOrientation[Struct[i][3]][Struct[i][2]] == true){
        PlaceRmCn(Struct[i][4], Struct[i][3])scale([CapScale[Struct[i][4]][Struct[i][3]],1,1])modPlateLen(Hulls = true, hullSides = Struct[i][5], rows = Struct[i][4], cols = Struct[i][3]);
      }else {
        PlaceRmCn(Struct[i][4], Struct[i][3])scale([1,CapScale[Struct[i][4]][Struct[i][3]],1])modPlateWid(Hulls = true, hullSides = Struct[i][5], rows = Struct[i][4], cols = Struct[i][3]);
      }
    }
  }
} //to emulate ergowarp webcuts
//hadamard(PlateDim,[CapScale[rows][cols],1,1])
//SUPPLYMENTAL
//Modulate shorthand for building Length-Wise hulls for Borders
module modBorderLen(Hulls = false, sides = 0, refSides = 0, dimClip = 0, refClip = 0, height = 6, hullSides = [0,0,0], rows, cols, scaling = [1,1,1]){

  if (SwitchOrientation[rows][cols] == true){ // no need to scale
    //TOP
    PlaceRmCn(rows, cols)scale([CapScale[rows][cols],1,1])modulate(PlateDim+[0,-refClip*2,PBuffer*2], [refSides,sides, BorderAlign ],PlateDim+[-dimClip,-Bthickness,height], [-refSides,sides,-BorderAlign ], Hull = Hulls, hullSide = [hullSides[0],hullSides[1],TOP], scalings = [1,1,1]);
    //BOTTOM
    PlaceRmCn(rows, cols)scale([CapScale[rows][cols],1,1])modulate(PlateDim+[0,-refClip*2,PBuffer*2], [refSides,sides, BorderAlign ],PlateDim+[-dimClip,-Bthickness,height], [-refSides,sides,-BorderAlign ], Hull = Hulls, hullSide = [hullSides[0],hullSides[1],BOTTOM], scalings = scaling);
  } else { // scale
    //TOP
    PlaceRmCn(rows, cols)modulate(hadamard(PlateDim,[1,CapScale[rows][cols],1])+[0,-refClip*0,PBuffer*2], [refSides,sides, BorderAlign ],PlateDim+[-dimClip,-Bthickness,height], [-refSides,sides,-BorderAlign ], Hull = Hulls, hullSide = [hullSides[0],hullSides[1],TOP], scalings = [1,1,1]);
    //BOTTOM
    PlaceRmCn(rows, cols)modulate(hadamard(PlateDim,[1,CapScale[rows][cols],1])+[0,-refClip*0,PBuffer*2], [refSides,sides, BorderAlign ],PlateDim+[-dimClip,-Bthickness,height], [-refSides,sides,-BorderAlign ], Hull = Hulls, hullSide = [hullSides[0],hullSides[1],BOTTOM], scalings = scaling);
  }
}

//Modulate shorthand for building Width-Wise hulls for Borders
module modBorderWid(Hulls = false, sides = 0, refSides = 0, dimClip = 0, refClip = 0, height = 6, hullSides = [0,0,0], rows, cols, scaling = [1,1,1]){
  if (SwitchOrientation[rows][cols] == true){ //no need to scale cap size
    //TOP
    PlaceRmCn(rows, cols)modulate(hadamard(PlateDim,[CapScale[rows][cols],1,1])+[-refClip*2,0,PBuffer*2], [refSides,sides, BorderAlign ],PlateDim+[-Bthickness,-dimClip,height], [refSides,-sides,-BorderAlign], Hull = Hulls, hullSide = [hullSides[0],hullSides[1],TOP], scalings = [1,1,1]);
    //BOTTOM
    PlaceRmCn(rows, cols)modulate(hadamard(PlateDim,[CapScale[rows][cols],1,1])+[-refClip*2,0,PBuffer*2], [refSides,sides, BorderAlign],PlateDim+[-Bthickness,-dimClip,height], [refSides,-sides,-BorderAlign], Hull = Hulls, hullSide = [hullSides[0],hullSides[1],BOTTOM], scalings = scaling);
  } else { //scale to cap size
    PlaceRmCn(rows, cols)scale([1,CapScale[rows][cols],1])modulate(PlateDim+[-refClip*2,0,PBuffer*2], [refSides,sides, BorderAlign ],PlateDim+[-Bthickness,-dimClip,height], [refSides,-sides,-BorderAlign], Hull = Hulls, hullSide = [hullSides[0],hullSides[1],TOP], scalings = [1,1,1]);
    //BOTTOM
    PlaceRmCn(rows, cols)scale([1,CapScale[rows][cols],1])modulate(PlateDim+[-refClip*2,0,PBuffer*2], [refSides,sides, BorderAlign ],PlateDim+[-Bthickness,-dimClip,height], [refSides,-sides,-BorderAlign], Hull = Hulls, hullSide = [hullSides[0],hullSides[1],BOTTOM], scalings = scaling);}
}


module modBottomLen(Hulls = false, sides = 0, refSides = 0, dimClip = 0, refClip = 0, height = 6, hullSides = [0,0,0], rows, cols, scaling = [1,1,1]){

  if (SwitchOrientation[rows][cols] == true){ // no need to scale
    //BOTTOM
    PlaceRmCn(rows, cols)scale([CapScale[rows][cols],1,1])modulate(PlateDim+[0,-refClip*2,PBuffer*2], [refSides,sides, BorderAlign ],PlateDim+[-dimClip,-Bthickness,height], [-refSides,sides,-BorderAlign ], Hull = Hulls, hullSide = [hullSides[0],hullSides[1],BOTTOM], scalings = scaling);
  } else { // scale
    //BOTTOM
    PlaceRmCn(rows, cols)modulate(hadamard(PlateDim,[1,CapScale[rows][cols],1])+[0,-refClip*0,PBuffer*2], [refSides,sides, BorderAlign ],PlateDim+[-dimClip,-Bthickness,height], [-refSides,sides,-BorderAlign ], Hull = Hulls, hullSide = [hullSides[0],hullSides[1],BOTTOM], scalings = scaling);
  }
}

//Modulate shorthand for building Width-Wise hulls for Borders
module modBottomWid(Hulls = false, sides = 0, refSides = 0, dimClip = 0, refClip = 0, height = 6, hullSides = [0,0,0], rows, cols, scaling = [1,1,1]){
  if (SwitchOrientation[rows][cols] == true){ //no need to scale cap size
    //BOTTOM
    PlaceRmCn(rows, cols)modulate(hadamard(PlateDim,[CapScale[rows][cols],1,1])+[-refClip*2,0,PBuffer*2], [refSides,sides, BorderAlign],PlateDim+[-Bthickness,-dimClip,height], [refSides,-sides,-BorderAlign], Hull = Hulls, hullSide = [hullSides[0],hullSides[1],BOTTOM], scalings = scaling);
  } else { //scale to cap size
    //BOTTOM
    PlaceRmCn(rows, cols)scale([1,CapScale[rows][cols],1])modulate(PlateDim+[-refClip*2,0,PBuffer*2], [refSides,sides, BorderAlign ],PlateDim+[-Bthickness,-dimClip,height], [refSides,-sides,-BorderAlign], Hull = Hulls, hullSide = [hullSides[0],hullSides[1],BOTTOM], scalings = scaling);}
}


module buildCorner(row = R0, col = C0, side1 = FRONT, side2 = LEFT, BHeight = BBackHeight, bBotScale = RScale){
  hull(){
    modBorderWid(true,     0, side2, 0, xLenM*abs(sign(Clipped[row][col])), BHeight, [0,side1,0], row, col, [bBotScale,1,1]);
    modBorderLen(true, side1,     0, 0, xLenM*abs(sign(Clipped[row][col])), BHeight, [side2,0,0], row, col, [1,bBotScale,1]);
  }
}

module BuildAdditionaltEdge(struct = Lborder, sides = LEFT, bBotScale = RScale){ //use border struc to biuld Left Edge
//depriciated
}

module BuildCustomBorder(struct = Sborder){// use Sborder struc to build hull.
  function Col(n,m) = struct[n][m][0];
  function Row(n,m) = struct[n][m][1];
  function LenCheck(i,j) = SwitchOrientation[Row(i,j)][Col(i,j)]?0:abs(Clipped[Row(i,j)][Col(i,j)]);
  function WidCheck(i,j) = !SwitchOrientation[Row(i,j)][Col(i,j)]?0:abs(Clipped[Row(i,j)][Col(i,j)]);
  function LenSides(i,j) = SwitchOrientation[Row(i,j)][Col(i,j)]?0:sign(Clipped[Row(i,j)][Col(i,j)]);
  function WidSides(i,j) = !SwitchOrientation[Row(i,j)][Col(i,j)]?0:sign(Clipped[Row(i,j)][Col(i,j)]);
  function SideMod(i,j) = (SwitchOrientation[Row(i,j)][Col(i,j)] && struct[i][j][3] == sign(Clipped[Row(i,j)][Col(i,j)]))?0:1;
  function SideMod2(i,j) = (SwitchOrientation[Row(i,j)][Col(i,j)] || struct[i][j][3] == sign(Clipped[Row(i,j)][Col(i,j)]))?0:1;
  function HeightCheck(n,m) = Col(n,m)>C7?TBackHeight:BBackHeight;

  for (i = [0:len(struct)-1]){
    hull(){
      //[Col, Row, len = true, Jog direction, HullFace, Scale],
      for (j = [0:len(struct[i])-1]){
        if (struct[i][j][2] == true){
          modBorderWid(true, WidSides(i,j), struct[i][j][3], WidCheck(i,j), xLenM*abs(sign(Clipped[Row(i,j)][Col(i,j)]))*SideMod2(i,j),  HeightCheck(i,j), [struct[i][j][4][0],struct[i][j][4][1],0], Row(i,j), Col(i,j), struct[i][j][5]);
        } else {
          modBorderLen(true, struct[i][j][3], LenSides(i,j), LenCheck(i,j), xLenM*abs(sign(Clipped[Row(i,j)][Col(i,j)]))*SideMod(i,j),  HeightCheck(i,j), [struct[i][j][4][0],struct[i][j][4][1],0], Row(i,j), Col(i,j), struct[i][j][5]);
        }
      }
    }
  }
}

module BuildTrackBorder(struct = TBborder){// use Sborder struc to build hull.
  function Col(n,m) =struct[n][0][m][0];
  function Row(n,m) =struct[n][0][m][1];
  function LenCheck(i,j) = SwitchOrientation[Row(i,j)][Col(i,j)]?0:abs(Clipped[Row(i,j)][Col(i,j)]);
  function WidCheck(i,j) = !SwitchOrientation[Row(i,j)][Col(i,j)]?0:abs(Clipped[Row(i,j)][Col(i,j)]);
  function LenSides(i,j) = SwitchOrientation[Row(i,j)][Col(i,j)]?0:sign(Clipped[Row(i,j)][Col(i,j)]);
  function WidSides(i,j) = !SwitchOrientation[Row(i,j)][Col(i,j)]?0:sign(Clipped[Row(i,j)][Col(i,j)]);
  function SideMod(i,j)  = (SwitchOrientation[Row(i,j)][Col(i,j)] && struct[i][0][j][3] == sign(Clipped[Row(i,j)][Col(i,j)]))?0:1;
  function SideMod2(i,j) = (SwitchOrientation[Row(i,j)][Col(i,j)] || struct[i][0][j][3] == sign(Clipped[Row(i,j)][Col(i,j)]))?0:1;

  for (i = [0:len(struct)-1]){
    hull(){
      //[Col, Row, len = true, Jog direction, HullFace, Scale],
      for (j = [0:len(struct[i])-1]){
        if (struct[i][0][j][2] == true){
          modBorderWid(
            true,
            WidSides(i,j),
            struct[i][0][j][3],
            WidCheck(i,j),
            xLenM*abs(sign(Clipped[Row(i,j)][Col(i,j)]))*SideMod2(i,j),
            BBackHeight,
            [struct[i][0][j][4][0],struct[i][0][j][4][1],0],
            Row(i,j),
            Col(i,j),
            struct[i][0][j][5]
          );
        } else {
          modBorderLen(
            true,
            struct[i][0][j][3],
            LenSides(i,j), LenCheck(i,j),
            xLenM*abs(sign(Clipped[Row(i,j)][Col(i,j)]))*SideMod(i,j),
            BBackHeight,
            [struct[i][0][j][4][0],struct[i][0][j][4][1],0],
            Row(i,j),
            Col(i,j),
            struct[i][0][j][5]
          );
        }
      }
      //build a modulation of pcb casing
      translate(trackOrigin)rotate(trackTilt)rotate(SensorRot)translate([0,0,-21])hull(){
        modulate(PCBCaseDim-[0,0,0], [0,0,TOP],PCBCaseDim-[0,0,0], [0,0,TOP], Hull = true, hullSide = struct[i][1]);
        modulate(PCBCaseDim-[0,0,0], [0,0,TOP],PCBCaseDim-[0,0,0], [0,0,TOP], Hull = true, hullSide = .9*struct[i][1]);
      }
    }
  }
}


//Generate basic borders by loop to separate generic border and pretty border calls.
module BuildTopEnclosure(bBotScale = RScale){
  //generic width wise border
  for (cols = colRange){
    hull(){modBorderLen(true,  BACK, 0, 0, xLenM*abs(sign(Clipped[RowInits[cols]][cols])), BBackHeight, [0,0,0], RowInits[cols], cols, [1,bBotScale,1]);} //generic BACK
    hull(){modBorderLen(true, FRONT, 0, 0, xLenM*abs(sign(Clipped[RowEnds[cols]][cols])), BFrontHeight, [0,0,0], RowEnds[cols], cols, [1,bBotScale,1]);} //generic FRONT
    //Generic Left and Right Boarder

    if (cols == CStart || cols == TStart){//Initial Columns
      buildCorner(row = RowInits[cols], col = cols, side1 = BACK, side2 = LEFT, BHeight = BBackHeight, bBotScale = RScale); //Bottom Right row corner
      for (rows = rowRange(cols)){//
        //LEFT
        if(rows != RowEnds[cols]){
          hull(){modBorderWid(true,     0, LEFT, 0, xLenM*abs(sign(Clipped[rows][cols])), BBackHeight, [0,0,0], rows, cols, [bBotScale,1,1]);}
          hull(){// Between Rows
            modBorderWid(true, 0, LEFT, 0, xLenM*abs(sign(Clipped[rows][cols])), BBackHeight, [0,FRONT,0],   rows, cols, [bBotScale,1,1]);
            modBorderWid(true, 0, LEFT, 0, xLenM*abs(sign(Clipped[rows+1][cols])), BBackHeight,  [0,BACK,0], rows+1, cols, [bBotScale,1,1]);
          }
        } else {
          hull(){ //Boarder Height transition
            modBorderWid(true,     0, LEFT, 0, xLenM*abs(sign(Clipped[rows][cols])), BFrontHeight, [0,FRONT,0], rows, cols, [bBotScale,1,1]);
            modBorderWid(true,     0, LEFT, 0, xLenM*abs(sign(Clipped[rows][cols])),  BBackHeight, [0,BACK,0],  rows, cols, [bBotScale,1,1]);
          }
          buildCorner(row = rows, col = cols, side1 = FRONT, side2 = LEFT, BHeight = BFrontHeight, bBotScale = RScale); //Bottom Right row corner
        }
        if (len(search(rows, [for( i =rowRange(cols+1)) i])) == 0){//next Col  No Match
          if (rows == RowInits[cols]){
            buildCorner(row = rows, col = cols, side1 = BACK, side2 = RIGHT, BHeight = BBackHeight, bBotScale = RScale); //Bottom Right row corner
          }
          if (rows != RowEnds[cols]){
            hull(){modBorderWid(true,     0, RIGHT, 0, xLenM*abs(sign(Clipped[rows][cols])), BBackHeight, [0,0,0], rows, cols, [bBotScale,1,1]);}
            if (len(search(rows+1, [for( i =rowRange(cols+1)) i])) == 0){ //check next row to build bridging hull
              hull(){
                modBorderWid(true,     0, RIGHT, 0, xLenM*abs(sign(Clipped[rows][cols])), BBackHeight, [0,FRONT,0], rows,   cols, [bBotScale,1,1]);
                modBorderWid(true,     0, RIGHT, 0, xLenM*abs(sign(Clipped[rows+1][cols])), BBackHeight,  [0,BACK,0], rows+1, cols, [bBotScale,1,1]);
              }
            }
          } else {
            hull(){//top height transition hull
              modBorderWid(true,     0, RIGHT, 0, xLenM*abs(sign(Clipped[rows][cols])), BFrontHeight, [0,FRONT,0], rows, cols, [bBotScale,1,1]);
              modBorderWid(true,     0, RIGHT, 0, xLenM*abs(sign(Clipped[rows][cols])),  BBackHeight,  [0,BACK,0], rows, cols, [bBotScale,1,1]);
            }
            buildCorner(row = rows, col = cols, side1 = FRONT, side2 = RIGHT, BHeight = BFrontHeight, bBotScale = RScale); //Bottom Right row corner
          }
        }
      }
    }
    //Final Columns
    else if (cols == CEnd || cols == TEnd){
      buildCorner(row = RowInits[cols], col = cols, side1 = BACK, side2 = RIGHT, BHeight = BBackHeight, bBotScale = RScale); //Bottom Right row corner
      for (rows = rowRange(cols)){
          //LEFTs
          if (len(search(rows, [for( i =rowRange(cols-1)) i])) == 0){//RIGHT NO Match
          if (rows == RowInits[cols]){
            buildCorner(row = rows, col = cols, side1 = BACK, side2 = LEFT, BHeight = BBackHeight, bBotScale = RScale); //Bottom Right row corner
          }
          if (rows != RowEnds[cols]){
            hull(){modBorderWid(true,     0, LEFT, 0, xLenM*abs(sign(Clipped[rows][cols])), BBackHeight, [0,0,0], rows, cols, [bBotScale,1,1]);}
            if (len(search(rows+1, [for (i = rowRange(cols-1)) i])) == 0){ //check next row to build bridging hull
              hull(){
                modBorderWid(true,     0, LEFT, 0, xLenM*abs(sign(Clipped[rows][cols])), BBackHeight, [0,FRONT,0], rows,   cols, [bBotScale,1,1]);
                modBorderWid(true,     0, LEFT, 0, xLenM*abs(sign(Clipped[rows+1][cols])), BBackHeight,  [0,BACK,0], rows+1, cols, [bBotScale,1,1]);
              }
            }
          } else {
            hull(){//top height transition hull
              modBorderWid(true,     0, LEFT, 0, xLenM*abs(sign(Clipped[rows][cols])), BFrontHeight, [0,FRONT,0], rows,   cols, [bBotScale,1,1]);
              modBorderWid(true,     0, LEFT, 0, xLenM*abs(sign(Clipped[rows][cols])), BBackHeight,  [0,BACK,0], rows, cols, [bBotScale,1,1]);
            }
            buildCorner(row = rows, col = cols, side1 = FRONT, side2 = LEFT, BHeight = BFrontHeight, bBotScale = RScale); //Bottom Right row corner
          }
        }
        //RIGHTs
        if(rows != RowEnds[cols]){
          hull(){modBorderWid(true,     0, RIGHT, 0, xLenM*abs(sign(Clipped[rows][cols])), BBackHeight, [0,0,0], rows, cols, [bBotScale,1,1]);}
          hull(){// Between Rows
            modBorderWid(true, 0, RIGHT, 0, xLenM*abs(sign(Clipped[rows][cols])), BBackHeight, [0,FRONT,0],   rows, cols, [bBotScale,1,1]);
            modBorderWid(true, 0, RIGHT, 0, xLenM*abs(sign(Clipped[rows+1][cols])), BBackHeight,  [0,BACK,0], rows+1, cols, [bBotScale,1,1]);
          }
        } else {
          hull(){ //Boarder Height transition
            modBorderWid(true,     0, RIGHT, 0, xLenM*abs(sign(Clipped[rows][cols])), BFrontHeight, [0,FRONT,0], rows, cols, [bBotScale,1,1]);
            modBorderWid(true,     0, RIGHT, 0, xLenM*abs(sign(Clipped[rows][cols])),  BBackHeight, [0,BACK,0],  rows, cols, [bBotScale,1,1]);
          }
          buildCorner(row = rows, col = cols, side1 = FRONT, side2 = RIGHT, BHeight = BFrontHeight, bBotScale = RScale); //Bottom Right row corner
        }
      }
    }
    // Rest of Columns
    else {//check for non matching adjacent rows
      for (rows = rowRange(cols)){
         //LEFT
        if (len(search(rows, [for( i =rowRange(cols-1)) i])) == 0){//RIGHT NO Match
          if (rows == RowInits[cols]){
            buildCorner(row = rows, col = cols, side1 = BACK, side2 = LEFT, BHeight = BBackHeight, bBotScale = RScale); //Bottom Right row corner
          }
          if (rows != RowEnds[cols]){
            hull(){modBorderWid(true,     0, LEFT, 0, xLenM*abs(sign(Clipped[rows][cols])), BBackHeight, [0,0,0], rows, cols, [bBotScale,1,1]);}
            if (len(search(rows+1, [for (i = rowRange(cols-1)) i])) == 0){ //check next row to build bridging hull
              hull(){
                modBorderWid(true,     0, LEFT, 0, xLenM*abs(sign(Clipped[rows][cols])), BBackHeight, [0,FRONT,0], rows,   cols, [bBotScale,1,1]);
                modBorderWid(true,     0, LEFT, 0, xLenM*abs(sign(Clipped[rows+1][cols])), BBackHeight,  [0,BACK,0], rows+1, cols, [bBotScale,1,1]);
              }
            }
          } else {
            hull(){//top height transition hull
              modBorderWid(true,     0, LEFT, 0, xLenM*abs(sign(Clipped[rows][cols])), BFrontHeight, [0,FRONT,0], rows, cols, [bBotScale,1,1]);
              modBorderWid(true,     0, LEFT, 0, xLenM*abs(sign(Clipped[rows][cols])), BBackHeight,   [0,BACK,0], rows, cols, [bBotScale,1,1]);
            }
            buildCorner(row = rows, col = cols, side1 = FRONT, side2 = LEFT, BHeight = BFrontHeight, bBotScale = RScale); //Bottom Right row corner
          }
        }
        //RIGHT
        if (len(search(rows, [for (i = rowRange(cols+1)) i])) == 0){//RIGHT NO Match
          if (rows == RowInits[cols]){
            buildCorner(row = rows, col = cols, side1 = BACK, side2 = RIGHT, BHeight = BBackHeight, bBotScale = RScale); //Bottom Right row corner
          }
          if (rows != RowEnds[cols]){
            hull(){modBorderWid(true,     0, RIGHT, 0, xLenM*abs(sign(Clipped[rows][cols])), BBackHeight, [0,0,0], rows, cols, [bBotScale,1,1]);}
            if (len(search(rows+1, [for (i = rowRange(cols+1)) i])) == 0){ //check next row to build bridging hull
              hull(){
                modBorderWid(true,     0, RIGHT, 0, xLenM*abs(sign(Clipped[rows][cols])),   BBackHeight, [0,FRONT,0],  rows,  cols, [bBotScale,1,1]);
                modBorderWid(true,     0, RIGHT, 0, xLenM*abs(sign(Clipped[rows+1][cols])), BBackHeight,  [0,BACK,0], rows+1, cols, [bBotScale,1,1]);
              }
            }
          } else {
            hull(){//top height transition hull
              modBorderWid(true,     0, RIGHT, 0, xLenM*abs(sign(Clipped[rows][cols])), BFrontHeight, [0,FRONT,0], rows, cols, [bBotScale,1,1]);
              modBorderWid(true,     0, RIGHT, 0, xLenM*abs(sign(Clipped[rows][cols])), BBackHeight,   [0,BACK,0], rows, cols, [bBotScale,1,1]);
            }
            buildCorner(row = rows, col = cols, side1 = FRONT, side2 = RIGHT, BHeight = BFrontHeight, bBotScale = RScale); //Bottom Right row corner
          }
        }
      }
    }
  }
}

//--- Rule based Pretty border
module BuildPrettyTransition(bBotScale = RScale, BackCase_1Limit = -unit/4, BackCase_2Limit = unit/4 , FrontCase_1Limit = unit/4, FrontCase_2Limit = unit/4, FrontCase_3Limit, DipConditionLimit = unit/6, TransitionHeightLimit = 10){
// deprciated as it only works in simple cases, which typically is not the case
}

//support module to build bottom enclosure.
module hullEnclusure (){
  hull(){
    rotate(tenting)translate([0,0,plateHeight])hull(){
      children([0:$children-1]);
    }
    linear_extrude(1)projection()rotate(tenting)translate([0,0,plateHeight])hull(){
      children([0:$children-1]);
    }
  }
}

module transEnclose (){
  rotate(tenting)translate([0,0,plateHeight]){
      children([0:$children-1]);
  }
}

module projectEnclose (thickness = .5, height = 0, projectionCut = false){
  translate([0,0,height])linear_extrude(thickness)projection(cut = projectionCut)rotate(tenting)translate([0,0,plateHeight])hull(){
    children([0:$children-1]);
  }
}

module USBPort (Length = 1, type = "C"){
  if(type == "C"){
    rotate([0,90,90])hull(){
      translate([0,-4,0])cylinder(d = 6, Length);
      translate([0,4,0])cylinder(d = 6, Length);
    }
  } else if(type == "B")
  {
    cube([12.04,16.1,10.6], center = true);
  }
}

module BuildBottomEnclosure (struct = Eborder, Mount = false,  JackType = true, MCUType = true)
{
  function Col(n,m,l) = struct[n][m][l][0];
  function Row(n,m,l) = struct[n][m][l][1];
  function LenCheck(i,j,k) = SwitchOrientation[Row(i,j,k)][Col(i,j,k)]?0:abs(Clipped[Row(i,j,k)][Col(i,j,k)]);
  function WidCheck(i,j,k) = !SwitchOrientation[Row(i,j,k)][Col(i,j,k)]?0:abs(Clipped[Row(i,j,k)][Col(i,j,k)]);
  function LenSides(i,j,k) = SwitchOrientation[Row(i,j,k)][Col(i,j,k)]?0:sign(Clipped[Row(i,j,k)][Col(i,j,k)]);
  function WidSides(i,j,k) = !SwitchOrientation[Row(i,j,k)][Col(i,j,k)]?0:sign(Clipped[Row(i,j,k)][Col(i,j,k)]);
//  function SideMod(i,j,k)  = (struct[i][j][k][3] == sign(Clipped[Row(i,j,k)][Col(i,j,k)]) && struct[i][j][k][2])?1:0;
  function SideMod(i,j,k)  = (SwitchOrientation[Row(i,j,k)][Col(i,j,k)] && struct[i][j][k][3] == sign(Clipped[Row(i,j,k)][Col(i,j,k)]))?0:1;
  function SideMod2(i,j,k) = (SwitchOrientation[Row(i,j,k)][Col(i,j,k)] || struct[i][j][k][3] == sign(Clipped[Row(i,j,k)][Col(i,j,k)]))?0:1;

  //submodule for calling the correct border modulation module and passing Parameters

  module modBorder(structID = 0, surfaceID = 0, subStructID = 0){
    row = struct[structID][surfaceID][subStructID][1];
    col = struct[structID][surfaceID][subStructID][0];
    Bheight = col>C7?TBackHeight:BBackHeight;

    function SideMod(i,j) = (SwitchOrientation[i][j] && struct[structID][surfaceID][subStructID][3] == sign(Clipped[i][j]))?0:1;
    if (struct[structID][surfaceID][subStructID][2] == true){ //check logic for Width or Length Wise Modulation
      modBorderWid(
        Hulls = true,
        sides = WidSides(structID,surfaceID,subStructID),
        refSides = struct[structID][surfaceID][subStructID][3],
        dimClip = WidCheck(structID,surfaceID,subStructID),
        refClip = xLenM*abs(sign(Clipped[row][col]))*SideMod2(structID,surfaceID,subStructID),
        height = Bheight,
        hullSides = [struct[structID][surfaceID][subStructID][4][0],struct[structID][surfaceID][subStructID][4][1],0],
        rows = row,
        cols = col,
        scaling = struct[structID][surfaceID][subStructID][5]
      );
    } else {
      modBorderLen(
        true,
        struct[structID][surfaceID][subStructID][3],
        LenSides(structID,surfaceID,subStructID),
        LenCheck(structID,surfaceID,subStructID),
        xLenM*abs(sign(Clipped[row][col]))*SideMod(i= structID,j= surfaceID),
        Bheight ,
        [struct[structID][surfaceID][subStructID][4][0],struct[structID][surfaceID][subStructID][4][1],0],
        row,
        col,
        struct[structID][surfaceID][subStructID][5]
      );
    }
  }

    module modBottom(structID = 0, surfaceID = 0, subStructID = 0){
    row = struct[structID][surfaceID][subStructID][1];
    col = struct[structID][surfaceID][subStructID][0];
    Bheight = col>C7?TBackHeight:BBackHeight;

    function SideMod(i,j) = (SwitchOrientation[i][j] && struct[structID][surfaceID][subStructID][3] == sign(Clipped[i][j]))?0:1;
    if (struct[structID][surfaceID][subStructID][2] == true){ //check logic for Width or Length Wise Modulation
      modBottomWid(
        Hulls = true,
        sides = WidSides(structID,surfaceID,subStructID),
        refSides = struct[structID][surfaceID][subStructID][3],
        dimClip = WidCheck(structID,surfaceID,subStructID),
        refClip = xLenM*abs(sign(Clipped[row][col]))*SideMod2(structID,surfaceID,subStructID),
        height = Bheight,
        hullSides = [struct[structID][surfaceID][subStructID][4][0],struct[structID][surfaceID][subStructID][4][1],0],
        rows = row,
        cols = col,
        scaling = struct[structID][surfaceID][subStructID][5]
      );
    } else {
      modBottomLen(
        true,
        struct[structID][surfaceID][subStructID][3],
        LenSides(structID,surfaceID,subStructID),
        LenCheck(structID,surfaceID,subStructID),
        xLenM*abs(sign(Clipped[row][col]))*SideMod(i= structID,j= surfaceID),
        Bheight ,
        [struct[structID][surfaceID][subStructID][4][0],struct[structID][surfaceID][subStructID][4][1],0],
        row,
        col,
        struct[structID][surfaceID][subStructID][5]
      );
    }
  }

  module EnclosureSection(ID = 0) {
    hull(){
      for (j = [0:len(struct[ID][0])-1]) {//itt through top surface list
        if(struct[ID][3]==true){ //
          transEnclose(){modBorder(structID = ID, surfaceID = 0, subStructID = j);}
        } else {
          transEnclose(){modBottom(structID = ID, surfaceID = 0, subStructID = j);}
        }
      }
      for (k = [0:len(struct[ID][1])-1]) {//itt throgh bottom projection list
        projectEnclose(){modBorder(structID = ID, surfaceID = 1, subStructID = k);}
      }
      if(struct[ID][2] != [0,0,0]){
        transEnclose()translate(trackOrigin)rotate(trackTilt)rotate(SensorRot)translate([0,0,-21]){
          modulate(PCBCaseDim, [0,0,TOP],PCBCaseDim-[0,0,0], [0,0,TOP], Hull = true, hullSide = struct[ID][2]);
          modulate(PCBCaseDim, [0,0,TOP],PCBCaseDim-[0,0,0], [0,0,TOP], Hull = true, hullSide = .9*struct[ID][2]);
        }
        projectEnclose()translate(trackOrigin)rotate(trackTilt)rotate(SensorRot)translate([0,0,-21]){
          scale([1.25,1.25,1])modulate(PCBCaseDim, [0,0,TOP],PCBCaseDim-[0,0,0], [0,0,TOP], Hull = true, hullSide = struct[ID][2]);
          scale([1.25,1.25,1])modulate(PCBCaseDim, [0,0,TOP],PCBCaseDim-[0,0,0], [0,0,TOP], Hull = true, hullSide = .9*struct[ID][2]);
        }
      }
    }
  }

  difference(){
    union(){
      //TOP side
      for (i = [0:len(struct)-1]){
        EnclosureSection(ID = i);
      }
      //Mounts
      if(Mount == true){
        for(i = [0:len(mountScrew)-1]){
          hull(){
            #translate(mountScrew[i])cylinder(d = mountDia*1.5, 8, $fn = 16); // Mount Screw
            translate([0,0,-midHeight])linear_extrude(.01)projection(true)translate([0,0,midHeight])EnclosureSection(ID = mountHull[i]); // Prjected section of enclosure to be hulled
            for (k = [0:len(struct[mountHull[i]][1])-1]){ // bottom of enclosure section to hull
              projectEnclose(.5){modBorder(structID = mountHull[i], surfaceID = 1, subStructID = k);}
            }
          }
        }
      }

      if(JackType == "RJ45"){
        translate(JackLoc+[-7,0,0])rotate(JackAng+[0,0,0])cube([15.24+3,5,15+3], center= true);
      }  else if(JackType == "TRRS"){
//      #translate(JackLoc+[0,0,0])rotate(JackAng+[90,0,90])translate([0,0,10])cylinder(d=11, 8,center= true, $fn=32);
        }
    }
    //CUTS
    //Mounts
    for(i = [0:len(mountScrew)-1]){
      translate([0,0,-1])translate(mountScrew[i])cylinder(d = mountDia, 7, $fn = 32);
    }

    if(JackType == "TRRS"){

      #translate(JackLoc+[0,0,0])rotate(JackAng+[90,0,90])translate([0,0,12])cylinder(d = 8, 20, center= true);
      #translate(JackLoc)rotate(JackAng)translate([.5,0,-2])cube(JackDim+[1,1,-3], center = true);
    } else if(JackType == "RJ45"){
      #translate(JackLoc+[0,0,0])rotate(JackAng+[0,0,0])cube([15.24,20.75,15], center= true);
    }

    if(MCUType == true){
#      translate(MCULoc)cube(MCUDim, center = true);
#      translate(USBLoc)USBPort(20);
    }
    //TODO: trackball modules?

  }
}

//generate Bottom Plate for mounting MCU, Jacks and weights?
module BuildBottomPlate(struct = Eborder, hullList = Hstruct, JackType = true, MCUType = true, Mount = false)
 {
  //submodule for calling the correct border modulation module and passing Parameters
  //TODO: repeating module! clean up
  function Col(n,m,l) = struct[n][m][l][0];
  function Row(n,m,l) = struct[n][m][l][1];
  function LenCheck(i,j,k) = SwitchOrientation[Row(i,j,k)][Col(i,j,k)]?0:abs(Clipped[Row(i,j,k)][Col(i,j,k)]);
  function WidCheck(i,j,k) = !SwitchOrientation[Row(i,j,k)][Col(i,j,k)]?0:abs(Clipped[Row(i,j,k)][Col(i,j,k)]);
  function LenSides(i,j,k) = SwitchOrientation[Row(i,j,k)][Col(i,j,k)]?0:sign(Clipped[Row(i,j,k)][Col(i,j,k)]);
  function WidSides(i,j,k) = !SwitchOrientation[Row(i,j,k)][Col(i,j,k)]?0:sign(Clipped[Row(i,j,k)][Col(i,j,k)]);
//  function SideMod(i,j,k)  = (struct[i][j][k][3] == sign(Clipped[Row(i,j,k)][Col(i,j,k)]) && struct[i][j][k][2])?1:0;
  function SideMod(i,j,k)  = (SwitchOrientation[Row(i,j,k)][Col(i,j,k)] && struct[i][j][k][3] == sign(Clipped[Row(i,j,k)][Col(i,j,k)]))?0:1;
  function SideMod2(i,j,k) = (SwitchOrientation[Row(i,j,k)][Col(i,j,k)] || struct[i][j][k][3] == sign(Clipped[Row(i,j,k)][Col(i,j,k)]))?0:1;

  //submodule for calling the correct border modulation module and passing Parameters

  module modBorder(structID = 0, surfaceID = 0, subStructID = 0){
    row = struct[structID][surfaceID][subStructID][1];
    col = struct[structID][surfaceID][subStructID][0];
//    echo("mod",row, col,subStructID, struct[structID][surfaceID][subStructID]);
    function SideMod(i,j) = (SwitchOrientation[i][j] && struct[structID][surfaceID][subStructID][3] == sign(Clipped[i][j]))?0:1;

    if (struct[structID][surfaceID][subStructID][2] == true){ //check logic for Width or Length Wise Modulation
      modBorderWid(
        Hulls = true,
        sides = WidSides(structID,surfaceID,subStructID),
        refSides = struct[structID][surfaceID][subStructID][3],
        dimClip = WidCheck(structID,surfaceID,subStructID),
        refClip = xLenM*abs(sign(Clipped[row][col]))*SideMod2(structID,surfaceID,subStructID),
        height = BBackHeight,
        hullSides = [struct[structID][surfaceID][subStructID][4][0],struct[structID][surfaceID][subStructID][4][1],0],
        rows = row,
        cols = col,
        scaling = struct[structID][surfaceID][subStructID][5]
      );
    } else {
      modBorderLen(
        true,
        struct[structID][surfaceID][subStructID][3],
        LenSides(structID,surfaceID,subStructID),
        LenCheck(structID,surfaceID,subStructID),
        xLenM*abs(sign(Clipped[row][col]))*SideMod(i= structID, j= surfaceID),
        BBackHeight*abs(sign(Clipped[row][col])),
        [struct[structID][surfaceID][subStructID][4][0],struct[structID][surfaceID][subStructID][4][1],0],
        row,
        col,
        struct[structID][surfaceID][subStructID][5]
      );
    }
  }

   difference(){
    union(){
      for (i = [0:len(hullList)-1]){
        hull(){
          for (j = [0:len(hullList[i])-1]) {
            for (k = [0:len(struct[hullList[i][j]][1])-1]){
//              echo("bttm", i,j,k,struct[hullList[i][j]][1], hullList[i][j] );
              projectEnclose(2){modBorder(structID = hullList[i][j], surfaceID = 1, subStructID = k);}
            }
            // Section for TB module case
            if (struct[hullList[i][j]][2] != [0,0,0]){
              projectEnclose(2)translate(trackOrigin)rotate(trackTilt)rotate(SensorRot)translate([0,0,-36/2])
              scale([1,1,1])modulate(PCBCaseDim, [0,0,TOP],PCBCaseDim-[0,0,0], [0,0,TOP], Hull = true, hullSide = [0,0,0]);
            }
          }
        }
      }
      if(JackType == true){
        translate(JackLoc)rotate(JackAng)translate([-2.5,0,-2])cube(JackDim+[5,5,-4], center = true);
      }

      if(MCUType == true){
        translate(MCULoc+[0,-2.5,-3])cube(MCUDim+[5,5,5], center = true);
      }
      //TODO: trackball modules?
    }

    //CUTS
    for (i = [0:len(struct)-1]){  //expanded to cut artifacts from hulling higher than bottom enclosure edges
      translate([0,0,-.02])scale(1.02)hull(){
        for (k = [0:len(struct[i][1])-1]) {//itt throgh bottom projection list
          projectEnclose(thickness = 4){
            modBorder(structID = i, surfaceID = 1, subStructID = k);
            if (struct[i][2] != [0,0,0]){
              translate(trackOrigin)rotate(trackTilt)rotate(SensorRot)translate([0,0,-36/2]){
                scale([1.25,1.25,1])modulate(PCBCaseDim, [0,0,TOP],PCBCaseDim-[0,0,0], [0,0,TOP], Hull = true, hullSide = struct[i][2]);
                scale([1.25,1.25,1])modulate(PCBCaseDim, [0,0,TOP],PCBCaseDim-[0,0,0], [0,0,TOP], Hull = true, hullSide = .9*struct[i][2]);
              }
            }
          }
        }
      }
    }

    if(Mount == true){
      for(i = [0:len(mountScrew)-1]){
        translate([0,0,0])translate(mountScrew[i])cylinder(d1 = screwtopDia, d2 =  screwholeDia, 2.8, $fn = 32);
        translate([0,0,-.5])translate(mountScrew[i])cylinder(d = screwholeDia, bpThickness+1, $fn = 32);
      }
    }

    if(JackType == true){
      #translate(JackLoc)rotate(JackAng)cube(JackDim, center = true);
      #translate(JackLoc)rotate(JackAng+[90,0,90])translate([0,0,14])cylinder(d = 8, 10, center= true);
    }

    if(MCUType == true){
      // for flipped Elite C
      translate(MCULoc)cube(MCUDim, center = true);
      translate(USBLoc)USBPort(20);
      //reset button for
      translate(MCULoc+[-2.5,5-32.5/2,0])cylinder(d = 3, 15, center = true);
      translate(MCULoc+[-2.5,5-32.5/2,-1])cube([5,4,3], center = true);
      //Pin Slots
      translate(MCULoc+[-9.25+1.5,0,0])cube([2,32.5,3], center = true);
      translate(MCULoc+[9.25-1.5,0,0])cube([2,32.5,3], center = true);
      translate(MCULoc+[0,-32.5/2+1.5,0])cube([18.5,2,3], center = true);
    }
  }
}

//--- Misc
//--- TrackBall
module PCB(height = 8){
  tol = .4;
  PL = 21/2+tol;
  PW = 18.6/2+tol;
  PT = 4.1;
  PCBT = 1.6;

  //Prism
  translate([0,0,-PT])linear_extrude(PT)rounding(r=8)polygon([[PL,PW],[-PL,PW],[-PL,-PW],[PL,-PW]]);
  translate([-PL+6.5,0,.6])cube([2,4,1.2],center= true);
  translate([PL-6.5,0,.6])cube([2,4,1.2],center= true);

  //PCB
  translate([0,0,-.8-PT])cube([29,21.5,height],center= true);
  translate([24/2,0,-PT-PCBT-2])cylinder(d=1.6, 10);
  translate([-24/2,0,-PT-PCBT-2])cylinder(d=1.6, 10);

  //Apeture
  translate([0,0,0])cylinder(d1=5, d2= 12, 4);
}

//Path functions for trackball holder
  function oval_path(theta, phi, a, b, c, deform = 0) = [
   a*cos(theta)*cos(phi), //x
   c*sin(theta)*(1+deform*cos(theta)) , //
   b*sin(phi),
  ];

  //oval path with linear angle offset
  function oval_path2(theta, phi_init, a, b, c, d = 0, p = 1, deform = 0) = [
   a*cos(theta)*cos(phi_init), //x
   b*sin(theta)*(1+deform*cos(theta))*cos(phi_init + d * sin(theta*p)), //
   c*sin(phi_init + d * sin(theta*p))
  ];

  //oval path with angle offset with hypersine
  function oval_path3(theta, phi_init, a, b, c, d = 0, p = 1, deform = 0) = [
   a*cos(theta)*cos(phi_init), //x
   b*sin(theta)*(1+deform*cos(theta))*cos(phi_init + d * pow(sin(theta*p), 1)), //
   c*sin(phi_init + d * pow(sin(theta*p), 3))
  ];

//shape functions
function ellipse(a, b, d = 0) = [for (t = [0:step:360]) [a*cos(t), b*sin(t)*(1+d*cos(t))]]; //shape to

// sweep generators

module palm_track() {
  a = trackR;
  b = trackR;
  c = trackR;
  //Ellipsoid([20*2,25*2,60],[30*2,25*2,60], center = true);
  function shape() = ellipse(3, 3);
  function shape2() = ellipse(4, 6);
  path_transforms =  [for (t=[0:step:180]) translation(oval_path3(t,20,a,c,b,30,1,0))*rotation([90,-20-20*sin(t),t])];
  path_transforms2 =  [for (t=[0:step:180]) translation(oval_path3(t,70,b,a,c,6,1,0))*rotation([90,-70+5*sin(t),t])];
//  path_transforms3 =  [for (t=[0:step:360]) translation(oval_path3(t,-5,a,c,b,-15,1,0))*rotation([90,20+15*cos(t),t])];
  path_transforms3 =  [for (t=[0:step:180]) translation(oval_path3(t,-40,a,c,b,10,1,0))*rotation([90,40-10*sin(t),t])];
  path_transforms4 =  [for (t=[180:step:360]) translation(oval_path3(t,-40,a,c,b,-35,1,0))*rotation([90,40+35*sin(t),t])];

 translate([0,0,0]){
//  rotate([-90,0,0])sweep(shape(), path_transforms);
//  rotate([90,0,-90])sweep(shape(), path_transforms2); //tip
//  rotate([90,0,90])sweep(shape(), path_transforms2);  //tip
  rotate([-30,0,0])sweep(shape2(), path_transforms3);
 }
 //support ring
 rotate([-30,0,0])sweep(shape2(), path_transforms4);
}


module TrackBall(){
  difference(){
    union(){
     palm_track();
     rotate(SensorRot)translate([0,0,-trackR+1])cube(PCBCaseDim,center= true); // pcb housing
    }
    rotate(SensorRot)translate([0,0,-38/2])PCB();
//    #rotate(SensorRot)translate([0,0,-42/2])cylinder(d =1, 100); orientation check
  }
}

//Key Switches and Caps
module BuildKeyWells () {
  for(cols = colRange){
    for(rows = [RowInits[cols]:RowEnds[cols]]){
      PlaceRmCn(rows, cols){
        if(SwitchOrientation[rows][cols] == true){
          Keyhole(tol = 0, clipLength = Clipped[rows][cols], cutThickness = 1, type = SwitchTypes[rows][cols], boffsets = holeOffset);
        }else {
          rotate([0,0,-90])Keyhole(tol = 0, clipLength = Clipped[rows][cols], cutThickness = 1, type = SwitchTypes[rows][cols], boffsets = holeOffset);
        }
      }
    }
  }

  //switch top cuts
  // for(cols = colRange)BuildColumn(PlateDim[2]+PBuffer+10, 0, TOP, col = cols, rowInit = RowInits[cols], rowEnd = RowEnds[cols]);
  // BuildColumn(PlateDim[2]+PBuffer+10, 0, TOP, col = CStart, rowInit = RowInits[CStart], rowEnd = RowEnds[CStart], offset2 = 18, adjust = LEFT);
  // BuildColumn(PlateDim[2]+PBuffer+10, 0, TOP, col = CEnd, rowInit = RowInits[CEnd], rowEnd = RowEnds[CEnd],offset2 = 18, adjust = RIGHT);
}

module BuildSet (switchType = SwitchTypes, capType = DSA, colors, stemcolor, switchH = 0) //place objects on key position
{
  for(cols = [CStart:CEnd]){
    for(rows = [RowInits[cols]:RowEnds[cols]]){
      PlaceRmCn(rows, cols)
      if(SwitchOrientation[rows][cols] == true){translate([0,0,switchH])Switch(switchScale = [CapScale[rows][cols],1,1], type = switchType[rows][cols], CapColor = colors,  Caps = capType, StemColor = stemcolor, clipLength = Clipped[rows][cols], Row = rows-1);}
      else {translate([0,0,switchH])rotate([0,0,-90])Switch(switchScale = [CapScale[rows][cols],1,1],type = switchType[rows][cols], CapColor = colors, Caps = capType, StemColor = stemcolor, clipLength = Clipped[rows][cols], Row = rows-1);}
    }
  }
  for(cols = [TStart:TEnd]){
    for(rows = [RowInits[cols]:RowEnds[cols]]){
      PlaceRmCn(rows, cols)
      if(SwitchOrientation[rows][cols] == true){translate([0,0,switchH])scale([1.0,1.0,1])Switch(switchScale = [CapScale[rows][cols],1,1],type = switchType[rows][cols], CapColor = colors,  Caps = capType, StemColor = stemcolor, clipLength = Clipped[rows][cols], Row = rows-1);}
      else {translate([0,0,switchH])rotate([0,0,-90])scale([1.0,1,1])Switch(switchScale = [CapScale[rows][cols],1,1],type = switchType[rows][cols], CapColor = colors,  Caps = capType, StemColor = stemcolor, clipLength = Clipped[rows][cols], Row = rows-1);}
    }
  }
}

module BuildPoints(length= .1) // output to be used by kicad
{
  for(cols = [CStart:CEnd]){
    for(rows = [RowInits[cols]:RowEnds[cols]]){
      PlaceRmCn(rows, cols)
      if(SwitchOrientation[rows][cols] == true){cube(length, center = true);}
      else {rotate([0,0,-90])cube(length, center = true);}
    }
  }
  for(cols = [TStart:TEnd]){
    for(rows = [RowInits[cols]:RowEnds[cols]]){
      PlaceRmCn(rows, cols)
      if(SwitchOrientation[rows][cols] == true){scale([1.0,1,1])cube(length, center = true);}
      else {rotate([0,0,-90])scale([1.0,1,1])cube(length, center = true);}
    }
  }
}

//Apply Color to Build
module PaintColor(colorBool = false){
  if( colorBool == false){
    color("lightslateGrey")children();
  }else {
    children();
  }
}