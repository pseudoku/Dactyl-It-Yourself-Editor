/*
Designer: Pseudoku
Summary:  (6x3+2)+4 split Choc [tweak and get 5x3+3! MiniWarp]
Concept:  Commision Design
          Shallow scooped to lull you into the world of ErgoWarp. Semi-opposable compact thumb cluster
TODOs:    * create mounting post for enclosure and bottom plate
          * generate bottom plate


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
Alps   = 2;

//Cap type applys to MX only?
//Cherry = 0;
DSA = 1;
SA  = 2;
MT3 = 3;
//-----   Grid parameters
unit           = 19.45;  //
Tol            = 0.01;  // tolance
HullThickness  = 0.01; // modulation hull thickness
TopHeight      = 100;      // Reference Origin of the keyswitch
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
RScale       = 2.2;        //Rim bottom scaling
EScale       = 2.0;      //Enclosure bottom scaling
PBuffer      = 0;       //additional Plate thickness
BorderAlign  = BOTTOM;           // high pro or flushed
Bthickness   = PlateDim[0] - 4;  //thickness of the enclosure rim
BFrontHeight = 3;                    //Height of frontside of the enclosure rim
BBackHeight  = 3;                    //Height of Backside of the enclosure rim
TFrontHeight = 0;
TBackHeight  = 0;
T0Buffer     = 0;                    //Additional Plate thickness buffer for T0 position.
T0BackH      = BBackHeight + T0Buffer;  //Adjuted height for T0
holeOffset   = 0;

//-----  Bottom Enclosure Offsets: Adjust how bottom casing offset from top plate
LeftOffset  = .75;
FrontOffset = .5;
RightOffset = -.25;
BackOffset  = -.5;
ThumbOffset = .2;

//-----     Tenting Parameters
tenting     = [-10,12,0]; // tenting for enclusoure
plateHeight = 40;       // height adjustment for enclusure

//-----     Trackball Parameters
trackR      = 27;        //trackball raidus  M570: 37mm, Ergo and Kennington: 40mm
trackOrigin = [-35,15,0]; //trackball origin
trackTilt   = [0,0,0];    //angle for tilting trackpoint support and PCB

//-----     Rotary Encoder
RELoc       = [];
REAng       = [];
RER         = 20;

//-----     Bottom Plate Parameters
//
bpThickness =  3; //Bottom Plate Thickness
midHeight   = -7; // used to generate hull between mount and enclosure
                /////           //////               /////
mountScrew  = [[50.5,-12.5,0],[-36,48,0],[25,58,0],[62,40,0],[-40,-15,0]]; // mount location
mountHull   = [26,8,11,13,2]; //refer to ebordes id to bind to to mountScrew location
mountDia    = 5; //mm
screwholeDia= 3; //mm
screwtopDia = 6; //mm

MCUDim      = [18, 32.5, 1.2];
MCULoc      = [5,47,7.1];
resetLoc    = [0,0,0];
USBLoc      = [5,40+32.5/2,6+1.2];

JackLoc     = [-20,48,7];
JackDim     = [18,6,10];
JackAng     = [0,0,90];

//-------  LAYOUT parameters
//column loop setter
CStart   = C1;  // Set column to begin looping for the build
CEnd     = C5;  // Set column to end for the build
TStart   = T1;  // Set Thumb Cluster Colum to begin
TEnd     = T2;  // Set Thumb Cluster to end
colRange = concat([for (i = [CStart:CEnd]) i], [for (i = [TStart:TEnd]) i]); //columnar for loop range

//structure to hold column origin transformation
ColumnOrigin = [//[translation vec]       [Global Rot]    [Local Rot]
                [[  -54, -unit*3/8,   1], [ 0,   0,   0], [ 0, 90,  0]], //INDEX 1
                [[  -unit*2,-unit*3/8,  -2], [ 0,   0,   0], [ 0, 90,  0]], //INDEX 2
                [[  -unit,   -unit/8,  -2], [ 0,   0,   0], [ 0, 90,  0]], //INDEX 3
                [[    0,    unit/8,  -5], [ 0,   0,  -3], [ 0, 90,  0]], //MIDDLE
                [[   unit+1,   -unit/8,   0], [ 0,   0,  -7], [ 0, 90,  0]], //RING
                [[ unit*2+2, -unit*3/8,   8], [ 0,   5, -15], [ 0, 90,  0]], //PINKY 1
                [[ unit*3+1, -unit*3/8,  12], [ 0,  10, -15], [ 0, 90,  0]], //PINKY 2
                [[ unit*4, -unit*3/8-0.5,  22], [ 0,  17.5, -15], [ 5, 90,  0]], //PINKY 3
                [[  -63,       -23, -23], [ 0,   0,  10], [-5, 95,  0]], //Thumb Outer
                [[  -46,       -22, -23], [ 0,   0,   0], [ 0, 90,-60]], //Thumb OuterMid
                [[  -46,       -22, -23], [ 0,   0,   0], [ 0, 90,-60]], //Thumb Midlde
                [[  -36,       -22, -14], [ 0,   0,   0], [ 0, 90,-60]], //Thumb InnerMid
                [[  -29,     -13.5,   3], [ 0,   0,   0], [ 0, 90,-60]]  //Thumb Inner
               ];

 //ThumbShift  = [[2,-12, 0],[ 0, -5, -5],[ 0, 0, 0]]; //global transform for thumb cluster to jog as whole rather than editing origin
//ThumbShift  = [[-10,-16, 5],[ 0, -5, -3],[ 0, 0, 0]]; //global transform for thumb cluster to jog as whole rather than editing origin
ThumbShift  = [[-10,-16, 5],[ 0, -5, -3],[ 0, 0, 0]];

//-------  and adjustment parameters

//row loop setter
//              C0:i1 C1:i2 C2:i3  C3:m  C4:r C5:p1 C6:p2 C7:p3 T0:Ot T1:OM T2:Md  T3:IM  T4:In
RowInits    = [   R2,    R1,   R1,   R0,   R0,   R1,   R1,   R1,   R2,   R2,    R1,   R1,    R0]; //set which Row to begin
RowEnds     = [   R2,    R3,   R3,   R3,   R3,   R3,   R3,   R3,   R2,   R2,    R2,   R1,    R0]; //set which Row to end

//Row transforms
RowTrans    = [[ -.18, -.18, -.18, -.18, -.18, -.55, -.55, -.55, -1.0,-1.25,-1.25,     0,     0], //R0
               [  .80,  .78,  .78,  .78,  .78,  .43,  .43,  .43,    0,    0,  -.1,     0,     0], //R1s
               [ 1.95, 1.95, 1.95, 1.95, 1.95, 1.60, 1.60, 1.60,  .95,  .95,  .95,     0,     0], //R2s
               [ 2.90, 2.90, 2.90, 2.90, 2.90, 2.55, 2.55, 2.55,    0, 1.75,    0,     0,     0], //R3s
               [ 3.80, 3.80, 3.80, 3.80, 3.80,    1,  .83,    1,    0,    0,    0,     0,     0], //R4
               [ 4.45, 4.45, 4.45, 4.45, 4.45,    4,   -4,    4,    0,    0,    0,     0,     0]  //R5
              ]*unit*1.06;

ColTrans    = [[    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0], //R0
               [    0,    0,    0,    0,    0,   .0,    0,    0,    0,   .0,   .21,    0,   1.1], //R1s
               [    0,    0,    0,    0,    0,    0,    0,    0, -.30,  -.42,   .8,    0,   .25], //R2s
               [    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0], //R3s
               [    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0], //R4
               [    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0]  //R5
              ]*unit*1.10;

Pitch       = [[   25,   25,   15,   15,   15,   25,   25,   25,   10,   10,  -10,     0,     0],  //R0
               [   15,   15,   15,   15,   15,   15,   15,   15,    0,   20,  -35,     0,     0],  //R1s
               [  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,    0,  -25,  -25,     0,     0],  //R2s
               [  -25,  -20,  -20,  -20,  -20,  -20,  -20,  -20,    0,  -60,    0,     0,     0],  //R3
               [  -45,  -45,  -45,  -45,  -45,  -45,  -45,    0,    0,    0,    0,     0,     0],  //R4
               [  -58,  -58,  -58,  -58,  -58,  -58,  -58,    0,    0,    0,    0,     0,     0]   //R5
              ];

Roll        = [[   -4,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0],  //R0
               [   -5,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0],  //R1s
               [   -0,    0,    0,    0,    0,    0,    0,    0,    0,  -13,   13,     0,     0],  //R2s
               [   -7,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0],  //R3
               [   -8,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0],  //R4
               [   -10,   0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0]   //R5
              ];

Height      = [[ -6.5, -6.5, -4.5, -4.5, -4.5, -6.5, -6.5, -6.5,    1,    0,    0,     0,     0],  //R0
               [    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,  9.5,     0,     0],  //R1s
               [    0,    0,    0,    0,    0,    0,    0,    0,   17, 1.85,    2,     0,     0],  //R2s
               [ -6.5, -5.5, -5.5, -5.5, -5.5, -5.5, -5.5, -5.5,    0,  -24,    0,     0,     0],  //R3
               [  -18,  -18,  -18,  -18,  -18,    0,    0,    0,    0,    0,    0,     0,     0],  //R4
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
              [[ true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true],
               [ true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true],
               [ true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true],
               [ true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true],
               [ true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true],
               [ true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true]
              ];

SwitchTypes = //MX | MX
              [[ MX,  MX,  MX,  MX,  MX,  MX,  MX,  MX,MX,MX,MX,MX,MX],
               [ MX,  MX,  MX,  MX,  MX,  MX,  MX,  MX,MX,MX,MX,MX,MX],
               [ MX,  MX,  MX,  MX,  MX,  MX,  MX,  MX,MX,MX,MX,MX,MX],
               [ MX,  MX,  MX,  MX,  MX,  MX,  MX,  MX,MX,MX,MX,MX,MX],
               [ MX,  MX,  MX,  MX,  MX,  MX,  MX,  MX,MX,MX,MX,MX,MX],
               [ MX,  MX,  MX,  MX,  MX,  MX,  MX,  MX,MX,MX,MX,MX,MX],
              ];
//-----     border Customization
//          Ca, Ra, Hull_a,      Cb, Rb,     Hull_b
TopCuts = [
//[C5, R3, [RIGHT,0,0], C6, R3, [LEFT,0,0]],
//           [T0, R1, [RIGHT,0,0], T1, R2, [LEFT,0,0]],
//           [T0, R1, [RIGHT,0,0], T1, R1, [LEFT,0,0]],
//           [T1, R1, [RIGHT,0,0], T2, R1, [LEFT,0,0]],
//           [T1, R2, [RIGHT,0,0], T2, R1, [LEFT,0,0]]
          ];

PBind      = [ //generater binds between specified columns and the next. you can specify face to minimize artifacts or hull web rectangular body to increase thickness
              //[column, Cn hull face, Cn+1 hull face]
               [C1,    0,    0],
               [C2,    0, LEFT],
               [C3,RIGHT,    0],
               [C4,RIGHT,    0],
               [C5,RIGHT, LEFT],
//               [C6,RIGHT, 0],
//               [C7,RIGHT, LEFT],
//               [T0,RIGHT, 0],
//               [T1,RIGHT, 0],
//               [T2,RIGHT, 0],
//               [T3,RIGHT, 0],
             ];

PlateCustomBind  = //fine tune edges and missing binds by specifing key position and face|edge|pseudo-point
  [

  [[T1,R2,LEFT,  [0,BACK,0],0],
   [T1,R2,RIGHT, [0,BACK,0],0],
   [T2,R1,LEFT,  [LEFT,FRONT,0],0]],

  [[T1,R2,RIGHT, [0,BACK,0],0],
   [T2,R1,LEFT,  [0,FRONT,0],0],
   [T2,R2,LEFT,  [0,BACK,0],0]],

  [[T1,R2,RIGHT, [0,0,0],0],
   [T2,R2,LEFT,  [0,0,0],0]],
  ];


//define Spical border Hull to make border pretty
Sborder = //color "Crimson"
 [
//[[Col, Row, len = true, Jog direction, HullFace, Scale], ...],


[[C1, RowEnds[C1], false,FRONT, [0,0,0],    [1,RScale,1]], //fill gap between general border and Bottom Enclosure near C1
   [C2, RowEnds[C2], false,FRONT, [LEFT,0,0], [1,RScale,1]] ],

  [[C2, RowEnds[C2], false,FRONT, [0,0,0],    [1,RScale,1]], //fill gap between general border and Bottom Enclosure near C3
   [C3, RowEnds[C3], false,FRONT, [LEFT,0,0], [1,RScale,1]] ],

  [[C1, RowEnds[C1], false,FRONT, [LEFT,0,0], [1,RScale,1]],
   [C2, RowEnds[C2], false,FRONT, [LEFT,0,0], [1,RScale,1]],
   [C3, RowEnds[C3], false,FRONT, [LEFT,0,0], [1,RScale,1]]],

  [[C3, RowEnds[C3], false,FRONT, [0,0,0], [1,RScale,1]]],

  [[C3, RowEnds[C3], false,FRONT, [RIGHT,0,0], [1,RScale,1]],
   [C4, RowEnds[C4], false,FRONT, [0,0,0],     [1,RScale,1]]],

  [[C4, RowEnds[C4], false,FRONT, [RIGHT,0,0], [1,RScale,1]], //fill gap between general border and Bottom Enclosure near C4
   [C5, RowEnds[C5], false,FRONT, [0,0,0],     [1,RScale,1]]],

  //corner
  [[C4, RowEnds[C4], false,FRONT, [RIGHT,0,0], [1,RScale,1]], //fill gap between general border and Bottom Enclosure near C1
   [C4, RowEnds[C4], true, RIGHT, [0,FRONT,0], [RScale,1,1]],],

  [[C4, RowEnds[C4], false,FRONT, [RIGHT,0,0], [1,RScale,1]], //fill gap between general border and Bottom Enclosure near C4 - C7
   [C5, RowEnds[C5], false,FRONT, [RIGHT,0,0], [1,RScale,1]]],
 //back door
  [[C1, RowInits[C1], false,BACK, [RIGHT,0,0], [1,RScale,1]],
   [C2, RowInits[C2], false,BACK, [0,0,0],     [1,RScale,1]],
   [C3, RowInits[C3], false,BACK, [LEFT,0,0],  [1,RScale,1]]],

  [[C3, RowInits[C3], false,BACK, [0,0,0],    [1,RScale,1]],
   [C4, RowInits[C4], false,BACK, [LEFT,0,0], [1,RScale,1]]],
 ];

//define Spical border Hull to join Column and Thumb Cluster
TCJoints = //color "Blue"
 [
    [[C3, RowInits[C3], false, BACK,    [LEFT,0,0],         [RScale,1,1]],
     [T2,          R2,  true,  RIGHT,   [LEFT,BACK,BOTTOM], [1,1,1]],
     [T2,          R1,  true,  RIGHT,   [0,0,BOTTOM],       [1,1,1]]],

    [[C3, RowInits[C3], false, BACK,    [LEFT,0,0],      [RScale,1,1]],
     [T2,          R2,  true,  RIGHT,   [LEFT,0,BOTTOM], [1,1,1]]],

    [[C1, RowInits[C1], false,  BACK,    [0,0,0],    [1,RScale,1]],
     [C3, RowInits[C3], false,  BACK,    [LEFT,0,0], [1,RScale,1]],
     [T2,  RowEnds[T2], false, FRONT,    [0,0,0],    [1,RScale,1]]],

    [[C1, RowInits[C1], false,  BACK,    [LEFT,0,0],    [1,RScale,1]],
     [T2,  RowEnds[T2], false, FRONT,    [LEFT,0,0],    [1,RScale,1]],
     [T1,  RowEnds[T1], false, FRONT,    [RIGHT,0,0],    [1,RScale,1]]],

    [[C1, RowInits[C1],  true, LEFT,    [0,0,0],    [RScale,1,1]],
     [C1, RowInits[C1], false, BACK,    [LEFT,0,0], [1,RScale,1]],
     [T1,          R2,  false, FRONT,   [0,0,0],    [1,RScale,1]]],
 ];


/* 2 sets of structure to hull to generate Bottom enclosures starting from Top Surface and Projected Bottom surface.
   Bottom structure is also used to generate bottom plates? may need to seperate due to concavity of border...
*/

//TODO simplify scale call
Eborder = //color green
  [/* [[Col, Row, len = true, Jog direction1, HullFace, Scale], ...], //top surface
      [[Col, Row, len = true, Jog direction1, HullFace, Scale], ...], //projected bottom surface
      [hullface], //for hulling to trackball mount. keep [0,0,0]
      bool //true will build top borders, false will generate only the bottom suface of top border. reduce manifold errors
   */
    //LEFT Section
    [//T1R1 Side 0
      [[TStart, RowEnds[TStart], true, LEFT,              [0,0,BOTTOM], [RScale,1,1]] ],
      [[TStart, RowEnds[TStart], true, LEFT+ThumbOffset,  [0,0,BOTTOM], [EScale,1,1]] ],
      [0,0,0],
      true
    ],
    [//T0 Front conrer
      [[TStart, RowEnds[TStart], true, LEFT,              [0,FRONT,BOTTOM], [RScale,1,1]],
       [TStart, RowEnds[TStart], false,FRONT,             [LEFT,0,BOTTOM],  [1,RScale,1]]],
      [[TStart, RowEnds[TStart], true, LEFT+ThumbOffset,  [0,FRONT,BOTTOM], [EScale,1,1]],
       [TStart, RowEnds[TStart], false,FRONT+ThumbOffset, [LEFT,0,BOTTOM],  [1,EScale,1]]],
      [0,0,0],
      true
    ],
    [//T1 to T2
      [
       [T1, R2, true, LEFT,              [0,FRONT,BOTTOM], [1,RScale,1]],
       [T1, R2, false,FRONT,             [LEFT,0,BOTTOM], [1,RScale,1]]],
      [
       [T1, R2, false,FRONT+ThumbOffset, [LEFT,0,BOTTOM],    [EScale,1,1]],
       [C1, R1, true, LEFT+LeftOffset,   [0,BACK,BOTTOM],    [EScale,1,1]]],
      [0,0,0],
      false
    ],
    [//T2 to C1R1
      [[T1, R2, false,FRONT,             [LEFT,0,BOTTOM],   [1,RScale,1]],
       [C1, R1, true, LEFT,              [0,FRONT,BOTTOM],    [RScale,1,1]]],
      [[C1, R1, true, LEFT+LeftOffset,   [0,0,BOTTOM],    [EScale,1,1]]],
      [0,0,0],
      true
    ],
    [//C1R1 to C1R2 side
      [[C1, R1, true, LEFT,              [0,FRONT,BOTTOM], [RScale,1,1]],
       [C1, R2, true, LEFT,              [0,BACK,BOTTOM],  [RScale,1,1]] ],
      [[C1, R1, true, LEFT+LeftOffset,   [0,FRONT,BOTTOM], [EScale,1,1]],
       [C1, R2, true, LEFT+LeftOffset,   [0,BACK,BOTTOM],  [EScale,1,1]] ],
      [0,0,0],
      true
    ],
    [//C1R2 side
      [[C1, R2, true, LEFT,              [0,0,BOTTOM], [RScale,1,1]]],
      [[C1, R2, true, LEFT+LeftOffset,   [0,0,BOTTOM], [EScale,1,1]]],
      [0,0,0],
      true
    ],
    [//C1R2 to C1R3 side
      [[C1, R2, true, LEFT,              [0,FRONT,BOTTOM], [RScale,1,1]],
       [C1, R3, true, LEFT,              [0,BACK,BOTTOM],  [RScale,1,1]]],
      [[C1, R2, true, LEFT+LeftOffset,   [0,FRONT,BOTTOM], [EScale,1,1]],
       [C1, R3, true, LEFT+LeftOffset,   [0,BACK,BOTTOM],  [EScale,1,1]]],
      [0,0,0],
      true
    ],
    [//C1R3 side
      [[C1, R3, true, LEFT,              [0,0,BOTTOM], [RScale,1,1]]],
      [[C1, R3, true, LEFT+LeftOffset,   [0,0,BOTTOM], [EScale,1,1]]],
      [0,0,0],
      true
    ],

    //FRONT Section
    [//CStart Front conrer 8
      [[CStart, RowEnds[CStart], true, LEFT,              [0,FRONT,BOTTOM], [RScale,1,1]],
       [CStart, RowEnds[CStart], false,FRONT,             [LEFT,0,BOTTOM],  [1,RScale,1]]],
      [[CStart, RowEnds[CStart], true, LEFT+LeftOffset,   [0,FRONT,BOTTOM], [EScale,1,1]],
       [CStart, RowEnds[CStart], false,FRONT+FrontOffset, [LEFT,0,BOTTOM],  [1,EScale,1]]],
      [0,0,0],
      true
    ],
    [//C1R3 FRONT to C2R3
      [[C1, RowEnds[C1], false,FRONT,             [LEFT,0,BOTTOM], [1,RScale,1]],
       [C3, RowEnds[C3], false,FRONT,             [LEFT,0,BOTTOM], [1,RScale,1]]],
      [[C1, RowEnds[C1], false,FRONT+FrontOffset, [LEFT,0,BOTTOM], [1,EScale,1]],
       [C3, RowEnds[C3], false,FRONT+FrontOffset, [LEFT,0,BOTTOM], [1,EScale,1]]],
      [0,0,0],
      false
    ],
    [//C3R3 FRONT
      [[C3, RowEnds[C3], false,FRONT,             [0,0,BOTTOM], [1,RScale,1]]],
      [[C3, RowEnds[C3], false,FRONT+FrontOffset, [0,0,BOTTOM], [1,EScale,1]]],
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
    [//C4R3 FRONT to CEnd (C5~C6, for C7 recommend edit)
      [[C4, RowEnds[C4], false,FRONT,                 [RIGHT,0,BOTTOM], [1,RScale,1]],
       [CEnd, RowEnds[CEnd], false,FRONT,             [RIGHT,0,BOTTOM], [1,RScale,1]]],
      [[C4, RowEnds[C4], false,FRONT+FrontOffset,     [RIGHT,0,BOTTOM], [1,EScale,1]],
       [CEnd, RowEnds[CEnd], false,FRONT+FrontOffset, [RIGHT,0,BOTTOM], [1,EScale,1]]],
      [0,0,0],
      true
    ],
    [//CEnd conrer
      [[CEnd, RowEnds[CEnd], true, RIGHT,             [0,FRONT,BOTTOM], [RScale,1,1]],
       [CEnd, RowEnds[CEnd], false,FRONT,             [RIGHT,0,BOTTOM], [1,RScale,1]]],
      [[CEnd, RowEnds[CEnd], true, RIGHT+RightOffset, [0,FRONT,BOTTOM], [EScale,1,1]],
       [CEnd, RowEnds[CEnd], false,FRONT+FrontOffset, [RIGHT,0,BOTTOM], [1,EScale,1]]],
      [0,0,0],
      true
    ],
    //RIGHT Section
    [//CEndR1 side  14
      [[CEnd, RowInits[CEnd], true, RIGHT,             [0,0,BOTTOM], [RScale,1,1]]],
      [[CEnd, RowInits[CEnd], true, RIGHT+RightOffset, [0,0,BOTTOM], [EScale,1,1]]],
      [0,0,0],
      true
    ],
    [//CEnd R1 to R2 side
      [[CEnd, R1, true, RIGHT,            [0,FRONT,BOTTOM], [RScale,1,1]],
       [CEnd, R2, true, RIGHT,            [0,BACK,BOTTOM],  [RScale,1,1]]],
      [[CEnd, R1, true, RIGHT+RightOffset,[0,FRONT,BOTTOM], [EScale,1,1]],
       [CEnd, R2, true, RIGHT+RightOffset,[0,BACK,BOTTOM],  [EScale,1,1]]],
      [0,0,0],
      true
    ],
    [//CEnd R1 side
      [[CEnd, R2, true, RIGHT,            [0,0,BOTTOM], [RScale,1,1]]],
      [[CEnd, R2, true, RIGHT+RightOffset,[0,0,BOTTOM], [EScale,1,1]]],
      [0,0,0],
      true
    ],
    [//CEnd R2 to R3 side
      [[CEnd, R2, true, RIGHT,            [0,FRONT,BOTTOM], [RScale,1,1]],
       [CEnd, R3, true, RIGHT,            [0,BACK,BOTTOM],  [RScale,1,1]]],
      [[CEnd, R2, true, RIGHT+RightOffset,[0,FRONT,BOTTOM], [EScale,1,1]],
       [CEnd, R3, true, RIGHT+RightOffset,[0,BACK,BOTTOM],  [EScale,1,1]]],
      [0,0,0],
      true
    ],
    [//CEnd R2 side
      [[CEnd, R3, true, RIGHT,            [0,0,BOTTOM], [RScale,1,1]]],
      [[CEnd, R3, true, RIGHT+RightOffset,[0,0,BOTTOM], [EScale,1,1]]],
      [0,0,0],
      true
    ],
    //Back Section
    [//TStart conrer  18
      [[TStart, RowInits[TStart], true, LEFT,               [0,BACK,0],      [RScale,1,1]],
       [TStart, RowInits[TStart], false,BACK,               [LEFT,0,0],      [1,RScale,1]]],
      [[TStart, RowInits[TStart], true, LEFT+ThumbOffset,   [0,BACK,BOTTOM], [EScale,1,1]],
       [TStart, RowInits[TStart], false,BACK,               [LEFT,0,BOTTOM], [1,EScale,1]]],
      [0,0,0],
      true
    ],
    [//T0 to T2
      [[TStart, RowInits[TStart], false, BACK, [0,0,0],   [1,RScale,1]],
       [T2,     RowInits[T2],     false, BACK, [LEFT,0,BOTTOM], [1,RScale,1]]],
      [[TStart, RowInits[TStart], false, BACK, [LEFT,0,BOTTOM], [1,EScale,1]],
       [T2,     RowInits[T2],     false, BACK, [LEFT,0,BOTTOM], [1,EScale,1]]],
      [0,0,0],
      true
    ],
    [//T1
      [[T2, R1, false,BACK, [0,0,BOTTOM], [1,RScale,1]]],
      [[T2, R1, false,BACK, [0,0,BOTTOM], [1,EScale,1]]],
      [0,0,0],
      true
    ],
    [//T2 corner ALT
      [[T2, R1, false,BACK,            [RIGHT,0,BOTTOM], [1,RScale,1]],
       [T2, R1,  true,RIGHT,           [0,BACK,BOTTOM],  [RScale,1,1]],
       [C3, R0, false,BACK,            [LEFT,0,BOTTOM], [1,RScale,1]]],
      [[T2, R1, false,BACK,            [RIGHT,0,BOTTOM], [1,EScale,1]],
       [C3, R0, false,BACK+BackOffset, [LEFT,0,BOTTOM], [1,EScale,1]]],
      [0,0,0],
      true
    ],
    [//C3R0 C4R1 BACK ALT
      [[C3, R0, false,BACK,                [LEFT,0,BOTTOM], [1,RScale,1]],
       [C4, R0, false,BACK,                [LEFT,0,BOTTOM], [1,RScale,1]]],
      [[C3, R0, false,BACK+BackOffset,     [LEFT,0,BOTTOM], [1,EScale,1]],
       [C4, R0, false,BACK+BackOffset,     [LEFT,0,BOTTOM], [1,EScale,1]]],
      [0,0,0],
      false
    ],
    [//C4R0 C5R1 BACK
      [[C4, R0, false,BACK,                [LEFT,0,BOTTOM], [1,RScale,1]],
       [C5, R1, false,BACK,                [LEFT,0,BOTTOM], [1,RScale,1]]],
      [[C4, R0, false,BACK+BackOffset,     [LEFT,0,BOTTOM], [1,EScale,1]],
       [C5, R1, false,BACK+BackOffset,     [LEFT,0,BOTTOM], [1,EScale,1]]],
      [0,0,0],
      true
    ],
    [//C7R3 BACK
      [[C5, R1, false,BACK,                [0,0,BOTTOM], [1,RScale,1]]],
      [[C5, R1, false,BACK+BackOffset,     [0,0,BOTTOM], [1,EScale,1]]],
      [0,0,0],
      true
    ],
    [//CEnd Back conrer
      [[CEnd, RowInits[CEnd], true, RIGHT,               [0,BACK,BOTTOM],  [RScale,1,1]],
       [CEnd, RowInits[CEnd], false,BACK,                [RIGHT,0,BOTTOM], [1,RScale,1]]],
      [[CEnd, RowInits[CEnd], true, RIGHT+RightOffset,   [0,BACK,BOTTOM],  [EScale,1,1]],
       [CEnd, RowInits[CEnd], false,BACK+BackOffset,     [RIGHT,0,BOTTOM], [1,EScale,1]]],
      [0,0,0],
      true
    ],
  ];

//Hull struct contain the Estruct array IDe to hull bottom plate: concavity exsits so blind hull will result in failuer
Hstruct =
  [[0,1,2,18,19,20,21],
   [3,4,5,22],
   [6,7,8,9,23],
   [10,11,12,13,16,17,24],
   [14,15,25,26]
 ];


//define Jointing between Thumb Cluster and Column

//-----     IGNORE IF YOU are not using Clipped switch
xLen         = 0;        //3.4 cut length for clipped khail
xLenM        = xLen+0;   //fudging to get cleaner border
//Manual Adjustment of Pitches post Calculation for minor adjustment
//              C0:i1 C1:i2  C2:i3   C3:m   C4:r  C5:p1  C6:p2  C7:p3  T0:Ot T1:OM T2:Md  T3:IM  T4:In
Clipped      =[[   1,     1,     1,     1,     1,    -1,     1,     1,     1,     1,    1,     1,    1],  //R0
               [   1,    -1,    -1,    -1,    -1,    -1,     1,     1,     1,     1,    1,     1,    1],  //R1s
               [   1,     1,     1,     1,     1,     1,    -1,     1,     1,     1,    1,     1,    1],  //R2s
               [   1,     1,    -1,     1,     1,     1,    -1,    -1,     1,     1,    1,     1,    1],  //R3
               [   1,     1,     1,    -1,    -1,     1,    -1,    -1,     1,     1,    1,     1,    1],  //R4
               [   1,     1,     1,     1,    -1,     1,    -1,     1,     1,     1,    1,     1,    1]   //R5
              ]*xLen;

//Orientation of the clippede switches
KeyOriginCnRm = [for( i= [C0:C7])[[0,BottomHeight],0], for(j = [R1:R4])[0,TopHeight,0]];

