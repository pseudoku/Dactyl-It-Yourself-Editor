include <SRC/DIYBuilder.scad>
//TODO: Simplify builds! do not rely on commenting to get build!
//Uncomment Layout you want or build your own layout

//include <SRC/Layouts/Pseudoku/LapidaryInanityFull.scad> // 5x3+4 FlatLander's Paradigm
//include <SRC/Layouts/Pseudoku/HypoWarp_Choc.scad>       // (6x3+2)+4 Hypothetical Rhetoric 
//include <SRC/Layouts/Pseudoku/HypoWarp_Choc+TB.scad>       // (6x3+2)+4 Hypothetical Rhetoric 
//include <SRC/Layouts/Pseudoku/MiniWarp_Choc.scad>      // (5x3+2)+3 Jumpin' Jacks Jr. 
include <SRC/Layouts/Pseudoku/GiGi_Choc.scad>           // 5x2+3 Steno Dreamer 
//include <SRC/Layouts/Pseudoku/GiGi(030)TB_Choc.scad>           // 5x2+3 Steno Dreamer 
//include <SRC/Layouts/Pseudoku/GiGi_MX.scad>           // 5x2+3 Steno Dreamer 
//include <SRC/Layouts/Pseudoku/AlphaPrime_Choc.scad>     // 5x2+4 BigBrained Alpha  


//##################     Main Calls    ##################
//rotate([0,0,360*$t]){ // for animation 
/*1. Top Plate*/
mirror([0,0,0]){ //[100] for Left side
  difference(){
    rotate(tenting)translate([0,0,plateHeight]){
      BuildTopPlate(
        MockUp           = true,    // trun on switch and caps 
        keyhole          = true,    // turn on keyhole cuts
        trackball        = true,   // turn on trackball mdoul
        ThumbJoint       = true,   // turn on thu+mb and column joint module 
        Border           = false,   // Generic Top enclosure
        PrettyBorder     = true,   //Lazy man's pretty border 
        CustomBorder     = true,   //manually defined custom border
        ColoredSection   = false //Color border by module to visiualize during edit/debug 
        );

    //  PlaceRmCn(R2,T1)rotate([0,90,0])RotaryEncoder(stemLength = 5, Wheel = 25);
    }
//      translate(trackOrigin)color("royalblue")sphere(d=trackR*2+.5,$fn= 64);
  }
//     translate(trackOrigin)rotate(trackTilt)Tra
  difference(){
   BuildBottomEnclosure(struct = Eborder, Mount = true, JackType = true, MCUType = true);
   BuildBottomPlate(struct = Eborder, hullList = Hstruct, Mount = false, JackType = false, MCUType = false);  
  }

/*2. Bottom Plate */
  color()BuildBottomPlate(struct = Eborder, hullList = Hstruct, Mount = true, JackType = true, MCUType = true);  

/*3. caps for visualization */
  rotate(tenting)translate([0,0,plateHeight]){BuildSet(switchType = Choc, capType = DSA, colors = "ivory", stemcolor = "lightGreen");}

}