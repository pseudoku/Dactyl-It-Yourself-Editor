/*
HYPOWARP_CUSTOM
Designer: Pseudoku
Summary:  (6x4+2)+4 Cherry CAP profile
Concept:  Tangental Home Row 
          Choc thumb cluster.
          
TODOs: implement row wise cherry profiles
       clipping issue in  outer wall 
       thumb cluster depth
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
unit           = 19.05;  // 
Tol            = 0.01;  // tolance
HullThickness  = 0.01; // modulation hull thickness
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
RScale       = 1;                //Rim bottom scaling
EScale       = 1;              //Enclosure bottom scaling
PBuffer      = 0;                //additional Plate thickness
BorderAlign  = BOTTOM;           //high pro or flushed
Bthickness   = PlateDim[0] - 4;  //thickness of the enclosure rim 
BFrontHeight = 0;                    //Height of frontside of the enclosure rim 
BBackHeight  = 5.5;                    //Height of Backside of the enclosure rim 
TFrontHeight = 0;
TBackHeight  = 0;
T0Buffer     = 0;                    //Additional Plate thickness buffer for T0 position.
T0BackH      = BBackHeight + T0Buffer;  //Adjuted height for T0
holeOffset   = 0;

//-----  Bottom Enclosure Offsets: Adjust how bottom casing offset from top plate
LeftOffset  = .5;
FrontOffset = 1.5;
RightOffset = 0;
BackOffset  = -.75;
ThumbOffset = .2; 

//-----     Tenting Parameters
tenting     = [-10,13,0]; // tenting for enclusoure  
plateHeight = 33;       // height adjustment for enclusure 

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
//
bpThickness =  3; //Bottom Plate Thickness
midHeight   = -7; // used to generate hull between mount and enclosure  
mountScrew  = [[-58,-28,0],[-33,83,0],[68,80,0],[66,5,0],[10,8,0]];
mountHull   = [0,8,15,21,24];
mountDia    = 5; //mm

MCUDim      = [18.5, 32.5, 1.2];
MCULoc      = [-13,76,10.1];
resetLoc    = [0,0,0]; 
USBLoc      = [-13,74-5+32.5/2,9+1.2];

JackLoc     = [-35,50,9];
JackDim     = [18,6,10];
JackAng     = [0,0,180];

//-------  LAYOUT parameters
//column loop setter
CStart   = C1;  // Set column to begin looping for the build
CEnd     = C6;  // Set column to end for the build
TStart   = T0;  // Set Thumb Cluster Colum to begin
TEnd     = T2;  // Set Thumb Cluster to end 
colRange = concat([for (i = [CStart:CEnd]) i], [for (i = [TStart:TEnd]) i]); //columnar for loop range 
  
//structure to hold column origin transformation
ColumnOrigin = [//[translation vec]       [Global Rot]    [Local Rot]
                [[  -54, -unit*3/4,   1], [   0,   0,   0], [ 0, 90,  0]], //INDEX 1 
                [[  -38.10,-unit*7/16,-0.5], [-4.5,   0,   0], [ 0, 90,  0]], //INDEX 2 
                [[  -19.05,   -unit/4,  -1], [-1.5,   0,   0], [ 0, 90,  0]], //INDEX 3 
                [[    0,    unit/8,  -2], [   4,   0,   0], [ 0, 90,  0]], //MIDDLE 
                [[   19.05,   -unit/8,-0.0], [  -1,   0,  -0], [ 0, 90,  0]], //RING 
                [[ 38.10, -unit*4/8, 0.5], [  -5,   0, -0], [ 0, 90,  0]], //PINKY 1 
                [[ 57.15, -unit*4/8, 0.5], [  -5,   0, -0], [ 0, 90,  0]], //PINKY 2 
                [[ 66.5, -unit*3/8,  21], [ 0,  15, -15], [ 0, 90,  0]], //PINKY 3                 
                [[  -63,       -23, -23], [ 0,   0,  10], [-5, 95,  0]], //Thumb Outer 
                [[  -46,       -22, -23], [ 0,   0,   0], [ 0, 90,-60]], //Thumb OuterMid
                [[  -46,       -22, -23], [ 0,   0,   0], [ 0, 90,-60]], //Thumb Midlde
                [[  -36,       -22, -14], [ 0,   0,   0], [ 0, 90,-60]], //Thumb InnerMid
                [[  -29,     -13.5,   3], [ 0,   0,   0], [ 0, 90,-60]]  //Thumb Inner              
               ];

ThumbShift  = [[8,-14, 27],[ 0, -5, -3],[ 0, 0, 0]]; //global transform for thumb cluster to jog as whole rather than editing origin

//-------  and adjustment parameters 

//row loop setter
//              C0:i1 C1:i2 C2:i3  C3:m  C4:r C5:p1 C6:p2 C7:p3 T0:Ot T1:OM T2:Md  T3:IM  T4:In
RowInits    = [   R2,    R1,   R1,   R1,   R1,   R1,   R1,   R0,   R2,   R2,    R1,   R1,    R0]; //set which Row to begin
RowEnds     = [   R2,    R4,   R4,   R4,   R4,   R4,   R4,   R0,   R2,   R2,    R2,   R1,    R0]; //set which Row to end

//Row transforms  
//              C0:i1 C1:i2 C2:i3  C3:m  C4:r C5:p1 C6:p2 C7:p3 T0:Ot T1:OM T2:Md  T3:IM  T4:In
RowTrans    = [[ -.18, -.18, -.18, -.18, -.18, -.18, -.18, -.55, -1.0, -1.0,-1.25, -1.25,     0], //R0
               [  .80,  .77,  .77,  .77,  .77,  .77,  .77,  .45,    0,  -.0,  -.1,     0,     0], //R1s
               [ 1.95, 1.95, 1.95, 1.95, 1.95, 1.95, 1.95, 1.60,  .95, 0.95,  .95,   .95,     0], //R2s 
               [ 2.90, 3.07, 3.07, 3.07, 3.07, 3.07, 3.07, 2.55,    0,    0,    0,     0,     0], //R3s
               [ 3.80, 4.00, 4.00, 4.00, 4.00, 4.00, 4.00,    3,    0,    0,    0,     0,     0], //R4
               [ 4.45, 4.45, 4.45, 4.45, 4.45,    4,   -4,    4,    0,    0,    0,     0,     0]  //R5           
              ]*unit; 
//              C0:i1 C1:i2 C2:i3  C3:m  C4:r C5:p1 C6:p2 C7:p3 T0:Ot T1:OM T2:Md  T3:IM  T4:In
ColTrans    = [[    0,    0,    0,    0,    0,    0,    0,    0,    0,   .0,    0,     0,     0], //R0
               [    0,    0,    0,    0,    0,    0,    0,    0,    0,   .0,  .25,     0,     0], //R1
               [    0,    0,    0,    0,    0,    0,    0,    0,    0,  -.3,   .8,     0,     0], //R2s 
               [    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0], //R3s
               [    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0], //R4
               [    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0]  //R5           
              ]*unit; 
//              C0:i1 C1:i2 C2:i3  C3:m  C4:r C5:p1 C6:p2 C7:p3 T0:Ot T1:OM T2:Md  T3:IM  T4:In              
Pitch       = [[   25,   15,   15,   15,   15,   15,   15,   25,   10,   10,  -10,    10,     0],  //R0
               [   15,   10,   10,   10,   10,   10,   10,   15,    0,   20,  -35,   -15,     0],  //R1s
               [  -15,  -10,  -10,  -10,  -10,  -10,  -10,  -15,    0,  -25,  -25,   -25,   0],  //R2s 
               [  -25,  -30,  -30,  -30,  -30,  -30,  -30,  -30,    0,  -60,    0,     0,     0],  //R3
               [  -45,  -50,  -50,  -50,  -50,  -50,  -50,    0,    0,    0,    0,     0,     0],  //R4
               [  -58,  -58,  -58,  -58,  -58,    0,    0,    0,    0,    0,    0,     0,     0]   //R5
              ];
//              C0:i1 C1:i2 C2:i3  C3:m  C4:r C5:p1 C6:p2 C7:p3 T0:Ot T1:OM T2:Md  T3:IM  T4:In
Roll        = [[   -4,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0],  //R0
               [   -5,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0],  //R1s
               [   -0,    0,    0,    0,    0,    0,    0,    0,    0,  -13,   13,     0,     0],  //R2s 
               [   -7,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0],  //R3
               [   -8,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0],  //R4
               [   -10,   0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0]   //R5
              ];         
//               C0:i1  C1:i2  C2:i3 C3:m  C4:r  C5:p1 C6:p2 C7:p3 T0:Ot T1:OM T2:Md T3:IM  T4:In

//Height      = [[ -6.5, -4.5, -4.5, -4.5, -4.5, -4.5, -4.5, -4.5,    1,    0,    0,     0,     0],  //R0
//               [    0,    0,   -0,    0,    0,    0,    0,    0,    0,    0,  9.5,     0,     0],  //R1s
//               [    0,    0,    0,    0,    0,    0,    0,    0,   17, 1.85,    2,     0,     0],  //R2s 
//               [ -6.5, -7.6, -7.6, -7.6, -7.6, -7.6, -7.6, -5.5,    0,  -24,    0,     0,     0],  //R3
//               [  -18,-22.0,-22.0,-22.0,-22.0,-22.0,-22.0,    0,    0,    0,    0,     0,     0],  //R4
//               [  -33,  -33,  -33,  -33,  -33,    0,    0,    0,    0,    0,    0,     0,     0]   //R5
//              ]; 
Height      = [[ -6.5, -4.5, -4.5, -4.5, -4.5, -4.5, -4.5, -4.5,    1,    0,    0,     0,     0],  //R0
               [    0,    0,   -0,    0,    0,    0,    0,    0,    0,    0,  9.5,     0,     0],  //R1s
               [    0,    1,    1,    1,    1,    1,    1,    0,   17, 1.85,    2,     0,     0],  //R2s 
               [ -6.5, -5.6, -5.6, -5.6, -5.6, -5.6, -5.6, -5.6,    0,  -24,    0,     0,     0],  //R3
               [  -18,-18.5,-18.5,-18.5,-18.5,-18.5,-18.5,    0,    0,    0,    0,     0,     0],  //R4
               [  -33,  -33,  -33,  -33,  -33,    0,    0,    0,    0,    0,    0,     0,     0]   //R5
              ]; 
//Account for non-1u caps
CapScale     =[[   1,     1,     1,     1,     1,     1,     1,     1,     1,     1,    1,     1,    1],  //R0
               [   1,     1,     1,     1,     1,     1,     1,     1,     1,     1,  1.5,     1,    1],  //R1s
               [   1,     1,     1,     1,     1,     1,     1,     1,     1,     1,    1,     1,    1],  //R2s 
               [   1,     1,     1,     1,     1,     1,     1,     1,     1,     1,    1,     1,    1],  //R3
               [   1,     1,     1,     1,     1,     1,     1,     1,     1,     1,    1,     1,    1],  //R4
               [   1,     1,     1,     1,     1,     1,     1,     1,     1,     1,    1,     1,    1]   //R5
              ];
SwitchOrientation = //if length-wise true 
//               C0:i1  C1:i2  C2:i3   C3:m   C4:r  C5:p1  C6:p2  C7:p3  T0:Ot  T1:OM  T2:Md T3:IM  T4:In
              [[ true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true],  
               [ true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true],
               [ true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true],
               [ true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true],
               [ true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true],
               [ true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true]
              ]; 
SwitchTypes = 
              [[   MX,    MX,    MX,    MX,    MX,    MX,    MX,    MX,  Choc,  Choc,  Choc,  Choc,  Choc],
               [   MX,    MX,    MX,    MX,    MX,    MX,    MX,    MX,  Choc,  Choc,  Choc,  Choc,  Choc],
               [   MX,    MX,    MX,    MX,    MX,    MX,    MX,    MX,  Choc,  Choc,  Choc,  Choc,  Choc],
               [   MX,    MX,    MX,    MX,    MX,    MX,    MX,    MX,  Choc,  Choc,  Choc,  Choc,  Choc],
               [   MX,    MX,    MX,    MX,    MX,    MX,    MX,    MX,  Choc,  Choc,  Choc,  Choc,  Choc],
               [   MX,    MX,    MX,    MX,    MX,    MX,    MX,    MX,  Choc,  Choc,  Choc,  Choc,  Choc],
              ];
//-----     border Customization

TopCuts = [
//            [C2, R1, [0,FRONT,0], C1, R2, [0,BACK,0]],
//            [C5, R1, [0,FRONT,0], C6, R2, [0,BACK,0]],
//            [T1, R1, [0,FRONT,0], T0, R2, [0,BACK,0]],
          ];
              
PBind      = [
[C1,0,LEFT],[C2,0,LEFT],[C3,RIGHT,LEFT],[C4,0,0],[C5,0,0] 
]; //list of BindColumns to build and bind sides 

PlateCustomBind  = 
  [
//   //Ring to Pinkie
  [[T0,R2,RIGHT,[0,0,0],0],
    [T1,R2,LEFT, [0,0,0],0]],
    
  [[T0,R2,RIGHT,[RIGHT,BACK,0],0],
    [T2,R1,LEFT, [0,0,0],0]],
    
  [[T0,R2,RIGHT,[RIGHT,BACK,0],0],
   [T1,R2,LEFT, [0,BACK,0],0],
   [T2,R1,LEFT, [0,FRONT,0],0]],
  
  [[T1,R2,LEFT, [0,BACK,0],0],
   [T1,R2,RIGHT, [0,BACK,0],0],
   [T2,R1,LEFT, [0,FRONT,0],0]],

  [[T1,R2,RIGHT, [0,BACK,0],0],
   [T2,R1,LEFT, [0,FRONT,0],0],
   [T2,R2,LEFT, [0,BACK,0],0],],
  [[T1,R2,RIGHT, [0,0,0],0],
   [T2,R2,LEFT, [0,0,0],0],],
  ]; 
  
  
 MountList = [
  [C1,R1,[10,-10,0]],
  [C1,R3,[10,10,0]],
  [C4,R1,[-10,-10,0]],
  [C4,R3,[-10,10,0]],

  [C4,R3,[-10,10,0]],
  [C4,R3,[-10,10,0]],
  
  [C5,R3,[5,11,0]],
  [C5,R2,[5,-11,0]],
  
  [C6,R2,[-11,-8,0]],
  [C6,R2,[-11,8,0]],
 ];
//define Spical border Hull to make border pretty             
Sborder = //color "Crimson"
 [
//[[Col, Row, len = true, Jog direction, HullFace, Scale], ...], 
//Front
//  [[CStart, RowEnds[CStart], false,FRONT, [LEFT,0,0],    [1,RScale,1]], //fill gap between general border and Bottom Enclosure near C1
//   [CStart, RowEnds[CStart], true,  LEFT, [0,FRONT,0],    [RScale,1,1]] ],

  [[C1, RowEnds[C1], false,FRONT, [0,0,0],    [1,RScale,1]], //fill gap between general border and Bottom Enclosure near C1
   [C2, RowEnds[C2], false,FRONT, [LEFT,0,0], [1,RScale,1]] ],
   
//  [[C1, RowEnds[C1], false,FRONT, [0,BACK,0],    [1,RScale,1]], //fill gap between general border and Bottom Enclosure near C1
//   [C2, RowEnds[C2], false,FRONT, [LEFT,BACK,0], [1,RScale,1]] ],
   
  [[C2, RowEnds[C2], false,FRONT, [0,0,0],    [1,RScale,1]], //fill gap between general border and Bottom Enclosure near C3
   [C3, RowEnds[C3], false,FRONT, [LEFT,0,0], [1,RScale,1]] ], 
   
  [[C3, RowEnds[C3], false,FRONT, [0,0,0], [1,RScale,1]]],

  [[C3, RowEnds[C3], false,FRONT, [RIGHT,0,0], [1,RScale,1]],
   [C4, RowEnds[C4], false,FRONT, [0,0,0],     [1,RScale,1]]],
   
  [[C4, RowEnds[C4], false,FRONT, [RIGHT,0,0], [1,RScale,1]], //fill gap between general border and Bottom Enclosure near C4
   [C5, RowEnds[C5], false,FRONT, [0,0,0],     [1,RScale,1]]],
   
  [[C5, RowEnds[C5], false,FRONT, [RIGHT,0,0], [1,RScale,1]], //fill gap between general border and Bottom Enclosure near C4
   [C6, RowEnds[C6], false,FRONT, [RIGHT,0,0], [1,RScale,1]]],
  //corner
  [[C4, RowEnds[C4], false,FRONT, [RIGHT,0,0], [1,RScale,1]], //fill gap between general border and Bottom Enclosure near C1
   [C4, RowEnds[C4], true, RIGHT, [0,FRONT,0], [RScale,1,1]],],
  //corner
////  [[CEnd, RowEnds[CEnd], false,FRONT, [RIGHT,0,0], [1,RScale,1]], //fill gap between general border and Bottom Enclosure near C1
////   [CEnd, RowEnds[CEnd], true, RIGHT, [0,FRONT,0], [RScale,1,1]],],
   
   //BACK
//  [[CStart, RowInits[CStart], false, BACK, [LEFT,0,0], [1,RScale,1]], //fill gap between general border and Bottom Enclosure near C1
//   [CStart, RowInits[CStart],  true, LEFT, [0,BACK,0],  [RScale,1,1]]],
//   
//  [[C1, RowInits[C1], false,BACK, [0,0,0],     [1,RScale,1]]],
  
  [[C1, RowInits[C1], false,BACK, [RIGHT,0,0],     [1,RScale,1]],
   [C2, RowInits[C2], false,BACK, [0,0,0],     [1,RScale,1]]],   
   
//  [[C2, RowInits[C2], false,BACK, [0,0,0],     [1,RScale,1]]],
//  
  [[C2, RowInits[C2], false,BACK, [RIGHT,0,0], [1,RScale,1]], //fill gap between general border and Bottom Enclosure near C1
   [C3, RowInits[C3], false,BACK, [0,0,0], [1,RScale,1]], //fill gap between general border and Bottom Enclosure near C1
   [C4, RowInits[C4], false,BACK, [LEFT,0,0],     [1,RScale,1]]],   
   
  [[C4, RowInits[C4], false,BACK, [0,0,0],  [1,RScale,1]],
   [C5, RowInits[C5], false,BACK, [LEFT,0,0],  [1,RScale,1]],], 
//
//  [[C5, RowInits[C5], false,BACK, [0,0,0],     [1,RScale,1]]],
//
   
  [[C5, RowInits[C5], false,BACK, [0,0,0],  [1,RScale,1]],
   [C6, RowInits[C6], false,BACK, [0,0,0], [1,RScale,1]],],
   
//  [[CEnd, RowInits[CEnd], false,BACK, [RIGHT,0,0], [1,RScale,1]], //fill gap between general border and Bottom Enclosure near C1
//   [CEnd, RowInits[CEnd], true, RIGHT, [0,BACK,0], [RScale,1,1]]],
   
////    //LEFT
////  [[CStart, RowInits[CStart], true, LEFT, [0,0,0], [RScale,1,1]]],
//////  
//  [[CStart, RowInits[CStart], true, LEFT, [0,FRONT,0], [RScale,1,1]],
//   [CStart, RowInits[CStart]+1, true, LEFT, [0,FRONT,0],  [RScale,1,1]]],
//
////  [[CStart, RowInits[CStart]+1, true, LEFT, [0,0,0], [RScale,1,1]]],
////   
//  [[CStart, RowInits[CStart]+1, true, LEFT, [0,FRONT,0], [RScale,1,1]],
//   [CStart,  RowInits[CStart]+2, true, LEFT, [0,FRONT,0],  [RScale,1,1]]],
////
////  [[CStart, RowInits[CStart]+2, true, LEFT, [0,0,0], [RScale,1,1]]],
//
//  [[CStart, RowInits[CStart]+2, true, LEFT, [0,FRONT,0], [RScale,1,1]],
//   [CStart,  RowEnds[CStart], true, LEFT, [0,FRONT,0],  [RScale,1,1]]],
//
//  [[CStart, RowEnds[CStart], true, LEFT, [0,0,0], [RScale,1,1]]],


//  
////  //RIGHT
//  [[CEnd, RowInits[CEnd], true, RIGHT, [0,0,0], [RScale,1,1]]],
////  
//  [[CEnd, RowInits[CEnd], true, RIGHT, [0,FRONT,0], [RScale,1,1]],
//   [CEnd, RowInits[CEnd]+1, true, RIGHT, [0,BACK,0],  [RScale,1,1]]],
//
//  [[CEnd, RowInits[CEnd]+1, true, RIGHT, [0,0,0], [RScale,1,1]]],
//   
//  [[CEnd, RowInits[CEnd]+1, true, RIGHT, [0,FRONT,0], [RScale,1,1]],
//   [CEnd,  RowInits[CEnd]+2, true, RIGHT, [0,BACK,0],  [RScale,1,1]]],
//
//  [[CEnd, RowInits[CEnd]+2, true, RIGHT, [0,0,0], [RScale,1,1]]],
//
//  [[CEnd, RowInits[CEnd]+2, true, RIGHT, [0,FRONT,0], [RScale,1,1]],
//   [CEnd,  RowEnds[CEnd], true, RIGHT, [0,BACK,0],  [RScale,1,1]]],
//
//  [[CEnd, RowEnds[CEnd], true, RIGHT, [0,0,0], [RScale,1,1]]],
  
 ];
 
//define Spical border Hull to join Column and Thumb Cluster 
TCJoints = //color "Salmon"
 [
   [[C2, RowInits[C2], false, BACK,    [RIGHT,0,0],        [RScale,1,1]], 
    [T2,          R2,  true,  RIGHT,   [LEFT,BACK,BOTTOM], [1,1,1]],  
    [T2,          R1,  true,  RIGHT,   [0,0,BOTTOM],    [1,1,1]],
//    [T2,          R1, false,  BACK,    [RIGHT,0,0],        [1,1,1]]
    ],  
    
   [[C2, RowInits[C2], false, BACK,    [RIGHT,0,0],   [RScale,1,1]], 
    [T2,          R2,  true,  RIGHT,   [LEFT,0,BOTTOM],   [1,1,1]],],  

   [[C1, RowInits[C1], false, BACK,    [RIGHT,0,0],   [RScale,1,1]], 
    [C2, RowInits[C2], false, BACK,    [RIGHT,0,0],   [RScale,1,1]], 
    [T2,          R2,  false, FRONT,   [RIGHT,0,0], [1,RScale,1]],],

   [[C1, RowInits[C1], false, BACK,    [0,0,0],   [RScale,1,1]], 
    [T2,          R2,  false, FRONT,   [0,0,0], [1,RScale,1]],],  
    
   [[C1, RowInits[C1],  true, LEFT,    [0,BACK,0],   [RScale,1,1]], 
    [C1, RowInits[C1], false, RIGHT,    [LEFT,0,0],   [RScale,1,1]], 
    [T2,          R2,  false, FRONT,   [0,0,0], [1,RScale,1]],],  
    
//  [[C1, RowInits[C1],  true, LEFT,    [0,BACK,0],   [RScale,1,1]], 
//    [C1, RowInits[C1], false, RIGHT,    [LEFT,0,0],   [RScale,1,1]], 
//    [T1,          R2,  false, FRONT,   [RIGHT,0,0], [1,RScale,1]],  
//    [T2,          R2,  false, FRONT,   [LEFT,0,0], [1,RScale,1]],],  
    
//    [[T1,          R2,  true,  RIGHT,    [0,0,0],   [RScale,1,1]],
//    [T1,          R2,  false, FRONT,    [RIGHT,0,0], [1,RScale,1]],],
   
   [[C1, RowInits[C1],  true, LEFT,    [0,0,0],   [RScale,1,1]], 
    [C1, RowInits[C1], false, BACK,    [LEFT,0,0],   [RScale,1,1]], 
    [T1,          R2,  false, FRONT,    [0,0,0], [1,RScale,1]],],  
   
   [[T0,          R2,  false, FRONT,    [0,0,0], [1,RScale,1]],
    [T1,          R2,  false, FRONT,    [LEFT,0,0], [1,RScale,1]],],  
   
//   [[T0,          R2,  true,  LEFT,    [0,FRONT,0],   [RScale,1,1]], 
//    [T0,          R2,  false, FRONT,    [LEFT,0,0], [1,RScale,1]],],  
   
//   [[T0,          R2,  true,  LEFT,    [0,0,0],   [RScale,1,1]], ],  
   
   [[C2, RowInits[C2], false, BACK,    [RIGHT,0,0],   [RScale,1,1]],
//    [T2,          R2,  true,  RIGHT,    [0,FRONT,0],   [1,1,1]], 
    [T2,          R2,  false, FRONT,   [RIGHT,0,0], [1,1,1]],],  
 ];
 
// define hull to join trackball module and border
TBborder = //color "Yellow" 
 [ 
 ];
 
/* 2 sets of structure to hull to generate Bottom enclosures starting from Top Surface and Projected Bottom surface. 
   Bottom structure is also used to generate bottom plates? may need to seperate due to concavity of border...
*/

//TODO simplify scale call 
Eborder = 
   [//[[Col, Row, len = true, Jog direction1, HullFace, Scale], ...], 
    //LEFT Section  
    [//T0 Front conrer 7
      [[TStart, RowEnds[TStart], true, LEFT,  [0,BACK,BOTTOM], [RScale,1,1]], 
       [TStart, RowEnds[TStart], false, BACK, [LEFT,0,BOTTOM],  [1,RScale,1]] ],
      [[TStart, RowEnds[TStart], true, LEFT+.5,  [0,BACK,BOTTOM], [EScale,1,1]],
       [TStart, RowEnds[TStart], false, BACK, [LEFT,0,BOTTOM],  [1,EScale,1]] ],
      [0,0,0],
      true
    ],
    [//T0R1 Side 
      [[TStart, RowInits[TStart], true, LEFT, [0,0,BOTTOM], [RScale,1,1]] ],
      [[TStart, RowInits[TStart], true, LEFT+.5, [0,0,BOTTOM], [EScale,1,1]] ],
      [0,0,0],
      true
    ],  
    [//T0 Front conrer 7
      [[TStart, RowEnds[TStart], true, LEFT,  [0,FRONT,BOTTOM], [RScale,1,1]], 
       [TStart, RowEnds[TStart], false,FRONT, [LEFT,0,BOTTOM],  [1,RScale,1]] ],
      [[C1,     RowInits[C1],     true, LEFT+LeftOffset, [0,FRONT,BOTTOM], [EScale,1,1]],
       [TStart, RowEnds[TStart], true, LEFT+.5,  [0,FRONT,BOTTOM], [EScale,1,1]]],
      [0,0,0],
      true
    ],
    [//C1 T1 side
      [[TStart, RowEnds[TStart], false, FRONT,           [LEFT,0,BOTTOM],       [1,RScale,1]],
       [T1,          RowEnds[T1], false,FRONT,            [LEFT,0,BOTTOM],  [1,RScale,1]],],
      [[C1,     RowInits[C1],     true, LEFT+LeftOffset, [0,FRONT,BOTTOM], [EScale,1,1]],
      ],
      [0,0,0],
      true
    ],
    [//C1 T1 side
      [[T1,          RowEnds[T1], false,FRONT,            [LEFT,0,BOTTOM],  [1,RScale,1]],
       [CStart, RowInits[CStart],  true, LEFT,            [0,FRONT,BOTTOM],  [RScale,1,1]]],
      [[C1,         RowInits[C1],  true, LEFT+LeftOffset, [0,FRONT,BOTTOM], [EScale,1,1]],
      ],
      [0,0,0],
      true
    ],
    
    [//C1 R1->R2
      [[C1,     R1, true, LEFT,               [0,FRONT,BOTTOM], [RScale,1,1]],
       [C1,     R2, true, LEFT,               [0,FRONT,BOTTOM], [RScale,1,1]]],
      [[C1,     R1, true, LEFT+LeftOffset,    [0,FRONT,BOTTOM], [EScale,1,1]],
       [C1,     R2, true, LEFT+LeftOffset, [0,FRONT,BOTTOM], [EScale,1,1]],
      ],
      [0,0,0],
      true
    ],
    
    [//C1 R2->R3
      [[C1,     R2, true, LEFT,            [0,FRONT,BOTTOM], [RScale,1,1]],
       [C1,     R3, true, LEFT,            [0,FRONT,BOTTOM], [RScale,1,1]]],
      [[C1,     R2, true, LEFT+LeftOffset, [0,FRONT,BOTTOM], [EScale,1,1]],
       [C1,     R3, true, LEFT+LeftOffset, [0,FRONT,BOTTOM], [EScale,1,1]],
      ],
      [0,0,0],
      true
    ],
        
    [//C1 R3->R4
      [[C1,     R3, true, LEFT,            [0,FRONT,BOTTOM], [RScale,1,1]],
       [C1,     R4, true, LEFT,            [0,FRONT,BOTTOM], [RScale,1,1]]],
      [[C1,     R3, true, LEFT+LeftOffset, [0,FRONT,BOTTOM], [EScale,1,1]],
       [C1,     R4, true, LEFT+LeftOffset, [0,FRONT,BOTTOM], [EScale,1,1]],
      ],
      [0,0,0],
      true
    ],
    
//    [//C1 R4
//      [[C1,     R4, true, LEFT,               [0,0,BOTTOM], [RScale,1,1]]],
//      [[C1,     R4, true, LEFT+LeftOffset,    [0,BACK+.3,BOTTOM], [EScale,1,1]],
//       [C1,     R4, true, LEFT+LeftOffset, [0,FRONT+.3,BOTTOM], [EScale,1,1]],
//      ],
//      [0,0,0],
//      true
//    ],
    
    //FRONT Section 
    [//CStart Front conrer 7
      [[CStart, RowEnds[CStart], true, LEFT,                 [0,FRONT,BOTTOM], [RScale,1,1]], 
       [CStart, RowEnds[CStart], false,FRONT,                [LEFT,0,BOTTOM],  [1,RScale,1]]],
      [[CStart, RowEnds[CStart], true, LEFT+LeftOffset,   [0,FRONT,BOTTOM], [EScale,1,1]],
       [CStart, RowEnds[CStart], false,FRONT+FrontOffset, [LEFT,0,BOTTOM],  [1,EScale,1]]],
      [0,0,0],
      true
    ],
    [//C1R2 FRONT to C2R2 
      [[C1, RowEnds[C1], false,FRONT,             [LEFT,0,BOTTOM], [1,RScale,1]],
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

    [//C6 FRONT
      [[C6, RowEnds[C6], false,FRONT,             [0,0,BOTTOM], [1,RScale,1]]],
      [[C6, RowEnds[C6], false,FRONT+FrontOffset, [LEFT,0,BOTTOM], [1,EScale,1]],
       [C6, RowEnds[C6], false,FRONT+FrontOffset-.7, [RIGHT,0,BOTTOM], [1,EScale,1]]],
      [0,0,0],
      false
    ],  
    [//CEnd conrer 
      [[CEnd, RowEnds[CEnd], true, RIGHT,             [0,FRONT,BOTTOM], [RScale,1,1]], 
       [CEnd, RowEnds[CEnd], false,FRONT,             [RIGHT,0,BOTTOM],    [1,RScale,1]]],
      [[CEnd, RowEnds[CEnd], true, RIGHT+RightOffset, [0,FRONT,BOTTOM],    [EScale,1,1]],
       [CEnd, RowEnds[CEnd], false,FRONT+FrontOffset-.7, [RIGHT,0,BOTTOM],    [1,EScale,1]]],
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
      [[CEnd, R4, true, RIGHT,             [0,FRONT,BOTTOM],  [RScale,1,1]],
       [CEnd, R3, true, RIGHT,             [0,FRONT,BOTTOM], [RScale,1,1]]],
      [[CEnd, R4, true, RIGHT+RightOffset, [0,FRONT,BOTTOM],     [EScale,1,1]],
       [CEnd, R3, true, RIGHT+RightOffset, [0,FRONT,BOTTOM],    [EScale,1,1]]],
      [0,0,0],
      true
    ],

    [//CEndR2
      [[CEnd, R3, true, RIGHT,             [0,FRONT,BOTTOM],  [RScale,1,1]],
       [CEnd, R2, true, RIGHT,             [0,FRONT,BOTTOM], [RScale,1,1]]],
      [[CEnd, R3, true, RIGHT+RightOffset, [0,FRONT,BOTTOM],     [EScale,1,1]],
       [CEnd, R2, true, RIGHT+RightOffset, [0,FRONT,BOTTOM],    [EScale,1,1]]],
      [0,0,0],
      true
    ],

    [//CEndR2
      [[CEnd, R2, true, RIGHT,             [0,FRONT,BOTTOM], [RScale,1,1]],
       [CEnd, R1, true, RIGHT,             [0,FRONT,BOTTOM], [RScale,1,1]]],
      [[CEnd, R2, true, RIGHT+RightOffset, [0,FRONT,BOTTOM], [EScale,1,1]],
       [CEnd, R1, true, RIGHT+RightOffset, [0,FRONT,BOTTOM], [EScale,1,1]]],
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
      [[C5, R1, false,BACK,                [LEFT,0,BOTTOM], [1,RScale,1]],
       [C6, R1, false,BACK,                [RIGHT,0,BOTTOM], [1,RScale,1]]],
      [[C5, R1, false,BACK+BackOffset,     [LEFT,0,BOTTOM], [1,EScale,1]],
       [C6, R1, false,BACK+BackOffset,     [RIGHT,0,BOTTOM], [1,EScale,1]]],
      [0,0,0],
      false
    ],   
    [//C4R1 
      [[C4, R1, false,BACK,                [LEFT,0,BOTTOM], [1,RScale,1]],
       [C5, R1, false,BACK,                [LEFT,0,BOTTOM], [1,RScale,1]]],
      [[C4, R1, false,BACK+BackOffset,     [LEFT,0,BOTTOM], [1,EScale,1]],
       [C5, R1, false,BACK+BackOffset,     [LEFT,0,BOTTOM], [1,EScale,1]]],
      [0,0,0],
      false
    ],   
    [//C2R1 
      [[C2, R1, false,BACK,                [RIGHT,0,BOTTOM], [1,RScale,1]],
       [C4, R1, false,BACK,                [LEFT,0,BOTTOM], [1,RScale,1]]],
      [[C2, R1, false,BACK+BackOffset,     [RIGHT,0,BOTTOM], [1,EScale,1]],
       [C4, R1, false,BACK+BackOffset,     [LEFT,0,BOTTOM], [1,EScale,1]]],
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
      [[T0,  R2, false, BACK, [0,0,0],         [RScale,1,1]],
       [T2,  R1, false, BACK, [LEFT,0,0],      [1,1,1]],],
      [[T0,  R2, false, BACK, [LEFT,0,BOTTOM], [EScale,1,1]]],
      [0,0,0],
      true
    ],
    [//T1R1 Side 0
      [[T2,  R1, false, BACK, [LEFT,0,0],      [1,1,1]],],
      [[T2,  R1, false, BACK, [LEFT,0,BOTTOM], [EScale,1,1]],
       [T0,  R2, false, BACK, [LEFT,0,BOTTOM], [EScale,1,1]]],
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
  
//Hull struct contain the Estruct array IDe to hull bottom plate: concavity exsits so blind hull will result in failuer 
Hstruct = 
  [[0,1,2,3,25,26,27,28],
   [4,5,6,7,8,9,10,11,12,13,14,15,16,17],
   [5,18,19],
   [20,21,22,23],
   [5,20,24]
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
 