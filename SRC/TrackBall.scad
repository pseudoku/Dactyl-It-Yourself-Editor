
//########    Trackball Module
step = 5;

//--- shorthard transform to blob center

//Path function.
  function oval_path(theta, phi, a, b, c, deform = 0) = [
   a*cos(theta)*cos(phi), //x
   c*sin(theta)*(1+deform*cos(theta)) , //
   b*sin(phi),
  ];

  //oval path with linear angle offset
  function oval_path2(theta, phi_init, a, b, c, d = 0, p = 1, deform = 0) = [
   a*cos(theta)*cos(phi_init), //x
   b*sin(theta)*(1+deform*cos(theta))*cos(phi_init + d * sin(theta*p)), //
   c*sin(phi_init + d * sin(theta*p))
  ];

  //oval path with angle offset with hypersine
  function oval_path3(theta, phi_init, a, b, c, d = 0, p = 1, deform = 0) = [
   a*cos(theta)*cos(phi_init), //x
   b*sin(theta)*(1+deform*cos(theta))*cos(phi_init + d * pow(sin(theta*p), 1)), //
   c*sin(phi_init + d * pow(sin(theta*p), 3))
  ];

//shape functions
function ellipse(a, b, d = 0) = [for (t = [0:step:360]) [a*cos(t), b*sin(t)*(1+d*cos(t))]]; //shape to

// sweep generators

module palm_track() {
  a = trackR;
  b = trackR;
  c = trackR;
  //Ellipsoid([20*2,25*2,60],[30*2,25*2,60], center = true);
  function shape() = ellipse(3, 3);
  function shape2() = ellipse(4, 6);
  path_transforms =  [for (t=[0:step:180]) translation(oval_path3(t,20,a,c,b,30,1,0))*rotation([90,-20-20*sin(t),t])];
  path_transforms2 =  [for (t=[0:step:180]) translation(oval_path3(t,70,b,a,c,6,1,0))*rotation([90,-70+5*sin(t),t])];
//  path_transforms3 =  [for (t=[0:step:360]) translation(oval_path3(t,-5,a,c,b,-15,1,0))*rotation([90,20+15*cos(t),t])];
  path_transforms3 =  [for (t=[0:step:180]) translation(oval_path3(t,-20,a,c,b,-30,1,0))*rotation([90,20+20*sin(t),t])];
  path_transforms4 =  [for (t=[0:step:360]) translation(oval_path3(t,-40,a,c,b,0,1,0))*rotation([90,40+sin(t),t])];

 translate([0,0,-1]){
  rotate([-90,0,0])sweep(shape(), path_transforms);
  rotate([90,0,-90])sweep(shape(), path_transforms2); //tip
  rotate([90,0,90])sweep(shape(), path_transforms2);  //tip
  rotate([-90,0,0])sweep(shape(), path_transforms3);
 }
 //support ring
 rotate([0,0,0])sweep(shape2(), path_transforms4);
}

module PCB(){
  tol = .05;
  PL = 21/2+tol;
  PW = 18.6/2+tol;
  PT = 3;
  PCBT = 1.6;

  //Prism
  translate([0,0,-PT])linear_extrude(PT)rounding(r=8)polygon([[PL,PW],[-PL,PW],[-PL,-PW],[PL,-PW]]);
  translate([PL-6,0,.5])cube([2,4,1],center= true);

  //PCB
  translate([0,0,-.8-PT])cube([28,21,PCBT],center= true);
  translate([24/2,0,-PT-PCBT-2])cylinder(d=2.44, 10);
  translate([-24/2,0,-PT-PCBT-2])cylinder(d=2.44, 10);

  //Apeture
  translate([0,0,0])cylinder(d1=5, d2= 12, 4);
}

PCBA = [45,0,0];
rbearing = .5;
module TrackBall(){
  difference(){
    union(){
     palm_track();
     rotate(PCBA)translate([0,0,-trackR-1])cube([30,22,8],center= true); // pcb housing
    }

//    sphere(d= trackR*2+.5);
    //bearing holes

    //lower bearing
    for(i= [0:2])rotate([0,40,120*i-90])translate([trackR,0,0])sphere(r=rbearing); //upper bearing for tighter fit?
    for(i= [0:1])rotate([0,-10,180*i])translate([trackR,0,0])sphere(r=rbearing); //upper bearing for tighter fit?
    rotate(PCBA)translate([0,0,-42/2])PCB();
  }
}