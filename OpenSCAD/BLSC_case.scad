$fn=100;

/*
difference(){
encodermount();
encodercutout();
}
*/
difference(){
    union(){
        caseU();
        caseL();
    }
    // BLSC text
    translate([-20,-45/2+0.3,-6])rotate([90,0,0])linear_extrude(height = 1){text("BLSC", $fn = 20, size = 10, font = "ArialBlack");}
}

module caseU(){    
    difference(){
        difference(){
            union(){
                difference(){
                    case(25,80,45);
                    case(22,77,42);
                    translate([0,0,-20])cube([100,100,40], center=true);
                    translate([-13,-3,0])cutoutscreenOLED(); // leave 0.3mm wall
                    translate([0,0,8])cooling();
                    // cutouts for wires
                    cube([100,10,4],center=true);
                }
                translate([-13,-3,0])mountingOLED();
                translate([16,0,0])encodermount();
            }
            translate([16,0,0])encodercutout();
        }
        
        locksU();
    }
    translate([-13,-3,0])OLEDcutoutSupport();
}

module caseL(){    
    difference(){
        union(){
            difference(){
                union(){
                    case(25,80,45);
                    hull(){
                        translate([0,0,-10.5])cube([66,45,4], center=true);
                        translate([0,0,-8])cube([74.1,45,0.1], center=true);
                    }
                }
                case(22,77,42);
                translate([0,0,-10])cooling();
                translate([0,0,20])cube([100,100,40], center=true);
                // cutouts for wires
                cube([100,10,4],center=true);
            }
        }
    
    }
    locksL();
    
}

module case(diam, len, wide){
    hull(){
        translate([-len/2+diam/2,0,0])rotate([90,0,0])cylinder(d=diam, h=wide, center=true);
        translate([len/2-diam/2,0,0])rotate([90,0,0])cylinder(d=diam, h=wide, center=true);
    }
}


module cutoutscreenOLED(){
    // cutouts for screen
    translate([0,0,9.3])rotate([180,0,180])union(){
        translate([0,2,0])cube([24,13,10], center = true);
        translate([0,0,0.5])cube([28,19.5,6.5], center = true);
        translate([0,0,1.7])cube([28,28,6.5], center = true);
        translate([0,11,1])cube([17.5,5,6.5], center = true);
    }
}

module mountingOLED(){
translate([0,0,9.3])rotate([180,0,180]){
    translate([11.75,11.75,-0.75]){
    difference(){
        translate([0,5.5,0])cube([6,15,2], center = true);
        cylinder(h=6, d=1, $fn=20, center = true);
    }}
    
translate([-11.75,11.75,-0.75]){
    difference(){
        translate([0,5.5,0])cube([6,15,2], center = true);
        cylinder(h=6, d=1, $fn=20, center = true);
    }}
    
translate([11.75,-11.75,-0.75]){
    difference(){
        translate([0,-2.5,0])cube([6,9,2], center = true);
        cylinder(h=6, d=1, $fn=20, center = true);
    }
    translate([2.75,15,0])cube([1,43,2], center = true);}
    
translate([-11.75,-11.75,-0.75]){
    difference(){
        translate([0,-2.5,0])cube([6,9,2], center = true);
        cylinder(h=6, d=1, $fn=20, center = true);
    }
    translate([-2.75,15,0])cube([1,43,2], center = true);}
}
}


module encodermount(){
    difference(){
        union(){
            translate([0,0,1])cube([15,20,2], center=true);
            translate([0,0,11])cube([15,20,2], center=true);
            translate([0,11,6])cube([15,2,12], center=true);
            translate([0,-11,6])cube([15,2,12], center=true);
        }
        cylinder(d=7.5,h=5, $fn=30, center = true);
        translate([0,6.5,0])cube([2.5,1,6], center=true);
    }
    hull(){
        translate([0,-8,10.5])cube([15,6,1], center=true);
        translate([0,-11,6])cube([15,2,1], center=true);
    }
    hull(){
        translate([0,8,10.5])cube([15,6,1], center=true);
        translate([0,11,6])cube([15,2,1], center=true);
    }
    
    
}

module encodercutout(){
    hull(){
        translate([0,0,11.6])cylinder(d=8, h=1, center=true);   
        translate([0,0,9.6])cube([10,10,1], center=true);
    }
    translate([0,0,15])cylinder(d=8, h=10, center=true);
}


module OLEDcutoutSupport(){
    h=9.05-0.2; //9.05 - 0.2mm distance
    difference(){
        translate([-13.5,-13,0])cube([27,26,h]);
        translate([-13,-12.5,-0.4])cube([26,25,h]);
        translate([-8,-12.5,0.1])cube([16,25,h]);
    }
    difference(){
        translate([-13.5,-5.5,h])cube([27,15,3]);
        translate([-13,-5,h-0.4])cube([26,14,3]);
        translate([-12,-3,h+0.1])cube([24,10,3]);
    }
}

module locksL(){
    translate([23,20,0])lock1();
    translate([-23,20,0])lock1();
    translate([23,-20,0])rotate([0,0,180])lock1();
    translate([-23,-20,0])rotate([0,0,180])lock1();
    
    translate([0,20.7,-0.5])cube([30,0.6,3],center=true);
    translate([0,-20.7,-0.5])cube([30,0.6,3],center=true);

    translate([38.2,14,-0.5])cube([0.6,12,3],center=true);
    translate([38.2,-14,-0.5])cube([0.6,12,3],center=true);
    translate([-38.2,14,-0.5])cube([0.6,12,3],center=true);
    translate([-38.2,-14,-0.5])cube([0.6,12,3],center=true);

}

module locksU(){
    translate([23,20,0])translate([0,1,2])rotate([0,90,0])cylinder(d=1.2,h=6,$fn=20, center=true);
    translate([-23,20,0])translate([0,1,2])rotate([0,90,0])cylinder(d=1.2,h=6,$fn=20, center=true);
    translate([23,-20,0])rotate([0,0,180])translate([0,1,2])rotate([0,90,0])cylinder(d=1.2,h=6,$fn=20, center=true);
    translate([-23,-20,0])rotate([0,0,180])translate([0,1,2])rotate([0,90,0])cylinder(d=1.2,h=6,$fn=20, center=true);

}

module lock1(){
    difference(){
        cube([5,2,6],center=true);
        translate([0,-2,-7])rotate([45,0,0])cube([10,10,10], center=true);
    }
    translate([0,1,2])rotate([0,90,0])cylinder(d=1,h=5,$fn=20, center=true);
}

module cooling(){
    for(i=[-20:20:20])
    translate([i,0,0])cube([8,46,1], center=true);
}