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
BFrontHeight = 3;                    //Height of frontside of the enclosure rim
BBackHeight  = 3;                    //Height of Backside of the enclosure rim
TFrontHeight = 0;
TBackHeight  = 0;
T0Buffer     = 0;                    //Additional Plate thickness buffer for T0 position.
T0BackH      = BBackHeight + T0Buffer;  //Adjuted height for T0

//-----  Bottom Enclosure Offsets: Adjust how bottom casing offset from top plate
LeftOffset  = .75;
FrontOffset = .5;
RightOffset = -.25;
BackOffset  = -.5;
ThumbOffset = .2;

//-----     Tenting Parameters
// tenting     = [0,17,0]; // tenting for enclusoure
// plateHeight = 22;       // height adjustment for enclusure

tenting     = [0,0,0]; // tenting for enclusoure
plateHeight = 22;       // height adjustment for enclusure

//-----     Trackball Parameters
trackR      = 17;        //trackball raidus  M570: 37mm, Ergo and Kennington: 40mm
trackOrigin = [0,-18,7]; //trackball origin
trackTilt   = [0,0,90];    //angle for tilting trackpoint support and PCB

//-----     Rotary Encoder
RELoc       = [];
REAng       = [];
RER         = 20;

//-----     Bottom Plate Parameters
//
bpThickness =  3; //Bottom Plate Thickness
midHeight   = -7; // used to generate hull between mount and enclosure
mountDia    = 5; //mm

MCUDim      = [18, 32.5, 1.2];
MCULoc      = [5,28,5];
resetLoc    = [0,0,0];
USBLoc      = [5,28+32.5/2,6+1.2];

TRRSLoc     = [-20,32,7.5];
TRRSDim     = [18,6,9];
TRRSAng     = [0,0,90];

//-------  LAYOUT parameters
//column loop setter
CStart   = C1;  // Set column to begin looping for the build
CEnd     = C6;  // Set column to end for the build
TStart   = T1;  // Set Thumb Cluster Colum to begin
TEnd     = T2;  // Set Thumb Cluster to end
colRange = concat([for (i = [CStart:CEnd]) i], [for (i = [TStart:TEnd]) i]); //columnar for loop range

//structure to hold column origin transformation
ColumnOrigin = [//[translation vec]       [Global Rot]    [Local Rot]
                [[  -54, -unit*3/4,   1], [ 0,   0,   0], [ 0, 90,  0]], //INDEX 1
                [[  -36,-unit*7/16,   0], [ 0,   0,   0], [ 0, 90,  0]], //INDEX 2
                [[  -18,   -unit/4,  -2], [ 0,   0,   0], [ 0, 90,  0]], //INDEX 3
                [[    0,    unit/8,  -5], [ 0,   0,   0], [ 0, 90,  0]], //MIDDLE
                [[   18,   -unit/8,   0], [ 0,   0,  -0], [ 0, 90,  0]], //RING
                [[ 37.0, -unit*5/8,  12], [ 0,   5, -15], [ 0, 90,  0]], //PINKY 1
                [[ 53.0, -unit*5/8,  16], [ 0,  10, -15], [ 0, 90,  0]], //PINKY 2
                [[ 67.0, -unit*5/8,  21], [ 0,  15, -15], [ 0, 90,  0]], //PINKY 3
                [[  -61,       -10, -27], [ 0,   0,  10], [-5, 95,  0]], //Thumb Outer
                [[  -36,       -22, -14], [ 0,   0,   0], [ 0, 90,-60]], //Thumb OuterMid
                [[  -29,     -13.5,   3], [ 0,   0,   0], [ 0, 90,-60]], //Thumb Midlde
                [[  -29,     -13.5,   3], [ 0,   0,   0], [ 0, 90,-60]],  //Thumb InnerMid
                [[  -29,     -13.5,   3], [ 0,   0,   0], [ 0, 90,-60]]  //Thumb Inner
               ];

ThumbShift  = [[-0,-5, 0],[ 0, -5, 5],[ 0, 0, 0]]; //global transform for thumb cluster to jog as whole rather than editing origin

//-------  and adjustment parameters

//row loop setter
//              C0:i1 C1:i2 C2:i3  C3:m  C4:r C5:p1 C6:p2 C7:p3 T0:Ot T1:OM T2:Md  T3:IM  T4:In
RowInits    = [   R2,    R1,   R1,   R1,   R1,   R1,   R1,   R0,   R1,   R1,    R1,   R1,    R0]; //set which Row to begin
RowEnds     = [   R2,    R2,   R2,   R2,   R2,   R2,   R2,   R0,   R1,   R2,    R1,   R1,    R0]; //set which Row to end

//Row transforms
RowTrans    = [[ -.18, -.18, -.18, -.18, -.18, -.55, -.55, -.55, -1.0,-1.25,-1.25,     0,     0], //R0
               [  .80,  .80,  .80,   .8,   .8,  .45,  .45,  .45,    0,    0,   .1,    .1,     0], //R1s
               [ 1.95, 1.95, 1.95, 1.95, 1.95, 1.60, 1.60, 1.60,    0, 1.05,    0,     0,     0], //R2s
               [ 2.90, 2.90, 2.90, 2.90, 2.90, 2.55, 2.55, 2.55,    0, 1.75,    0,     0,     0], //R3s
               [ 3.80, 3.80, 3.80, 3.80, 3.80,    1,  .83,    3,    0,    0,    0,     0,     0], //R4
               [ 4.45, 4.45, 4.45, 4.45, 4.45,    4,   -4,    4,    0,    0,    0,     0,     0]  //R5
              ]*unit;

ColTrans    = [[    0,    0,    0,    0,    0,    0,    0,    0,    0,   .3,    0,     0,     0], //R0
               [    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,  1.25,     0], //R1s
               [    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0], //R2s
               [    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0], //R3s
               [    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0], //R4
               [    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0]  //R5
              ]*unit;

Pitch       = [[   25,   25,   25,   25,   25,   25,   25,   25,   10,   10,  -10,     0,     0],  //R0
               [   15,   15,   15,   15,   15,   15,   15,   15,    0,  -15,  -25,   -25,     0],  //R1s
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
CapScale     =[[   1,     1,     1,     1,     1,     1,     1,     1,    1,    1,     1,     1],  //R0
               [   1,     1,     1,     1,     1,     1,     1,     1, 1.25,    1,  1.25,  1.25],  //R1s
               [   1,     1,     1,     1,     1,     1,     1,     1,    1,    1,     1,     1],  //R2s
               [   1,     1,     1,     1,     1,     1,     1,     1,    1,    1,     1,     1],  //R3
               [   1,     1,     1,     1,     1,     1,     1,     1,    1,    1,     1,     1],  //R4
               [   1,     1,     1,     1,     1,     1,     1,     1,    1,    1,     1,     1]   //R5
              ];
SwitchOrientation = //if length-wise true
              [[ true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true],
               [ true,  true,  true,  true,  true,  true,  true,  true,  true,  true, false,  true,  true],
               [ true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true],
               [ true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true],
               [ true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true],
               [ true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true]
              ];
//-----     border Customization

TopCuts = [[T1, R1, [RIGHT,0,0], T2, R1, [LEFT,0,0]],
           [T1, R2, [RIGHT,0,0], T2, R1, [LEFT,0,0]],
           [T2, R1, [RIGHT,0,0], T3, R1, [LEFT,0,0]]
          ];
// define Columns will needs Left or Right borders not catched by Generic calls
Lborder    = [[], //R0
               [], //R1
               [], //R2
               [], //R3
               [], //R4
               []  //R5
              ]; //color "DarkGreen"
Rborder    = [[], //R0
               [], //R1
               [], //R2
               [], //R3
               [], //R4
               []  //R5
              ]; //color "YellowGreen"

//define Spical border Hull to make border pretty
//define Spical border Hull to make border pretty
Sborder = //color "Crimson"
 [
//[[Col, Row, len = true, Jog direction, HullFace, Scale], ...],
  [[C1, RowEnds[C1], false,FRONT, [LEFT,0,0], [1,RScale,1]], //fill gap between general border and Bottom Enclosure near C1
   [C2, RowEnds[C2], false,FRONT, [LEFT,0,0], [1,RScale,1]],
   [C3, RowEnds[C3], false,FRONT, [LEFT,0,0], [1,RScale,1]]],

  [[C2, RowEnds[C2], false,FRONT, [RIGHT,0,0], [1,RScale,1]], //fill gap between general border and Bottom Enclosure near C3
   [C3, RowEnds[C3], false,FRONT, [0,0,0],     [1,RScale,1]],
   [C3, RowEnds[C3], false,FRONT, [0,0,0],     [1,RScale,1]],
   [C4, RowEnds[C4], false,FRONT, [LEFT,0,0],  [1,RScale,1]]],

  [[C4, RowEnds[C4], false,FRONT, [RIGHT,0,0], [1,RScale,1]], //fill gap between general border and Bottom Enclosure near C4
   [C5, RowEnds[C5], false,FRONT, [RIGHT,0,0], [1,RScale,1]],
   [C6, RowEnds[C6], false,FRONT, [0,0,0],     [1,RScale,1]]],

  [[T1, RowInits[T1],  true,RIGHT, [0,0,0], [RScale,1,1]], //fill gap between T1 and T2 BACK
   [T2, RowInits[T2], false, BACK, [0,0,0], [1,RScale,1]]]
 ];

//define Spical border Hull to join Column and Thumb Cluster
TCJoints = //color "Salmon"
 [
   [[C1, RowInits[C1],  true,  LEFT,   [0,FRONT,0], [RScale,1,1]], //Left C1R0 to T1R2
    [C1, RowInits[C1],  true,  LEFT,   [0,BACK,0],  [RScale,1,1]],
    [T1,  RowEnds[T1], false, FRONT,   [0,0,0],     [1,RScale,1]]
   ],
   [[C1, RowInits[C1],  true,  LEFT,   [0,BACK,0], [RScale,1,1]],  //C1R0 corner to T1R2
    [C1, RowInits[C1], false,  BACK,   [LEFT,0,0], [1,RScale,1]],
    [T1,  RowEnds[T1], false, FRONT,   [RIGHT,0,0], [1,RScale,1]]
   ],
//   [[C1, RowInits[C1], false,  BACK,    [0,0,0],        [1,RScale,1]],
//    [T1,  RowEnds[T1],  true, RIGHT,    [LEFT,FRONT,0], [RScale,1,1]],
//   ],
    [[C1, RowInits[C1], false,  BACK,    [0,0,0],     [1,RScale,1]],
//     [C3, RowInits[C3], false,  BACK,    [LEFT,0,0],  [1,RScale,1]],
     [T2,  RowEnds[T2], false, FRONT,    [RIGHT,0,0],     [CapScale[R1][T2],RScale,1]],
     [T1,  RowEnds[T1],  true, RIGHT,    [0,FRONT,0], [RScale,1,1]]
   ],
   [[C2, RowInits[C2], false,  BACK,    [0,0,0],  [1,RScale,1]],
    [T2,  RowEnds[T2], false, FRONT,    [RIGHT,0,0], [1,RScale,1]],
    [T2,  RowEnds[T2], false,  BACK,    [RIGHT,0,0], [1,RScale,1]]
   ],
//   [[C3, RowInits[C3], false,  BACK,    [0,0,0],    [1,RScale,1]],
//    [C4, RowInits[C4], false,  BACK,    [LEFT,0,0], [1,RScale,1]]
//   ]
 ];


/* 2 sets of structure to hull to generate Bottom enclosures starting from Top Surface and Projected Bottom surface.
   Bottom structure is also used to generate bottom plates? may need to seperate due to concavity of border...
*/

//TODO simplify scale call
Eborder =
  [//[[Col, Row, len = true, Jog direction1, HullFace, Scale], ...],
    //LEFT Section
    [//T1R1 to R2 0
      [[TStart, RowInits[TStart], true, LEFT,               [0,0,0],      [RScale,1,1]],
       [TStart,               R2, true, LEFT,               [0,BACK,0],      [RScale,1,1]] ],
      [[TStart, RowInits[TStart], true, LEFT+ThumbOffset,   [0,BACK,BOTTOM], [EScale,1,1]],
       [TStart,               R2, true, LEFT+ThumbOffset,   [0,FRONT,BOTTOM], [EScale,1,1]] ]
    ],
    [//T1R2  Side
      [[TStart, RowEnds[TStart], true, LEFT,              [0,0,BOTTOM], [RScale,1,1]],
       [TStart,              R1, true, LEFT,              [0,FRONT,BOTTOM], [RScale,1,1]] ],
      [[TStart, RowEnds[TStart], true, LEFT+ThumbOffset,  [0,FRONT,BOTTOM], [EScale,1,1]] ]
    ],
    [//T1 to C1R1
      [[T1, R2, true, LEFT,              [0,FRONT,0], [1,RScale,1]],
       [T1, R2, false,FRONT,             [LEFT,0,0], [1,RScale,1]],
       [C1, R1, true, LEFT,              [0,FRONT,BOTTOM],    [RScale,1,1]] ],
      [[T1, R2, true, LEFT+ThumbOffset,   [0,FRONT,BOTTOM],    [EScale,1,1]],
       [C1, R1, true, LEFT+LeftOffset,   [0,FRONT,BOTTOM],    [EScale,1,1]] ]
    ],
    [//C1R1 to C1R2 side
      [[C1, R1, true, LEFT,              [0,FRONT,BOTTOM], [RScale,1,1]],
       [C1, R2, true, LEFT,              [0,BACK,BOTTOM],  [RScale,1,1]] ],
      [[C1, R1, true, LEFT+LeftOffset,   [0,FRONT,BOTTOM], [EScale,1,1]],
       [C1, R2, true, LEFT+LeftOffset,   [0,BACK,BOTTOM],  [EScale,1,1]] ]
    ],
    [//C1R2 side
      [[C1, R2, true, LEFT,              [0,0,BOTTOM], [RScale,1,1]]],
      [[C1, R2, true, LEFT+LeftOffset,   [0,0,BOTTOM], [EScale,1,1]]]
    ],

    //FRONT Section
    [//CStart Front conrer 5
      [[CStart, RowEnds[CStart], true, LEFT,              [0,FRONT,BOTTOM], [RScale,1,1]],
       [CStart, RowEnds[CStart], false,FRONT,             [LEFT,0,BOTTOM],  [1,RScale,1]]],
      [[CStart, RowEnds[CStart], true, LEFT+LeftOffset,   [0,FRONT,BOTTOM], [EScale,1,1]],
       [CStart, RowEnds[CStart], false,FRONT+FrontOffset, [LEFT,0,BOTTOM],  [1,EScale,1]]]
    ],
    [//C1R3 FRONT to C2R3
      [[C1, RowEnds[C1], false,FRONT,             [LEFT,0,BOTTOM], [1,RScale,1]],
       [C3, RowEnds[C3], false,FRONT,             [LEFT,0,BOTTOM], [1,RScale,1]]],
      [[C1, RowEnds[C1], false,FRONT+FrontOffset, [LEFT,0,BOTTOM], [1,EScale,1]],
       [C3, RowEnds[C3], false,FRONT+FrontOffset, [LEFT,0,BOTTOM], [1,EScale,1]]]
    ],
    [//C3R3 FRONT
      [[C3, RowEnds[C3], false,FRONT,             [0,0,BOTTOM], [1,RScale,1]] ],
      [[C3, RowEnds[C3], false,FRONT+FrontOffset, [0,0,BOTTOM], [1,EScale,1]] ]
    ],
    [//C3R3 FRONT to C4R3
      [[C3, RowEnds[C3], false,FRONT,             [RIGHT,0,BOTTOM], [1,RScale,1]],
       [C4, RowEnds[C4], false,FRONT,             [RIGHT,0,BOTTOM], [1,RScale,1]]],
      [[C3, RowEnds[C3], false,FRONT+FrontOffset, [RIGHT,0,BOTTOM], [1,EScale,1]],
       [C4, RowEnds[C4], false,FRONT+FrontOffset, [RIGHT,0,BOTTOM], [1,EScale,1]]]
    ],
    [//C4R3 FRONT to CEnd (C5~C6, for C7 recommend edit)
      [[C4, RowEnds[C4], false,FRONT,                 [RIGHT,0,BOTTOM], [1,RScale,1]],
       [CEnd, RowEnds[CEnd], false,FRONT,             [RIGHT,0,BOTTOM], [1,RScale,1]]],
      [[C4, RowEnds[C4], false,FRONT+FrontOffset,     [RIGHT,0,BOTTOM], [1,EScale,1]],
       [CEnd, RowEnds[CEnd], false,FRONT+FrontOffset, [RIGHT,0,BOTTOM], [1,EScale,1]]]
    ],
    [//CEnd conrer
      [[CEnd, RowEnds[CEnd], true, RIGHT,             [0,FRONT,BOTTOM], [RScale,1,1]],
       [CEnd, RowEnds[CEnd], false,FRONT,             [RIGHT,0,BOTTOM], [1,RScale,1]]],
      [[CEnd, RowEnds[CEnd], true, RIGHT+RightOffset, [0,FRONT,BOTTOM], [EScale,1,1]],
       [CEnd, RowEnds[CEnd], false,FRONT+FrontOffset, [RIGHT,0,BOTTOM], [1,EScale,1]]]
    ],
    //RIGHT Section
    [//CEndR1 side  11
      [[CEnd, RowInits[CEnd], true, RIGHT,             [0,0,BOTTOM], [RScale,1,1]]],
      [[CEnd, RowInits[CEnd], true, RIGHT+RightOffset, [0,0,BOTTOM], [EScale,1,1]]]
    ],
    [//CEnd R1 to R2 side
      [[CEnd, R1, true, RIGHT,            [0,FRONT,BOTTOM], [RScale,1,1]],
       [CEnd, R2, true, RIGHT,            [0,BACK,BOTTOM],  [RScale,1,1]],],
      [[CEnd, R1, true, RIGHT+RightOffset,[0,FRONT,BOTTOM], [EScale,1,1]],
       [CEnd, R2, true, RIGHT+RightOffset,[0,BACK,BOTTOM],  [EScale,1,1]]]
    ],
    [//CEnd R1 side
      [[CEnd, R2, true, RIGHT,            [0,0,BOTTOM], [RScale,1,1]]],
      [[CEnd, R2, true, RIGHT+RightOffset,[0,0,BOTTOM], [EScale,1,1]]]
    ],

    //Back Section
    [//TStart conrer  14
      [[TStart, RowInits[TStart], true, LEFT,               [0,BACK,0],      [RScale,1,1]],
       [TStart, RowInits[TStart], false,BACK,               [LEFT,0,0],      [1,RScale,1]]],
      [[TStart, RowInits[TStart], true, LEFT+ThumbOffset,   [0,BACK,BOTTOM], [EScale,1,1]],
       [TStart, RowInits[TStart], false,BACK-ThumbOffset,   [LEFT,0,BOTTOM], [1,EScale,1]]]
    ],
    [//T1
      [[T1, R1, false,BACK,               [0,0,BOTTOM], [1,RScale,1]]],
      [[T1, R1, false,BACK-ThumbOffset,   [0,0,BOTTOM], [1,EScale,1]]]
    ],
    [//T1 to T2  TODO FIX
      [[T1, R1, false,BACK,               [RIGHT,0,0], [1,RScale,1]],
       [T2, R1, false,BACK,               [RIGHT,0,0], [1,RScale,1]] ],
      [[T1, R1, false,BACK-ThumbOffset,   [RIGHT,0,BOTTOM], [1,EScale,1]],
       [T2, R1, false,BACK+BackOffset,    [RIGHT,0,BOTTOM], [1,EScale,1]] ]
    ],
    [//T2 corner ALT
      [[T2, R1, false,BACK,               [RIGHT,0,BOTTOM], [1,RScale,1]],
        ],
      [[T2, R1, false,BACK+BackOffset,    [RIGHT,0,BOTTOM], [1,EScale,1]],
       [T2, R1,  true,BACK+BackOffset,    [0,BACK,BOTTOM],  [EScale,1,1]] ]
    ],
    [//T2 to C3 BACK ALT
      [[T2, R1, false,BACK,               [RIGHT,0,BOTTOM], [1,RScale,1]],
       [C2, R1, false,BACK,                [RIGHT,0,BOTTOM], [1,RScale,1]] ],
      [[T2, R1,  true,BACK+BackOffset,    [0,BACK,BOTTOM],  [EScale,1,1]],
       [C2, R1, false,BACK+BackOffset,     [RIGHT,0,BOTTOM], [1,EScale,1]] ]
    ],
    [//C3R0 C4R1 BACK ALT
      [[C2, R1, false,BACK,                [RIGHT,0,BOTTOM], [1,RScale,1]],
       [C4, R1, false,BACK,                [LEFT,0,BOTTOM], [1,RScale,1]],],
      [[C2, R1, false,BACK+BackOffset,     [RIGHT,0,BOTTOM], [1,EScale,1]],
       [C4, R1, false,BACK+BackOffset,     [LEFT,0,BOTTOM], [1,EScale,1]]]
    ],
    [//C4R0 C5R1 BACK
      [[C4, R1, false,BACK,                [LEFT,0,BOTTOM], [1,RScale,1]],
       [C5, R1, false,BACK,                [LEFT,0,BOTTOM], [1,RScale,1]],],
      [[C4, R1, false,BACK+BackOffset,     [LEFT,0,BOTTOM], [1,EScale,1]],
       [C5, R1, false,BACK+BackOffset,     [LEFT,0,BOTTOM], [1,EScale,1]]]
    ],
    [//C5R1 BACK
      [[C5, R1, false,BACK,                [0,0,BOTTOM], [1,RScale,1]]],
      [[C5, R1, false,BACK+BackOffset,     [0,0,BOTTOM], [1,EScale,1]]]
    ],
    [//C6R3 BACK
      [[C6, R1, false,BACK,                [0,0,BOTTOM], [1,RScale,1]]],
      [[C6, R1, false,BACK+BackOffset,     [0,0,BOTTOM], [1,EScale,1]]]
    ],
    [//CEnd Back conrer
      [[CEnd, RowInits[CEnd], true, RIGHT,               [0,BACK,BOTTOM],  [RScale,1,1]],
       [CEnd, RowInits[CEnd], false,BACK,                [RIGHT,0,BOTTOM], [1,RScale,1]]],
      [[CEnd, RowInits[CEnd], true, RIGHT+RightOffset,   [0,BACK,BOTTOM],  [EScale,1,1]],
       [CEnd, RowInits[CEnd], false,BACK+BackOffset,     [RIGHT,0,BOTTOM], [1,EScale,1]]]
    ],
  ];
//---- Bottom Plate Design

mountScrew  = [[-16,-30,0],[59.5,-23.5,0],[24,41,0],[68,10,0],[-35,32,0],[-39,0,0]];
mountHull   = [16,23,8,10,5,2];

//Hull struct contain the Estruct array IDe to hull bottom plate: concavity exsits so blind hull will result in failuer
Hstruct =
  [[0,1,2,3,4,5,14,15,16,17,18],
   [6,7,8,19],
   [9,10,13,20],
   [11,12,21,22],
 ];

addCuts =
  [ [17,18,19,20]
  ];
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
