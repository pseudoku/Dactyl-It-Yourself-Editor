include <SRC/DIYBuilder.scad>
//Uncomment Layout you want or build your own layout

//include <SRC/Layouts/Pseudoku/HypoWarp_Choc.scad>        // (6x3+2)+[trichord+1] Hypothetical Rhetoric.
//include <SRC/Layouts/Darrenph1/D-Warp.scad>                // (6x4)+[trichord+1]   Tangental Home Row Cherry Cap Height.
//include <SRC/Layouts/Pseudoku/MiniWarp.scad>             // (5x3)+[trichord]     Utility Event Horrizon    Status:Complete no build test
include <SRC/Layouts/Smeeba/GiGi_Smeeba.scad>
//include <SRC/Layouts/Smeeba/GiGi_Smeeba(Keyholes).scad>
//include <SRC/Layouts/Smeeba/SiSi_Smeeba.scad>
//include <SRC/Layouts/Smeeba/SiSi_Smeeba(Keyholes).scad>
//include <SRC/Layouts/Smeeba/FlapFlap_Smeeba.scad>
//include <SRC/Layouts/Smeeba/MiniWarp_Smeeba.scad>
//include <SRC/Layouts/Smeeba/HypoWarp_Smeeba.scad>

//still need to update flies
//include <SRC/Layouts/Pseudoku/GiGi_Trichord.scad>        // 5x2+[trichord]   Alternate Thumb cluster prioritizing trichord comfort and more naturla finger spread
//include <SRC/Layouts/Pseudoku/Epigrammatic.scad>         // (4x2+3)+[0111] chopped thumb cluster and Trackball

 $fn =16;   //resolution

//##################     Main Calls    ##################
//rotate([0,0,360*$t]){ // for animation

/*1. Top Plate*/
mirror([0,0,0]){ //[100] for Left side
  color(){
    BuildTopPlate(
      Keyhole          = true,  // keyhole cuts + cuts space above plate to remove artifacts frod custod border and enclosure build
      Enclosure        = true,   // light pink if you want to work on layouts turn off for speed
      BottomPlateCuts  = true,  // cuts bottom plate recess on enclosure. turn off while working on enclosure to reduce error and speed
      Trackball        = false,  // turn on trackball module. don't its a mess
      ThumbJoint       = true,   // salmon color turn on thu+mb and column joint module
      CustomBorder     = true,   // Red manually defined custom border
      ColoredSection   = true    // Color border by module to visiualize during edit/debug
    );
  }

//un comment to build bottom plate

//#BuildBottomPlate(struct = Eborder, hullList = Hstruct, Mount = true, JackType =true, MCUType = true);

/*3. caps for visualization */
  rotate(tenting)translate([0,0,plateHeight]){
//    BuildSet(capType = DSA, colors = "ivory", stemcolor = "lightGreen", switchH = 0);
  }

}
