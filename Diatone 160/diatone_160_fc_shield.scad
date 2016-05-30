$fn=100;

stl_height = 5;
desired_height = 15;
roof_thickness = 3;

module model() {
    scale([1, 1, desired_height / stl_height]) {
        translate([98, -100, 0]) {
            import("ET160_5mm_Spacer.stl", convexity=3);
        }
    }
}

module esc_hole_1() {
    translate([-23, -20, 0]) {
        rotate([90, 0, 130]) {
            cylinder(r = 3, h = 10);
        }
    }
}

module esc_hole_2() {
    translate([-27, 34, 0]) {
        rotate([90, 0, 73]) {
            cylinder(r = 3, h = 10);
        }
    }
}

module antenna_holes() {
    translate([8, 60, 0]) {
        cube([2, 3, 20]);
    }
    
    translate([5, 60, 0]) {
        cube([2, 3, 20]);
    }
}

module power_hole() {
    translate([0, -22, 0]) {
        rotate([90, 0, 0]) {
            cylinder(r = 3, h = 10);
        }
    }
}

module holes() {
    esc_hole_1();
    esc_hole_2();
    antenna_holes();

    mirror([-1, 0, 0]) {
        esc_hole_1();
        esc_hole_2();
        antenna_holes();
    }
    
    power_hole();
}

module roof_half() {
    translate([0, 0, desired_height - roof_thickness]) {
        linear_extrude(height = roof_thickness) {
            polygon(points=
    [[0,-25], [-10,-25], [-22,-11], [-21.5,23], [-11,66], [0,66], [0,0]]
            );
        }
    }
}

module roof() {
    roof_half();
    
    mirror([-1, 0, 0]) {
        roof_half();
    }
}

module model_and_roof() {
    model();
    roof();
}

module main() {
    difference() {
        model_and_roof();
        
        holes();
    }
}

main();

//holes();
