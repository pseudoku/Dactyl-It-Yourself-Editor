include <SRC/DIYBuilder.scad>
//include <SRC/DIYBuilderB.scad>
//TODO: Simplify builds! do not rely on commenting to get build!
//TODO: improve jack orientation 
//Uncomment Layout you want or build your own layout

include <SRC/Layouts/Pseudoku/CorneTron.scad> // 5x3+4 FlatLander's Paradigm. Status:INCOMPLETE


//include <SRC/Layouts/Pseudoku/HypoWarp_Choc.scad> // (6x3+2)+[121] Hypothetical Rhetoric. Status:Complete no build test
//include <SRC/Layouts/Pseudoku/HypoWarpMX.scad> // (5x3+2)+[trichord] Hypothetical Rhetoric. Status:Complete no build test
//include <SRC/Layouts/Pseudoku/SpaceWarpMX.scad> // (5x3+2)+[trichord] Hypothetical Rhetoric. Status:Complete no build test

//include <SRC/Layouts/Pseudoku/MiniWarp.scad>  // (5x3+2)+[trichord] Minimalism Ho Status:INCOMPLETE Priority HIGH

//include <SRC/Layouts/Pseudoku/GiGi_Choc.scad>            // 6x2+[021] Steno Dreamer Original Version with thumb cluster
//include <SRC/Layouts/Pseudoku/GiGi_Trichord.scad>        // 6x2+[0111] Alternate Thumb cluster prioritizing trichord comfort and more naturla finger spread
//include <SRC/Layouts/Pseudoku/GiGi_Incredulous.scad>     // (6x2)+[0111] chopped thumb cluster and Trackball

//Asymplex Series a simplex of asymptotic lexicon
//include <SRC/Layouts/Pseudoku/Epigrammatic.scad>     // (4x2+3)+[0111] chopped thumb cluster and Trackball
//include <SRC/Layouts/Pseudoku/EpigrammaticNoTrack.scad>     // (4x2+3)+[0111] prioritize low profile
//include <SRC/Layouts/Pseudoku/Asymplex.scad> // 4x3+ ultra Low prof . Status:INCOMPLETE
//include <SRC/Layouts/Pseudoku/NullApothegm.scad> // 4x1+1 . Status:INCOMPLETE
//$fn =64;  

//##################     Main Calls    ##################
//rotate([0,0,360*$t]){ // for animation 
/*1. Top Plate*/
mirror([0,0,0]){ //[100] for Left side
  
  difference(){
    union(){
      rotate(tenting)translate([0,0,plateHeight]){
        BuildTopPlate(
          //MockUp           = true,    // trun on switch and caps not yes functional
          keyhole          = false,// turn on keyhole cuts 
          trackball        = false,   // turn on trackball module
          ThumbJoint       = false,   // turn on thu+mb and column joint module 
          Border           = false,   // Generic Top enclosure
          PrettyBorder     = false,   //Lazy man's pretty border 
          CustomBorder     = false,   //manually defined custom border
          ColoredSection   = true //Color border by module to visiualize during edit/debug
          );
     //encoder test for incredulous 
//    PlaceRmCn(R1,T4)translate([0,0,0])rotate([0,0,0])RotaryEncoder(stemLength = 16, Wheel = 25);
    }
    color("silver")difference(){
      union(){
//        BuildBottomEnclosure(struct = Eborder, Mount = false, JackType = "RJ45",, MCUType = false);
      }
//     BuildBottomPlate(struct = Eborder, hullList = Hstruct, Mount = false, JackType = false, MCUType = false);  
    }

    }
//    translate(JackLoc+[0,0,0])rotate(JackAng+[0,0,0])translate([0,-4,0])cube([15.24,20.75,15], center= true); // additional cut 
    translate([0,0,-1])cube([150,150,2], center = true);
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
    }
//    #rotate(tenting)translate([0,0,plateHeight])translate(trackOrigin)rotate(trackTilt)rotate(SensorRot)translate([0,0,-38/2])PCB();
//  } 
//difference(){
// translate([5,5,-1.1])cube([140,110,6],center=true);
//  BuildBottomPlate(Mount = false, JackType = false, MCUType = true);  
//  
//}
// translate([-30,25,-.2]) rotate([0,0,180])scale(2.5){
//    rotate([0,0,0]){
//      translate([3.5,-3.65,0])hull(){
//        rotate([0,0,30])cylinder(r = 1.5, .1, $fn = 3);
//        translate([0,0,.5])rotate([0,0,60])cylinder(r = .5, .1, $fn = 3);
//      }
//      translate([0.5,-3.65,0])hull(){
//        rotate([0,0,30])cylinder(r = 1.5, .1, $fn = 3);
//        translate([0,0,.5])rotate([0,0,0])cylinder(r = .5, .1, $fn = 3);
//      }
//    }
//  rotate([0,0,0]){
//    translate([2.,-4.40,0])rotate([0,0,180])hull(){
//      rotate([0,0,30])cylinder(r = 1.5, .1, $fn = 3);
//      translate([0,0,.5])rotate([0,0,-30])cylinder(r = .5, .1, $fn = 3);
//    }
//  //  translate([2.25+shiftx,-2.85,5.0])sphere(.20, $fn = 32);
//    
//    translate([3.5,-2.0,0])rotate([0,0,180])hull(){
//      rotate([0,0,30])cylinder(r = 1.5, .1, $fn = 3);
//      translate([0,0,.5])rotate([0,0,30])cylinder(r = .5, .1, $fn = 3);
//    }
//  }
//}
// translate([45,0,-.2]) rotate([0,0,0])scale(2.5){
//    rotate([0,0,0]){
//      translate([3.5,-3.65,0])hull(){
//        rotate([0,0,30])cylinder(r = 1.5, .1, $fn = 3);
//        translate([0,0,.5])rotate([0,0,60])cylinder(r = .5, .1, $fn = 3);
//      }
//      translate([0.5,-3.65,0])hull(){
//        rotate([0,0,30])cylinder(r = 1.5, .1, $fn = 3);
//        translate([0,0,.5])rotate([0,0,0])cylinder(r = .5, .1, $fn = 3);
//      }
//    }
//  rotate([0,0,0]){
//    translate([2.,-4.40,0])rotate([0,0,180])hull(){
//      rotate([0,0,30])cylinder(r = 1.5, .1, $fn = 3);
//      translate([0,0,.5])rotate([0,0,-30])cylinder(r = .5, .1, $fn = 3);
//    }
//  //  translate([2.25+shiftx,-2.85,5.0])sphere(.20, $fn = 32);
//    
//    translate([3.5,-2.0,0])rotate([0,0,180])hull(){
//      rotate([0,0,30])cylinder(r = 1.5, .1, $fn = 3);
//      translate([0,0,.5])rotate([0,0,30])cylinder(r = .5, .1, $fn = 3);
//    }
//  }
//}
////  translate([0,0,-10])cube([20,20,20]);
////container(xu = 1, yu = 2.25, yn = 2);
// // simplex sig
//  rotate([0,0,0])translate([-40,-30,-.5])scale(3){
//    difference() {
//    minkowski(){
//     {
//       union(){
//            cylinder(r=.75, .25, $fn = 32);
//            translate([0,-.05,0])cube([4.5,.1,.25]);
//          }
//        }
//      sphere(.15, $fn = 32);
//      }
//     cylinder(r=.75, , $fn = 32,center = true);
//    }
//        sphere(.65, $fn = 32);
//        translate([2.25,0,0])sphere(.65, $fn = 32);
//        translate([4.5,0,0])sphere(.65, $fn = 32);
//  }

/*2. Bottom Plate  Test */
//rotate(tenting)translate([0,0,plateHeight])
//difference(){
//  union(){
//   BuildBottomPlate2(Mount = true, JackType = false, MCUType = true);  
//   difference(){
//     hull(){
//       PlaceRmCn(R1,C5)translate([0,-4,-4])rotate([0,0,0])cube(PlateDim-[0,8,0],center = true);
//       PlaceRmCn(R1,C5)translate([0,-4,-12])rotate([90,0,0])cylinder(d = 12, 10,center = true);
//     }
//     PlaceRmCn(R1,C5)translate([0,0,-12])rotate([90,0,0])cylinder(d = 5, 20,center = true);     
//   }
//  }
//  BuildTopPlate(
//          //MockUp           = true,    // trun on switch and caps not yes functional
//          keyhole          = false,// turn on keyhole cuts 
//          trackball        = false,   // turn on trackball module
//          ThumbJoint       = true,   // turn on thu+mb and column joint module 
//          Border           = false,   // Generic Top enclosure
//          PrettyBorder     = false,   //Lazy man's pretty border 
//          CustomBorder     = true,   //manually defined custom border
//          ColoredSection   = true //Color border by module to visiualize during edit/debug
//          );
// BuilHotSwapSet(switchH = -.75);
// 
//     PlaceRmCn(R1,C3)translate([-2.54*2.5,-8,-5])rotate([0,0,0]){
//      for(i = [0:5]){
//        translate([2.54*i,0,0])cylinder(d = 1, 10,center = true);
//      }
//      
//      for(i = [0:5]){
//        translate([-2.54,2.54*i,0])cylinder(d = 1, 10,center = true);
//        translate([2.54*6,2.54*i,0])cylinder(d = 1, 10,center = true);
//      }
//     }
//     PlaceRmCn(R1,C3)translate([0,0,-2.5])cube(PlateDim-[0,0,-1],center = true);
//     BuildSet(switchType = Choc, capType = DSA, colors = "ivory", stemcolor = "lightGreen",switchH = -.75);
//}   

      rotate(tenting)translate([0,0,plateHeight]){ BuildSet(switchType = MX, capType = Choc, colors = "ivory", stemcolor = "lightGreen",switchH = -.75);} //(switchH = 0 for mx platethicknes 3.5, for -.75 for 2 )

//}
//  #rotate(tenting)translate([0,0,plateHeight])translate(trackOrigin)rotate(trackTilt)rotate(SensorRot)translate([0,0,-42/2])PCB(3);
//}
/*3. caps for visualization */

//rotate(tenting)translate([0,0,plateHeight])translate(trackOrigin)rotate(trackTilt)color("royalblue")sphere(d=trackR*2,$fn= 64);
     
  }