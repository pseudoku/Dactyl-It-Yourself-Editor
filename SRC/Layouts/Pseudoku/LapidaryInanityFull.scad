//
//-----  Enum Emulation
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
Alps   = 2;

//Cap type applys to MX only?
//Cherry = 0;
DSA = 1;
SA  = 2;
MT3 = 3;
//-----   Grid parameters
unit           = 18.05;  // 
Tol            = 0.001;  // tolance
HullThickness  = 0.0001; // modulation hull thickness
TopHeight      = 0;      // Reference Origin of the keyswitch 
BottomHeight   = 3.6;    // height adjustment used for R0 keys for cherry types

SwitchWidth    = 15.6;   // switch width 
PlateOffsets   = 2.5;    // additional pading on width of plates
PlateOffsetsY  = 2.5;    // additional padding on lenght of plates
PlateThickness = 3.5;    // switch plate thickness
PlateDim       = [SwitchWidth+PlateOffsets, SwitchWidth+PlateOffsetsY, PlateThickness];
PlateHeight    = 6.6;    //
SwitchBottom   = 4.8;    // from plate 
WebThickness   = PlateDim[0] - 2; // inter column hull inward offsets, 0 thickness results in poor plate thickness

//-----    Enclusure and plate parameter
RScale       = 2;        //Rim bottom scaling
EScale       = 2.5;      //Enclosure bottom scaling
PBuffer      = 0;       //additional Plate thickness
Bthickness   = PlateDim[0] - 2;  //thickness of the enclosure rim 
BFrontHeight = 0;                    //Height of frontside of the enclosure rim 
BBackHeight  = 0;                    //Height of Backside of the enclosure rim 
TFrontHeight = 0;
TBackHeight  = 0;
T0Buffer     = 3;                    //Additional Plate thickness buffer for T0 position.
T0BackH      = BBackHeight + T0Buffer;  //Adjuted height for T0

//-----     Tenting Parameters
tenting     = [0,0,0]; // tenting for enclusoure  
plateHeight = 0;       // height adjustment for enclusure 


//-----     Trackball Parameters
trackR      = 17;        //trackball raidus  M570: 37mm, Ergo and Kennington: 40mm
trackOrigin = [2,-25,7]; //trackball origin
trackTilt   = [0,0,0];    //angle for tilting trackpoint support and PCB

//-------  LAYOUT parameters
//column loop setter
CStart   = C1;  // Set column to begin looping for the build
CEnd     = C5;  // Set column to end for the build
TStart   = T1;  // Set Thumb Cluster Colum to begin
TEnd     = T4;  // Set Thumb Cluster to end 
colRange = concat([for (i = [CStart:CEnd]) i], [for (i = [TStart:TEnd]) i]); //columnar for loop range 
  
//structure to hold column origin transformation
ColumnOrigin = [//[translation vec]       [Global Rot]    [Local Rot]
                [[  -50, -unit*3/4,   0], [ 0,   0,   0], [ 0, 90,  0]], //INDEX 1 
                [[  -39,-unit*7/16,   0], [ 0,   0,   3], [ 0, 90,  0]], //INDEX 2 
                [[  -20,   -unit/4,   0], [ 0,   0,   3], [ 0, 90,  0]], //INDEX 3 
                [[    0,    unit/8,   0], [ 0,   0,   0], [ 0, 90,  0]], //MIDDLE 
                [[ 19.5,   -unit/8,   0], [ 0,   0,  -7], [ 0, 90,  0]], //RING 
//                [[ 33.0, -unit*5/8,   0], [ 0,   0,  -7], [ 0, 90,  0]], //PINKY 1 
                [[ 49.5, -unit*3/8,   0], [ 0,   0, -15], [ 0, 90,  0]], //PINKY 1
                [[ 47.5, -unit*3/8,   0], [ 0,   0, -15], [ 0, 90,  0]], //PINKY 2 
                [[ 58.0, -unit*3/8,   0], [ 0,   0, -15], [ 0, 90,  0]], //PINKY 3                 
                [[  -82,        -2,   0], [ 0,   0,  35], [ 0, 90,  0]], //Thumb Outer 
                [[-63.5,     -34.6,   0], [ 0,   0,   5], [ 0, 90,  0]], //Thumb OuterMid
                [[  -46,       -44,   0], [ 0,   0,  -5], [ 0, 90,  0]], //Thumb Middle
                [[  -28,       -47,   0], [ 0,   0, -10], [ 0, 90,  0]], //Thumb InnerMid
                [[   -5,     -48.6,   0], [ 0,   0, -15], [ 0, 90,  0]]  //Thumb Inner              
               ];
//prev build
//                [[  -82,        -2,   0], [ 0,   0,  35], [ 0, 90,  0]], //Thumb Outer 
//                [[  -56.5,   -36.8,   0], [ 0,   0,   5], [ 0, 90,  0]], //Thumb OuterMid
//                [[  -38,       -45,   0], [ 0,   0,  -5], [ 0, 90,  0]], //Thumb Middle
ThumbShift  = [[-0, 2, 0],[ 0, 0, 0],[ 0, 0, 0]]; //global transform for thumb cluster to jog as whole rather than editing origin

//-------  and adjustment parameters 

//row loop setter
//              C0:i1 C1:i2 C2:i3  C3:m  C4:r C5:p1 C6:p2 C7:p3 T0:Ot T1:OM T2:Md  T3:IM  T4:In
RowInits    = [   R2,    R0,   R0,   R0,   R0,   R0,   R0,   R0,   R1,   R1,    R1,   R1,    R1]; //set which Row to begin
RowEnds     = [   R2,    R2,   R2,   R2,   R2,   R2,   R1,   R1,   R1,   R1,    R1,   R1,    R1]; //set which Row to end

//Row transforms
RowTrans    = [[ -.18,  .04,  .04,  .04,  .04,   .2,   .2,   .2, -1.0,-1.25,-1.25,     0,     0], //R0
               [  .80,  .80,  .80,   .8,   .8,  .75,  .75,  1.2,    0,    0,   -0, -0.02,  -.02], //R1s
               [ 1.35, 1.56, 1.56, 1.56, 1.56, 1.84, 1.84, 1.65,    0, 1.05,    0, -0.02,     0], //R2s 
               [ 2.90, 2.90, 2.90, 2.90, 2.90, 2.55, 2.55, 2.55,    0, 1.75,    0,     0,     0], //R3s
               [ 3.80, 3.80, 3.80, 3.80, 3.80,    1,  .83,    3,    0,    0,    0,     0,     0], //R4
               [ 4.45, 4.45, 4.45, 4.45, 4.45,    4,   -4,    4,    0,    0,    0,     0,     0]  //R5           
              ]*unit; 

ColTrans    = [[    0,    0,    0,    0,    0,    0,    0,    0,    0,   .3,    0,     0,     0], //R0
               [    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0], //R1s
               [    0,    0,    0,    0,    0, -1.0,    0,    0,    0,    0,    0,   -.4,     0], //R2s 
               [    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0], //R3s
               [    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0], //R4
               [    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0]  //R5           
              ]*unit; 
              
Pitch       = [[    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0],  //R0
               [    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0],  //R1s
               [    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0],  //R2s 
               [    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0],  //R3
               [    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0],  //R4
               [    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0]   //R5
              ];

Roll        = [[   -4,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0],  //R0
               [   -5,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0],  //R1s
               [   -0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    80,     0],  //R2s 
               [   -7,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0],  //R3
               [   -8,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0],  //R4
               [   -10,   0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0]   //R5
              ];         
              
Height      = [[    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0],  //R0
               [    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0],  //R1s
               [    0,    0,    0,    0,    0,    0,    0,    0,    0,   -8,    0,   -12,     0],  //R2s 
               [    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0],  //R3
               [    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0],  //R4
               [    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0]   //R5
              ]; 
//-----     border Customization

// define Columns will needs Left or Right borders not catched by Generic calls 
Lborder    =  [[C1], //R0
               [C1], //R1
               [C1], //R2
               [], //R3
               [], //R4
               []  //R5
              ]; //color "DarkGreen"
Rborder    =  [[C7], //R0
               [C7, T3], //R1
               [C5], //R2
               [], //R3
               [], //R4
               []  //R5
              ]; //color "YellowGreen"
              
//define Spical border Hull to make border pretty             
Sborder = //color "Crimson"
 [
//[[Col, Row, len = true, Jog direction, HullFace, Scale], ...], 
//  [[T0, R1, false, BACK, [RIGHT,0,0], [1,RScale,1]], [T1, R1, false,  BACK, [LEFT,0,0], [1,RScale,1]]],
//  [[C4, R2, true, RIGHT, [0,0,0], [1,1,1]],[C5, R2, true,  LEFT, [0,0,0], [1,1,1]],[C5, R2, false,  FRONT, [LEFT,0,0], [1,1,1]]]
 ];

//define Spical border Hull to join Column and Thumb Cluster 
TCJoints = //color "Salmon"
 [
  [[C1, RowInits[C1], false,  BACK,         [0,0,0], [1,RScale,1]], 
   [C2, RowInits[C2], false,  BACK,         [0,0,0], [1,RScale,1]], 
   [T3,  RowEnds[T3], false,  FRONT,     [0,0,0], [1,RScale,1]],
  ],
  
  [[C2, RowInits[C2], false,  BACK,         [RIGHT,0,0], [1,RScale,1]], 
   [T3,  RowEnds[T3], true,  RIGHT,     [0,0,0], [RScale,1,1]],
  ],
  
  [[C1, RowInits[C1], false,  BACK,      [LEFT,0,0], [1,RScale,1]], 
   [T2,  RowEnds[T2], false,  FRONT,     [0,0,0], [1,RScale,1]],
   [T3,  RowEnds[T3], false,  FRONT,     [LEFT,0,0], [1,RScale,1]],
  ],
//  [[C1, RowInits[C1], false,  BACK,   [LEFT,BACK,0], [1,RScale,1]], 
//   [C1, RowInits[C1],  true,  LEFT,   [LEFT,BACK,0], [RScale,1,1]], 
//   [T2,  RowEnds[T2], false, FRONT,     [RIGHT,0,0], [1,RScale,1]],
//   [T2,  RowEnds[T2],  true, RIGHT,     [0,FRONT,0], [RScale,1,1]]],
//   
//  [[C1, RowInits[C1],  true,  LEFT,      [LEFT,0,0], [RScale,1,1]], 
//   [T2,  RowEnds[T2], false, FRONT, [RIGHT,FRONT,0], [1,RScale,1]],
//   [T1,  RowEnds[T1], false, FRONT,     [RIGHT,0,0], [1,RScale,1]]],
//   
////  [[C1, RowInits[C1],  true,  LEFT,      [LEFT,0,0], [RScale,1,1]],
////   [C0, RowInits[C0], false,  BACK,      [LEFT,0,0], [1,RScale,1]],
////   [C0, RowInits[C0],  true,  LEFT,      [0,BACK,0], [RScale,1,1]],
////   [T2,  RowEnds[T2], false, FRONT, [RIGHT,FRONT,0], [1,RScale,1]],
////   [T1,  RowEnds[T1], false, FRONT,     [RIGHT,0,0], [1,RScale,1]]],
//   
//  [[C1, RowInits[C1],  true,  LEFT,     [0,FRONT,0], [RScale,1,1]],
//   [C1, RowInits[C1],  true,  LEFT,      [0,BACK,0], [RScale,1,1]],
//   [T1,  RowEnds[T1], false, FRONT,     [0,0,0], [1,RScale,1]]],
 ];
//define Jointing between Thumb Cluster and Column 

//-----     IGNORE IF YOU are not using Clipped switch 
xLen         = 4;        //3.4 cut length for clipped khail  4 for MX 
xLenM        = xLen-0;   //fudging to get cleaner border               
//Manual Adjustment of Pitches post Calculation for minor adjustment    
//              C0:i1 C1:i2  C2:i3   C3:m   C4:r  C5:p1  C6:p2  C7:p3  T0:Ot T1:OM T2:Md  T3:IM  T4:In
Clipped      =[[   1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,     1,     1,    1,     1,    1],  //R0
               [   1,     0,    -0,    -0,    -0,     1,     1,    -1,     1,     1,   -1,    -1,   -0],  //R1s
               [   1,     1,     1,     1,     1,    -1,    -1,     1,     1,     1,    1,     1,    1],  //R2s 
               [   1,     1,    -1,     1,     1,     1,    -1,    -1,     1,     1,    1,     1,    1],  //R3
               [   1,     1,     1,    -1,    -1,     1,    -1,    -1,     1,     1,    1,     1,    1],  //R4
               [   1,     1,     1,     1,    -1,     1,    -1,     1,     1,     1,    1,     1,    1]   //R5
              ]*xLen;

//Orientation of the clippede switches
ClippedOrientation = //if length-wise true 
//               C0:i1  C1:i2  C2:i3  C3:m   C4:r   C5:p1  C6:p2  C7:p3  T0:Ot T1:OM T2:Md  T3:IM  T4:In
              [[ true,  true,  true,  true,  true,  true,  true, false,  true,  true,  true,  true,  true],  
               [ true,  true,  true,  true,  true,  true, true, false,  false, false, false,false,  true],
               [false,  true,  true,  true,  true,  false,false,  true,  true,  true,  true, false,  true],
               [ true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true],
               [ true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true],
               [ true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true]
              ]; 
              
CapScale     =[[   1,     1,     1,     1,     1,     1,     1,     1,     1,     1,    1,     1,    1],  //R0
               [   1,     1,     1,     1,     1,     1,     1,     1,     1,     1,    1,     1,    1],  //R1s
               [   1,     1,     1,     1,     1,     1,     1,     1,     1,     1,    1,     1,    1],  //R2s 
               [   1,     1,     1,     1,     1,     1,     1,     1,     1,     1,    1,     1,    1],  //R3
               [   1,     1,     1,     1,     1,     1,     1,     1,     1,     1,    1,     1,    1],  //R4
               [   1,     1,     1,     1,     1,     1,     1,     1,     1,     1,    1,     1,    1]   //R5
              ];
KeyOriginCnRm = [for( i= [C0:C7])[[0,BottomHeight],0], for(j = [R1:R4])[0,TopHeight,0]];
 