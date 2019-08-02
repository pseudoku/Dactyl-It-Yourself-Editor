use <Switch.scad> //modules for switches and key holes generation
use <sweep.scad>
use <scad-utils/transformations.scad>
use <scad-utils/morphology.scad>
use <scad-utils/lists.scad>
use <scad-utils/shapes.scad>
use <scad-utils/trajectory.scad>
use <scad-utils/trajectory_path.scad>
use <skin.scad>  
//################ Main Builder ############################
module BuildTopPlate(keyhole = false, trackball = false, ThumbJoint = false, Border = false, PrettyBorder = false, ColoredSection = false)
{
  //Submodules 
  //TODO: change scope of submodules and remove duplicates now that calls are merged
  module modPlate(Hulls = true, thickBuff = 0, sides = TOP, refSides = BOTTOM, hullSides = [0,0,0], row, col){//shorthand
    if (SwitchOrientation[row][col] == true){
      PlaceRmCn(row, col)modulate(PlateDim,[0,sign(Clipped[row][col]), sides],PlateDim-[0,abs(Clipped[row][col]),-PBuffer-thickBuff], [0,-sign(Clipped[row][col]),refSides], Hull = Hulls, hullSide = hullSides);
    }
    else{
      PlaceRmCn(rows, cols)modulate(PlateDim,[sign(Clipped[rows][cols]), 0, sides], PlateDim-[abs(Clipped[rows][cols]),0,-PBuffer-thickBuff], [-sign(Clipped[rows][cols]), 0, refSides], Hull = Hulls, hullSide = hullSides);
    }
  }
  module modWeb(Hulls = true,  sides = 0, refSides = 0, hullSides = [0,0,0], row, col){
    PlaceRmCn(row, col)modulate(PlateDim+[-abs(Clipped[row][col])*2,0,PBuffer*2], [refSides,sides,TOP],PlateDim+[-WebThickness,-abs(Clipped[row][col]),PBuffer], [-refSides,sides,BOTTOM], Hull = Hulls, hullSide = hullSides);
  }
  //End of Submodules
  
  //Builds
  difference(){
    union(){
      for (cols = colRange){// build main plate objects
        BuildColumn(PlateDim[2]+PBuffer, 0, BOTTOM, col = cols, rowInit = RowInits[cols], rowEnd = RowEnds[cols]); //builds plate 
//        echo(ColumnOrigin[cols+1][0][0]-ColumnOrigin[cols][0][0],PlateDim[0]);
        //build webbing between Columns
        if(ColumnOrigin[cols+1][0][0]-ColumnOrigin[cols][0][0] < PlateDim[0]){//column separation are larger than the boundary  
          BindColums(TopAlignment = BOTTOM, BufferAlignment = 0, cols= cols);
        } else {
          BindColums(TopAlignment = BOTTOM, BufferAlignment = RIGHT, cols= cols);
        }
      }      
      // todo call thum joint here for plate only builds?
      //----- Borders
      PaintColor(ColoredSection){        
        if (Border == true )BuildTopEnclosure(bBotScale = RScale); //for easier debugging
        if (PrettyBorder == true)BuildPrettyTransition(bBotScale = RScale);
        if (CustomBorder == true){
          color("Crimson")BuildCustomBorder(struct = Sborder);
          color("DarkGreen")BuildAdditionaltEdge(struct = Lborder, sides = LEFT);   //Catch uncaught Left Top Border
          color("YellowGreen")BuildAdditionaltEdge(struct = Rborder, sides = RIGHT);  //Catch uncaught Left Top Border
        }
        if (ThumbJoint == true)color("Salmon")BuildCustomBorder(struct = TCJoints);       
        if (trackball == true){}//color("Green")BuildCustomBorder(struct = TBJoints); //Tarckballs
      }
      
    }//end build union
    //CUTS
    union(){     
      // Remove inter-columnar artifacts from borders and web joints
//      for( cols = [C5, T0, T1]){
        BindTopCuts(struct = TopCuts, height = 1);
//      }
      // Keyholes
      if(keyhole == true){ //Column Section
        for(cols = colRange){
          for(rows = [RowInits[cols]:RowEnds[cols]]){
            PlaceRmCn(rows, cols){
              if(SwitchOrientation[rows][cols] == true){
                Keyhole(tol = 0, clipLength = Clipped[rows][cols], cutThickness = 5, type = Box);
              }else {
                rotate([0,0,-90])Keyhole(tol = 0, clipLength = Clipped[rows][cols], cutThickness = 5, type = Box);
              }
            }
          }     
        }
        //cuttting switch top to remove artifacts 
        for(cols = colRange){
          BuildColumn(PlateDim[2]+PBuffer+10, 0, TOP, col = cols, rowInit = RowInits[cols], rowEnd = RowEnds[cols]);  
//          BindColums(TopAlignment =TOP, BufferAlignment = RIGHT, cols= cols);
        }
        
        //PCB mount
//        for(cols = [CStart:CEnd])PlaceRmCn(PM,cols)cylinder(d=3, 20, center = true); 
      }
    }
  }
}

//----- Supporting Modules for Main Builder Modules

//----  functions
function hadamard(a, b) = !(len(a) > 0) ? a*b : [ for (i = [0:len(a) - 1]) hadamard(a[i], b[i])]; // elementwise mult
function rowRange(col) = [RowInits[col]:RowEnds[col]]; // shorthand for row loop range 

//cal global y position without considering rotation for quick condition check
function BRowYPos(i) = ColumnOrigin[i][0][1]+RowTrans[RowInits[i]][i];
function FRowYPos(i) = ColumnOrigin[i][0][1]+RowTrans[RowEnds[i]][i];
function FRowZPos(i) = ColumnOrigin[i][0][1]+Height[RowEnds[i]][i];

//----  Transformations and Modulating cube
module hullPlate(referenceDimensions = [0,0,0], offsets = [0,0,0], scalings = [1,1,1]) //Convenient notation for hulling a cube by face/edge/vertex
{ 
  hullDimension = [
    offsets[0] == 0 ?  scalings[0]*referenceDimensions[0]:HullThickness, // x
    offsets[1] == 0 ?  scalings[1]*referenceDimensions[1]:HullThickness, // y
    offsets[2] == 0 ?  scalings[2]*referenceDimensions[2]:HullThickness, // z
  ];
  
  translate(hadamard(referenceDimensions, offsets/2))translate(hadamard(hullDimension, -offsets/2))cube(hullDimension, center = true);
} 

module modulate(referenceDimension = [0,0,0], referenceSide = [0,0,0], objectDimension = [0,0,0], objectSide = [0,0,0], Hull = false, hullSide = [0,0,0], scalings = [1,1,1]){//Convinient cube transferomation and hulling ref
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

//module OutRmCn(row, col) {
//    PlaceColumnOrigin(col)
//    [RowTrans[row][col],Height[row][col]+PlateThickness/2,ColTrans[row][col]]
//  
//}
//--- Building Modules 
module BuildColumn(plateThickness, offsets, sides =TOP, col=0, rowInit = R0, rowEnd = R0){//generate switch plates and hull in between between per column 
  refDim   = PlateDim +[0,0,offsets];
  buildDim = [PlateDim[0], PlateDim[1], plateThickness];
  
  //TODO: Refactor all modplate type calls 
  module modPlateLen(Hulls = true, hullSides = [0,0,0], rows, cols){//shorthand call for length-wise clipping 
    modulate(refDim,[0,sign(Clipped[rows][cols]),TOP], buildDim-[0,abs(Clipped[rows][cols]),0], [0,-sign(Clipped[rows][cols]),sides], Hull = Hulls, hullSide = hullSides);
    //use clip length sign to direct transform sides and adjust platle length rather than if else statement for more compact call 
  }
  
  module modPlateWid(Hulls = true, hullSides = [0,0,0], rows, cols){//shorthand call for Width-wise clipping
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

module BindColums(TopAlignment =TOP, BufferAlignment = 0, cols=0){//Build support structure between columns, Buffers side option to aligne hull surface 
  
  module modWeb(Hulls = true,  sides = 0, refSides = 0, hullSides = [0,0,0], row, col){
    if(SwitchOrientation[row][col] == true){
      PlaceRmCn(row, col)scale([CapScale[row][col],1,1])modulate(PlateDim+[-abs(Clipped[row][col])*2,0,PBuffer*2], [refSides,sides,TOP],PlateDim+[-WebThickness,-abs(Clipped[row][col]),PBuffer], [-refSides,sides,TopAlignment], Hull = Hulls, hullSide = hullSides);
    }else {
      PlaceRmCn(row, col)scale([1,CapScale[row][col],1])modulate(PlateDim+[-abs(Clipped[row][col])*2,0,PBuffer*2], [refSides,sides,TOP],PlateDim+[-WebThickness,-abs(Clipped[row][col]),PBuffer], [-refSides,sides,TopAlignment], Hull = Hulls, hullSide = hullSides);
    }
  }
  
  if (cols != CEnd && cols != TEnd){//Hull Between Columns TODO: Modulize 
    for(rows = [max(RowInits[cols],RowInits[cols+1]):min(RowEnds[cols],RowEnds[cols+1])]){//build only nearest
      hull(){
        modWeb(true, sides = 0, refSides = RIGHT, hullSides = [BufferAlignment,0,0], row = rows, col = cols);
        modWeb(true, sides = 0, refSides = LEFT,  hullSides = [-BufferAlignment,0,0], row = rows, col = cols+1);
      }
    }
    //between corners
    for(rows = [max(RowInits[cols],RowInits[cols+1]):min(RowEnds[cols],RowEnds[cols+1])]){
      if(rows != min(RowEnds[cols],RowEnds[cols+1])){
        hull(){
          modWeb(true, sides = 0, refSides = RIGHT, hullSides = [BufferAlignment,FRONT,0],  row = rows,   col =   cols);
          modWeb(true, sides = 0, refSides = LEFT,  hullSides = [-BufferAlignment,FRONT,0], row = rows,   col = cols+1);
          modWeb(true, sides = 0, refSides = RIGHT, hullSides = [BufferAlignment,BACK,0],   row = rows+1, col =   cols);
          modWeb(true, sides = 0, refSides = LEFT,  hullSides = [-BufferAlignment,BACK,0],  row = rows+1, col = cols+1);
        }
      }
    }
  }
}

module BindTopCuts(Struct = TopCuts,height = 0) {
  plateThickness = PlateDim[2]+PBuffer+height;
  offsets = 0;
  sides = TOP;
  refDim   = PlateDim +[0,0,offsets];
  buildDim = [PlateDim[0], PlateDim[1], plateThickness];
  
  //TODO: Refactor all modplate type calls 
  module modPlateLen(Hulls = true, hullSides = [0,0,0], rows, cols){//shorthand call for length-wise clipping 
    modulate(refDim,[0,sign(Clipped[rows][cols]),TOP], buildDim-[0,abs(Clipped[rows][cols]),0], [0,-sign(Clipped[rows][cols]),sides], Hull = Hulls, hullSide = hullSides);
    //use clip length sign to direct transform sides and adjust platle length rather than if else statement for more compact call 
  }
  
  module modPlateWid(Hulls = true, hullSides = [0,0,0], rows, cols){//shorthand call for Width-wise clipping
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
    PlaceRmCn(rows, cols)scale([CapScale[rows][cols],1,1])modulate(PlateDim+[0,-refClip*2,PBuffer*2], [refSides,sides, BOTTOM],PlateDim+[-dimClip,-Bthickness,height], [-refSides,sides,TOP], Hull = Hulls, hullSide = [hullSides[0],hullSides[1],TOP], scalings = [1,1,1]);
    //BOTTOM
    PlaceRmCn(rows, cols)scale([CapScale[rows][cols],1,1])modulate(PlateDim+[0,-refClip*2,PBuffer*2], [refSides,sides, BOTTOM],PlateDim+[-dimClip,-Bthickness,height], [-refSides,sides,TOP], Hull = Hulls, hullSide = [hullSides[0],hullSides[1],BOTTOM], scalings = scaling);
  } else { // scale 
    //TOP
    PlaceRmCn(rows, cols)modulate(hadamard(PlateDim,[1,CapScale[rows][cols],1])+[0,-refClip*2,PBuffer*2], [refSides,sides, BOTTOM],PlateDim+[-dimClip,-Bthickness,height], [-refSides,sides,TOP], Hull = Hulls, hullSide = [hullSides[0],hullSides[1],TOP], scalings = [1,1,1]);
    //BOTTOM
    PlaceRmCn(rows, cols)modulate(hadamard(PlateDim,[1,CapScale[rows][cols],1])+[0,-refClip*2,PBuffer*2], [refSides,sides, BOTTOM],PlateDim+[-dimClip,-Bthickness,height], [-refSides,sides,TOP], Hull = Hulls, hullSide = [hullSides[0],hullSides[1],BOTTOM], scalings = scaling);
  }
}

//Modulate shorthand for building Width-Wise hulls for Borders
module modBorderWid(Hulls = false, sides = 0, refSides = 0, dimClip = 0, refClip = 0, height = 6, hullSides = [0,0,0], rows, cols, scaling = [1,1,1]){
  if (SwitchOrientation[rows][cols] == true){ //no need to scale cap size
    //TOP
    PlaceRmCn(rows, cols)modulate(hadamard(PlateDim,[CapScale[rows][cols],1,1])+[-refClip*2,0,PBuffer*2], [refSides,sides, BOTTOM],PlateDim+[-Bthickness,-dimClip,height], [refSides,-sides,TOP], Hull = Hulls, hullSide = [hullSides[0],hullSides[1],TOP], scalings = [1,1,1]);
    //BOTTOM
    PlaceRmCn(rows, cols)modulate(hadamard(PlateDim,[CapScale[rows][cols],1,1])+[-refClip*2,0,PBuffer*2], [refSides,sides, BOTTOM],PlateDim+[-Bthickness,-dimClip,height], [refSides,-sides,TOP], Hull = Hulls, hullSide = [hullSides[0],hullSides[1],BOTTOM], scalings = scaling);
  } else { //scale to cap size
    PlaceRmCn(rows, cols)scale([1,CapScale[rows][cols],1])modulate(PlateDim+[-refClip*2,0,PBuffer*2], [refSides,sides, BOTTOM],PlateDim+[-Bthickness,-dimClip,height], [refSides,-sides,TOP], Hull = Hulls, hullSide = [hullSides[0],hullSides[1],TOP], scalings = [1,1,1]);
    //BOTTOM
    PlaceRmCn(rows, cols)scale([1,CapScale[rows][cols],1])modulate(PlateDim+[-refClip*2,0,PBuffer*2], [refSides,sides, BOTTOM],PlateDim+[-Bthickness,-dimClip,height], [refSides,-sides,TOP], Hull = Hulls, hullSide = [hullSides[0],hullSides[1],BOTTOM], scalings = scaling);}
}

module buildCorner(row = R0, col = C0, side1 = FRONT, side2 = LEFT, BHeight = BBackHeight, bBotScale = RScale){
  hull(){
    modBorderWid(true,     0, side2, 0, xLenM, BHeight, [0,side1,0], row, col, [bBotScale,1,1]);
    modBorderLen(true, side1,     0, 0, xLenM, BHeight, [side2,0,0], row, col, [1,bBotScale,1]);
  } 
}

module BuildAdditionaltEdge(struct = Lborder, sides = LEFT, bBotScale = RScale){ //use border struc to biuld Left Edge
  for (row = [0:len(struct)-1]){
    for (i = [0:len(struct[row])-1]){
      if(row == RowEnds[struct[row][i]]){ //if at the Max Row of a column add height transition
        hull(){
          modBorderWid(true, 0, sides, 0, xLenM, BFrontHeight, [0,FRONT,0], row, struct[row][i], [bBotScale,1,1]);
          modBorderWid(true, 0, sides, 0, xLenM, BBackHeight,   [0,BACK,0], row, struct[row][i], [bBotScale,1,1]);
        }
      } else { 
        hull(){
          modBorderWid(true, 0, sides, 0, xLenM, BBackHeight, [0,0,0], row, struct[row][i], [bBotScale,1,1]);
        }
      } 
      if (len(search(struct[row][i],struct[row+1])) > 0){ // check if next row has matching column 
        hull(){
          modBorderWid(true, 0, sides, 0, xLenM, BBackHeight, [0,FRONT,0], row, struct[row][i], [bBotScale,1,1]);
          modBorderWid(true, 0, sides, 0, xLenM, BBackHeight,  [0,BACK,0], row+1, struct[row][i], [bBotScale,1,1]);
        }
      }
      if (RowInits[struct[row][i]] == row){ // codition col min
//        hull(){
//          modBorderWid(true,    0, sides, 0, xLenM, BBackHeight,  [0,BACK,0], row, struct[row][i], [bBotScale,1,1]);
//          modBorderLen(true, BACK,     0, 0, xLenM, BBackHeight,  [sides,0,0], row, struct[row][i], [1,bBotScale,1]);
//        }  
        buildCorner(row, struct[row][i], BACK, sides, BBackHeight, RScale);
      }
      if (RowEnds[struct[row][i]] == row){ // codition col max match 
        buildCorner(row, struct[row][i], FRONT, sides, BFrontHeight, RScale);
      }
    }
  }
}

module BuildCustomBorder(struct = Sborder){// use Sborder struc to build hull.
  for (i = [0:len(struct)-1]){
    hull(){
      //[Col, Row, len = true, Jog direction, HullFace, Scale], 
      for (j = [0:len(struct[i])-1]){
        if (struct[i][j][2] == true){
          modBorderWid(true, 0, struct[i][j][3], 0, xLenM, BBackHeight, [struct[i][j][4][0],struct[i][j][4][1],0], struct[i][j][1], struct[i][j][0], struct[i][j][5]);
        } else {
          modBorderLen(true, struct[i][j][3], 0, 0, xLenM, BBackHeight, [struct[i][j][4][0],struct[i][j][4][1],0], struct[i][j][1], struct[i][j][0], struct[i][j][5]);
        }
      }
    }
  } 
}

//Generate basic borders by loop to separate generic border and pretty border calls. 
module BuildTopEnclosure(bBotScale = RScale){  
  //generic width wise border
  for (cols = colRange){
    hull(){modBorderLen(true, BACK, 0, 0, xLenM, BBackHeight, [0,0,0], RowInits[cols], cols, [1,bBotScale,1]);} //generic BACK
    hull(){modBorderLen(true, FRONT,    0, 0, xLenM, BFrontHeight, [0,0,0], RowEnds[cols], cols, [1,bBotScale,1]);} //generic FRONT
    //Generic Left and Right Boarder 
    if (cols == CStart || cols == TStart){//Initial Columns
      buildCorner(row = RowInits[cols], col = cols, side1 = BACK, side2 = LEFT, BHeight = BBackHeight, bBotScale = RScale); //Bottom Right row corner   
      for (rows = rowRange(cols)){//
        //LEFT
        if(rows != RowEnds[cols]){
          hull(){modBorderWid(true,     0, LEFT, 0, xLenM, BBackHeight, [0,0,0], rows, cols, [bBotScale,1,1]);}
          hull(){// Between Rows
            modBorderWid(true, 0, LEFT, 0, xLenM, BBackHeight, [0,FRONT,0],   rows, cols, [bBotScale,1,1]);
            modBorderWid(true, 0, LEFT, 0, xLenM, BBackHeight,  [0,BACK,0], rows+1, cols, [bBotScale,1,1]);
          }
        } else {
          hull(){ //Boarder Height transition 
            modBorderWid(true,     0, LEFT, 0, xLenM, BFrontHeight, [0,FRONT,0], rows, cols, [bBotScale,1,1]);
            modBorderWid(true,     0, LEFT, 0, xLenM,  BBackHeight, [0,BACK,0],  rows, cols, [bBotScale,1,1]);
          }
          buildCorner(row = rows, col = cols, side1 = FRONT, side2 = LEFT, BHeight = BFrontHeight, bBotScale = RScale); //Bottom Right row corner 
        }
        if (len(search(rows, [for( i =rowRange(cols+1)) i])) == 0){//next Col  No Match 
          if (rows == RowInits[cols]){
            buildCorner(row = rows, col = cols, side1 = BACK, side2 = RIGHT, BHeight = BBackHeight, bBotScale = RScale); //Bottom Right row corner
          }
          if (rows != RowEnds[cols]){
            hull(){modBorderWid(true,     0, RIGHT, 0, xLenM, BBackHeight, [0,0,0], rows, cols, [bBotScale,1,1]);}
            if (len(search(rows+1, [for( i =rowRange(cols+1)) i])) == 0){ //check next row to build bridging hull
              hull(){
                modBorderWid(true,     0, RIGHT, 0, xLenM, BBackHeight, [0,FRONT,0], rows,   cols, [bBotScale,1,1]);
                modBorderWid(true,     0, RIGHT, 0, xLenM, BBackHeight,  [0,BACK,0], rows+1, cols, [bBotScale,1,1]);
              }
            }
          } else {
            hull(){//top height transition hull
              modBorderWid(true,     0, RIGHT, 0, xLenM, BFrontHeight, [0,FRONT,0], rows,   cols, [bBotScale,1,1]);
              modBorderWid(true,     0, RIGHT, 0, xLenM, BBackHeight,  [0,BACK,0], rows, cols, [bBotScale,1,1]);
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
            hull(){modBorderWid(true,     0, LEFT, 0, xLenM, BBackHeight, [0,0,0], rows, cols, [bBotScale,1,1]);}
            if (len(search(rows+1, [for (i = rowRange(cols-1)) i])) == 0){ //check next row to build bridging hull
              hull(){
                modBorderWid(true,     0, LEFT, 0, xLenM, BBackHeight, [0,FRONT,0], rows,   cols, [bBotScale,1,1]);
                modBorderWid(true,     0, LEFT, 0, xLenM, BBackHeight,  [0,BACK,0], rows+1, cols, [bBotScale,1,1]);
              }
            }
          } else {
            hull(){//top height transition hull
              modBorderWid(true,     0, LEFT, 0, xLenM, BFrontHeight, [0,FRONT,0], rows,   cols, [bBotScale,1,1]);
              modBorderWid(true,     0, LEFT, 0, xLenM, BBackHeight,  [0,BACK,0], rows, cols, [bBotScale,1,1]);
            }
            buildCorner(row = rows, col = cols, side1 = FRONT, side2 = LEFT, BHeight = BFrontHeight, bBotScale = RScale); //Bottom Right row corner
          }
        }
        //RIGHTs
        if(rows != RowEnds[cols]){
          hull(){modBorderWid(true,     0, RIGHT, 0, xLenM, BBackHeight, [0,0,0], rows, cols, [bBotScale,1,1]);}
          hull(){// Between Rows
            modBorderWid(true, 0, RIGHT, 0, xLenM, BBackHeight, [0,FRONT,0],   rows, cols, [bBotScale,1,1]);
            modBorderWid(true, 0, RIGHT, 0, xLenM, BBackHeight,  [0,BACK,0], rows+1, cols, [bBotScale,1,1]);
          }
        } else {
          hull(){ //Boarder Height transition 
            modBorderWid(true,     0, RIGHT, 0, xLenM, BFrontHeight, [0,FRONT,0], rows, cols, [bBotScale,1,1]);
            modBorderWid(true,     0, RIGHT, 0, xLenM,  BBackHeight, [0,BACK,0],  rows, cols, [bBotScale,1,1]);
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
            hull(){modBorderWid(true,     0, LEFT, 0, xLenM, BBackHeight, [0,0,0], rows, cols, [bBotScale,1,1]);}
            if (len(search(rows+1, [for (i = rowRange(cols-1)) i])) == 0){ //check next row to build bridging hull
              hull(){
                modBorderWid(true,     0, LEFT, 0, xLenM, BBackHeight, [0,FRONT,0], rows,   cols, [bBotScale,1,1]);
                modBorderWid(true,     0, LEFT, 0, xLenM, BBackHeight,  [0,BACK,0], rows+1, cols, [bBotScale,1,1]);
              }
            }
          } else {
            hull(){//top height transition hull
              modBorderWid(true,     0, LEFT, 0, xLenM, BFrontHeight, [0,FRONT,0], rows,   cols, [bBotScale,1,1]);
              modBorderWid(true,     0, LEFT, 0, xLenM, BBackHeight,  [0,BACK,0], rows, cols, [bBotScale,1,1]);
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
            hull(){modBorderWid(true,     0, RIGHT, 0, xLenM, BBackHeight, [0,0,0], rows, cols, [bBotScale,1,1]);}
            if (len(search(rows+1, [for (i = rowRange(cols+1)) i])) == 0){ //check next row to build bridging hull
              hull(){
                modBorderWid(true,     0, RIGHT, 0, xLenM, BBackHeight, [0,FRONT,0], rows,   cols, [bBotScale,1,1]);
                modBorderWid(true,     0, RIGHT, 0, xLenM, BBackHeight,  [0,BACK,0], rows+1, cols, [bBotScale,1,1]);
              }
            }
          } else {
            hull(){//top height transition hull
              modBorderWid(true,     0, RIGHT, 0, xLenM, BFrontHeight, [0,FRONT,0], rows,   cols, [bBotScale,1,1]);
              modBorderWid(true,     0, RIGHT, 0, xLenM, BBackHeight,  [0,BACK,0], rows, cols, [bBotScale,1,1]);
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
  for (cols = colRange){
//    echo(cols, FRowZPos(cols+1), FRowZPos(cols),FRowZPos(cols+1)-FRowZPos(cols)); //codition check
//    echo(cols, BRowYPos(cols), BRowYPos(cols-1),BRowYPos(cols)-BRowYPos(cols-1), DipConditionLimit); //codition check
    //BACK
    //Case 1: if Bottom stagger of next column is substantial Back 
    if (BRowYPos(cols+1) - BRowYPos(cols) < BackCase_1Limit && cols+1 != TStart){
//      echo("case B1");
      // if next col is lower by at least half unit THAN bind by webbing b/w BACK side and LEFT
      color("Green")hull(){ //Widwise Transition on Row Init  
        modBorderLen(true,  BACK,     0, 0, xLenM, BBackHeight, [0,0,0], RowInits[cols], cols, [1,bBotScale,1]);
        if (cols != TEnd && cols != CEnd){ //chepa solution to 
          modBorderWid(true,   0,  LEFT, 0, xLenM, BBackHeight, [0,0,0], RowInits[cols+1], cols+1, [bBotScale,1,1]); 
          buildCorner(RowInits[cols+1], cols+1, side1 = BACK, side2 = LEFT, BHeight = BBackHeight, bBotScale = RScale); //Bottom Right row corner   
        }
        //dip condiiton 
        if (BRowYPos(cols) - BRowYPos(cols-1) > DipConditionLimit &&  cols != CStart &&  cols != TStart &&  cols-1 != CEnd){
          modBorderWid(true,   0, RIGHT, 0, xLenM, BBackHeight, [0,0,0], RowInits[cols-1], cols-1, [bBotScale,1,1]);   
          buildCorner(RowInits[cols-1], cols-1, side1 = BACK, side2 = RIGHT, BHeight = BBackHeight, bBotScale = RScale); //Bottom Right row corner
        }
      }
    }
    //Case 2: if bottom stagger of next col is small, simpl hull
    else if (abs(BRowYPos(cols) - BRowYPos(cols+1)) < BackCase_2Limit && cols != CEnd && cols != TEnd){
//      echo("case B2");
      // if next col is lower or higher by less than half unit bind by hulling entire thing
      color("DodgerBlue")hull(){
        modBorderLen(true, BACK,    0, 0, xLenM, BBackHeight, [0,0,0], RowInits[cols], cols, [1,bBotScale,1]);
        modBorderLen(true, BACK,    0, 0, xLenM, BBackHeight, [0,0,0], RowInits[cols+1], cols+1, [1,bBotScale,1]);
      
      //dip condiiton        
        if (BRowYPos(cols) - BRowYPos(cols-1) > DipConditionLimit &&  cols != CStart &&  cols != TStart &&  cols-1 != CEnd){
          modBorderWid(true,   0, RIGHT, 0, xLenM, BBackHeight, [0,0,0], max(RowInits[cols]-1,0), cols-1, [bBotScale,1,1]);   
          buildCorner(max(RowInits[cols]-1,0), cols-1, side1 = BACK, side2 = RIGHT, BHeight = BBackHeight, bBotScale = RScale); //Bottom Right row corner
        }
      }
    }    
    //Case 3: catch condition
    else if(cols != CEnd && cols != TEnd) {
//      echo("case B3");
      color("Orange")hull(){
        modBorderLen(true, BACK,    0, 0, xLenM, BBackHeight, [RIGHT,0,0], RowInits[cols], cols, [1,bBotScale,1]);
        modBorderLen(true, BACK,    0, 0, xLenM, BBackHeight, [LEFT,0,0], RowInits[cols+1], cols+1, [1,bBotScale,1]);
      }
    }
    //Front Side
    //Case 1: if change in col stagger is Small enough, hull entirely to next column
    if (abs(FRowYPos(cols+1) - FRowYPos(cols)) < FrontCase_1Limit && cols != CEnd && cols != TEnd){
//      echo("case F1");
      color("Navy")hull(){ //Widwise Transition on Row Init  
        modBorderLen(true, FRONT,    0, 0, xLenM, BFrontHeight, [0,0,0], RowEnds[cols], cols, [1,bBotScale,1]);
        if (RowEnds[cols]+1 <= RowEnds[cols+1]){ // if next column has more row above
          modBorderWid(true,     0, LEFT, 0, xLenM,  BFrontHeight, [0,0,0], RowEnds[cols]+1, cols+1, [bBotScale,1,1]);  
        }else {
          modBorderLen(true, FRONT,    0, 0, xLenM,  BFrontHeight, [0,0,0], RowEnds[cols+1], cols+1, [1,bBotScale,1]);    
        }
      }
    } 
    //Case 2: if col+1 stagger is higher and is substantial, hull to col top to col+1 edge
    //TODO: add height conditions, and add corner 
    else if (FRowYPos(cols+1) - FRowYPos(cols) > FrontCase_2Limit && cols != CEnd){
//      echo("case F2");
      color("RED")hull(){
        //col hull 
        if (FRowZPos(cols+1)-FRowZPos(cols) > TransitionHeightLimit){// next transition is too high, use edge 
//            echo("case 2 high diff @ C", FRowZPos(cols+1)-FRowZPos(cols));
          modBorderLen(true, FRONT, 0, 0, xLenM, BFrontHeight, [RIGHT,0,0], RowEnds[cols], cols, [1,bBotScale,1]); 
        } else {
          modBorderLen(true, FRONT, 0, 0, xLenM, BFrontHeight, [0,0,0], RowEnds[cols], cols, [1,bBotScale,1]); 
        }
        //col+1 hull
        if (RowEnds[cols+1] > RowEnds[cols]){// if next col has more Rows, bind to next rows rather than max 
          modBorderWid(true, 0, LEFT, 0, xLenM, BFrontHeight, [0,0,0], RowEnds[cols]+1, cols+1, [bBotScale,1,1]);     
        }else {
          if (FRowZPos(cols)-FRowZPos(cols+1) > TransitionHeightLimit){// if height difference is great bind to left side only to avoid excessive artifacts
//            echo("case 2 high diff @ C", cols);
            modBorderLen(true, FRONT, 0, 0, xLenM, BFrontHeight, [0,0,0], RowEnds[cols+1], cols+1, [1,bBotScale,1]);  
          } else {
            modBorderLen(true, FRONT, 0, 0, xLenM, BFrontHeight, [LEFT,0,0], RowEnds[cols+1], cols+1, [1,bBotScale,1]);              
          }
        }
      }
    }   
    //Case 3: if col+1 stagger is lower and is substantial, hull to col edge to col+1 top 
    else if (FRowYPos(cols+1) - FRowYPos(cols) < -unit/2 && cols != CEnd && cols != TEnd){
//      echo("case F3");
      //part 1 Edge 
      color("Blue")hull(){
        if (RowEnds[cols] > RowEnds[cols+1]){ //if current col has more rows bind to next RowEnd+1 of next col
          if(RowEnds[cols+1]+1 == RowEnds[cols]){ // if hightest row add transition and corner
            buildCorner(RowEnds[cols], cols, side1 = FRONT, side2 = RIGHT, BHeight = BFrontHeight, bBotScale = RScale);
          } else {
            modBorderWid(true,     0, RIGHT, 0, xLenM, BBackHeight,   [0,0,0], RowEnds[cols+1]+1, cols, [bBotScale,1,1]);  
          }  
        } else {
//          modBorderWid(true,     0, RIGHT, 0, xLenM, BFrontHeight, [0,0,0], RowEnds[cols], cols, [bBotScale,1,1]); 
          buildCorner(RowEnds[cols], cols, side1 = FRONT, side2 = RIGHT, BHeight = BFrontHeight, bBotScale = RScale);
        }
        modBorderLen(true, FRONT,     0, 0, xLenM, BFrontHeight, [0,0,0], RowEnds[cols+1], cols+1, [1,bBotScale,1]);  
      }
      //edge bind if col row > col +1 rows  
      color("Blue")hull(){
        if (RowEnds[cols] > RowEnds[cols+1]){ //if current col has more rows bind to next RowEnd+1 of next col
          if(RowEnds[cols+1]+1 == RowEnds[cols]){ // if hightest row add transition and corner
            modBorderWid(true,     0, RIGHT, 0, xLenM, BFrontHeight, [0,FRONT,0], RowEnds[cols], cols, [bBotScale,1,1]);        
            modBorderWid(true,     0, RIGHT, 0, xLenM, BBackHeight,   [0,BACK,0], RowEnds[cols], cols, [bBotScale,1,1]);   
          } else {
           
            
          }
          modBorderLen(true, FRONT,     0, 0, xLenM, BFrontHeight, [LEFT,0,0], RowEnds[cols+1], cols+1, [1,bBotScale,1]);  
        }
      } 
    } 
    //Case 4: catch condition 
    else if (cols != CEnd && cols != TEnd){  
//      echo("case F4");
      color("MidnightBlue")hull(){ //Widwise Transition on Row Init
        if (FRowZPos(cols+1)-FRowZPos(cols) > TransitionHeightLimit){ //Hullface adjustment when encountering large height difference 
          modBorderLen(true, FRONT,    0,       0, xLenM,  BFrontHeight, [RIGHT,0,0], RowEnds[cols], cols, [1,bBotScale,1]);  
          modBorderLen(true, FRONT,    0,       0, xLenM,  BFrontHeight, [0,0,0], RowEnds[cols+1], cols+1, [1,bBotScale,1]); 
          if(RowEnds[cols] > RowEnds[cols+1]){
            modBorderWid(true,     0, RIGHT, 0, xLenM, BFrontHeight, [0,FRONT,0], RowEnds[cols], cols, [bBotScale,1,1]);        
            modBorderWid(true,     0, RIGHT, 0, xLenM, BBackHeight,   [0,BACK,0], RowEnds[cols], cols, [bBotScale,1,1]);   
          } 
        } else if (FRowZPos(cols+1)-FRowZPos(cols) < TransitionHeightLimit){
            modBorderLen(true, FRONT,    0,       0, xLenM,  BFrontHeight, [RIGHT,0,0], RowEnds[cols], cols, [1,bBotScale,1]);  
            modBorderLen(true, FRONT,    0,       0, xLenM,  BFrontHeight, [0,0,0], RowEnds[cols+1], cols+1, [1,bBotScale,1]);  
        }else{
          modBorderLen(true, FRONT,    0,       0, xLenM,  BFrontHeight, [0,0,0], RowEnds[cols], cols, [1,bBotScale,1]);
          modBorderLen(true, FRONT,    0,       0, xLenM,  BFrontHeight, [0,0,0], RowEnds[cols+1], cols+1, [1,bBotScale,1]);  
        }
      }
    }
  }
}

//support module to build bottom enclosure.
module hullEnclusure(){
  hull(){
    rotate(tenting)translate([0,0,plateHeight])hull(){
      children([0:$children-1]);
    }
    linear_extrude(1)projection()rotate(tenting)translate([0,0,plateHeight])hull(){
      children([0:$children-1]);
    }
  }
}

module transEnclose(){
  rotate(tenting)translate([0,0,plateHeight]){
      children([0:$children-1]);
  }
}

module projectEnclose(thickness = .5, height = 0, projectionCut = false){
  translate([0,0,height])linear_extrude(thickness)projection(cut = projectionCut)rotate(tenting)translate([0,0,plateHeight])hull(){
    children([0:$children-1]);
  }
}

module USBPort(Length = 1){
  rotate([0,90,90])hull(){
    translate([0,-4,0])cylinder(d = 6, Length);
    translate([0,4,0])cylinder(d = 6, Length);   
  }
}

module BuildBottomEnclosure(struct = Eborder, JackType = true, MCUType = true)
{  
  //submodule for calling the correct border modulation module and passing Parameters  
  module modBorder(structID = 0, surfaceID = 0, subStructID = 0){
    if (struct[structID][surfaceID][subStructID][2] == true){ //check logic for Width or Length Wise Modulation
      modBorderWid(
        Hulls = true,
        sides = 0,
        refSides = struct[structID][surfaceID][subStructID][3], 
        dimClip = 0, 
        refClip = xLenM, 
        height = BBackHeight, 
        hullSides = [struct[structID][surfaceID][subStructID][4][0],struct[structID][surfaceID][subStructID][4][1],0], 
        rows = struct[structID][surfaceID][subStructID][1], 
        cols = struct[structID][surfaceID][subStructID][0], 
        scaling = struct[structID][surfaceID][subStructID][5]
      );
    } else {
      modBorderLen(
        true,
        struct[structID][surfaceID][subStructID][3], 
        0, 
        0, 
        xLenM, 
        BBackHeight, 
        [struct[structID][surfaceID][subStructID][4][0],struct[structID][surfaceID][subStructID][4][1],0], 
        struct[structID][surfaceID][subStructID][1], 
        struct[structID][surfaceID][subStructID][0], 
        struct[structID][surfaceID][subStructID][5]
      );
    }
  }
  module EnclosureSection(ID = 0) {
    hull(){
      for (j = [0:len(struct[ID][0])-1]) {//itt through top surface list
        transEnclose(){modBorder(structID = ID, surfaceID = 0, subStructID = j);}
      }
      for (k = [0:len(struct[ID][1])-1]) {//itt throgh bottom projection list
        projectEnclose(){modBorder(structID = ID, surfaceID = 1, subStructID = k);}
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
            translate(mountScrew[i])cylinder(d = mountDia*1.5, 7, $fn = 16); // Mount Screw 
            translate([0,0,-midHeight])linear_extrude(.01)projection(true)translate([0,0,midHeight])EnclosureSection(ID = mountHull[i]); // Prjected section of enclosure to be hulled
            for (k = [0:len(struct[mountHull[i]][1])-1]){ // bottom of enclosure section to hull
              projectEnclose(.5){modBorder(structID = mountHull[i], surfaceID = 1, subStructID = k);}
            }
          }
        }
      }
      
      if(JackType == true){
      //housing for Connectors
      }
      
      if(MCUType == true){
      //housing for MCU
      }
      
      //TODO: Mountiong Screw Posts
      //for(i = [0:len(PostPositions)-1]){
      //}
      
      //TODO: trackball modules?

    }  
    //CUTS
    //Mounts
    for(i = [0:len(mountScrew)-1]){
       translate([0,0,-1])translate(mountScrew[i])cylinder(d = mountDia, 7, $fn = 32);
    }
    
    if(JackType == true){
      translate(TRRSLoc)rotate(TRRSAng)cube(TRRSDim, center = true);
      translate(TRRSLoc+[0,14,0])rotate(TRRSAng+[90,0,90])cylinder(d = 8, 15, center= true);
    }
    
    if(MCUType == true){
      translate(MCULoc)cube(MCUDim, center = true);
      translate(USBLoc)USBPort(20);
    }
    //TODO: trackball modules?
   
  }
}

//generate Bottom Plate for mounting MCU, Jacks and weights?
module BuildBottomPlate(struct = Eborder, aStruct = addCuts, hullList = Hstruct, JackType = true, MCUType = true, Mount = false)
 {
  //submodule for calling the correct border modulation module and passing Parameters  
  //TODO: repeating module! clean up
  module modBorder(structID = 0, surfaceID = 0, subStructID = 0){
    if (struct[structID][surfaceID][subStructID][2] == true){ //check logic for Width or Length Wise Modulation
      modBorderWid(
        Hulls = true,
        sides = 0,
        refSides = struct[structID][surfaceID][subStructID][3], 
        dimClip = 0, 
        refClip = xLenM, 
        height = BBackHeight, 
        hullSides = [struct[structID][surfaceID][subStructID][4][0],struct[structID][surfaceID][subStructID][4][1],0], 
        rows = struct[structID][surfaceID][subStructID][1], 
        cols = struct[structID][surfaceID][subStructID][0], 
        scaling = struct[structID][surfaceID][subStructID][5]
      );
    } else {
      modBorderLen(
        true,
        struct[structID][surfaceID][subStructID][3], 
        0, 
        0, 
        xLenM, 
        BBackHeight, 
        [struct[structID][surfaceID][subStructID][4][0],struct[structID][surfaceID][subStructID][4][1],0], 
        struct[structID][surfaceID][subStructID][1], 
        struct[structID][surfaceID][subStructID][0], 
        struct[structID][surfaceID][subStructID][5]
      );
    }
  }
   difference(){
    union(){
      for (i = [0:len(hullList)-1]){  
        hull(){
          for (j = [0:len(hullList[i])-1]) {
            for (k = [0:len(struct[j][1])-1]){
              projectEnclose(3){modBorder(structID = hullList[i][j], surfaceID = 1, subStructID = k);}
            }
          }
        }
      }
      if(JackType == true){
        translate(TRRSLoc+[0,-2.5,-2])rotate(TRRSAng)cube(TRRSDim+[5,5,-4], center = true);
      }
      
      if(MCUType == true){
        translate(MCULoc+[0,-2.5,-1])cube(MCUDim+[5,5,2], center = true);
      }
      //TODO: trackball modules?
    }  
    
    //CUTS
    for (i = [0:len(struct)-1]){  //expanded to cut artifacts from hulling higher than bottom enclosure edges
      translate([0,0,-.02])scale(1.02)hull(){
        for (k = [0:len(struct[i][1])-1]) {//itt throgh bottom projection list
          projectEnclose(thickness = 4){modBorder(structID = i, surfaceID = 1, subStructID = k);}
        }
      }
    }
      for (i = [0:len(addCuts)-1]){  
        translate([0,0,-.02])scale(1.02)hull(){
          for (j = [0:len(addCuts[i])-1]) {
            for (k = [0:len(struct[j][1])-1]){
              projectEnclose(3){modBorder(structID = addCuts[i][j], surfaceID = 1, subStructID = k);}
            }
          }
        }
      }
    for (i = [0:len(struct)-1]){  // cut wedge from enclosure
      translate([0,0,-.02])scale(1.001)hull(){
        for (j = [0:len(struct[i][0])-1]) {//itt through top surface list
          transEnclose(){modBorder(structID = i, surfaceID = 0, subStructID = j);}
        }
        for (k = [0:len(struct[i][1])-1]) {//itt throgh bottom projection list
          projectEnclose(){modBorder(structID = i, surfaceID = 1, subStructID = k);}
        }
      }
    }
//    if(Text == true){
//      #translate([15,10,-.02])mirror([1,0,0])linear_extrude(height = 0.5)text( text = "HYPOWARP", font = "Constantia:style=Bold", size = 12, valign = "center", halign = "center" );
//    }
    if(Mount == true){
      for(i = [0:len(mountScrew)-1]){
        translate([0,0,0])translate(mountScrew[i])cylinder(d1 = mountDia*2, d2 = mountDia, 2.8, $fn = 32);
        translate([0,0,-.5])translate(mountScrew[i])cylinder(d = mountDia, bpThickness+1, $fn = 32);
      }
    }
    if(JackType == true){
      translate(TRRSLoc)rotate(TRRSAng)cube(TRRSDim, center = true);
      translate(TRRSLoc+[0,14,0])rotate(TRRSAng+[90,0,90])cylinder(d = 8, 10, center= true);
    }
    
    if(MCUType == true){
      translate(MCULoc)cube(MCUDim, center = true);
      translate(USBLoc)USBPort(20);
    }
    //TODO: trackball modules?
  }
}
//--- Misc

//--- TrackBall
step = 5;

module PCB(){
  tol = .05;
  PL = 21/2+tol;
  PW = 18.6/2+tol;
  PT = 3;
  PCBT = 1.6;
  
  //Prism  
  translate([0,0,-PT])linear_extrude(PT)rounding(r=8)polygon([[PL,PW],[-PL,PW],[-PL,-PW],[PL,-PW]]);
  translate([PL-6,0,.5])cube([2,4,1],center= true);
  
  //PCB
  translate([0,0,-.8-PT])cube([28,21,PCBT],center= true);
  translate([24/2,0,-PT-PCBT-2])cylinder(d=2.44, 10);
  translate([-24/2,0,-PT-PCBT-2])cylinder(d=2.44, 10);
  
  //Apeture
  translate([0,0,0])cylinder(d1=5, d2= 12, 4);
}
//Path function. 
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
  path_transforms3 =  [for (t=[0:step:180]) translation(oval_path3(t,-20,a,c,b,-30,1,0))*rotation([90,20+20*sin(t),t])];   
  path_transforms4 =  [for (t=[0:step:360]) translation(oval_path3(t,-40,a,c,b,0,1,0))*rotation([90,40+sin(t),t])];  
   
 translate([0,0,-1]){ 
  rotate([-90,0,0])sweep(shape(), path_transforms);
  rotate([90,0,-90])sweep(shape(), path_transforms2); //tip
  rotate([90,0,90])sweep(shape(), path_transforms2);  //tip
  rotate([-90,0,0])sweep(shape(), path_transforms3); 
 }
 //support ring
 rotate([0,0,0])sweep(shape2(), path_transforms4); 
}
PCBA = [0,0,0];
rbearing = .5;
module TrackBall(){
  difference(){
    union(){
     palm_track();
//     rotate(PCBA)translate([0,0,-trackR-1])cube([30,22,8],center= true); // pcb housing
    }
      
   sphere(d= trackR*2+.5); 
    //bearing holes

    //lower bearing
    for(i= [0:2])rotate([0,40,120*i-90])translate([trackR,0,0])sphere(r=rbearing); //upper bearing for tighter fit?
    for(i= [0:1])rotate([0,-10,180*i])translate([trackR,0,0])sphere(r=rbearing); //upper bearing for tighter fit?
    #rotate(PCBA)translate([0,0,-42/2])PCB();
  }
}


//Key Switches and Caps 
module BuildSet(switchType, capType = Cherry, colors, stemcolor)
{
  for(cols = [CStart:CEnd]){
    for(rows = [RowInits[cols]:RowEnds[cols]]){
      PlaceRmCn(rows, cols)
      if(SwitchOrientation[rows][cols] == true){Switch(type = switchType, CapColor = colors, StemColor = stemcolor, clipLength = Clipped[rows][cols]);}
      else {rotate([0,0,-90])Switch(switchScale = [CapScale[rows][cols],1,1],type = switchType, CapColor = colors, StemColor = stemcolor, clipLength = Clipped[rows][cols]);}
    }
  }
  for(cols = [TStart:TEnd]){
    for(rows = [RowInits[cols]:RowEnds[cols]]){
      PlaceRmCn(rows, cols)
      if(SwitchOrientation[rows][cols] == true){scale([1.0,1.0,1])Switch(type = switchType, CapColor = colors, StemColor = stemcolor, clipLength = Clipped[rows][cols]);}
      else {rotate([0,0,-90])scale([1.0,1,1])Switch(switchScale = [CapScale[rows][cols],1,1],type = switchType, CapColor = colors, StemColor = stemcolor, clipLength = Clipped[rows][cols]);}
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
//module OutSet()
//{
//  for(cols = [CStart:CEnd]){
//    for(rows = [RowInits[cols]:RowEnds[cols]]){
//      PlaceRmCn(rows, cols)
//    }
//  }
//  for(cols = [TStart:TEnd]){
//    for(rows = [RowInits[cols]:RowEnds[cols]]){
//      PlaceRmCn(rows, cols)
//    }
//  }
//}

//Apply Color to Build
module PaintColor(colorBool = false){
  if( colorBool == false){
    color("lightslateGrey")children();
  }else {
    children();
  }
}

  
  
  
  
  
  
  
  
 