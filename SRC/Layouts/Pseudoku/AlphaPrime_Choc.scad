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

//Switch Type
MX   = 0;  // Generic MX
Choc = 1;  // Low profile 
Alps = 2;  // For Your Superiority Complex's Needs

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
PBuffer      = -1;       //additional Plate thickness
Bthickness   = PlateDim[0] - 2;  //thickness of the enclosure rim 
BFrontHeight = 3;                    //Height of frontside of the enclosure rim 
BBackHeight  = 3;                    //Height of Backside of the enclosure rim 
T0Buffer     = 0;                    //Additional Plate thickness buffer for T0 position.
T0BackH      = BBackHeight + T0Buffer;  //Adjuted height for T0

//-----     Tenting Parameters
tenting     = [0,13,0]; // tenting for enclusoure  
plateHeight = 25;       // height adjustment for enclusure 


//-----     Trackball Parameters
trackR      = 17;        //trackball raidus  M570: 37mm, Ergo and Kennington: 40mm
trackOrigin = [2,-25,7]; //trackball origin
trackTilt   = [0,0,0];    //angle for tilting trackpoint support and PCB

//-------  LAYOUT parameters
//column loop setter
CStart   = C1;  // Set column to begin looping for the build
CEnd     = C5;  // Set column to end for the build
TStart   = T0;  // Set Thumb Cluster Colum to begin
TEnd     = T2;  // Set Thumb Cluster to end 
colRange = concat([for (i = [CStart:CEnd]) i], [for (i = [TStart:TEnd]) i]); //columnar for loop range 
  
//structure to hold column origin transformation
ColumnOrigin = [//[translation vec]       [Global Rot]    [Local Rot]
                [[  -54, -unit*3/4,   1], [ 0,   0,   0], [ 0, 90,  0]], //INDEX 1 
                [[  -36,-unit*7/16,   0], [ 0,   0,   0], [ 0, 90,  0]], //INDEX 2 
                [[  -18,   -unit/4,  -2], [ 0,   0,   0], [ 0, 90,  0]], //INDEX 3 
                [[    0,         0,  -5], [ 0,   0,   0], [ 0, 90,  0]], //MIDDLE 
                [[   18,   -unit/4,   0], [ 0,   0,  -0], [ 0, 90,  0]], //RING 
                [[ 37.0, -unit*5/8,  12], [ 0,   5, -15], [ 0, 90,  0]], //PINKY 1 
                [[ 53.0, -unit*5/8,  16], [ 0,  10, -15], [ 0, 90,  0]], //PINKY 2 
                [[ 67.0, -unit*5/8,  21], [ 0,  15, -15], [ 0, 90,  0]], //PINKY 3                 
                [[  -61,       -10, -27], [ 0,   0,  10], [-5, 95,  0]], //Thumb Outer 
                [[  -36,       -22, -14], [ 0,   0,   0], [ 0, 90,-60]], //Thumb OuterMid
                [[  -29,     -13.5,   3], [ 0,   0,   0], [ 0, 90,-60]], //Thumb Midlde
                [[  -36,       -22, -14], [ 0,   0,   0], [ 0, 90,-60]], //Thumb InnerMid
                [[  -29,     -13.5,   3], [ 0,   0,   0], [ 0, 90,-60]]  //Thumb Inner              
               ];

ThumbShift  = [[-0,-5, 0],[ 0, -5, 0],[ 0, 0, 0]]; //global transform for thumb cluster to jog as whole rather than editing origin

//-------  and adjustment parameters 

//row loop setter
//              C0:i1 C1:i2 C2:i3  C3:m  C4:r C5:p1 C6:p2 C7:p3 T0:Ot T1:OM T2:Md  T3:IM  T4:In
RowInits    = [   R2,    R1,   R1,   R1,   R1,   R1,   R0,   R0,   R1,   R1,    R1,   R1,    R0]; //set which Row to begin
RowEnds     = [   R2,    R2,   R2,   R2,   R2,   R3,   R2,   R0,   R1,   R2,    R1,   R1,    R0]; //set which Row to end

//Row transforms
RowTrans    = [[ -.18, -.18, -.18, -.18, -.18, -.55, -.55, -.55, -1.0,-1.25,-1.25,     0,     0], //R0
               [  .80,  .80,  .80,   .8,   .8,  .45,  .45,  .45,    0,    0, -.25,     0,     0], //R1s
               [ 1.95, 1.95, 1.95, 1.95, 1.95, 1.60, 1.60, 1.60,    0, 1.05,    0,     0,     0], //R2s 
               [ 2.90, 2.90, 2.90, 2.90, 2.90, 2.55, 2.55, 2.55,    0, 1.75,    0,     0,     0], //R3s
               [ 3.80, 3.80, 3.80, 3.80, 3.80,    1,  .83,    3,    0,    0,    0,     0,     0], //R4
               [ 4.45, 4.45, 4.45, 4.45, 4.45,    4,   -4,    4,    0,    0,    0,     0,     0]  //R5           
              ]*unit; 
              
Pitch       = [[   25,   25,   25,   25,   25,   25,   25,   25,   10,   10,  -10,     0,     0],  //R0
               [   15,   15,   15,   15,   15,   15,   15,   15,    0,  -15,  -25,     0,     0],  //R1s
               [  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,    0,  -40,    0,     0,     0],  //R2s 
               [  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,    0,  -60,    0,     0,     0],  //R3
               [  -45,  -45,  -45,  -45,  -45,    0,    0,    0,    0,    0,    0,     0,     0],  //R4
               [  -58,  -58,  -58,  -58,  -58,    0,    0,    0,    0,    0,    0,     0,     0]   //R5
              ];

Roll        = [[   -4,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0],  //R0
               [   -5,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0],  //R1s
               [   -0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0],  //R2s 
               [   -7,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0],  //R3
               [   -8,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0],  //R4
               [   -10,   0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0]   //R5
              ];         
              
Height      = [[ -6.5, -6.5, -6.5, -6.5, -6.5, -6.5, -6.5, -6.5,    1,    0,    7,     0,     0],  //R0
               [    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0],  //R1s
               [    0,    0,    0,    0,    0,    0,    0,    0,    0,   -8,    0,     0,     0],  //R2s 
               [ -6.5, -6.5, -6.5, -6.5, -6.5, -6.5, -6.5, -6.5,    0,  -24,    0,     0,     0],  //R3
               [  -18,  -18,  -18,  -18,  -18,    0,    0,    0,    0,    0,    0,     0,     0],  //R4
               [  -33,  -33,  -33,  -33,  -33,    0,    0,    0,    0,    0,    0,     0,     0]   //R5
              ]; 
//-----     border Customization

// define Columns that will have borders 
Lborder    = [[], //R0
               [C1, C5,  T0], //R1
               [C1, T1], //R2
               [], //R3
               [], //R4
               []  //R5
              ]; //color "DarkGreen"
Rborder    = [[], //R0
               [C5, T2], //R1
               [C4, C5, T1], //R2
               [], //R3
               [], //R4
               []  //R5
              ]; //color "YellowGreen"
              
//define Spical border Hull to make border pretty             
Sborder = //color "Crimson"
 [
//[[Col, Row, len = true, Jog direction, HullFace, Scale], ...], 
  [[T0, R1, false, BACK, [RIGHT,0,0], [1,RScale,1]], [T1, R1, false,  BACK, [LEFT,0,0], [1,RScale,1]]],
  [[C4, R2, true, RIGHT, [0,0,0], [1,1,1]],[C5, R2, true,  LEFT, [0,0,0], [1,1,1]],[C5, R2, false,  FRONT, [LEFT,0,0], [1,1,1]]]
 ];

//define Spical border Hull to join Column and Thumb Cluster 
TCJoints = //color "Salmon"
 [
  [[C1, RowInits[C1], false,  BACK,         [0,0,0], [1,RScale,1]], 
   [C2, RowInits[C2], false,  BACK,         [0,0,0], [1,RScale,1]], 
   [T2,  RowEnds[T2],  true, RIGHT,     [0,0,0], [RScale,1,1]],
  ],
  
  [[C1, RowInits[C1], false,  BACK,   [LEFT,BACK,0], [1,RScale,1]], 
   [C1, RowInits[C1],  true,  LEFT,   [LEFT,BACK,0], [RScale,1,1]], 
   [T2,  RowEnds[T2], false, FRONT,     [RIGHT,0,0], [1,RScale,1]],
   [T2,  RowEnds[T2],  true, RIGHT,     [0,FRONT,0], [RScale,1,1]]],
   
  [[C1, RowInits[C1],  true,  LEFT,      [LEFT,0,0], [RScale,1,1]], 
   [T2,  RowEnds[T2], false, FRONT, [RIGHT,FRONT,0], [1,RScale,1]],
   [T1,  RowEnds[T1], false, FRONT,     [RIGHT,0,0], [1,RScale,1]]],
   
//  [[C1, RowInits[C1],  true,  LEFT,      [LEFT,0,0], [RScale,1,1]],
//   [C0, RowInits[C0], false,  BACK,      [LEFT,0,0], [1,RScale,1]],
//   [C0, RowInits[C0],  true,  LEFT,      [0,BACK,0], [RScale,1,1]],
//   [T2,  RowEnds[T2], false, FRONT, [RIGHT,FRONT,0], [1,RScale,1]],
//   [T1,  RowEnds[T1], false, FRONT,     [RIGHT,0,0], [1,RScale,1]]],
   
  [[C1, RowInits[C1],  true,  LEFT,     [0,FRONT,0], [RScale,1,1]],
   [C1, RowInits[C1],  true,  LEFT,      [0,BACK,0], [RScale,1,1]],
   [T1,  RowEnds[T1], false, FRONT,     [0,0,0], [1,RScale,1]]],
 ];
//define Jointing between Thumb Cluster and Column 

//-----     IGNOR IF YOU are not using Clipped switch 
xLen           = 0;        //3.4 cut length for clipped khail 
xLenM          = xLen+0;   //fudging to get cleaner border               
//Manual Adjustment of Pitches post Calculation for minor adjustment    
//              C0:i1 C1:i2  C2:i3   C3:m   C4:r  C5:p1  C6:p2  C7:p3 T0:out T1:mid T3:in 
Clipped      =[[   1,     1,     1,     1,     1,    -1,     1,     1,     1,     1,    1],  //R0
               [   1,    -1,    -1,    -1,    -1,    -1,     1,     1,     1,     1,    1],  //R1s
               [   1,     1,     1,     1,     1,     1,    -1,     1,     1,     1,    1],  //R2s 
               [   1,     1,    -1,     1,     1,     1,    -1,    -1,     1,     1,    1],  //R3
               [   1,     1,     1,    -1,    -1,     1,    -1,    -1,     1,     1,    1],  //R4
               [   1,     1,     1,     1,    -1,     1,    -1,     1,     1,     1,    1]   //R5
              ]*xLen;

//Orientation of the clippede switches
ClippedOrientation = //if length-wise true 
              [[ true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true],  
               [ true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true],
               [ true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true],
               [ true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true],
               [ true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true],
               [ true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true]
              ]; 
              
KeyOriginCnRm = [for( i= [C0:C7])[[0,BottomHeight],0], for(j = [R1:R4])[0,TopHeight,0]];
 