/*
          INCOMPLETE
Designer: Pseudoku & Smeeba
Summary:  (4x2+3)+(1,2,0) TB split Choc
Concept:  idealistic steno for people who never touched it before.
          elimiate lateral movement by bring the design down to only one column per finger

*/
//-----  Enum
R0 = 0; //Rows
R1 = 1;
R2 = 2;
R3 = 3;
R4 = 4;
R5 = 5;

C0 = 0; //Columns
C1 = 1;
C2 = 2;
C3 = 3;
C4 = 4;
C5 = 5;
C6 = 6;
C7 = 7;

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
unit           = 18.05;  //
Tol            = 0.001;  // tolance
HullThickness  = 0.0001; // modulation hull thickness
TopHeight      = 0;      // Reference Origin of the keyswitch
BottomHeight   = 3.6;    // height adjustment used for R0 keys for cherry types

SwitchWidth    = 15.6;   // switch width
PlateOffsets   = 2.5;    // additional pading on width of plates
PlateOffsetsY  = 2.5;    // additional padding on lenght of plates
PlateThickness = 3.5;     // switch plate thickness
PlateDim       = [SwitchWidth+PlateOffsets, SwitchWidth+PlateOffsetsY, PlateThickness];
PlateHeight    = 6.6;    //
SwitchBottom   = 4.8;    // from plate
WebThickness   = PlateDim[0] - 2; // inter column hull inward offsets, 0 thickness results in poor plate thickness

//-----    Enclusure and plate parameter
RScale       = 2;        //Rim bottom scaling
EScale       = 2.5;      //Enclosure bottom scaling
PBuffer      = 0;       //additional Plate thickness
BorderAlign  = TOP;     //high pro or flushed
Bthickness   = PlateDim[0] - 2;  //thickness of the enclosure rim
BFrontHeight = 0;                    //Height of frontside of the enclosure rim
BBackHeight  = 0;                    //Height of Backside of the enclosure rim
TFrontHeight = 0;
TBackHeight  = 0;
T0Buffer     = 0;                    //Additional Plate thickness buffer for T0 position.
T0BackH      = BBackHeight + T0Buffer;  //Adjuted height for T0
holeOffset   = 0;

//-----  Bottom Enclosure Offsets: Adjust how bottom casing offset from top plate
LeftOffset  = .75;
FrontOffset = 0;
RightOffset = 0;
BackOffset  = -.5;
ThumbOffset = .2;

//-----     Tenting Parameters
// tenting     = [0,0,0]; // tenting for enclusoure
// plateHeight = 25;       // height adjustment for enclusure

tenting     = [-10,20,0]; // tenting for enclusoure
plateHeight = 25;       // height adjustment for enclusure

//-----     Trackball Parameters
trackR      = 17;        //trackball raidus  M570: 34mm, Ergo and Kennington: 40mm
trackOrigin = [-16,-24,-3]; //trackball origin
trackTilt   = [65,10,-70];    //angle for tilting trackpoint support and PCB
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
mountScrew  = [[-15,-30,0],[52,-6,0],[-23,38,0],[42,34,0]];
mountHull   = [20,30,8,13];
mountDia    = 3.0; // 3.2mm

MCULoc      = [-15,280,7.1];
MCUDim      = [18.5, 32.5, 1.2];

resetLoc    = [0,0,0];

USBLoc      = [-15,22.5-5+36.5/2,6+1.2];

// TRRS Jack
JackLoc     = [-10,20,7.5];
JackDim     = [18,6,10];
JackAng     = [0,0,190];

//-------  LAYOUT parameters
//column loop setter
CStart   = C2;  // Set column to begin looping for the build
CEnd     = C5;  // Set column to end for the build
TStart   = T0;  // Set Thumb Cluster Colum to begin
TEnd     = T1;  // Set Thumb Cluster to end
colRange = concat([for (i = [CStart:CEnd]) i], [for (i = [TStart:TEnd]) i]); //columnar for loop range
//colRange = [for (i = [CStart:CEnd]) i];

//structure to hold column origin transformation
ColumnOrigin = [//[translation vec]               [Global Rot]    [Local Rot]
                [ [       -54,   -unit*3/4,   1],  [ 0,   0,   0], [ 0, 90,  0]], //INDEX 1                                                   //Not Used
                [ [  -20-unit,   -unit*3/8,   0],  [ 0,   0,   3], [ 0, 90,  0]], //INDEX 2         [-38.05,-6.76875,0] [0,0,3]     [0,90,0]
                [ [       -20,   -unit*3/8,   0],  [ 0,   0,   3], [ 0, 90,  0]], //INDEX 3         [-20,-6.76875,0]    [0,0,3]     [0,90,0]
                [ [         0,    unit*2/8,  -5],  [ 0,   0,   0], [ 0, 90,  0]], //MIDDLE          [0,4.5125,-5]       [0,0,0]     [0,90,0]
                [ [        20,     -unit/8,   2],  [ 0,   5,  -5], [ 0, 90,  0]], //RING            [20,-2.25625,2]     [0,5,-5]    [0,90,0]
                [ [        41,   -unit*5/8,  12],  [ 0,  10, -15], [ 0, 90,  0]], //PINKY 1         [41,-4.5125,13]     [0,10,-15]  [0,90,0]
                [ [        41,   -unit*4/8,  16],  [ 0,  10, -15], [ 0, 90,  0]], //PINKY 2         [41,-9.025,16]      [0,10,-15]  [0,90,0]  //Not used
                [ [        67,   -unit*5/8,  21],  [ 0,  15, -15], [ 0, 90,  0]], //PINKY 3                                                   //Not Used
                [ [       -46,         -22, -23],  [ 0,   0,   0], [ 0, 90,-60]], //Thumb Outer     [-46,-22,-23]       [0,0,0]     [0,90,-60]
                [ [       -46,         -22, -23],  [ 0,   0,   0], [ 0, 90,-60]], //Thumb OuterMid  [-46,-22,-23]       [0,0,0]     [0,90,-60]
                [ [       -29,       -13.5,   3],  [ 0,   0,   0], [ 0, 90,-60]], //Thumb Midlde                                             //Not Used
                [ [       -36,         -22, -14],  [ 0,   0,   0], [ 0, 90,-60]], //Thumb InnerMid                                           //Not Used
                [ [        20,     -unit/8,   0],  [ 0,   0, -10], [ 0, 90,  0]]  //Ring Rotary Encoder                                      //Not Used
               ];

//ThumbShift  = [[-7,-8, 7],[ 0, -5, 0],[ 0, 0, 0]]; //global transform for thumb cluster to jog as whole rather than editing origin
//ThumbShift  = [[-5,-8, 7],[ 0, -5, 5],[ 0, 0, 0]];
ThumbShift  = [[-5,-8, 3],[ 0, -5, 5],[ 0, 0, 0]]; //global transform for thumb cluster to jog as whole rather than editing origin without trackball

//-------  and adjustment parameters

//row loop setter
//              C0:i1 C1:i2 C2:i3  C3:m  C4:r C5:p1 C6:p2 C7:p3 T0:Ot T1:OM T2:Md  T3:IM  T4:In
RowInits    = [   R2,    R1,   R0,   R0,   R0,   R1,   R2,   R0,   R2,   R1,    R1,   R1,    R0]; //set which Row to begin
RowEnds     = [   R2,    R2,   R2,   R2,   R2,   R2,   R2,   R0,   R2,   R2,    R1,   R1,    R0]; //set which Row to end

//Col Transforms (Translate Along X Axis)
ColTrans    = [[    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0], //R0
               [    0,    0,    0,    0,    0,    0,    0,    0,    0,   .1,    0,     0,     0], //R1
               [    0,    0,    0,    0,    0,    0,    0,    0, -.30,  .80,    0,     0,     0], //R2
               [    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0], //R3
               [    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0], //R4
               [    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0]  //R5
              ]*unit;

//Row Transforms (Translate Along Y Axis)
RowTrans    = [[    0,    0,  -.1,  -.1,  -.1,    0,    0,    0,    0,    0,    0,     0,     0], //R0
               [    0,   .8,   .8,   .8,   .8,   .8,    0,    0,    0,  -.1,    0,     0,     0], //R1
               [    0, 1.95, 1.95, 1.95, 1.95, 1.95,    0,    0, 0.95, 0.95,    0,     0,     0], //R2
               [    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0], //R3
               [    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0], //R4
               [    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0]  //R5
              ]*unit;

//Height Transforms (Transform Along Z Axis)
Height      = [[    0,    0,-3.65,-3.65,-3.65,    0,    0,    0,    0,    0,    0,     0,     0],  //R0
               [    0,    0,    0,    0,    0,    0,    0,    0,    0,  9.8,    0,     0,     5],  //R1
               [    0,    0,    0,    0,    0,    0,    0,    0,    2,    2,    0,     0,     0],  //R2
               [    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0],  //R3
               [    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0],  //R4
               [    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0]   //R5
              ];

//Pitch Transforms (Rotate Along X Axis)
Pitch       = [[    0,    0,   10,   10,   10,    0,    0,    0,    0,    0,    0,     0,     0],  //R0
               [    0,   15,   15,   15,   15,   15,    0,    0,    0,  -15,    0,     0,     0],  //R1
               [    0,  -15,  -15,  -15,  -15,  -15,    0,    0,  -25,  -25,    0,     0,     0],  //R2
               [    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0],  //R3
               [    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0],  //R4
               [    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0]   //R5
              ];

//Roll Transforms (Rotate Along Y Axis)
Roll        = [[    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0],  //R0
               [    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0],  //R1
               [    0,    0,    0,    0,    0,    0,    0,    0,  -10,   10,    0,     0,     0],  //R2
               [    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0],  //R3
               [    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0],  //R4
               [    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0]   //R5
              ];

CapScale     =[[   1,     1,    1,    1,    1,    1,    1,    1,    1,    1,    1,     1,    1],  //R0
               [   1,     1,    1,    1,    1,    1,    1,    1,    1,  1.5,    1,     1,    1],  //R1
               [   1,     1,    1,    1,    1,    1,    1,    1,    1,    1,    1,     1,    1],  //R2
               [   1,     1,    1,    1,    1,    1,    1,    1,    1,    1,    1,     1,    1],  //R3
               [   1,     1,    1,    1,    1,    1,    1,    1,    1,    1,    1,     1,    1],  //R4
               [   1,     1,    1,    1,    1,    1,    1,    1,    1,    1,    1,     1,    1]   //R5
              ];

SwitchTypes = //MX | Choc
              [[Choc,  Choc,  Choc,  Choc,  Choc,  Choc,  Choc,  Choc,  Choc,  Choc,  Choc,  Choc,  Choc],
               [Choc,  Choc,  Choc,  Choc,  Choc,  Choc,  Choc,  Choc,  Choc,  Choc,  Choc,  Choc,  Choc],
               [Choc,  Choc,  Choc,  Choc,  Choc,  Choc,  Choc,  Choc,  Choc,  Choc,  Choc,  Choc,  Choc],
               [Choc,  Choc,  Choc,  Choc,  Choc,  Choc,  Choc,  Choc,  Choc,  Choc,  Choc,  Choc,  Choc],
               [Choc,  Choc,  Choc,  Choc,  Choc,  Choc,  Choc,  Choc,  Choc,  Choc,  Choc,  Choc,  Choc],
               [Choc,  Choc,  Choc,  Choc,  Choc,  Choc,  Choc,  Choc,  Choc,  Choc,  Choc,  Choc,  Choc],
              ];

SwitchOrientation = //if length-wise true
              [[ true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true],
               [ true,  true,  true,  true,  true,  true,  true,  true,  true,  true, false,  true,  true],
               [ true,  true,  true,  true,  true,  true,  true,  true,  true, false, false,  true,  true],
               [ true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true],
               [ true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true],
               [ true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true]
              ];
//-----     border Customization

// define Columns will needs Left or Right borders not catched by Generic calls
TopCuts = [];

PBind = [[C3,RIGHT,0],[C4,RIGHT,0]]; //list of BindColumns to build and bind sides (Not really sure what it does but I'm not touching)

// Define custom connectors between keys
PlateCustomBind  =
  [
   //Index to middle
   [[C2,R1,RIGHT,[0,0,0],0],
    [C3,R0,LEFT, [LEFT,0,0],0]],
   [[C2,R1,RIGHT,[0,FRONT,0],0],
    [C3,R1,LEFT, [LEFT,0,0],0]],
   [[C2,R1,RIGHT,[0,FRONT,0],0],
    [C2,R2,RIGHT,[0,BACK,0],0],
    [C3,R1,LEFT, [LEFT,FRONT,0],0]],
   [[C2,R2,RIGHT,[0,0,0],0],
    [C3,R1,LEFT, [LEFT,FRONT,0],0],
    [C3,R2,LEFT, [LEFT,BACK,0],0]],
   [[C2,R2,RIGHT,[0,FRONT,0],0],
    [C3,R2,LEFT, [LEFT,0,0],0]],

  //Thumb Connectors
  [[T0,R2,LEFT, [0,BACK,0],0],
   [T0,R2,RIGHT, [0,BACK,0],0],
   [T1,R1,LEFT, [0,FRONT,0],0]],
  [[T1,R2,LEFT, [0,BACK,0],0],
   [T1,R2,RIGHT, [0,BACK,0],0],
   [T1,R1,RIGHT, [0,FRONT,0],0]],
  [[T1,R2,LEFT, [0,BACK,0],0],
   [T0,R2,RIGHT, [0,BACK,0],0],
   [T1,R1,RIGHT, [0,FRONT,0],0],
   [T1,R1,LEFT, [0,FRONT,0],0]],
  [[T0,R2,RIGHT, [RIGHT,0,0],0],
   [T1,R2,LEFT, [LEFT,0,0],0]],
  ];

//define Spical border Hull to make border pretty
Sborder = //color "Crimson"
  [
  //Front

  [[C2,  RowEnds[C2], false, FRONT,    [0,0,0],    [1,RScale,1]], //fill gap between general border and Bottom Enclosure near C3
   [C3,  RowEnds[C3], false, FRONT, [LEFT,0,0],   [1,RScale,1]]],

  [[C3,  RowEnds[C3], false, FRONT,    [0,0,0],   [1,RScale,1]]],

  [[C3,  RowEnds[C3], false, FRONT, [RIGHT,0,0],   [1,RScale,1]],
   [C4,  RowEnds[C4], false, FRONT,     [0,0,0],  [1,RScale,1]]],

  [[C4,  RowEnds[C4], false, FRONT, [RIGHT,0,0],   [1,RScale,1]], //fill gap between general border and Bottom Enclosure near C4
   [C5,  RowEnds[C5], false, FRONT,     [0,0,0],  [1,RScale,1]]],

   //BACK

  [[C2, RowInits[C2], false, BACK,      [0,0,0], [1,RScale,1]], //fill gap between general border and Bottom Enclosure near C3
    [C3,RowInits[C3], false, BACK,   [LEFT,0,0],     [1,RScale,1]]],

  [[C3, RowInits[C3], false, BACK,      [0,0,0], [1,RScale,1]]],

  [[C3, RowInits[C3], false, BACK,  [RIGHT,0,0], [1,RScale,1]], //fill gap between general border and Bottom Enclosure near C4
    [C4,RowInits[C4], false, BACK,   [LEFT,0,0],     [1,RScale,1]]],

  [[C4, RowInits[C4], false, BACK,      [0,0,0], [1,RScale,1]]],

  [[C4, RowInits[C4], false, BACK,  [RIGHT,0,0], [1,RScale,1]], //fill gap between general border and Bottom Enclosure near C5
    [C5,RowInits[C5], false, BACK,   [LEFT,0,0],     [1,RScale,1]]],

  [[C5, RowInits[C5], false, BACK,      [0,0,0], [1,RScale,1]]],


  //LEFT

  [[C2,  RowEnds[C2], false, FRONT,  [LEFT,0,0], [1,RScale,1]],
   [C2,  RowEnds[C2],  true, LEFT,      [0,0,0], [RScale,1,1]]],

  [[C2,  RowEnds[C2],  true, LEFT,      [0,0,0], [RScale,1,1]]],

  [[C2,  RowEnds[C2],  true, LEFT,   [0,BACK,0], [RScale,1,1]],
   [C2, RowInits[C2],  true, LEFT,  [0,FRONT,0], [RScale,1,1]]],

  [[C2, RowInits[C2],  true, LEFT,      [0,0,0], [RScale,1,1]]],

  [[C2,  RowInits[C2], false, BACK,  [LEFT,0,0], [1,RScale,1]],
   [C2,  RowInits[C2],  true, LEFT,      [0,0,0], [RScale,1,1]]],

  [[C5,  RowEnds[C5], false, FRONT,  [RIGHT,0,0], [1,RScale,1]],
   [C5,  RowEnds[C5],  true, RIGHT,      [0,0,0], [RScale,1,1]]],

  [[C5,  RowEnds[C5],  true, RIGHT,      [0,0,0], [RScale,1,1]]],

  [[C5,  RowEnds[C5],  true, RIGHT,   [0,BACK,0], [RScale,1,1]],
   [C5, RowInits[C5],  true, RIGHT,  [0,FRONT,0], [RScale,1,1]]],

  [[C5, RowInits[C5],  true, RIGHT,      [0,0,0], [RScale,1,1]]],

  [[C5, RowInits[C5], false,  BACK,  [RIGHT,0,0],   [1,RScale,1]], //fill gap between general border and Bottom Enclosure near C5
   [C5, RowInits[C5],  true,  RIGHT,  [0,BACK,0],  [RScale,1,1]]],



//Thumbs
 //fronts
  [[T0,  RowEnds[T0], false, FRONT,  [LEFT,0,0],  [1,RScale,1]],
   [T0,  RowEnds[T0],  true,  LEFT, [0,FRONT,0], [RScale,1,1]]],

  [[T0,  RowEnds[T0], false, FRONT,     [0,0,0],    [1,RScale,1]]],

  [[T0,  RowEnds[T1], false, FRONT,  [RIGHT,0,0],  [1,RScale,1]],
   [T1,  RowEnds[T1], false,  FRONT, [LEFT,0,0], [1,RScale,1]]],

  [[T1,  RowEnds[T1], false, FRONT,     [0,0,0],    [1,RScale,1]]],

  [[T1,  RowEnds[T1], false, FRONT,  [RIGHT,0,0],  [1,RScale,1]],
   [T1,  RowEnds[T1],  true,  RIGHT, [0,FRONT,0], [RScale,1,1]]],

  //Left

  [[T1, RowInits[T1],  true, LEFT,      [0,0,0],    [RScale,1,1]],
   [T0,  RowEnds[T0],  true, LEFT,   [0,BACK,0], [RScale,1,1]]],

  [[T0,  RowEnds[T0],  true, LEFT,      [0,0,0], [RScale,1,1]]],

 //Right

  [[T1, RowInits[T1], false, BACK,  [RIGHT,0,0], [1,1,1]],
   [T1, RowInits[T1],  true, RIGHT,  [0,BACK,0], [RScale,1,1]]],

  [[T1, RowInits[T1],  true, RIGHT,  [0,BACK,0],    [RScale,1,1]],
   [T1, RowInits[T1],  true, RIGHT, [0,FRONT,0],   [RScale,1,1]],
   [T1,  RowEnds[T1],  true, RIGHT, [0,BACK, 0],   [RScale,1,1]]],

  [[T1,  RowEnds[T1],  true, RIGHT,      [0,0,0], [RScale,1,1]]],

  // [[T1,  RowEnds[T1],  true, RIGHT, [0,BACK, 0],   [1,1,1]],
  // [T1,   RowEnds[T1],  true, RIGHT,[0,FRONT, 0],  [1,1,1]]],

  // [[T1,  RowEnds[T1],  true, RIGHT,[0,FRONT, 0],  [1,1,1]],
  // [C2,  RowInits[C2], false, BACK,   [LEFT,0,0],   [1,RScale,1]]],

 //Back

  [[T1, RowInits[T1], false, BACK,  [LEFT,0,0], [1,1,1]],
   [T1, RowInits[T1],  true, LEFT,  [0,BACK,0], [RScale,1,1]]],

  [[T1, RowInits[T1], false, BACK,     [0,0,0], [1,1,1]]],


   //Additional Support
 ];

//define Spical border Hull to join Column and Thumb Cluster
TCJoints = //color "Salmon"
 [
  //  [
  //   [T1,  RowEnds[T1],  true, RIGHT,   [0,FRONT,0],  [1,1,1]],
  //   [T0,  RowEnds[T0],  false, LEFT,   [0,0,0],      [1,RScale,1]],
  //   [C2,           R1, false, BACK,    [LEFT,0,0],   [1,RScale,1]],
  //   [C2,           R1,  true, LEFT,    [0,BACK,0],   [RScale,1,1]],
  //  ],

  //  [
  //   [T1,  RowEnds[T1],  true, RIGHT,   [0,FRONT, 0],  [1,1,1]],
  //   [C2, R1, false, BACK,    [LEFT,0,0],   [1,RScale,1]],
  //   [C2, R1,  true, LEFT,    [0,BACK,0],   [RScale,1,1]],
  //   [C2, R1, false, BACK,    [LEFT,0,0],   [1,RScale,1]]
  //  ],

 ];

// define hull to join trackball module and border
TBborder = //color "Yellow"
 [
  [[[T1, RowInits[T1], false,  BACK, [0,0,0], [1,1,1]],
    [T1, RowInits[T1],  true,  LEFT, [0,BACK,0], [RScale,1,1]],],
    [LEFT,0,0]],

  [[[T1,  RowEnds[T1],  true, RIGHT, [0,0,0], [1,1,1]],],
    [RIGHT,BACK,0]],

  [[[T1, RowInits[T1],  true,  RIGHT, [0,0,0], [1,1,1]],],
    [0,0,0]],

  [[[T1,  RowEnds[T1],  true, RIGHT, [0,0,0], [1,1,1]],
    [C2, RowInits[C2], false,  BACK, [LEFT,0,0], [1,RScale,1]],],
    [RIGHT,BACK,0]],

  [[[T1,  RowEnds[T1],  true, RIGHT, [0,0,0], [1,1,1]],
    [C3, RowInits[C3], false,  BACK, [LEFT,0,0], [1,RScale,1]],],
    [RIGHT,BACK,0]],

  [[[C2, RowInits[C2], false,  BACK, [0,0,0], [1,RScale,1]],
    [C3, RowInits[C3], false,  BACK, [LEFT,0,0], [1,RScale,1]],],
    [RIGHT,0,0]],

  [[[C3, RowInits[C3], false,  BACK, [0,0,0], [1,RScale,1]],
    [C4, RowInits[C4], false,  BACK, [LEFT,0,0], [1,RScale,1]],],
    [RIGHT,FRONT,0]],

  [[[C4, RowInits[C4], false,  BACK, [LEFT,0,0], [1,RScale,1]],],
    [0,FRONT,0]],

  [[[C4, RowInits[C4], false,  BACK, [0,0,0], [1,RScale,1]],],
    [LEFT,FRONT,0]],

 ];

/* 2 sets of structure to hull to generate Bottom enclosures starting from Top Surface and Projected Bottom surface.
   Bottom structure is also used to generate bottom plates? may need to seperate due to concavity of border...
*/

Eborder =
   [//[[Col, Row, len = true, Jog direction1, HullFace, Scale], ...],

    //LEFT Section
    [//T1R1 Side 0
      [[T1,  R1,  true, LEFT, [0,BACK,0],      [RScale,1,1]],
       [T0,  R2,  true, LEFT, [0,BACK,0],      [RScale,1,1]]],
      [[T1,  R1,  true, LEFT, [0,BACK,BOTTOM], [EScale,1,1]],
       [T0,  R2,  true, LEFT, [0,BACK,BOTTOM], [EScale,1,1]]],
      [0,0,0]
    ],

    [//T0R1 Side
      [[TStart, RowInits[TStart], true, LEFT, [0,0,BOTTOM], [RScale,1,1]] ],
      [[TStart, RowInits[TStart], true, LEFT, [0,0,BOTTOM], [EScale,1,1]] ],
      [0,0,0]
    ],
    [//T0 Front conrer 7
      [[TStart, RowEnds[TStart], true, LEFT,  [0,FRONT,BOTTOM], [RScale,1,1]],
       [TStart, RowEnds[TStart], false,FRONT, [LEFT,0,BOTTOM],  [1,RScale,1]] ],
      [[TStart, RowEnds[TStart], true, LEFT,  [0,FRONT,BOTTOM], [EScale,1,1]],
       [CStart,     RowInits[C2], true, LEFT+LeftOffset-.2, [0,FRONT+.3,BOTTOM], [EScale,1,1]] ],
      [0,0,0]
    ],
    [//C2 T1 side
      [[TStart, RowEnds[TStart], false, FRONT,           [0,0,BOTTOM],       [1,RScale,1]]],
      [[CStart,     RowInits[C2], true, LEFT+LeftOffset-.2, [0,FRONT+.3,BOTTOM], [EScale,1,1]],
      ],
      [0,0,0]
    ],
    [//C2 T1 side
      [[TStart,  RowEnds[TStart], false,FRONT,            [0,0,BOTTOM],  [1,RScale,1]],
       [CStart,               C1, false, BACK,            [LEFT,0,BOTTOM],  [1,RScale,1]],
       [CStart,               C1,  true, LEFT,            [0,BACK,BOTTOM],  [RScale,1,1]]],
      [[CStart, RowInits[CStart], true, LEFT+LeftOffset-.2, [0,FRONT+.3,BOTTOM], [EScale,1,1]],
      ],
      [0,0,0]
    ],
    [//C2 T1 side
      [[TStart,  RowEnds[TStart], false,FRONT,            [0,0,BOTTOM],  [1,RScale,1]],
       [CStart,               C1, false, BACK,            [LEFT,0,BOTTOM],  [1,RScale,1]],
       [CStart,               C1,  true, LEFT,            [0,BACK,BOTTOM],  [RScale,1,1]]],
      [[CStart, RowInits[CStart], true, LEFT+LeftOffset-.2, [0,FRONT+.3,BOTTOM], [EScale,1,1]],
      ],
      [0,0,0]
    ],
    [//C2 T1
      [[CStart,     RowInits[CStart], true, LEFT,               [0,FRONT,BOTTOM], [RScale,1,1]],
       [CStart,      RowEnds[CStart], true, LEFT,               [0,BACK,BOTTOM], [RScale,1,1]]],
      [[CStart,     RowInits[CStart], true, LEFT+LeftOffset-.2, [0,FRONT+.3,BOTTOM], [EScale,1,1]],
      ],
      [0,0,0]
    ],

    [//C2 T1
      [[CStart,      RowEnds[CStart], true, LEFT,               [0,0,BOTTOM], [RScale,1,1]]],
      [[CStart,     RowInits[CStart], true, LEFT+LeftOffset-.2, [0,FRONT+.3,BOTTOM], [EScale,1,1]],
       [CStart,      RowEnds[CStart], true, LEFT+LeftOffset-.2, [0,FRONT+.3,BOTTOM], [EScale,1,1]],
      ],
      [0,0,0]
    ],

    //FRONT Section
    [//CStart Front conrer 7
      [[CStart, RowEnds[CStart], true, LEFT,              [0,FRONT,BOTTOM], [RScale,1,1]],
       [CStart, RowEnds[CStart], false,FRONT,             [LEFT,0,BOTTOM],  [1,RScale,1]]],
      [[CStart, RowEnds[CStart], true, LEFT+LeftOffset-.2,   [0,FRONT+.3,BOTTOM], [EScale,1,1]],
       [CStart, RowEnds[CStart], false,FRONT+FrontOffset+.5, [LEFT,0,BOTTOM],  [1,EScale,1]]],
      [0,0,0]
    ],
    [//C2R2 FRONT to C2R2
      [[C2, RowEnds[C2], false,FRONT,             [LEFT,0,BOTTOM], [1,RScale,1]],
       [C2, RowEnds[C2], false,FRONT,             [LEFT,0,BOTTOM], [1,RScale,1]]],
      [[C2, RowEnds[C2], false,FRONT+FrontOffset+.5, [LEFT,0,BOTTOM], [1,EScale,1]]
       ],
      [0,0,0]
    ],
    [//C2R2 FRONT to C3R2
      [[C2, RowEnds[C2], false,FRONT,             [LEFT,0,BOTTOM], [1,RScale,1]],
       [C3, RowEnds[C3], false,FRONT,             [LEFT,0,BOTTOM], [1,RScale,1]]],
      [[C2, RowEnds[C2], false,FRONT+FrontOffset+.5, [LEFT,0,BOTTOM], [1,EScale,1]],
       [C3, RowEnds[C3], false,FRONT+FrontOffset, [LEFT,0,BOTTOM], [1,EScale,1]]
      ],
      [0,0,0]
    ],
    [//C3R3 FRONT
      [[C3, RowEnds[C3], false,FRONT,             [0,0,BOTTOM], [1,RScale,1]] ],
      [[C3, RowEnds[C3], false,FRONT+FrontOffset, [0,0,BOTTOM], [1,EScale,1]] ],
      [0,0,0]
    ],
    [//C3R3 FRONT to C4R3
      [[C3, RowEnds[C3], false,FRONT,             [RIGHT,0,BOTTOM], [1,RScale,1]],
       [C4, RowEnds[C4], false,FRONT,             [RIGHT,0,BOTTOM], [1,RScale,1]]],
      [[C3, RowEnds[C3], false,FRONT+FrontOffset, [RIGHT,0,BOTTOM], [1,EScale,1]],
       [C4, RowEnds[C4], false,FRONT+FrontOffset, [RIGHT,0,BOTTOM], [1,EScale,1]]],
      [0,0,0]
    ],

    [//C4R3 FRONT to C5R3
      [[C4, RowEnds[C4], false,FRONT,             [RIGHT,0,BOTTOM], [1,RScale,1]],
       [C5, RowEnds[C5], false,FRONT,             [RIGHT,0,BOTTOM], [1,RScale,1]]],
      [[C4, RowEnds[C4], false,FRONT+FrontOffset, [RIGHT,0,BOTTOM], [1,EScale,1]],
       [C5, RowEnds[C5], false,FRONT+FrontOffset, [RIGHT,0,BOTTOM], [1,RScale,1]]],
      [0,0,0],
    ],

    [//CEND conrer
      [[CEnd, RowEnds[CEnd], true, RIGHT,             [0,FRONT,BOTTOM], [RScale,1,1]],
       [CEnd, RowEnds[CEnd], false,FRONT,             [RIGHT,0,BOTTOM],    [1,RScale,1]]],
      [[CEnd, RowEnds[CEnd], true, RIGHT+RightOffset, [0,FRONT,BOTTOM],    [EScale,1,1]],
       [CEnd, RowEnds[CEnd], false,FRONT+FrontOffset, [RIGHT,0,BOTTOM],    [1,RScale,1]]],
      [0,0,0],
      true
    ],

    //RIGHT Section
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

    //Back Section
    [//T1R1 Side 20
      [[T1, RowInits[T1], false, BACK,             [LEFT,0,BOTTOM], [1,1,1]],
       [T1, RowInits[T1], true,  LEFT,             [0,BACK,BOTTOM], [RScale,1,1]]],
      [[T1, RowInits[T1], false, BACK-ThumbOffset, [LEFT,0,BOTTOM], [1,RScale,1]],
       [T1, RowInits[T1],  true, LEFT,             [0,BACK,BOTTOM], [EScale,1,1]]],
      [0,0,0]
    ],
    [//T1R1 Side 20
      [[T1, RowInits[T1], false, BACK,             [0,0,BOTTOM], [1,1,1]]],
      [[T1, RowInits[T1], false, BACK-ThumbOffset, [0,0,BOTTOM], [1,RScale,1]]],
      [0,0,0]
    ],
    [//T1R1 Inner section
      [[T1, RowInits[T1], false, BACK,             [RIGHT,0,BOTTOM], [1,1,1]],
       [T1, RowInits[T1], true,  RIGHT,             [0,BACK,BOTTOM], [RScale,1,1]]],
      [[T1, RowInits[T1], false, BACK-ThumbOffset, [RIGHT,0,BOTTOM], [1,RScale,1]],
       [C3, RowInits[C3], false,BACK+BackOffset,     [LEFT,0,BOTTOM], [1,EScale,1]]],
      [0,0,0]
    ],
    [//T1R1 Side 20
      [[T1, RowInits[T1], true,  RIGHT,             [0,0,BOTTOM], [RScale,1,1]],
       [T1, RowEnds[T1],  true,  RIGHT,             [0,BACK,BOTTOM], [1,1,1]]],
      [[C3, RowInits[C3], false,BACK+BackOffset,     [LEFT,0,BOTTOM], [1,EScale,1]]],
      [0,0,0]
    ],

    [//T1R1 Side 20
      [[T1, RowInits[T1], true,  RIGHT,             [0,0,BOTTOM], [RScale,1,1]],
       [T1, RowEnds[T1],  true,  RIGHT,             [0,BACK,BOTTOM], [1,1,1]]],
      [[C3, RowInits[C3], false,BACK+BackOffset,     [LEFT,0,BOTTOM], [1,EScale,1]]],
      [0,0,0]
    ],

    [//C2 to C3R0 BACK
      [[C2, RowInits[C2], false,BACK,                [0,0,BOTTOM], [1,RScale,1]]],
      [[C3, RowInits[C3], false,BACK+BackOffset,     [LEFT,0,BOTTOM], [1,EScale,1]],],
      [0,0,0]
    ],

    [//C2 to C3R0 BACK
      [[C2, RowInits[C2], false,BACK,                [0,0,BOTTOM], [1,RScale,1]],
       [C3, RowInits[C3], false,BACK,                [LEFT,0,BOTTOM], [1,RScale,1]],],
      [[C3, RowInits[C3], false,BACK+BackOffset,     [LEFT,0,BOTTOM], [1,EScale,1]],],
      [0,0,0]
    ],

    [//C3R0 BACK
      [[C3, RowInits[C3], false,BACK,                [0,0,BOTTOM], [1,RScale,1]]],
      [[C4, RowInits[C4], false,BACK+BackOffset,     [LEFT,0,BOTTOM], [1,EScale,1]],
       [C3, RowInits[C3], false,BACK+BackOffset,     [LEFT,0,BOTTOM], [1,EScale,1]]],
      [0,0,0]
    ],

    [//C3 to C4R0 BACK
      [[C3, RowInits[C3], false,BACK,                [RIGHT,0,BOTTOM], [1,RScale,1]],
       [C4, RowInits[C4], false,BACK,                [LEFT,0,BOTTOM], [1,RScale,1]],
      ],
      [[C4, RowInits[C4], false,BACK+BackOffset,     [LEFT,0,BOTTOM], [1,EScale,1]],],
      [0,0,0]
    ],
    [//C4R0 BACK
      [[C4, RowInits[C4], false,BACK,                [0,0,BOTTOM], [1,RScale,1]]],
      [[C4, RowInits[C4], false,BACK+BackOffset,     [0,0,BOTTOM], [1,EScale,1]]],
      [0,0,0]
    ],

    [//C BACK 27
      [[C5, RowInits[C5], false,BACK,                [LEFT,0,BOTTOM],  [1,RScale,1]],
       [C4, RowInits[C4], false,BACK,                [RIGHT,0,BOTTOM], [1,RScale,1]]],
      [[C4, RowInits[C4], false,BACK+BackOffset,     [RIGHT,0,BOTTOM], [1,EScale,1]]],
      [0,0,0]
    ],
    [//C BACK 27
      [[C5, RowInits[C5], false,BACK,                [0,0,BOTTOM],  [1,RScale,1]]],
      [[C4, RowInits[C4], false,BACK+BackOffset,     [RIGHT,0,BOTTOM], [1,EScale,1]],
       [C5, RowInits[C5], false,BACK+BackOffset,     [RIGHT,0,BOTTOM], [1,EScale,1]]],
      [0,0,0]
    ],
    [//CEND conrer
      [[CEnd, RowInits[CEnd], true, RIGHT,             [0,BACK,BOTTOM], [RScale,1,1]],
       [CEnd, RowInits[CEnd], false,BACK,             [RIGHT,0,BOTTOM],    [1,RScale,1]]],
      [[CEnd, RowInits[CEnd], true, RIGHT+RightOffset, [0,BACK,BOTTOM],    [EScale,1,1]],
       [CEnd, RowInits[CEnd], false,BACK+BackOffset, [RIGHT,0,BOTTOM],    [1,EScale,1]]],
      [0,0,0],
      true
    ],
  ];

//Hull struct contain the Estruct array IDe to hull bottom plate: concavity exsits so blind hull will result in failuer
Hstruct =
  [
   [0,1,2,3,20,21,22],
   [3,4,5,6,7,8,9,10,11,12,13,14,17],
   [3,17,18,23,24,25,26,27,28,29,30]
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
