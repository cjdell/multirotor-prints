$fn = 100;

diff_over = 1.0;

pillar_diameter = 5.0;
pillar_radius = pillar_diameter * 0.5;
pillar_height = 40.0;

pillar_pole_gap = 0.3;

pole_hole_radius = pillar_radius + pillar_pole_gap;
pole_hole_diameter = pole_hole_radius * 2;

thickness = 2.0;

row_1_spacing = 29.5;

// diag 78.6
row_1_2_spacing = 77.4;

row_2_spacing = 56.0;

// diag 50.0
row_2_3_spacing = 49.8;

row_3_spacing = 65.0;

// diag 55.0
row_3_4_spacing = 52.0;

row_4_spacing = 32.5;
 
biggest_row_spacing = row_3_spacing;
row_1_4_spacing = row_1_2_spacing + row_2_3_spacing + row_3_4_spacing;

battery_dimensions = [36, 117, 35]; // WLH - Turnigy nano-tech 2200mah 4S 35~70C
battery_width = battery_dimensions[0];
battery_length = battery_dimensions[1];

pillar_positions = [
    [(biggest_row_spacing - row_1_spacing) * 0.5, 0],
    [(biggest_row_spacing - row_1_spacing) * 0.5 + row_1_spacing, 0],
    [(biggest_row_spacing - row_2_spacing) * 0.5, row_1_2_spacing],
    [(biggest_row_spacing - row_2_spacing) * 0.5 + row_2_spacing, row_1_2_spacing],
    [(biggest_row_spacing - row_3_spacing) * 0.5, row_1_2_spacing + row_2_3_spacing],
    [(biggest_row_spacing - row_3_spacing) * 0.5 + row_3_spacing, row_1_2_spacing + row_2_3_spacing],
    [(biggest_row_spacing - row_4_spacing) * 0.5, row_1_2_spacing + row_2_3_spacing + row_3_4_spacing],
    [(biggest_row_spacing - row_4_spacing) * 0.5 + row_4_spacing, row_1_2_spacing + row_2_3_spacing + row_3_4_spacing]
];

// Over extends so that diffs work properly
module diff_cylinder(h, r) {
    translate([0, 0, -diff_over]) {
        cylinder(h = h + diff_over * 2, r = r);
    }
}

// Same as cube but takes position argument
module pcube(position, size, center) {
    translate(position) {
        cube(size = size, center = center);
    }
}

module pillar(x, y) {
    translate([x, y, 0]) {
        cylinder(h = pillar_height, r = pillar_radius);
    }
}

module pillars() {
    for (pillar_position = pillar_positions) {
        pillar(pillar_position[0], pillar_position[1]);
    }
}

module battery() {
    translate([(biggest_row_spacing - battery_width) * 0.5, (row_1_4_spacing - battery_length) * 0.5, 0]) {
        cube(battery_dimensions);
    }
}

module pole(position, h) {
    translate(position) {
        difference() {
            cylinder(h = h, r = pole_hole_radius + thickness);
            diff_cylinder(h = h, r = pole_hole_radius);
        }
    }
}

module side_wall() {
    pole_1 = [(biggest_row_spacing - row_2_spacing) * 0.5, row_1_2_spacing, 0];
    
    pole_2 = [(biggest_row_spacing - row_3_spacing) * 0.5, row_1_2_spacing + row_2_3_spacing, 0];

    pole(position = pole_1, h = pillar_height * 0.5);
    
    // Wall between poles
    pcube(pole_1 + [pole_hole_radius, 0, 0], size=[thickness, row_2_3_spacing + thickness * 0.5, pillar_height * 0.5]);    

    pole(position = pole_2, h = pillar_height * 0.5);
    
    // Connection to pole 2
    pcube(position = pole_2 + [pole_hole_radius, -thickness * 0.5, 0], size = [pole_1[0] - pole_2[0] + thickness, thickness, pillar_height * 0.5]);
}

// Starboard wall
side_wall();

// Port wall
translate([biggest_row_spacing, 0, 0]) {
    mirror([1, 0, 0]) {
        side_wall();
    }
}

// Visual aids
pillars();
battery();
