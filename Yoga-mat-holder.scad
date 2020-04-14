d=130;
w=10;
pstep=10;
psize=7;
h=10;

hole_d=3;
hole_cap=hole_d*3;
hole_sym_dist=5;

mount_placement=-2;
mount_thickness=w/3+0.8;

$fa=1;
$fs=0.4;
$fn=100;

_scaling=[1,0.9,1];
_unscaling=[1/_scaling[0],1/_scaling[1],1/_scaling[2]];

module circ_points(step, size, r) {
     for (i = [0:step:360]) {
          rotate(i)
               translate([r,0,0])
//               rotate(-45-i, x)
               scale(_unscaling)
               circle(d=size);
     }
}

module base_arm(d, w, pstep, psize) {
     r = d/2;

     module base_arc() {
          difference() {
               circle(d=d+2*w);
               circle(d=d);
               polygon([[0,0],[2*(r+w),0],[0,2*(r+w)]]);
               circ_points(pstep, psize, (d+w)/2);
          }
     }

     module bulb(from, to) {
          difference() {
               circle(d=to*w);
               circle(d=from*w);
          }
     }

     module bulbs(from, to) {
          translate([r+w/2,0,0])
               rotate(-45)
               scale(_unscaling)
               bulb(from, to);
     
          translate([0,r+w/2,0])
               rotate(-45)
               scale(_unscaling)
               bulb(from, to);
     }

     union() {
          difference() {
               base_arc();
               bulbs(0, 1.5);
          }
          bulbs(1.1, 1.5);
     }
}

module ring(d, xa) {
     translate([0,0,h/2])
          rotate(45-xa/2)
          rotate_extrude(angle=-270+xa)
          translate([d/2,0,0])
          circle(d=psize/1);
}

module circ_arm(d, w, pstep, psize) {
     difference()
     {
          union() {
               linear_extrude(h) {
                    rotate(45)
                         base_arm(d,w, pstep, psize);
                    translate([0,-(d+w)/2,0])
                         square([2*w,w], center=true);
               }
//               translate([0,-(d+2*w)+mount_thickness,h/2])
//                    sphere(d=d+2*w);
          }
          ring(d+2*w, 9);
          // wall support
          // mount cutting
          translate([0,-d-d/2-w-mount_placement,0])
               cube(2*d, center=true);
          ring(d, 11.5);
     }
}


module holes() {
     translate([0,-(d/2),h/2])
          rotate([90,0,0])
          for (i = [-hole_sym_dist,hole_sym_dist]) {
               translate([i,0,0]) {
                    hl=3*w;
                    translate([0,0,hl/2])
                         cylinder(hl,d=hole_d, center=true);
                    rotate_extrude()
                         polygon([[0,0],[hole_cap/2,0],[0,hole_cap/2]]);
                    translate([0,0,-hl/2])
                         cylinder(hl,d=hole_cap, center=true);
               }
          }
}

module detail() {
     //scale(_scaling)
          difference()
     {
          circ_arm(d, w, pstep, psize);
          holes();
     }
}

rotate([90,0,0])
detail();

