/*
MINIWARP
Designer: Pseudoku
Summary:  (5x3)+3 MX profile
Concept:  
          
TODOs:
*/
//-----  Enum
R0 = 0; //bottom row
R1 = 1;
R2 = 2;
R3 = 3;
R4 = 4;
R5 = 5;

C0 = 0; //Column
C1 = 1;
C2 = 2;
C3 = 3;
C4 = 4;
C5 = 5;
C6 = 6;
C7 = 7; //Extend if you wish 
T0 = 8; //Thumb
T1 = 9;
T2 = 10;
T3 = 11;
T4 = 12; //Extend if you need more 

//Modulation Reference
FRONT  =  1;
RIGHT  = -1;
BACK   = -1;
LEFT   =  1; 
TOP    =  1;
BOTTOM = -1;

//Enum Switch Type
MX   = 0;  // Generic MX
Choc = 1;  // Low profile 
Alps = 2;  // For Your Superiority Complex's Needs

//Switch cutawy Type
Cherry = 0;
Box    = 1; 

//Cap type applys to MX only?
//Cherry = 0;
DSA = 1;
SA  = 2;
MT3 = 3;

//-----   Grid parameters
unit           = 19.05;  // cherry unit length spacing
Tol            = 0.01;   // tolance
HullThickness  = 0.01;   // modulation hull thickness
TopHeight      = 0;      // Reference Origin of the keyswitch 
BottomHeight   = 3.6;    // height adjustment used for R0 keys for cherry types

SwitchWidth    = 15.6;   // switch width 
PlateOffsets   = 3.5;    // additional pading on width of plates
PlateOffsetsY  = 3.5;    // additional padding on lenght of plates
PlateThickness = 3.5;    // switch plate thickness
PlateDim       = [SwitchWidth+PlateOffsets, SwitchWidth+PlateOffsetsY, PlateThickness];
PlateHeight    = 6.6;    //
SwitchBottom   = 4.8;    // from plate 
WebThickness   = PlateDim[0] - 2; // inter column hull inward offsets, 0 thickness results in poor plate thickness

//-----    Enclusure and plate parameter
RScale       = 1;                // Rim bottom scaling
EScale       = 1;                // Enclosure bottom scaling
PBuffer      = 0;                // additional Plate thickness
BorderAlign  = BOTTOM;           // high pro or flushed
Bthickness   = PlateDim[0] - 4;  // thickness of the enclosure rim 
BFrontHeight = 0;                // Height of frontside of the enclosure rim 
BBackHeight  = 0;                // Height of Backside of the enclosure rim 
TFrontHeight = 0;
TBackHeight  = 0;
T0Buffer     = 0;                       //Additional Plate thickness buffer for T0 position.
T0BackH      = BBackHeight + T0Buffer;  //Adjuted height for T0
holeOffset   = 0;

//-----  Bottom Enclosure Offsets: Adjust how bottom casing offset from top plate
LeftOffset  = .5;
FrontOffset = .5;
RightOffset = 0;
BackOffset  = -.75;
ThumbOffset = .2; 

//-----     Tenting Parameters
tenting     = [-10,12,0]; // tenting for enclusoure  
plateHeight = 27;       // height adjustment for enclusure 

//-----     Trackball Parameters
//40mm
//trackR      = 20;        //trackball raidus  M570: 34mm, Ergo and Kennington: 40mm
//trackOrigin = [-17,-25,-8]; //trackball origin
//trackTilt   = [75,0,-80];    //angle for tilting trackpoint support and PCB
//34mm 
trackR      = 17;        //trackball raidus  M570: 34mm, Ergo and Kennington: 40mm
trackOrigin = [-19.5,-31, 2]; //trackball origin
trackTilt   = [65,10,-70];    //angle for tilting trackpoint support and PCB
//
//trackOrigin = [-16.0,-23,5]; //trackball origin
//trackTilt   = [65,10,-90];    //angle for tilting trackpoint support and PCB
SensorRot   = [-10,0,0];   
PCBCaseDim  = [30,22,5];
rbearing    = 1;           //bearing radius
step        = 5;           //housing resolustion
//-----     Rotary Encoder
RELoc       = [];
REAng       = [];
RER         = 20;

//-----     Bottom Plate Parameters
////
bpThickness =  3; //Bottom Plate Thickness
midHeight   = -7; // used to generate hull between mount and enclosure  

mountScrew  = [[-20,-35,0],[45,-2,0],[-40,60,0],[60,55,0]];
mountHull   = [27,22,8,15];
mountDia    = 5; //mm
screwholeDia= 3; //mm 
screwtopDia = 6; //mm

MCUDim      = [18.5, 32.5, 1.2];
MCULoc      = [-18,53,7.1];
resetLoc    = [0,0,0]; 
USBLoc      = [-18,49-5+32.5/2,6+1.2];

JackLoc     = [-38,21,7];
JackDim     = [18,6,10];
JackAng     = [0,0,180];
//-------  LAYOUT parameters
//column loop setter
CStart   = C1;  // Set column to begin looping for the build
CEnd     = C5;  // Set column to end for the build
TStart   = T1;  // Set Thumb Cluster Colum to begin
TEnd     = T2;  // Set Thumb Cluster to end 
colRange = concat([for (i = [CStart:CEnd]) i], [for (i = [TStart:TEnd]) i]); //columnar for loop range 
  
//
ColumnOrigin = [//[translation vec]       [Global Rot]    [Local Rot]
                [[   -54, -unit*3/4,   1], [ 0,   0,   0], [ 0, 90,  0]], //INDEX 1 
                [[ -unit, -unit*3/8,  -0], [ 0,   0,   3], [ 0, 90,  0]], //INDEX 2 
                [[ -unit, -unit*3/8,  -0], [ 0,   0,   3], [ 0, 90,  0]], //INDEX 3 
                [[     0,    unit/8,  -5], [ 0,   0,   0], [ 0, 90,  0]], //MIDDLE 
                [[  unit,   -unit/8,   2], [ 0,   5,  -5], [ 0, 90,  0]], //RING 
                [[unit*2, -unit*3/8,  10], [-3,  10, -12], [ 0, 90,  0]], //PINKY 1 
                [[  41.0, -unit*5/8,   8], [ 0,  10, -18], [ 0, 90,  0]], //PINKY 2 
                [[  67.0, -unit*5/8,  21], [ 0,  15, -15], [ 0, 90,  0]], //PINKY 3                 
                [[   -63,       -23, -23], [ 0,   0,  10], [-5, 95,  0]], //Thumb Outer 
                [[   -46,       -22, -23], [ 0,   0,   0], [ 0, 90,-60]], //Thumb OuterMid
                [[   -46,       -22, -23], [ 0,   0,   0], [ 0, 90,-60]], //Thumb Midlde
                [[   -36,       -22, -14], [ 0,   0,   0], [ 0, 90,-60]], //Thumb InnerMid
                [[    20,   -unit/8,   0], [ 0,   0, -10], [ 0, 90,  0]]  //Ring Rotary Encoder           
               ];

ThumbShift  = [[12,-16, 15],[ 0, -5,-3],[ 0, 0, 0]]; //global transform for thumb cluster to jog as whole rather than editing origin

//-------  and adjustment parameters 

//row loop setter
//              C0:i1 C1:i2 C2:i3  C3:m  C4:r C5:p1 C6:p2 C7:p3 T0:Ot T1:OM T2:Md  T3:IM  T4:In
RowInits    = [   R2,    R1,   R1,   R1,   R1,   R1,   R2,   R0,   R2,   R2,    R1,   R1,    R0]; //set which Row to begin
RowEnds     = [   R2,    R3,   R3,   R3,   R3,   R3,   R2,   R0,   R2,   R2,    R2,   R1,    R0]; //set which Row to end

//Row transforms
RowTrans    = [[ -.18, -.18, -.10, -.10, -.10, -.55, -.55, -.55, -1.0,-1.25,-1.25,     0,     0], //R0
               [  .80,  .85,  .85,  .85,  .85,  .85,  .45,  .45,    0,  -.1,  -.0,     0,     0], //R1s
               [ 1.95, 2.10, 2.10, 2.10, 2.10, 2.10, 2.05, 1.60, 0.95, 0.95,  .95,     0,   3.2], //R2s 
               [ 2.90, 3.17, 3.15, 3.15, 3.15, 3.15, 2.55, 2.55,    0,    0,    0,     0,     0], //R3s
               [ 3.80, 3.80, 3.80, 3.80, 3.80,    1,  .83,    3,    0,    0,    0,     0,     0], //R4
               [ 4.45, 4.45, 4.45, 4.45, 4.45,    4,   -4,    4,    0,    0,    0,     0,     0]  //R5           
              ]*unit; 

ColTrans    = [[    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0], //R0
               [    0,-1.08,    0,    0,    0,   .0,   .5,    0,    0,   .0,   .21,    0,   1.1], //R1s
               [    0,-1.08,    0,    0,    0,    0,    1,    0, -.30,  -.42,   .8,    0,   .25], //R2s 
               [    0,-1.08,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0], //R3s
               [    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0], //R4
               [    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0]  //R5           
              ]*unit; 
              
Pitch       = [[   25,   25,   25,   10,   10,   10,   25,   25,   10,   10,  -10,     0,     0],  //R0
               [   15,   18,   18,   18,   18,   18,   15,   15,   20,   20,  -35,     0,     0],  //R1s
               [  -15,  -15,  -15,  -15,  -15,  -15,  -30,  -15,  -25,  -25,  -25,     0,     0],  //R2s 
               [  -25,  -48,  -48,  -48,  -48,  -48,  -25,  -25,    0,  -05,    0,     0,     0],  //R3
               [  -45,  -45,  -45,  -45,  -45,    0,    0,    0,    0,    0,    0,     0,     0],  //R4
               [  -58,  -58,  -58,  -58,  -58,    0,    0,    0,    0,    0,    0,     0,     0]   //R5
              ];

Roll        = [[   -4,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0],  //R0
               [   -5,   -0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,    85],  //R1s
               [   -0,    0,    0,    0,    0,   -0,   25,    0,  -15,  -16,   16,     0,     0],  //R2s 
               [   -7,   -0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0],  //R3
               [   -8,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0],  //R4
               [   -10,   0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0]   //R5
              ];         
              
Height      = [[ -6.5, -6.5, -6.5,-3.65,-3.65, -6.5, -6.5, -6.5,    1,    0,    7,     0,     0],  //R0
               [    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,   10,     0,     5],  //R1s
               [    0,   .7,   .7,   .7,   .7,   .7, -7.1,    0, 1.85, 1.86,    2,     0,     0],  //R2s 
               [ -6.5,-11.8,-11.8,-11.8,-11.8,-11.8, -6.5, -6.5,    0,   -0,    0,     0,     0],  //R3
               [  -18,  -18,  -18,  -18,  -18,    0,    0,    0,    0,    0,    0,     0,     0],  //R4
               [  -33,  -33,  -33,  -33,  -33,    0,    0,    0,    0,    0,    0,     0,     0]   //R5
              ]; 
CapScale     =[[   1,     1,    1,    1,    1,    1,    1,    1,    1,    1,    1,     1,    1],  //R0
               [   1,     1, 1.00,    1,    1, 1.00,    1,    1,    1,    1,  1.5,     1,    1],  //R1s
               [   1,     1,    1,    1,    1,    1,    1,    1,    1,    1,    1,     1,    1],  //R2s 
               [   1,     1,    1,    1,    1,    1,    1,    1,    1,    1,    1,     1,    1],  //R3
               [   1,     1,    1,    1,    1,    1,    1,    1,    1,    1,    1,     1,    1],  //R4
               [   1,     1,    1,    1,    1,    1,    1,    1,    1,    1,    1,     1,    1]   //R5
              ];
SwitchOrientation = //if length-wise true 
              [[ true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true],  
               [ true,  true,  true,  true,  true,  true, false, false,  true,  true,  true,  true,  true],
               [ true,  true,  true,  true,  true,  true, false, false,  true,  true,  true,  true,  true],
               [ true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true],
               [ true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true],
               [ true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true]
              ]; 
SwitchTypes = //MX | Choc
              [[   MX,    MX,    MX,    MX,    MX,    MX,    MX,    MX,  MX,  MX,  MX,  MX,  MX],
               [   MX,    MX,    MX,    MX,    MX,    MX,    MX,    MX,  MX,  MX,  MX,  MX,  MX],
               [   MX,    MX,    MX,    MX,    MX,    MX,    MX,    MX,  MX,  MX,  MX,  MX,  MX],
               [   MX,    MX,    MX,    MX,    MX,    MX,    MX,    MX,  MX,  MX,  MX,  MX,  MX],
               [   MX,    MX,    MX,    MX,    MX,    MX,    MX,    MX,  MX,  MX,  MX,  MX,  MX],
               [   MX,    MX,    MX,    MX,    MX,    MX,    MX,    MX,  MX,  MX,  MX,  MX,  MX],
              ];
//-----     border Customization

TopCuts = [
//            [C2, R1, [0,FRONT,0], C1, R2, [0,BACK,0]],
//            [C5, R1, [0,FRONT,0], C6, R2, [0,BACK,0]],
//            [T1, R1, [0,FRONT,0], T0, R2, [0,BACK,0]],
          ];
/*
depriciated since most of layounts utlizes custom
//// define Columns will needs Left or Right borders not catched by Generic calls 
//Lborder    = [[], //R0
//               [], //R1
//               [], //R2
//               [], //R3
//               [], //R4 
//               []  //R5
//              ]; //color "DarkGreen"
//Rborder    = [[], //R0
//               [], //R1
//               [], //R2
//               [], //R3
//               [], //R4
//               []  //R5
//              ]; //color "YellowGreen"
//
*/
PBind      = [ //generater binds between specified columns and the next. you can specify face to minimize artifacts or hull web rectangular body to increase thickness
              //[column, Cn hull face, Cn+1 hull face] 
               [C1,RIGHT, LEFT],
               [C2,    0, LEFT],
               [C3,RIGHT, 0],
               [C4,RIGHT, 0], 
//               [C5,RIGHT, 0], 
//               [C6,RIGHT, 0], 
//               [C7,RIGHT, 0], 
//               [T0,RIGHT, 0], 
//               [T1,RIGHT, 0], 
//               [T2,RIGHT, 0], 
//               [T3,RIGHT, 0], 
             ]; 

PlateCustomBind  = //fine tune edges and missing binds by specifing key position and face|edge|pseudo-point  
  [
//   //Ring to Pinkie
//  [[T0,R2,RIGHT,[0,0,0],0],
//    [T1,R2,LEFT, [0,0,0],0]],
//    
//  [[T0,R2,RIGHT,[RIGHT,BACK,0],0],
//    [T2,R1,LEFT, [0,0,0],0]],
//    
    [[T1,R2,LEFT, [0,BACK,0], 0],
     [T2,R1,LEFT, [0,0,0],    0]
    ],
    
    [[T1,R2,LEFT,  [0,BACK,0],  0],
     [T1,R2,RIGHT, [0,BACK,0],  0],
     [T2,R1,LEFT,  [0,FRONT,0], 0]
    ],

    [[T1,R2,RIGHT, [0,BACK,0],  0],
     [T2,R1,LEFT,  [0,FRONT,0], 0],
     [T2,R2,LEFT,  [0,BACK,0],  0]
    ],
     
    [[T1,R2,RIGHT, [0,0,0], 0],
     [T2,R2,LEFT,  [0,0,0], 0]
    ],
  ]; 
  

//define Spical border Hull to make border pretty
//fill missed hull from enclosure builder
// use scale to if you want tapered edges
Sborder = //color "Crimson"
 [
//[[Col, Row, len = true, Jog direction, HullFace, Scale], ...], 
//Front

  [[C1, RowEnds[C1], false,FRONT, [0,0,0],    [1,RScale,1]]], //fill gap between general border and Bottom Enclosure near C1

  [[C1, RowEnds[C1], false,FRONT, [RIGHT,0,0],[1,RScale,1]], //fill gap between general border and Bottom Enclosure near C1
   [C2, RowEnds[C2], false,FRONT, [LEFT,0,0], [1,RScale,1]] ],
   
  [[C2, RowEnds[C2], false,FRONT, [0,0,0],    [1,RScale,1]], //fill gap between general border and Bottom Enclosure near C3
   [C3, RowEnds[C3], false,FRONT, [LEFT,0,0], [1,RScale,1]] ], 
   
  [[C3, RowEnds[C3], false,FRONT, [0,0,0], [1,RScale,1]]],

  [[C3, RowEnds[C3], false,FRONT, [RIGHT,0,0], [1,RScale,1]],
   [C4, RowEnds[C4], false,FRONT, [0,0,0],     [1,RScale,1]]],
   
  [[C4, RowEnds[C4], false,FRONT, [RIGHT,0,0], [1,RScale,1]], //fill gap between general border and Bottom Enclosure near C4
   [C5, RowEnds[C5], false,FRONT, [0,0,0],     [1,RScale,1]]],
   
  [[C5, RowEnds[C5], false,FRONT, [RIGHT,0,0], [1,RScale,1]]],
  //corner
  [[C4, RowEnds[C4], false,FRONT, [RIGHT,0,0], [1,RScale,1]], //fill gap between general border and Bottom Enclosure near C1
   [C4, RowEnds[C4], true, RIGHT, [0,FRONT,0], [RScale,1,1]],],
  //corner
////  [[CEnd, RowEnds[CEnd], false,FRONT, [RIGHT,0,0], [1,RScale,1]], //fill gap between general border and Bottom Enclosure near C1
////   [CEnd, RowEnds[CEnd], true, RIGHT, [0,FRONT,0], [RScale,1,1]],],
   
   //BACK
 
  [[C1, RowInits[C1], false,BACK, [RIGHT,0,0],     [1,RScale,1]],
   [C2, RowInits[C2], false,BACK, [0,0,0],     [1,RScale,1]]],   
   
//  [[C2, RowInits[C2], false,BACK, [0,0,0],     [1,RScale,1]]],
//  
  [[C2, RowInits[C2], false,BACK, [RIGHT,0,0], [1,RScale,1]], //fill gap between general border and Bottom Enclosure near C1
   [C3, RowInits[C3], false,BACK, [0,0,0], [1,RScale,1]], //fill gap between general border and Bottom Enclosure near C1
   [C4, RowInits[C4], false,BACK, [LEFT,0,0],     [1,RScale,1]]],   
   
  [[C4, RowInits[C4], false,BACK, [0,0,0],  [1,RScale,1]],
   [C5, RowInits[C5], false,BACK, [LEFT,0,0],  [1,RScale,1]],], 
 
 ];
 
//define Spical border Hull to join Column and Thumb Cluster 
//same as custom border. separated for organization 
TCJoints = //color "Salmon"
 [
   [[C2, RowInits[C2], false, BACK,    [RIGHT,0,0],     [RScale,1,1]], 
    [T2,          R2,  true,  RIGHT,   [0,BACK,BOTTOM], [1,1,1]],  
    [T2,          R1,  true,  RIGHT,   [0,0,BOTTOM],    [1,1,1]],
    [T2,          R1, false,  BACK,    [RIGHT,0,0],     [1,1,1]]
    ],  
    
   [[C2, RowInits[C2], false, BACK,    [RIGHT,0,0],  [RScale,1,1]], 
    [T2,          R2,  false, FRONT,   [RIGHT,0,0],  [1,RScale,1]],
    [T2,          R2,  true,  RIGHT,   [0,0,BOTTOM], [1,1,1]],],  

   [[C1, RowInits[C1], false, BACK,    [RIGHT,0,0], [RScale,1,1]], 
    [C2, RowInits[C2], false, BACK,    [RIGHT,0,0], [RScale,1,1]], 
    [T2,          R2,  false, FRONT,   [RIGHT,0,0], [1,RScale,1]],],

   [[C1, RowInits[C1], false, BACK,    [0,0,0], [RScale,1,1]], 
    [T2,          R2,  false, FRONT,   [0,0,0], [1,RScale,1]],],  
    
   [[C1, RowInits[C1],  true, LEFT,    [0,BACK,0], [RScale,1,1]], 
    [C1, RowInits[C1], false, RIGHT,   [LEFT,0,0], [RScale,1,1]], 
    [T2,          R2,  false, FRONT,   [0,0,0],    [1,RScale,1]],],  
       
   [[C1, RowInits[C1],  true, LEFT,    [0,BACK,0],   [RScale,1,1]], 
    [C1, RowInits[C1], false, BACK,    [LEFT,0,0],   [RScale,1,1]], 
    [T2,          R2,  false, FRONT,   [LEFT,0,0], [1,RScale,1]],
    [T1,          R2,  false, FRONT,   [RIGHT,0,0], [1,RScale,1]],],  
    
   [[C1, RowInits[C1],  true, LEFT,    [0,BACK,0],   [RScale,1,1]], 
    [C1, RowInits[C1], false, BACK,    [0,0,0],   [RScale,1,1]], 
    [T1,          R2,  false, FRONT,   [0,0,0], [1,RScale,1]]
   ],  
   
 ];
 
// define hull to join trackball module and border
TBborder = //color "Yellow" 
 [ 
 ];
 
/* 2 sets of structure to hull to generate Bottom enclosures starting from Top Surface and Projected Bottom surface. 
   Bottom structure is also used to generate bottom plates?
*/

//TODO simplify scale call?
Eborder = 
  [//[[Col, Row, len = true, Jog direction1, HullFace, Scale],  ...],], [hullface to trackball mounts], [ignore   /]  
    //LEFT Section  
    [//T2 Front conrer 7
      [[T2, RowInits[T2], true, LEFT,  [0,BACK,BOTTOM], [RScale,1,1]], 
       [T2, RowInits[T2], false, BACK, [LEFT,0,BOTTOM],  [1,RScale,1]] ],
      [[T2, RowInits[T2], true, LEFT+.5,  [0,BACK,BOTTOM], [EScale,1,1]],
       [T2, RowInits[T2], false, BACK, [LEFT,0,BOTTOM],  [1,EScale,1]] ],
      [0,0,0],
      true
    ],
    
      [//T1R1 Side 
      [[T2, RowInits[T2], true, LEFT, [0,BACK,BOTTOM], [RScale,1,1]],
       [T1, RowInits[T1], true, LEFT, [0,BACK,BOTTOM], [RScale,1,1]] ],
      [[TStart, RowInits[TStart], true, LEFT+.5, [0,0,BOTTOM], [EScale,1,1]],
       [T2, RowInits[T2], true, LEFT+.5, [0,0,BOTTOM], [EScale,1,1]]],
      [0,0,0],
      true
    ],    
    [//T1R1 Side 
      [[TStart, RowInits[TStart], true, LEFT, [0,0,BOTTOM], [RScale,1,1]] ],
      [[TStart, RowInits[TStart], true, LEFT+.5, [0,0,BOTTOM], [EScale,1,1]] ],
      [0,0,0],
      true
    ],  
    [//T0 Front conrer 7
      [[TStart, RowEnds[TStart], true,  LEFT,            [0,FRONT,BOTTOM], [RScale,1,1]], 
       [C1,     R1,              false, BACK,            [LEFT,0,BOTTOM],  [RScale,1,1]],
       [C1,     R1,              true,  LEFT,            [0,0,BOTTOM],     [RScale,1,1]]],
      [[C1,     RowInits[C1],    true,  LEFT+LeftOffset, [0,FRONT,BOTTOM], [EScale,1,1]],
       [TStart, RowEnds[TStart], true,  LEFT+.5,         [0,FRONT,BOTTOM], [EScale,1,1]]],
      [0,0,0],
      true
    ],

    [//C1 R1->R2
      [[C1,     R1, true, LEFT,            [0,FRONT,BOTTOM], [RScale,1,1]],
       [C1,     R2, true, LEFT,            [0,BACK,BOTTOM],  [RScale,1,1]]],
      [[C1,     R1, true, LEFT+LeftOffset, [0,FRONT,BOTTOM], [EScale,1,1]],
       [C1,     R2, true, LEFT+LeftOffset, [0,BACK,BOTTOM],  [EScale,1,1]]],
      [0,0,0],
      true
    ],
    
    [//C1 R1->R2
      [[C1,     R2, true, LEFT,            [0,0,BOTTOM], [RScale,1,1]]],
      [[C1,     R2, true, LEFT+LeftOffset, [0,0,BOTTOM], [EScale,1,1]]],
      [0,0,0],
      true
    ],   
    
    [//C1 R2->R3
      [[C1,     R2, true, LEFT,            [0,FRONT,BOTTOM], [RScale,1,1]],
       [C1,     R3, true, LEFT,            [0,BACK,BOTTOM], [RScale,1,1]]],
      [[C1,     R2, true, LEFT+LeftOffset, [0,FRONT,BOTTOM], [EScale,1,1]],
       [C1,     R3, true, LEFT+LeftOffset, [0,BACK,BOTTOM], [EScale,1,1]],
      ],
      [0,0,0],
      true
    ],
     [//C1 R1->R2
      [[C1,     R3, true, LEFT,               [0,0,BOTTOM], [RScale,1,1]]],
      [[C1,     R3, true, LEFT+LeftOffset,    [0,0,BOTTOM], [EScale,1,1]]],
      [0,0,0],
      true
    ],              
    
    //FRONT Section 
    [//CStart Front conrer 7
      [[CStart, RowEnds[CStart], true, LEFT,              [0,FRONT,BOTTOM], [RScale,1,1]], 
       [CStart, RowEnds[CStart], false,FRONT,             [LEFT,0,BOTTOM],  [1,RScale,1]]],
      [[CStart, RowEnds[CStart], true, LEFT+LeftOffset,   [0,FRONT,BOTTOM], [EScale,1,1]],
       [CStart, RowEnds[CStart], false,FRONT+FrontOffset, [LEFT,0,BOTTOM],  [1,EScale,1]]],
      [0,0,0],
      true
    ],
    [//C1R2 FRONT to C2R2 
      [[C1, RowEnds[C1], false,FRONT,             [0,0,BOTTOM], [1,RScale,1]]],
      [[C1, RowEnds[C1], false,FRONT+FrontOffset, [LEFT,0,BOTTOM], [1,EScale,1]]
       ],
      [0,0,0],
      false
    ],
    [//C1R2 FRONT to C2R2 
      [[C1, RowEnds[C1], false,FRONT,             [RIGHT,0,BOTTOM], [1,RScale,1]],
       [C2, RowEnds[C2], false,FRONT,             [LEFT,0,BOTTOM], [1,RScale,1]]],
      [[C1, RowEnds[C1], false,FRONT+FrontOffset, [LEFT,0,BOTTOM], [1,EScale,1]]
       ],
      [0,0,0],
      false
    ],
    [//C2R2 FRONT to C3R2 
      [[C2, RowEnds[C2], false,FRONT,             [LEFT,0,BOTTOM], [1,RScale,1]],
       [C3, RowEnds[C3], false,FRONT,             [LEFT,0,BOTTOM], [1,RScale,1]]],
      [[C1, RowEnds[C1], false,FRONT+FrontOffset, [LEFT,0,BOTTOM], [1,EScale,1]],
       [C3, RowEnds[C3], false,FRONT+FrontOffset, [LEFT,0,BOTTOM], [1,EScale,1]]
      ],
      [0,0,0],
      false
    ],
    [//C3R3 FRONT 
      [[C3, RowEnds[C3], false,FRONT,             [0,0,BOTTOM], [1,RScale,1]] ],
      [[C3, RowEnds[C3], false,FRONT+FrontOffset, [0,0,BOTTOM], [1,EScale,1]] ],
      [0,0,0],
      false
    ],
    [//C3R3 FRONT to C4R3 
      [[C3, RowEnds[C3], false,FRONT,             [RIGHT,0,BOTTOM], [1,RScale,1]],
       [C4, RowEnds[C4], false,FRONT,             [RIGHT,0,BOTTOM], [1,RScale,1]]],
      [[C3, RowEnds[C3], false,FRONT+FrontOffset, [RIGHT,0,BOTTOM], [1,EScale,1]],
       [C4, RowEnds[C4], false,FRONT+FrontOffset, [RIGHT,0,BOTTOM], [1,EScale,1]]],
      [0,0,0],
      false
    ],
    [//C4R3 FRONT to C5R3 
      [[C4, RowEnds[C4], false,FRONT,             [RIGHT,0,BOTTOM], [1,RScale,1]],
       [C5, RowEnds[C5], false,FRONT,             [0,0,BOTTOM], [1,RScale,1]]],
      [[C4, RowEnds[C4], false,FRONT+FrontOffset, [RIGHT,0,BOTTOM], [1,EScale,1]],
       [C5, RowEnds[C5], false,FRONT+FrontOffset, [RIGHT,0,BOTTOM], [1,EScale,1]]],
      [0,0,0],
      false
    ],
    [//CEnd conrer 
      [[CEnd, RowEnds[CEnd], true, RIGHT,             [0,FRONT,BOTTOM], [RScale,1,1]], 
       [CEnd, RowEnds[CEnd], false,FRONT,             [RIGHT,0,BOTTOM],    [1,RScale,1]]],
      [[CEnd, RowEnds[CEnd], true, RIGHT+RightOffset, [0,FRONT,BOTTOM],    [EScale,1,1]],
       [CEnd, RowEnds[CEnd], false,FRONT+FrontOffset, [RIGHT,0,BOTTOM],    [1,EScale,1]]],
      [0,0,0],
      true
    ],
    
//    //RIGHT Section
    [//CEndR1 side  16
      [[CEnd, RowEnds[CEnd], true, RIGHT,             [0,0,BOTTOM], [RScale,1,1]]],
      [[CEnd, RowEnds[CEnd], true, RIGHT+RightOffset, [0,0,BOTTOM],    [EScale,1,1]]],
      [0,0,0],
      true
    ],
    [//CEndR2
      [[CEnd, R3, true, RIGHT,             [0,BACK,BOTTOM],  [RScale,1,1]],
       [CEnd, R2, true, RIGHT,             [0,FRONT,BOTTOM], [RScale,1,1]]],
      [[CEnd, R3, true, RIGHT+RightOffset, [0,BACK,BOTTOM],     [EScale,1,1]],
       [CEnd, R2, true, RIGHT+RightOffset, [0,FRONT,BOTTOM],    [EScale,1,1]]],
      [0,0,0],
      true
    ],
    [//CEndR1 side  16
      [[CEnd, R2, true, RIGHT,             [0,0,BOTTOM], [RScale,1,1]]],
      [[CEnd, R2, true, RIGHT+RightOffset, [0,0,BOTTOM],    [EScale,1,1]]],
      [0,0,0],
      true
    ], 
    [//CEndR2
      [[CEnd, R2, true, RIGHT,             [0,BACK,BOTTOM],  [RScale,1,1]],
       [CEnd, R1, true, RIGHT,             [0,FRONT,BOTTOM], [RScale,1,1]]],
      [[CEnd, R2, true, RIGHT+RightOffset, [0,BACK,BOTTOM],     [EScale,1,1]],
       [CEnd, R1, true, RIGHT+RightOffset, [0,FRONT,BOTTOM],    [EScale,1,1]]],
      [0,0,0],
      true
    ],

    [//CEndR1 side  16
      [[CEnd, R1, true, RIGHT,             [0,0,BOTTOM], [RScale,1,1]]],
      [[CEnd, R1, true, RIGHT+RightOffset, [0,0,BOTTOM],    [EScale,1,1]]],
      [0,0,0],
      true
    ], 
//    //Back Section
    [//CEND conrer 
      [[CEnd, RowInits[CEnd], true, RIGHT,             [0,BACK,BOTTOM], [RScale,1,1]], 
       [CEnd, RowInits[CEnd], false,BACK,             [RIGHT,0,BOTTOM],    [1,RScale,1]]],
      [[CEnd, RowInits[CEnd], true, RIGHT+RightOffset, [0,BACK,BOTTOM],    [EScale,1,1]],
       [CEnd, RowInits[CEnd], false,BACK+BackOffset, [RIGHT,0,BOTTOM],    [1,EScale,1]]],
      [0,0,0],
      true
    ],
    [//C5R1 
      [[C5, R1, false,BACK,                [0,0,BOTTOM], [1,RScale,1]]],
      [[C5, R1, false,BACK+BackOffset,     [0,0,BOTTOM], [1,EScale,1]]],
      [0,0,0],
      true
    ],   
    [//C4R1 
      [[C5, R1, false,BACK,                [LEFT,0,BOTTOM], [1,RScale,1]]],
//       [C5, R1, false,BACK,                [LEFT,0,BOTTOM], [1,RScale,1]]],
      [[C2, R1, false,BACK+BackOffset,     [RIGHT,0,BOTTOM], [1,EScale,1]],
       [C5, R1, false,BACK+BackOffset,     [LEFT,0,BOTTOM], [1,EScale,1]]],
      [0,0,0],
      false
    ],   
    [//C4R1 
      [[C4, R1, false,BACK,                [LEFT,0,BOTTOM], [1,RScale,1]],
       [C5, R1, false,BACK,                [LEFT,0,BOTTOM], [1,RScale,1]]],
       
      [[C2, R1, false,BACK+BackOffset,     [RIGHT,0,BOTTOM], [1,EScale,1]]],
      [0,0,0],
      false
    ],   
    [//C2R1 
      [[C2, R1, false,BACK,                [RIGHT,0,BOTTOM], [1,RScale,1]],
       [C4, R1, false,BACK,                [LEFT,0,BOTTOM], [1,RScale,1]]],
      [[C2, R1, false,BACK+BackOffset,     [RIGHT,0,BOTTOM], [1,EScale,1]]],
      [0,0,0],
      false
    ],   

    [//C2R1 
      [[C2, R1, false,BACK,                [RIGHT,0,BOTTOM], [1,RScale,1]],
       [T2, R1, true,RIGHT,                [0,BACK,BOTTOM], [1,RScale,1]],
       [T2, R1, false,BACK,                [RIGHT,0,BOTTOM], [1,RScale,1]]],
       
      [[C2, R1, false,BACK+BackOffset,     [RIGHT,0,BOTTOM], [1,EScale,1]],
       [T2, R1, false,BACK,                [RIGHT,0,BOTTOM], [1,EScale,1]]],
      [0,0,0],
      true
    ],   

    [//T1R1 Side 0
      [[T2,  R1, false, BACK, [0,0,0],      [1,1,1]],],
      [[T2,  R1, false, BACK, [0,0,BOTTOM], [EScale,1,1]]],
      [0,0,0],
      true
    ] 
  ];
  
//Hull struct refers Estruct array to hull bottom plate: concavity exsits so blind hull will result in failuer
// turn on # debug on editor's buildbottomplate() to visualize 
Hstruct = 
  [[0,1,2,3,4,5,6,7,8,9,10,25,26,27],
   [11,12,13,14,15,25],
   [16,25],
   [17,23,24,25],
   [18,19,22],
   [20,21,22]
 ];


//-----     IGNORE IF YOU are not using Clipped switch 
xLen         = 0;        //3.4 cut length for clipped khail 
xLenM        = xLen+2;   //fudging to get cleaner border               
//Manual Adjustment of Pitches post Calculation for minor adjustment    
//              C0:i1 C1:i2  C2:i3   C3:m   C4:r  C5:p1  C6:p2  C7:p3  T0:Ot T1:OM T2:Md  T3:IM  T4:In
Clipped      =[[   1,     1,     1,    -0,    -0,    -1,     1,     1,     1,     1,    1,     1,    1],  //R0
               [   1,    -1,    -1,    -1,    -1,    -1,    -1,     1,     1,     0,    1,     1,    0],  //R1s
               [   1,     0,    -0,    -0,     0,     0,    -1,     1,     0,    -1,    1,     1,    0],  //R2s 
               [   1,     1,     1,     1,     1,     1,     1,    -1,     1,     1,    1,     1,    1],  //R3
               [   1,     1,     1,    -1,    -1,     1,    -1,    -1,     1,     1,    1,     1,    1],  //R4
               [   1,     1,     1,     1,    -1,     1,    -1,     1,     1,     1,    1,     1,    1]   //R5
              ]*xLen;

//Orientation of the clippede switches
KeyOriginCnRm = [for( i= [C0:C7])[[0,BottomHeight],0], for(j = [R1:R4])[0,TopHeight,0]];
 