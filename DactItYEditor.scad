include <SRC/DIYBuilder.scad>
//Uncomment Layout you want or build your own layout

//include <SRC/Layouts/Pseudoku/HypoWarp_Choc.scad>        // (6x3+2)+[trichord+1] Hypothetical Rhetoric.
//include <SRC/Layouts/Darrenph1/D-Warp.scad>                // (6x4)+[trichord+1]   Tangental Home Row Cherry Cap Height.
include <SRC/Layouts/Pseudoku/MiniWarp.scad>             // (5x3)+[trichord]     Utility Event Horrizon    Status:Complete no build test

//include <SRC/Layouts/Smeeba/GiGi.scad>
include <SRC/Layouts/Smeeba/GiGi_Trichord.scad>
//include <SRC/Layouts/Smeeba/GiGi_Trichord_One_Star.scad>
//include <SRC/Layouts/Smeeba/GiGi_Trichord_One_Index.scad>
//include <SRC/Layouts/Smeeba/GiGi_Trichord_Warp.scad>

$fn = 18;   //resolution
$renderTop = true; // Render top plate
$renderBottom = true; // Render bottom plate
$renderKeycaps = false; // Render keycaps
$mirrorRender = false; // Mirror render

mirrorArray = [$mirrorRender ? 1 : 0,0,0];

//##################     Main Calls    ##################
//rotate([0,0,360*$t]){ // for animation

/*1. Top Plate*/
  mirror(mirrorArray){
    if($renderTop == true) {
      BuildTopPlate(
        Keyhole        = true,  // keyhole cuts + cuts space above plate to remove artifacts frod custod border and enclosure build
        Enclosure      = true,   // light pink if you want to work on layouts turn off for speed
        BottomPlateCuts= true,  // cuts bottom plate recess on enclosure. turn off while working on enclosure to reduce error and speed
        ThumbJoint     = true,   // salmon color turn on thu+mb and column joint module
        CustomBorder   = true,   // Red manually defined custom border
        ColoredSection = true,    // Color border by module to visiualize during edit/debug
        BuildConnectors= true,  // build connecters between individual keys in a column and connecters between the columns
        BuildWells     = true
      );
    }

  //un comment to build bottom plate
  if($renderBottom == true) {
    BuildBottomPlate(struct = Eborder, hullList = Hstruct, Mount = false, JackType = true, MCUType = true, cuts = false);
  }
  /*3. caps for visualization */
    if($renderKeycaps == true) {
      rotate(tenting)translate([0,0,plateHeight]){
        BuildSet(capType = DSA, colors = "ivory", stemcolor = "lightGreen", switchH = 0);
      }
    }

//#BuildBottomPlate(struct = Eborder, hullList = Hstruct, Mount = true, JackType =true, MCUType = true);

/*3. caps for visualization */
  rotate(tenting)translate([0,0,plateHeight]){
//    BuildSet(capType = DSA, colors = "ivory", stemcolor = "lightGreen", switchH = 0);
  }

}
