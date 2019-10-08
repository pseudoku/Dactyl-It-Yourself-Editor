include <SRC/DIYBuilder.scad>
//TODO: Simplify builds! do not rely on commenting to get build!
//TODO: improve jack orientation 
//Uncomment Layout you want or build your own layout

//include <SRC/Layouts/Pseudoku/CorneTron.scad> // 5x3+4 FlatLander's Paradigm. Status:INCOMPLETE


//include <SRC/Layouts/Pseudoku/HypoWarp_Choc.scad> // (6x3+2)+[121] Hypothetical Rhetoric. Status:Complete no build test

//include <SRC/Layouts/Pseudoku/MiniWarp.scad>  // (5x3-1+2)+[022] Jumpin' Jacks Jr. Status:INCOMPLETE Priority HIGH

//include <SRC/Layouts/Pseudoku/GiGi_Choc.scad>            // 6x2+[021] Steno Dreamer Original Version with thumb cluster
//include <SRC/Layouts/Pseudoku/GiGi_Trichord.scad>        // 6x2+[0111] Alternate Thumb cluster prioritizing trichord comfort and more naturla finger spread
//include <SRC/Layouts/Pseudoku/GiGi_Incredulous.scad>     // (6x2)+[0111] chopped thumb cluster and Trackball

//Asymplex Series a simplex of asymptotic lexicon
include <SRC/Layouts/Pseudoku/Epigrammatic.scad>     // (4x2+2)+[0111] chopped thumb cluster and Trackball
//include <SRC/Layouts/Pseudoku/Asymplex.scad> // 4x1+3 Axiomatic Bat shit crazy. Status:INCOMPLETE
//include <SRC/Layouts/Pseudoku/NullApothegm.scad> // 4x1+1 . Status:INCOMPLETE
$fn =64;

//##################     Main Calls    ##################
//rotate([0,0,360*$t]){ // for animation 
/*1. Top Plate*/
mirror([0,0,0]){ //[100] for Left side

  difference(){
    union(){
//      #rotate(tenting)translate([0,0,plateHeight]){
//        BuildTopPlate(
//          //MockUp           = true,    // trun on switch and caps not yes functional
//          keyhole          = false,// turn on keyhole cuts 
//          trackball        = false,   // turn on trackball module
//          ThumbJoint       = true,   // turn on thu+mb and column joint module 
//          Border           = false,   // Generic Top enclosure
//          PrettyBorder     = false,   //Lazy man's pretty border 
//          CustomBorder     = true,   //manually defined custom border
//          ColoredSection   = true //Color border by module to visiualize during edit/debug
//          );
//     //encoder test for incredulous 
////    PlaceRmCn(R1,T4)translate([0,0,0])rotate([0,0,0])RotaryEncoder(stemLength = 16, Wheel = 25);
//    }
////    color("silver")difference(){
//      union(){
//        BuildBottomEnclosure(struct = Eborder, Mount = true, JackType = true, MCUType = true);
//      }
//      BuildBottomPlate(struct = Eborder, hullList = Hstruct, Mount = false, JackType = false, MCUType = false);  
//      rotate(tenting)translate([0,0,plateHeight])translate(trackOrigin)rotate(trackTilt)rotate(SensorRot)translate([0,0,-42/2])PCB();
//    }
  } 
//rotate(tenting)translate([0,0,plateHeight])BuildBottomPlate2(Mount = true, JackType = false, MCUType = true);  
//  rotate(tenting)translate([0,0,plateHeight])translate(trackOrigin)rotate(trackTilt)color("royalblue")sphere(d=trackR*2+1.25,$fn= 32);
  }
  
  

/*2. Bottom Plate */
rotate(tenting)translate([0,0,plateHeight])
difference(){
  union(){
   BuildBottomPlate2(Mount = true, JackType = false, MCUType = true);  
   difference(){
     hull(){
       PlaceRmCn(R1,C5)translate([0,-4,-4])rotate([0,0,0])cube(PlateDim-[0,8,0],center = true);
       PlaceRmCn(R1,C5)translate([0,-4,-12])rotate([90,0,0])cylinder(d = 12, 10,center = true);
     }
     PlaceRmCn(R1,C5)translate([0,0,-12])rotate([90,0,0])cylinder(d = 5, 20,center = true);     
   }
  }
  BuildTopPlate(
          //MockUp           = true,    // trun on switch and caps not yes functional
          keyhole          = false,// turn on keyhole cuts 
          trackball        = false,   // turn on trackball module
          ThumbJoint       = true,   // turn on thu+mb and column joint module 
          Border           = false,   // Generic Top enclosure
          PrettyBorder     = false,   //Lazy man's pretty border 
          CustomBorder     = true,   //manually defined custom border
          ColoredSection   = true //Color border by module to visiualize during edit/debug
          );
 #BuilHotSwapSet(switchH = -.75);
 
     PlaceRmCn(R1,C3)translate([-2.54*2.5,-8,-5])rotate([0,0,0]){
      for(i = [0:5]){
        translate([2.54*i,0,0])cylinder(d = 1, 10,center = true);
      }
      
      for(i = [0:5]){
        translate([-2.54,2.54*i,0])cylinder(d = 1, 10,center = true);
        translate([2.54*6,2.54*i,0])cylinder(d = 1, 10,center = true);
      }
     }
     PlaceRmCn(R1,C3)translate([0,0,-2.5])cube(PlateDim-[0,0,-1],center = true);
     BuildSet(switchType = Choc, capType = DSA, colors = "ivory", stemcolor = "lightGreen",switchH = -.75);
}   

     rotate(tenting)translate([0,0,plateHeight]){}

//}
//  #rotate(tenting)translate([0,0,plateHeight])translate(trackOrigin)rotate(trackTilt)rotate(SensorRot)translate([0,0,-42/2])PCB(3);
//}
/*3. caps for visualization */

// rotate(tenting)translate([0,0,plateHeight])translate(trackOrigin)rotate(trackTilt)color("royalblue")sphere(d=trackR*2+1,$fn= 32);

  }