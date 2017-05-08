$fn=50;

caseU();

module caseU(){    
    difference(){
        case(25,80,45);
        case(22,77,42);
        translate([0,0,-20])cube([100,100,40], center=true);
        translate([-14,-3,0])cutoutscreenOLED(); // leave 0.3mm wall
    }
    translate([-14,-3,0])mountingOLED();   
}

module case(diam, len, wide){
    hull(){
        translate([-len/2+diam/2,0,0])rotate([90,0,0])cylinder(d=diam, h=wide, center=true);
        translate([len/2-diam/2,0,0])rotate([90,0,0])cylinder(d=diam, h=wide, center=true);
    }
}


module cutoutscreenOLED(){
    // cutouts for screen
    translate([0,0,9.4])rotate([180,0,180])union(){
        translate([0,2,0]) cube([24,13,10], center = true);
        translate([0,0,0.5])
            cube([28,18,6.5], center = true);
        translate([0,0,1.7])
            cube([28,28,6.5], center = true);
        translate([0,11,1])
            cube([11,5,6.5], center = true);
    }
}

module mountingOLED(){
translate([0,0,9.4])rotate([180,0,180]){
    translate([11.75,11.75,-0.75]){
    difference(){
    translate([0,1,0]){cube([6,6,2], center = true);}
    cylinder(h=6, d=1, $fn=20, center = true);
    }}
    
translate([-11.75,11.75,-0.75]){
    difference(){
    translate([0,1,0]){cube([6,6,2], center = true);}
    cylinder(h=6, d=1, $fn=20, center = true);
    }}
    
translate([11.75,-11.75,-0.75]){
    difference(){
    translate([0,-1,0]){cube([6,6,2], center = true);}
    cylinder(h=6, d=1, $fn=20, center = true);
    }}
    
translate([-11.75,-11.75,-0.75]){
    difference(){
    translate([0,-1,0]){cube([6,6,2], center = true);}
    cylinder(h=6, d=1, $fn=20, center = true);
    }}
}
}
