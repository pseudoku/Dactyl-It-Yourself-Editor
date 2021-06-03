include <SRC/DIYBuilder.scad>
//Uncomment Layout you want or build your own layout

//include <SRC/Layouts/Pseudoku/HypoWarp_Choc.scad>        // (6x3+2)+[trichord+1] Hypothetical Rhetoric.
//include <SRC/Layouts/Pseudoku/MiniWarp.scad>             // (5x3)+[trichord]     Utility Event Horrizon    Status:Complete no build test
//include <SRC/Layouts/Pseudoku/Epigrammatic.scad>

//include <SRC/Layouts/Darrenph1/D-Warp.scad>                // (6x4)+[trichord+1]   Tangental Home Row Cherry Cap Height.

//include <SRC/Layouts/Smeeba/GiGi.scad>
include <SRC/Layouts/Smeeba/GiGi_Trichord.scad>
//include <SRC/Layouts/Smeeba/GiGi_Trichord_One_Star.scad>
//include <SRC/Layouts/Smeeba/GiGi_Trichord_Warp.scad>

 $fn = 18;   //resolution

//##################     Main Calls    ##################
rotate([0,0,360*$t]){ // for animation

/*1. Top Plate*/
  mirror([0,0,0]){ //[100] for Left side
    color(){
      BuildTopPlate(
        Keyhole          = true,  // keyhole cuts + cuts space above plate to remove artifacts frod custod border and enclosure build
        Enclosure        = false,   // light pink if you want to work on layouts turn off for speed
        BottomPlateCuts  = false,  // cuts bottom plate recess on enclosure. turn off while working on enclosure to reduce error and speed
        ThumbJoint       = false,   // salmon color turn on thu+mb and column joint module
        CustomBorder     = false,   // Red manually defined custom border
        ColoredSection   = false,    // Color border by module to visiualize during edit/debug
        BuildConnectors  = false  // build connecters between individual keys in a column and connecters between the columns (default: false)
      );
    }

  //un comment to build bottom plate

  //#BuildBottomPlate(struct = Eborder, hullList = Hstruct, Mount = false, JackType =false, MCUType = false);

  /*3. caps for visualization */
    rotate(tenting)translate([0,0,plateHeight]){
      //BuildSet(capType = DSA, colors = "ivory", stemcolor = "lightGreen", switchH = 0);
    }

  }
}
